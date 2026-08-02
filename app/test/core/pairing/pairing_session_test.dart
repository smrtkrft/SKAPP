import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto_pkg;
import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/pairing/pairing_error.dart';
import 'package:skapp/core/pairing/pairing_link.dart';
import 'package:skapp/core/pairing/pairing_session.dart';

/// Script'lenebilir sahte link: testler cihaz cevaplarını kuyruklar.
class FakePairingLink implements PairingLink {
  final sent = <Map<String, dynamic>>[];
  final _lines = StreamController<String>.broadcast();

  /// Her sendJson'da çalıştırılan cevap üreticisi (throwOnSend'den ÖNCE
  /// çalışır — reply-then-close quirk'ini simüle edebilmek için).
  Future<void> Function(Map<String, dynamic> msg, FakePairingLink link)? onSend;
  bool throwOnSend = false;

  @override
  Stream<String> get lines => _lines.stream;

  void emit(Map<String, dynamic> obj) => _lines.add(jsonEncode(obj));
  void emitRaw(String line) => _lines.add(line);
  void dropLink([Object? error]) {
    if (error != null) _lines.addError(error);
    _lines.close();
  }

  @override
  Future<void> sendJson(Map<String, dynamic> obj) async {
    sent.add(obj);
    await onSend?.call(obj, this);
    if (throwOnSend) throw StateError('write failed');
  }

  @override
  Future<void> close() async {
    if (!_lines.isClosed) await _lines.close();
  }
}

/// Gerçek X25519 ile cihaz tarafını simüle eder; our_pub üretir ve
/// beklenen token'ı hesaplar (sk_auth_token_v1 türetimi).
class FakeDeviceCrypto {
  late SimpleKeyPair keyPair;
  late Uint8List publicKey;

  static Future<FakeDeviceCrypto> create() async {
    final d = FakeDeviceCrypto();
    d.keyPair = await X25519().newKeyPair();
    d.publicKey =
        Uint8List.fromList((await d.keyPair.extractPublicKey()).bytes);
    return d;
  }

  Future<Uint8List> expectedToken(String appPubHex) async {
    final appPub =
        SimplePublicKey(hex.decode(appPubHex), type: KeyPairType.x25519);
    final secret = await X25519()
        .sharedSecretKey(keyPair: keyPair, remotePublicKey: appPub);
    final bytes = await secret.extractBytes();
    final input = <int>[...utf8.encode('sk_auth_token_v1'), ...bytes];
    return Uint8List.fromList(crypto_pkg.sha256.convert(input).bytes);
  }
}

PairingSession _session(FakePairingLink link, {List<String>? trail}) =>
    PairingSession(
      link: link,
      ourPeerId: Uint8List.fromList(List.generate(16, (i) => i)),
      label: 'test-skapp',
      onTrace: trail?.add,
    );

void main() {
  test('happy path derives the same token as the device side', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.onSend = (msg, l) async {
      expect(msg['cmd'], 'pairing.ecdh.exchange');
      expect((msg['args'] as Map)['peer_id'], hasLength(32)); // 16B hex
      expect((msg['args'] as Map)['label'], 'test-skapp');
      l.emit({
        'ok': true,
        'data': {'our_pub': hex.encode(device.publicKey), 'slot': 3},
      });
    };
    final r = await _session(link).run(promptPassphrase: (_) async => null);
    final appPubHex = (link.sent.single['args'] as Map)['peer_pub'] as String;
    expect(r.token, await device.expectedToken(appPubHex));
    expect(r.slot, 3);
  });

  test('bonded greeting (auth.challenge) and pairing.required are skipped',
      () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.onSend = (msg, l) async {
      l.emit({'evt': 'auth.challenge', 'data': 'aa' * 16});
      l.emit({
        'evt': 'pairing.required',
        'data': {'reason': 'no_bond'},
      });
      l.emit({
        'ok': true,
        'data': {'our_pub': hex.encode(device.publicKey)},
      });
    };
    final r = await _session(link).run(promptPassphrase: (_) async => null);
    expect(r.token, hasLength(32));
    expect(r.slot, isNull);
  });

  test('ERR_PAIRING_NOT_OPEN → typed pairingNotOpen', () async {
    final link = FakePairingLink();
    link.onSend =
        (msg, l) async => l.emit({'ok': false, 'err': 'ERR_PAIRING_NOT_OPEN'});
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.pairingNotOpen)),
    );
  });

  test('ERR_BOND_STORE_FULL carries peers params', () async {
    final link = FakePairingLink();
    link.onSend = (msg, l) async => l.emit({
          'ok': false,
          'err': 'ERR_BOND_STORE_FULL',
          'params': {
            'peers': [
              {'slot': 0, 'label': 'x'},
            ],
          },
        });
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.bondStoreFull)
          .having((e) => (e.params?['peers'] as List).length, 'peers', 1)),
    );
  });

  test('non-envelope JSON lines are skipped, not consumed as the reply',
      () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    final trail = <String>[];
    link.onSend = (msg, l) async {
      // Cihazın araya sıkıştırdığı, zarf olmayan bir JSON satırı: ne `evt`
      // ne `ok` içeriyor. Eskiden bu satır "cevap" sayılıp akışı
      // ERR_UNKNOWN ile düşürüyordu.
      l.emit({'status': 'busy'});
      l.emit({
        'ok': true,
        'data': {'our_pub': hex.encode(device.publicKey)},
      });
    };
    final r =
        await _session(link, trail: trail).run(promptPassphrase: (_) async => null);
    expect(r.token, hasLength(32));
    expect(trail.join('\n'), contains('non-envelope'));
  });

  test('stale ok-envelope cannot satisfy the passphrase gate silently',
      () async {
    // Regresyon: parola aşamasında bekleyen completer'ı, cihazın
    // doğrulamasını temsil ETMEYEN bayat bir exchange zarfı tamamlarsa
    // kapı sahte açılır → token kaydedilir ama cihazda bond yoktur.
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    var verifySeen = false;
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {
            'our_pub': hex.encode(device.publicKey),
            'need_passphrase': true,
            'attempts_left': 3,
          },
        });
      } else if (msg['cmd'] == 'pairing.passphrase.verify') {
        verifySeen = true;
        // Araya bayat bir EXCHANGE zarfı düşüyor (our_pub taşıyor) — bu,
        // parola doğrulamasının cevabı DEĞİLDİR. Ardından gerçek verify
        // cevabı geliyor. Doğru davranış: bayatı atla, gerçeği bekle.
        l.emit({
          'ok': true,
          'data': {'our_pub': hex.encode(device.publicKey), 'need_passphrase': true},
        });
        l.emit({
          'ok': true,
          'data': {'slot': 2},
        });
      }
    };
    final r = await _session(link).run(promptPassphrase: (_) async => 'pw');
    expect(verifySeen, isTrue);
    // slot=2 ancak GERÇEK verify cevabı işlendiyse gelir; bayat zarf kapıyı
    // açsaydı slot null kalırdı.
    expect(r.slot, 2);
  });

  test('malformed lines are counted, not fatal', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    final trail = <String>[];
    link.onSend = (msg, l) async {
      l.emitRaw('not-json-at-all');
      l.emit({
        'ok': true,
        'data': {'our_pub': hex.encode(device.publicKey)},
      });
    };
    final r = await _session(link, trail: trail)
        .run(promptPassphrase: (_) async => null);
    expect(r.token, hasLength(32));
    expect(trail.join('\n'), contains('malformed'));
  });

  test('link drop while waiting → linkClosed with cause', () async {
    final link = FakePairingLink();
    link.onSend = (msg, l) async => l.dropLink(StateError('reset'));
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.linkClosed)
          .having((e) => e.cause.toString(), 'cause', contains('reset'))),
    );
  });

  test('write error is benign when reply already arrives', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.throwOnSend = true; // reply-then-close: cevap gider, write patlar
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {'our_pub': hex.encode(device.publicKey)},
        });
      }
    };
    final r = await _session(link).run(promptPassphrase: (_) async => null);
    expect(r.token, hasLength(32));
  });

  test('write error without reply → linkClosed', () async {
    final link = FakePairingLink();
    link.throwOnSend = true;
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.linkClosed)
          .having((e) => e.stage, 'stage', PairingStage.exchange)),
    );
  });

  test('passphrase: incorrect → reprompt, then success', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    var verifies = 0;
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {
            'our_pub': hex.encode(device.publicKey),
            'need_passphrase': true,
            'attempts_left': 5,
          },
        });
      } else if (msg['cmd'] == 'pairing.passphrase.verify') {
        verifies++;
        if (verifies == 1) {
          l.emit({
            'ok': false,
            'err': 'ERR_PASSPHRASE_INCORRECT',
            'params': {'attempts_left': 4},
          });
        } else {
          expect((msg['args'] as Map)['plain'], 'pw');
          l.emit({
            'ok': true,
            'data': {'slot': 1},
          });
        }
      }
    };
    final prompts = <int>[];
    final r = await _session(link).run(promptPassphrase: (left) async {
      prompts.add(left);
      return 'pw';
    });
    expect(prompts, [5, 4]);
    expect(r.slot, 1);
  });

  test('passphrase cancel → cancelled', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {
            'our_pub': hex.encode(device.publicKey),
            'need_passphrase': true,
          },
        });
      }
    };
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.cancelled)),
    );
  });

  test('passphrase lockout when attempts exhausted', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {
            'our_pub': hex.encode(device.publicKey),
            'need_passphrase': true,
            'attempts_left': 1,
          },
        });
      } else {
        l.emit({
          'ok': false,
          'err': 'ERR_PASSPHRASE_INCORRECT',
          'params': {'attempts_left': 0},
        });
      }
    };
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => 'wrong'),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.passphraseLockout)),
    );
  });

  test('ERR_NO_PENDING_BOND during passphrase → noPendingBond', () async {
    final device = await FakeDeviceCrypto.create();
    final link = FakePairingLink();
    link.onSend = (msg, l) async {
      if (msg['cmd'] == 'pairing.ecdh.exchange') {
        l.emit({
          'ok': true,
          'data': {
            'our_pub': hex.encode(device.publicKey),
            'need_passphrase': true,
          },
        });
      } else {
        l.emit({'ok': false, 'err': 'ERR_NO_PENDING_BOND'});
      }
    };
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => 'pw'),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.noPendingBond)),
    );
  });

  test('invalid our_pub → invalidReply', () async {
    final link = FakePairingLink();
    link.onSend = (msg, l) async => l.emit({
          'ok': true,
          'data': {'our_pub': 'tooshort'},
        });
    await expectLater(
      _session(link).run(promptPassphrase: (_) async => null),
      throwsA(isA<PairingException>()
          .having((e) => e.code, 'code', PairingErrorCode.invalidReply)),
    );
  });
}
