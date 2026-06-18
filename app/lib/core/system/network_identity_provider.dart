// Network identity that this SKAPP installation will broadcast on the LAN
// once the HTTP listener (Phase 2) comes online.
//
// What lives here in Phase 1:
//   - A real, persisted UUID (RFC 4122 v4) for the host
//   - A real, persisted Bearer token (32 random bytes, base64url)
//   - A user-editable mDNS instance name (default seeded from hostname)
//   - The configured listener port (default 5000)
//
// What does NOT live here yet (per the no-fake-data rule):
//   - The HTTP server itself (Phase 2)
//   - mDNS announce of `_skapp._tcp.local` for this SKAPP (Phase 2, only
//     announce when there's a real server backing the announcement)
//
// The Settings → Bağlantı → "Ağ kimliği" card reads from
// [networkIdentityProvider] and surfaces the values plus a clear warning
// that the listener is not running yet.

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/preferences_provider.dart';

/// Secure storage key the bearer token lives under. Bumped from the
/// legacy SharedPreferences `network_identity_v1.bearerToken` JSON field
/// in Phase A — value migrates once on first launch after upgrade and the
/// old field is stripped from disk so the token never sits in plaintext.
const bearerTokenSecureKey = 'network_identity.bearer_token_v1';

/// Boot-time-resolved bearer token from secure storage. Overridden by
/// `main()` at app start using `ProviderScope`; never null inside the
/// running app graph. Null override value means "no token in secure
/// storage yet" — the notifier then attempts a SharedPreferences
/// migration before generating a fresh token. The default body throws so
/// a missing override surfaces as a clear error in tests rather than
/// silently using a null token.
final bearerTokenBootstrapProvider = Provider<String?>(
  (_) => throw UnimplementedError(
    'bearerTokenBootstrapProvider must be overridden at app boot',
  ),
);

class NetworkIdentity {
  const NetworkIdentity({
    required this.uuid,
    required this.name,
    required this.bearerToken,
    required this.port,
    this.lanVisible = true,
  });

  /// Stable device identity, RFC 4122 v4 hex (with dashes).
  /// Generated once at first launch, never changes thereafter.
  final String uuid;

  /// User-facing mDNS instance name (e.g. `cem-laptop-skapp`). Editable in
  /// Settings; persists across launches. Validated to lowercase + dashes.
  final String name;

  /// 32-byte random secret, base64url-encoded. Sent as Bearer in HTTP
  /// requests once the listener exists. User can regenerate from Settings.
  final String bearerToken;

  /// TCP port the listener will bind to. Default 5000.
  final int port;

  /// When `true` (default), the HTTP listener binds to `0.0.0.0` so paired
  /// peers on the LAN (BF webhooks, mobile SKAPP) can reach it. When
  /// `false`, the listener binds to `127.0.0.1` only — BF cannot post
  /// webhooks. Settings exposes the toggle inside Developer mode; outside Pro
  /// mode the toggle is hidden and `SkappListenerService.watchProMode`
  /// auto-restores `true` so disabling Developer mode never leaves the user
  /// stranded with a silently dead BF chain.
  final bool lanVisible;

  static const int defaultPort = 5000;

  NetworkIdentity copyWith({
    String? uuid,
    String? name,
    String? bearerToken,
    int? port,
    bool? lanVisible,
  }) =>
      NetworkIdentity(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        bearerToken: bearerToken ?? this.bearerToken,
        port: port ?? this.port,
        lanVisible: lanVisible ?? this.lanVisible,
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'bearerToken': bearerToken,
        'port': port,
        'lanVisible': lanVisible,
      };

  factory NetworkIdentity.fromJson(Map<String, dynamic> j) => NetworkIdentity(
        uuid: j['uuid'] as String,
        name: j['name'] as String,
        bearerToken: j['bearerToken'] as String,
        port: (j['port'] as num?)?.toInt() ?? defaultPort,
        lanVisible: j['lanVisible'] as bool? ?? true,
      );
}

const _prefsKey = 'network_identity_v1';

class NetworkIdentityNotifier extends Notifier<NetworkIdentity> {
  /// Reusable secure storage handle. `FlutterSecureStorage` is stateless
  /// so a single const instance per notifier is safe and avoids
  /// re-initializing the platform channel on every write.
  static const _storage = FlutterSecureStorage();

  @override
  NetworkIdentity build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_prefsKey);
    final bootstrapToken = ref.read(bearerTokenBootstrapProvider);

    if (raw != null && raw.isNotEmpty) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        // Legacy installs stored the bearer token in this same JSON; new
        // installs leave the field absent. Either way we resolve the
        // token from secure storage first, then fall back to the legacy
        // SharedPreferences slot, and migrate to secure storage if that
        // fallback fired so the next launch reads the canonical source.
        final legacyToken = json['bearerToken'] as String?;
        final resolvedToken =
            bootstrapToken ?? legacyToken ?? _generateToken();

        final identity = NetworkIdentity(
          uuid: json['uuid'] as String,
          name: json['name'] as String,
          bearerToken: resolvedToken,
          port: (json['port'] as num?)?.toInt() ?? NetworkIdentity.defaultPort,
          lanVisible: json['lanVisible'] as bool? ?? true,
        );

        if (bootstrapToken == null) {
          // Secure storage didn't have the token at boot: either we just
          // migrated up from a legacy install (legacyToken != null) or
          // the secure storage entry was wiped (legacyToken == null,
          // fresh token generated above). Either way, write the token
          // back to secure storage and strip it from SharedPreferences.
          unawaited(_persist(identity));
        }
        return identity;
      } catch (_) {
        // Malformed or schema drift, fall through to fresh generation.
      }
    }
    // First launch (or corrupt persistence): generate, persist, return.
    final fresh = _generateFresh();
    unawaited(_persist(fresh));
    return fresh;
  }

  /// User picks a new mDNS instance name. Trims, lowercases, replaces
  /// whitespace with dashes; rejects empty results so the UI keeps the
  /// previous name on garbage input.
  Future<void> setName(String input) async {
    final cleaned = _normalizeName(input);
    if (cleaned.isEmpty || cleaned == state.name) return;
    final next = state.copyWith(name: cleaned);
    await _persist(next);
    state = next;
  }

  Future<void> setPort(int port) async {
    if (port <= 0 || port > 65535 || port == state.port) return;
    final next = state.copyWith(port: port);
    await _persist(next);
    state = next;
  }

  /// Toggle LAN visibility. When `false`, the HTTP listener binds to
  /// loopback only; when `true`, it binds to `0.0.0.0`. The actual
  /// listener restart is driven by `SkappListenerService.watchIdentity`
  /// which fires on lanVisible changes.
  Future<void> setLanVisible(bool visible) async {
    if (visible == state.lanVisible) return;
    final next = state.copyWith(lanVisible: visible);
    await _persist(next);
    state = next;
  }

  /// Replace the bearer token with a fresh 32-byte random secret. UUID is
  /// intentionally NOT regeneratable from the UI, rotating it would orphan
  /// every paired device's "expected target" record.
  Future<void> regenerateToken() async {
    final next = state.copyWith(bearerToken: _generateToken());
    await _persist(next);
    state = next;
  }

  /// Factory Reset için: identity'yi tamamen sıfırlayıp default değerlerle
  /// yeniden üretir (yeni UUID, yeni token, hostname'den isim, port 5000,
  /// lanVisible true). regenerateToken'dan farkı UUID dahil HER ŞEY yenilenir.
  /// Reset Pairings çağrılmaz; Factory Reset cascade'in bir adımı.
  Future<void> resetToDefaults() async {
    final fresh = _generateFresh();
    await _persist(fresh);
    state = fresh;
  }

  Future<void> _persist(NetworkIdentity id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    // Strip the bearer token from the SharedPreferences blob — it lives
    // in secure storage now. Legacy installs that still had it in the
    // JSON get cleaned on first save through this path. Other fields
    // (uuid/name/port/lanVisible) stay where they were so unrelated
    // consumers (settings UI, mDNS announcer) keep working unchanged.
    final json = id.toJson()..remove('bearerToken');
    await prefs.setString(_prefsKey, jsonEncode(json));
    try {
      await _storage.write(
        key: bearerTokenSecureKey,
        value: id.bearerToken,
      );
    } catch (e) {
      // Linux without libsecret, Android Keystore unavailable, or a
      // platform channel hiccup — the token already lives in `state`
      // for this session so we don't fail the operation. Next launch
      // falls back to whatever was last successfully persisted; in the
      // worst case the user regenerates the token from Settings.
      debugPrint('[secure-storage] bearer token write failed: $e');
    }
  }
}

NetworkIdentity _generateFresh() {
  final uuid = _generateUuidV4();
  return NetworkIdentity(
    uuid: uuid,
    name: _defaultName(uuid),
    bearerToken: _generateToken(),
    port: NetworkIdentity.defaultPort,
  );
}

/// Pull a sensible default mDNS name from the host. Falls back to a
/// uuid-derived stub when the platform doesn't expose a hostname (mobile,
/// some CI environments) so the value is always non-empty and unique-ish.
String _defaultName(String uuid) {
  String? host;
  if (!kIsWeb) {
    try {
      host = Platform.localHostname;
    } catch (_) {
      host = null;
    }
  }
  final cleaned = host == null ? '' : _normalizeName(host);
  if (cleaned.isNotEmpty) return '$cleaned-skapp';
  return 'skapp-${uuid.replaceAll('-', '').substring(0, 8)}';
}

/// Lowercase, replace whitespace with dashes, drop characters that aren't
/// safe in DNS labels. Limit to 32 chars (mDNS instance names go up to 63
/// but shorter is friendlier in UIs).
String _normalizeName(String input) {
  final trimmed = input.trim().toLowerCase();
  final dashed = trimmed.replaceAll(RegExp(r'\s+'), '-');
  final filtered = dashed.replaceAll(RegExp(r'[^a-z0-9\-]'), '');
  // Collapse repeated dashes; trim leading/trailing dashes.
  final collapsed = filtered.replaceAll(RegExp(r'-+'), '-');
  final stripped = collapsed.replaceAll(RegExp(r'^-+|-+$'), '');
  return stripped.length > 32 ? stripped.substring(0, 32) : stripped;
}

/// RFC 4122 version 4 UUID using a cryptographically secure RNG.
/// Hand-rolled to avoid pulling in the `uuid` package for ~12 lines of code.
String _generateUuidV4() {
  final r = Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1 (RFC 4122)
  String hex(int i) => bytes[i].toRadixString(16).padLeft(2, '0');
  final h = List.generate(16, hex).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}'
      '-${h.substring(16, 20)}-${h.substring(20)}';
}

/// 32-byte secure random secret, base64url without padding.
String _generateToken() {
  final r = Random.secure();
  final bytes = List<int>.generate(32, (_) => r.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

final networkIdentityProvider =
    NotifierProvider<NetworkIdentityNotifier, NetworkIdentity>(
        NetworkIdentityNotifier.new);
