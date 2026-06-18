// Persisted session tokens, one per paired device. Uses
// flutter_secure_storage which maps to Keychain / Keystore / DPAPI.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:convert/convert.dart';

class TokenStore {
  TokenStore._();
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Persist a 32-byte session token for [deviceId].
  static Future<void> save(String deviceId, List<int> token) async {
    if (token.length != 32) {
      throw ArgumentError('token must be 32 bytes, got ${token.length}');
    }
    await _storage.write(key: 'sk_token_$deviceId', value: hex.encode(token));
  }

  static Future<List<int>?> load(String deviceId) async {
    final v = await _storage.read(key: 'sk_token_$deviceId');
    if (v == null) return null;
    return hex.decode(v);
  }

  static Future<void> clear(String deviceId) async {
    await _storage.delete(key: 'sk_token_$deviceId');
  }

  /// Per-device last known IP address so we can prefer TCP over BLE when
  /// the WiFi route is alive.
  static Future<void> saveLastIp(String deviceId, String ip) async {
    await _storage.write(key: 'sk_ip_$deviceId', value: ip);
  }

  static Future<String?> loadLastIp(String deviceId) async {
    return _storage.read(key: 'sk_ip_$deviceId');
  }
}
