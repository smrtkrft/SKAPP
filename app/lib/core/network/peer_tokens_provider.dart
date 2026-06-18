// Desktop-side store of per-peer authentication tokens. Faz B step 3
// replaces "every paired SKAPP shares the install bearer" with one
// random secret per paired peer, so revoking a single phone doesn't
// require rotating the bearer and kicking every other paired device.
//
// Storage:
//   - Index (peer UUID → metadata) lives in SharedPreferences (cheap,
//     synchronous).
//   - The token itself lives in `flutter_secure_storage` under a
//     stable key per peer (`peer_token.<uuid>`). Token never sits in
//     plaintext anywhere on disk.
//
// Bootstrap order matches `bearerTokenBootstrapProvider`: `main()`
// pre-reads tokens into a `Map<uuid, token>` and exposes them via the
// `peerTokenBootstrapProvider` override so the notifier's synchronous
// `build()` has them on hand.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/paired_devices_store.dart';
import '../storage/preferences_provider.dart';

/// One paired peer, indexed by `peerUuid`. Token is intentionally NOT
/// part of this struct — it lives in secure storage and is fetched
/// through the notifier so plaintext copies don't leak into SharedPrefs
/// JSON or logs.
class PeerTokenEntry {
  const PeerTokenEntry({
    required this.peerUuid,
    required this.name,
    required this.issuedAt,
    this.lastUsedAt,
  });

  final String peerUuid;
  final String name;
  final DateTime issuedAt;
  final DateTime? lastUsedAt;

  PeerTokenEntry copyWith({String? name, DateTime? lastUsedAt}) =>
      PeerTokenEntry(
        peerUuid: peerUuid,
        name: name ?? this.name,
        issuedAt: issuedAt,
        lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      );

  Map<String, Object?> toJson() => {
        'peerUuid': peerUuid,
        'name': name,
        'issuedAt': issuedAt.toIso8601String(),
        'lastUsedAt': lastUsedAt?.toIso8601String(),
      };

  factory PeerTokenEntry.fromJson(Map<String, dynamic> j) => PeerTokenEntry(
        peerUuid: j['peerUuid'] as String,
        name: j['name'] as String,
        issuedAt: DateTime.parse(j['issuedAt'] as String),
        lastUsedAt: j['lastUsedAt'] == null
            ? null
            : DateTime.parse(j['lastUsedAt'] as String),
      );
}

const _kPeerTokenIndexKey = 'peer_token_index_v1';
String _secureKeyFor(String peerUuid) => 'peer_token.$peerUuid';

/// Bootstrap-only map of secure-storage-resolved tokens, keyed by peer
/// UUID. `main()` pre-reads these synchronously into the Notifier so
/// `tokenFor` can serve lookups without `await`-ing. Override at app
/// boot via `ProviderScope`; default throws so tests notice missing
/// setup loudly.
final peerTokenBootstrapProvider = Provider<Map<String, String>>(
  (_) => throw UnimplementedError(
    'peerTokenBootstrapProvider must be overridden at app boot',
  ),
);

class PeerTokensNotifier extends Notifier<List<PeerTokenEntry>> {
  static const _storage = FlutterSecureStorage();

  /// In-memory mirror of secure storage. Populated from the bootstrap
  /// provider on first build and kept in sync with every issue/revoke
  /// so HMAC verification stays synchronous (no `await` inside the
  /// request hot path).
  final Map<String, String> _tokensByUuid = {};

  @override
  List<PeerTokenEntry> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    _tokensByUuid
      ..clear()
      ..addAll(ref.read(peerTokenBootstrapProvider));
    final raw = prefs.getString(_kPeerTokenIndexKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => PeerTokenEntry.fromJson(
              (e as Map).cast<String, dynamic>()))
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Look up the secret for [peerUuid] from the in-memory mirror.
  /// Returns null if the peer was never issued one or has been revoked
  /// since boot — both map to a 401 `unknown_peer` at the wire layer.
  String? tokenFor(String peerUuid) => _tokensByUuid[peerUuid];

  /// Issue a fresh per-peer token. Generates a 32-byte random secret,
  /// writes it to secure storage, records the metadata in the index,
  /// and returns the token to the caller (only the redeem endpoint
  /// should see this — never logged, never echoed back to other
  /// surfaces).
  Future<String> issue({
    required String peerUuid,
    required String name,
  }) async {
    final token = _generateToken();
    _tokensByUuid[peerUuid] = token;
    try {
      await _storage.write(key: _secureKeyFor(peerUuid), value: token);
    } catch (e) {
      // Secure storage unavailable (Linux without libsecret). Keep the
      // in-memory copy so the redeem still completes this session; the
      // user is warned via the same fallback path the network identity
      // notifier uses.
      debugPrint('[secure-storage] peer token write failed: $e');
    }
    final entry = PeerTokenEntry(
      peerUuid: peerUuid,
      name: name,
      issuedAt: DateTime.now().toUtc(),
    );
    final next = [
      for (final p in state)
        if (p.peerUuid != peerUuid) p,
      entry,
    ];
    state = next;
    await _persistIndex(next);
    return token;
  }

  /// Drop a peer's token from both secure storage and the in-memory
  /// mirror. Subsequent HMAC requests from that peer return 401
  /// `unknown_peer` immediately.
  ///
  /// Cascade: a mobile-peer pairing creates an `MS` PairedDevice in
  /// `pairedDevicesProvider` (Faz 3) so the phone shows up in
  /// Cihazlarım. Revoking the token without removing that synthetic
  /// device leaves an orphan tile that can't be triggered (auth
  /// fails). We delete the matching MS entry here so the cascade is
  /// atomic. BF / LS bonds use a different store and aren't affected.
  Future<void> revoke(String peerUuid) async {
    _tokensByUuid.remove(peerUuid);
    try {
      await _storage.delete(key: _secureKeyFor(peerUuid));
    } catch (e) {
      debugPrint('[secure-storage] peer token delete failed: $e');
    }
    final next = [
      for (final p in state)
        if (p.peerUuid != peerUuid) p,
    ];
    state = next;
    await _persistIndex(next);
    // Cascade to PairedDevices (MS prefix only — BF/LS pairings are
    // independent of peer-token storage).
    final paired = ref.read(pairedDevicesProvider);
    final hasMsEntry =
        paired.any((d) => d.id == peerUuid && d.prefix == 'MS');
    if (hasMsEntry) {
      await ref.read(pairedDevicesProvider.notifier).remove(peerUuid);
    }
  }

  /// Reset Pairings / Factory Reset için: tüm peer token'lar (hem
  /// in-memory mirror, hem secure storage, hem SharedPreferences index)
  /// silinir. Tek tek revoke'tan farkı: tek atomik wipe.
  ///
  /// PairedDevices store'undaki MS kayıtları da paralel silinir.
  /// BF/LS bond cascade'i ResetService'te ayrıca yönetilir.
  Future<void> revokeAll() async {
    final ids = _tokensByUuid.keys.toList();
    _tokensByUuid.clear();
    for (final id in ids) {
      try {
        await _storage.delete(key: _secureKeyFor(id));
      } catch (e) {
        debugPrint('[secure-storage] peer token bulk delete failed: $e');
      }
    }
    // Index'i tek seferde temizle.
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_kPeerTokenIndexKey);
    state = const [];
    // MS PairedDevice cascade — peer UUID ile yazılan kayıtları
    // tek tek temizle, BF/LS dokunmaz.
    final paired = ref.read(pairedDevicesProvider);
    for (final d in paired) {
      if (d.prefix == 'MS' && ids.contains(d.id)) {
        await ref.read(pairedDevicesProvider.notifier).remove(d.id);
      }
    }
  }

  /// Record that [peerUuid] just made a successful request. Used by the
  /// Settings UI ("last seen" column); not consumed by auth itself.
  Future<void> touch(String peerUuid) async {
    final idx = state.indexWhere((p) => p.peerUuid == peerUuid);
    if (idx == -1) return;
    final next = [...state];
    next[idx] = next[idx].copyWith(lastUsedAt: DateTime.now().toUtc());
    state = next;
    await _persistIndex(next);
  }

  Future<void> _persistIndex(List<PeerTokenEntry> list) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _kPeerTokenIndexKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static String _generateToken() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

final peerTokensProvider =
    NotifierProvider<PeerTokensNotifier, List<PeerTokenEntry>>(
        PeerTokensNotifier.new);

/// Boot-time loader. Reads the peer-token index from SharedPreferences
/// (sync) and resolves each token from secure storage in parallel. The
/// result becomes the override value for `peerTokenBootstrapProvider`.
/// Returns an empty map if secure storage is unavailable; the notifier
/// still functions, it just starts with no known peers (treat as fresh
/// install for the auth path).
Future<Map<String, String>> loadPeerTokensFromSecureStorage({
  required Iterable<String> peerUuids,
}) async {
  const storage = FlutterSecureStorage();
  final out = <String, String>{};
  for (final uuid in peerUuids) {
    try {
      final v = await storage.read(key: _secureKeyFor(uuid));
      if (v != null) out[uuid] = v;
    } catch (e) {
      debugPrint('[secure-storage] bootstrap peer token read failed: $e');
    }
  }
  return out;
}

/// Convenience wrapper for `main()`: derives the UUID list from the
/// persisted index, then resolves each token from secure storage.
/// Returns the map ready to feed into `peerTokenBootstrapProvider`.
Future<Map<String, String>> resolvePeerTokenBootstrap(
  Object prefsLike,
) async {
  // `prefsLike` is typed loosely so we don't drag SharedPreferences into
  // every caller; we use duck-typing via dynamic dispatch on the one
  // method we need.
  final dyn = prefsLike as dynamic;
  final raw = dyn.getString(_kPeerTokenIndexKey) as String?;
  if (raw == null || raw.isEmpty) return const {};
  try {
    final list = jsonDecode(raw) as List<dynamic>;
    final uuids = <String>[
      for (final e in list)
        if ((e as Map)['peerUuid'] is String) e['peerUuid'] as String,
    ];
    return loadPeerTokensFromSecureStorage(peerUuids: uuids);
  } catch (_) {
    return const {};
  }
}
