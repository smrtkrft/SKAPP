// BF firmware OTA screen.
//
// Drives the two-step firmware OTA flow correctly against the device's async
// CLI surface (sk_ota.c):
//   ota.status        → read snapshot (state, current, remote, progress,
//                       can_rollback, running_partition, message)
//   ota.check         → ASYNC: returns {checking:true} immediately; the real
//                       result lands later as an `ota.fw.state` event
//                       (update_available / no_update / error).
//   ota.update        → critical (confirm-token): download + sha256 verify +
//                       reboot; progress streams via `ota.fw.state`.
//   ota.rollback      → critical: boot previous partition.
//
// The previous Settings implementation only fired `ota.check` and showed a
// generic toast, never reading the result, never offering install. This
// screen subscribes to the event stream so the version comparison the
// firmware actually performs becomes visible, and wires the install +
// rollback critical commands.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart' show ShellNavBar;
import 'bf_session.dart';

class BfOtaScreen extends StatefulWidget {
  const BfOtaScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<BfOtaScreen> createState() => _BfOtaScreenState();
}

class _BfOtaScreenState extends State<BfOtaScreen> {
  bool _loaded = false;
  String _state = 'idle'; // idle|checking|update_available|no_update|downloading|done|error
  String _current = '-';
  String _remote = '';
  int _progress = 0;
  bool _canRollback = false;
  String _runningPartition = '';
  String _message = '';
  String? _readError; // ota.status read failure (transport/proto)

  StreamSubscription<Map<String, dynamic>>? _eventSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _refreshStatus();
    // Subscribe to ota.fw.state pushes so async check/download results show
    // without polling. Other event names are ignored.
    _eventSub = BfSession.of(context).client.events.listen(_onEvent);
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  /// Applies a status/event payload map onto local state. Both `ota.status`
  /// data and the `ota.fw.state` event carry the same field names; status
  /// additionally has can_rollback / running_partition.
  void _apply(Map data) {
    setState(() {
      _state = data['state']?.toString() ?? _state;
      final cur = data['current']?.toString();
      if (cur != null && cur.isNotEmpty) _current = cur;
      _remote = data['remote']?.toString() ?? _remote;
      final p = data['progress'];
      if (p is num) _progress = p.toInt();
      if (data.containsKey('can_rollback')) {
        _canRollback = data['can_rollback'] == true;
      }
      final rp = data['running_partition']?.toString();
      if (rp != null && rp.isNotEmpty) _runningPartition = rp;
      _message = data['message']?.toString() ?? _message;
    });
  }

  void _onEvent(Map<String, dynamic> evt) {
    if (evt['evt']?.toString() != 'ota.fw.state') return;
    final data = evt['data'];
    if (data is Map) _apply(data);
  }

  Future<void> _refreshStatus() async {
    final client = BfSession.of(context).client;
    try {
      final r = await client.send('ota.status');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        setState(() => _readError = null);
        _apply(r.data as Map);
      } else if (!r.ok) {
        setState(() => _readError = r.err ?? AppLocalizations.of(context).commonReadFailed);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _readError = e.toString());
    }
  }

  Future<void> _check() async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    // Optimistic: the device flips to "checking" and pushes the real result
    // (update_available / no_update / error) as an event shortly after.
    setState(() {
      _state = 'checking';
      _message = '';
    });
    try {
      final r = await client.send('ota.check');
      if (!mounted) return;
      if (!r.ok) {
        setState(() {
          _state = 'error';
          _message = r.err ?? l.commonError;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = 'error';
        _message = e.toString();
      });
    }
  }

  /// Drives a critical command (ota.update / ota.rollback) through the
  /// firmware confirm-token two-step, with a local confirm dialog.
  Future<void> _runCritical({
    required String cmd,
    required String title,
    required String body,
    required String confirmLabel,
    Color? confirmColor,
  }) async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    final r = await client.sendCritical(
      cmd,
      confirmRequest: (req) async {
        if (!mounted) return false;
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l.commonCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(foregroundColor: confirmColor),
                child: Text(confirmLabel),
              ),
            ],
          ),
        );
        return ok == true;
      },
    );
    if (!mounted) return;
    // Success path is reflected by ota.fw.state events (downloading→done).
    // Surface only hard failures that aren't a user cancel.
    if (!r.ok && r.err != 'ERR_CONFIRM_TOKEN_REQUIRED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.commonError}: ${r.err ?? "?"}',
              textAlign: TextAlign.center),
        ),
      );
    }
  }

  void _confirmUpdate() {
    final l = AppLocalizations.of(context);
    _runCritical(
      cmd: 'ota.update',
      title: l.bfOtaUpdateConfirmTitle,
      body: l.bfOtaUpdateConfirmBody(_remote.isEmpty ? '?' : _remote),
      confirmLabel: l.bfOtaUpdateCta,
    );
  }

  void _confirmRollback() {
    final l = AppLocalizations.of(context);
    _runCritical(
      cmd: 'ota.rollback',
      title: l.bfOtaRollbackConfirmTitle,
      body: l.bfOtaRollbackConfirmBody,
      confirmLabel: l.bfOtaRollbackCta,
      confirmColor: const Color(0xFFD4A017),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final busy = _state == 'checking' || _state == 'downloading';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfOtaTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: busy ? null : _refreshStatus,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            // Current version + active partition.
            SkNeuCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv(context, l.bfOtaCurrentLabel, _current, mono: true),
                  if (_runningPartition.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _kv(context, l.bfOtaRunningPartitionLabel,
                        _runningPartition,
                        mono: true),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // State-driven status + primary action.
            SkNeuCard(
              padding: const EdgeInsets.all(16),
              child: _buildStateBody(context, l, cs),
            ),
            if (_canRollback) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: busy ? null : _confirmRollback,
                icon: const Icon(Icons.history, size: 18),
                label: Text(l.bfOtaRollbackCta),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFD4A017),
                ),
              ),
            ],
            if (_readError != null) ...[
              const SizedBox(height: 16),
              Text(
                '${l.commonError}: $_readError',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStateBody(
      BuildContext context, AppLocalizations l, ColorScheme cs) {
    switch (_state) {
      case 'checking':
        return _statusRow(
          context,
          const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          l.bfOtaChecking,
        );
      case 'update_available':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.bfOtaAvailable(_remote.isEmpty ? '?' : _remote),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.primary),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _confirmUpdate,
              icon: const Icon(Icons.system_update_alt, size: 18),
              label: Text(l.bfOtaUpdateCta),
            ),
          ],
        );
      case 'downloading':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.bfOtaDownloading(_progress)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress > 0 ? _progress / 100 : null,
                minHeight: 6,
              ),
            ),
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_message,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ],
        );
      case 'done':
        return _statusRow(
          context,
          Icon(Icons.check_circle_outline, color: cs.primary),
          l.bfOtaDone,
        );
      case 'error':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusRow(
              context,
              Icon(Icons.error_outline, color: cs.error),
              l.bfOtaErrorMsg(_message.isEmpty ? '?' : _message),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l.bfOtaCheckCta),
            ),
          ],
        );
      case 'no_update':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusRow(
              context,
              Icon(Icons.check_circle_outline, color: cs.primary),
              l.bfOtaUpToDate,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l.bfOtaCheckCta),
            ),
          ],
        );
      default: // idle
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.bfOtaIdleHint,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _check,
              icon: const Icon(Icons.cloud_download_outlined, size: 18),
              label: Text(l.bfOtaCheckCta),
            ),
          ],
        );
    }
  }

  Widget _statusRow(BuildContext context, Widget leading, String text) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _kv(BuildContext context, String key, String value,
      {bool mono = false}) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(key,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: mono ? 'monospace' : null),
          ),
        ),
      ],
    );
  }
}
