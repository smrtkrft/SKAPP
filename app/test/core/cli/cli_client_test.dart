// CliClient sözleşme testleri. Özellikle: sendLine fırlarsa bekleyen
// completer SIZMAMALI — aksi halde transport kapanınca dinleyicisiz
// future'a hata düşer ve zone'da yakalanmamış async istisna olur
// (USB'de sendLine tasarım gereği fırlar: >1023B komut, kapalı port).

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/cli_client.dart';
import 'package:skapp/core/cli/cli_transport.dart';

class _ThrowingTransport implements CliTransport {
  final _incoming = StreamController<String>.broadcast();
  bool throwOnSend = true;

  @override
  Stream<String> get incoming => _incoming.stream;

  @override
  bool get authenticated => true;

  @override
  Future<void> connect() async {}

  @override
  Future<void> sendLine(String line) async {
    if (throwOnSend) throw StateError('write failed');
  }

  @override
  Future<void> close() async {
    if (!_incoming.isClosed) await _incoming.close();
  }
}

/// Transport that lets a test script the device side: [onSend] sees each
/// decoded request and calls [reply] with whatever the "device" answers.
class _ScriptedTransport implements CliTransport {
  final _incoming = StreamController<String>.broadcast();
  void Function(Map<String, dynamic> msg)? onSend;

  void reply(Map<String, dynamic> msg) {
    scheduleMicrotask(() {
      if (!_incoming.isClosed) _incoming.add(jsonEncode(msg));
    });
  }

  @override
  Stream<String> get incoming => _incoming.stream;

  @override
  bool get authenticated => true;

  @override
  Future<void> connect() async {}

  @override
  Future<void> sendLine(String line) async {
    onSend?.call(jsonDecode(line) as Map<String, dynamic>);
  }

  @override
  Future<void> close() async {
    if (!_incoming.isClosed) await _incoming.close();
  }
}

void main() {
  test('send() cleans up the pending entry when sendLine throws', () async {
    final transport = _ThrowingTransport();
    final client = CliClient(transport);
    await client.start();

    await expectLater(
        client.send('device.info'), throwsA(isA<StateError>()));

    // Sızıntı olsaydı stop() bu completer'a completeError yapar ve hiçbir
    // dinleyicisi olmadığı için zone'da yakalanmamış hata oluşurdu.
    // pendingCount ile doğrudan doğruluyoruz.
    expect(client.pendingCount, 0,
        reason: 'başarısız gönderim bekleyen istek bırakmamalı');

    await client.stop();
  });

  test('non-JSON device output is surfaced, not dropped', () async {
    // An ESP32 on a USB-Serial-JTAG port prints boot logs, printf debug
    // output and panic backtraces on the SAME wire as NDJSON. Dropping
    // those lines hides exactly the evidence the dev console exists for:
    // firmware crashes, then the user only sees a generic timeout.
    final transport = _ThrowingTransport()..throwOnSend = false;
    final client = CliClient(transport);
    await client.start();

    final seen = <String>[];
    final sub = client.unparsed.listen(seen.add);

    transport._incoming.add('E (1234) sk_core: assert failed at line 42');
    transport._incoming.add('Backtrace: 0x400d1234:0x3ffb0000');
    transport._incoming.add('{"id":1,"ok":true}'); // valid JSON, not unparsed
    await Future<void>.delayed(Duration.zero);

    expect(seen, [
      'E (1234) sk_core: assert failed at line 42',
      'Backtrace: 0x400d1234:0x3ffb0000',
    ]);

    await sub.cancel();
    await client.stop();
  });

  test('confirm dialog is labelled with OUR command, not the device echo',
      () async {
    // The confirm dialog is the only barrier between a typed line and an
    // irreversible command. Labelling it with device-supplied text lets a
    // rogue/tampered device answer a factory-reset request with
    // params.cmd = "device.status", so the user approves something
    // harmless-looking while the app sends the destructive command.
    final transport = _ScriptedTransport();
    final client = CliClient(transport);
    await client.start();

    transport.onSend = (msg) {
      if (msg['confirm_token'] == null) {
        transport.reply({
          'id': msg['id'],
          'ok': false,
          'err': 'ERR_CONFIRM_TOKEN_REQUIRED',
          'params': {
            'cmd': 'device.status', // device lies about which command
            'ttl_sec': 99999, // and about the TTL
            'confirm_token': 'abc123',
          },
        });
      } else {
        transport.reply({'id': msg['id'], 'ok': true});
      }
    };

    CliConfirmRequest? shown;
    final resp = await client.sendCritical(
      'device.factory-reset',
      confirmRequest: (req) async {
        shown = req;
        return true;
      },
    );

    expect(shown!.cmd, 'device.factory-reset',
        reason: 'dialog must name the command WE are about to send');
    expect(shown!.ttlSec, lessThanOrEqualTo(300),
        reason: 'device-supplied TTL must be clamped');
    expect(resp.ok, isTrue);
    await client.stop();
  });

  test('hostile response shapes do not throw inside the stream callback',
      () async {
    // A foreign device on the port can send `"params":[]` / `"err":1`.
    // Unguarded casts turned that into an uncaught zone error.
    final transport = _ThrowingTransport()..throwOnSend = false;
    final client = CliClient(transport);
    await client.start();

    final pending = client.send('device.info',
        timeout: const Duration(milliseconds: 200));
    transport._incoming.add('{"id":1,"ok":false,"err":1,"params":[]}');

    final r = await pending;
    expect(r.ok, isFalse);
    expect(r.err, isNotNull, reason: 'non-string err must be stringified');
    await client.stop();
  });

  test('closedReason carries the transport failure to pending requests',
      () async {
    final transport = _ThrowingTransport()..throwOnSend = false;
    final client = CliClient(transport);
    await client.start();

    final pending = client.send('device.info',
        timeout: const Duration(seconds: 5));
    expect(client.pendingCount, 1);

    transport._incoming.addError(const TransportClosedException('unplugged'));

    await expectLater(pending, throwsA(isA<TransportClosedException>()));
    expect(client.closedReason, isA<TransportClosedException>());
  });
}
