// Reset API endpoint section body for LebensSpur dashboard.
//
// Wraps the firmware's HTTP reset endpoint config: a toggle (enable),
// the masked API key (mostly read-only · regenerate via a button), and
// the full URL with copy-to-clipboard. Includes a small example curl
// command so the user can paste it into a terminal.
//
// CLI contract:
//   READ   : reset_api.get → {enabled, key, port, endpoint}
//   TOGGLE : reset_api.enable {enabled: "on"|"off"}
//   REGEN  : reset_api.regen
//
// Notes:
//   * The key comes back already masked from the device ("********<4>").
//     We never have the full secret on the SKAPP side, so "Copy URL"
//     embeds the masked key; users who need a working URL must run
//     `reset_api.regen` and read the fresh key off the device via CLI
//     once. (Future: surface the new key once, in clear, right after
//     regen. Out of scope for this phase.)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/ui/sk_neu_card.dart' show SkNeuSwitch;
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class LsSectionResetApi extends ConsumerStatefulWidget {
  const LsSectionResetApi({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionResetApi> createState() =>
      _LsSectionResetApiState();
}

class _LsSectionResetApiState extends ConsumerState<LsSectionResetApi> {
  bool _loading = true;
  bool _busy = false;
  String? _loadError;

  bool _enabled = false;
  String _key = '';
  int _port = 80;
  String _endpoint = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('reset_api.get');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        setState(() {
          _enabled = (m['enabled'] as bool?) ?? false;
          _key = m['key']?.toString() ?? '';
          _port = (m['port'] as num?)?.toInt() ?? 80;
          _endpoint = m['endpoint']?.toString() ?? '';
          _loading = false;
        });
        widget.onStatusChanged(_summary());
      } else {
        final l = AppLocalizations.of(context);
        setState(() {
          _loading = false;
          _loadError = r.err ?? l.lsCommonReadFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  String _summary() {
    final l = AppLocalizations.of(context);
    if (!_enabled) return l.lsResetApiStatusDisabled;
    return l.lsResetApiStatusEnabledPort(_port);
  }

  String get _fullUrl {
    if (_endpoint.isEmpty) return '';
    // Endpoint already contains "http://...:port/path"; just append the
    // query string. If the firmware ever returns a bare path we still
    // produce something reasonable.
    final sep = _endpoint.contains('?') ? '&' : '?';
    return '$_endpoint${sep}key=$_key';
  }

  Future<void> _toggle(bool next) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'reset_api.enable',
        args: {'enabled': next ? 'on' : 'off'},
      );
      if (!mounted) return;
      if (r.ok) {
        await _fetch();
      } else {
        setState(() => _busy = false);
        _snack(l.lsCommonFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack(l.lsCommonFailedWith(e.toString()));
    } finally {
      if (mounted && _busy) setState(() => _busy = false);
    }
  }

  Future<void> _regen() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lsResetApiRegenDialogTitle),
        content: Text(l.lsResetApiRegenDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: SkColors.attentionMustard,
              foregroundColor: SkColors.black,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.lsResetApiRegenConfirm),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('reset_api.regen');
      if (!mounted) return;
      if (r.ok) {
        _snack(l.lsResetApiKeyRegeneratedSnack);
        await _fetch();
      } else {
        setState(() => _busy = false);
        _snack(l.lsCommonFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack(l.lsCommonFailedWith(e.toString()));
    }
  }

  Future<void> _copyUrl() async {
    final url = _fullUrl;
    if (url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) _snack(AppLocalizations.of(context).lsSmtpUrlCopiedSnack);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LsSectionBody(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      );
    }
    if (_loadError != null) {
      return LsSectionBody(
        children: [
          LsSectionErrorLine(message: _loadError!, onRetry: _fetch),
        ],
      );
    }

    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    final url = _fullUrl;

    return LsSectionBody(
      children: [
        LsField(
          label: l.lsResetApiEnabledLabel,
          row: true,
          hint: l.lsResetApiEnabledHint,
          child: SkNeuSwitch(
            value: _enabled,
            onChanged: _busy ? null : _toggle,
          ),
        ),
        LsField(
          label: l.lsResetApiEndpointUrlLabel,
          child: _ReadOnlyMonoBox(
            text: url.isEmpty ? l.lsResetApiUrlNotAvailable : url,
            trailing: url.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    color: fg.withValues(alpha: 0.50),
                    onPressed: _copyUrl,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tooltip: l.lsResetApiCopyUrlTooltip,
                  ),
          ),
        ),
        LsField(
          label: l.lsResetApiKeyLabel,
          row: true,
          child: Text(
            _key.isEmpty ? l.lsResetApiKeyNotSet : _key,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              color: fg.withValues(alpha: 0.90),
            ),
          ),
        ),
        if (url.isNotEmpty) ...[
          Text(
            l.lsResetApiExampleLabel,
            style: TextStyle(
              fontSize: 12,
              color: fg.withValues(alpha: 0.50),
            ),
          ),
          _ReadOnlyMonoBox(text: 'curl "$url"'),
        ],
        LsActionsRow(
          children: [
            LsPillButton(
              label: l.lsResetApiRegenerateButton,
              icon: Icons.autorenew,
              outlined: true,
              onPressed: _busy ? null : _regen,
            ),
          ],
        ),
      ],
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────

/// Monospace read-only box with an optional trailing widget (copy button).
/// Visually similar to .neu-input but uses an inset well so it reads
/// "data display" rather than "user input".
class _ReadOnlyMonoBox extends StatelessWidget {
  const _ReadOnlyMonoBox({required this.text, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final bg = isDark
        ? Colors.black.withValues(alpha: 0.20)
        : Colors.black.withValues(alpha: 0.04);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: fg.withValues(alpha: 0.85),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
