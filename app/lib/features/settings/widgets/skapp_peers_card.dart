import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/skapp_peer_store.dart';
import '../../../core/network/skapp_peer_target.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../../skapi/skapp_peer_pairing_screen.dart';

/// Body of the SKAPP Peers accordion in Settings → Advanced.
///
/// Outer SkCard + title chevron come from `_DevCollapsibleCard` in
/// `settings_screen.dart` (2026-05-14 accordion reorganization). This
/// widget renders the subtitle, peer list (or empty hint), and the
/// "Pair new" button that opens [SkappPeerPairingScreen].
///
/// Why it exists: `SkappPeerPairingScreen` was orphaned — there was no
/// path from the Settings screen (or anywhere else) to actually scan a
/// QR / enter the pairing form. Mobile users hit "laptop bağlantısı
/// kurulamıyor" because they had no entry point.
///
/// Visible on every platform; even Desktop hosts may pair with another
/// Desktop SKAPP someday.
class SkappPeersCard extends ConsumerWidget {
  const SkappPeersCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final peers = ref.watch(skappPeersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.skappPeersCardSubtitle,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        if (peers.isEmpty)
          Text(
            l.skappPeersCardEmpty,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...peers.map((p) => _PeerRow(peer: p)),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => _openPairingFlow(context),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: Text(l.skappPeersCardPairButton),
          ),
        ),
      ],
    );
  }

  Future<void> _openPairingFlow(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SkappPeerPairingScreen(),
      ),
    );
  }
}

class _PeerRow extends ConsumerWidget {
  const _PeerRow({required this.peer});
  final SkappPeerTarget peer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final statusLabel = peer.lastSeen == null
        ? l.skappPeersCardNeverSeen
        : peer.online
            ? l.skappPeersCardOnline
            : l.skappPeersCardOffline;
    final dotColor = peer.online
        ? SkColors.attentionMustard
        : cs.onSurface.withValues(alpha: 0.30);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onLongPress: () => _confirmRemove(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      peer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${peer.lastIp ?? '-'} · :${peer.port} · $statusLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.skappPeersCardRemoveConfirm,
                icon: const Icon(Icons.link_off_rounded),
                color: SkColors.warnRed,
                onPressed: () => _confirmRemove(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final ok = await showSkConfirm(
      context,
      title: l.skappPeersCardRemoveTitle(peer.name),
      message: l.skappPeersCardRemoveBody,
      cancelLabel: l.skappPeersCardRemoveCancel,
      confirmLabel: l.skappPeersCardRemoveConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(skappPeersProvider.notifier).remove(peer.uuid);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skappPeersCardRemovedToast(peer.name), textAlign: TextAlign.center),
      ));
  }
}
