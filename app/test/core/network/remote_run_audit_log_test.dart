// Güvenlik.md Madde 10 — kalıcı remote-run audit log (JSONL ring buffer).
//
// Temp dosya ile test edilir; path_provider plugin'i gerekmez. Round-trip
// serialization, newest-first ordering, ring-buffer cap ve clear doğrulanır.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/network/remote_run_activity_provider.dart';
import 'package:skapp/core/network/remote_run_audit_log.dart';

RemoteRunActivity _entry(String runId, {int i = 0}) => RemoteRunActivity(
      when: DateTime(2026, 1, 1, 12, 0, i),
      runId: runId,
      peerUuid: 'peer-$runId',
      peerName: 'Phone $runId',
      platform: 'win',
      scriptId: 'toast',
      outcome: RemoteRunOutcome.completed,
      statusCode: 200,
      exitCode: 0,
      durationMs: 12,
      paramOverrideKeys: const ['message'],
    );

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('skapp_audit_test');
  });

  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  RemoteRunAuditLog log({int maxRecords = 1000}) => RemoteRunAuditLog(
        file: File('${tmp.path}/remote_runs.jsonl'),
        maxRecords: maxRecords,
      );

  test('toJson/fromJson round-trip alanları korur (değer sızıntısı yok)', () {
    final e = _entry('r1');
    final back = RemoteRunActivity.fromJson(e.toJson())!;
    expect(back.runId, 'r1');
    expect(back.peerUuid, 'peer-r1');
    expect(back.scriptId, 'toast');
    expect(back.outcome, RemoteRunOutcome.completed);
    expect(back.statusCode, 200);
    expect(back.paramOverrideKeys, ['message']);
  });

  test('append + loadRecent newest-first döner', () async {
    final l = log();
    await l.append(_entry('r1', i: 1));
    await l.append(_entry('r2', i: 2));
    await l.append(_entry('r3', i: 3));
    final loaded = await l.loadRecent();
    expect(loaded.map((e) => e.runId).toList(), ['r3', 'r2', 'r1']);
  });

  test('eksik dosya → boş liste', () async {
    expect(await log().loadRecent(), isEmpty);
  });

  test('ring buffer maxRecords ile sınırlanır (compact)', () async {
    final l = log(maxRecords: 5);
    // compactFactor 1.25 → 5*1.25=6.25, 7. append'te compact tetiklenir
    for (var i = 0; i < 20; i++) {
      await l.append(_entry('r$i', i: i));
    }
    final loaded = await l.loadRecent();
    expect(loaded.length, lessThanOrEqualTo(5));
    // En yeni kayıt korunmalı
    expect(loaded.first.runId, 'r19');
  });

  test('clear dosyayı siler', () async {
    final l = log();
    await l.append(_entry('r1'));
    await l.clear();
    expect(await l.loadRecent(), isEmpty);
  });

  test('bozuk satır load\'u bozmaz (skip)', () async {
    final f = File('${tmp.path}/remote_runs.jsonl');
    await f.writeAsString('not-json\n${'{"bad":'}\n');
    final l = log();
    await l.append(_entry('good'));
    final loaded = await l.loadRecent();
    expect(loaded.map((e) => e.runId), contains('good'));
  });
}
