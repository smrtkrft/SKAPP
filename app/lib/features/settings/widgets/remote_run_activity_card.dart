import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/remote_run_activity_provider.dart';
import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Body of the "Remote runs" accordion in Settings → Advanced. Mounted
/// by the desktop-side settings screen behind the Developer-mode gate:
/// when devMode is off no peer can trigger a remote run anyway, so the
/// card is hidden to keep the surface tidy.
///
/// Lives parallel to `WebhookActivityCard`: webhook activity tracks
/// BF (device) events, this card tracks paired-mobile-peer script
/// requests. Both share the same 50-entry ring buffer model so the
/// reader can stitch a "who triggered what" timeline.
class RemoteRunActivityCard extends ConsumerWidget {
  const RemoteRunActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final entries = ref.watch(remoteRunActivityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.remoteRunActivityCardSubtitle,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Text(
            l.remoteRunActivityCardEmpty,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          )
        else ...[
          for (final entry in entries) _Row(entry: entry),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () =>
                  ref.read(remoteRunActivityProvider.notifier).clear(),
              icon: const Icon(Icons.delete_sweep_outlined, size: 18),
              label: Text(l.remoteRunActivityCardClear),
            ),
          ),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.entry});

  final RemoteRunActivity entry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isError = entry.outcome == RemoteRunOutcome.rejected ||
        (entry.outcome == RemoteRunOutcome.completed &&
            (entry.exitCode ?? 0) != 0);
    final dotColor = switch (entry.outcome) {
      RemoteRunOutcome.completed =>
        (entry.exitCode ?? 0) == 0 ? SkColors.attentionMustard : SkColors.warnRed,
      RemoteRunOutcome.cancelled => cs.onSurface.withValues(alpha: 0.45),
      RemoteRunOutcome.rejected => SkColors.warnRed,
    };
    final detail = switch (entry.outcome) {
      RemoteRunOutcome.completed => l.remoteRunActivityRowOk(
          entry.exitCode ?? -1,
          entry.durationMs ?? 0,
        ),
      RemoteRunOutcome.cancelled => l.remoteRunActivityRowCancelled,
      RemoteRunOutcome.rejected =>
        l.remoteRunActivityRowRejected(entry.reason ?? 'unknown'),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${entry.peerName} · ${entry.platform}/${entry.scriptId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isError ? cs.error : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_fmtTime(entry.when)} · $detail',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmtTime(DateTime t) {
    final l = t.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.hour)}:${two(l.minute)}:${two(l.second)}';
  }
}
