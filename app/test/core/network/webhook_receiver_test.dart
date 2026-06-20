// Güvenlik.md Madde 18 — webhook HMAC canonical mesajı length-prefix.
//
// Canonical form (firmware sk_api.c build_sign_msg ile byte-exact aynı):
//   <body_len> "\n" body "\n" ts "\n" nonce_hex
// Bu test app verifier'ın YENİ formatı kabul, ESKİ formatı reddettiğini
// kilitler — firmware ile lockstep sözleşmeyi regresyona karşı korur.

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skapp/core/cli/bond_store.dart';
import 'package:skapp/core/network/webhook_receiver.dart';

class MockBondStore extends Mock implements BondStore {}

String _hex(List<int> b) =>
    b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();

void main() {
  late MockBondStore bond;
  late WebhookReceiver receiver;

  final token = Uint8List.fromList(List.generate(32, (i) => i + 1));
  const deviceId = 'BF-TEST01';
  const peerId = 'aabbccddeeff00112233445566778899';
  const nonce = '00112233445566778899aabbccddeeff';
  const body = '{"event":"timer.expired","slot":0}';

  setUp(() {
    bond = MockBondStore();
    when(() => bond.tokenFor(any())).thenAnswer((_) async => token);
    receiver = WebhookReceiver(bondStore: bond);
  });

  String sigFor(String canonical) {
    final mac = Hmac(sha256, token).convert(utf8.encode(canonical)).bytes;
    return _hex(mac.sublist(0, 16));
  }

  Map<String, String> headers(String ts, String sig) => {
        'x-sk-device-id': deviceId,
        'x-sk-peer-id': peerId,
        'x-sk-timestamp': ts,
        'x-sk-nonce': nonce,
        'x-sk-signature': sig,
      };

  test('YENİ length-prefixed canonical imza kabul edilir', () async {
    final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final bodyLen = utf8.encode(body).length;
    final canonical = '$bodyLen\n$body\n$ts\n$nonce';
    final result = await receiver.verify(
      headers: headers(ts, sigFor(canonical)),
      body: body,
    );
    expect(result.ok, isTrue, reason: result.message);
    expect(result.deviceId, deviceId);
  });

  test('ESKİ prefixsiz format artık REDDEDİLİR (signature mismatch)', () async {
    final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final oldCanonical = '$body\n$ts\n$nonce'; // Madde 18 öncesi form
    final result = await receiver.verify(
      headers: headers(ts, sigFor(oldCanonical)),
      body: body,
    );
    expect(result.ok, isFalse);
    expect(result.statusCode, 401);
  });
}
