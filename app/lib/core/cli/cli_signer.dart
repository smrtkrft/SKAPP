// Per-message HMAC-SHA256 envelope. Mirrors sk_secure_session_dispatch_signed
// on the device:
//
//   wire = {"body":"<inner json>","sig":"<32hex>","nonce":<u32>,"ts":<i64>}
//
// `sig` = HMAC-SHA256(token, utf8(body))[:16], body is the inner JSON bytes
// as transmitted, NOT a re-canonicalised form. `nonce` is monotonic per
// session (replay window 64 on the device side); `ts` is advisory (the
// device has no NTP yet, so it just bumps the nonce window).

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class CliSigner {
  /// Each new signer starts with a random 24-bit base. The firmware does
  /// the right thing now (replay window is reset on every fresh auth
  /// handshake, sk_auth_replay_reset), but on devices running older
  /// firmware that still carry over the global nonce list across
  /// reconnects, starting from a random offset drastically lowers the
  /// chance of a collision with the previous session's last 64 nonces.
  /// Belt-and-suspenders: cheap on our side, hard to predict from
  /// outside, and never breaks anything.
  CliSigner(List<int> token)
      : _token = Uint8List.fromList(token),
        _nonce = Random.secure().nextInt(1 << 24);

  final Uint8List _token;
  int _nonce;

  /// Wraps a raw command body in a signed NDJSON envelope. The inner body
  /// is serialised once and that exact byte sequence is used both as the
  /// envelope's `body` field and as the HMAC input.
  String envelope(Map<String, dynamic> body) {
    final bodyJson = jsonEncode(body);
    final nonce = ++_nonce;
    final tsUnix = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final mac = Hmac(sha256, _token).convert(utf8.encode(bodyJson)).bytes;
    final sigHex = hex.encode(mac.sublist(0, 16));

    return jsonEncode({
      'body': bodyJson,
      'sig': sigHex,
      'nonce': nonce,
      'ts': tsUnix,
    });
  }
}
