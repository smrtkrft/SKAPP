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
  });
}
