// In-memory, short-lived handshake tokens used by the Faz B v:2 pairing
// flow. Desktop mints a token whenever the user opens the pairing QR
// sheet; mobile redeems it once via `POST /api/pair/redeem` to obtain a
// per-peer token. If the QR is photographed, screencast'ed, or
// shoulder-surfed, the leak window is 60 s and the token is single-use.
//
// Why in-memory: the value is intentionally ephemeral. Persisting it
// would mean a forgotten QR sheet from yesterday still produces valid
// tokens — exactly the leak we're closing.

import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One live handshake. `redeemed` flips to true on first successful
/// redeem so a captured QR cannot be replayed against the same handle
/// during its TTL — second attempt sees the same record and rejects.
class PairingHandshake {
  PairingHandshake({
    required this.token,
    required this.issuedAt,
    required this.expiresAt,
  });

  final String token;
  final DateTime issuedAt;
  final DateTime expiresAt;
  bool redeemed = false;

  bool get expired => DateTime.now().isAfter(expiresAt);
}

class PairingHandshakeNotifier extends Notifier<Map<String, PairingHandshake>> {
  static const Duration ttl = Duration(seconds: 60);

  @override
  Map<String, PairingHandshake> build() => <String, PairingHandshake>{};

  /// Mint a fresh handshake token. Caller stores the returned token
  /// inside the QR payload; the user has [ttl] to scan + redeem.
  PairingHandshake mint() {
    _gc();
    final token = _generate();
    final now = DateTime.now();
    final handshake = PairingHandshake(
      token: token,
      issuedAt: now,
      expiresAt: now.add(ttl),
    );
    state = {...state, token: handshake};
    return handshake;
  }

  /// Drop a handshake the user has abandoned (sheet closed without
  /// scanning). Best-effort; the GC cycle on the next mint would catch
  /// it anyway but explicit drop frees up the slot immediately.
  void cancel(String token) {
    if (!state.containsKey(token)) return;
    final next = Map<String, PairingHandshake>.from(state)..remove(token);
    state = next;
  }

  /// Try to redeem [token]. Returns the handshake on success, or null
  /// if the token is unknown, expired, or already redeemed. The
  /// returned handshake is mutated in place to record consumption so a
  /// later concurrent attempt sees `redeemed == true`.
  PairingHandshake? redeem(String token) {
    _gc();
    final h = state[token];
    if (h == null) return null;
    if (h.expired || h.redeemed) return null;
    h.redeemed = true;
    // Mutating an existing object doesn't notify listeners, but no one
    // listens to this provider for UI today — server reads it once per
    // redeem. If a future listener appears we can `state = {...state}`
    // here to publish.
    return h;
  }

  void _gc() {
    final now = DateTime.now();
    final stale = <String>[];
    for (final entry in state.entries) {
      if (now.isAfter(entry.value.expiresAt) || entry.value.redeemed) {
        stale.add(entry.key);
      }
    }
    if (stale.isEmpty) return;
    final next = Map<String, PairingHandshake>.from(state);
    for (final k in stale) {
      next.remove(k);
    }
    state = next;
  }

  static String _generate() {
    final rng = Random.secure();
    final bytes = List<int>.generate(24, (_) => rng.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

final pairingHandshakeProvider =
    NotifierProvider<PairingHandshakeNotifier, Map<String, PairingHandshake>>(
        PairingHandshakeNotifier.new);
