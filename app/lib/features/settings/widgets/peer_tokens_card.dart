import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/peer_tokens_provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';

/// Body of the Peer Tokens accordion in Settings → Advanced.
///
/// Outer SkCard + title chevron come from `_DevCollapsibleCard` in
/// `settings_screen.dart` (2026-05-14 accordion reorganization). This
/// widget renders only the subtitle + per-peer row list (or empty hint).
///
/// Desktop-only list of paired mobile SKAPP peers and the per-peer
/// tokens issued to each. Why a separate card instead of an extension
/// of [SkappListenerCard]: revoking a peer is a destructive action with
/// a confirm dialog and a distinct domain (per-peer secret store) from
/// the listener lifecycle. Two cards keep each concern legible.
class PeerTokensCard extends ConsumerWidget {
  const PeerTokensCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final entries = ref.watch(peerTokensProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.settingsPeerTokensSubtitle,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Text(
            l.settingsPeerTokensEmpty,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          for (final entry in entries) _PeerRow(entry: entry),
      ],
    );
  }
}

class _PeerRow extends ConsumerWidget {
  const _PeerRow({required this.entry});
  final PeerTokenEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final lastUsed = entry.lastUsedAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  l.settingsPeerTokensIssuedAt(_fmtDate(entry.issuedAt)),
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (lastUsed != null)
                  Text(
                    l.settingsPeerTokensLastUsed(_fmtDate(lastUsed)),
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => _confirmRevoke(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: SkColors.warnRed,
              side: BorderSide(
                color: SkColors.warnRed.withValues(alpha: 0.6),
              ),
            ),
            child: Text(l.settingsPeerTokensRevokeButton),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRevoke(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final confirmed = await showSkConfirm(
      context,
      title: l.settingsPeerTokensRevokeConfirmTitle,
      message: l.settingsPeerTokensRevokeConfirmBody,
      cancelLabel: l.settingsPeerTokensRevokeConfirmCancel,
      confirmLabel: l.settingsPeerTokensRevokeConfirmAction,
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(peerTokensProvider.notifier).revoke(entry.peerUuid);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.settingsPeerTokensRevokedToast(entry.name), textAlign: TextAlign.center),
      ));
  }

  String _fmtDate(DateTime when) {
    final local = when.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
