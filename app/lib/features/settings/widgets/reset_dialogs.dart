import 'dart:io' show exit;

import 'package:flutter/material.dart';

import '../../../core/reset/reset_service.dart';
import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Second-stage "type to confirm" dialog for Factory Reset. The user must
/// type the localized confirmation phrase before the destructive action
/// enables. Pops `true` on confirm, `false`/null on cancel.
class TypeToConfirmDialog extends StatefulWidget {
  const TypeToConfirmDialog({super.key, required this.localizations});
  final AppLocalizations localizations;

  @override
  State<TypeToConfirmDialog> createState() => _TypeToConfirmDialogState();
}

class _TypeToConfirmDialogState extends State<TypeToConfirmDialog> {
  final _ctrl = TextEditingController();
  late final String _expected =
      widget.localizations.settingsFactoryResetSecondConfirmHint;
  String _typed = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.localizations;
    final match = _typed.trim().toUpperCase() == _expected.toUpperCase();
    return AlertDialog(
      title: Text(l.settingsFactoryResetSecondConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.settingsFactoryResetSecondConfirmBody),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: _expected,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _typed = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: SkColors.warnRed,
          ),
          onPressed: match ? () => Navigator.of(context).pop(true) : null,
          child: Text(l.settingsFactoryResetSecondConfirmAction),
        ),
      ],
    );
  }
}

/// Small progress dialog shown during Reset/Factory Reset. No cancel
/// (atomic operation); normally finishes in 1-3 seconds.
class ResetProgressDialog extends StatelessWidget {
  const ResetProgressDialog({super.key, required this.localizations});
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(localizations.settingsResetInProgress)),
          ],
        ),
      ),
    );
  }
}

/// Post-reset summary dialog. Lists removed counts + warnings (if any). In
/// factory mode an additional "Restart now" button appears.
class ResetSummaryDialog extends StatelessWidget {
  const ResetSummaryDialog({
    super.key,
    required this.summary,
    required this.localizations,
  });
  final ResetSummary summary;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final l = localizations;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isFactory = summary.kind == ResetKind.factory;
    final title = summary.hasErrors
        ? l.settingsResetDoneWithWarnings
        : l.settingsResetDoneTitle;

    final lines = <String>[
      if (summary.pairedDevicesRemoved > 0)
        l.settingsResetSummaryPaired(summary.pairedDevicesRemoved),
      if (summary.bondsCleared > 0)
        l.settingsResetSummaryBonds(summary.bondsCleared),
      if (summary.bindingsRemoved > 0)
        l.settingsResetSummaryBindings(summary.bindingsRemoved),
      if (summary.skappPeersRemoved > 0)
        l.settingsResetSummaryPeers(summary.skappPeersRemoved),
      if (summary.networkIdentityReset) l.settingsResetSummaryNetworkIdentity,
      if (summary.tlsCertCleared) l.settingsResetSummaryTlsCert,
      if (summary.autostartUnregistered) l.settingsResetSummaryAutostart,
    ];

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final line in lines) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line, style: tt.bodyMedium)),
                  ],
                ),
              ),
            ],
            if (summary.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l.settingsResetSummaryWarningHeader,
                style: tt.labelMedium?.copyWith(
                  color: SkColors.warnRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              for (final err in summary.errors)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• $err',
                    style: tt.bodySmall?.copyWith(
                      color: cs.error,
                    ),
                  ),
                ),
            ],
            if (isFactory) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: SkColors.attentionMustard,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: SkColors.attentionMustard,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.settingsResetRestartHint,
                        style: tt.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.settingsResetClose),
        ),
        if (isFactory)
          FilledButton.icon(
            onPressed: () {
              // Agresif restart yok; sadece exit çağrılır, kullanıcı
              // app'i manuel yeniden açar. windowManager.destroy + exit
              // ile process temiz sonlanır.
              Navigator.of(context).pop();
              exit(0);
            },
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(l.settingsResetRestartNow),
          ),
      ],
    );
  }
}
