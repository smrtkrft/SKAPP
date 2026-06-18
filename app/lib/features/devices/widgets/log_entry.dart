// LogEntry — yapılandırılmış cihaz log kaydı modeli.
// Cihaz tarafındaki sk_log API'sinin (esp32/COMMON_LOG_SPEC.md) ürettiği
// JSON satırlarını typed olarak tutar.

enum LogLevel {
  debug,
  info,
  warn,
  error;

  /// Cihazın gönderdiği tek-harf koddan ("D" / "I" / "W" / "E") parse et.
  static LogLevel fromCode(String? code) {
    switch (code) {
      case 'D':
        return LogLevel.debug;
      case 'I':
        return LogLevel.info;
      case 'W':
        return LogLevel.warn;
      case 'E':
        return LogLevel.error;
    }
    return LogLevel.info;
  }

  /// CLI parametresi ("debug","info","warn","error").
  String get cliName {
    switch (this) {
      case LogLevel.debug:
        return 'debug';
      case LogLevel.info:
        return 'info';
      case LogLevel.warn:
        return 'warn';
      case LogLevel.error:
        return 'error';
    }
  }

  /// UI'de gösterilecek kısa harf.
  String get shortLabel {
    switch (this) {
      case LogLevel.debug:
        return 'D';
      case LogLevel.info:
        return 'I';
      case LogLevel.warn:
        return 'W';
      case LogLevel.error:
        return 'E';
    }
  }

  /// Severity ordering for filtering ("show at least this level").
  int get rank {
    switch (this) {
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 1;
      case LogLevel.warn:
        return 2;
      case LogLevel.error:
        return 3;
    }
  }
}

class LogEntry {
  const LogEntry({
    required this.tsUnix,
    required this.upUs,
    required this.level,
    required this.tag,
    required this.event,
    required this.msg,
  });

  /// 0 ise cihaz saatinin set edilmediği anlamına gelir (UI'de uyarı gösterilir).
  final int tsUnix;

  /// Monotonik uptime mikrosaniye, her zaman geçerli.
  final int upUs;

  final LogLevel level;
  final String tag;
  final String event;
  final String msg;

  /// JSON map'inden parse et. Eski format (`String`) için fallback yapmaz;
  /// bu model sadece yeni structured event format'ını destekler.
  static LogEntry fromJson(Map<String, dynamic> j) {
    return LogEntry(
      tsUnix: (j['ts'] as num?)?.toInt() ?? 0,
      upUs: (j['up_us'] as num?)?.toInt() ?? 0,
      level: LogLevel.fromCode(j['lvl'] as String?),
      tag: (j['tag'] as String?) ?? '?',
      event: (j['event'] as String?) ?? '?',
      msg: (j['msg'] as String?) ?? '',
    );
  }

  /// Cihaz saati geçerli mi (post-2023)?
  bool get hasRealTime => tsUnix > 0;

  /// Formatlı tek-satır gösterim (monospace UI için).
  /// Saat varsa HH:MM:SS, yoksa `+S.s` (uptime saniye).
  String formatLine() {
    final stamp = hasRealTime
        ? _hhmmss(tsUnix)
        : '+${(upUs / 1000000).toStringAsFixed(1)}s';
    final m = msg.isEmpty ? '' : ' $msg';
    return '$stamp ${level.shortLabel} $tag $event$m';
  }

  static String _hhmmss(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: false);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
