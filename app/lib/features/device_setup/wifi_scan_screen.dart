import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'wifi_password_screen.dart';

/// WiFi network picker, first screen of post-pair onboarding.
///
/// Real wire-up: opens the deviceSession (BLE-backed CliClient) and
/// issues `wifi.scan`. The response shape is mirrored from sk_wifi.c:
///   {"id":N,"ok":true,"data":[{"ssid":"...","rssi":-41,"auth":3}, ...]}
/// `auth` is an integer matching wifi_auth_mode_t (0 = open, others =
/// some flavour of WPA). We surface the raw int and translate it in the
/// list tile.
class WifiScanScreen extends ConsumerStatefulWidget {
  const WifiScanScreen({super.key, required this.device});
  final DiscoveredDevice device;

  @override
  ConsumerState<WifiScanScreen> createState() => _WifiScanScreenState();
}

class _WifiScanScreenState extends ConsumerState<WifiScanScreen> {
  bool _scanning = true;
  String? _errorMsg;
  List<_WifiNetwork> _networks = const [];
  final List<String> _trail = [];
  // True after the first attempt errored. Subsequent calls to _runScan
  // (i.e. the user pressed "Tekrar dene") then invalidate the cached
  // session so the next ref.read opens a fresh BLE link instead of
  // re-throwing the cached error. We never invalidate on the FIRST
  // attempt, at that point the session was just opened by
  // pairing_screen._routeAfterPairing and is alive + authenticated;
  // killing it forces a redundant reconnect that often loses the
  // wifi.scan write to a half-closed link.
  bool _hasErroredOnce = false;

  void _trace(String s) {
    debugPrint('[WIFI] $s');
    final ts = DateTime.now();
    final line =
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}.${ts.millisecond.toString().padLeft(3, '0')}  $s';
    if (mounted) {
      setState(() {
        _trail.add(line);
        if (_trail.length > 30) _trail.removeAt(0);
      });
    } else {
      _trail.add(line);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runScan());
  }

  Future<void> _runScan() async {
    setState(() {
      _scanning = true;
      _errorMsg = null;
    });
    try {
      // Only blow away the cached session after a *previous* failure.
      // First-attempt invalidate would discard the live session that
      // pairing_screen just opened in _routeAfterPairing, forcing a
      // redundant reconnect that can lose the wifi.scan write.
      if (_hasErroredOnce) {
        _trace('previous attempt errored, invalidating session');
        ref.invalidate(deviceSessionProvider(widget.device.id));
      }
      _trace('opening session…');
      // 30s: BLE zinciri (mDNS ~1.5s + BLE client.start 15s cap) + eslesme
      // sonrasi yavas Android reconnect 12s'yi asabiliyor ve scan'e ulasmadan
      // timeout dusuyordu. Reconnect yolu (pairing_screen) zaten 30s kullaniyor;
      // wizard da ona hizalandi.
      final session = await ref
          .read(deviceSessionProvider(widget.device.id).future)
          .timeout(const Duration(seconds: 30));
      _trace('session ready, sending wifi.scan');
      final reply = await session.client.send(
        'wifi.scan',
        timeout: const Duration(seconds: 20),
      );
      _trace('reply ok=${reply.ok} err=${reply.err} '
          'dataType=${reply.data?.runtimeType} '
          'len=${reply.data is List ? (reply.data as List).length : (reply.data is Map ? "Map(${(reply.data as Map).keys.toList()})" : "n/a")}');
      if (!reply.ok) {
        if (!mounted) return;
        _fail(AppLocalizations.of(context)
            .wifiScanRejected(reply.err ?? 'ERR_UNKNOWN'));
        return;
      }
      // BF iki şema kullanabilir: doğrudan data=List, veya
      // data={"networks":[...]}/data={"results":[...]}.
      List? raw;
      if (reply.data is List) {
        raw = reply.data as List;
      } else if (reply.data is Map) {
        final m = reply.data as Map;
        raw = (m['networks'] ?? m['results'] ?? m['list']) as List?;
      }
      if (raw == null) {
        if (!mounted) return;
        _fail(AppLocalizations.of(context)
            .wifiScanUnexpectedReply(reply.data.toString()));
        return;
      }
      final list = raw
          .whereType<Map>()
          .map((m) => _WifiNetwork.fromJson(m.cast<String, dynamic>()))
          .where((n) => n.ssid.isNotEmpty)
          .toList()
        ..sort((a, b) => b.rssi.compareTo(a.rssi));
      if (!mounted) return;
      setState(() {
        _networks = list;
        _scanning = false;
      });
      debugPrint('[WIFI] parsed ${list.length} networks');
    } on TimeoutException catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).wifiScanTimeout(e.toString()));
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).wifiScanConnectionError(e.toString()));
    }
  }

  void _fail(String msg) {
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _errorMsg = msg;
      _hasErroredOnce = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(l.wifiScanTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.wifiScanRescanTooltip,
            onPressed: _scanning ? null : _runScan,
          ),
        ],
      ),
      body: SkContent(
        maxWidth: SkBreakpoints.maxContentWidth,
        horizontalPadding: 0,
        child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            color: cs.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.device.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l.wifiScanHeaderHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (_scanning) const LinearProgressIndicator(minHeight: 2),
          Expanded(child: _body(cs)),
        ],
        ),
      ),
    );
  }

  Widget _body(ColorScheme cs) {
    if (_errorMsg != null) {
      return _ErrorView(
          message: _errorMsg!, onRetry: _runScan, trail: _trail);
    }
    final l = AppLocalizations.of(context);
    if (_scanning && _networks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36, height: 36,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Text(l.wifiScanRunning, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    if (_networks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 40, color: cs.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(l.wifiScanNoNetworks,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _runScan,
                icon: const Icon(Icons.refresh),
                label: Text(l.wifiScanRescan),
              ),
              if (_trail.isNotEmpty) ...[
                const SizedBox(height: 16),
                _WifiDebugPanel(trail: _trail),
              ],
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _networks.length + 1,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (ctx, i) {
        if (i == _networks.length) {
          return ListTile(
            leading: const Icon(Icons.add),
            title: Text(l.wifiScanHiddenAdd),
            subtitle: Text(l.wifiScanHiddenSubtitle),
            onTap: () => _openPassword(
              const _WifiNetwork(
                ssid: '',
                rssi: 0,
                auth: 3, // WPA2 default for hidden entry
                hidden: true,
              ),
            ),
          );
        }
        return _NetworkTile(
          network: _networks[i],
          onTap: () => _openPassword(_networks[i]),
        );
      },
    );
  }

  void _openPassword(_WifiNetwork n) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WifiPasswordScreen(
          device: widget.device,
          ssid: n.ssid,
          authMode: n.auth,
          hidden: n.hidden,
        ),
      ),
    );
  }
}

class _WifiNetwork {
  const _WifiNetwork({
    required this.ssid,
    required this.rssi,
    required this.auth,
    this.hidden = false,
  });
  factory _WifiNetwork.fromJson(Map<String, dynamic> j) => _WifiNetwork(
        ssid: (j['ssid'] as String?) ?? '',
        rssi: (j['rssi'] as num?)?.toInt() ?? -100,
        auth: (j['auth'] as num?)?.toInt() ?? 3,
      );
  final String ssid;
  final int rssi;

  /// wifi_auth_mode_t int: 0=open, 1=WEP, 2=WPA, 3=WPA2, 4=WPA/WPA2,
  /// 6=WPA3, 7=WPA2/WPA3, ...
  final int auth;
  final bool hidden;

  bool get isOpen => auth == 0;
}

class _NetworkTile extends StatelessWidget {
  const _NetworkTile({required this.network, required this.onTap});
  final _WifiNetwork network;
  final VoidCallback onTap;

  String _authLabel(AppLocalizations l) => switch (network.auth) {
        0 => l.wifiScanAuthOpen,
        1 => 'WEP',
        2 => 'WPA',
        3 => 'WPA2',
        4 => 'WPA/WPA2',
        6 => 'WPA3',
        7 => 'WPA2/WPA3',
        _ => l.wifiScanAuthEncrypted,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return ListTile(
      leading: _SignalBars(rssi: network.rssi),
      title: Text(network.ssid),
      subtitle: Text('${_authLabel(l)}  •  ${network.rssi} dBm'),
      trailing: network.isOpen
          ? Icon(Icons.lock_open, color: cs.onSurfaceVariant)
          : Icon(Icons.lock_outline, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.rssi});
  final int rssi;

  int get _level {
    if (rssi >= -55) return 4;
    if (rssi >= -67) return 3;
    if (rssi >= -75) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 28,
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (i) {
          final filled = i < _level;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 4,
              height: 6.0 + i * 4,
              decoration: BoxDecoration(
                color: filled
                    ? cs.primary
                    : cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    this.trail = const [],
  });
  final String message;
  final VoidCallback onRetry;
  final List<String> trail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40, color: cs.error),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context).commonRetry),
          ),
          if (trail.isNotEmpty) ...[
            const SizedBox(height: 16),
            _WifiDebugPanel(trail: trail),
          ],
        ],
      ),
    );
  }
}

class _WifiDebugPanel extends StatelessWidget {
  const _WifiDebugPanel({required this.trail});
  final List<String> trail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, size: 14, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).wifiScanLogTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              IconButton(
                tooltip: AppLocalizations.of(context).settingsNetworkIdentityCopy,
                icon: const Icon(Icons.copy, size: 16),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: trail.join('\n')));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context).wifiPasswordLogCopied)),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 8),
          Flexible(
            child: SingleChildScrollView(
              reverse: true,
              child: SelectableText(
                trail.join('\n'),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
