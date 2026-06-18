import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/ble_service.dart';
import '../../core/ble/device_model.dart';
import '../../core/ble/device_type_visual.dart';
import '../../core/cli/ble_transport.dart'
    show bleTraceStream, PairingRequiredException;
import '../../core/cli/bond_store.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/cli/ecdh_pairing.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../device_setup/wifi_scan_screen.dart';
import '../device_setup/wifi_success_screen.dart';
import 'pairing_helpers.dart';

/// Two paths through this screen, picked at entry from BondStore:
///
///   * **Bond yok** → ECDH bootstrap:
///       1) BLE connect + GATT discover
///       2) Generate X25519 ephemeral keypair
///       3) Send pairing.ecdh.exchange { peer_pub: hex(our_pub) }
///       4) Receive { ok:true, data:{ our_pub:hex } }
///       5) Derive token = SHA256("sk_auth_token_v1" || shared_secret)
///       6) Persist token in BondStore
///       7) Device closes the link; route to WiFi setup
///
///   * **Bond var** → HMAC reconnect (sk_secure_session mutual C-R):
///       1) Open a real CliClient through deviceSessionProvider, which
///          drives BleCliTransport's auth.challenge / auth.response /
///          {ok:true,data:{answer:...}} handshake under the hood.
///       2) Once authenticated, route straight to the WiFi setup screen
///          (the CliClient stays alive in the provider scope, so the
///          downstream screens just call session.client.send(...)).
///
/// Failure surfaces a retryable error card without leaving the screen.
enum _PairStage { connecting, exchanging, verifying, done, failed }

/// Cihazın bond'u açıkça reddettiğini gösteren marker. Transient hatalardan
/// (timeout, BLE drop) ayrıştırmak için _runReconnect catch'inde kullanılır.
class _BondRejectedError implements Exception {
  _BondRejectedError(this.code);
  final String code;
  @override
  String toString() => 'bond reddedildi: $code';
}

const _svcUuid = 'f100d001-7a5b-4c1e-8d2f-4a6b9c3e1d01';
const _cmdRxUuid = 'f100d002-7a5b-4c1e-8d2f-4a6b9c3e1d01';
const _eventTxUuid = 'f100d003-7a5b-4c1e-8d2f-4a6b9c3e1d01';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key, required this.device});
  final DiscoveredDevice device;

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  _PairStage _stage = _PairStage.connecting;
  String? _errorMsg;
  BluetoothDevice? _btDevice;
  StreamSubscription<List<int>>? _notifySub;
  // null until BondStore lookup resolves: keeps the UI on a generic
  // "checking…" state instead of briefly flashing the bootstrap labels
  // before flipping to reconnect (or vice versa).
  bool? _isReconnect;

  // Reentrancy guard: _decideAndRun PostFrameCallback ile başlıyor ve
  // _retry/_manualRecovery tarafından da tekrar tetikleniyor. Aynı anda
  // iki paralel akış kalkarsa BLE oturumları ve notify subscribe'ları
  // çakışıyor, auth.challenge dinleyicisi yarışta kayboluyor.
  bool _decideRunning = false;

  // In-memory debug trail, kullanıcı failed olduğunda son adımları
  // ekranda görür, kopyalayıp paylaşabilir. logcat alamayan kullanıcılar
  // için tek pratik debug yöntemi.
  final List<String> _trail = [];

  void _trace(String s) {
    debugPrint('[PAIR] $s');
    final ts = DateTime.now();
    final h = ts.hour.toString().padLeft(2, '0');
    final m = ts.minute.toString().padLeft(2, '0');
    final sec = ts.second.toString().padLeft(2, '0');
    final ms = ts.millisecond.toString().padLeft(3, '0');
    if (mounted) {
      setState(() {
        _trail.add('$h:$m:$sec.$ms  $s');
        if (_trail.length > 40) _trail.removeAt(0);
      });
    } else {
      _trail.add('$h:$m:$sec.$ms  $s');
    }
  }

  StreamSubscription<({String message, DateTime ts})>? _bleTraceSub;

  @override
  void initState() {
    super.initState();
    // BleCliTransport her adımı bleTraceStream'e push ediyor (connect,
    // discover, subscribe, rx N bytes, auth.challenge received, parse, …).
    // Burada abone olup eşleşme günlüğüne yansıtıyoruz; 8sn timeout
    // sessizliği yerine kullanıcı hangi adımda kırıldığını görüyor.
    _bleTraceSub = bleTraceStream.listen((ev) {
      if (!mounted) return;
      _trace('[ble] ${ev.message}');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideAndRun());
  }

  @override
  void dispose() {
    _bleTraceSub?.cancel();
    _notifySub?.cancel();
    _btDevice?.disconnect().catchError((_) {});
    super.dispose();
  }

  Future<void> _decideAndRun() async {
    // Reentrancy guard: PostFrameCallback + _retry/_manualRecovery aynı
    // anda tetiklerse iki paralel handshake akışı oluşur, BLE notify
    // dinleyicileri çakışır ve auth.challenge sessizce kaybolur.
    if (_decideRunning) {
      debugPrint('[PAIR] _decideAndRun: reentrancy blocked');
      return;
    }
    _decideRunning = true;
    try {
      // BondStore lookup decides the path. Note: hasBond is async (secure
      // storage I/O), so the screen briefly shows the "Bağlanılıyor"
      // step before either branch starts.
      final bonded = await ref.read(bondStoreProvider).hasBond(widget.device.id);
      if (!mounted) return;
      setState(() => _isReconnect = bonded);
      if (bonded) {
        await _runReconnect();
      } else {
        await _runFlow();
      }
    } finally {
      _decideRunning = false;
    }
  }

  /// HMAC reconnect path. Uses the shared deviceSessionProvider so the
  /// resulting CliClient stays alive past this screen, WifiScanScreen
  /// reads the same provider to send `wifi.scan` etc.
  ///
  /// Recovery semantiği iki dallı:
  ///   * Cihaz açıkça bond'u reddederse (BLE handshake'te
  ///     "auth answer verification failed" / device.info ok:false vb.)
  ///     bond gerçekten çürümüş demektir, kullanıcıya cihazın pairing
  ///     butonuna basmasını söyleyip ECDH bootstrap'a düşeriz.
  ///   * Timeout / BLE link drop / GATT bulunamadı gibi transient
  ///     hatalarda bond'u SİLMEYİZ; sadece "Tekrar dene" göstereniyoruz.
  ///     Aksi halde geçici bir BF reboot'u veya ağ titremesi kullanıcıyı
  ///     baştan eşleşmeye zorluyor.
  Future<void> _runReconnect() async {
    final svc = ref.read(bleServiceProvider);
    await svc.stopScan();

    try {
      _trace('reconnect: stopping any stale link');
      _set(_PairStage.connecting);
      try {
        await svc.deviceFor(widget.device.id).disconnect();
      } catch (_) {/* ignore */}

      _trace('reconnect: opening session via provider');
      _set(_PairStage.exchanging);
      // 30s wrapper: deviceSessionProvider zinciri (TCP cache → mDNS 1.5s
      // → mDNS-TCP 8s → BLE connect 12s + discover 8s + subscribe 5s +
      // auth 8s) en kötü ihtimalle ~30s sürer. Eski 12s değer BF'nin
      // bir önceki eşleşmenin link'ini kapatıp advertise'ı geri açtığı
      // pencerede yanlış pozitif veriyordu — sonra bond clear edip
      // ECDH bootstrap'a düşüyordu ve oradaki yazma da "pairing modu
      // kapalı" yüzünden PlatformException'la fail ediyordu.
      final session = await ref
          .read(deviceSessionProvider(widget.device.id).future)
          .timeout(const Duration(seconds: 30));
      _set(_PairStage.verifying);

      _trace('reconnect: sending device.info ping');
      final ping = await session.client
          .send('device.info', timeout: const Duration(seconds: 8));
      if (!ping.ok) {
        throw _BondRejectedError(ping.err ?? 'device.info');
      }

      await ref
          .read(pairedDevicesProvider.notifier)
          .touch(widget.device.id);

      _trace('reconnect: success');
      _set(_PairStage.done);
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      await _routeAfterPairing();
    } catch (e) {
      // Açık reddi tanı: cihaz veya BLE handshake bond'u geçersiz
      // saydı. Bunlar gerçek "bond çürümesi" sinyalidir, recovery şart.
      //
      // PairingRequiredException: cihaz pairing modunda olduğunu hint
      // event'i ile bildirdi (bond yok, kendisi de NORMAL mode'da değil).
      // Reconnect'i 8 sn beklemeden hard rejection sayıp pairing-mode
      // dialog'unu otomatik açıyoruz.
      final eMsg = e.toString().toLowerCase();
      final isHardRejection = e is _BondRejectedError ||
          e is PairingRequiredException ||
          eMsg.contains('auth answer verification') ||
          eMsg.contains('auth rejected') ||
          eMsg.contains('reddedildi') ||
          eMsg.contains('err_');

      if (!isHardRejection) {
        _trace('reconnect transient ($e) — keeping bond, prompting retry');
        if (!mounted) return;
        _fail(AppLocalizations.of(context)
            .pairingReconnectTransient(e.toString()));
        return;
      }

      _trace('reconnect rejected ($e) — asking user for pairing-mode confirm');
      if (!mounted) return;
      final proceed = await _confirmPairingMode();
      if (!mounted) return;
      if (proceed != true) {
        _fail(AppLocalizations.of(context).pairingRecoveryCancelled);
        return;
      }

      try {
        await ref.read(bondStoreProvider).clear(widget.device.id);
      } catch (_) {/* sil silinmediyse zaten gerekenden az şey kayıp */}
      // Provider scope'unu yenile ki taze BleCliTransport oluşturulabilsin.
      ref.invalidate(deviceSessionProvider(widget.device.id));
      if (!mounted) return;
      setState(() => _isReconnect = false);
      await _runFlow();
    }
  }

  /// Bootstrap'a düşmeden önce kullanıcıya: cihazdaki pairing butonuna
  /// basıp 60sn'lik pencereyi açmasını söyle. Aksi halde sonraki
  /// `pairing.ecdh.exchange` yazısını BF sessizce reddediyor (bond
  /// var + pairing modu kapalı → `sk_secure_session_feed_line` →
  /// AUTH_INVALID → `ble_gap_terminate` → PlatformException).
  Future<bool?> _confirmPairingMode() async {
    if (!mounted) return false;
    final l = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.pairingRecoveryTitle),
        content: Text(l.pairingRecoveryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.pairingRecoveryContinue),
          ),
        ],
      ),
    );
  }

  Future<void> _runFlow() async {
    final svc = ref.read(bleServiceProvider);
    final dev = svc.deviceFor(widget.device.id);
    _btDevice = dev;

    await svc.stopScan();

    // Defensive disconnect: önceki başarısız reconnect, recovery transition
    // veya başka bir oturumdan kalmış half-open link, dev.connect()'i no-op'a
    // dönüştürür. Bu durumda discoverServices/setNotifyValue cached state
    // üzerinde çalışır ve BF cihazı yeniden subscribe event'i göndermez —
    // pairing.ecdh.exchange writes sessizce başarısız olur. Önce temiz
    // kopuş, sonra taze GAP connect.
    try {
      await dev.disconnect().timeout(const Duration(seconds: 3));
    } catch (_) {/* zaten kopuk */}

    // ── 1. Connect ────────────────────────────────────────────────────
    try {
      _set(_PairStage.connecting);
      _trace('bootstrap: connecting…');
      await dev
          .connect(timeout: const Duration(seconds: 10), license: License.free)
          .timeout(const Duration(seconds: 12));
      try {
        await dev.requestMtu(247).timeout(const Duration(seconds: 5));
      } catch (_) {/* fall back to negotiated MTU */}
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingBleConnectFailed(e.toString()));
      return;
    }

    // ── 2/3. Discover GATT + send peer_pub ────────────────────────────
    BluetoothCharacteristic cmdRx;
    BluetoothCharacteristic eventTx;
    final lEarly = mounted ? AppLocalizations.of(context) : null;
    try {
      _set(_PairStage.exchanging);
      _trace('bootstrap: discovering services…');
      final services = await dev
          .discoverServices()
          .timeout(const Duration(seconds: 8));
      final svc = services.firstWhere(
        (s) => s.uuid.str.toLowerCase() == _svcUuid,
        orElse: () => throw StateError(
            lEarly?.pairingGattServiceMissing ?? 'SKAPP service not found'),
      );
      cmdRx = svc.characteristics.firstWhere(
        (c) => c.uuid.str.toLowerCase() == _cmdRxUuid,
        orElse: () => throw StateError(
            lEarly?.pairingGattCmdRxMissing ?? 'cmd_rx characteristic missing'),
      );
      eventTx = svc.characteristics.firstWhere(
        (c) => c.uuid.str.toLowerCase() == _eventTxUuid,
        orElse: () => throw StateError(
            lEarly?.pairingGattEventTxMissing ?? 'event_tx characteristic missing'),
      );
      await eventTx.setNotifyValue(true).timeout(const Duration(seconds: 5));
      _trace('bootstrap: GATT ready, notify subscribed');
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingGattDiscoveryFailed(e.toString()));
      return;
    }

    // Reply pump: lines arriving on event_tx are dispatched to whichever
    // completer is "armed" right now. The bootstrap flow now talks to the
    // device twice over the same characteristic (pairing.ecdh.exchange,
    // then optionally pairing.passphrase.verify), so we re-arm between
    // turns instead of locking in a single completer.
    Completer<Map<String, dynamic>>? armed;
    final lineBuf = StringBuffer();
    _notifySub = eventTx.onValueReceived.listen((bytes) {
      _trace('rx ${bytes.length}B');
      lineBuf.write(utf8.decode(bytes, allowMalformed: true));
      while (true) {
        final s = lineBuf.toString();
        final nl = s.indexOf('\n');
        if (nl < 0) break;
        final line = s.substring(0, nl);
        lineBuf
          ..clear()
          ..write(s.substring(nl + 1));
        if (line.isEmpty) continue;
        _trace('rx line: ${line.length > 80 ? "${line.substring(0, 80)}…" : line}');
        try {
          final msg = jsonDecode(line) as Map<String, dynamic>;
          // Cihaz pairing modunda subscribe'ı görür görmez "pairing.required"
          // hint'i yayınlıyor — bu sinyal reconnect path'i için anlamlı.
          // Bootstrap'ta zaten pairing yapıyoruz, bu yüzden hint'i sessizce
          // gözardı et; sıradaki gerçek cevap (our_pub) `armed`'ı tamamlar.
          if (msg['evt'] == 'pairing.required') {
            _trace('rx: pairing.required hint (ignored in bootstrap)');
            continue;
          }
          final c = armed;
          if (c != null && !c.isCompleted) c.complete(msg);
        } catch (e) {
          _trace('rx parse fail: $e');
        }
      }
    });

    Future<void> writeLine(Map<String, dynamic> obj) async {
      final cmd = jsonEncode(obj);
      final cmdBytes = utf8.encode('$cmd\n');
      const chunk = 180;
      for (var i = 0; i < cmdBytes.length; i += chunk) {
        final end = (i + chunk > cmdBytes.length) ? cmdBytes.length : i + chunk;
        await cmdRx
            .write(cmdBytes.sublist(i, end), withoutResponse: false)
            .timeout(const Duration(seconds: 5));
      }
    }

    // Generate our keypair + send the multi-bond exchange (peer_id + label).
    final ephemeral = await EcdhPairing().begin();
    final ourPubHex = hex.encode(ephemeral.ourPublic);
    final store = ref.read(bondStoreProvider);
    final ourPeerId = await store.appPeerId();
    final peerIdHex = hex.encode(ourPeerId);
    // The bond_store `label` slot identifies THIS SKAPP instance for the
    // device's logs and ERR_BOND_STORE_FULL peer list, not the device
    // we're talking to. Pull our own name from NetworkIdentity so paired
    // devices show "ali-telefon-skapp" rather than the device's own id.
    final label =
        shortPairingLabel(ref.read(networkIdentityProvider).name);

    armed = Completer<Map<String, dynamic>>();
    try {
      _trace('bootstrap: writing pairing.ecdh.exchange (peer_id=${peerIdHex.substring(0, 8)}…)');
      await writeLine({
        'cmd': 'pairing.ecdh.exchange',
        'args': {
          'peer_pub': ourPubHex,
          'peer_id': peerIdHex,
          'label':   label,
        },
      });
      _trace('bootstrap: write complete, awaiting reply…');
    } catch (e) {
      // BLE quirk: firmware closes the bootstrap link the moment it
      // sends back `our_pub` (per ecdh_pairing.dart contract). The
      // notify reaches SKAPP before the BLE stack delivers the
      // write-with-response ACK, so flutter_blue_plus throws
      // PlatformException(Unknown error) on a write that did, in fact,
      // get through. If the reply already arrived, treat the write
      // exception as benign and proceed; otherwise it's a genuine
      // delivery failure.
      if (armed.isCompleted) {
        _trace('write threw after reply arrived, ignoring: $e');
      } else {
        if (!mounted) return;
        _fail(AppLocalizations.of(context).pairingKeySendFailed(e.toString()));
        return;
      }
    }

    // ── 4/5/6. Wait for our_pub, derive token, persist bond ───────────
    _set(_PairStage.verifying);
    Map<String, dynamic> reply;
    try {
      reply = await armed.future.timeout(const Duration(seconds: 8));
    } catch (_) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingDeviceNoReply(8));
      return;
    }

    // Slot-full short-circuit: device returned the peer list, let the
    // user know what's in the way; they remove a peer from the device's
    // settings (via another paired SKAPP / USB) and retry.
    if (reply['ok'] != true) {
      final errCode = reply['err']?.toString() ?? 'ERR_UNKNOWN';
      if (errCode == 'ERR_BOND_STORE_FULL') {
        final params = reply['params'] as Map<String, dynamic>?;
        final peers  = (params?['peers'] as List?) ?? const [];
        if (mounted) _fail(bondStoreFullMessage(context, peers));
        return;
      }
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingDeviceRejected(errCode));
      return;
    }

    final data = reply['data'] as Map<String, dynamic>?;
    final ourPub = data?['our_pub'] as String?;
    if (ourPub == null || ourPub.length != 64) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingInvalidReplyMissingPub);
      return;
    }

    Uint8List devicePub;
    try {
      devicePub = Uint8List.fromList(hex.decode(ourPub));
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingHexDecodeFailed(e.toString()));
      return;
    }

    final bond = await ephemeral.complete(devicePub);
    int? assignedSlot = (data?['slot'] as num?)?.toInt();

    // Passphrase gate: device derived our session key but has not yet
    // committed it, we must prove the user passphrase first. Loop until
    // success or the user cancels (pairing window closes server-side
    // after 60s anyway, and 10 wrong attempts factory-resets the device).
    if (data?['need_passphrase'] == true) {
      int attemptsLeft =
          (data?['attempts_left'] as num?)?.toInt() ?? 10;
      bool unlocked = false;
      while (!unlocked) {
        final plain = !mounted
            ? null
            : await promptPairingPassphrase(context, attemptsLeft: attemptsLeft);
        final l = !mounted ? null : AppLocalizations.of(context);
        if (plain == null) {
          _fail(l?.pairingPassphraseCancelled ?? 'pairing cancelled');
          return;
        }
        armed = Completer<Map<String, dynamic>>();
        try {
          await writeLine({
            'cmd':  'pairing.passphrase.verify',
            'args': {'plain': plain},
          });
        } catch (e) {
          // Same write-after-reply quirk as the ECDH write above.
          if (armed.isCompleted) {
            _trace('passphrase write threw after reply arrived: $e');
          } else {
            _fail(l?.pairingPassphraseSendError(e.toString()) ?? '$e');
            return;
          }
        }

        Map<String, dynamic> vr;
        try {
          vr = await armed.future.timeout(const Duration(seconds: 8));
        } catch (_) {
          _fail(l?.pairingPassphraseTimeout ?? 'timeout');
          return;
        }

        if (vr['ok'] == true) {
          unlocked = true;
          assignedSlot = (vr['data']?['slot'] as num?)?.toInt() ?? assignedSlot;
        } else {
          final code = vr['err']?.toString() ?? '';
          if (code == 'ERR_PASSPHRASE_INCORRECT') {
            attemptsLeft = (vr['params']?['attempts_left'] as num?)?.toInt()
                ?? (attemptsLeft > 0 ? attemptsLeft - 1 : 0);
            if (attemptsLeft <= 0) {
              _fail(l?.passphraseLockoutTriggered ?? 'lockout');
              return;
            }
            // loop, re-prompt with updated attempts_left
          } else if (code == 'ERR_NO_PENDING_BOND') {
            _fail(l?.pairingWindowClosedRetry ?? 'window closed');
            return;
          } else {
            _fail(l?.pairingPassphraseFailed(code) ?? 'failed: $code');
            return;
          }
        }
      }
    }

    // Save under both the BLE MAC (widget.device.id, used for session
    // setup + paired-list ordering) AND the SmartKraft id (widget.device.
    // name, what BF firmware sends as X-SK-Device-Id in webhooks). Without
    // the alias every webhook lands at SKAPP, fails BondStore lookup, and
    // is rejected as "Device not paired with this SKAPP" — even though
    // the device is in fact paired.
    await store.save(
      widget.device.id,
      bond.token,
      peerId: ourPeerId,
      slot: assignedSlot,
      aliasIds: [widget.device.name],
    );

    // Persist user-visible metadata so home/devices listings can render
    // this device even before any session is open.
    await ref.read(pairedDevicesProvider.notifier).upsert(PairedDevice(
          id: widget.device.id,
          name: widget.device.name,
          prefix: widget.device.typePrefix ?? '??',
          pairedAt: DateTime.now(),
        ));

    // The device closes the link itself once it's written the reply, but
    // we explicitly disconnect to make sure both sides agree about state.
    try {
      await _btDevice?.disconnect();
    } catch (_) {/* already gone is fine */}
    // Hand off BLE ownership: the next screen's deviceSessionProvider
    // will open a *new* connection on the same BluetoothDevice handle.
    // If we keep `_btDevice` non-null, this State's dispose() would
    // call disconnect() on the singleton handle and tear down the
    // provider's freshly-opened transport, exactly the bug that
    // caused wifi.scan to never reach the device after Faz 2 added the
    // post-pair status probe.
    _btDevice = null;

    // ── 7. Done ──────────────────────────────────────────────────────
    _set(_PairStage.done);
    // Give NimBLE on the device side a beat to finish closing the
    // bootstrap link before the provider tries to re-open one. The
    // device-side gatt logs show ~250 ms between "ECDH complete" and
    // "advertising as ... pairable=0". 800 ms covered the device side but
    // not Android's own link teardown; the immediate re-connect then
    // stalled and the wizard timed out. 1.8 s gives both sides room.
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    await _routeAfterPairing();
  }

  /// Decide where to send the user once the secure session is up.
  ///
  /// Primary signal: `device.info.user_configured` — true once the device
  /// has been through its initial setup (first successful `wifi.ip.acquired`).
  /// This is the authoritative flag set by sk_baseline.c and cleared on
  /// factory reset, so a re-pair after orphan-bond recovery skips the
  /// wizard cleanly.
  ///
  /// Fallback (older firmware without the flag): `wifi.status.has_primary`
  /// / `has_backup` — credentials presence is a good proxy.
  ///
  /// Both probes failing falls through to the wizard — better to ask the
  /// user than land on a screen assuming connectivity that may not exist.
  Future<void> _routeAfterPairing() async {
    bool skipWizard = false;
    String? connectedSsid;
    bool userConfiguredKnown = false;
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.device.id).future)
          .timeout(const Duration(seconds: 30));

      final infoReply = await session.client
          .send('device.info', timeout: const Duration(seconds: 5));
      if (infoReply.ok && infoReply.data is Map) {
        final m = infoReply.data as Map;
        if (m.containsKey('user_configured')) {
          userConfiguredKnown = true;
          skipWizard = m['user_configured'] == true;
        }
        final wifi = m['wifi'];
        if (wifi is Map && wifi['connected'] == true) {
          connectedSsid = wifi['ssid']?.toString();
        }
      }

      // Older firmware doesn't expose user_configured — fall back to
      // credentials presence so an upgraded device that's already on
      // WiFi still skips the wizard.
      if (!userConfiguredKnown) {
        final statusReply = await session.client
            .send('wifi.status', timeout: const Duration(seconds: 5));
        if (statusReply.ok && statusReply.data is Map) {
          final m = statusReply.data as Map;
          skipWizard = m['has_primary'] == true || m['has_backup'] == true;
          if (connectedSsid == null && m['connected'] == true) {
            connectedSsid = m['ssid']?.toString();
          }
        }
      }

      _trace('post-pair: user_configured='
          '${userConfiguredKnown ? skipWizard : "n/a"} '
          '→ skipWizard=$skipWizard ssid=${connectedSsid ?? "(none)"}');
    } catch (e) {
      _trace('post-pair: probe failed ($e), showing wizard');
    }
    if (!mounted) return;
    final next = skipWizard
        ? WifiSuccessScreen(device: widget.device, ssid: connectedSsid)
        : WifiScanScreen(device: widget.device);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  void _set(_PairStage s) {
    if (!mounted) return;
    setState(() => _stage = s);
  }

  void _fail(String msg) {
    if (!mounted) return;
    _trace('FAIL: ${msg.split("\n").first}');
    setState(() {
      _stage = _PairStage.failed;
      _errorMsg = msg;
    });
  }

  Future<void> _retry() async {
    await _notifySub?.cancel();
    _notifySub = null;
    try {
      await _btDevice?.disconnect();
    } catch (_) {}
    // KRİTİK: deviceSessionProvider AsyncError state'inde takılı kalmış
    // olabilir; .future her okumada cached hatayı 1ms'de döndürür. Bu
    // yüzden retry sahte "transient" oluyordu — gerçek BLE denemesi
    // hiç başlamıyordu. Invalidate ederek provider'ı sıfırlıyoruz, bir
    // sonraki .read taze attempt başlatsın.
    ref.invalidate(deviceSessionProvider(widget.device.id));
    setState(() {
      _stage = _PairStage.connecting;
      _errorMsg = null;
      _isReconnect = null;
    });
    await _decideAndRun();
  }

  /// Manuel recovery: kullanıcı transient timeout döngüsünde sıkıştıysa
  /// "Eşleşmeyi yenile" butonuyla zorla bootstrap'a geçer. BLE auth
  /// timeout'u BF tarafında bond yokken DA timeout olarak görünüyor
  /// (auth.challenge hiç gelmez); bu durumda otomatik tanı koyamadığımız
  /// için kullanıcıya kaçış kapısı bırakmak şart.
  Future<void> _manualRecovery() async {
    if (!mounted) return;
    final proceed = await _confirmPairingMode();
    if (!mounted) return;
    if (proceed != true) return;

    await _notifySub?.cancel();
    _notifySub = null;
    try {
      await _btDevice?.disconnect();
    } catch (_) {}
    try {
      await ref.read(bondStoreProvider).clear(widget.device.id);
    } catch (_) {/* silent */}
    ref.invalidate(deviceSessionProvider(widget.device.id));
    if (!mounted) return;
    setState(() {
      _isReconnect = false;
      _stage = _PairStage.connecting;
      _errorMsg = null;
    });
    await _runFlow();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    // Recovery butonunun neden render edilip edilmediğini logcat'ten
    // teyit etmek için her build'de state'i basıyoruz. Kullanıcı
    // "manuel recovery butonunu görmüyorum" diyorsa bu satır
    // _isReconnect/_stage/_errorMsg üçlüsünün hangi pozisyonda
    // takıldığını anlatır.
    debugPrint(
        '[PAIR] build: isReconnect=$_isReconnect stage=$_stage errorMsg=${_errorMsg != null}');

    final title = _isReconnect == null
        ? l.pairingTitleConnecting
        : (_isReconnect! ? l.pairingTitleReconnecting : l.pairingTitle);

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(title)),
      body: SkContent(
        maxWidth: SkBreakpoints.maxContentWidth,
        horizontalPadding: 24,
        child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Icon(
              DeviceTypeVisual.iconFor(widget.device.typePrefix),
              size: 56,
              color: cs.primary,
            ),
            const SizedBox(height: 14),
            Text(widget.device.name,
                style: Theme.of(context).textTheme.headlineSmall),
            if (widget.device.isSmartKraft) ...[
              const SizedBox(height: 2),
              Text(
                DeviceTypeVisual.friendlyName(widget.device.typePrefix),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              widget.device.id,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 36),
            // Flexible (Expanded değil): failed state'de error container +
            // debug panel + iki buton birlikte ekrana sığmayınca, eski
            // Expanded "tüm artan alanı al" deyip aşağıdaki butonları
            // viewport dışına itiyordu. Flexible loose fit'li olduğu için
            // alttaki içerik için yer bırakır.
            Flexible(child: _stepsList(context)),
            if (_stage == _PairStage.failed) ...[
              if (_errorMsg != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_errorMsg!,
                      style: TextStyle(color: cs.onErrorContainer)),
                ),
              if (_trail.isNotEmpty)
                _DebugPanel(trail: _trail),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: Text(l.pairingRetryButton),
                  ),
                  // Manuel recovery: Tekrar dene'nin yanında (geniş ekran)
                  // veya altında (dar ekran) görünür. Wrap'in runSpacing'i
                  // satır atladığında 8px ekler. Önceki dikey yerleşim
                  // Column'un Expanded'ı yüzünden navbar altına itiliyordu.
                  if (_isReconnect != false)
                    FilledButton.tonalIcon(
                      onPressed: _manualRecovery,
                      icon: const Icon(Icons.link_off),
                      label: Text(l.pairingRenewBondButton),
                    ),
                ],
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }

  Widget _stepsList(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final steps = (_isReconnect ?? false)
        ? <_StepRow>[
            _StepRow(
              title: l.pairingStepConnecting,
              subtitle: l.pairingStepConnectingSubtitle,
              state: _stateOf(_PairStage.connecting),
            ),
            _StepRow(
              title: l.pairingStepMutualAuth,
              subtitle: l.pairingMutualAuthHmacSubtitle,
              state: _stateOf(_PairStage.exchanging),
            ),
            _StepRow(
              title: l.pairingStepDeviceInfo,
              subtitle: l.pairingStepDeviceInfoSubtitle,
              state: _stateOf(_PairStage.verifying),
            ),
            _StepRow(
              title: l.pairingStepConnected,
              subtitle: l.pairingStepConnectedSubtitle,
              state: _stateOf(_PairStage.done),
            ),
          ]
        : <_StepRow>[
            _StepRow(
              title: l.pairingStepConnecting,
              subtitle: l.pairingStepConnectingSubtitle,
              state: _stateOf(_PairStage.connecting),
            ),
            _StepRow(
              title: l.pairingStepKeyExchange,
              subtitle: l.pairingStepKeyExchangeSubtitle,
              state: _stateOf(_PairStage.exchanging),
            ),
            _StepRow(
              title: l.pairingStepVerifying,
              subtitle: l.pairingStepVerifyingSubtitle,
              state: _stateOf(_PairStage.verifying),
            ),
            _StepRow(
              title: l.pairingStepDone,
              subtitle: l.pairingStepDoneSubtitle,
              state: _stateOf(_PairStage.done),
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in steps)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: s,
          ),
        if (_errorMsg != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: cs.onErrorContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _errorMsg!,
                    style: TextStyle(color: cs.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.wifiPairingStageAwaitingHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  _StepState _stateOf(_PairStage s) {
    if (_stage == _PairStage.failed) {
      return s.index < _stage.index || s == _stage
          ? _StepState.failed
          : _StepState.pending;
    }
    if (_stage.index > s.index) return _StepState.done;
    if (_stage.index == s.index) return _StepState.active;
    return _StepState.pending;
  }
}

enum _StepState { pending, active, done, failed }

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.title,
    required this.subtitle,
    required this.state,
  });
  final String title;
  final String subtitle;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (icon, color) = switch (state) {
      _StepState.pending => (
        Icons.radio_button_unchecked,
        cs.onSurfaceVariant.withValues(alpha: 0.5)
      ),
      _StepState.active =>
        (Icons.radio_button_checked, cs.primary),
      _StepState.done => (Icons.check_circle, cs.primary),
      _StepState.failed => (Icons.error, cs.error),
    };
    final dim = state == _StepState.pending;

    return Row(
      children: [
        SizedBox(
          // Square outer container so the CircularProgressIndicator
          // doesn't stretch into an ellipse when Row's cross-axis
          // resolves taller than 28 (title+subtitle column).
          width: 28,
          height: 28,
          child: Center(
            child: state == _StepState.active
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: cs.primary,
                      backgroundColor: cs.primary.withValues(alpha: 0.18),
                    ),
                  )
                : Icon(icon, color: color),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: dim ? cs.onSurfaceVariant : cs.onSurface,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: dim
                          ? cs.onSurfaceVariant.withValues(alpha: 0.7)
                          : cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Failed durumda kullanıcıya gösterilen debug log paneli. Son 40 trace
/// satırını monospace font ile listeler; tek tıklamayla pano kopyalama.
/// adb logcat erişimi olmayan kullanıcılar için tek pratik debug akışı
/// kullanıcı kopyalayıp WhatsApp/email ile getirebilir.
class _DebugPanel extends StatelessWidget {
  const _DebugPanel({required this.trail});
  final List<String> trail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report,
                  size: 14, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).pairingLogTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              IconButton(
                tooltip: AppLocalizations.of(context).settingsNetworkIdentityCopy,
                icon: const Icon(Icons.copy, size: 16),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: trail.join('\n')));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context).pairingLogCopied)),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 8),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: SelectableText(
                trail.join('\n'),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
