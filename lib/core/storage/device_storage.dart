import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceStorage {
  static const String _deviceTokenKey = 'device_token';
  static const String _deviceIdKey = 'device_id';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: _deviceTokenKey, value: token);
  }

  Future<String?> getDeviceToken() async {
    return await _storage.read(key: _deviceTokenKey);
  }

  Future<void> saveDeviceId(String id) async {
    await _storage.write(key: _deviceIdKey, value: id);
  }

  Future<String?> getDeviceId() async {
    return await _storage.read(key: _deviceIdKey);
  }

  Future<void> clear() async {
    await _storage.delete(key: _deviceTokenKey);
    await _storage.delete(key: _deviceIdKey);
  }
}
