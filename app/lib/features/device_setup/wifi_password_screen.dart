import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'wifi_success_screen.dart';

/// WiFi password / SSID-finalisation screen.
///
/// Real wire-up:
///   1. `wifi.connect` { ssid, password }, non-critical, no confirm token
///      (BF firmware: physical USB or post-handshake auth already gates
///      WiFi writes; sk_wifi.c marks the command non-critical on purpose)
///   2. Wait for {"ok":true,"data":{...}} or err
///   3. Forward to WifiSuccessScreen which handles time.set + device.info
class WifiPasswordScreen extends ConsumerStatefulWidget {
  const WifiPasswordScreen({
    super.key,
    required this.device,
    required this.ssid,
    required this.authMode,
    this.hidden = false,
  });
  final DiscoveredDevice device;
  final String ssid;

  /// wifi_auth_mode_t int (0 = open, 3 = WPA2, …).
  final int authMode;
  final bool hidden;

  @override
  ConsumerState<WifiPasswordScreen> createState() =>
      _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends ConsumerState<WifiPasswordScreen> {
  late final TextEditingController _ssid =
      TextEditingController(text: widget.ssid);
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _connecting = false;
  String? _errorMsg;

  /// Diagnostic trail, surfaced under the error card so a failed
  /// connect attempt shows what was sent and what came back, without
  /// needing logcat. Mirrors the pattern in wifi_scan_screen.
  final List<String> _trail = [];

  void _trace(String s) {
    debugPrint('[WIFI-PASS] $s');
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
  void dispose() {
    _ssid.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _needsPassword => widget.authMode != 0;

  Future<void> _connect() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _connecting = true;
      _errorMsg = null;
      _trail.clear();
    });

    try {
      _trace('opening session for ${widget.device.id}');
      final session = await ref
          .read(deviceSessionProvider(widget.device.id).future)
          .timeout(const Duration(seconds: 12));
      _trace('session ready');

      // wifi.connect, wait up to 25 s, BF tries to associate. BF marks
      // this command as non-critical, so no confirm token is needed.
      final args = <String, dynamic>{'ssid': _ssid.text.trim()};
      if (_needsPassword) args['password'] = _password.text;
      _trace('sending wifi.connect ssid="${args['ssid']}"'
          '${_needsPassword ? ' (password=${_password.text.length} chars)' : ' (open)'}');

      final reply = await session.client.send(
        'wifi.connect',
        args: args,
        timeout: const Duration(seconds: 25),
      );
      _trace('reply ok=${reply.ok} err=${reply.err}'
          ' data=${reply.data} params=${reply.params}');

      if (!reply.ok) {
        if (!mounted) return;
        throw AppLocalizations.of(context)
            .wifiPasswordConnectionRejected(reply.err ?? 'ERR_UNKNOWN');
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WifiSuccessScreen(
            device: widget.device,
            ssid: _ssid.text.trim(),
          ),
        ),
      );
    } on TimeoutException {
      if (!mounted) return;
      _showError(AppLocalizations.of(context).wifiPasswordTimeout);
    } catch (e) {
      _showError('$e');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    setState(() {
      _connecting = false;
      _errorMsg = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(l.wifiPasswordTitle)),
      body: SafeArea(
        child: SkContent(
          maxWidth: SkBreakpoints.maxContentWidth,
          horizontalPadding: 24,
          child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.device.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        )),
                const SizedBox(height: 16),
                if (widget.hidden)
                  TextFormField(
                    controller: _ssid,
                    decoration: InputDecoration(
                      labelText: l.wifiPasswordSsidLabel,
                      prefixIcon: const Icon(Icons.wifi),
                    ),
                    autocorrect: false,
                    enableSuggestions: false,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(32),
                    ],
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'SSID' : null,
                  )
                else
                  TextField(
                    controller: _ssid,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l.wifiPasswordNetworkLabel,
                      prefixIcon: const Icon(Icons.wifi),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_needsPassword)
                  TextFormField(
                    controller: _password,
                    obscureText: !_showPassword,
                    autofocus: !widget.hidden,
                    decoration: InputDecoration(
                      labelText: l.wifiPasswordPasswordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _showPassword = !_showPassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 8) {
                        return l.wifiPasswordMinLength;
                      }
                      return null;
                    },
                  )
                else
                  SkNeuCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(Icons.lock_open, color: cs.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.wifiPasswordHelp,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMsg != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_errorMsg!,
                        style: TextStyle(color: cs.onErrorContainer)),
                  ),
                  if (_trail.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _WifiPassDebugPanel(trail: _trail),
                  ],
                ],
                const Spacer(),
                FilledButton(
                  onPressed: _connecting ? null : _connect,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _connecting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white),
                        )
                      : Text(l.wifiPasswordConnect),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      _connecting ? null : () => Navigator.of(context).pop(),
                  child: Text(l.commonBack),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _WifiPassDebugPanel extends StatelessWidget {
  const _WifiPassDebugPanel({required this.trail});
  final List<String> trail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
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
              Text(AppLocalizations.of(context).wifiPasswordLogTitle,
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
