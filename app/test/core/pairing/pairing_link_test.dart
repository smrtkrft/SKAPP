import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/pairing/pairing_link.dart';

void main() {
  group('NdjsonLineBuffer', () {
    test('splits fragmented chunks into lines', () {
      final buf = NdjsonLineBuffer();
      expect(buf.feed('{"a"'), isEmpty);
      expect(buf.feed(':1}\n{"b":2}\n{"c"'), ['{"a":1}', '{"b":2}']);
      expect(buf.feed(':3}\n'), ['{"c":3}']);
    });
    test('drops empty lines', () {
      final buf = NdjsonLineBuffer();
      expect(buf.feed('\n\n{"a":1}\n'), ['{"a":1}']);
    });

    test('throws once a line exceeds maxLineBytes (İ-10: unbounded buffer)',
        () {
      // \n göndermeyen bir uç, tamponu sınırsız büyütüp belleği tüketebilir
      // ve her feed'de O(n²) CPU yakar. Cap aşımında bağlantı kesilmeli.
      final buf = NdjsonLineBuffer(maxLineBytes: 64);
      expect(buf.feed('x' * 60), isEmpty);
      expect(() => buf.feed('y' * 10), throwsA(isA<PairingLineOverflow>()));
    });

    test('cap counts per line, not per session', () {
      final buf = NdjsonLineBuffer(maxLineBytes: 16);
      expect(buf.feed('${'a' * 10}\n${'b' * 10}\n'), ['a' * 10, 'b' * 10]);
      expect(buf.feed('c' * 10), isEmpty); // yeni satır, sayaç sıfırlandı
    });
  });

  group('TcpPairingLink', () {
    test('round-trips lines and closes stream on server FIN', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final serverGot = <String>[];
      server.listen((client) {
        utf8.decoder.bind(client).listen((chunk) {
          serverGot.add(chunk);
          client.add(utf8.encode('{"ok":true}\n'));
          client.close();
        });
      });
      final link = await TcpPairingLink.connect(
          InternetAddress.loopbackIPv4.address, server.port);
      final lines = <String>[];
      final done =
          link.lines.listen(lines.add).asFuture<void>().catchError((_) {});
      await link.sendJson({'cmd': 'x'});
      await done.timeout(const Duration(seconds: 5));
      expect(serverGot.join(), '{"cmd":"x"}\n');
      expect(lines, ['{"ok":true}']);
      await link.close();
      await server.close();
    });

    test('traces received bytes so the debug panel proves data arrived',
        () async {
      // Cihaz \n'siz cevap gönderirse panel "hiç cevap gelmedi" ile ayırt
      // edilemez sessizlik gösteriyordu; rx izleri bunu çözer.
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((client) {
        client.add(utf8.encode('{"ok":true}\n'));
      });
      final trail = <String>[];
      final link = await TcpPairingLink.connect(
          InternetAddress.loopbackIPv4.address, server.port,
          onTrace: trail.add);
      await link.lines.first.timeout(const Duration(seconds: 5));
      expect(trail.join('\n'), contains('rx'));
      await link.close();
      await server.close();
    });
  });
}
