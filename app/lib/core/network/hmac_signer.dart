// HMAC-SHA256 request signer/verifier for SKAPP HTTP listener traffic.
//
// Shared between Desktop server (verify) and Mobile client (sign) so the
// canonical message format lives in one file. Bearer authentication
// remains supported in parallel as a fallback for older paired clients
// (Faz B step 2); Faz B step 3 (per-peer token) flips the default to
// HMAC and lets us retire the bearer path later.
//
// Wire format
// -----------
//   Authorization: SKAPP-HMAC <peerUuid>:<unixMillis>:<hexSig>
//
//   peerUuid    — same UUID the mobile peer received during pairing,
//                 identifies which token to look up server-side.
//   unixMillis  — caller's clock at request time, ms since epoch.
//   hexSig      — lowercase hex HMAC-SHA256, 64 chars.
//
// Canonical signed message:
//
//   <httpMethodUpper> "\n" <pathWithLeadingSlash> "\n"
//   <unixMillis>       "\n" <bodySha256Hex>
//
// Empty body's SHA-256 is the well-known
// e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
// — we always compute it explicitly to avoid a special case.
//
// Replay protection
// -----------------
//   - Timestamp window: ±300 seconds. Wider than the bond-webhook 60s
//     because mobile clocks drift more than ESP32 SNTP-synced clocks.
//   - Nonce dedup: (peerUuid, unixMillis, hexSig) tuple in an LRU ring
//     (size 256). Replays inside the window return 409 conflict.
//
// Constant-time signature comparison guards against timing attacks
// during signature verification; not strictly necessary for our threat
// model (the secret is the user's token, not a server-wide secret) but
// cheap and consistent with `webhook_receiver.dart`.

import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto_pkg;

/// Outcome of a signed-request verification step. Carries the resolved
/// peer UUID on success so the caller can attribute the request without
/// re-parsing the header.
class HmacVerificationResult {
  const HmacVerificationResult.ok({required this.peerUuid})
      : ok = true,
        statusCode = 200,
        code = null,
        message = null;

  const HmacVerificationResult.fail({
    required this.statusCode,
    required this.code,
    required this.message,
  })  : ok = false,
        peerUuid = null;

  final bool ok;

  /// Stable machine-readable failure code for the API caller. Values:
  /// `malformed_header`, `stale_request`, `replay_detected`,
  /// `unknown_peer`, `invalid_signature`. Server emits these in the
  /// JSON error body so the mobile client can map them to specific i18n
  /// strings without parsing English.
  final String? code;
  final int statusCode;
  final String? message;
  final String? peerUuid;
}

/// Resolves a peer's HMAC secret from its UUID. Faz B step 2 implements
/// this as "look up `bearerToken` in the install's `NetworkIdentity`"
/// because every paired peer currently shares the install bearer. Faz B
/// step 3 swaps this for `peerTokensProvider.tokenFor(peerUuid)` so
/// per-peer revoke becomes possible without touching the verifier.
typedef HmacTokenLookup = String? Function(String peerUuid);

/// Server-side verifier. One instance per `SkappHttpServer` lifetime so
/// the nonce ring is shared across requests.
class HmacRequestVerifier {
  HmacRequestVerifier({required HmacTokenLookup tokenLookup})
      : _tokenLookup = tokenLookup;

  final HmacTokenLookup _tokenLookup;

  /// LRU ring sized for 256 in-flight nonces. Even at 10 req/sec inside
  /// the 300s window we'd see ~3000 entries — well over the cap — so the
  /// effective replay window for very chatty clients is shorter than
  /// 5min, which is fine (the timestamp window still rejects truly
  /// stale requests).
  static const int _nonceRingSize = 256;
  final Queue<String> _nonceRing = Queue<String>();
  final Set<String> _nonceSet = <String>{};

  /// Inclusive ±5 minute timestamp window.
  static const Duration _maxSkew = Duration(minutes: 5);

  /// Verifies the `Authorization: SKAPP-HMAC ...` header and request
  /// envelope. The caller still has to enforce its own per-route policy
  /// (Developer mode gate, bearer fallback, etc.) — this method only judges
  /// the signature, the timestamp, and the nonce.
  HmacVerificationResult verify({
    required String authorizationHeader,
    required String method,
    required String path,
    required String body,
  }) {
    if (!authorizationHeader.startsWith('SKAPP-HMAC ')) {
      return const HmacVerificationResult.fail(
        statusCode: 400,
        code: 'malformed_header',
        message: 'Authorization header is not a SKAPP-HMAC envelope',
      );
    }
    final envelope = authorizationHeader.substring('SKAPP-HMAC '.length).trim();
    final parts = envelope.split(':');
    if (parts.length != 3) {
      return const HmacVerificationResult.fail(
        statusCode: 400,
        code: 'malformed_header',
        message: 'Envelope must be <peerUuid>:<unixMillis>:<hexSig>',
      );
    }
    final peerUuid = parts[0];
    final tsRaw = parts[1];
    final sigHex = parts[2].toLowerCase();
    if (peerUuid.isEmpty || tsRaw.isEmpty || sigHex.length != 64) {
      return const HmacVerificationResult.fail(
        statusCode: 400,
        code: 'malformed_header',
        message: 'Envelope fields invalid',
      );
    }

    final ts = int.tryParse(tsRaw);
    if (ts == null) {
      return const HmacVerificationResult.fail(
        statusCode: 400,
        code: 'malformed_header',
        message: 'Invalid timestamp',
      );
    }
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if ((nowMs - ts).abs() > _maxSkew.inMilliseconds) {
      return HmacVerificationResult.fail(
        statusCode: 401,
        code: 'stale_request',
        message: 'Stale or future-dated request '
            '(skew=${(nowMs - ts).abs()}ms)',
      );
    }

    // Resolve peer token. Unknown peer (never paired, or revoked after
    // Faz B step 3 lands) → reject before recomputing the signature so
    // a probing attacker can't enumerate peer UUIDs via timing.
    final token = _tokenLookup(peerUuid);
    if (token == null) {
      return const HmacVerificationResult.fail(
        statusCode: 401,
        code: 'unknown_peer',
        message: 'Peer not paired or has been revoked',
      );
    }

    final expectedHex = computeSignature(
      token: token,
      method: method,
      path: path,
      unixMillis: ts,
      body: body,
    );
    if (!constantTimeEq(expectedHex, sigHex)) {
      return const HmacVerificationResult.fail(
        statusCode: 401,
        code: 'invalid_signature',
        message: 'Signature mismatch',
      );
    }

    // Nonce dedup, checked AFTER signature passes so an unauthenticated
    // attacker can't pollute the ring.
    final dedupKey = '$peerUuid:$ts:$sigHex';
    if (_nonceSet.contains(dedupKey)) {
      return const HmacVerificationResult.fail(
        statusCode: 409,
        code: 'replay_detected',
        message: 'Same (peer, timestamp, signature) already accepted',
      );
    }
    _nonceSet.add(dedupKey);
    _nonceRing.addLast(dedupKey);
    while (_nonceRing.length > _nonceRingSize) {
      _nonceSet.remove(_nonceRing.removeFirst());
    }

    return HmacVerificationResult.ok(peerUuid: peerUuid);
  }
}

/// Sign helper used by the mobile-side `SkappHttpClient`. Stateless,
/// hence a free function — no class state to manage and no LRU to share.
String buildAuthorizationHeader({
  required String peerUuid,
  required String token,
  required String method,
  required String path,
  required String body,
  DateTime? now,
}) {
  final ts = (now ?? DateTime.now()).millisecondsSinceEpoch;
  final sig = computeSignature(
    token: token,
    method: method,
    path: path,
    unixMillis: ts,
    body: body,
  );
  return 'SKAPP-HMAC $peerUuid:$ts:$sig';
}

/// Canonical signature computation. Shared by the server and the client
/// so the format only lives in one place. Anchor of correctness for
/// every test in this module.
String computeSignature({
  required String token,
  required String method,
  required String path,
  required int unixMillis,
  required String body,
}) {
  final bodyHash = crypto_pkg.sha256.convert(utf8.encode(body)).toString();
  final message = '${method.toUpperCase()}\n'
      '$path\n'
      '$unixMillis\n'
      '$bodyHash';
  final hmac = crypto_pkg.Hmac(crypto_pkg.sha256, utf8.encode(token));
  return hmac.convert(utf8.encode(message)).toString();
}

/// Length-stable, constant-time string equality. Both inputs should be
/// hex strings of the same fixed length (64 chars for SHA-256).
bool constantTimeEq(String a, String b) {
  if (a.length != b.length) return false;
  final ab = utf8.encode(a);
  final bb = utf8.encode(b);
  var diff = 0;
  for (var i = 0; i < ab.length; i++) {
    diff |= ab[i] ^ bb[i];
  }
  return diff == 0;
}
