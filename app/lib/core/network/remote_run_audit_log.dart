import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:path_provider/path_provider.dart';

import 'remote_run_activity_provider.dart';

/// Persistent, append-only forensic log of remote-run activity
/// (güvenlik.md Madde 10). The in-RAM ring buffer (`remoteRunActivityProvider`)
/// is dropped on every listener restart; this survives so the desktop owner
/// can answer "which peer ran what, when" after a suspected token leak.
///
/// Storage: newline-delimited JSON at
/// `<appSupport>/skapp_audit/remote_runs.jsonl`, capped to [maxRecords]
/// entries. We avoid a SQLite dependency (and its desktop FFI setup) on
/// purpose — a JSONL ring buffer covers the forensic need with zero new
/// packages. The cap is enforced by rewriting the file once it grows past
/// [maxRecords] * [_compactFactor]; between rewrites it appends in O(1).
///
/// Only override KEYS are persisted (never values), matching the RAM card —
/// the log itself must not become a content-leak surface.
class RemoteRunAuditLog {
  RemoteRunAuditLog({required this.file, this.maxRecords = 1000});

  /// Default on-disk location under the OS application-support directory.
  /// Returns null on web (no file system / no listener there anyway).
  static Future<RemoteRunAuditLog?> defaultLocation({int maxRecords = 1000}) async {
    if (kIsWeb) return null;
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/skapp_audit');
      if (!await dir.exists()) await dir.create(recursive: true);
      return RemoteRunAuditLog(
        file: File('${dir.path}/remote_runs.jsonl'),
        maxRecords: maxRecords,
      );
    } catch (e) {
      debugPrint('[audit-log] defaultLocation failed: $e');
      return null;
    }
  }

  final File file;
  final int maxRecords;

  /// Rewrite/compact once the file holds this multiple of [maxRecords].
  static const double _compactFactor = 1.25;

  int _linesSinceLoad = 0;

  /// Appends [entry] as one JSON line. Best-effort: any IO error is logged
  /// and swallowed so audit persistence can never break the run path.
  Future<void> append(RemoteRunActivity entry) async {
    try {
      await file.writeAsString(
        '${jsonEncode(entry.toJson())}\n',
        mode: FileMode.append,
        flush: false,
      );
      _linesSinceLoad++;
      if (_linesSinceLoad > maxRecords * _compactFactor) {
        await _compact();
      }
    } catch (e) {
      debugPrint('[audit-log] append failed: $e');
    }
  }

  /// Loads the most recent [maxRecords] entries, newest first (matching the
  /// RAM buffer's ordering). Returns empty on any error or missing file.
  Future<List<RemoteRunActivity>> loadRecent() async {
    try {
      if (!await file.exists()) return const [];
      final lines = await file.readAsLines();
      _linesSinceLoad = lines.length;
      final kept = lines.length > maxRecords
          ? lines.sublist(lines.length - maxRecords)
          : lines;
      final out = <RemoteRunActivity>[];
      for (final line in kept) {
        if (line.trim().isEmpty) continue;
        try {
          final entry = RemoteRunActivity.fromJson(
            jsonDecode(line) as Map<String, dynamic>,
          );
          if (entry != null) out.add(entry);
        } catch (_) {
          // Skip a corrupt line rather than failing the whole load.
        }
      }
      // File is oldest-first; the UI/RAM buffer is newest-first.
      return out.reversed.toList(growable: false);
    } catch (e) {
      debugPrint('[audit-log] loadRecent failed: $e');
      return const [];
    }
  }

  /// Rewrites the file with only the most recent [maxRecords] lines.
  Future<void> _compact() async {
    try {
      final lines = await file.readAsLines();
      if (lines.length <= maxRecords) {
        _linesSinceLoad = lines.length;
        return;
      }
      final kept = lines.sublist(lines.length - maxRecords);
      await file.writeAsString('${kept.join('\n')}\n');
      _linesSinceLoad = kept.length;
    } catch (e) {
      debugPrint('[audit-log] compact failed: $e');
    }
  }

  /// Deletes the persisted log (Reset/Factory Reset path).
  Future<void> clear() async {
    try {
      if (await file.exists()) await file.delete();
      _linesSinceLoad = 0;
    } catch (e) {
      debugPrint('[audit-log] clear failed: $e');
    }
  }
}
