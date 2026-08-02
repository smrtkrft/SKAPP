// CliClient sözleşme testleri. Özellikle: sendLine fırlarsa bekleyen
// completer SIZMAMALI — aksi halde transport kapanınca dinleyicisiz
// future'a hata düşer ve zone'da yakalanmamış async istisna olur
// (USB'de sendLine tasarım gereği fırlar: >1023B komut, kapalı port).

import 'dart:async';

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
