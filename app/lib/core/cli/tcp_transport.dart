// TCP NDJSON transport.
//
// Connects to <device-ip>:<port> (default 8080) and runs the same mutual
// challenge-response handshake as the BLE transport, sk_secure_session
// is transport-agnostic on the device side, so the on-the-wire shape is
// identical:
//   device → peer : {"evt":"auth.challenge","data":"<16hex>"}
//   peer  → device: {"cmd":"auth.response","args":{"response":"<16hex>","challenge":"<16hex>"}}
//   device → peer : {"ok":true,"data":{"answer":"<16hex>"}}
//
// Once `authenticated == true`, the application layer keeps wrapping
// outbound commands in the HMAC envelope (CliClient + CliSigner).

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'cli_transport.dart';

class TcpCliTransport implements CliTransport {
  TcpCliTransport({
    required this.host,
    this.port = 8080,
    required List<int> token,
  }) : _token = Uint8List.fromList(token);

  final String host;
  final int port;
  final Uint8List _token;

  final _incoming = StreamController<String>.broadcast();
  final _authDone = Completer<void>();
  Socket? _socket;
  bool _authenticated = false;
  Uint8List? _ourChallenge;
  final _buffer = StringBuffer();

  @override
  Stream<String> get incoming => _incoming.stream;

  @override
  bool get authenticated => _authenticated;

  @override
  Future<void> connect() async {
    _socket = await Socket.connect(host, port,
        timeout: const Duration(seconds: 5));
    utf8.decoder.bind(_socket!).listen(_onChunk,
        onError: (Object _) {}, onDone: close);
    await _authDone.future.timeout(const Duration(seconds: 10));
  }

  void _onChunk(String chunk) {
    _buffer.write(chunk);
    while (true) {
      final s = _buffer.toString();
      final nl = s.indexOf('\n');
      if (nl < 0) break;
      final line = s.substring(0, nl);
      _buffer
        ..clear()
        ..write(s.substring(nl + 1));
      if (line.isEmpty) continue;
      _handleLine(line);
    }
  }

  Future<void> _handleLine(String line) async {
    Map<String, dynamic> msg;
    try {
      msg = jsonDecode(line) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    if (!_authenticated) {
      // Step 1: device sends auth.challenge.
      if (msg['evt'] == 'auth.challenge') {
        final hexChallenge = msg['data'] as String?;
        if (hexChallenge == null) return;
        final challenge = Uint8List.fromList(hex.decode(hexChallenge));
        final resp =
            Hmac(sha256, _token).convert(challenge).bytes.sublist(0, 16);
        _ourChallenge = _randomBytes(16);
        final body = jsonEncode({
          'cmd': 'auth.response',
          'args': {
            'response': hex.encode(resp),
            'challenge': hex.encode(_ourChallenge!),
          },
        });
        await sendLine(body);
        return;
      }

      // Step 2: device's answer to our challenge.
      if (msg['ok'] == true && msg['data'] is Map) {
        final data = msg['data'] as Map<String, dynamic>;
        final answerHex = data['answer'] as String?;
        if (answerHex == null || _ourChallenge == null) return;
        final answer = Uint8List.fromList(hex.decode(answerHex));
        final expected = Hmac(sha256, _token)
            .convert(_ourChallenge!)
            .bytes
            .sublist(0, 16);
        if (_constantTimeEq(answer, expected)) {
          _authenticated = true;
          if (!_authDone.isCompleted) _authDone.complete();
        } else if (!_authDone.isCompleted) {
          _authDone.completeError(
              StateError('TCP auth answer verification failed'));
        }
        return;
      }

      if (msg['ok'] == false) {
        _incoming.add(line);
        if (!_authDone.isCompleted) {
          _authDone.completeError(
              StateError(msg['err']?.toString() ?? 'TCP auth rejected'));
        }
        return;
      }
      return;
    }

    _incoming.add(line);
  }

  Uint8List _randomBytes(int n) {
    final r = Random.secure();
    final out = Uint8List(n);
    for (var i = 0; i < n; i++) {
      out[i] = r.nextInt(256);
    }
    return out;
  }

  bool _constantTimeEq(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  @override
  Future<void> sendLine(String line) async {
    if (_socket == null) throw StateError('TCP transport not connected');
    final s = line.endsWith('\n') ? line : '$line\n';
    _socket!.add(utf8.encode(s));
    await _socket!.flush();
  }

  @override
  Future<void> close() async {
    _authenticated = false;
    try {
      await _socket?.close();
    } catch (_) {/* already gone */}
    _socket = null;
    if (!_incoming.isClosed) await _incoming.close();
  }
}
