// API zinciri editor, bf.html bf-api-chain ekranının Flutter karşılığı.
//
// All endpoint data flows through the live `api.*` CLI surface:
//   api.status            → master switch state + endpoint count
//   api.endpoint.list     → full endpoint records
//   api.on / api.off      → master switch toggle (non-critical)
//   api.endpoint.add      → upsert endpoint  (critical, sendCritical)
//   api.endpoint.remove   → delete endpoint  (critical, sendCritical)
//   api.send              → manual fire one endpoint
//   api.chain.run         → fire all enabled endpoints in order
//
// BF endpoint shape (sk_api.c):
//   { slot, name, type:"generic"|"ifttt"|"webhook_post", url, method,
//     auth:"none"|"bearer"|"basic"|"header", header, content_type,
//     masked_token, delay_after_sec }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cli/cli_client.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_confirm_dialog.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../devices/bf/bf_session.dart';
import '../main_shell/main_shell.dart';
import '../devices/bf/widgets/bootstrap_banner.dart';
import 'data/api_endpoint.dart';
import 'data/script_manifest.dart';
import 'data/system_endpoint_sync_service.dart';
import 'widgets/on_device_api_endpoint_card.dart';


/// AppBar title bağlam seçici. BF dashboard'dan açıldığında "API Zinciri",
/// SKAPI pill / Other template'ından açıldığında "Cihaz Üzeri API".
enum ApiEditorTitleKey { bfDashboard, skapiEditor }

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// On-device API endpoint editor.
///
/// Manages the 5 USER + 8 SYSTEM slots a paired device exposes through
/// `api.endpoint.*` / `api.system.*` CLI commands. Same screen serves both
/// entry points:
///   * BF dashboard "API zinciri" tile (full management view).
///   * SKAPI "+ Yeni Aksiyon" pill + `other` template detail
///     "Cihaza yükle" CTA. These supply a [prefillTemplate] so the editor
///     opens with one USER slot draft already populated from the template.
///
/// The screen relies on [BfSession] being available in the route's
/// `InheritedWidget` chain — both entry points wrap the push in
/// `BfSession.providerWrapper` so the CLI client + device id are
/// resolvable from inside the widget tree.
class OnDeviceApiEditorScreen extends StatefulWidget {
  const OnDeviceApiEditorScreen({
    super.key,
    required this.deviceId,
    this.prefillTemplate,
    this.titleKey = ApiEditorTitleKey.bfDashboard,
  });

  final String deviceId;

  /// When non-null, after [_bootstrap] finishes the editor seeds an
  /// expanded USER draft populated from the template (name, type, url,
  /// method, auth, headers, payload, delay-after). Placeholders inside
  /// the url/payload templates (`{{key}}`) are left verbatim for the
  /// user to fill manually for now; smart param substitution UI lands
  /// alongside S2.5 when the Other template detail screen wires
  /// "Cihaza yükle" through here.
  final ApiTemplateManifest? prefillTemplate;

  /// AppBar title selector. BF dashboard "API zinciri" tile'ından açıldığında
  /// `bfDashboard` (varsayılan) — kullanıcı zaten "API Zinciri" çinde
  /// olduğunu biliyor. SKAPI pill / Other template'ından açıldığında
  /// `skapiEditor` ("Cihaz Üzeri API") — bağlam SKAPI'dir, BF terminolojisi
  /// kafa karıştırır.
  final ApiEditorTitleKey titleKey;

  @override
  State<OnDeviceApiEditorScreen> createState() => _OnDeviceApiEditorScreenState();
}

class _OnDeviceApiEditorScreenState extends State<OnDeviceApiEditorScreen> {
  bool _loading = true;
  bool _masterOn = false;
  String? _loadError;
  final List<ApiEndpoint> _endpoints = [];
  bool _bootstrapped = false;

  // Capacity constants mirror sk_api.h. Hard-coded here so the screen
  // doesn't need a CLI roundtrip just to render the "{N}/{cap}" badge —
  // they only change with a firmware version bump.
  static const int _userSlotCapacity   = 5;
  static const int _systemSlotCapacity = 8;

  List<ApiEndpoint> get _userEndpoints =>
      _endpoints.where((e) => e.kind == ApiKind.user).toList(growable: false);
  List<ApiEndpoint> get _systemEndpoints =>
      _endpoints.where((e) => e.kind == ApiKind.system).toList(growable: false);

  /// `slot < 0` = SKAPP-side draft (henüz cihaza yazılmadı). Refresh /
  /// retry, `_endpoints` listesini cihaz state'i ile değiştirdiği için
  /// bu taslakları sessizce siler; dirty olduğumuzda kullanıcıdan
  /// kaybı kabul edip etmediğini soruyoruz.
  bool get _hasUnsavedDrafts =>
      _userEndpoints.any((e) => e.slot < 0);

  /// Refresh / retry'den önce taslak kontrolü. Dirty değilse direkt true
  /// döner ve _bootstrap'i tetikler. Dirty ise onay dialogu gösterir;
  /// kullanıcı "Yine de yenile" derse true, "İptal" derse false.
  Future<void> _refreshWithConfirm() async {
    if (_hasUnsavedDrafts) {
      final l = AppLocalizations.of(context);
      final go = await showDialog<bool>(
        context: context,
        builder: (dlgCtx) => AlertDialog(
          title: Text(l.bfApiChainRefreshDirtyTitle),
          content: Text(l.bfApiChainRefreshDirtyBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dlgCtx).pop(false),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dlgCtx).pop(true),
              child: Text(l.bfApiChainRefreshDirtyConfirm),
            ),
          ],
        ),
      );
      if (go != true || !mounted) return;
    }
    setState(() {
      _bootstrapped = false;
      _loading = true;
    });
    await _bootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    String? loadErr;
    bool masterOn = false;
    final endpoints = <ApiEndpoint>[];

    try {
      final s = await client.send('api.status');
      if (s.ok && s.data is Map) {
        masterOn = (s.data as Map)['master_enabled'] == true;
      }
    } catch (_) {/* api.status fail tolere edilir; master OFF default */}

    try {
      final r = await client.send('api.endpoint.list');
      if (r.ok) {
        final raw = r.data is List
            ? r.data as List
            : (r.data is Map
                ? ((r.data as Map)['endpoints'] as List? ?? const [])
                : const []);
        for (final e in raw) {
          if (e is Map) {
            endpoints
                .add(ApiEndpoint.fromJson(Map<String, dynamic>.from(e)));
          }
        }
      } else {
        loadErr = r.err ?? l.commonReadFailed;
      }
    } catch (e) {
      loadErr = e.toString();
    }

    if (!mounted) return;
    setState(() {
      _masterOn = masterOn;
      _endpoints
        ..clear()
        ..addAll(endpoints);
      _loading = false;
      _loadError = loadErr;
    });

    // Template prefill happens once, only on the bootstrap that follows
    // the initial mount. A refresh (pull-to-refresh / refresh icon) will
    // also call _bootstrap, but by then the user has either saved the
    // draft (so a real endpoint with the same name exists and a re-seed
    // would be a duplicate row) or discarded it (re-seeding would be
    // confusing). Guarding on _bootstrapped-was-just-flipped is the
    // simplest way to express "once".
    final tpl = widget.prefillTemplate;
    if (tpl != null && _userEndpoints.where((e) => e.name == tpl.defaultName).isEmpty) {
      _seedTemplateDraft(tpl);
    }
  }

  void _seedTemplateDraft(ApiTemplateManifest tpl) {
    // Truncate at firmware-imposed limits so we never produce a draft
    // the device would silently reject at save time. Limits live in
    // sk_api.h (SK_API_NAME_MAX = 31, SK_API_URL_MAX = 191, etc).
    String trunc(String s, int max) => s.length <= max ? s : s.substring(0, max);

    setState(() {
      _endpoints.add(ApiEndpoint(
        name: trunc(tpl.defaultName, 31),
        type: typeFromWire(tpl.type),
        url: trunc(tpl.urlTemplate, 191),
        method: methodFromWire(tpl.method),
        auth: authFromWire(tpl.auth),
        headerName: tpl.headerName,
        contentType: tpl.contentType,
        delayAfterSec: tpl.delayAfterSec.clamp(0, 300),
        expanded: true,
      ));
    });
  }

  Future<void> _setMaster(bool enable) async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    final r = await client.send(enable ? 'api.on' : 'api.off');
    if (!mounted) return;
    if (r.ok) {
      setState(() => _masterOn = enable);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainMasterError(r.err ?? "ERR_UNKNOWN"))),
      );
    }
  }

  Future<void> _runChain() async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    // Force-sync the listener URL + time + purge any orphan SYSTEM
    // slots BEFORE firing the chain. Without this, the test button
    // can hit BF's stale NVS slot from an old SKAPP install (orphan
    // peer_id) → 10-second TCP timeout to an unreachable URL → user
    // sees "test button does nothing for ~30s, then a vague error".
    // forceSync awaits (push time.set → purge → re-add own URL) so by
    // the time api.chain.run reaches BF, only the current SKAPP's
    // valid URL is in the SYSTEM bucket.
    try {
      // No Consumer scope here (plain StatefulWidget), so reach the
      // service via the enclosing ProviderScope's container. This is
      // the documented escape hatch for triggering a one-shot
      // operation outside the build phase.
      final container = ProviderScope.containerOf(context, listen: false);
      await container
          .read(systemEndpointSyncServiceProvider)
          .forceSync(reason: 'chain-test');
    } catch (e) {
      debugPrint('[BF-API] pre-test sync failed: $e');
    }
    // Use the same event name BF emits at the natural countdown end
    // (`timer.expired`) so user-created bindings — typically filtered
    // on that event — actually match. Without an explicit payload BF
    // falls back to the synthetic `manual_test` event (sk_api.c:1339)
    // which no real binding subscribes to and the activity log shows
    // the misleading "Eşleşen binding yok" warning.
    final r = await client.send(
      'api.chain.run',
      args: {
        'payload': '{"event":"timer.expired","source":"manual_test",'
            '"device":"\$id"}',
      },
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(r.ok
            ? l.bfApiChainChainStarted
            : l.bfApiChainChainError(r.err ?? l.commonUnknown)),
      ),
    );
  }

  Future<void> _saveEndpoint(ApiEndpoint draft, String? plainToken) async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    final args = <String, dynamic>{
      'name': draft.name,
      'type': typeWire(draft.type),
      'url': draft.url,
      'method': methodWire(draft.method),
      'auth': authWire(draft.auth),
      'delay-after': draft.delayAfterSec.toString(),
    };
    if (plainToken != null && plainToken.isNotEmpty) {
      args['token'] = plainToken;
    }
    if (draft.headerName != null && draft.headerName!.isNotEmpty) {
      args['header-name'] = draft.headerName!;
    }
    if (draft.contentType != null && draft.contentType!.isNotEmpty) {
      args['content-type'] = draft.contentType!;
    }

    final r = await client.sendCritical(
      'api.endpoint.add',
      args: args,
      confirmRequest: _confirmDialog(
        title: l.bfApiChainSaveDialogTitle,
        body: l.bfApiChainSaveDialogBody(draft.name),
        confirmLabel: l.bfApiChainSaveDialogConfirm,
      ),
    );

    if (!mounted) return;
    if (r.ok) {
      await _bootstrap();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainSavedToast(draft.name))),
      );
    } else if (r.err == 'ERR_CONFIRM_TOKEN_REQUIRED') {
      // user cancelled the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainSaveFailed(r.err ?? "ERR_UNKNOWN"))),
      );
    }
  }

  Future<void> _removeEndpoint(ApiEndpoint endpoint) async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    final r = await client.sendCritical(
      'api.endpoint.remove',
      args: {'name': endpoint.name},
      confirmRequest: _confirmDialog(
        title: l.bfApiChainDeleteDialogTitle,
        body: l.bfApiChainDeleteDialogBody(endpoint.name),
        confirmLabel: l.bfApiChainDeleteDialogConfirm,
        destructive: true,
      ),
    );
    if (!mounted) return;
    if (r.ok) {
      setState(() => _endpoints.remove(endpoint));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainDeletedToast(endpoint.name))),
      );
    } else if (r.err == 'ERR_CONFIRM_TOKEN_REQUIRED') {
      // user cancelled
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainDeleteFailed(r.err ?? "ERR_UNKNOWN"))),
      );
    }
  }

  Future<void> _testEndpoint(ApiEndpoint endpoint) async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);

    // sk_api_send queues the HTTPS request on a worker task and replies
    // with `{queued:true}`, the real result lands later as an `api.sent`
    // event with ok+status+err. Subscribe BEFORE firing so we never miss
    // the response, then race a 15s timeout: long enough for one TLS
    // handshake + small body, short enough that a stuck worker doesn't
    // sit on the snackbar forever.
    final result = Completer<Map<String, dynamic>?>();
    final sub = client.events.listen((evt) {
      if (evt['evt'] != 'api.sent') return;
      final data = evt['data'];
      if (data is Map && data['name'] == endpoint.name && !result.isCompleted) {
        result.complete(Map<String, dynamic>.from(data));
      }
    });
    final timer = Timer(const Duration(seconds: 15), () {
      if (!result.isCompleted) result.complete(null);
    });

    final r = await client.send('api.send', args: {'name': endpoint.name});
    if (!r.ok) {
      await sub.cancel();
      timer.cancel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfApiChainTestTriggerFailed(r.err ?? l.commonUnknown))),
      );
      return;
    }

    final outcome = await result.future;
    await sub.cancel();
    timer.cancel();
    if (!mounted) return;

    String msg;
    if (outcome == null) {
      msg = l.bfApiChainTestNoReply(endpoint.name);
    } else if (outcome['ok'] == true) {
      final status = outcome['status'];
      final httpSuffix = status is int && status > 0 ? ' (HTTP $status)' : '';
      msg = l.bfApiChainTestSuccess(endpoint.name, httpSuffix);
    } else {
      final err = outcome['err']?.toString() ?? l.commonUnknown;
      final status = outcome['status'];
      final httpSuffix = status is int && status > 0 ? ' (HTTP $status)' : '';
      msg = l.bfApiChainTestFailure(endpoint.name, err, httpSuffix);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),
    );
  }

  /// Builds a confirmRequest callback that shows a Material dialog with
  /// the given copy. Used by the sendCritical wrappers above.
  Future<bool> Function(CliConfirmRequest) _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) {
    final l = AppLocalizations.of(context);
    return (req) async {
      if (!context.mounted) return false;
      return showSkConfirm(
        context,
        title: title,
        message: body,
        confirmLabel: confirmLabel,
        cancelLabel: l.commonCancel,
        destructive: destructive,
      );
    };
  }

  void _addDraft() {
    final l = AppLocalizations.of(context);
    setState(() {
      _endpoints.add(ApiEndpoint(
        name: l.bfApiChainNewEndpointName,
        type: ApiType.generic,
        url: 'https://',
        method: HttpMethod.post,
        contentType: 'application/json',
        expanded: true,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(switch (widget.titleKey) {
          ApiEditorTitleKey.bfDashboard => l.bfDashboardApiChainTitle,
          ApiEditorTitleKey.skapiEditor => l.skapiApiEditorTitle,
        }),
        actions: [
          IconButton(
            tooltip: l.commonRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWithConfirm,
          ),
          IconButton(
            tooltip: l.bfApiChainRunChain,
            icon: const Icon(Icons.play_arrow),
            onPressed: _endpoints.isEmpty || !_masterOn ? null : _runChain,
          ),
          IconButton(
            tooltip: l.bfApiChainToggleAll,
            icon: const Icon(Icons.unfold_more),
            onPressed: _endpoints.isEmpty
                ? null
                : () {
                    final anyOpen = _endpoints.any((s) => s.expanded);
                    setState(() {
                      for (final s in _endpoints) {
                        s.expanded = !anyOpen;
                      }
                    });
                  },
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              children: [
                if (_loadError != null)
                  BootstrapBanner(
                    error: _loadError!,
                    onRetry: _refreshWithConfirm,
                  ),
                _MasterSwitch(
                  value: _masterOn,
                  onChanged: _setMaster,
                ),
                const SizedBox(height: 18),
                if (_endpoints.isEmpty && _loadError == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.link_off,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text(
                              l.bfApiChainEmptyTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.bfApiChainEmptyBody,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                // SYSTEM bucket — auto-managed (paired SKAPP'lar).
                // Read-only: edits / removes happen on the matching
                // SKAPP install's side via api.system.* CLI from SKAPI.
                if (_systemEndpoints.isNotEmpty) ...[
                  _SectionHeader(
                    title: l.bfApiChainSystemSectionTitle,
                    subtitle: l.bfApiChainSystemSectionSubtitle,
                    badge:
                        '${_systemEndpoints.length}/$_systemSlotCapacity',
                  ),
                  for (final ep in _systemEndpoints)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SystemRow(endpoint: ep, onTest: () => _testEndpoint(ep)),
                    ),
                  const SizedBox(height: 8),
                ],

                // USER bucket — manuel IoT (Shelly, Home Assistant, IFTTT).
                _SectionHeader(
                  title: l.bfApiChainUserSectionTitle,
                  subtitle: l.bfApiChainUserSectionSubtitle,
                  badge: '${_userEndpoints.length}/$_userSlotCapacity',
                ),
                for (int i = 0; i < _userEndpoints.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EndpointCard(
                      endpoint: _userEndpoints[i],
                      onChange: () => setState(() {}),
                      onSave: _saveEndpoint,
                      onRemove: () => _removeEndpoint(_userEndpoints[i]),
                      onTest: () => _testEndpoint(_userEndpoints[i]),
                    ),
                  ),
                if (_userEndpoints.length < _userSlotCapacity)
                  _AddCard(onAdd: _addDraft),
              ],
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Master switch
// ---------------------------------------------------------------------------

class _MasterSwitch extends StatelessWidget {
  const _MasterSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SkNeuCard(
      onTap: () => onChanged(!value),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SkNeuIconSlot(
            icon: Icons.power_settings_new,
            size: 40,
            iconSize: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.bfApiChainMasterToggleLabel,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  value
                      ? l.bfApiChainMasterOnSubtitle
                      : l.bfApiChainMasterOffSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SkNeuSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "+ Yeni endpoint" footer card
// ---------------------------------------------------------------------------

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return SkNeuCard(
      onTap: onAdd,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.bfApiChainAddCardLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header (USER vs SYSTEM bucket separator)
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  final String title;
  final String subtitle;
  /// `{used}/{cap}` chip rendered on the right.
  final String badge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurface,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badge,
                  style: tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SYSTEM row — read-only display of a paired SKAPP's auto-managed slot
// ---------------------------------------------------------------------------

class _SystemRow extends StatelessWidget {
  const _SystemRow({required this.endpoint, required this.onTest});
  final ApiEndpoint endpoint;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    final pid = endpoint.peerIdHex ?? '';
    final pidShort = pid.length >= 8 ? pid.substring(0, 8) : pid;
    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      child: Row(
        children: [
          Icon(Icons.computer, size: 18, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        endpoint.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SYSTEM',
                        style: tt.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  endpoint.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                if (pidShort.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    l.bfApiChainSystemRowSignedTooltip(
                        pidShort, endpoint.delayAfterSec),
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: l.bfApiChainTestEndpointTooltip,
            icon: const Icon(Icons.send_outlined),
            onPressed: onTest,
          ),
        ],
      ),
    );
  }
}
