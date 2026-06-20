// Güvenlik.md Madde 9 — per-peer dakika-başı sliding-window rate limit.
//
// Eşzamanlılık cap'i (kMaxRunsPerPeer) anlık yükü sınırlıyordu; bu test
// dakika-başı burst/brute-force sınırını (kMaxRunsPerMinute) doğrular.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/active_runs_registry.dart';
import 'package:skapp/features/skapi/data/run_handle.dart';

ActiveRun _run(String peer, String runId) => ActiveRun(
      runId: runId,
      peerUuid: peer,
      platform: 'win',
      scriptId: 'toast',
      handle: RunHandle(
        scriptId: 'toast',
        output: const Stream.empty(),
        result: Future.value(
          RunResult(exitCode: 0, durationMs: 1, cancelled: false),
        ),
        bufferedOutput: const [],
        onCancel: () {},
      ),
      startedAt: DateTime(2026),
    );

void main() {
  const peer = 'peer-A';
  final t0 = DateTime(2026, 1, 1, 12, 0, 0);

  group('withinRateLimit', () {
    test('boş geçmiş → izinli', () {
      final reg = ActiveRunsRegistry();
      expect(reg.withinRateLimit(peer, now: t0), isTrue);
    });

    test('$kMaxRunsPerMinute. çağrıya kadar izinli, sonrası reddedilir', () {
      final reg = ActiveRunsRegistry();
      // Pencere içinde kMaxRunsPerMinute kadar başlat
      for (var i = 0; i < kMaxRunsPerMinute; i++) {
        expect(reg.withinRateLimit(peer, now: t0.add(Duration(seconds: i))),
            isTrue,
            reason: '$i. run izinli olmalı');
        reg.register(_run(peer, 'r$i'), now: t0.add(Duration(seconds: i)));
      }
      // Cap dolu → bir sonraki reddedilir
      expect(
        reg.withinRateLimit(peer, now: t0.add(const Duration(seconds: 10))),
        isFalse,
      );
    });

    test('pencere kayınca (60sn sonra) yeniden izinli', () {
      final reg = ActiveRunsRegistry();
      for (var i = 0; i < kMaxRunsPerMinute; i++) {
        reg.register(_run(peer, 'r$i'), now: t0.add(Duration(seconds: i)));
      }
      expect(reg.withinRateLimit(peer, now: t0.add(const Duration(seconds: 5))),
          isFalse);
      // İlk timestamp 61sn sonra pencereden düşer → tekrar yer açılır
      expect(
        reg.withinRateLimit(peer, now: t0.add(const Duration(seconds: 61))),
        isTrue,
      );
    });

    test('rate limit per-peer izole', () {
      final reg = ActiveRunsRegistry();
      for (var i = 0; i < kMaxRunsPerMinute; i++) {
        reg.register(_run(peer, 'r$i'), now: t0.add(Duration(seconds: i)));
      }
      expect(reg.withinRateLimit(peer, now: t0), isFalse);
      // Farklı peer etkilenmez
      expect(reg.withinRateLimit('peer-B', now: t0), isTrue);
    });

    test('bitmiş run (cleanup) rate ledger\'dan DÜŞMEZ — zaman tabanlı', () {
      final reg = ActiveRunsRegistry();
      for (var i = 0; i < kMaxRunsPerMinute; i++) {
        reg.register(_run(peer, 'r$i'), now: t0.add(Duration(seconds: i)));
      }
      // Tüm run'lar biter (concurrency sıfırlanır)
      for (var i = 0; i < kMaxRunsPerMinute; i++) {
        reg.cleanup('r$i');
      }
      expect(reg.canStart(peer), isTrue); // concurrency boş
      // ...ama dakika penceresi hâlâ dolu
      expect(reg.withinRateLimit(peer, now: t0.add(const Duration(seconds: 10))),
          isFalse);
    });
  });
}
