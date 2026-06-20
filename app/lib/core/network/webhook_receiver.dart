// Bond-signed webhook receiver for the SKAPP HTTP listener.
//
// BF firmware (sk_api SYSTEM kind) fires HTTP requests to
// `POST /api/events/incoming` carrying these headers:
//
//   X-SK-Device-Id   BF-A06TMFSQT  (the BF's mDNS / hardware id)
//   X-SK-Peer-Id     <32 hex>      (this SKAPP install's peer_id)
//   X-SK-Timestamp   <unix sec>    (replay window anchor)
//   X-SK-Nonce       <32 hex>      (16 random bytes, hex)
//   X-SK-Signature   <32 hex>      (HMAC-SHA256(bond_token, body || \n
//                                   || ts || \n || nonce_hex)[:16])
//
// This module verifies the signature using the bond token stored locally
// for X-SK-Device-Id (via BondStore), enforces a ±60s timestamp window
// and a small in-memory nonce dedup ring for replay protection, then
// returns the parsed body to the caller for routing.
//
// On any failure the request is rejected with HTTP 401/400. The
// listener's bearer-auth middleware is bypassed for this route via a
// header-based opt-out (`X-SK-Webhook: 1`) handled by the caller, since
// SYSTEM-kind webhooks authenticate via the bond signature, not the
// SKAPP install's NetworkIdentity.bearerToken.

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto_pkg;

import '../cli/bond_store.dart';
import '../cli/device_id.dart';

class WebhookVerificationResult {
  WebhookVerificationResult.ok({
    required this.deviceId,
    required this.body,
  })  : ok = true,
        statusCode = 200,
        message = null;

  WebhookVerificationResult.fail({
    required this.statusCode,
    required this.message,
  })  : ok = false,
        deviceId = null,
        body = null;

  final bool ok;
  final int statusCode;
  final String? message;
  final String? deviceId;
  final Map<String, Object?>? body;
}

class WebhookReceiver {
  WebhookReceiver({required BondStore bondStore})
      : _bondStore = bondStore;

  final BondStore _bondStore;

  /// Replay protection — dedups (deviceId, nonce) tuples seen in the last
  /// few minutes. Ring size 256 is generous: even at 1 webhook/second the
  /// 60-second timestamp window only allows ~60 entries inside the
  /// acceptable region, so 256 keeps a comfortable safety margin without
  /// growing without bound.
  static const int _nonceRingSize = 256;
  final Queue<String> _nonceRing = Queue<String>();
  final Set<String> _nonceSet = <String>{};

  /// Allowed clock skew between BF and host. BF's clock comes from SNTP
  /// once WiFi is up; before SNTP the timestamp will be near-zero and
  /// requests will fail this window — that's the desired behaviour
  /// (don't run scripts before the device clock is sane).
  static const Duration _maxSkew = Duration(seconds: 60);

  Future<WebhookVerificationResult> verify({
    required Map<String, String> headers,
    required String body,
  }) async {
    final deviceId = _header(headers, 'x-sk-device-id');
    final peerIdHex = _header(headers, 'x-sk-peer-id');
    final tsStr = _header(headers, 'x-sk-timestamp');
    final nonceHex = _header(headers, 'x-sk-nonce');
    final sigHex = _header(headers, 'x-sk-signature');

    if (deviceId == null ||
        peerIdHex == null ||
        tsStr == null ||
        nonceHex == null ||
        sigHex == null) {
      return WebhookVerificationResult.fail(
        statusCode: 400,
        message: 'Missing one or more X-SK-* headers',
      );
    }

    // Timestamp window check first (cheap) so an attacker spamming with a
    // wrong key can't probe nonce dedup.
    final ts = int.tryParse(tsStr);
    if (ts == null) {
      return WebhookVerificationResult.fail(
          statusCode: 400, message: 'Invalid timestamp');
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if ((now - ts).abs() > _maxSkew.inSeconds) {
      return WebhookVerificationResult.fail(
        statusCode: 401,
        message: 'Stale or future-dated request '
            '(skew=${(now - ts).abs()}s)',
      );
    }

    // Bond lookup: only paired BFs are accepted. Unknown deviceId →
    // reject. This is the "must be a paired SmartKraft device" gate.
    final token = await _bondStore.tokenFor(deviceId);
    if (token == null) {
      return WebhookVerificationResult.fail(
        statusCode: 401,
        message: 'Device not paired with this SKAPP',
      );
    }

    // Recompute signature over the canonical message and compare in
    // constant time. The canonical form must match sk_api.c
    // build_sign_msg() exactly (güvenlik.md Madde 18):
    //   <body_len> || "\n" || body || "\n" || ts || "\n" || nonce_hex
    // The leading decimal BYTE length prefix removes the framing ambiguity
    // the old `body\n...` form had. `body_len` is the UTF-8 byte count so it
    // matches the firmware's `%zu` of the raw body bytes (not char count).
    // NOTE: lockstep change — a BF on old firmware signs the old format and
    // fails verification here until reflashed.
    final bodyByteLen = utf8.encode(body).length;
    final msg = utf8.encode('$bodyByteLen\n$body\n$tsStr\n$nonceHex');
    final mac = crypto_pkg.Hmac(crypto_pkg.sha256, token).convert(msg).bytes;
    final expectedHex = _hex(mac.sublist(0, 16));
    if (!_constantTimeEq(expectedHex, sigHex.toLowerCase())) {
      return WebhookVerificationResult.fail(
        statusCode: 401,
        message: 'Signature mismatch',
      );
    }

    // Nonce dedup — only after signature passes, so an attacker can't
    // pollute the ring without a valid bond.
    // Normalize so the same logical (device, nonce) pair can't slip past
    // dedup under a different id case or nonce-hex case (replay guard).
    final dedupKey =
        '${canonicalizeDeviceId(deviceId)}:${nonceHex.toLowerCase()}';
    if (_nonceSet.contains(dedupKey)) {
      return WebhookVerificationResult.fail(
        statusCode: 401,
        message: 'Nonce already seen (replay)',
      );
    }
    _nonceSet.add(dedupKey);
    _nonceRing.addLast(dedupKey);
    while (_nonceRing.length > _nonceRingSize) {
      final dropped = _nonceRing.removeFirst();
      _nonceSet.remove(dropped);
    }

    // Parse body as JSON. BF ships application/json by default; we accept
    // an empty body just in case (treat as `{}` so the router still sees
    // a map with no event).
    Map<String, Object?> parsed = const {};
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, Object?>) {
          parsed = decoded;
        } else if (decoded is Map) {
          parsed = decoded.cast<String, Object?>();
        } else {
          // A JSON array / scalar is not a valid webhook envelope; reject
          // it explicitly instead of silently treating it as an empty map.
          return WebhookVerificationResult.fail(
              statusCode: 400, message: 'Body must be a JSON object');
        }
      } catch (e) {
        return WebhookVerificationResult.fail(
            statusCode: 400, message: 'Body is not valid JSON: $e');
      }
    }

    return WebhookVerificationResult.ok(deviceId: deviceId, body: parsed);
  }

  String? _header(Map<String, String> headers, String key) {
    // Shelf normalises to lower-case but accept both for safety.
    return headers[key] ?? headers[key.toUpperCase()];
  }

  static String _hex(List<int> bytes) {
    final out = StringBuffer();
    for (final b in bytes) {
      out.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return out.toString();
  }

  static bool _constantTimeEq(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    final ab = utf8.encode(a);
    final bb = utf8.encode(b);
    for (var i = 0; i < ab.length; i++) {
      diff |= ab[i] ^ bb[i];
    }
    return diff == 0;
  }
}

/// Shape of a verified incoming webhook routed into the bindings layer.
class WebhookEvent {
  const WebhookEvent({
    required this.deviceId,
    required this.eventName,
    required this.payload,
  });

  /// The BF that sent the request (bond-verified).
  final String deviceId;

  /// `event` field from the JSON body. BF currently emits
  /// `focus_session_ended` from bf_timer_engine when the countdown ends.
  /// Treated as the binding's event filter target.
  final String eventName;

  /// Full body as a typed map; useful for binding param overrides that
  /// pull values out of the BF payload (duration_min, face, etc.).
  final Map<String, Object?> payload;
}

/// Helper: extract the event name from a webhook body. Falls back to
/// the legacy `evt` key (used by BLE/TCP CLI events) if `event` is
/// missing, so a single dispatcher can handle both paths.
String? webhookEventName(Map<String, Object?> body) {
  final v = body['event'] ?? body['evt'];
  if (v is String && v.isNotEmpty) return v;
  return null;
}

// Unused-but-kept-for-symmetry reference: build the canonical sign
// message exactly the way the BF firmware does. The receiver above
// inlines this for performance (avoid one extra UTF-8 copy), but we
// also expose the helper for tests / diagnostics.
Uint8List buildSignMessage({
  required String body,
  required String timestamp,
  required String nonceHex,
}) {
  return Uint8List.fromList(utf8.encode('$body\n$timestamp\n$nonceHex'));
}
