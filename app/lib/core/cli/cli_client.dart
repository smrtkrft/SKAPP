// Command client on top of a CliTransport.
//
// - Tracks outgoing request id / response matching.
// - Exposes events separately.
// - Handles the auth handshake exchanged as {"evt":"auth.challenge"} / answers.
// - Applies per-message HMAC when a session token is loaded.

import 'dart:async';
import 'dart:convert';

import 'cli_transport.dart';
import 'cli_signer.dart';

typedef CliEvent = Map<String, dynamic>;

/// Metadata the firmware ships with `ERR_CONFIRM_TOKEN_REQUIRED`. The
/// auto-issue path drops a single-use token + its TTL into the error
/// envelope's `params`; [CliClient.sendCritical] forwards them here so
/// the UI can render an honest "are you sure?" dialog (with the actual
/// command name and time budget, not a hardcoded copy).
class CliConfirmRequest {
  const CliConfirmRequest({required this.cmd, required this.ttlSec});

  /// Canonical command name as the dispatcher echoed it back, e.g.
  /// `device.factory-reset`. Useful for diagnostic dialog copy.
  final String cmd;

  /// Seconds remaining before the token expires. Dialog can hide or
  /// auto-close when this elapses if it wants to be precise.
  final int ttlSec;
}

class CliResponse {
  CliResponse({
    required this.id,
    required this.ok,
    this.data,
    this.err,
    this.params,
  });

  final int id;
  final bool ok;
  final dynamic data;
  final String? err;
  final Map<String, dynamic>? params;
}

class CliClient {
  CliClient(this.transport, {this.signer});

  final CliTransport transport;
  final CliSigner? signer;

  final _events = StreamController<CliEvent>.broadcast();
  final _pending = <int, Completer<CliResponse>>{};
  int _nextId = 1;

  Stream<CliEvent> get events => _events.stream;

  /// Completes when the underlying transport drops (socket onDone, BLE
  /// disconnect). Any pending requests are failed at the same moment so
  /// callers stop waiting on dead I/O. Watchers can use this to surface a
  /// "connection lost" signal to the user without polling.
  Future<void> get whenClosed => _closedCompleter.future;
  final _closedCompleter = Completer<void>();
  bool _closed = false;

  StreamSubscription<String>? _sub;

  Future<void> start() async {
    await transport.connect();
    _sub = transport.incoming.listen(
      _onLine,
      onDone: _onTransportClosed,
      onError: (Object _) => _onTransportClosed(),
    );
  }

  /// Fired exactly once when the underlying transport closes, either
  /// because we tore it down via [stop] or because the device went away
  /// (socket FIN, BLE disconnect). Pending CLI requests get a real error
  /// instead of waiting out their per-request timeout, and [whenClosed]
  /// completes so listeners (Riverpod providers) can decide whether to
  /// auto-reconnect or surface "connection lost" to the user.
  void _onTransportClosed() {
    if (_closed) return;
    _closed = true;
    for (final c in _pending.values) {
      if (!c.isCompleted) {
        c.completeError(StateError('CLI transport closed'));
      }
    }
    _pending.clear();
    if (!_closedCompleter.isCompleted) _closedCompleter.complete();
  }

  Future<CliResponse> send(
    String cmd, {
    Map<String, dynamic>? args,
    List<String>? argv,
    String? confirmToken,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final id = _nextId++;
    final body = <String, dynamic>{
      'cmd': cmd,
      'id': id,
      'args': ?args,
      'argv': ?argv,
      'confirm_token': ?confirmToken,
    };

    final completer = Completer<CliResponse>();
    _pending[id] = completer;

    // Bonded transports (BLE/TCP after ECDH) require the per-message HMAC
    // envelope expected by sk_secure_session_dispatch_signed. Pre-bond
    // paths (USB, ECDH bootstrap) send the raw body directly.
    final wireLine =
        signer != null ? signer!.envelope(body) : jsonEncode(body);
    await transport.sendLine(wireLine);

    return completer.future.timeout(timeout, onTimeout: () {
      _pending.remove(id);
      throw TimeoutException('CLI command timeout: $cmd');
    });
  }

  /// Two-step confirm flow for `.critical = true` BF commands.
  ///
  /// On the firmware side the dispatcher auto-mints a single-use token when
  /// a critical command lands without one (sk_cli.c §auto-issue) and packs
  /// it into the error envelope's `params.confirm_token`. This helper
  /// drives the SKAPP-side equivalent of the CLI's "type the command,
  /// paste the retry hint":
  ///
  ///   1. send [cmd] without a token
  ///   2. on `ERR_CONFIRM_TOKEN_REQUIRED` with a token in params,
  ///      ask the caller's [confirmRequest] callback (typically a
  ///      Flutter dialog)
  ///   3. if the user approves, retry [cmd] with that exact token
  ///
  /// Any other response (success on the first try, a different error,
  /// or user cancellation) is returned as-is, callers always check
  /// `response.ok` to drive UI.
  Future<CliResponse> sendCritical(
    String cmd, {
    Map<String, dynamic>? args,
    Duration timeout = const Duration(seconds: 10),
    required Future<bool> Function(CliConfirmRequest req) confirmRequest,
  }) async {
    final first = await send(cmd, args: args, timeout: timeout);
    if (first.ok) return first;
    if (first.err != 'ERR_CONFIRM_TOKEN_REQUIRED') return first;

    final params = first.params;
    final token = params?['confirm_token'] as String?;
    if (token == null || token.isEmpty) return first;

    final confirmed = await confirmRequest(CliConfirmRequest(
      cmd: (params?['cmd'] as String?) ?? cmd,
      ttlSec: (params?['ttl_sec'] as num?)?.toInt() ?? 30,
    ));
    if (!confirmed) return first;

    return send(cmd, args: args, confirmToken: token, timeout: timeout);
  }

  Future<void> stop() async {
    _onTransportClosed();
    await _sub?.cancel();
    await transport.close();
    if (!_events.isClosed) await _events.close();
  }

  void _onLine(String line) {
    Map<String, dynamic> msg;
    try {
      msg = jsonDecode(line) as Map<String, dynamic>;
    } catch (_) {
      return; // ignore malformed lines
    }
    if (msg.containsKey('evt')) {
      _events.add(msg);
      return;
    }
    final idRaw = msg['id'];
    if (idRaw is int && _pending.containsKey(idRaw)) {
      final c = _pending.remove(idRaw)!;
      c.complete(CliResponse(
        id: idRaw,
        ok: msg['ok'] == true,
        data: msg['data'],
        err: msg['err'] as String?,
        params: (msg['params'] as Map?)?.cast<String, dynamic>(),
      ));
    }
  }
}
