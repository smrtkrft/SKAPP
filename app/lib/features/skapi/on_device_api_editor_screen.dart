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
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../devices/bf/bf_session.dart';
import '../main_shell/main_shell.dart';
import '../devices/bf/widgets/bootstrap_banner.dart';
import 'data/script_manifest.dart';
import 'data/system_endpoint_sync_service.dart';

// ---------------------------------------------------------------------------
// Wire-format ↔ enum conversions
// ---------------------------------------------------------------------------

enum ApiType { generic, ifttt, webhookPost }

String _typeWire(ApiType t) => switch (t) {
      ApiType.generic => 'generic',
      ApiType.ifttt => 'ifttt',
      ApiType.webhookPost => 'webhook_post',
    };

ApiType _typeFromWire(String? s) => switch (s) {
      'generic' => ApiType.generic,
      'ifttt' => ApiType.ifttt,
      'webhook_post' => ApiType.webhookPost,
      _ => ApiType.generic,
    };

String _typeLabel(ApiType t) => switch (t) {
      ApiType.generic => 'Generic HTTP',
      ApiType.ifttt => 'IFTTT',
      ApiType.webhookPost => 'Webhook (POST)',
    };

String _typeBadgeText(ApiType t) => switch (t) {
      ApiType.generic => 'GEN',
      ApiType.ifttt => 'IF',
      ApiType.webhookPost => 'WH',
    };

enum HttpMethod { get, post, put, delete }

String _methodWire(HttpMethod m) => switch (m) {
      HttpMethod.get => 'GET',
      HttpMethod.post => 'POST',
      HttpMethod.put => 'PUT',
      HttpMethod.delete => 'DELETE',
    };

HttpMethod _methodFromWire(String? s) => switch (s?.toUpperCase()) {
      'GET' => HttpMethod.get,
      'POST' => HttpMethod.post,
      'PUT' => HttpMethod.put,
      'DELETE' => HttpMethod.delete,
      _ => HttpMethod.post,
    };

enum AuthMode { none, bearer, basic, header }

String _authWire(AuthMode a) => a.name;

AuthMode _authFromWire(String? s) => switch (s) {
      'none' => AuthMode.none,
      'bearer' => AuthMode.bearer,
      'basic' => AuthMode.basic,
      'header' => AuthMode.header,
      _ => AuthMode.none,
    };

String _authLabel(AppLocalizations l, AuthMode a) => switch (a) {
      AuthMode.none => l.bfApiChainAuthNone,
      AuthMode.bearer => l.bfApiChainAuthBearer,
      AuthMode.basic => l.bfApiChainAuthBasic,
      AuthMode.header => l.bfApiChainAuthHeader,
    };

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

/// Endpoint bucket kind, mirrors firmware sk_api_kind_t.
///   user   = manual IoT webhook (max SK_API_USER_SLOTS slots, fully editable)
///   system = auto-managed entry owned by a paired SKAPP install
///            (read-only here; the SKAPP install with the matching
///             peer_id manages it via api.system.add/remove from its
///             SKAPI bindings flow)
enum ApiKind { user, system }

ApiKind _kindFromWire(String? s) => switch (s) {
      'system' => ApiKind.system,
      _ => ApiKind.user,
    };

class ApiEndpoint {
  ApiEndpoint({
    required this.name,
    required this.type,
    required this.url,
    this.method = HttpMethod.post,
    this.auth = AuthMode.none,
    this.headerName,
    this.contentType,
    this.maskedToken,
    this.delayAfterSec = 0,
    this.slot = -1,
    this.expanded = false,
    this.kind = ApiKind.user,
    this.peerIdHex,
  });

  String name;
  ApiType type;
  String url;
  HttpMethod method;
  AuthMode auth;
  String? headerName;
  String? contentType;

  /// BF returns a masked preview of the stored token (e.g. `sk_…AbCd`).
  /// SKAPP never gets the plaintext, to rotate, the user supplies a new
  /// value via the "Token" field which goes back as `--token <plain>`.
  String? maskedToken;

  int delayAfterSec;

  /// Slot index assigned by BF.
  ///   user   bucket: 0..SK_API_USER_SLOTS-1
  ///   system bucket: 0..SK_API_SYSTEM_SLOTS-1
  /// -1 means "not yet saved" (only used for in-progress USER drafts).
  int slot;

  /// UI-only: card expanded for editing.
  bool expanded;

  /// Bucket — manuel IoT (user) vs paired SKAPP (system).
  ApiKind kind;

  /// SYSTEM kind only: full hex of the peer_id that owns this slot.
  /// Empty string for USER kind. Used to label the read-only row with
  /// the SKAPP install identity.
  String? peerIdHex;

  factory ApiEndpoint.fromJson(Map<String, dynamic> j) => ApiEndpoint(
        slot: (j['slot'] as num?)?.toInt() ?? -1,
        name: (j['name'] ?? '').toString(),
        type: _typeFromWire(j['type']?.toString()),
        url: (j['url'] ?? '').toString(),
        method: _methodFromWire(j['method']?.toString()),
        auth: _authFromWire(j['auth']?.toString()),
        headerName: (j['header'] as String?) ??
            (j['header_name'] as String?),
        contentType: j['content_type']?.toString(),
        maskedToken: j['masked_token']?.toString(),
        delayAfterSec:
            (j['delay_after_sec'] as num?)?.toInt() ?? 0,
        kind: _kindFromWire(j['kind']?.toString()),
        peerIdHex: (j['peer_id'] as String?) ?? '',
      );
}

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
        type: _typeFromWire(tpl.type),
        url: trunc(tpl.urlTemplate, 191),
        method: _methodFromWire(tpl.method),
        auth: _authFromWire(tpl.auth),
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
      'type': _typeWire(draft.type),
      'url': draft.url,
      'method': _methodWire(draft.method),
      'auth': _authWire(draft.auth),
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
        confirmColor: Theme.of(context).colorScheme.error,
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
    Color? confirmColor,
  }) {
    final l = AppLocalizations.of(context);
    return (req) async {
      if (!context.mounted) return false;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              child: Text(confirmLabel),
            ),
          ],
        ),
      );
      return ok == true;
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
                    child: _EndpointCard(
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
// Endpoint card (head + expandable body)
// ---------------------------------------------------------------------------

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({
    required this.endpoint,
    required this.onChange,
    required this.onSave,
    required this.onRemove,
    required this.onTest,
  });

  final ApiEndpoint endpoint;
  final VoidCallback onChange;
  final Future<void> Function(ApiEndpoint draft, String? plainToken) onSave;
  final VoidCallback onRemove;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Head(endpoint: endpoint, onChange: onChange),
          if (endpoint.expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: _Body(
                endpoint: endpoint,
                onChange: onChange,
                onSave: onSave,
                onRemove: onRemove,
                onTest: onTest,
              ),
            ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({required this.endpoint, required this.onChange});
  final ApiEndpoint endpoint;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final saved = endpoint.slot >= 0;
    return InkWell(
      onTap: () {
        endpoint.expanded = !endpoint.expanded;
        onChange();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            _TypeBadge(type: endpoint.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    endpoint.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      _typeLabel(endpoint.type),
                      _methodWire(endpoint.method),
                      if (endpoint.delayAfterSec > 0)
                        l.bfApiChainSavedDelaySeconds(endpoint.delayAfterSec),
                      if (!saved) l.bfApiChainNotSaved,
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: endpoint.expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 160),
              child: Icon(Icons.expand_more, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Endpoint editing form
// ---------------------------------------------------------------------------

class _Body extends StatefulWidget {
  const _Body({
    required this.endpoint,
    required this.onChange,
    required this.onSave,
    required this.onRemove,
    required this.onTest,
  });

  final ApiEndpoint endpoint;
  final VoidCallback onChange;
  final Future<void> Function(ApiEndpoint draft, String? plainToken) onSave;
  final VoidCallback onRemove;
  final VoidCallback onTest;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final TextEditingController _name;
  late final TextEditingController _url;
  late final TextEditingController _delay;
  late final TextEditingController _headerName;
  late final TextEditingController _contentType;
  late final TextEditingController _newToken;
  bool _saving = false;
  bool _showAdvanced = false;

  late ApiType _type;
  late HttpMethod _method;
  late AuthMode _auth;

  @override
  void initState() {
    super.initState();
    final e = widget.endpoint;
    _name = TextEditingController(text: e.name);
    _url = TextEditingController(text: e.url);
    _delay = TextEditingController(text: '${e.delayAfterSec}');
    _headerName = TextEditingController(text: e.headerName ?? '');
    _contentType =
        TextEditingController(text: e.contentType ?? 'application/json');
    _newToken = TextEditingController();
    _type = e.type;
    _method = e.method;
    _auth = e.auth;
  }

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _delay.dispose();
    _headerName.dispose();
    _contentType.dispose();
    _newToken.dispose();
    super.dispose();
  }

  /// Strip duplicated scheme prefixes ("https://http://example.com",
  /// "http://https://...") and trailing whitespace. The endpoint editor
  /// previously wrote whatever the user typed straight to the device,
  /// where esp_http_client failed the malformed URL with ERR_HTTP_CONNECT
  ///, surfaced as a generic OOPS scene with no clue *why*. Normalising
  /// here means the form ships valid URLs and the user sees a hint when
  /// the input was wrong. For IFTTT (`type == ifttt`) the field is the
  /// event slug, not a URL, skip the prefix logic in that case.
  static String _sanitizeUrl(String raw, ApiType type) {
    var s = raw.trim();
    if (type == ApiType.ifttt) return s;
    // Collapse any number of leading scheme prefixes, keep only the
    // last one. "https://http://x" → "http://x"; "http://https://x" →
    // "https://x"; "http://http://x" → "http://x". A normal valid input
    // is already idempotent.
    while (true) {
      final lower = s.toLowerCase();
      // Find the last occurrence of "://", anything before its scheme
      // prefix is a stray duplicate.
      final lastScheme = lower.lastIndexOf('://');
      if (lastScheme < 0) break;
      // Locate the scheme word that owns this "://".
      var schemeStart = lastScheme;
      while (schemeStart > 0 && _isSchemeChar(lower.codeUnitAt(schemeStart - 1))) {
        schemeStart--;
      }
      if (schemeStart == 0) break;  // already clean
      s = s.substring(schemeStart);
    }
    return s;
  }

  static bool _isSchemeChar(int c) {
    return (c >= 0x61 && c <= 0x7a) || // a-z
           (c >= 0x41 && c <= 0x5a) || // A-Z
           (c >= 0x30 && c <= 0x39) || // 0-9
           c == 0x2b || c == 0x2d || c == 0x2e; // + - .
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final delay = int.tryParse(_delay.text) ?? 0;
      final clamped = delay < 0 ? 0 : (delay > 300 ? 300 : delay);
      final cleanedUrl = _sanitizeUrl(_url.text, _type);
      // If sanitiser changed the value, write it back to the field so
      // the user sees what was actually saved.
      if (cleanedUrl != _url.text) _url.text = cleanedUrl;
      final draft = widget.endpoint
        ..name = _name.text.trim()
        ..type = _type
        ..url = cleanedUrl
        ..method = _method
        ..auth = _auth
        ..headerName =
            _headerName.text.trim().isEmpty ? null : _headerName.text.trim()
        ..contentType =
            _contentType.text.trim().isEmpty ? null : _contentType.text.trim()
        ..delayAfterSec = clamped;
      await widget.onSave(
        draft,
        _newToken.text.isEmpty ? null : _newToken.text,
      );
      if (mounted) _newToken.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final saved = widget.endpoint.slot >= 0;
    final masked = widget.endpoint.maskedToken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(label: l.bfApiChainFieldNameLabel, controller: _name),
        const SizedBox(height: 12),
        _LabelText(l.bfApiChainTypeLabel),
        const SizedBox(height: 6),
        _TypeSelector(
          selected: _type,
          onChanged: (v) => setState(() => _type = v),
        ),
        const SizedBox(height: 12),
        _Field(
          label: _type == ApiType.ifttt ? l.bfApiChainEventOrApplet : 'URL',
          controller: _url,
        ),
        const SizedBox(height: 12),
        _LabelText(l.bfApiChainMethodLabel),
        const SizedBox(height: 6),
        _MethodSelector(
          selected: _method,
          onChanged: (v) => setState(() => _method = v),
        ),
        const SizedBox(height: 12),
        // Advanced section: auth + headers + content-type + delay-after.
        // Hidden by default to keep the form approachable; opens for
        // power users. delay-after moved inside here in S2.3 (plan
        // decision #7) so new users see a shorter form; the cooldown
        // really only matters when 2+ slots fire in a chain and the
        // user must avoid rate-limit (429) from IFTTT / Discord.
        InkWell(
          onTap: () => setState(() => _showAdvanced = !_showAdvanced),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _showAdvanced ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _showAdvanced ? l.bfApiChainAdvancedHide : l.bfApiChainAdvancedShow,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (_showAdvanced) ...[
          // delay-after: cooldown between this slot and the next in the
          // chain. Only meaningful when the user has 2+ endpoints; for
          // a single-slot binding this stays 0 and is invisible.
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(child: Text(l.bfApiChainDelayLabel)),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _delay,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(l.bfApiChainDelayUnit,
                  style: TextStyle(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 14),
          _LabelText(l.bfApiChainAuthLabel),
          const SizedBox(height: 6),
          _AuthSelector(
            selected: _auth,
            onChanged: (v) => setState(() => _auth = v),
          ),
          if (_auth == AuthMode.header) ...[
            const SizedBox(height: 12),
            _Field(label: l.bfApiChainFieldHeaderName, controller: _headerName),
          ],
          if (_auth != AuthMode.none) ...[
            const SizedBox(height: 12),
            if (masked != null && masked.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  l.bfApiChainCurrentTokenHint(masked),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            _Field(
              label: l.bfApiChainNewTokenLabel,
              controller: _newToken,
              obscure: true,
            ),
          ],
          const SizedBox(height: 12),
          _Field(label: l.bfApiChainContentTypeLabel, controller: _contentType),
        ],
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: saved ? widget.onRemove : null,
              icon: const Icon(Icons.delete_outline),
              label: Text(l.bfApiChainDeleteCta),
              style: TextButton.styleFrom(foregroundColor: cs.error),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: saved ? widget.onTest : null,
              icon: const Icon(Icons.send, size: 18),
              label: Text(l.bfApiChainTestCta),
            ),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.bfApiChainSaveCta),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tiny presentation primitives
// ---------------------------------------------------------------------------

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.obscure = false,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _LabelText extends StatelessWidget {
  const _LabelText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 1,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final ApiType type;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMustard = type == ApiType.ifttt;
    final bg = isMustard
        ? const Color(0xFFD4A017).withValues(alpha: 0.15)
        : cs.surfaceContainerHigh;
    final fg = isMustard ? const Color(0xFFD4A017) : cs.onSurface;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        _typeBadgeText(type),
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});
  final ApiType selected;
  final ValueChanged<ApiType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final t in ApiType.values)
          ChoiceChip(
            label: Text(_typeLabel(t)),
            selected: selected == t,
            onSelected: (v) {
              if (v) onChanged(t);
            },
          ),
      ],
    );
  }
}

class _MethodSelector extends StatelessWidget {
  const _MethodSelector({required this.selected, required this.onChanged});
  final HttpMethod selected;
  final ValueChanged<HttpMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final m in HttpMethod.values)
          ChoiceChip(
            label: Text(_methodWire(m)),
            selected: selected == m,
            onSelected: (v) {
              if (v) onChanged(m);
            },
          ),
      ],
    );
  }
}

class _AuthSelector extends StatelessWidget {
  const _AuthSelector({required this.selected, required this.onChanged});
  final AuthMode selected;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: 6,
      children: [
        for (final a in AuthMode.values)
          ChoiceChip(
            label: Text(_authLabel(l, a)),
            selected: selected == a,
            onSelected: (v) {
              if (v) onChanged(a);
            },
          ),
      ],
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
