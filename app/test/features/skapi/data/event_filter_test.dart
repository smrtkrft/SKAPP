// Faz 1 — saf-mantık testi: EventFilter.match.
//
// EventFilter ([lib/features/skapi/data/event_filter.dart]) ActionBinding'in
// eventFilter alanını cihaz olayına eşler. Üç biçim: exact, `*` (hepsi),
// `prefix.*` (nokta sınırlı önek). Bu test mevcut davranışı kilitler;
// Faz 3'te validasyon yayılırken referans olur.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/event_filter.dart';

void main() {
  group('EventFilter.match · exact', () {
    test('aynı string eşleşir', () {
      expect(EventFilter.match('timer.expired', 'timer.expired'), isTrue);
    });
    test('farklı string eşleşmez', () {
      expect(EventFilter.match('timer.expired', 'timer.started'), isFalse);
    });
  });

  group('EventFilter.match · wildcard *', () {
    test('* her olayı eşler', () {
      expect(EventFilter.match('*', 'anything.at.all'), isTrue);
      expect(EventFilter.match('*', 'x'), isTrue);
    });
  });

  group('EventFilter.match · prefix.*', () {
    test('timer.* → timer.expired eşleşir', () {
      expect(EventFilter.match('timer.*', 'timer.expired'), isTrue);
      expect(EventFilter.match('timer.*', 'timer.started'), isTrue);
    });
    test('timer.* → çok segmentli devamı eşler', () {
      expect(EventFilter.match('timer.*', 'timer.state.changed'), isTrue);
    });
    test('nokta sınırı: timer.* → timerextra.foo eşleşmez', () {
      expect(EventFilter.match('timer.*', 'timerextra.foo'), isFalse);
    });
    test('prefix.* → çıplak prefix (nokta yok) eşleşmez', () {
      expect(EventFilter.match('timer.*', 'timer'), isFalse);
    });
  });

  group('EventFilter.match · boş girdi', () {
    test('boş filtre eşleşmez', () {
      expect(EventFilter.match('', 'timer.expired'), isFalse);
    });
    test('boş olay eşleşmez', () {
      expect(EventFilter.match('timer.expired', ''), isFalse);
    });
    test('iki boş eşleşmez', () {
      expect(EventFilter.match('', ''), isFalse);
    });
  });
}
