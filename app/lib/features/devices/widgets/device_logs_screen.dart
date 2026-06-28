// DeviceLogsScreen — cihaz tipinden bağımsız, BF ve LS için ortak log
// görüntüleyici. `logs.get --level <lvl>` çağırır, yeni structured event
// formatını (esp32/COMMON_LOG_SPEC.md) parse edip listeler. Severity
// filter chip'leri, refresh, ve cihaz saati yoksa uyarı banner'ı içerir.

import 'package:flutter/material.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'log_entry.dart';

class DeviceLogsScreen extends StatefulWidget {
  const DeviceLogsScreen({
    super.key,
    required this.client,
    required this.deviceId,
    required this.title,
  });

  /// Cihaza komut gönderen authenticated CLI client (BfSession / LsSession
  /// üzerinden gelir).
  final CliClient client;

  /// Sadece log/debug için; UI'de gösterilmez.
  final String deviceId;

  /// AppBar başlığı (cihaz adı veya jenerik "Logs").
  final String title;

  @override
  State<DeviceLogsScreen> createState() => _DeviceLogsScreenState();
}

class _DeviceLogsScreenState extends State<DeviceLogsScreen> {
  List<LogEntry> _entries = const [];
  String? _error;
  bool _loading = true;
  bool _truncated = false;
  bool _bootstrapped = false;
  LogLevel _minLevel = LogLevel.info;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    _refresh();
  }

  Future<void> _refresh() async {
    if (mounted) setState(() => _loading = true);
    final l = AppLocalizations.of(context);
    try {
      final r = await widget.client.send(
        'logs.get',
        args: {'level': _minLevel.cliName, 'limit': 200},
      );
      if (!mounted) return;
      if (!r.ok) {
        setState(() {
          _error = r.err == 'ERR_UNKNOWN_COMMAND'
              ? l.bfLogsUnsupported
              : (r.err ?? l.commonReadFailed);
          _loading = false;
        });
        return;
      }
      final data = r.data;
      final lines = (data is Map ? data['lines'] : null);
      final entries = <LogEntry>[];
      if (lines is List) {
        for (final item in lines) {
          if (item is Map<String, dynamic>) {
            entries.add(LogEntry.fromJson(item));
          } else if (item is Map) {
            entries.add(LogEntry.fromJson(item.cast<String, dynamic>()));
          }
          // Eski string format'ı sessizce atla — yeni firmware formatına
          // göre güncellenmiş cihazlardan yalnız typed entry beklenir.
        }
      }
      final truncated = data is Map && data['truncated'] == true;
      setState(() {
        _entries = entries;
        _truncated = truncated;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _levelColor(LogLevel level, ColorScheme cs) {
    switch (level) {
      case LogLevel.debug:
        return cs.onSurfaceVariant.withValues(alpha: 0.55);
      case LogLevel.info:
        return cs.onSurface;
      case LogLevel.warn:
        // Log metni okunabilirliği için koyulaştırılmış hardal (palet ailesi;
        // parlak #D4A017 cream zeminde düşük kontrast verdiğinden bilinçli
        // istisna — tasarim.md mustard'ın text-on-light türevi).
        return const Color(0xFFB37A00);
      case LogLevel.error:
        return cs.error; // = SkColors.warnRed (tema token)
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    final anyTimeUnknown = _entries.any((e) => !e.hasRealTime);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: l.commonRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refresh,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: Column(
        children: [
          // Severity filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Wrap(
              spacing: 6,
              children: [
                for (final lvl in LogLevel.values)
                  ChoiceChip(
                    label: Text(lvl.cliName),
                    selected: _minLevel == lvl,
                    onSelected: (sel) {
                      if (!sel) return;
                      setState(() => _minLevel = lvl);
                      _refresh();
                    },
                  ),
              ],
            ),
          ),

          if (anyTimeUnknown)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SkNeuCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        // Cihazda saat set edilmemiş; zaman damgaları uptime
                        // bazlı (+S.s) gösterilir.
                        l.deviceLogsNoClockBanner,
                        style: TextStyle(
                            fontSize: 12, color: cs.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                      children: [
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SkNeuCard(
                              padding: const EdgeInsets.all(12),
                              child: Text(_error!),
                            ),
                          ),
                        if (_error == null && _entries.isEmpty)
                          SkNeuCard(
                            padding: const EdgeInsets.all(16),
                            child: Text(l.bfLogsBufferEmpty),
                          ),
                        if (_entries.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: cs.outlineVariant, width: 0.5),
                            ),
                            child: SelectableText.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  height: 1.55,
                                ),
                                children: [
                                  for (final e in _entries) ...[
                                    TextSpan(
                                      text: e.formatLine(),
                                      style: TextStyle(
                                          color: _levelColor(e.level, cs)),
                                    ),
                                    const TextSpan(text: '\n'),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        if (_truncated)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              // Cihazın yanıtı 8KB buffer'ı doldurdu, bazı
                              // kayıtlar atlandı. --limit veya --level ile daraltın.
                              l.deviceLogsTruncatedHint,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: cs.onSurfaceVariant),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
        ),
      ),
    );
  }
}
