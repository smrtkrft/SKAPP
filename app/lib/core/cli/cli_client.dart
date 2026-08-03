// Command client on top of a CliTransport.
//
// - Tracks outgoing request id / response matching.
// - Exposes events separately.
// - Handles the auth handshake exchanged as {"evt":"auth.challenge"} / answers.
// - Applies per-message HMAC when a session token is loaded.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;

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
  final _unmatched = StreamController<Map<String, dynamic>>.broadcast();
  final _unparsed = StreamController<String>.broadcast();
  final _pending = <int, Completer<CliResponse>>{};
  int _nextId = 1;

  Stream<CliEvent> get events => _events.stream;

  /// Lines the device sent that are not NDJSON at all — ESP-IDF boot logs,
  /// `printf` debug output, panic backtraces. On a USB-Serial-JTAG port
  /// these share the wire with the protocol, and dropping them hides
  /// exactly the evidence a dev console exists to show (firmware crashes
  /// would surface only as a generic command timeout).
  Stream<String> get unparsed => _unparsed.stream;

  /// Bekleyen bir isteğe eşleşmeyen cevaplar. İki gerçek durum:
  ///   * Ham JSON modunda kullanıcının kendi `id`'siyle gönderdiği komut
  ///     (istek CliClient'tan geçmediği için `_pending`'de yok).
  ///   * Timeout'tan SONRA gelen geç cevap (id kaydı silinmiştir).
  /// Eskiden ikisi de sessizce düşüyordu; konsol bunu dinleyip gösterir.
  Stream<Map<String, dynamic>> get unmatched => _unmatched.stream;

  /// Completes when the underlying transport drops (socket onDone, BLE
  /// disconnect). Any pending requests are failed at the same moment so
  /// callers stop waiting on dead I/O. Watchers can use this to surface a
  /// "connection lost" signal to the user without polling.
  Future<void> get whenClosed => _closedCompleter.future;
  final _closedCompleter = Completer<void>();
  bool _closed = false;

  /// Kapanışa yol açan alt hata (socket reset, BLE drop). Temiz stop()'ta
  /// null. whenClosed tamamlandıktan sonra okunabilir — TransportSelector
  /// loglar, UI "bağlantı koptu"yu sebep bilgisiyle gösterebilir.
  Object? closedReason;

  StreamSubscription<String>? _sub;

  /// Cevabı beklenen istek sayısı (test/tanılama).
  @visibleForTesting
  int get pendingCount => _pending.length;

  Future<void> start() async {
    await transport.connect();
    _sub = transport.incoming.listen(
      _onLine,
      onDone: _onTransportClosed,
      onError: (Object e) => _onTransportClosed(e),
    );
  }

  /// Fired exactly once when the underlying transport closes, either
  /// because we tore it down via [stop] or because the device went away
  /// (socket FIN, BLE disconnect). Pending CLI requests get a real error
  /// instead of waiting out their per-request timeout, and [whenClosed]
  /// completes so listeners (Riverpod providers) can decide whether to
  /// auto-reconnect or surface "connection lost" to the user.
  void _onTransportClosed([Object? reason]) {
    if (_closed) return;
    _closed = true;
    closedReason ??= reason;
    for (final c in _pending.values) {
      if (!c.isCompleted) {
        c.completeError(TransportClosedException(closedReason));
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
    void Function(int id)? onRequestId,
  }) async {
    final id = _nextId++;
    // Çağıran isterse istek id'sini öğrenir: timeout'tan sonra gelen geç
    // cevap `unmatched`'e düşer ve tüketici onun KENDİ isteği mi yoksa
    // beklenmedik bir çerçeve mi olduğunu ayırt edebilsin.
    onRequestId?.call(id);
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
    try {
      await transport.sendLine(wireLine);
    } catch (_) {
      // Gönderim başarısızsa bu isteğin cevabı ASLA gelmez. Kaydı bırakmak
      // sızıntıdır: transport kapanınca _onTransportClosed dinleyicisiz
      // completer'a completeError yapar → zone'da yakalanmamış async hata.
      // (USB'de sendLine tasarım gereği fırlayabiliyor: >1023B komut,
      // kapalı port, WriteFile hatası.)
      _pending.remove(id);
      rethrow;
    }

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
    List<String>? argv,
    Duration timeout = const Duration(seconds: 10),
    required Future<bool> Function(CliConfirmRequest req) confirmRequest,
  }) async {
    final first = await send(cmd, args: args, argv: argv, timeout: timeout);
    if (first.ok) return first;
    if (first.err != 'ERR_CONFIRM_TOKEN_REQUIRED') return first;

    final params = first.params;
    final token = params?['confirm_token'] as String?;
    if (token == null || token.isEmpty) return first;

    // GÜVENLİK: dialog, GÖNDERECEĞİMİZ komutla etiketlenir — cihazın
    // yankıladığı `params.cmd` ile DEĞİL. Aksi halde sahte/kurcalanmış bir
    // cihaz, factory-reset isteğine `params.cmd:"device.status"` cevabı
    // vererek kullanıcıya zararsız görünen bir onay penceresi gösterir,
    // onay alınınca app yıkıcı komutu gönderir. Yankı yalnız tutarlılık
    // kontrolü için kullanılır.
    final echoed = params?['cmd'];
    if (echoed is String && echoed != cmd) {
      debugPrint('[cli] confirm echo mismatch: device said "$echoed", '
          'we are sending "$cmd"');
    }
    // Cihazdan gelen TTL'i makul aralığa sıkıştır (UI'da "onay süresi
    // 99999 sn" gibi güven telkin eden saçmalık görünmesin).
    final rawTtl = (params?['ttl_sec'] as num?)?.toInt() ?? 30;
    final confirmed = await confirmRequest(CliConfirmRequest(
      cmd: cmd,
      ttlSec: rawTtl.clamp(1, 300),
    ));
    if (!confirmed) return first;

    return send(cmd,
        args: args, argv: argv, confirmToken: token, timeout: timeout);
  }

  Future<void> stop() async {
    _onTransportClosed();
    await _sub?.cancel();
    await transport.close();
    if (!_events.isClosed) await _events.close();
    if (!_unmatched.isClosed) await _unmatched.close();
    if (!_unparsed.isClosed) await _unparsed.close();
  }

  void _onLine(String line) {
    Map<String, dynamic> msg;
    try {
      msg = jsonDecode(line) as Map<String, dynamic>;
    } catch (_) {
      // Not NDJSON: firmware boot log / printf / panic backtrace. Surface
      // it instead of dropping — see [unparsed].
      debugPrint('[cli] non-JSON line surfaced (${line.length}B)');
      if (!_unparsed.isClosed) _unparsed.add(line);
      return;
    }
    if (msg.containsKey('evt')) {
      _events.add(msg);
      return;
    }
    final idRaw = msg['id'];
    if (idRaw is int && _pending.containsKey(idRaw)) {
      final c = _pending.remove(idRaw)!;
      // Korumalı okuma: yabancı/kurcalanmış bir cihaz `"err":1` veya
      // `"params":[]` gönderirse çıplak cast, stream callback'i içinde
      // yakalanmamış TypeError üretiyordu (istek de timeout'a kalıyordu).
      final errRaw = msg['err'];
      final paramsRaw = msg['params'];
      c.complete(CliResponse(
        id: idRaw,
        ok: msg['ok'] == true,
        data: msg['data'],
        err: errRaw?.toString(),
        params: paramsRaw is Map ? paramsRaw.cast<String, dynamic>() : null,
      ));
    } else {
      debugPrint('[cli] response with unknown id $idRaw surfaced as unmatched');
      if (!_unmatched.isClosed) _unmatched.add(msg);
    }
  }
}
