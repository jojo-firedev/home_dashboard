import 'dart:async';
import 'dart:convert';
import 'package:home_dashboard/globals.dart';
import 'package:web_socket_channel/io.dart';

class HomeAssistantAPI {
  // WebSocketChannel? _channel;
  IOWebSocketChannel? _channel;
  String _url = '';
  String _accessToken = '';

  Future<bool> connectTest() async {
    try {
      String url = await Globals.secureStorage.getToken('ha_host') ?? '';
      _url = 'ws://$url/api/websocket';
      _accessToken =
          await Globals.secureStorage.getToken('ha_access_token') ?? '';

      _channel = IOWebSocketChannel.connect(Uri.parse(_url));

      // Authentifizierung bei der Verbindung
      _channel?.sink.add(jsonEncode({
        'type': 'auth',
        'access_token': _accessToken,
      }));

      // Auf eine Antwort warten
      final completer = Completer<bool>();
      _channel?.stream.listen((message) {
        var response = jsonDecode(message);
        if (response['type'] == 'auth_ok') {
          completer.complete(true);
        } else if (response['type'] == 'auth_invalid') {
          completer.complete(false);
        }
      });

      return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
        return false; // Timeout, keine Antwort erhalten
      });
    } catch (e) {
      print('Error connecting to Home Assistant: $e');
      return false;
    }
  }

  Future<void> connect() async {
    String url = await Globals.secureStorage.getToken('ha_host') ?? '';
    _url = 'ws://$url/api/websocket';
    _accessToken =
        await Globals.secureStorage.getToken('ha_access_token') ?? '';

    _channel = IOWebSocketChannel.connect(Uri.parse(_url));
    _channel!.sink.add(jsonEncode({
      'type': 'auth',
      'access_token': _accessToken,
    }));
    _channel!.stream.listen(_handleMessage);
  }

  void subscribeToEntity(String entityId, Function(String) callback) {
    _channel!.sink.add(jsonEncode({
      'id': 1, // Unique ID for the subscription
      'type': 'subscribe_events',
      'event_type': 'state_changed',
      // 'entity_id': entityId
    }));

    // Handling of incoming messages should call back with the new state
    _entityUpdateCallbacks[entityId] = callback;
  }

  Map<String, Function(String)> _entityUpdateCallbacks = {};

  void _handleMessage(dynamic message) {
    var data = jsonDecode(message);
    print(data);
    if (data['type'] == 'event' &&
        data['event']['event_type'] == 'state_changed') {
      var entityId = data['event']['data']['entity_id'];
      if (_entityUpdateCallbacks.containsKey(entityId)) {
        var newState = data['event']['data']['new_state']['state'];
        _entityUpdateCallbacks[entityId]!(newState);
      }
    }
  }

  void sendCommand(String entityId, String service) {
    var command = {
      'id': 1, // Increment for each command or use a unique identifier
      'type': 'call_service',
      'domain': 'light',
      'service': service,
      'service_data': {'entity_id': entityId},
    };
    _channel?.sink.add(jsonEncode(command));
  }

  void dispose() {
    _channel?.sink.close();
  }
}
