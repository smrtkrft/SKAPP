// Firmware sözleşmesi: makine modunda `sk_cli_arg_named` STRING olmayan
// cJSON değeri için NULL döner (sk_cli.c:209-227); `sk_cli_arg_long` ise
// hem sayıyı hem sayısal string'i kabul eder (sk_cli.c:229-261).
//
// Sonuç: named argümanı STRING göndermek her iki okuyucuda da çalışır,
// sayı göndermek ise string bekleyen alanı SESSİZCE düşürür — cihaz
// komutu eksik argümanla işler ya da reddeder, uygulama "ok" görebilir.
// Bu bir kez `time.set` ile yaşandı (cihaz saati 1970'te kaldı) ve bir kez
// `vacation.set` ile: ölü-adam anahtarı cihazında "tatil" göründü ama geri
// sayım devam etti.
//
// Bu test kaynak kodu tarar: CLI `args:` haritalarında sayı/bool literal
// bırakılmasını engeller.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CLI args map hiçbir yerde sayı/bool literal göndermiyor', () {
    final offenders = <String>[];
    // `args: { ... }` ve `_send('cmd', { ... })` biçimlerindeki değerleri
    // yakala; string ('...'), değişken, çağrı ve koleksiyonlar serbest —
    // yalnız çıplak sayı / true / false yasak.
    final argMap = RegExp(r"args:\s*\{([^}]*)\}|_send\(\s*'[^']+'\s*,\s*\{([^}]*)\}");
    final badValue = RegExp(r"'[A-Za-z_][\w-]*'\s*:\s*(-?\d+(\.\d+)?|true|false)\s*[,}]");

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final src = entity.readAsStringSync();
      for (final m in argMap.allMatches(src)) {
        final body = m.group(1) ?? m.group(2) ?? '';
        for (final bad in badValue.allMatches(body)) {
          final line = '\n'.allMatches(src.substring(0, m.start)).length + 1;
          offenders.add('${entity.path}:$line → ${bad.group(0)!.trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'CLI named argümanları string olmalı (firmware '
          'sk_cli_arg_named string-only). Sayıyı "\$deger" olarak gönder.\n'
          '${offenders.join('\n')}',
    );
  });
}
