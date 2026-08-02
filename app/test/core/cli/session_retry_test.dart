// Riverpod 3'ün varsayılan retry'ı, eşleştirme akışının tipli hatalarını
// (PairingRequiredException gibi) 10 kez artan gecikmeyle sessizce yeniden
// dener ve provider.future'ı beklemede tutar. Bu, "cihaz fabrika sıfırlandı →
// yeniden eşleş diyaloğunu aç" gibi kararların ekrana HİÇ ulaşmamasına yol
// açıyordu (ekran ~98 s sonra jenerik timeout görüyordu).

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/ble_transport.dart' show PairingRequiredException;
import 'package:skapp/core/cli/cli_providers.dart';
import 'package:skapp/core/cli/cli_session.dart';

void main() {
  group('sessionRetryPolicy', () {
    test('never retries — transport chain has its own fallbacks', () {
      final errors = <Object>[
        const PairingRequiredException('no_bond'),
        BondMissingException('BF-TEST'),
        DeviceUnreachableException(const ['TCP: yok']),
        TimeoutException('slow'),
        Exception('generic'),
      ];
      for (final e in errors) {
        expect(sessionRetryPolicy(0, e), isNull,
            reason: '$e retry edilmemeli (ilk deneme)');
        expect(sessionRetryPolicy(3, e), isNull, reason: '$e hiç retry edilmemeli');
      }
    });
  });

  group('deviceSessionProvider', () {
    test('carries the no-retry policy (not Riverpod default)', () {
      final provider = deviceSessionProvider('BF-TEST');
      expect(provider.retry, isNotNull,
          reason: 'null retry → container defaultRetry devreye girer');
      expect(provider.retry!(0, const PairingRequiredException('no_bond')), isNull);
    });

    test('typed pairing error surfaces immediately, without backoff', () async {
      // Gerçek container: retry override YOK (üretimdeki ProviderScope gibi).
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final probe = FutureProvider<int>(
        (ref) async => throw const PairingRequiredException('no_bond'),
        retry: sessionRetryPolicy,
      );

      final sw = Stopwatch()..start();
      final completer = Completer<Object>();
      void report(Object e) {
        if (!completer.isCompleted) completer.complete(e);
      }

      // Riverpod 3'te FutureProvider hatası duruma göre listener'a AsyncError
      // olarak ya da onError'a gelir (bkz. transport_selector_test._run).
      final sub = c.listen<AsyncValue<int>>(probe, (_, next) {
        if (next is AsyncError) report(next.error!);
      }, fireImmediately: true, onError: (e, _) => report(e));
      addTearDown(sub.close);

      final err = await completer.future.timeout(const Duration(seconds: 2));
      sw.stop();
      expect(err, isA<PairingRequiredException>());
      // defaultRetry olsaydı ilk yeniden deneme 200 ms sonra olur ve hata
      // ancak ~44 s'lik backoff zincirinin sonunda yüzeye çıkardı.
      expect(sw.elapsedMilliseconds, lessThan(150),
          reason: 'hata gecikmesiz yüzeye çıkmalı');
    });
  });
}
