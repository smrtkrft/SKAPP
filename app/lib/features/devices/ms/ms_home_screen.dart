import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import '../../skapi/data/action_binding.dart';
import '../../skapi/data/mobile_event_catalog.dart';
import '../../skapi/data/skapi_providers.dart';

/// Mobile-peer device detail screen. Reached from Cihazlarım when the
/// user taps a paired phone's tile. MS-prefixed entries don't have BF's
/// dashboard / events / logs surfaces (the desktop is the host, not the
/// peer); this screen is purely informational and links to the bind
/// screen so the user can wire the phone's tap event to a script.
class MsHomeScreen extends ConsumerWidget {
  const MsHomeScreen({super.key, required this.peerUuid});

  final String peerUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final paired = ref.watch(pairedDevicesProvider);
    final PairedDevice? device =
        paired.where((d) => d.id == peerUuid).cast<PairedDevice?>().firstOrNull;
    if (device == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.msHomeScreenTitle)),
        body: Center(child: Text(l.msHomeScreenNotFound)),
        bottomNavigationBar: const ShellNavBar(),
      );
    }
    final bindings = ref
        .watch(bindingsProvider)
        .where((b) => b.deviceId == peerUuid)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(device.displayName),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _InfoCard(device: device),
          const SizedBox(height: 14),
          Text(
            l.msHomeScreenEventsHeader,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SkNeuCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final ev in kMobileEvents)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app_rounded,
                            size: 18, color: SkColors.attentionMustard),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l.skapiBindEventMobileTap,
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ev.value,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l.msHomeScreenBindingsHeader(bindings.length),
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (bindings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l.msHomeScreenBindingsEmpty,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            SkNeuCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (int i = 0; i < bindings.length; i++) ...[
                    if (i > 0)
                      Divider(
                          height: 1,
                          color: cs.onSurface.withValues(alpha: 0.08)),
                    _BindingRow(binding: bindings[i]),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 18),
          Text(
            l.msHomeScreenHint,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.device});
  final PairedDevice device;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final pairedDate =
        '${device.pairedAt.toLocal().year}-${device.pairedAt.toLocal().month.toString().padLeft(2, '0')}-${device.pairedAt.toLocal().day.toString().padLeft(2, '0')}';
    return SkNeuCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const SkNeuIconSlot(
            icon: Icons.smartphone_rounded,
            size: 44,
            iconSize: 22,
            tone: SkNeuIconSlotTone.mustard,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  device.typeFullName,
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  device.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  l.msHomeScreenPairedAt(pairedDate),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BindingRow extends StatelessWidget {
  const _BindingRow({required this.binding});
  final ActionBinding binding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded,
              size: 16, color: cs.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${binding.platform}/${binding.scriptId}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  binding.eventFilter,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          if (!binding.enabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'off',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
