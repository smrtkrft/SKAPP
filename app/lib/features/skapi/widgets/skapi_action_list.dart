import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../devices/bf/bf_session.dart';
import '../data/action_binding.dart';
import '../data/script_manifest.dart';
import '../data/skapi_i18n_lookup.dart';
import '../data/skapi_providers.dart';
import '../data/system_endpoint_sync_service.dart';
import '../on_device_api_editor_screen.dart';
import '../skapi_bind_screen.dart';

/// Bindings listesi — "Aksiyonlarım" bölümü dolu olduğunda render edilir.
///
/// Cihaz başına gruplandırılmış: her grup bir [_DeviceActionGroup] (header
/// + collapsible body). Header'da cihaz adı + aksiyon sayısı + chevron;
/// gövdesi expand olduğunda o cihaza bağlı [_ActionRow]'ları gösterir.
///
/// Default state: tüm gruplar kapalı başlar (kullanıcı kararı). Sıralama
/// alfabetik (cihaz displayName'ine göre A→Z). Orphan binding'ler (paired
/// listede olmayan deviceId) listenin sonunda kendi grubuyla görünür.
class SkapiActionList extends ConsumerStatefulWidget {
  const SkapiActionList({super.key, required this.bindings});
  final List<ActionBinding> bindings;

  @override
  ConsumerState<SkapiActionList> createState() => _ActionsListState();
}

class _ActionsListState extends ConsumerState<SkapiActionList> {
  /// Açık grupların deviceId set'i. Tüm gruplar kapalı başlar; kullanıcı
  /// header'a tıklayarak açar/kapar. State sadece bu widget yaşadığı
  /// sürece tutulur (sekme değişiminde resetlenir, basitlik için).
  final Set<String> _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final paired = ref.watch(pairedDevicesProvider);

    // Bindings'i deviceId'ye göre grupla.
    final byDevice = <String, List<ActionBinding>>{};
    for (final b in widget.bindings) {
      byDevice.putIfAbsent(b.deviceId, () => []).add(b);
    }

    // Cihaz adı çözücü: paired listede varsa displayName, yoksa raw id.
    String nameOf(String id) {
      for (final p in paired) {
        if (p.id == id) return p.displayName;
      }
      return id;
    }

    // Alfabetik sıralama (displayName, case-insensitive). Tie-break: id.
    final orderedIds = byDevice.keys.toList()
      ..sort((a, b) {
        final cmp =
            nameOf(a).toLowerCase().compareTo(nameOf(b).toLowerCase());
        return cmp != 0 ? cmp : a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < orderedIds.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _DeviceActionGroup(
            deviceId: orderedIds[i],
            deviceName: nameOf(orderedIds[i]),
            bindings: byDevice[orderedIds[i]]!,
            expanded: _expanded.contains(orderedIds[i]),
            onToggle: () => setState(() {
              if (_expanded.contains(orderedIds[i])) {
                _expanded.remove(orderedIds[i]);
              } else {
                _expanded.add(orderedIds[i]);
              }
            }),
          ),
        ],
      ],
    );
  }
}

/// Tek bir cihazın aksiyon grubu. Header tıklanabilir; tap → expand toggle.
/// Body kapalıyken çizilmez (height 0), açıkken yumuşak AnimatedSize ile
/// belirir.
class _DeviceActionGroup extends StatelessWidget {
  const _DeviceActionGroup({
    required this.deviceId,
    required this.deviceName,
    required this.bindings,
    required this.expanded,
    required this.onToggle,
  });

  final String deviceId;
  final String deviceName;
  final List<ActionBinding> bindings;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SkNeuCard(
      borderRadius: 14,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.skapiActionsGroupTitle(deviceName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l.skapiActionsGroupCount(bindings.length),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(alpha: 0.65),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: expanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: cs.outlineVariant,
                        ),
                        // S2.6: two sub-sections inside each device group.
                        // "Local scripts" = Yapı 1 bindings (host-fired).
                        // "On-device API" = Yapı 2 endpoints (device-fired).
                        // Sub-headers only render when their list is
                        // non-empty so the card stays tight.
                        if (bindings.isNotEmpty) ...[
                          _SubSectionHeader(
                            label: l.skapiLocalScriptsSubheading,
                          ),
                          for (int i = 0; i < bindings.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: cs.outlineVariant,
                              ),
                            _ActionRow(binding: bindings[i]),
                          ],
                        ],
                        _OnDeviceApiList(deviceId: deviceId),
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
    );
  }
}

/// Mustard-tinted thin label that separates "Local scripts" and
/// "On-device API" sub-sections inside a [_DeviceActionGroup] body.
/// Plain text on a divider-thin background so it doesn't compete with
/// the device group's title.
class _SubSectionHeader extends StatelessWidget {
  const _SubSectionHeader({required this.label, this.action});
  final String label;

  /// Sağda render edilen küçük aksiyon (örn. refresh ikonu). Yoksa
  /// başlık satırı önceki gibi sadece label içerir.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelWidget = Text(
      label.toUpperCase(),
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: cs.onSurface.withValues(alpha: 0.55),
        letterSpacing: 0.6,
      ),
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14, action == null ? 8 : 2, 6, action == null ? 6 : 2),
      color: cs.onSurface.withValues(alpha: 0.03),
      child: action == null
          ? labelWidget
          : Row(
              children: [
                Expanded(child: labelWidget),
                action!,
              ],
            ),
    );
  }
}

/// "On-device API" sub-section list. Subscribes to
/// [onDeviceApiEndpointsProvider] for the device; renders one row per
/// USER slot. Hidden entirely when the device returns zero USER
/// endpoints (the sub-header doesn't even appear), so a device with
/// only Local scripts shows the original card unchanged.
///
/// Device offline / load error states render a small placeholder row
/// (not a hard error) so the parent group's Local scripts list stays
/// readable.
class _OnDeviceApiList extends ConsumerWidget {
  const _OnDeviceApiList({required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final endpointsAsync = ref.watch(onDeviceApiEndpointsProvider(deviceId));

    return endpointsAsync.when(
      loading: () => _OnDeviceApiPlaceholderRow(
        icon: Icons.sync_rounded,
        text: l.commonLoading,
      ),
      error: (e, _) => _OnDeviceApiPlaceholderRow(
        icon: Icons.error_outline_rounded,
        text: l.skapiOnDeviceApiLoadError,
      ),
      data: (endpoints) {
        if (endpoints.isEmpty) {
          // Empty branch covers BOTH "device online, no endpoints" and
          // "device offline" (provider returns []) — collapsed to a
          // single hidden state because Aksiyonlarım should not surface
          // a noisy "no endpoints" message when the user just hasn't
          // configured anything yet. The OnDeviceApiEditorScreen is
          // where they'd add one.
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubSectionHeader(
              label: l.skapiOnDeviceApiSubheading,
              // Manual refresh: provider re-fetcher tetikler. Otomatik
              // polling YOK (cihaz pil tasarrufu); kullanıcı bir başka
              // SKAPP'tan veya CLI'dan endpoint eklediyse listeyi
              // güncellemek için bu ikona dokunur.
              action: IconButton(
                tooltip: l.commonRefresh,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                onPressed: () =>
                    ref.invalidate(onDeviceApiEndpointsProvider(deviceId)),
              ),
            ),
            for (int i = 0; i < endpoints.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: cs.outlineVariant,
                ),
              _OnDeviceApiRow(
                endpoint: endpoints[i],
                onTap: () => _openEditor(context),
              ),
            ],
            // Hint footer: tapping any row drops the user into the
            // editor (full slot list view), not a single-endpoint
            // detail screen. The editor handles edit + delete from
            // there.
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Text(
                l.skapiOnDeviceApiRowHint,
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    await BfSession.pushForDevice<void>(
      context: context,
      deviceId: deviceId,
      child: OnDeviceApiEditorScreen(
        deviceId: deviceId,
        titleKey: ApiEditorTitleKey.skapiEditor,
      ),
    );
  }
}

class _OnDeviceApiRow extends StatelessWidget {
  const _OnDeviceApiRow({required this.endpoint, required this.onTap});
  final OnDeviceApiSummary endpoint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            Icon(
              Icons.cloud_outlined,
              color: cs.onSurface.withValues(alpha: 0.55),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    endpoint.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${endpoint.method.toUpperCase()} · ${endpoint.url}',
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
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _OnDeviceApiPlaceholderRow extends StatelessWidget {
  const _OnDeviceApiPlaceholderRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: cs.onSurface.withValues(alpha: 0.45)),
          const SizedBox(width: 8),
          Text(
            text,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.binding});
  final ActionBinding binding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final paired = ref.watch(pairedDevicesProvider).firstWhere(
      (d) => d.id == binding.deviceId,
      orElse: () => PairedDevice(
        id: binding.deviceId,
        name: binding.deviceId,
        prefix: '??',
        pairedAt: DateTime.now(),
      ),
    );

    final manifestAsync = ref.watch(skapiScriptManifestProvider((
      platform: binding.platform,
      script: binding.scriptId,
    )));

    final syncRecord = ref.watch(systemEndpointSyncStateProvider)[
            binding.deviceId] ??
        SyncRecord.idle;

    return InkWell(
      onTap: () => _openEditor(context, ref, manifestAsync.value),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Row(
          children: [
            Icon(
              binding.enabled
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              color: binding.enabled
                  ? SkColors.attentionMustard
                  : cs.onSurface.withValues(alpha: 0.40),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    manifestAsync.when(
                      data: (m) => resolveSkapiI18nKey(l, m.i18nTitle),
                      loading: () => binding.scriptId,
                      error: (_, _) => binding.scriptId,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${paired.displayName} · ${binding.platform} · '
                    '${binding.scriptId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                    ),
                  ),
                  // Per-device sync status: did SKAPP successfully tell
                  // BF where to send the webhook? Issue 3 root cause —
                  // user kept thinking "binding kayıtlı" while BF had
                  // no SYSTEM slot. Badge surfaces this asymmetry.
                  if (syncRecord.status != SyncStatus.idle &&
                      syncRecord.status != SyncStatus.removed) ...[
                    const SizedBox(height: 4),
                    _SyncBadge(record: syncRecord),
                  ],
                ],
              ),
            ),
            SkNeuSwitch(
              value: binding.enabled,
              onChanged: (v) async {
                await ref
                    .read(bindingsProvider.notifier)
                    .setEnabled(binding.id, v);
              },
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    ScriptManifest? manifest,
  ) async {
    if (manifest == null) {
      // Manifest henüz yüklenmedi (offline veya asset eksik). Boş tap
      // sessiz no-op değil, kullanıcı geri bildirim alsın.
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.skapiManifestLoadingRetry(
              binding.platform, binding.scriptId), textAlign: TextAlign.center),
        ));
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiBindScreen(
          manifest: manifest,
          existing: binding,
        ),
      ),
    );
  }
}



/// Per-row chip showing whether SKAPP has pushed the webhook URL onto
/// the device's SYSTEM slot. Three meaningful colors:
///   pending → mustard "BF'ye yazılıyor"
///   ok      → faint green "BF'ye kayıtlı"
///   failed  → warn-red with the firmware error string + tooltip
/// idle / removed states render nothing (caller filters them).
class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.record});
  final SyncRecord record;

  /// Resolves an `errorReason` from [SystemEndpointSyncService] to a
  /// localized string. Sentinels in [SyncErrReason] map to ARB entries;
  /// anything else (raw firmware code, truncated exception message) is
  /// passed through as-is.
  String _translateReason(AppLocalizations l, String reason) {
    switch (reason) {
      case SyncErrReason.unknownCommand:
        return l.syncErrUnknownCommand;
      case SyncErrReason.notAuthenticated:
        return l.syncErrNotAuthenticated;
      case SyncErrReason.notFound:
        return l.syncErrNotFound;
      case SyncErrReason.internal:
        return l.syncErrInternal;
      case SyncErrReason.unknown:
        return l.syncErrUnknown;
      case SyncErrReason.timeout:
        return l.syncErrTimeout;
      case SyncErrReason.noBond:
        return l.syncErrNoBond;
      case SyncErrReason.connect:
        return l.syncErrConnect;
      default:
        return reason;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    Color bg;
    Color fg;
    IconData icon;
    String text;
    String? tooltip;

    switch (record.status) {
      case SyncStatus.pending:
        bg = SkColors.attentionMustard.withValues(alpha: 0.18);
        fg = SkColors.attentionMustard;
        icon = Icons.sync_rounded;
        text = l.skapiSyncBadgeWriting;
        break;
      case SyncStatus.ok:
        bg = const Color(0xFF2E7D32).withValues(alpha: 0.16);
        fg = const Color(0xFF2E7D32);
        icon = Icons.cloud_done_rounded;
        text = l.skapiSyncBadgeWritten;
        break;
      case SyncStatus.failed:
        bg = SkColors.warnRed.withValues(alpha: 0.16);
        fg = SkColors.warnRed;
        icon = Icons.warning_amber_rounded;
        text = record.errorReason == null
            ? l.skapiSyncBadgeFailed
            : _translateReason(l, record.errorReason!);
        tooltip = record.errorCode == null
            ? null
            : l.skapiSyncBadgeFirmwareCodeTooltip(record.errorCode!);
        break;
      case SyncStatus.idle:
      case SyncStatus.removed:
        return const SizedBox.shrink();
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return tooltip == null ? chip : Tooltip(message: tooltip, child: chip);
  }
}
