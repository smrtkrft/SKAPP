import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/devices/validators/bf_endpoint_rules.dart';
import '../../core/devices/validators/sd_validators.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../devices/bf/bf_session.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../main_shell/selected_tab_provider.dart';
import 'data/device_template.dart';
import 'data/script_manifest.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/template_deploy_service.dart';
import 'data/template_render.dart';
import 'data/user_template.dart';
import 'on_device_api_editor_screen.dart';
import 'skapi_template_library_screen.dart'
    show TemplateLibraryContext, TemplateKindBadge, DevicePrefixChip;

/// Cihaz şablonu detayı — Form / Gelişmiş (JSON) sekmeli.
///
/// [SkapiApiTemplateDetailScreen]'in halefi; dört hedef türünü de kapsar:
///   * Form sekmesi: tipli param alanları (enum→dropdown, int→sayısal,
///     secret→gizli) + cihaza gidecek gövdenin canlı önizlemesi.
///   * Gelişmiş sekmesi: ham JSON (sd.* türlerinde düzenlenebilir) +
///     tür-bazlı "Doğrula".
///   * "Şablonlarıma kopyala" → düzenlenebilir [UserTemplate] kopyası.
///   * "Cihaza yükle" → bf.endpoint için OnDeviceApiEditorScreen akışı
///     (parametre formu orada, Faz A); sd.* için cihaz seçici (+ slot /
///     kasa kaydı seçimi) + [TemplateDeployService] geri-okumalı dağıtım.
class SkapiTemplateDetailScreen extends ConsumerStatefulWidget {
  const SkapiTemplateDetailScreen({
    super.key,
    required this.template,
    this.userTemplateId,
    this.libraryContext = const TemplateLibraryContext(),
  });

  final DeviceTemplate template;

  /// Dolu ise bu bir "Şablonlarım" kaydıdır: Gelişmiş sekmesindeki
  /// düzenlemeler kalıcı kaydedilebilir ve AppBar'dan silinebilir.
  final String? userTemplateId;

  final TemplateLibraryContext libraryContext;

  @override
  ConsumerState<SkapiTemplateDetailScreen> createState() =>
      _SkapiTemplateDetailScreenState();
}

class _SkapiTemplateDetailScreenState
    extends ConsumerState<SkapiTemplateDetailScreen> {
  int _tab = 0; // 0 = Form, 1 = Gelişmiş (JSON)
  final Map<String, String> _values = {};
  late final TextEditingController _advanced;

  /// Kullanıcı Gelişmiş sekmesinde metne dokunduysa artık ham metin
  /// doğruluk kaynağıdır; form paramları yeniden render ETMEZ (yazılanı
  /// ezmesin).
  bool _advancedDirty = false;

  String? _validationError; // null=henüz koşmadı, ''=geçerli
  bool _busy = false;

  DeviceTemplate get _tpl => widget.template;

  @override
  void initState() {
    super.initState();
    for (final p in _tpl.params) {
      _values[p.name] = p.defaultValue ?? '';
    }
    _advanced = TextEditingController(text: _renderedBody());
  }

  @override
  void dispose() {
    _advanced.dispose();
    super.dispose();
  }

  /// sd.* türlerinde cihaza gidecek gövde; bf.endpoint'te önizleme amaçlı
  /// eşdeğer JSON (gerçek kayıt editör ekranında kurulur).
  String _renderedBody() {
    if (_tpl.jsonBody != null) {
      final rendered = renderTemplate(_tpl.jsonBody!, _values);
      // Görsel tutarlılık: geçerli JSON'sa 2-boşluk girintiyle bas.
      try {
        return const JsonEncoder.withIndent('  ')
            .convert(jsonDecode(rendered));
      } catch (_) {
        return rendered; // doldurulmamış {{param}} decode'u bozar — ham bas
      }
    }
    final ep = _tpl.endpoint;
    if (ep == null) return '';
    return const JsonEncoder.withIndent('  ').convert({
      'type': ep.type,
      'method': ep.method,
      'url': renderTemplate(ep.urlTemplate, _values),
      'auth': ep.auth,
      if (ep.headerName != null) 'header': ep.headerName,
      if (ep.contentType != null) 'content_type': ep.contentType,
      if (ep.payloadTemplate != null)
        'payload': renderTemplate(ep.payloadTemplate!, _values),
      if (ep.delayAfterSec > 0) 'delay_after_sec': ep.delayAfterSec,
    });
  }

  /// Dağıtıma giden nihai gövde: Gelişmiş sekmesi kirliyse oradaki metin,
  /// değilse formdan render edilen.
  String get _effectiveBody =>
      _advancedDirty ? _advanced.text : _renderedBody();

  void _onParamChanged(String name, String value) {
    setState(() {
      _values[name] = value;
      _validationError = null;
      if (!_advancedDirty) _advanced.text = _renderedBody();
    });
  }

  // -- Doğrulama -------------------------------------------------------------

  String? _validate(String body) {
    final unresolved = unresolvedPlaceholders(body);
    if (unresolved.isNotEmpty) {
      return AppLocalizations.of(context)
          .skapiTplUnresolvedError(unresolved.join(', '));
    }
    switch (_tpl.targetKind) {
      case TemplateTargetKind.sdProfile:
        return validateProfileJson(body)?.kind.name;
      case TemplateTargetKind.sdMode:
        return validateModeBindingJson(body)?.kind.name;
      case TemplateTargetKind.sdSafe:
        return validateSafeEntryJson(body)?.kind.name;
      case TemplateTargetKind.bfEndpoint:
        final ep = _tpl.endpoint;
        if (ep == null) return 'endpoint yok';
        final err = validateBfEndpointFields(
          name: ep.defaultName,
          url: renderTemplate(ep.urlTemplate, _values),
          contentType: ep.contentType,
          payload: ep.payloadTemplate == null
              ? null
              : renderTemplate(ep.payloadTemplate!, _values),
          delayAfterSec: ep.delayAfterSec,
        );
        return err?.name;
    }
  }

  void _runValidation() {
    final err = _validate(_effectiveBody);
    setState(() => _validationError = err ?? '');
  }

  // -- Şablonlarıma kopyala ---------------------------------------------------

  Future<void> _copyToMine() async {
    final l = AppLocalizations.of(context);
    final now = DateTime.now().millisecondsSinceEpoch;
    final title = resolveSkapiI18nKey(l, _tpl.i18nTitle);
    var copy = UserTemplate.fromDeviceTemplate(
      _tpl,
      resolvedTitle: title,
      resolvedSummary: resolveSkapiI18nKey(l, _tpl.i18nSummary),
      nowMs: now,
    );
    final ep = _tpl.endpoint;
    if (_tpl.targetKind == TemplateTargetKind.bfEndpoint && ep != null) {
      copy = copy.copyWith(endpointJson: _endpointManifestJson(ep));
    }
    await ref.read(userTemplatesProvider.notifier).upsert(copy);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skapiTplCopiedToast(title), textAlign: TextAlign.center),
      ));
  }

  /// [ApiTemplateManifest]'in asset şemasına geri serileştirilmesi —
  /// UserTemplate.endpointJson üzerinden kayıpsız round-trip için.
  static String _endpointManifestJson(ApiTemplateManifest ep) => jsonEncode({
        'id': ep.id,
        'platform': ep.platform,
        'targetDeviceType': ep.targetDeviceType,
        'i18n': {
          'title': ep.i18nTitle,
          'summary': ep.i18nSummary,
          if (ep.i18nNote != null) 'note': ep.i18nNote,
        },
        'defaults': {
          'name': ep.defaultName,
          'type': ep.type,
          'url': ep.urlTemplate,
          'method': ep.method,
          'auth': ep.auth,
          if (ep.headerName != null) 'headerName': ep.headerName,
          if (ep.contentType != null) 'contentType': ep.contentType,
          if (ep.payloadTemplate != null) 'payload': ep.payloadTemplate,
          'delayAfterSec': ep.delayAfterSec,
        },
        'params': [
          for (final p in ep.params)
            {
              'name': p.name,
              'placeholder': p.placeholder,
              'i18nLabel': p.i18nLabel,
              if (p.i18nHint != null) 'i18nHint': p.i18nHint,
              if (p.defaultValue != null) 'default': p.defaultValue,
              'secret': p.secret,
            },
        ],
      });

  // -- Kullanıcı şablonu kaydet / sil ----------------------------------------

  Future<void> _saveUserTemplate() async {
    final l = AppLocalizations.of(context);
    final existing =
        ref.read(userTemplatesProvider.notifier).byId(widget.userTemplateId!);
    if (existing == null) return;
    await ref.read(userTemplatesProvider.notifier).upsert(existing.copyWith(
          jsonBody: _tpl.jsonBody == null ? null : _effectiveBody,
          updatedAtMs: DateTime.now().millisecondsSinceEpoch,
        ));
    if (!mounted) return;
    setState(() => _advancedDirty = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(l.skapiTplSavedToast, textAlign: TextAlign.center)));
  }

  Future<void> _deleteUserTemplate() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.skapiTplDeleteCta),
        content: Text(resolveSkapiI18nKey(l, _tpl.i18nTitle)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.skapiTplDeleteCta)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref
        .read(userTemplatesProvider.notifier)
        .remove(widget.userTemplateId!);
    if (mounted) Navigator.of(context).maybePop();
  }

  // -- Cihaza yükle ------------------------------------------------------------

  Future<void> _onDeploy() async {
    final l = AppLocalizations.of(context);

    // Zorunlu paramlar dolu mu? (Gelişmiş kirliyse metnin kendisi denetlenir.)
    final err = _validate(_effectiveBody);
    if (err != null) {
      setState(() {
        _validationError = err;
        _tab = 1;
      });
      return;
    }

    // Hedef cihaz: derin bağlantı bağlamı varsa sabit; yoksa seçici.
    PairedDevice? target;
    final paired = ref.read(pairedDevicesProvider);
    final ctxDeviceId = widget.libraryContext.deviceId;
    if (ctxDeviceId != null) {
      for (final d in paired) {
        if (d.id == ctxDeviceId) target = d;
      }
    }
    if (target == null) {
      final candidates = compatibleDevices(paired, _tpl.compatiblePrefixes);
      if (candidates.isEmpty) {
        await _noDevicesDialog(l);
        return;
      }
      target = await _pickDevice(candidates, l);
    }
    if (target == null || !mounted) return;

    if (!isDeviceRecentlySeen(target)) {
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

    // bf.endpoint: kayıt editör ekranında kurulur (param formu orada).
    if (_tpl.targetKind == TemplateTargetKind.bfEndpoint) {
      final ep = _tpl.endpoint;
      if (ep == null) return;
      await BfSession.pushForDevice<void>(
        context: context,
        deviceId: target.id,
        child: OnDeviceApiEditorScreen(
          deviceId: target.id,
          prefillTemplate: ep,
          titleKey: ApiEditorTitleKey.skapiEditor,
        ),
      );
      return;
    }

    final svc = ref.read(templateDeployServiceProvider);
    int? slot;
    int? safeEntry;

    if (_tpl.targetKind == TemplateTargetKind.sdMode) {
      // Referans profil cihazda var mı? Yoksa kullanıcıya açıkça sor.
      final profileId = _profileIdInBody(_effectiveBody);
      if (profileId != null) {
        setState(() => _busy = true);
        final ids = await svc.deviceProfileIds(target.id);
        if (!mounted) return;
        setState(() => _busy = false);
        if (ids.isNotEmpty && !ids.contains(profileId)) {
          final goOn = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l.skapiTplProfileMissingTitle),
              content: Text(l.skapiTplProfileMissingBody(profileId)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(l.commonCancel)),
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(l.skapiTplDeployAnyway)),
              ],
            ),
          );
          if (goOn != true || !mounted) return;
        }
      }
      setState(() => _busy = true);
      final slots = await svc.deviceModeSlots(target.id);
      if (!mounted) return;
      setState(() => _busy = false);
      slot = await _pickSlot(slots, l);
      if (slot == null || !mounted) return;
    }

    if (_tpl.targetKind == TemplateTargetKind.sdSafe) {
      safeEntry = await _pickSafeEntry(l);
      if (safeEntry == null || !mounted) return;
    }

    setState(() => _busy = true);
    final outcome = await svc.deploy(
      template: _tpl,
      deviceId: target.id,
      renderedJson: _effectiveBody,
      slot: slot,
      safeEntry: safeEntry,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    final msg = switch (outcome.status) {
      DeployStatus.ok => l.skapiTplDeployOkToast(target.displayName),
      DeployStatus.validationFailed =>
        l.skapiTplValidationFail(outcome.detail),
      DeployStatus.deviceError => l.skapiTplDeployErrorToast(outcome.detail),
      DeployStatus.mismatch => l.skapiTplDeployMismatchToast(outcome.detail),
      DeployStatus.offline => l.skapiTplDeployOfflineToast,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        duration: const Duration(seconds: 4),
      ));
    if (outcome.ok && widget.libraryContext.isDeepLink) {
      // Derin bağlantı akışı: dağıtım bitti, cihaz ekranına geri dön.
      Navigator.of(context).maybePop();
    }
  }

  static String? _profileIdInBody(String body) {
    try {
      final m = jsonDecode(body);
      if (m is Map && m['profile'] is String) return m['profile'] as String;
    } catch (_) {}
    return null;
  }

  Future<void> _noDevicesDialog(AppLocalizations l) async {
    final goToDevices = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.skapiNewActionNoDevicesTitle),
        content: Text(l.skapiNewActionNoDevicesBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.skapiNewActionNoDevicesCta)),
        ],
      ),
    );
    if (goToDevices == true && mounted) {
      ref.read(selectedTabProvider.notifier).set(1);
    }
  }

  Future<PairedDevice?> _pickDevice(
      List<PairedDevice> devices, AppLocalizations l) {
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
                Text(l.skapiNewActionPickDeviceTitle,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final d in devices)
                  Builder(builder: (_) {
                    final online = isDeviceRecentlySeen(d);
                    return ListTile(
                      enabled: online,
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                        color: online
                            ? Colors.green.shade600
                            : cs.onSurface.withValues(alpha: 0.30),
                      ),
                      title: Text(d.displayName),
                      subtitle: Text(
                        online ? d.id : '${d.id} · ${l.skapiTplDeviceOffline}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      onTap: online ? () => Navigator.of(ctx).pop(d) : null,
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int?> _pickSlot(Map<int, String?> slots, AppLocalizations l) {
    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final tt = Theme.of(ctx).textTheme;
        final cs = Theme.of(ctx).colorScheme;
        final entries = slots.isEmpty
            ? {1: null, 2: null, 3: null}.entries.toList()
            : (slots.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.skapiTplPickSlotTitle,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final e in entries)
                  ListTile(
                    leading: Icon(
                      e.value == null
                          ? Icons.radio_button_unchecked
                          : Icons.radio_button_checked,
                      color: cs.onSurfaceVariant,
                    ),
                    title: Text('Slot ${e.key}'),
                    subtitle: Text(
                      e.value == null || e.value!.isEmpty
                          ? l.skapiTplSlotEmpty
                          : e.value!,
                    ),
                    onTap: () => Navigator.of(ctx).pop(e.key),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int?> _pickSafeEntry(AppLocalizations l) {
    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final tt = Theme.of(ctx).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.skapiTplPickSafeEntryTitle,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (int i = 1; i <= 5; i++)
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text('$i'),
                    onTap: () => Navigator.of(ctx).pop(i),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -- Build -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final title = resolveSkapiI18nKey(l, _tpl.i18nTitle);
    final summary = resolveSkapiI18nKey(l, _tpl.i18nSummary);
    final note =
        _tpl.i18nNote == null ? null : resolveSkapiI18nKey(l, _tpl.i18nNote!);

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (widget.userTemplateId != null)
            IconButton(
              tooltip: l.skapiTplDeleteCta,
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteUserTemplate,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Başlık altı: tür + uyumluluk rozetleri + hedef komut.
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TemplateKindBadge(kind: _tpl.targetKind),
                    for (final p in _tpl.compatiblePrefixes)
                      DevicePrefixChip(prefix: p),
                    Text(
                      _deployCommandLabel(),
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (summary.isNotEmpty)
                  SkNeuCard(
                    padding: const EdgeInsets.all(14),
                    child: Text(summary, style: tt.bodyMedium),
                  ),
                if (note != null) ...[
                  const SizedBox(height: 12),
                  SkNeuCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            size: 18,
                            color: cs.onSurface.withValues(alpha: 0.65)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            note,
                            style: tt.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: cs.onSurface.withValues(alpha: 0.80),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                _TabSelector(
                  selected: _tab,
                  formLabel: l.skapiTplDetailFormTab,
                  jsonLabel: l.skapiTplDetailJsonTab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 14),
                if (_tab == 0) ...[
                  if (_tpl.params.isEmpty)
                    SkNeuCard(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        _tpl.targetKind == TemplateTargetKind.bfEndpoint
                            ? l.skapiTplUploadFilledInEditor
                            : l.skapiTplNoParams,
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    )
                  else
                    SkNeuCard(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                      child: Column(
                        children: [
                          for (final p in _tpl.params)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: _ParamField(
                                param: p,
                                value: _values[p.name] ?? '',
                                onChanged: (v) => _onParamChanged(p.name, v),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      l.skapiTplPreviewHeading.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  _JsonCard(text: _effectiveBody),
                ] else ...[
                  SkNeuCard(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _advanced,
                      readOnly:
                          _tpl.targetKind == TemplateTargetKind.bfEndpoint,
                      maxLines: 14,
                      minLines: 6,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12.5),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {
                        _advancedDirty = true;
                        _validationError = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _runValidation,
                        icon: const Icon(Icons.rule, size: 18),
                        label: Text(l.skapiTplValidateCta),
                      ),
                      const SizedBox(width: 10),
                      if (_validationError != null)
                        Expanded(
                          child: Text(
                            _validationError!.isEmpty
                                ? l.skapiTplValidationOk
                                : l.skapiTplValidationFail(_validationError!),
                            style: tt.bodySmall?.copyWith(
                              color: _validationError!.isEmpty
                                  ? Colors.green.shade700
                                  : SkColors.warnRed,
                            ),
                          ),
                        ),
                      if (widget.userTemplateId != null &&
                          _advancedDirty) ...[
                        const Spacer(),
                        TextButton(
                          onPressed: _saveUserTemplate,
                          child: Text(l.skapiTplSaveCta),
                        ),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            widget.userTemplateId == null ? _copyToMine : null,
                        icon: const Icon(Icons.copy_all_outlined, size: 18),
                        label: Text(l.skapiTplCopyCta),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DeployCta(
                        label: l.skapiTplDeployCta,
                        busy: _busy,
                        onTap: _busy ? null : _onDeploy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _deployCommandLabel() => switch (_tpl.targetKind) {
        TemplateTargetKind.bfEndpoint => 'api.endpoint.add',
        TemplateTargetKind.sdProfile => 'profile.add',
        TemplateTargetKind.sdMode => 'mode.set',
        TemplateTargetKind.sdSafe => 'safe.set',
      };
}

/// Form / Gelişmiş sekme seçici — SkNeuCard well zemininde iki pill.
class _TabSelector extends StatelessWidget {
  const _TabSelector({
    required this.selected,
    required this.formLabel,
    required this.jsonLabel,
    required this.onChanged,
  });

  final int selected;
  final String formLabel;
  final String jsonLabel;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    Widget pill(int index, String label) {
      final on = selected == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: on
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: on
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ]
                  : const [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: on ? cs.onSurface : cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(children: [pill(0, formLabel), pill(1, jsonLabel)]),
    );
  }
}

/// Tek param alanı — tipe göre dropdown / sayısal / gizli / düz metin.
class _ParamField extends StatelessWidget {
  const _ParamField({
    required this.param,
    required this.value,
    required this.onChanged,
  });

  final TemplateParam param;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = resolveSkapiI18nKey(l, param.i18nLabel);
    final hint = param.i18nHint == null
        ? param.placeholder
        : '${resolveSkapiI18nKey(l, param.i18nHint!)} — ${param.placeholder}';

    if (param.type == 'enum' && (param.allowedValues?.isNotEmpty ?? false)) {
      return DropdownButtonFormField<String>(
        initialValue: value.isEmpty ? null : value,
        items: [
          for (final v in param.allowedValues!)
            DropdownMenuItem(value: v, child: Text(v)),
        ],
        onChanged: (v) => onChanged(v ?? ''),
        decoration: InputDecoration(
          labelText: label,
          helperText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      );
    }

    return TextFormField(
      initialValue: value,
      obscureText: param.secret,
      autocorrect: !param.secret,
      enableSuggestions: !param.secret,
      keyboardType: switch (param.type) {
        'int' => TextInputType.number,
        'host' => TextInputType.url,
        _ => TextInputType.text,
      },
      decoration: InputDecoration(
        labelText: param.required ? label : '$label (${l.skapiTplOptional})',
        helperText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }
}

/// Salt-okunur JSON önizleme kutusu (well görünümü).
class _JsonCard extends StatelessWidget {
  const _JsonCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.5,
            color: cs.onSurface.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

/// Hardal "Cihaza yükle" CTA'sı — SkapiApiTemplateDetailScreen._UploadCta
/// deseninin busy destekli hali.
class _DeployCta extends StatelessWidget {
  const _DeployCta({required this.label, required this.busy, this.onTap});
  final String label;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SkColors.attentionMustard
          .withValues(alpha: onTap == null ? 0.55 : 1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: SkColors.black),
                )
              else
                const Icon(Icons.upload_rounded,
                    color: SkColors.black, size: 18),
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
