import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:crypto/crypto.dart' as crypto_pkg;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;

import '../../features/skapi/data/run_handle.dart';
import '../system/network_identity_provider.dart';
import 'hmac_signer.dart';
import 'skapp_peer_target.dart';

/// HTTP client for talking to a paired Desktop SKAPP. Used by Mobile to
/// trigger remote runs and forward device events; Desktop also uses it
/// to forward to a remote peer.
///
/// `runRemote` returns a `Stream<RunOutputLine>` that mirrors the local
/// `ScriptRunner` output stream, so the run sheet can render uniformly
/// regardless of whether the script ran locally or via HTTP.
class SkappHttpClient {
  SkappHttpClient({required this.ref});

  /// Riverpod handle used to resolve this install's own UUID for the
  /// HMAC `peerUuid` field. The desktop side stores tokens keyed on
  /// this UUID via `peer_tokens_provider`, so signing has to match.
  final Ref ref;

  /// Per-peer cache of pinned `IOClient`s. Each entry wraps an
  /// `io.HttpClient` whose `badCertificateCallback` compares the
  /// presented cert's SHA-256 against `peer.certFingerprint`. We can't
  /// share a single client across peers because the pin is peer-
  /// specific. Faz B step 4 wires this up; rotating a peer's
  /// fingerprint via re-pairing invalidates the cached client through
  /// `invalidatePeer(uuid)`.
  final Map<String, http.Client> _peerClients = {};

  http.Client _clientFor(SkappPeerTarget peer) {
    final cached = _peerClients[peer.uuid];
    if (cached != null) return cached;
    final pinned = _buildPinnedClient(peer.certFingerprint);
    _peerClients[peer.uuid] = pinned;
    return pinned;
  }

  /// Drop a peer's cached pinned client (e.g. after revoke or re-pair
  /// with a new fingerprint). The next request rebuilds against the
  /// fresh peer record.
  void invalidatePeer(String peerUuid) {
    final c = _peerClients.remove(peerUuid);
    c?.close();
  }

  /// Build an `IOClient` that pins TLS by comparing the presented
  /// cert's SHA-256 against [expectedFingerprintHex]. When null
  /// (legacy v:1 peers paired before Faz B step 4) we accept any cert
  /// — same behaviour the old plain-HTTP client had, only over TLS so
  /// payload at least isn't plaintext. Settings nudges the user to
  /// re-pair so the fingerprint gets recorded.
  http.Client _buildPinnedClient(String? expectedFingerprintHex) {
    final inner = io.HttpClient();
    inner.badCertificateCallback = (cert, host, port) {
      if (expectedFingerprintHex == null) {
        debugPrint('[tls-pin] peer has no pinned fingerprint; accepting '
            'cert from $host:$port for backward compatibility');
        return true;
      }
      final actual =
          crypto_pkg.sha256.convert(cert.der).toString().toLowerCase();
      final ok = actual == expectedFingerprintHex.toLowerCase();
      if (!ok) {
        debugPrint('[tls-pin] cert mismatch for $host:$port '
            'expected=$expectedFingerprintHex actual=$actual');
      }
      return ok;
    };
    return io_client.IOClient(inner);
  }

  /// Resolves the base URL for a peer. mDNS keeps `lastIp` fresh; if it
  /// is null (peer offline / never seen) the call fails fast so the UI
  /// can surface a sensible "peer offline" error instead of a hanging
  /// connection.
  Uri _baseUri(SkappPeerTarget peer, String path) {
    final ip = peer.lastIp;
    if (ip == null || ip.isEmpty) {
      throw const SkappPeerOfflineException();
    }
    // Faz B step 4: every paired peer is reached over TLS. The cert
    // is self-signed by the desktop and pinned via the per-peer
    // `IOClient` — Dart won't validate the chain, fingerprint match
    // is the only trust anchor.
    return Uri.parse('https://$ip:${peer.port}$path');
  }

  /// Builds the request headers for a peer-targeted call. Faz B step 2
  /// signs every request with HMAC-SHA256 anchored on the peer's stored
  /// token; the server still accepts the older `Bearer` form for legacy
  /// clients but we always emit the modern envelope from this side so
  /// timestamps + replay protection kick in immediately.
  Map<String, String> _signedHeaders(
    SkappPeerTarget peer, {
    required String method,
    required String path,
    required String body,
  }) {
    // HMAC `peerUuid` is THIS install's identity — the server stores
    // tokens keyed on the requesting peer, not on the desktop being
    // talked to. `peer.uuid` (the desktop's UUID) only used to pick
    // which target to call.
    final selfUuid = ref.read(networkIdentityProvider).uuid;
    final authz = buildAuthorizationHeader(
      peerUuid: selfUuid,
      token: peer.bearerToken,
      method: method,
      path: path,
      body: body,
    );
    return {
      'authorization': authz,
      'content-type': 'application/json',
    };
  }

  Future<SkappPeerHealth> health(SkappPeerTarget peer) async {
    final uri = _baseUri(peer, '/api/health');
    // `/api/health` is a public bypass on the server so we don't even
    // need to sign it, but using the same signed path keeps the client
    // side homogenous and lets the server log peer-id on every probe
    // once Faz B step 3 surfaces audit metrics. Stick to empty body for
    // GET.
    final headers = _signedHeaders(
      peer,
      method: 'GET',
      path: '/api/health',
      body: '',
    );
    final resp = await _clientFor(peer).get(uri, headers: headers).timeout(
          const Duration(seconds: 4),
        );
    if (resp.statusCode == 401) {
      throw const SkappPeerUnauthorizedException();
    }
    if (resp.statusCode != 200) {
      throw SkappPeerHttpException(resp.statusCode, resp.body);
    }
    return SkappPeerHealth.fromJson(
        (jsonDecode(resp.body) as Map).cast<String, Object?>());
  }

  /// Runs `scriptId` on `peer` with the given parameter overrides.
  ///
  /// The remote endpoint streams NDJSON. The first record is a header
  /// `{ "start": true, "runId": ..., "manifestId": ..., "platform": ... }`
  /// that lets the client target the cancel endpoint. Subsequent
  /// records are one-per-output-line, and the stream ends with
  /// `{ "end": true, "exitCode": ... }`. We decode the stream lazily
  /// into `RunOutputLine`s; consumers `await` the `result` future for
  /// the closing record and `runId` for the cancel handle.
  Future<RemoteRunHandle> runRemote({
    required SkappPeerTarget peer,
    required String platform,
    required String scriptId,
    Map<String, Object?> paramOverrides = const {},
    int prerunDelaySeconds = 0,
  }) async {
    final path = '/api/scripts/$platform/$scriptId/run';
    final uri = _baseUri(peer, path);
    final body = jsonEncode({
      'paramOverrides': paramOverrides,
      'prerunDelaySeconds': prerunDelaySeconds,
    });
    final req = http.Request('POST', uri)
      ..headers.addAll(_signedHeaders(
        peer,
        method: 'POST',
        path: path,
        body: body,
      ))
      ..body = body;
    final response = await _clientFor(peer).send(req);
    if (response.statusCode == 401) {
      throw const SkappPeerUnauthorizedException();
    }
    if (response.statusCode == 404) {
      throw SkappPeerHttpException(404, 'Script not found');
    }
    if (response.statusCode == 429) {
      final body = await response.stream.bytesToString();
      throw SkappPeerTooManyRunsException.fromBody(body);
    }
    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw SkappPeerHttpException(response.statusCode, body);
    }

    final outputController = StreamController<RunOutputLine>();
    final resultCompleter = Completer<RemoteRunResult>();
    final runIdCompleter = Completer<String>();
    response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
      (line) {
        if (line.isEmpty) return;
        Map<String, Object?> json;
        try {
          json = (jsonDecode(line) as Map).cast<String, Object?>();
        } catch (_) {
          return;
        }
        if (json['start'] == true && json['runId'] is String) {
          if (!runIdCompleter.isCompleted) {
            runIdCompleter.complete(json['runId'] as String);
          }
          return;
        }
        if (json['end'] == true) {
          if (!resultCompleter.isCompleted) {
            resultCompleter.complete(RemoteRunResult(
              exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
              durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
              cancelled: (json['cancelled'] as bool?) ?? false,
              errorMessageKey: json['errorMessageKey'] as String?,
            ));
          }
          return;
        }
        final kindName = (json['kind'] as String?) ?? 'stdout';
        final kind = RunOutputKind.values.firstWhere(
          (k) => k.name == kindName,
          orElse: () => RunOutputKind.stdout,
        );
        outputController.add(RunOutputLine(
          kind: kind,
          text: (json['text'] as String?) ?? '',
          ts: DateTime.tryParse((json['ts'] as String?) ?? '') ??
              DateTime.now(),
        ));
      },
      onError: (Object e) {
        if (!resultCompleter.isCompleted) {
          resultCompleter.completeError(e);
        }
        if (!runIdCompleter.isCompleted) {
          runIdCompleter.completeError(e);
        }
      },
      onDone: () async {
        await outputController.close();
        if (!resultCompleter.isCompleted) {
          resultCompleter.complete(RemoteRunResult(
            exitCode: -1,
            durationMs: 0,
            cancelled: false,
            errorMessageKey: 'skapiRunErrorSpawn',
          ));
        }
        if (!runIdCompleter.isCompleted) {
          // Stream closed before we ever saw a start record. Surface as
          // an error so the cancel button stays disabled.
          runIdCompleter.completeError(
            const SkappPeerHttpException(500, 'No start record received'),
          );
        }
      },
    );

    return RemoteRunHandle(
      output: outputController.stream,
      result: resultCompleter.future,
      runIdFuture: runIdCompleter.future,
      onCancel: () async {
        // Wait for the start record so we have a runId to target.
        // Cap the wait at 3 s — past that the run never produced a
        // header and the server has nothing to cancel anyway.
        String runId;
        try {
          runId = await runIdCompleter.future.timeout(
            const Duration(seconds: 3),
          );
        } catch (_) {
          return;
        }
        await cancelRemote(peer: peer, runId: runId);
      },
    );
  }

  /// Mobile-side trigger emitter. Posts an event from this phone to a
  /// paired desktop peer; the desktop runs it through the bindings
  /// trigger service (same surface BF webhooks land on), so any
  /// binding whose `deviceId` matches this peer's UUID + whose
  /// `eventFilter` matches [eventName] fires its script.
  ///
  /// Throws [SkappPeerOfflineException] if the peer has no known IP,
  /// [SkappPeerUnauthorizedException] on 401 (re-pair needed), or
  /// [SkappPeerHttpException] for other non-2xx responses (e.g. 403
  /// `pro_mode_disabled` when the desktop owner has dev mode off).
  Future<void> emitEvent({
    required SkappPeerTarget peer,
    required String eventName,
    Map<String, Object?> data = const {},
  }) async {
    const path = '/api/events/incoming/peer';
    final uri = _baseUri(peer, path);
    final body = jsonEncode({
      'event': eventName,
      'data': data,
    });
    final headers = _signedHeaders(
      peer,
      method: 'POST',
      path: path,
      body: body,
    );
    final resp = await _clientFor(peer)
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 5));
    if (resp.statusCode == 401) {
      throw const SkappPeerUnauthorizedException();
    }
    if (resp.statusCode == 200) return;
    throw SkappPeerHttpException(resp.statusCode, resp.body);
  }

  /// Tell the desktop peer to terminate run [runId]. Fire-and-forget
  /// semantics: if the run already finished, the server returns 404
  /// and we swallow it (idempotent cancel). 200 means SIGTERM was
  /// dispatched; the actual cancellation surfaces in the run's final
  /// `end` record (`cancelled: true`).
  Future<void> cancelRemote({
    required SkappPeerTarget peer,
    required String runId,
  }) async {
    final path = '/api/scripts/runs/$runId';
    final uri = _baseUri(peer, path);
    final headers = _signedHeaders(
      peer,
      method: 'DELETE',
      path: path,
      body: '',
    );
    try {
      final resp = await _clientFor(peer)
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 4));
      if (resp.statusCode == 200 || resp.statusCode == 404) return;
      debugPrint('[cancelRemote] unexpected status ${resp.statusCode}: '
          '${resp.body}');
    } catch (e) {
      // Best-effort cancel: connection drop is fine, the user already
      // closed the sheet. Log so the developer can diagnose if needed.
      debugPrint('[cancelRemote] failed: $e');
    }
  }

  void close() {
    for (final c in _peerClients.values) {
      c.close();
    }
    _peerClients.clear();
  }
}

class SkappPeerHealth {
  const SkappPeerHealth({
    required this.uuid,
    required this.name,
    required this.port,
    required this.platform,
    required this.runnerAvailable,
    this.developerModeEnabled,
  });

  final String uuid;
  final String name;
  final int port;
  final String platform;
  final bool runnerAvailable;

  /// `true` when the peer has the Developer-mode toggle on. The peer
  /// picker disables rows when this is `false` (run requests would
  /// otherwise come back as 403 + `pro_mode_disabled`). `null` means
  /// the peer's server is older than this field — treat as "unknown,
  /// allow attempt" to keep backward compat.
  final bool? developerModeEnabled;

  factory SkappPeerHealth.fromJson(Map<String, Object?> j) => SkappPeerHealth(
        uuid: j['uuid'] as String,
        name: j['name'] as String,
        port: (j['port'] as num).toInt(),
        platform: (j['platform'] as String?) ?? 'other',
        runnerAvailable: (j['runnerAvailable'] as bool?) ?? false,
        developerModeEnabled: j['developerModeEnabled'] as bool?,
      );
}

class RemoteRunHandle {
  RemoteRunHandle({
    required this.output,
    required this.result,
    required Future<String> runIdFuture,
    required Future<void> Function() onCancel,
  })  : _runIdFuture = runIdFuture,
        _onCancel = onCancel;

  final Stream<RunOutputLine> output;
  final Future<RemoteRunResult> result;

  /// Resolves to the server-issued run id once the NDJSON `start`
  /// header arrives. Not synchronous because the header is the first
  /// line of the stream, not part of the POST response. Listeners
  /// should `await` it before exposing a Cancel button.
  final Future<String> _runIdFuture;
  Future<String> get runId => _runIdFuture;

  final Future<void> Function() _onCancel;
  bool _cancelRequested = false;

  /// Ask the server to terminate this run. Idempotent. The output
  /// stream continues to drain whatever is already buffered after the
  /// kill signal; the final `result` record carries `cancelled: true`.
  Future<void> cancel() async {
    if (_cancelRequested) return;
    _cancelRequested = true;
    await _onCancel();
  }
}

class RemoteRunResult {
  const RemoteRunResult({
    required this.exitCode,
    required this.durationMs,
    required this.cancelled,
    this.errorMessageKey,
  });

  final int exitCode;
  final int durationMs;
  final bool cancelled;
  final String? errorMessageKey;

  bool get success => exitCode == 0 && errorMessageKey == null && !cancelled;
}

class SkappPeerOfflineException implements Exception {
  const SkappPeerOfflineException();
  @override
  String toString() => 'SkappPeerOfflineException: peer has no known IP';
}

class SkappPeerUnauthorizedException implements Exception {
  const SkappPeerUnauthorizedException();
  @override
  String toString() =>
      'SkappPeerUnauthorizedException: bearer token rejected (401)';
}

class SkappPeerHttpException implements Exception {
  const SkappPeerHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'SkappPeerHttpException($statusCode): $body';
}

/// Server returned 429 because the peer already has `kMaxRunsPerPeer`
/// runs in flight. UI surfaces a "wait for one to finish" hint, not a
/// generic HTTP error, so the user understands the cause.
class SkappPeerTooManyRunsException implements Exception {
  const SkappPeerTooManyRunsException({
    required this.limit,
    required this.running,
  });

  /// Max concurrent runs the server allows per peer.
  final int limit;

  /// Number of runs the server says are currently in flight for this
  /// peer. Same as [limit] in practice, but the body carries it so the
  /// UI can render a fresh count without round-tripping again.
  final int running;

  factory SkappPeerTooManyRunsException.fromBody(String body) {
    try {
      final j = (jsonDecode(body) as Map).cast<String, Object?>();
      return SkappPeerTooManyRunsException(
        limit: (j['limit'] as num?)?.toInt() ?? 0,
        running: (j['running'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return const SkappPeerTooManyRunsException(limit: 0, running: 0);
    }
  }

  @override
  String toString() =>
      'SkappPeerTooManyRunsException(running=$running/$limit)';
}

/// Outcome of `redeemPairing`. `peerToken` is the freshly minted secret
/// the mobile peer must keep — every subsequent request will sign with
/// it via `buildAuthorizationHeader`. The desktop UUID + name are
/// reflected back so the mobile can confirm it's talking to the same
/// host it scanned (and pin them into the local peer record).
class PairingRedeemResult {
  const PairingRedeemResult({
    required this.peerToken,
    required this.desktopUuid,
    required this.desktopName,
  });

  final String peerToken;
  final String desktopUuid;
  final String desktopName;
}

/// One-shot pairing redeem. Mobile calls this after scanning the v:2 QR
/// to convert the handshake token into a per-peer secret. Bypass the
/// signed-request helpers because the credential we'd sign with doesn't
/// exist yet.
///
/// Pairing-time TLS trust: the QR payload carries the desktop's cert
/// fingerprint, so the redeem call itself can already pin against it.
/// If `expectedFingerprintHex` is null the desktop is running a pre-
/// Faz-B4 build and we fall back to "accept any cert" (legacy path,
/// no TLS protection but the connection still works).
Future<PairingRedeemResult> redeemPairing({
  required String host,
  required int port,
  required String handshakeToken,
  required String peerUuid,
  required String peerName,
  String? expectedFingerprintHex,
}) async {
  final inner = io.HttpClient();
  inner.badCertificateCallback = (cert, h, p) {
    if (expectedFingerprintHex == null) return true;
    final actual =
        crypto_pkg.sha256.convert(cert.der).toString().toLowerCase();
    return actual == expectedFingerprintHex.toLowerCase();
  };
  final c = io_client.IOClient(inner);
  try {
    final uri = Uri.parse('https://$host:$port/api/pair/redeem');
    final resp = await c
        .post(
          uri,
          headers: const {'content-type': 'application/json'},
          body: jsonEncode({
            'handshakeToken': handshakeToken,
            'peerUuid': peerUuid,
            'peerName': peerName,
          }),
        )
        .timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) {
      throw SkappPeerHttpException(resp.statusCode, resp.body);
    }
    final json = (jsonDecode(resp.body) as Map).cast<String, Object?>();
    return PairingRedeemResult(
      peerToken: json['peerToken'] as String,
      desktopUuid: json['desktopUuid'] as String,
      desktopName: (json['desktopName'] as String?) ?? '',
    );
  } finally {
    c.close();
  }
}

final skappHttpClientProvider = Provider<SkappHttpClient>((ref) {
  final client = SkappHttpClient(ref: ref);
  ref.onDispose(client.close);
  return client;
});
