// Terminal-style ↑/↓ command history in the USB console.
//
// History is stored oldest-first, so the newest entry is the last one.
// Index -1 means "the draft line the user is currently typing".

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/dev/usb_console_screen.dart';

void main() {
  const len = 3; // ['old', 'mid', 'new']

  group('consoleHistoryIndex', () {
    test('arrow up from draft recalls the newest command', () {
      expect(consoleHistoryIndex(current: -1, delta: -1, length: len), 2);
    });

    test('arrow up keeps walking towards older entries', () {
      expect(consoleHistoryIndex(current: 2, delta: -1, length: len), 1);
      expect(consoleHistoryIndex(current: 1, delta: -1, length: len), 0);
    });

    test('arrow up stops at the oldest entry', () {
      expect(consoleHistoryIndex(current: 0, delta: -1, length: len), 0);
    });

    test('arrow down walks back towards newer entries', () {
      expect(consoleHistoryIndex(current: 0, delta: 1, length: len), 1);
      expect(consoleHistoryIndex(current: 1, delta: 1, length: len), 2);
    });

    test('arrow down past the newest returns to the empty draft', () {
      expect(consoleHistoryIndex(current: 2, delta: 1, length: len), -1);
    });

    test('arrow down on the draft stays on the draft', () {
      // -1 + 1 == 0 would jump to the OLDEST entry, which is not what a
      // terminal does; the draft must stay put.
      expect(consoleHistoryIndex(current: -1, delta: 1, length: len), -1);
    });

    test('single-entry history round-trips', () {
      expect(consoleHistoryIndex(current: -1, delta: -1, length: 1), 0);
      expect(consoleHistoryIndex(current: 0, delta: 1, length: 1), -1);
      expect(consoleHistoryIndex(current: 0, delta: -1, length: 1), 0);
    });
  });
}
