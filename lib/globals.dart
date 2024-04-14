import 'package:home_dashboard/service/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Globals {
  static SecureStorage secureStorage = SecureStorage();
  static WebSocketChannel? channel;
}
