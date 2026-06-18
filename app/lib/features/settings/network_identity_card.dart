import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/system/network_identity_provider.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/network_identity_dialogs.dart';

/// Body of the Network Identity accordion in Settings → Advanced.
///
/// The outer card wrapper (SkCard + title row + chevron) is provided by
/// [_DevCollapsibleCard] in `settings_screen.dart` (2026-05-14 accordion
/// reorganization). This widget renders only the data rows + the
/// "server not running yet" notice.
///
/// Phase 1 honesty:
///   - All four identity values are real, persisted, and non-zero from
///     first launch (see [networkIdentityProvider]).
///   - The notice banner stays until the HTTP listener lands; the user
///     shouldn't expect actions to fire today.
///
/// Renamable: port. Read-only-but-rotatable: token. Read-only: UUID
/// (rotating it would orphan every paired device's expected identity).
class NetworkIdentityCard extends ConsumerWidget {
  const NetworkIdentityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final id = ref.watch(networkIdentityProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2026-05-13: Name satırı kaldırıldı. Settings ekranının
        // tepesinde zaten "This Node > Node name" NavCardı aynı
        // setName() akışını çağırıyor; iki yerden edit karıştırıcıydı.
        // Developer mode kullanıcısı da aynı top kartı görür.
        _IdentityRow(
          label: l.settingsNetworkIdentityUuid,
          value: id.uuid,
          monospace: true,
          actions: [
            _RowAction(
              icon: Icons.copy_rounded,
              tooltip: l.settingsNetworkIdentityCopy,
              onTap: () => _copy(context, l, id.uuid),
            ),
          ],
        ),
        const _RowDivider(),

        _IdentityRow(
          label: l.settingsNetworkIdentityPort,
          value: id.port.toString(),
          actions: [
            _RowAction(
              icon: Icons.edit_outlined,
              tooltip: l.settingsNetworkIdentityNameEdit,
              onTap: () => _editPort(context, ref, l, id.port),
            ),
          ],
        ),
        const _RowDivider(),

        _IdentityRow(
          label: l.settingsNetworkIdentityToken,
          value: _maskToken(id.bearerToken),
          monospace: true,
          actions: [
            _RowAction(
              icon: Icons.copy_rounded,
              tooltip: l.settingsNetworkIdentityCopy,
              onTap: () => _copy(context, l, id.bearerToken),
            ),
            _RowAction(
              icon: Icons.refresh_rounded,
              tooltip: l.settingsNetworkIdentityRegenerateToken,
              onTap: () => _confirmRegenerateToken(context, ref, l),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: SkColors.attentionMustard, width: 1.5),
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
                  l.settingsNetworkIdentityServerNotRunning,
                  style: tt.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.settingsNetworkIdentityStaticIpHint,
          style: tt.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // -- actions -----------------------------------------------------------

  Future<void> _editPort(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    int current,
  ) async {
    final next = await promptNetworkIdentityText(
      context: context,
      title: l.settingsNetworkIdentityPortDialogTitle,
      help: '1–65535',
      initial: current.toString(),
      maxLength: 5,
      keyboardType: TextInputType.number,
    );
    if (next == null) return;
    final parsed = int.tryParse(next);
    if (parsed == null) return;
    await ref.read(networkIdentityProvider.notifier).setPort(parsed);
  }

  Future<void> _confirmRegenerateToken(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.settingsNetworkIdentityRegenerateConfirmTitle),
        content: Text(l.settingsNetworkIdentityRegenerateConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.settingsNetworkIdentityRegenerateToken),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(networkIdentityProvider.notifier).regenerateToken();
  }

  Future<void> _copy(
    BuildContext context,
    AppLocalizations l,
    String value,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.settingsNetworkIdentityCopied, textAlign: TextAlign.center)));
  }
}

/// Show only the first/last few token characters so the card stays
/// compact and the secret isn't fully visible at a glance, copy is
/// always available for the real value.
String _maskToken(String token) {
  if (token.length <= 12) return token;
  return '${token.substring(0, 6)}…${token.substring(token.length - 6)}';
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({
    required this.label,
    required this.value,
    required this.actions,
    this.monospace = false,
  });

  final String label;
  final String value;
  final List<_RowAction> actions;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: (monospace
                        ? tt.bodyMedium?.copyWith(fontFamilyFallback: const [
                            'monospace',
                            'Courier New',
                          ])
                        : tt.bodyMedium)
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        for (final a in actions)
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: a.tooltip,
            icon: Icon(a.icon, size: 18),
            onPressed: a.onTap,
          ),
      ],
    );
  }
}

class _RowAction {
  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 18,
      thickness: 1,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
    );
  }
}
