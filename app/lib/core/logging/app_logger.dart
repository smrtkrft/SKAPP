import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// App-wide diagnostic logger for the public beta.
///
/// Captures (a) every `debugPrint` — wired once in `main.dart` so the ~130
/// existing call sites are recorded for free, and (b) uncaught Flutter /
/// platform / zone errors via the handlers installed in `main.dart`. Writes a
/// rotating newline-delimited file at `<appSupport>/skapp_logs/skapp.log`.
///
/// Design mirrors [RemoteRunAuditLog]: a JSONL/text ring buffer on disk (no
/// SQLite/FFI), capped at [_maxLines] and compacted once it grows past
/// [_maxLines] * [_compactFactor]; appends are O(1) between rewrites. An
/// in-RAM ring buffer ([_ramCapacity] lines) backs export even if a disk
/// write is mid-flight or the file could not be opened.
///
/// Privacy: this is local-only. Nothing is uploaded; logs leave the device
/// ONLY when the user explicitly exports/shares them (Settings → Diagnostics),
/// preserving SKAPP's "no cloud, no telemetry" property. Like the audit log,
/// callers must log keys/messages — never secret values.
class AppLogger {
  AppLogger._();

  /// Process-wide singleton.
  static final AppLogger instance = AppLogger._();

  static const int _maxLines = 5000;
  static const double _compactFactor = 1.25;
  static const int _ramCapacity = 500;

  File? _file;
  bool _ready = false;
  int _linesSinceLoad = 0;
  final Queue<String> _ram = Queue<String>();

  bool get isReady => _ready;

  /// The backing log file, or null on web / before [init] / on init failure.
  File? get file => _file;

  /// Resolves `<appSupport>/skapp_logs/skapp.log`, creating the directory.
  /// Best-effort: failure leaves the logger in RAM-only mode (never throws).
  Future<void> init() async {
    if (kIsWeb) {
      _ready = false;
      return;
    }
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/skapp_logs');
      if (!await dir.exists()) await dir.create(recursive: true);
      final f = File('${dir.path}/skapp.log');
      _file = f;
      if (await f.exists()) {
        _linesSinceLoad = (await f.readAsLines()).length;
      }
      _ready = true;
      log('AppLogger initialised', level: 'I');
    } catch (e) {
      _ready = false;
      // debugPrint is not yet overridden at init time, so this is safe.
      debugPrint('[app-logger] init failed: $e');
    }
  }

  /// Records a single line (RAM buffer + best-effort file append).
  void log(String message, {String level = 'I'}) {
    final line = '${DateTime.now().toUtc().toIso8601String()} $level $message';
    _ram.addLast(line);
    while (_ram.length > _ramCapacity) {
      _ram.removeFirst();
    }
    unawaited(_appendToFile(line));
  }

  /// Records an uncaught error + stack from the global handlers.
  void record(Object error, StackTrace? stack, {String source = 'app'}) {
    log('UNCAUGHT[$source]: $error', level: 'E');
    if (stack != null) log(stack.toString(), level: 'E');
  }

  Future<void> _appendToFile(String line) async {
    final f = _file;
    if (f == null || !_ready) return;
    try {
      await f.writeAsString('$line\n', mode: FileMode.append, flush: false);
      _linesSinceLoad++;
      if (_linesSinceLoad > _maxLines * _compactFactor) {
        await _compact();
      }
    } catch (_) {
      // Logging must never break the app — swallow IO errors silently
      // (and never debugPrint here, to avoid feedback loops).
    }
  }

  Future<void> _compact() async {
    final f = _file;
    if (f == null) return;
    try {
      final lines = await f.readAsLines();
      if (lines.length <= _maxLines) {
        _linesSinceLoad = lines.length;
        return;
      }
      final kept = lines.sublist(lines.length - _maxLines);
      await f.writeAsString('${kept.join('\n')}\n');
      _linesSinceLoad = kept.length;
    } catch (_) {
      // Best-effort; keep appending if compaction fails.
    }
  }

  /// Full on-disk log text, falling back to the RAM buffer.
  Future<String> dump() async {
    final f = _file;
    if (f != null) {
      try {
        if (await f.exists()) return await f.readAsString();
      } catch (_) {
        // Fall through to RAM.
      }
    }
    return _ram.join('\n');
  }

  /// Deletes the persisted log + clears RAM (Factory Reset path).
  Future<void> clear() async {
    _ram.clear();
    _linesSinceLoad = 0;
    final f = _file;
    if (f == null) return;
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {
      // Best-effort.
    }
  }
}
