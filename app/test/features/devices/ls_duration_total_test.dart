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
}
