// Ortak ECDH + parola eşleştirme durum makinesi. Eskiden pairing_screen
// (BLE) ve wifi_pairing_screen (TCP) aynı protokolü ~400 satır kopyayla
// bağımsız yürütüyordu; artık tek makine bir PairingLink üstünde çalışır.
//
// Sözleşme (pairing_session_test.dart bire bir sabitler):
//   * Hiçbir hata sessiz kalmaz: her başarısızlık PairingException olarak
//     aşama + kod + cause ile fırlar.
//   * `evt` alanlı TÜM satırlar (bonded auth.challenge selamı,
//     pairing.required ipucu) trace'lenip atlanır — cevap döngüsü yalnızca
//     ok'lu zarf bekler. İki taşıyıcının eski farklı davranışı tekleşti.
//   * Malformed satırlar sayılır ve trace edilir; timeout mesajına eklenir.
//   * Yazma hatası, cevap benignWriteGrace içinde geldiyse affedilir
//     (firmware reply-then-close davranışı, bkz. PairingTimeouts).

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

import '../cli/ecdh_pairing.dart';
import 'pairing_error.dart';
import 'pairing_link.dart';
import 'pairing_timeouts.dart';

typedef PairingTrace = void Function(String message);

/// Parola kapısı: kalan deneme sayısıyla kullanıcıdan parola ister;
/// null dönerse akış [PairingErrorCode.cancelled] ile sonlanır.
typedef PassphrasePrompt = Future<String?> Function(int attemptsLeft);

class PairingSessionResult {
  const PairingSessionResult({
    required this.token,
    required this.devicePublic,
    this.slot,
  });

  /// 32-byte oturum token'ı — SHA256("sk_auth_token_v1" ‖ X25519 secret).
  final Uint8List token;

  /// Cihazın public key'i (tanılama/audit için).
  final Uint8List devicePublic;

  /// Cihazın bond'u yazdığı slot (0..7), eski firmware'de null.
  final int? slot;
}

class PairingSession {
  PairingSession({
    required this.link,
    required this.ourPeerId,
    required this.label,
    this.onTrace,
    EcdhPairing? ecdh,
  }) : _ecdh = ecdh ?? EcdhPairing();

  final PairingLink link;
  final Uint8List ourPeerId;
  final String label;
  final PairingTrace? onTrace;
  final EcdhPairing _ecdh;

  int _malformed = 0;
  Completer<Map<String, dynamic>>? _armed;
  StreamSubscription<String>? _sub;
  bool _linkDown = false;
  Object? _linkDownCause;

  void _trace(String s) => onTrace?.call(s);

  Future<PairingSessionResult> run(
      {required PassphrasePrompt promptPassphrase}) async {
    try {
      return await _run(promptPassphrase);
    } finally {
      await _sub?.cancel();
      _sub = null;
    }
  }

  Future<PairingSessionResult> _run(PassphrasePrompt promptPassphrase) async {
    // ── Keygen ────────────────────────────────────────────────────────
    final EphemeralPairing ephemeral;
    try {
      ephemeral = await _ecdh.begin();
    } catch (e, st) {
      throw PairingException(PairingStage.keygen, PairingErrorCode.storage,
          cause: e, stackTrace: st);
    }

    // ── Reply pompası ─────────────────────────────────────────────────
    _sub = link.lines.listen(_onLine, onError: (Object e, StackTrace st) {
      _linkDown = true;
      _linkDownCause = e;
      final c = _armed;
      if (c != null && !c.isCompleted) c.completeError(e, st);
    }, onDone: () {
      _linkDown = true;
      final c = _armed;
      if (c != null && !c.isCompleted) {
        c.completeError(_linkDownCause ?? StateError('pairing link closed'));
      }
    });

    // ── Exchange ──────────────────────────────────────────────────────
    _trace('tx pairing.ecdh.exchange '
        '(peer_id=${hex.encode(ourPeerId).substring(0, 8)}…)');
    await _sendExpectingReply({
      'cmd': 'pairing.ecdh.exchange',
      'args': {
        'peer_pub': hex.encode(ephemeral.ourPublic),
        'peer_id': hex.encode(ourPeerId),
        'label': label,
      },
    }, PairingStage.exchange);

    final reply =
        await _awaitReply(PairingStage.awaitReply, PairingTimeouts.replyDeadline);

    if (reply['ok'] != true) {
      final err = reply['err']?.toString();
      throw PairingException(
          PairingStage.awaitReply, PairingErrorCode.fromWire(err),
          deviceErr: err ?? 'ERR_UNKNOWN',
          params: (reply['params'] as Map?)?.cast<String, dynamic>());
    }

    // ── our_pub doğrulama + token türetimi ────────────────────────────
    final data = reply['data'] as Map?;
    final ourPub = data?['our_pub']?.toString();
    if (ourPub == null || ourPub.length != 64) {
      throw PairingException(
          PairingStage.awaitReply, PairingErrorCode.invalidReply,
          detail: 'our_pub=${ourPub == null ? "missing" : "${ourPub.length}ch"}');
    }
    final Uint8List devicePub;
    try {
      devicePub = Uint8List.fromList(hex.decode(ourPub));
    } catch (e, st) {
      throw PairingException(
          PairingStage.awaitReply, PairingErrorCode.invalidReply,
          cause: e, stackTrace: st);
    }

    final EcdhBondResult bond;
    try {
      bond = await ephemeral.complete(devicePub);
    } catch (e, st) {
      throw PairingException(PairingStage.keygen, PairingErrorCode.storage,
          cause: e, stackTrace: st);
    }
    _trace('bond derived (${bond.token.length}B token)');

    int? slot = ((data?['slot']) as num?)?.toInt();

    // ── Parola kapısı ─────────────────────────────────────────────────
    if (data?['need_passphrase'] == true) {
      var attemptsLeft = ((data?['attempts_left']) as num?)?.toInt() ?? 10;
      var unlocked = false;
      while (!unlocked) {
        final plain = await promptPassphrase(attemptsLeft);
        if (plain == null) {
          throw PairingException(
              PairingStage.passphrase, PairingErrorCode.cancelled);
        }
        await _sendExpectingReply({
          'cmd': 'pairing.passphrase.verify',
          'args': {'plain': plain},
        }, PairingStage.passphrase);
        final vr = await _awaitReply(
            PairingStage.passphrase, PairingTimeouts.passphraseReply);

        if (vr['ok'] == true) {
          unlocked = true;
          slot = ((vr['data'] as Map?)?['slot'] as num?)?.toInt() ?? slot;
        } else {
          final err = vr['err']?.toString();
          final code = PairingErrorCode.fromWire(err);
          final params = (vr['params'] as Map?)?.cast<String, dynamic>();
          if (code == PairingErrorCode.passphraseIncorrect) {
            attemptsLeft = (params?['attempts_left'] as num?)?.toInt() ??
                (attemptsLeft > 0 ? attemptsLeft - 1 : 0);
            if (attemptsLeft <= 0) {
              throw PairingException(
                  PairingStage.passphrase, PairingErrorCode.passphraseLockout,
                  deviceErr: err, params: params);
            }
            _trace('passphrase incorrect, $attemptsLeft attempts left');
          } else if (code == PairingErrorCode.noPendingBond) {
            throw PairingException(
                PairingStage.passphrase, PairingErrorCode.noPendingBond,
                deviceErr: err, params: params);
          } else {
            throw PairingException(
                PairingStage.passphrase, PairingErrorCode.rejected,
                deviceErr: err ?? 'ERR_UNKNOWN', params: params);
          }
        }
      }
    }

    return PairingSessionResult(
        token: bond.token, devicePublic: bond.peerPublic, slot: slot);
  }

  void _onLine(String line) {
    Map<String, dynamic> msg;
    try {
      msg = jsonDecode(line) as Map<String, dynamic>;
    } catch (_) {
      _malformed++;
      _trace('rx malformed line dropped (${line.length}B, total $_malformed)');
      return;
    }
    if (msg.containsKey('evt')) {
      // Bonded cihaz her bağlantıyı auth.challenge ile selamlar; pairing
      // modundaki cihaz subscribe anında pairing.required ipucu yayınlar.
      // İkisi de eşleştirme cevabı DEĞİLDİR — atla ve beklemeye devam et
      // (28d947e'nin TCP fix'i artık iki taşıyıcı için de geçerli).
      _trace('rx evt ${msg['evt']} (skipped during pairing)');
      return;
    }
    final c = _armed;
    if (c != null && !c.isCompleted) c.complete(msg);
  }

  /// Cevap completer'ını yazmadan ÖNCE kurar (cevap yazma ACK'inden önce
  /// gelebilir), sonra yazar. Yazma hatasında benignWriteGrace kadar cevabı
  /// bekler: geldiyse hata zararsızdır (reply-then-close), gelmediyse
  /// gerçek teslim hatasıdır.
  Future<void> _sendExpectingReply(
      Map<String, dynamic> obj, PairingStage stage) async {
    if (_linkDown) {
      throw PairingException(stage, PairingErrorCode.linkClosed,
          cause: _linkDownCause);
    }
    final c = Completer<Map<String, dynamic>>();
    _armed = c;
    try {
      await link.sendJson(obj);
    } catch (e) {
      final arrived = await Future.any<bool>([
        c.future.then((_) => true, onError: (_) => false),
        Future<bool>.delayed(PairingTimeouts.benignWriteGrace, () => false),
      ]);
      if (!arrived) {
        throw PairingException(stage, PairingErrorCode.linkClosed, cause: e);
      }
      _trace('write threw after reply arrived, ignoring: $e');
    }
  }

  Future<Map<String, dynamic>> _awaitReply(
      PairingStage stage, Duration budget) async {
    final c = _armed;
    if (c == null) {
      throw StateError('_awaitReply without an armed completer');
    }
    try {
      return await c.future.timeout(budget);
    } on TimeoutException {
      throw PairingException(stage, PairingErrorCode.timeout,
          detail: 'malformed=$_malformed, budget=${budget.inSeconds}s');
    } on PairingException {
      rethrow;
    } catch (e, st) {
      throw PairingException(stage, PairingErrorCode.linkClosed,
          cause: e, stackTrace: st);
    }
  }
}
