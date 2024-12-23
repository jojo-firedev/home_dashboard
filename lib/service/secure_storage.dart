import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> storeToken(String key, String value) async {
    print('Storing $key: $value');
    await _storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }
}
