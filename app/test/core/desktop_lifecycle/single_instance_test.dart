// Güvenlik.md Madde 11 — focus IPC magic-string gate.
//
// Önceden loopback listener gelen HER bağlantıda onFocus() çağırıyordu;
// artık ilk satır SKAPP_FOCUS_v1 magic'iyle eşleşmek zorunda. Bu test
// sözleşmeyi kilitler: eski `FOCUS` payload'u reddedilir, yeni magic kabul.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/desktop_lifecycle/single_instance.dart';

void main() {
  group('SingleInstance.isFocusCommand', () {
    test('geçerli magic kabul edilir', () {
      expect(SingleInstance.isFocusCommand('SKAPP_FOCUS_v1'), isTrue);
    });

    test('trailing CR/LF/boşluk tolere edilir (client \\n yazıyor)', () {
      expect(SingleInstance.isFocusCommand('SKAPP_FOCUS_v1\n'), isTrue);
      expect(SingleInstance.isFocusCommand('SKAPP_FOCUS_v1\r\n'), isTrue);
      expect(SingleInstance.isFocusCommand('  SKAPP_FOCUS_v1  '), isTrue);
    });

    test('Madde 11 öncesi FOCUS payload\'u artık REDDEDİLİR', () {
      expect(SingleInstance.isFocusCommand('FOCUS'), isFalse);
      expect(SingleInstance.isFocusCommand('FOCUS\n'), isFalse);
    });

    test('boş / yabancı / kısmi payload reddedilir', () {
      expect(SingleInstance.isFocusCommand(''), isFalse);
      expect(SingleInstance.isFocusCommand('hello'), isFalse);
      expect(SingleInstance.isFocusCommand('SKAPP_FOCUS'), isFalse);
      expect(SingleInstance.isFocusCommand('SKAPP_FOCUS_v2'), isFalse);
      expect(SingleInstance.isFocusCommand('skapp_focus_v1'), isFalse);
    });
  });
}
