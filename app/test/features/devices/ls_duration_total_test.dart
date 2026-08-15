// H1 regresyonu · hero halkasının dolabilmesi bu türetmeye bağlı.
//
// Hata: `_totalSec` `final int = 0` idi ve hiç atanmıyordu; `remaining /
// total` hep 0 çıkıyor (halka hiç dolmuyor), `_onReset` de ekrana
// 00:00:00 yazıyordu. Duration bölümü artık `onTotalChanged` ile saniyeyi
// yukarı itiyor — bu test o türetmeyi sabitler.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/devices/lebensspur/widgets/sections/ls_section_duration.dart';

void main() {
  group('lsDurationTotalSeconds', () {
    test('firmware birimlerini saniyeye çevirir', () {
      expect(lsDurationTotalSeconds('minute', 1), 60);
      expect(lsDurationTotalSeconds('minute', 45), 45 * 60);
      expect(lsDurationTotalSeconds('hour', 1), 3600);
      expect(lsDurationTotalSeconds('hour', 12), 12 * 3600);
      expect(lsDurationTotalSeconds('day', 1), 86400);
      expect(lsDurationTotalSeconds('day', 30), 30 * 86400);
    });

    test('bilinmeyen birim gün sayılır (cihaz varsayılanı)', () {
      expect(lsDurationTotalSeconds('week', 2), 2 * 86400);
      expect(lsDurationTotalSeconds('', 5), 5 * 86400);
    });

    test('sonuç her zaman pozitif ve halka oranı 0..1 aralığında', () {
      // Hero: fraction = remaining / total. total 0 olursa oran sabit 0
      // kalır — hatanın ta kendisi. Türetme asla 0 dönmemeli.
      for (final unit in ['minute', 'hour', 'day']) {
        for (final v in [1, 30, 60]) {
          final total = lsDurationTotalSeconds(unit, v);
          expect(total, greaterThan(0), reason: '$unit/$v');
          final fraction = (total ~/ 2) / total;
          expect(fraction, closeTo(0.5, 0.01));
        }
      }
    });
  });
  _alarmRuleTests();
}

// ── Alarm kuralı · firmware ls_timer_engine ile aynı sözleşme ────────
//
// Alarmlar sondan geriye 1 birim arayla dizilir: N. alarm "N birim kala"
// çalar. N == value olsaydı alarm geri sayım daha BAŞLARKEN çalardı
// (remaining == total == eşik). Bu yüzden alarm sayısı value'dan küçük
// olmalı — 24 saat için en fazla 23.
void _alarmRuleTests() {
  group('alarm kuralı', () {
    bool valid(int alarms, int value) =>
        alarms >= 0 && alarms <= kLsMaxAlarms && alarms < value;

    test('24 saat → 23 alarm geçerli, 24 değil', () {
      expect(valid(23, 24), isTrue);
      expect(valid(24, 24), isFalse, reason: 'başlangıçta çalardı');
      expect(valid(25, 24), isFalse);
    });

    test('küçük değerlerde sınır', () {
      expect(valid(0, 1), isTrue, reason: 'alarmsız 1 birim geçerli');
      expect(valid(1, 1), isFalse, reason: '1 birim → alarm kurulamaz');
      expect(valid(2, 3), isTrue);
      expect(valid(3, 3), isFalse);
    });

    test('mutlak tavan maske genişliği (31)', () {
      expect(kLsMaxAlarms, 31);
      expect(valid(31, 60), isTrue);
      expect(valid(32, 60), isFalse, reason: 'maskeye sığmaz');
    });

    test('60 gün en uzun süre · 31 alarm ile birlikte geçerli', () {
      expect(lsDurationTotalSeconds('day', 60), 60 * 86400);
      expect(valid(31, 60), isTrue);
    });
  });
}
