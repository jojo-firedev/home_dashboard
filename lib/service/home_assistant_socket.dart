import 'dart:async';
import 'dart:convert';
import 'package:home_dashboard/globals.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantAPI {
  String _url = '';
  String _accessToken = '';

  Future<bool> connect() async {
    try {
      String url = await Globals.secureStorage.getToken('ha_host') ?? '';
      _url = 'ws://$url/api/websocket';
      _accessToken =
          await Globals.secureStorage.getToken('ha_access_token') ?? '';

      Globals.channel = WebSocketChannel.connect(Uri.parse(_url));

      // Authentifizierung bei der Verbindung
      Globals.channel?.sink.add(jsonEncode({
        'type': 'auth',
        'access_token': _accessToken,
      }));

      // Auf eine Antwort warten
      final completer = Completer<bool>();
      Globals.channel?.stream.listen((message) {
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

  void sendCommand(String entityId, String service) {
    var command = {
      'id': 1, // Increment for each command or use a unique identifier
      'type': 'call_service',
      'domain': 'light',
      'service': service,
      'service_data': {'entity_id': entityId},
    };
    Globals.channel?.sink.add(jsonEncode(command));
  }

  void dispose() {
    Globals.channel?.sink.close();
  }
}
