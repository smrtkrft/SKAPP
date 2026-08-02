// Firmware sözleşmesi: konsol argüman değerleri HER ZAMAN string gider.
//
// sk_cli.c:sk_cli_arg_named makine modunda cJSON değeri string değilse NULL
// döner; sk_cli_arg_long ise sayısal string'i strtol ile okur. Yani string
// göndermek her iki okuyucu için de çalışır, sayı/bool göndermek string
// bekleyen alanları sessizce düşürür.
//
// Bu bir kez "iyileştirme" sanılıp sayıya çevrildi ve WiFi parolasını
// bozdu: password=12345678 → sk_wifi.c parolayı NULL görür, strncpy
// atlanır, cihaz "ok" der ve ağı PAROLASIZ kaydeder. Bu test o refleksin
// tekrarını engeller.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/dev/usb_console_providers.dart';

void main() {
  group('cliArgValue — firmware string sözleşmesi', () {
    test('sayı gibi görünen değerler string kalır', () {
      expect(cliArgValue('128'), '128');
      expect(cliArgValue('1754169600'), '1754169600'); // time.set unix
      expect(cliArgValue('12345678'), '12345678'); // WiFi parolası
      expect(cliArgValue('-5'), '-5');
      expect(cliArgValue('1.5'), '1.5');
    });

    test('bool/null sözcükleri string kalır', () {
      expect(cliArgValue('true'), 'true');
      expect(cliArgValue('false'), 'false');
      expect(cliArgValue('null'), 'null');
    });

    test('metinler değişmeden geçer', () {
      expect(cliArgValue('ofis_wifi'), 'ofis_wifi');
      expect(cliArgValue('BF-A06TMFSQT'), 'BF-A06TMFSQT');
      expect(cliArgValue(''), '');
    });

    test('dönüş tipi String — sayısal tip sızıntısı olmamalı', () {
      // Tip düzeyinde de sabitle: dönüş `String`, dynamic değil.
      const String v = 'x';
      expect(cliArgValue(v), isA<String>());
      expect(cliArgValue('42'), isA<String>());
    });
  });
}
