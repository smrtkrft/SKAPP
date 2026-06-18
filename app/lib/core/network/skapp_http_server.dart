import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../features/skapi/data/active_runs_registry.dart';
import '../../features/skapi/data/param_merge.dart';
import '../../features/skapi/data/script_manifest.dart';
import '../../features/skapi/data/skapi_providers.dart';
import '../cli/bond_store.dart';
import '../settings/settings_providers.dart';
import '../storage/paired_devices_store.dart';
import '../system/network_identity_provider.dart';
import 'hmac_signer.dart';
import 'pairing_handshake_provider.dart';
import 'peer_tokens_provider.dart';
import 'remote_run_activity_provider.dart';
import 'self_signed_cert.dart';
import 'webhook_activity_provider.dart';
import 'webhook_receiver.dart';

/// Hard ceiling on any request body the listener will buffer. Every SKAPP
/// API payload (pairing handshake, param overrides, event envelope, BF
/// webhook) is a small JSON object, so 256 KiB is generous. The cap lives
/// at the read site because the auth-bypassed routes (`/api/pair/redeem`,
/// `/api/events/incoming`, `/api/health`) buffer the body before any
/// credential check runs.
const int _kMaxRequestBodyBytes = 256 * 1024;

/// Upper bound for a remote run's pre-execution delay. Without it a peer
/// could pin one of its `kMaxRunsPerPeer` slots indefinitely by requesting
/// a multi-year delay. One hour covers every legitimate "add delay" use.
const int _kMaxPrerunDelaySeconds = 3600;

/// Path-segment guard for `{platform}` / `{scriptId}`. Both are kebab-case
/// asset folder / file ids (e.g. `win`, `lx-debian`, `toast-notification`).
/// `rootBundle` can't escape the asset bundle, but a `.`-bearing id has no
/// legitimate use here, so we reject it as defense-in-depth.
final RegExp _kAssetIdPattern = RegExp(r'^[a-z0-9][a-z0-9-]*$');

/// Reads the request body as UTF-8, refusing anything over
/// [_kMaxRequestBodyBytes]. Returns null on overflow (caller maps to 413).
/// Guards both the declared Content-Length and the actual streamed size so
/// a missing or lying length header can't smuggle an oversized body past
/// the check.
Future<String?> _readBodyCapped(Request req) async {
  final declared = req.contentLength;
  if (declared != null && declared > _kMaxRequestBodyBytes) return null;
  final bytes = <int>[];
  await for (final chunk in req.read()) {
    bytes.addAll(chunk);
    if (bytes.length > _kMaxRequestBodyBytes) return null;
  }
  return utf8.decode(bytes);
}

Response _payloadTooLarge() => Response(
      413,
      body: jsonEncode(
          {'error': 'body_too_large', 'limit': _kMaxRequestBodyBytes}),
      headers: {'content-type': 'application/json'},
    );

/// SKAPP Desktop HTTP listener.
///
/// Mounts under `/api`:
///   GET  /api/health                       -> identity snapshot
///   POST /api/scripts/{platform}/{id}/run  -> NDJSON stream
///
/// The server only starts when:
///   * The current platform can spawn PowerShell (Windows / macOS / Linux).
///   * `start()` is called explicitly. Mobile / web call sites short-circuit
///     and the API is exposed only as a remote target on those platforms.
///
/// Bearer auth comes from `NetworkIdentity.bearerToken`. Token rotates
/// invalidate every previously paired phone, which is the intended UX:
/// the regenerate button is the "kick everyone out" action.
class SkappHttpServer {
  SkappHttpServer(this._ref);

  final Ref _ref;

  HttpServer? _server;
  bool get isRunning => _server != null;
  int? get boundPort => _server?.port;

  // Plain-HTTP listener dedicated to the BF (ESP32) webhook. BF can't
  // validate our self-signed TLS cert (its esp_http_client uses the public
  // CA bundle), so it cannot reach the HTTPS listener — its webhook POSTs
  // hit the TLS port as plain HTTP, the server drops them, and BF reports
  // ERR_API_CONNECT. The BF webhook is HMAC-authenticated (bond token) and
  // the payload ("timer.expired") is not secret, so plain HTTP is acceptable
  // here. Mobile peers keep using the HTTPS listener (id.port). Bound at
  // id.port + 1.
  HttpServer? _httpServer;
  int? get bfWebhookPort => _httpServer?.port;

  bool get supported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  Future<void> start() async {
    if (!supported || _server != null) return;
    final id = _ref.read(networkIdentityProvider);
    final router = _buildRouter(id.bearerToken);
    final pipeline = const Pipeline()
        .addMiddleware(_authMiddleware(id.bearerToken))
        .addHandler(router.call);

    // Bind address: when `lanVisible` is true (default), accept connections
    // from anywhere on the LAN so BF webhooks + paired mobile peers can
    // reach us. When false, restrict to loopback — useful for security-
    // sensitive environments where the user has only USB-paired devices.
    // Note: closing LAN visibility also blocks BF webhooks; the Settings
    // toggle warns the user, and `SkappListenerService.watchProMode`
    // auto-restores `true` when Developer mode is turned off so users can never
    // get stranded.
    final bindAddr =
        id.lanVisible ? InternetAddress.anyIPv4 : InternetAddress.loopbackIPv4;

    // Faz B step 4: TLS. Resolve or generate the self-signed cert
    // bound to this install's UUID, then bind the shelf pipeline via
    // `bindSecure` instead of plain `bind`. Mobile peers will pin the
    // fingerprint at pairing time so MITM with a different cert fails
    // at handshake. `currentTlsCertProvider` is published so the QR
    // sheet + mDNS announcer can read the fingerprint without
    // re-loading from disk.
    final cert = await loadOrIssueCert(uuid: id.uuid);
    _ref.read(currentTlsCertProvider.notifier).set(cert);
    final ctx = SecurityContext(withTrustedRoots: false)
      ..useCertificateChainBytes(utf8.encode(cert.certPem))
      ..usePrivateKeyBytes(utf8.encode(cert.privateKeyPem));
    _server = await shelf_io.serve(
      pipeline,
      bindAddr,
      id.port,
      shared: false,
      securityContext: ctx,
    );

    // Plain-HTTP twin for the BF webhook (see _httpServer doc). Same
    // pipeline (the auth middleware bypasses /api/events/incoming, which
    // self-auths via HMAC; bearer routes still require a token, and mobile
    // peers use the HTTPS port, so this plain port is effectively BF-only).
    // Only when LAN-visible; loopback-only mode has no BF webhooks anyway.
    if (id.lanVisible) {
      try {
        _httpServer = await shelf_io.serve(
          pipeline,
          bindAddr,
          id.port + 1,
          shared: false,
        );
        debugPrint('[SKAPP-RX] BF plain-HTTP webhook listener on :${id.port + 1}');
      } catch (e) {
        debugPrint('[SKAPP-RX] BF plain-HTTP listener bind failed (:${id.port + 1}): $e');
      }
    }
    _webhookReceiver ??= WebhookReceiver(
      bondStore: _ref.read(bondStoreProvider),
    );
    // Reset the HMAC nonce ring on every start so a listener restart
    // (which already invalidates open connections) also clears stale
    // dedup entries. Token lookup closes over `_ref` so it sees future
    // identity-provider updates without rebuilding the verifier.
    _hmacVerifier = HmacRequestVerifier(
      tokenLookup: (peerUuid) {
        // Faz B step 3: per-peer tokens issued by the redeem endpoint.
        // Each paired phone has its own secret; revoking one entry in
        // `peerTokensProvider` flips its requests to 401 without
        // touching the others. Fallback chain below keeps the install
        // bearer working for clients paired before per-peer tokens
        // existed — Faz B step 4 retires that fallback.
        final perPeer =
            _ref.read(peerTokensProvider.notifier).tokenFor(peerUuid);
        if (perPeer != null) return perPeer;
        final id = _ref.read(networkIdentityProvider);
        if (peerUuid == id.uuid) return id.bearerToken;
        return null;
      },
    );
  }

  // Webhook receiver is created lazily on first start() so unit tests can
  // construct the server without a Riverpod scope hosting BondStore. One
  // instance per server lifetime keeps the nonce dedup ring shared across
  // all incoming requests.
  WebhookReceiver? _webhookReceiver;

  // HMAC verifier owns the nonce LRU; one instance per server lifetime
  // keeps replay protection consistent across requests. Recreated on
  // each `start()` so a listener restart (token rotation, port change)
  // wipes the dedup ring — wanted behaviour, the old window is gone too.
  HmacRequestVerifier? _hmacVerifier;

  Future<void> stop() async {
    final h = _httpServer;
    _httpServer = null;
    if (h != null) {
      try { await h.close(force: true); } catch (_) {/* already gone */}
    }
    final s = _server;
    if (s == null) return;
    _server = null;
    try {
      await s.close(force: true);
    } catch (_) {
      // Close during shutdown/restart is best-effort; a failure here must
      // not crash the caller (restart, reset cascade, provider dispose).
    }
  }

  Future<void> restart() async {
    await stop();
    await start();
  }

  Router _buildRouter(String token) {
    final router = Router();

    // One-time pairing handshake redeem. Mobile POSTs the
    // `handshakeToken` it scanned from the v:2 pairing QR plus a peer
    // UUID it's claiming + a friendly `peerName`. Desktop checks the
    // handshake is unexpired and unused, mints a per-peer token, and
    // returns it. Auth-free on purpose — pairing is the bootstrap that
    // creates the auth credential. Developer mode gate is enforced by the
    // outer middleware bypass list below (path matches
    // `api/pair/redeem`).
    router.post('/api/pair/redeem', (Request req) async {
      final body = await _readBodyCapped(req);
      if (body == null) return _payloadTooLarge();
      Map<String, Object?> json;
      try {
        json = (jsonDecode(body) as Map).cast<String, Object?>();
      } catch (_) {
        return Response.badRequest(
          body: jsonEncode({'error': 'malformed_body'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final handshakeToken = json['handshakeToken'] as String?;
      final peerUuid = json['peerUuid'] as String?;
      final peerName = json['peerName'] as String?;
      if (handshakeToken == null || peerUuid == null || peerName == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'missing_field'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final handshake = _ref
          .read(pairingHandshakeProvider.notifier)
          .redeem(handshakeToken);
      if (handshake == null) {
        return Response(
          401,
          body: jsonEncode({'error': 'handshake_invalid'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final token = await _ref
          .read(peerTokensProvider.notifier)
          .issue(peerUuid: peerUuid, name: peerName);
      // Faz 3 redirect: bir mobil peer eşleştiğinde aynı zamanda
      // `PairedDevice(prefix: 'MS')` kaydı ekle. Bu kayıt sayesinde
      // mobile peer Cihazlarım sekmesinde görünür ve mevcut
      // `bindingsForDeviceProvider(deviceId)` akışı peer UUID ile
      // tetiklenebilir. Pairing → device-list senkronizasyonu
      // tek yönlü asimetri: telefon Cihazlarım'da MS olarak görünür,
      // laptop telefonda hâlâ "Eşli Desktop SKAPP'ler"de kalır
      // (desktop, telefon için bir "cihaz" değil yönetilen sistem).
      await _ref.read(pairedDevicesProvider.notifier).upsert(PairedDevice(
            id: peerUuid,
            name: peerName,
            prefix: 'MS',
            pairedAt: DateTime.now().toUtc(),
            lastSeen: DateTime.now().toUtc(),
          ));
      final desktopId = _ref.read(networkIdentityProvider);
      return Response.ok(
        jsonEncode({
          'peerToken': token,
          'desktopUuid': desktopId.uuid,
          'desktopName': desktopId.name,
        }),
        headers: {'content-type': 'application/json'},
      );
    });

    router.get('/api/health', (Request req) {
      final id = _ref.read(networkIdentityProvider);
      // `developerModeEnabled` lets paired mobile peers show a
      // "Geliştirici modu kapalı" rozet in the peer picker before the
      // user attempts a remote run, so they don't get a surprise 403
      // when the gating middleware refuses the call.
      return Response.ok(
        jsonEncode({
          'ok': true,
          'uuid': id.uuid,
          'name': id.name,
          'port': id.port,
          'platform': _platformTag(),
          'runnerAvailable': true,
          'developerModeEnabled': _ref.read(developerModeProvider),
        }),
        headers: {'content-type': 'application/json'},
      );
    });

    router.post('/api/scripts/<platform>/<scriptId>/run',
        (Request req, String platform, String scriptId) async {
      final peerUuid = req.context['peerUuid'] as String? ??
          _ref.read(networkIdentityProvider).uuid;
      // Peer name surfaces in the Settings activity card. Fall back to
      // a short UUID prefix when the peer isn't in the per-peer token
      // index (legacy bearer caller, or revoked-since-issued).
      final peerEntry = _ref
          .read(peerTokensProvider)
          .where((e) => e.peerUuid == peerUuid)
          .firstOrNull;
      final peerName = peerEntry?.name ??
          peerUuid.substring(0, peerUuid.length.clamp(0, 8));
      final activity = _ref.read(remoteRunActivityProvider.notifier);

      // Defense-in-depth: `{platform}`/`{scriptId}` are kebab-case asset
      // ids. `rootBundle` can't escape the bundle, but a `.`-bearing id has
      // no legitimate use, so reject it before doing any work.
      if (!_kAssetIdPattern.hasMatch(platform) ||
          !_kAssetIdPattern.hasMatch(scriptId)) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 400,
          reason: 'invalid_path',
        );
        return Response.badRequest(
          body: jsonEncode({'error': 'invalid_path'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final body = await _readBodyCapped(req);
      if (body == null) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 413,
          reason: 'body_too_large',
        );
        return _payloadTooLarge();
      }
      Map<String, Object?> overrides = const {};
      var prerunDelaySeconds = 0;
      if (body.isNotEmpty) {
        try {
          final parsed = jsonDecode(body);
          if (parsed is Map<String, Object?>) {
            overrides = (parsed['paramOverrides']
                    as Map?)?.cast<String, Object?>() ??
                const {};
            prerunDelaySeconds =
                (((parsed['prerunDelaySeconds'] as num?)?.toInt() ?? 0)
                        .clamp(0, _kMaxPrerunDelaySeconds))
                    .toInt();
          }
        } catch (_) {
          activity.recordRejected(
            peerUuid: peerUuid,
            peerName: peerName,
            platform: platform,
            scriptId: scriptId,
            statusCode: 400,
            reason: 'malformed_body',
          );
          return Response.badRequest(body: 'Invalid JSON body');
        }
      }

      final repo = _ref.read(scriptRepositoryProvider);
      final runner = _ref.read(scriptRunnerProvider);
      final registry = _ref.read(activeRunsRegistryProvider);

      late final ScriptManifest manifest;
      try {
        manifest = await repo.loadScript(platform, scriptId);
      } catch (e) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 404,
          reason: 'script_not_found',
        );
        return Response.notFound('Script $platform/$scriptId not found');
      }

      // Remote-execution whitelist. Manifest must explicitly opt in by
      // setting `remoteRunnable: true`. Power scripts (shutdown, kill-app
      // etc.) deliberately stay default-off; only safe scripts (toast,
      // dialog, volume-set, brightness, media-key, show-desktop, fade-
      // screen, grayscale, find-mouse-shake, mute-toggle) are surfaced
      // here. Local "Run now" in the desktop UI bypasses this check.
      if (!manifest.remoteRunnable) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 403,
          reason: 'not_remote_runnable',
        );
        return Response(
          403,
          body: jsonEncode({
            'error': 'not_remote_runnable',
            'scriptId': scriptId,
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Schema-validate the override map before it hits PowerShell. Type,
      // range, pattern, allowedValues, and control-char rules live in
      // `ParamValidator`. Wire-side guard: catches a malformed override
      // before the wrapper script sees it, returns 400 with a single
      // machine-readable failure code so callers can react cleanly.
      final validation = const ParamValidator().validate(
        manifestParams: manifest.params,
        overrides: overrides,
      );
      if (!validation.ok) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 400,
          reason: validation.code ?? 'validation_failed',
        );
        return Response.badRequest(
          body: jsonEncode({
            'error': validation.code,
            'param': validation.paramName,
            'message': validation.message,
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      // Per-peer concurrency cap. Three in-flight runs per peer is
      // enough for legitimate parallel use; the fourth comes back as
      // 429 + machine-readable `too_many_runs` so the mobile sheet can
      // render a "wait for one to finish" hint instead of a generic
      // HTTP error.
      if (!registry.canStart(peerUuid)) {
        activity.recordRejected(
          peerUuid: peerUuid,
          peerName: peerName,
          platform: platform,
          scriptId: scriptId,
          statusCode: 429,
          reason: 'too_many_runs',
        );
        return Response(
          429,
          body: jsonEncode({
            'error': 'too_many_runs',
            'limit': kMaxRunsPerPeer,
            'running': registry.countFor(peerUuid),
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final handle = await runner.run(
        manifest: manifest,
        paramOverrides: overrides,
        prerunDelaySeconds: prerunDelaySeconds,
      );
      // Mint a runId and register the active run so the cancel endpoint
      // and the activity card can target it. The runId is the first
      // NDJSON record so the mobile sheet learns it before any output
      // is produced.
      final runId = _generateRunId();
      registry.register(ActiveRun(
        runId: runId,
        peerUuid: peerUuid,
        platform: platform,
        scriptId: scriptId,
        handle: handle,
        startedAt: DateTime.now(),
      ));
      activity.recordAccepted(
        runId: runId,
        peerUuid: peerUuid,
        peerName: peerName,
        platform: platform,
        scriptId: scriptId,
        paramOverrideKeys: overrides.keys.toList(growable: false),
      );

      // NDJSON stream: header `{"start": true, "runId": ..., ...}` then
      // one JSON object per line for each output line, then a final
      // `{"end": true, "exitCode": N}` record. Header carries runId so
      // the client can DELETE /api/scripts/runs/<runId> to abort.
      final controller = StreamController<List<int>>();
      final headerJson = jsonEncode({
        'start': true,
        'runId': runId,
        'manifestId': manifest.id,
        'platform': platform,
      });
      controller.add(utf8.encode('$headerJson\n'));

      handle.output.listen(
        (line) {
          if (controller.isClosed) return;
          final json = jsonEncode({
            'kind': line.kind.name,
            'text': line.text,
            'ts': line.ts.toIso8601String(),
          });
          controller.add(utf8.encode('$json\n'));
        },
        onDone: () async {
          final result = await handle.result;
          activity.updateOnEnd(
            runId: runId,
            exitCode: result.exitCode,
            durationMs: result.durationMs,
            cancelled: result.cancelled,
            errorKey: result.errorMessageKey,
          );
          registry.cleanup(runId);
          if (controller.isClosed) return;
          final json = jsonEncode({
            'end': true,
            'exitCode': result.exitCode,
            'durationMs': result.durationMs,
            'errorMessageKey': result.errorMessageKey,
            'cancelled': result.cancelled,
          });
          controller.add(utf8.encode('$json\n'));
          await controller.close();
        },
      );
      return Response.ok(
        controller.stream,
        headers: {
          'content-type': 'application/x-ndjson',
          'cache-control': 'no-store',
        },
      );
    });

    // Mobile peer event push. The phone sends `{event, data}` here when
    // the user taps a trigger button (Faz 3 redirect: telefon =
    // sadece event kaynağı). Authentication is the same peer-token
    // HMAC the run endpoint uses (the auth middleware verifies it
    // before this handler runs) so we can trust `req.context['peerUuid']`
    // as the originating mobile peer. Developer mode gating is also
    // already applied — phones can only emit events when the desktop
    // owner has explicitly opted in.
    //
    // We reuse `BindingsTriggerService.dispatchWebhook(deviceId, event)`
    // with `peerUuid` as the device id: pair/redeem above wrote a
    // `PairedDevice(prefix: 'MS', id: peerUuid)` for this peer, so the
    // bindings lookup matches against the same id the user chose in the
    // bind screen. The activity log surface is shared with BF webhooks
    // (`webhookActivityProvider`) so the user sees both phone and BF
    // triggers in one place.
    router.post('/api/events/incoming/peer', (Request req) async {
      final peerUuid = req.context['peerUuid'] as String?;
      if (peerUuid == null) {
        return Response.unauthorized(
          jsonEncode({'error': 'missing_peer_context'}),
        );
      }
      final body = await _readBodyCapped(req);
      if (body == null) return _payloadTooLarge();
      Map<String, Object?> json;
      try {
        json = (jsonDecode(body) as Map).cast<String, Object?>();
      } catch (_) {
        return Response.badRequest(
          body: jsonEncode({'error': 'malformed_body'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final eventName = json['event'] as String?;
      if (eventName == null || eventName.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'error': 'missing_event'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final activity = _ref.read(webhookActivityProvider.notifier);
      final activityToken = activity.recordAccepted(
        deviceId: peerUuid,
        eventName: eventName,
      );
      final trigger = _ref.read(bindingsTriggerServiceProvider);
      // Mirror the BF dispatch surface so the user sees the same
      // "matched 0 / matched N · failed M" indicators for mobile-peer
      // events in the webhook activity card.
      unawaited(() async {
        try {
          final summary = await trigger.dispatchWebhook(peerUuid, eventName);
          DispatchOutcome outcome;
          String? note;
          if (summary.matchedBindings == 0) {
            outcome = DispatchOutcome.noMatch;
            note = 'No enabled binding matches $eventName for $peerUuid';
          } else if (summary.anyFailed) {
            outcome = DispatchOutcome.error;
            final fails = summary.scriptResults.where((r) => !r.success);
            note = fails
                .map((r) =>
                    '${r.scriptId}: ${r.errorMessage ?? "exit=${r.exitCode}"}')
                .join(' · ');
          } else {
            outcome = DispatchOutcome.matched;
          }
          activity.updateDispatch(
            token: activityToken,
            dispatch: outcome,
            matchedBindings: summary.matchedBindings,
            scriptResults: summary.scriptResults
                .map((r) => ScriptRunResult(
                      scriptId: r.scriptId,
                      platform: r.platform,
                      success: r.success,
                      exitCode: r.exitCode,
                      errorMessage: r.errorMessage,
                    ))
                .toList(growable: false),
            note: note,
          );
        } catch (e, st) {
          debugPrint('[peer-event] dispatch failed: $e\n$st');
          activity.updateDispatch(
            token: activityToken,
            dispatch: DispatchOutcome.error,
            note: 'dispatch threw: $e',
          );
        }
      }());
      return Response.ok(
        jsonEncode({'ok': true, 'event': eventName, 'queued': true}),
        headers: {'content-type': 'application/json'},
      );
    });

    // Cancel an in-flight remote run. Mobile sheet calls this when the
    // user taps "İptal" or dismisses the sheet while the run is still
    // streaming. The registry sends SIGTERM via the underlying
    // RunHandle; the run's own onDone callback (above) is responsible
    // for cleaning up the registry entry. We return 200 immediately
    // and let the activity record's `cancelled` flag flip when the
    // process actually exits.
    router.delete('/api/scripts/runs/<runId>',
        (Request req, String runId) async {
      final registry = _ref.read(activeRunsRegistryProvider);
      final cancelled = registry.cancel(runId);
      if (!cancelled) {
        return Response.notFound(
          jsonEncode({'error': 'unknown_run_id', 'runId': runId}),
        );
      }
      return Response.ok(
        jsonEncode({'ok': true, 'runId': runId, 'cancelling': true}),
        headers: {'content-type': 'application/json'},
      );
    });

    // BF SYSTEM-kind webhook entry point. Authenticated by bond-keyed
    // HMAC, NOT by the SKAPP install's bearer token (the auth middleware
    // is bypassed for this path because BF doesn't know our bearer; it
    // signs with the bond token negotiated during ECDH pairing).
    router.post('/api/events/incoming', (Request req) async {
      // FAZ0_DIAG: T1 anchor (webhook entry, body read sonrası).
      final tEntryUs = DateTime.now().microsecondsSinceEpoch;
      final body = await _readBodyCapped(req);
      if (body == null) return _payloadTooLarge();
      final receiver = _webhookReceiver;
      final activity =
          _ref.read(webhookActivityProvider.notifier);
      if (receiver == null) {
        activity.recordRejected(
          statusCode: 503,
          note: 'Webhook receiver not ready',
        );
        return Response(503, body: 'Webhook receiver not ready');
      }
      final headerDeviceId = req.headers['X-SK-Device-Id'] ??
          req.headers['x-sk-device-id'];
      final result = await receiver.verify(
        headers: req.headers,
        body: body,
      );
      // FAZ0_DIAG: T2 verify-done (HMAC + secure storage 3-way lookup).
      debugPrint('[FAZ0_DIAG] T1_entry_us=$tEntryUs '
          'verify_delta_us=${DateTime.now().microsecondsSinceEpoch - tEntryUs} '
          'ok=${result.ok} status=${result.statusCode}');
      if (!result.ok) {
        debugPrint('[SKAPP-RX] webhook reject ${result.statusCode}: '
            '${result.message}');
        activity.recordRejected(
          deviceId: result.deviceId ?? headerDeviceId,
          statusCode: result.statusCode,
          note: result.message,
        );
        return Response(result.statusCode,
            body: result.message ?? 'rejected');
      }
      final eventName = webhookEventName(result.body ?? const {});
      if (eventName == null) {
        activity.recordMalformed(
          deviceId: result.deviceId,
          note: 'Body missing "event" field',
        );
        return Response.badRequest(body: 'Body missing "event" field');
      }
      // Record accept FIRST, get the activity entry's timestamp as a
      // token, then dispatch async and back-fill dispatch outcome on
      // the entry. HTTP response goes back to BF immediately so the
      // chain doesn't stall on script duration. The dispatch result
      // updates the activity row a few hundred ms later so the user
      // sees "Kabul edildi · 0 binding match" or "1 script çalıştı"
      // instead of a silent post-accept void.
      final activityToken = activity.recordAccepted(
        deviceId: result.deviceId!,
        eventName: eventName,
      );
      final trigger = _ref.read(bindingsTriggerServiceProvider);
      // FAZ0_DIAG: T3 dispatch-start (binding lookup + script run).
      final tDispatchUs = DateTime.now().microsecondsSinceEpoch;
      debugPrint('[FAZ0_DIAG] T3_dispatch_start_us=$tDispatchUs '
          'event=$eventName device=${result.deviceId}');
      unawaited(() async {
        try {
          final summary = await trigger.dispatchWebhook(
            result.deviceId!,
            eventName,
          );
          debugPrint('[FAZ0_DIAG] T5_dispatch_done_us='
              '${DateTime.now().microsecondsSinceEpoch} '
              'delta_ms=${(DateTime.now().microsecondsSinceEpoch - tDispatchUs) ~/ 1000} '
              'matched=${summary.matchedBindings} failed=${summary.anyFailed}');
          DispatchOutcome outcome;
          String? note;
          if (summary.matchedBindings == 0) {
            outcome = DispatchOutcome.noMatch;
            note = 'No enabled binding matches '
                '$eventName for ${result.deviceId}';
          } else if (summary.anyFailed) {
            outcome = DispatchOutcome.error;
            final fails = summary.scriptResults.where((r) => !r.success);
            note = fails
                .map((r) =>
                    '${r.scriptId}: ${r.errorMessage ?? "exit=${r.exitCode}"}')
                .join(' · ');
          } else {
            outcome = DispatchOutcome.matched;
          }
          activity.updateDispatch(
            token: activityToken,
            dispatch: outcome,
            matchedBindings: summary.matchedBindings,
            scriptResults: summary.scriptResults
                .map((r) => ScriptRunResult(
                      scriptId: r.scriptId,
                      platform: r.platform,
                      success: r.success,
                      exitCode: r.exitCode,
                      errorMessage: r.errorMessage,
                    ))
                .toList(growable: false),
            note: note,
          );
        } catch (e, st) {
          debugPrint('[SKAPP-RX] dispatch failed: $e\n$st');
          activity.updateDispatch(
            token: activityToken,
            dispatch: DispatchOutcome.error,
            note: 'dispatch threw: $e',
          );
        }
      }());
      return Response.ok(
        jsonEncode({'ok': true, 'event': eventName, 'queued': true}),
        headers: {'content-type': 'application/json'},
      );
    });

    return router;
  }

  Middleware _authMiddleware(String expectedToken) {
    return (Handler inner) {
      return (Request req) async {
        // Public, bearer-free routes:
        //   /api/events/incoming — bond-signed webhook receiver, auths
        //     itself via X-SK-Signature; the route's verify() does the
        //     heavy lifting.
        //   /api/health — diagnostic ping (used by the in-app self-test
        //     button to confirm the listener bind + firewall path; was
        //     erroneously blocked by bearer auth which surfaced as a
        //     scary "Self-test failed" toast even on a healthy install).
        // Every other route requires either the install bearer or a
        // valid HMAC envelope (Faz B step 2).
        final p = req.url.path;
        // `api/pair/redeem` is the pairing bootstrap — there is no
        // credential yet, the handshake token in the body IS the auth.
        if (p == 'api/events/incoming' ||
            p == 'api/health' ||
            p == 'api/pair/redeem') {
          return inner(req);
        }
        final auth = req.headers['authorization'];
        if (auth == null || auth.isEmpty) {
          return Response.unauthorized('Missing authorization');
        }
        // HMAC path — preferred when peers support it. Replay/timestamp
        // checks live inside the verifier; bearer fallback below stays
        // for legacy clients that haven't been updated yet.
        //
        // On success the verifier returns the peer's UUID; we stash it
        // on the request context (`peerUuid`) so downstream route
        // handlers (run endpoint concurrency cap, activity audit) can
        // attribute the request without re-parsing the header. Bearer
        // fallback uses the install UUID as a synthetic peer id so the
        // same context contract holds across both auth schemes.
        String? attributedPeerUuid;
        if (auth.startsWith('SKAPP-HMAC ')) {
          final body = await _readBodyCapped(req);
          if (body == null) return _payloadTooLarge();
          final verifier = _hmacVerifier;
          if (verifier == null) {
            return Response(
              503,
              body: jsonEncode({'error': 'hmac_verifier_unavailable'}),
              headers: {'content-type': 'application/json'},
            );
          }
          final result = verifier.verify(
            authorizationHeader: auth,
            method: req.method,
            path: '/${req.url.path}',
            body: body,
          );
          if (!result.ok) {
            return Response(
              result.statusCode,
              body: jsonEncode({
                'error': result.code,
                'message': result.message,
              }),
              headers: {'content-type': 'application/json'},
            );
          }
          attributedPeerUuid = result.peerUuid;
          // The downstream handler needs to re-read the body; shelf
          // requests are single-use, so we rebuild with the already-
          // consumed bytes attached.
          req = req.change(body: body);
        } else if (auth.startsWith('Bearer ')) {
          final token = auth.substring('Bearer '.length).trim();
          if (token != expectedToken) {
            return Response.unauthorized('Invalid token');
          }
          // Legacy bearer caller is the install itself; attribute the
          // run to the install UUID so per-peer caps still apply.
          attributedPeerUuid = _ref.read(networkIdentityProvider).uuid;
        } else {
          return Response.unauthorized('Unsupported authorization scheme');
        }
        // Developer mode gate: even with valid auth, mobile-trigger routes are
        // off by default. Power user must opt in via Settings →
        // "Geliştirici modu" before paired SKAPP peers can run scripts on
        // this host. BF webhooks (`/api/events/incoming`) are bypassed
        // above and unaffected by this check.
        //
        // `shelf` ships no `Response.forbidden` factory, so we build the
        // 403 with the raw constructor.
        if (!_ref.read(developerModeProvider)) {
          return Response(
            403,
            body: jsonEncode({'error': 'pro_mode_disabled'}),
            headers: {'content-type': 'application/json'},
          );
        }
        // Carry the resolved peer UUID into the route handlers via the
        // shelf request context. Route handlers fetch it as
        // `req.context['peerUuid']` to scope concurrency caps + audit
        // records per peer.
        if (attributedPeerUuid != null) {
          req = req.change(context: {'peerUuid': attributedPeerUuid});
        }
        return inner(req);
      };
    };
  }

  String _platformTag() {
    if (kIsWeb) return 'web';
    if (Platform.isWindows) return 'win';
    if (Platform.isMacOS) return 'mac';
    if (Platform.isLinux) return 'lx';
    return 'other';
  }

  /// RFC 4122 v4 UUID for tagging an in-flight remote run. Inline so we
  /// don't depend on the `uuid` package — same pattern as
  /// `network_identity_provider`'s install UUID generator.
  static String _generateRunId() {
    final r = Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int i) => bytes[i].toRadixString(16).padLeft(2, '0');
    final h = List.generate(16, hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}

/// Long-lived listener provider. Mobile / web ref.read returns an
/// instance whose `start()` is a no-op so call sites stay uniform.
final skappHttpServerProvider = Provider<SkappHttpServer>((ref) {
  final server = SkappHttpServer(ref);
  ref.onDispose(server.stop);
  return server;
});

/// Reactive running flag. The Settings card watches this to decide
/// whether to show "Running on port N" or "Stopped". Driven by the
/// service lifecycle wrapper that calls `start()` / `stop()`.
class SkappHttpServerRunningNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final skappHttpServerRunningProvider =
    NotifierProvider<SkappHttpServerRunningNotifier, bool>(
        SkappHttpServerRunningNotifier.new);

/// Live handle to the self-signed TLS cert the listener is currently
/// serving. `start()` populates this once it has loaded or issued the
/// cert; `stop()` leaves the previous value in place so consumers
/// (mDNS announcer TXT record, pairing QR sheet) can still pin the
/// fingerprint while the listener is restarting. Faz B step 4
/// "rotate cert" action explicitly overwrites it through
/// `regenerateCert(...)` + `set(...)`.
class CurrentTlsCertNotifier extends Notifier<SelfSignedCert?> {
  @override
  SelfSignedCert? build() => null;

  void set(SelfSignedCert? cert) => state = cert;
}

final currentTlsCertProvider =
    NotifierProvider<CurrentTlsCertNotifier, SelfSignedCert?>(
        CurrentTlsCertNotifier.new);
