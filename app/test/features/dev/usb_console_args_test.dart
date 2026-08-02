// USB konsolunda `key=value` argümanları firmware'e HEP string olarak
// gidiyordu: `brightness=128` → {"brightness":"128"}. Makine-modu komutları
// cJSON'da sayı/bool beklediği için ERR_INVALID_ARGS dönüyordu — kullanıcının
// gördüğü "komut hatalarının" en olası kaynağı.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/dev/usb_console_providers.dart';

void main() {
  group('coerceCliArgValue', () {
    test('integers become num', () {
      expect(coerceCliArgValue('128'), 128);
      expect(coerceCliArgValue('-5'), -5);
      expect(coerceCliArgValue('0'), 0);
    });

    test('doubles become num', () {
      expect(coerceCliArgValue('1.5'), 1.5);
    });

    test('booleans become bool', () {
      expect(coerceCliArgValue('true'), isTrue);
      expect(coerceCliArgValue('false'), isFalse);
      // Büyük/küçük harf duyarsız.
      expect(coerceCliArgValue('TRUE'), isTrue);
    });

    test('null literal becomes null', () {
      expect(coerceCliArgValue('null'), isNull);
    });

    test('everything else stays a string', () {
      expect(coerceCliArgValue('ofis_wifi'), 'ofis_wifi');
      expect(coerceCliArgValue('BF-A06TMFSQT'), 'BF-A06TMFSQT');
      // SSID/parola gibi sayı GİBİ görünen ama string kalması gerekenler
      // tırnakla korunur (tokenizer tırnağı ayıklar, biz işareti alırız).
      expect(coerceCliArgValue('12345678', quoted: true), '12345678');
    });

    test('leading-zero and oversized numerics stay strings', () {
      // "007" bir kimlik/kod olabilir; sayıya çevirmek anlamı bozar.
      expect(coerceCliArgValue('007'), '007');
      // 64-bit'i aşan değer sayıya sığmaz, string kalmalı.
      expect(coerceCliArgValue('123456789012345678901234567890'),
          '123456789012345678901234567890');
    });

    test('hex/plus forms stay strings', () {
      expect(coerceCliArgValue('0x1F'), '0x1F');
      expect(coerceCliArgValue('+5'), '+5');
    });
  });
}
