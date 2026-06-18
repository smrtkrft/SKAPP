import 'package:flutter/material.dart';

import '../../../core/network/skapp_peer_target.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_centered_dialog.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom sheet that lets the user pick which paired Desktop SKAPP a
/// remote run should target. Shown when the caller has 2+ paired
/// peers; the single-peer path skips the sheet and dispatches
/// directly (see `SkapiScriptDetailScreen._onRun`).
///
/// Row state mapping:
///   - Online + Developer mode confirmed on:   enabled, primary tile
///   - Online + Developer mode confirmed off:  disabled, "Dev mode is off"
///   - Online + Developer mode unknown:        enabled (let the run
///                                              endpoint reject if needed)
///   - Offline (lastSeen stale):               disabled, "Offline"
///
/// Returns the selected peer via [Navigator.pop]. Cancelling the sheet
/// returns `null` and the caller silently aborts the run.
class SkappPeerPickerSheet extends StatelessWidget {
  const SkappPeerPickerSheet({super.key, required this.peers});

  final List<SkappPeerTarget> peers;

  static Future<SkappPeerTarget?> show(
    BuildContext context, {
    required List<SkappPeerTarget> peers,
  }) {
    return showDialog<SkappPeerTarget>(
      context: context,
      builder: (_) => SkappPeerPickerSheet(peers: peers),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkCenteredDialog(
      title: l.skappPeerPickerTitle,
      icon: Icons.devices_other_rounded,
      subtitle: l.skappPeerPickerSubtitle,
      maxWidth: 460,
      maxHeight: 540,
      bodyPadding: const EdgeInsets.symmetric(vertical: 6),
      child: peers.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  l.skappPeerPickerEmpty,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < peers.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: cs.onSurface.withValues(alpha: 0.06),
                      indent: 16,
                      endIndent: 16,
                    ),
                  _PeerRow(
                    peer: peers[i],
                    onTap: () => Navigator.of(context).pop(peers[i]),
                  ),
                ],
              ],
            ),
    );
  }
}

class _PeerRow extends StatelessWidget {
  const _PeerRow({required this.peer, required this.onTap});

  final SkappPeerTarget peer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final online = peer.online;
    final devModeOff = peer.developerModeEnabled == false;
    final disabled = !online || devModeOff;
    final reasonText = !online
        ? l.skappPeerPickerOfflineReason
        : devModeOff
            ? l.skappPeerPickerDevModeOffReason
            : null;
    final dotColor = online
        ? SkColors.attentionMustard
        : cs.onSurface.withValues(alpha: 0.30);
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.45 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            peer.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tt.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (peer.developerModeEnabled == true)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: SkColors.attentionMustard
                                  .withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              l.skappPeerHealthDevModeBadge,
                              style: tt.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: SkColors.attentionMustard,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${peer.lastIp ?? '-'} · :${peer.port}'
                      '${reasonText == null ? '' : ' · $reasonText'}',
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
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
