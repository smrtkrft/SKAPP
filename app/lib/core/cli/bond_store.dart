// Persistent storage for the per-device session token derived during ECDH
// pairing, plus per-install identity and bond slot bookkeeping for the
// multi-bond firmware (8 slots per device).
//
// Keys (FlutterSecureStorage):
//   bond.<deviceId>           , 32-byte session token, hex-encoded
//   bond.<deviceId>.peer_id   , 16-byte SKAPP install UUID, hex-encoded
//   bond.<deviceId>.slot      , uint8 (string), the slot index the device
//                                stored this bond into (0..7)
//   app.peer_id               , this SKAPP install's stable peer_id, sent
//                                to every device during ECDH pairing so the
//                                device can address us by slot. Generated
//                                once on first launch and never changed.
//
// The peer_id is install-scoped, not device-scoped, the same SKAPP install
// can pair with multiple devices using the same peer_id. Re-installing the
// app generates a fresh peer_id (existing bonds become orphaned slots from
// the device's POV; user removes them via BfBondListScreen).

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'device_id.dart';

class BondStore {
  BondStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _appPeerIdKey = 'app.peer_id';

  String _key(String deviceId) => 'bond.$deviceId';
  String _peerKey(String deviceId) => 'bond.$deviceId.peer_id';
  String _slotKey(String deviceId) => 'bond.$deviceId.slot';

  Future<Uint8List?> tokenFor(String deviceId) async {
    // Try exact key first, then case-folded variants. Defensive against
    // BF firmware quirks (e.g. mDNS instance name mixed case vs SmartKraft
    // id sk_identity_get() upper case) without forcing all stored keys
    // to a single canonical form.
    final candidates = deviceIdKeyVariants(deviceId);
    for (final id in candidates) {
      final hexStr = await _storage.read(key: _key(id));
      if (hexStr == null || hexStr.isEmpty) continue;
      try {
        return Uint8List.fromList(hex.decode(hexStr));
      } catch (_) {
        // Corrupt entry, wipe so subsequent reads stay deterministic.
        await _storage.delete(key: _key(id));
      }
    }
    return null;
  }

  /// Stores the bond. `peerId` and `slot` are filled when pairing went
  /// through the multi-bond firmware (it returns `slot` in the ECDH /
  /// passphrase-verify response). `peerId` is the local install's id
  /// what we sent to the device, kept here only as a redundancy for
  /// debugging; it is the same as `appPeerId()` for fresh pairings.
  ///
  /// `aliasIds` is an optional list of additional identifiers that point
  /// to the same bond. Critical because the pair flow keys bonds by BLE
  /// MAC (the discovered remote-id), but BF firmware sends webhooks with
  /// `X-SK-Device-Id: <SmartKraft-id>` (e.g. `BF-A06TMFSQT`). Without an
  /// alias the receiver's `tokenFor("BF-A06TMFSQT")` lookup never finds
  /// the bond stored under the MAC and rejects every webhook with
  /// "Device not paired with this SKAPP". Pass the BLE name here so the
  /// same token is reachable under both ids.
  Future<void> save(
    String deviceId,
    Uint8List token, {
    Uint8List? peerId,
    int? slot,
    List<String> aliasIds = const [],
  }) async {
    if (token.length != 32) {
      throw ArgumentError(
          'token must be exactly 32 bytes (got ${token.length})');
    }
    await _storage.write(key: _key(deviceId), value: hex.encode(token));
    if (peerId != null) {
      if (peerId.length != 16) {
        throw ArgumentError(
            'peer_id must be exactly 16 bytes (got ${peerId.length})');
      }
      await _storage.write(key: _peerKey(deviceId), value: hex.encode(peerId));
    }
    if (slot != null) {
      if (slot < 0 || slot > 7) {
        throw ArgumentError('slot must be in 0..7 (got $slot)');
      }
      await _storage.write(key: _slotKey(deviceId), value: slot.toString());
    }
    for (final alias in aliasIds) {
      if (alias.isEmpty || alias == deviceId) continue;
      await _storage.write(key: _key(alias), value: hex.encode(token));
      if (peerId != null) {
        await _storage.write(
            key: _peerKey(alias), value: hex.encode(peerId));
      }
      if (slot != null) {
        await _storage.write(
            key: _slotKey(alias), value: slot.toString());
      }
    }
  }

  Future<void> clear(String deviceId) async {
    await Future.wait([
      _storage.delete(key: _key(deviceId)),
      _storage.delete(key: _peerKey(deviceId)),
      _storage.delete(key: _slotKey(deviceId)),
    ]);
  }

  /// Reset Pairings için: tüm bond.* key'lerini siler. `app.peer_id`
  /// KORUNUR (Reset Pairings install kimliğini koruma kararı). Factory
  /// Reset ayrıca [clearAppPeerId] çağırır.
  Future<int> clearAllBonds() async {
    final all = await _storage.readAll();
    final bondKeys =
        all.keys.where((k) => k.startsWith('bond.')).toList(growable: false);
    if (bondKeys.isEmpty) return 0;
    await Future.wait(bondKeys.map((k) => _storage.delete(key: k)));
    return bondKeys
        .where((k) => !k.endsWith('.peer_id') && !k.endsWith('.slot'))
        .length;
  }

  /// Factory Reset için: install-scoped peer_id'yi de siler. Bir sonraki
  /// pair işleminde yeni peer_id üretilir.
  Future<void> clearAppPeerId() async {
    await _storage.delete(key: _appPeerIdKey);
  }

  Future<List<String>> bondedDeviceIds() async {
    final all = await _storage.readAll();
    return all.keys
        // Only the canonical token key (no `.peer_id` / `.slot` suffix).
        .where((k) => k.startsWith('bond.') &&
            !k.endsWith('.peer_id') &&
            !k.endsWith('.slot'))
        .map((k) => k.substring('bond.'.length))
        .toList();
  }

  Future<bool> hasBond(String deviceId) async {
    final t = await tokenFor(deviceId);
    return t != null;
  }

  /// Slot index the device stored this bond into, or null if unknown
  /// (legacy bond paired before multi-slot firmware).
  Future<int?> slotFor(String deviceId) async {
    final s = await _storage.read(key: _slotKey(deviceId));
    if (s == null) return null;
    return int.tryParse(s);
  }

  /// Per-device peer_id we sent during pairing. Usually equals
  /// `appPeerId()`, diverges only if the user reinstalled SKAPP between
  /// pairings.
  Future<Uint8List?> peerIdFor(String deviceId) async {
    final hexStr = await _storage.read(key: _peerKey(deviceId));
    if (hexStr == null || hexStr.isEmpty) return null;
    try {
      return Uint8List.fromList(hex.decode(hexStr));
    } catch (_) {
      await _storage.delete(key: _peerKey(deviceId));
      return null;
    }
  }

  /// Returns this SKAPP install's stable peer_id (16 bytes). Generated and
  /// stored on first call; subsequent calls return the same value until
  /// the app is reinstalled or secure storage is wiped.
  Future<Uint8List> appPeerId() async {
    final cached = await _storage.read(key: _appPeerIdKey);
    if (cached != null && cached.isNotEmpty) {
      try {
        final bytes = hex.decode(cached);
        if (bytes.length == 16) return Uint8List.fromList(bytes);
      } catch (_) {
        // fall through and regenerate
      }
    }
    final fresh = _generatePeerId();
    await _storage.write(key: _appPeerIdKey, value: hex.encode(fresh));
    return fresh;
  }

  static Uint8List _generatePeerId() {
    // 16 bytes of cryptographic randomness, same shape the firmware
    // expects (peer_id[16]). Random.secure() taps the platform CSPRNG.
    final rng = Random.secure();
    final bytes = Uint8List(16);
    for (var i = 0; i < 16; i++) {
      bytes[i] = rng.nextInt(256);
    }
    return bytes;
  }
}

/// Riverpod handle. The store is cheap to construct (no I/O until first
/// call) so a singleton is fine.
final bondStoreProvider = Provider<BondStore>((ref) => BondStore());

/// Helper: never store the token as plain bytes anywhere user code can
/// hold onto. We only expose it for the duration of a transport's lifetime.
Future<Uint8List?> readBondToken(BondStore store, String deviceId) =>
    store.tokenFor(deviceId);

/// Helper: shape conversion utility used by handshake code.
Uint8List utf8Bytes(String s) => Uint8List.fromList(utf8.encode(s));
