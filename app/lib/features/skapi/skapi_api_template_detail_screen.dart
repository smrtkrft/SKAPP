import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/paired_devices_store.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../devices/bf/bf_session.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../main_shell/selected_tab_provider.dart';
import 'data/script_manifest.dart';
import 'data/skapi_i18n_lookup.dart';
import 'on_device_api_editor_screen.dart';

/// Detail screen for one `ApiTemplateManifest` under an `other-*` platform.
///
/// Counterpart of [SkapiScriptDetailScreen] for Yapı 2 templates. The user
/// reads what the template does, then taps "Cihaza yükle" (mustard CTA) to
/// upload it onto a paired device. Different from Yapı 1 detail screen:
///   * No "Bağla" / params override editor (template is a prefill, not a
///     local binding).
///   * No "Run now" (the host never executes API templates).
///   * No favourite star (favourites are scoped to scripts; api templates
///     are episodic uploads).
///
/// "Cihaza yükle" reuses the same device-picker flow as SKAPI "+ Yeni
/// Aksiyon" (see [SkapiScreen._onAddNewAction]), with `prefillTemplate`
/// passed through so the editor opens with the template's fields baked in.
class SkapiApiTemplateDetailScreen extends ConsumerWidget {
  const SkapiApiTemplateDetailScreen({super.key, required this.manifest});

  final ApiTemplateManifest manifest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final title = resolveSkapiI18nKey(l, manifest.i18nTitle);
    final summary = resolveSkapiI18nKey(l, manifest.i18nSummary);
    final note = manifest.i18nNote == null
        ? null
        : resolveSkapiI18nKey(l, manifest.i18nNote!);

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  title: title,
                  platform: manifest.platform,
                  templateId: manifest.id,
                ),
                const SizedBox(height: 14),
                _SummaryCard(text: summary),
                if (note != null) ...[
                  const SizedBox(height: 12),
                  _NoteCard(text: note),
                ],
                const SizedBox(height: 16),
                _EndpointPreviewCard(manifest: manifest),
                const SizedBox(height: 18),
                _UploadCta(
                  label: l.skapiApiTemplateUploadCta,
                  onTap: () => _onUpload(context, ref, l),
                ),
                const SizedBox(height: 16),
                Text(
                  l.skapiApiTemplateUploadHint,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onUpload(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final paired = ref.read(pairedDevicesProvider);

    // Filter by target device type; same logic as SkapiScreen but the
    // filter could differ if a future template targets LebensSpur etc.
    final wantsBf = manifest.targetDeviceType == 'bf';
    final candidates = paired
        .where((d) => wantsBf ? d.prefix == 'BF' : false)
        .toList(growable: false);

    if (candidates.isEmpty) {
      await _noDevicesDialog(context, ref, l);
      return;
    }

    final target = candidates.length == 1
        ? candidates.first
        : await _pickDevice(context, candidates, l);
    if (target == null || !context.mounted) return;

    // Offline check: BfSession.pushForDevice gate'i bağlanamayınca tam
    // ekran hata kusar (`_GateError`); kullanıcıyı oraya sokmadan alt
    // SnackBar ile bilgilendiriyoruz. SkapiScreen._onAddNewAction ile
    // aynı 90 sn lastSeen kriteri.
    final ls = target.lastSeen;
    final offline = ls == null ||
        DateTime.now().difference(ls) >= const Duration(seconds: 90);
    if (offline) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            l.skapiNewActionDeviceOffline(target.displayName),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 3),
        ));
      return;
    }

    await BfSession.pushForDevice<void>(
      context: context,
      deviceId: target.id,
      child: OnDeviceApiEditorScreen(
        deviceId: target.id,
        prefillTemplate: manifest,
        titleKey: ApiEditorTitleKey.skapiEditor,
      ),
    );
  }

  Future<void> _noDevicesDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final goToDevices = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.skapiNewActionNoDevicesTitle),
        content: Text(l.skapiNewActionNoDevicesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.skapiNewActionNoDevicesCta),
          ),
        ],
      ),
    );
    if (goToDevices == true) {
      ref.read(selectedTabProvider.notifier).set(1);
    }
  }

  Future<PairedDevice?> _pickDevice(
    BuildContext context,
    List<PairedDevice> devices,
    AppLocalizations l,
  ) {
    return showModalBottomSheet<PairedDevice>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        final tt = Theme.of(ctx).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.skapiNewActionPickDeviceTitle,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  l.skapiNewActionPickDeviceSubtitle,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 12),
                for (final d in devices)
                  ListTile(
                    leading: const Icon(Icons.developer_board_rounded),
                    title: Text(d.displayName),
                    subtitle: Text(
                      d.id,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    onTap: () => Navigator.of(ctx).pop(d),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.platform,
    required this.templateId,
  });
  final String title;
  final String platform;
  final String templateId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          '$platform · $templateId',
          style: tt.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SkNeuCard(
      padding: const EdgeInsets.all(14),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 18, color: cs.onSurface.withValues(alpha: 0.65)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.80),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndpointPreviewCard extends StatelessWidget {
  const _EndpointPreviewCard({required this.manifest});
  final ApiTemplateManifest manifest;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rows = <(String, String)>[
      (l.skapiApiTemplatePreviewType, manifest.type),
      (l.skapiApiTemplatePreviewMethod, manifest.method.toUpperCase()),
      (l.skapiApiTemplatePreviewUrl, manifest.urlTemplate),
      (l.skapiApiTemplatePreviewAuth, manifest.auth),
      if (manifest.headerName != null && manifest.headerName!.isNotEmpty)
        (l.skapiApiTemplatePreviewHeader, manifest.headerName!),
      if (manifest.contentType != null && manifest.contentType!.isNotEmpty)
        (l.skapiApiTemplatePreviewContentType, manifest.contentType!),
      if (manifest.payloadTemplate != null &&
          manifest.payloadTemplate!.isNotEmpty)
        (l.skapiApiTemplatePreviewPayload, manifest.payloadTemplate!),
      if (manifest.delayAfterSec > 0)
        (l.skapiApiTemplatePreviewDelay,
            '${manifest.delayAfterSec} ${l.bfApiChainDelayUnit}'),
    ];
    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.skapiApiTemplatePreviewTitle,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 96,
                  child: Text(
                    rows[i].$1,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _UploadCta extends StatelessWidget {
  const _UploadCta({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SkColors.attentionMustard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_rounded, color: SkColors.black, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: SkColors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
