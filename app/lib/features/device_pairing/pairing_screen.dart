import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/ble_service.dart';
import '../../core/ble/device_model.dart';
import '../../core/ble/device_type_visual.dart';
import '../../core/ble/paired_ble_scanner.dart'
    show beginBleExclusive, endBleExclusive;
import '../../core/cli/ble_transport.dart'
    show bleTraceStream, PairingRequiredException;
import '../../core/cli/bond_store.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/cli/transport_selector.dart';
import '../../core/logging/app_logger.dart';
import '../../core/pairing/pairing_error.dart';
import '../../core/pairing/pairing_link.dart';
import '../../core/pairing/pairing_session.dart';
import '../../core/pairing/pairing_timeouts.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_confirm_dialog.dart';
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

// Bond-reddi marker'ı artık core/pairing/pairing_error.dart'ta
// (BondRejectedError) — isHardBondRejection ile birlikte tek yerde.

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
  // Kırılma anındaki aşama — adım listesi renklendirmesi için.
  _PairStage? _failedAt;
  String? _errorMsg;
  BluetoothDevice? _btDevice;
  BlePairingLink? _pairingLink;
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
    _pairingLink?.close();
    _btDevice?.disconnect().catchError((Object e) {
      debugPrint('[PAIR] dispose disconnect: $e');
    });
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
      await _guardedRun(() async {
      // REQUEST-DRIVEN BOOTSTRAP FIRST (deterministik, yarış-bağışık).
      //
      // Eski tasarım: bond varsa reconnect'e giriyordu ve cihazın abonelik
      // anında ATTIĞI proaktif hint'i (auth.challenge / pairing.required)
      // beklerdi. macOS/BLE'de bu notify, setNotifyValue anında geldiğinden
      // KAÇABİLİYOR → app 8-30 sn boşa bekliyor, "transient" sanıp otomatik
      // bootstrap'a düşmüyor (gözlemlenen "X25519'da sonsuz takılma").
      //
      // Yeni tasarım: app önce PROAKTİF olarak pairing.ecdh.exchange yazar
      // (bootstrap). Bu, cihazın konuşmasını beklemediğinden yarıştan
      // bağımsızdır ve our_pub cevabı yazıdan SONRA geldiğinden güvenle
      // yakalanır. Cihaz zaten bond'luysa (pairing penceresi kapalı) ECDH
      // `ERR_PAIRING_NOT_OPEN` döner → _runFlow mevcut bond'la reconnect'e
      // devreder. Böylece hem taze-ekleme hem repair tek deterministik yolla
      // çalışır.
        if (!mounted) return;
        setState(() => _isReconnect = false);
        await _runFlow();
      });
    } finally {
      _decideRunning = false;
    }
  }

  /// Son savunma hattı: akıştan kaçan HERHANGİ bir hata (kripto
  /// ArgumentError, secure-storage PlatformException, provider hatası)
  /// spinner'ı sonsuza kadar döndürmek yerine hata kartına iner. Zone
  /// handler'a hiçbir eşleştirme hatası kaçmaz (audit C1 — kalıcı-takılı
  /// UI'nin tek kaynağı buydu).
  ///
  /// Ekrandan tetiklenen HER akış (ilk çalıştırma, Tekrar dene, manuel
  /// yenileme) bu sarmalayıcıdan geçmeli; doğrudan `_runFlow()` çağrısı
  /// korumayı delip eski davranışı geri getirir.
  Future<void> _guardedRun(Future<void> Function() body) async {
    try {
      await body();
    } catch (e, st) {
      AppLogger.instance.error('pair.ble', e, st);
      _trace('unhandled: $e');
      if (mounted) {
        _fail(AppLocalizations.of(context).pairingUnexpectedError(e.toString()));
      }
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
      } catch (e) {
        _trace('stale-link disconnect: $e (devam)');
      }

      _trace('reconnect: opening session via provider');
      _set(_PairStage.exchanging);
      // chainWorstCase wrapper: deviceSessionProvider zincirinin (TCP cache
      // → mDNS → .local → BLE) toplam bütçesi tek kaynaktan gelir. Eski
      // el-ile-30s değer, zincir bütçeleri düzeltilince (BLE 15s→~45s)
      // yine iç toplamın altında kalacaktı — aynı erken-kesme hatası
      // (yanlış pozitif → bond clear → PlatformException döngüsü) geri
      // gelirdi.
      final session = await ref
          .read(deviceSessionProvider(widget.device.id).future)
          .timeout(TransportSelector.chainWorstCase);
      _set(_PairStage.verifying);

      _trace('reconnect: sending device.info ping');
      final ping = await session.client
          .send('device.info', timeout: const Duration(seconds: 8));
      if (!ping.ok) {
        throw BondRejectedError(ping.err ?? 'device.info');
      }

      // Kayıt yoksa geri yaz: touch() kayıt yokken no-op'tur. Bond'u olan
      // ama metadata'sı silinmiş cihaz (yarım kalmış persist / yarım
      // kalmış forget) aksi halde "eşleşti" görünüp listeye hiç düşmez —
      // uygulama yeniden başlayınca cihaza dönüş yolu kalmaz.
      final devicesStore = ref.read(pairedDevicesProvider.notifier);
      if (ref.read(pairedDevicesProvider).matchDeviceId(widget.device.id) ==
          null) {
        await devicesStore.upsert(PairedDevice(
          id: widget.device.id,
          name: widget.device.name,
          prefix: widget.device.typePrefix ?? '??',
          pairedAt: DateTime.now(),
        ));
      } else {
        await devicesStore.touch(widget.device.id);
      }

      _trace('reconnect: success');
      _set(_PairStage.done);
      await Future.delayed(PairingTimeouts.reconnectDoneDwell);
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
      // Tipli sınıflandırma: eski substring eşleştirme ('err_',
      // 'reddedildi') locale'e bağımlıydı ve TransportClosedException gibi
      // transient hataları yanlışlıkla hard sayıp bond silebiliyordu.
      final isHardRejection = isHardBondRejection(e);

      if (!isHardRejection) {
        _trace('reconnect transient ($e) — keeping bond, prompting retry');
        if (!mounted) return;
        _fail(AppLocalizations.of(context)
            .pairingReconnectTransient(e.toString()));
        return;
      }

      // Cihaz "pairing.required (no_bond)" hint'i gönderdiyse pairing penceresi
      // ZATEN açık (firmware sabit-güç fix'i: sahipsiz cihaz her zaman
      // eşleşilebilir). Kullanıcıya "butona bas" dedirtmeden bayat bond'u
      // otomatik temizleyip bootstrap'a düş — kusursuz/sürtünmesiz eşleşme.
      // Diğer sert reddedişlerde (bond farklı/çürük, pencere gerçekten kapalı)
      // onay dialog'unu göster.
      if (e is! PairingRequiredException) {
        _trace('reconnect rejected ($e) — asking user for pairing-mode confirm');
        if (!mounted) return;
        final proceed = await _confirmPairingMode();
        if (!mounted) return;
        if (proceed != true) {
          _fail(AppLocalizations.of(context).pairingRecoveryCancelled);
          return;
        }
      } else {
        _trace('reconnect: device pairable (no_bond) — '
            'auto-clearing stale bond and bootstrapping');
      }

      try {
        // Alias da temizlenmeli: save() token'ı hem MAC hem SmartKraft adı
        // altında yazar; yalnız id'yi silmek ad alias'ından dirilme demek.
        await ref.read(bondStoreProvider).clear(widget.device.id);
        await ref.read(bondStoreProvider).clear(widget.device.name);
      } catch (e2, st2) {
        // Bayat bond diskte kalırsa bootstrap ERR_PAIRING_NOT_OPEN /
        // PlatformException döngüsüne girer — sessizce devam etmek YASAK
        // (audit C3'ün tehlikeli çifti).
        AppLogger.instance.error('pair.ble', e2, st2);
        if (!mounted) return;
        _fail(AppLocalizations.of(context).pairingBondClearFailed(e2.toString()));
        return;
      }
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
    return showSkConfirm(
      context,
      title: l.pairingRecoveryTitle,
      message: l.pairingRecoveryBody,
      cancelLabel: l.commonCancel,
      confirmLabel: l.pairingRecoveryContinue,
      barrierDismissible: false,
    );
  }

  Future<void> _runFlow() async {
    final svc = ref.read(bleServiceProvider);
    final dev = svc.deviceFor(widget.device.id);
    _btDevice = dev;

    await svc.stopScan();

    // PairedBleScanner sweep'leriyle yarışı kapat: pairing GATT trafiği
    // boyunca adapter exclusive kullanılır. Concurrent scan + connect
    // Android'de adapter state machine'ini bozuyor (auth.challenge/notify
    // pipe kaybı) — BleCliTransport bu kilidi zaten alıyordu, bootstrap
    // akışı açıkta kalmıştı.
    beginBleExclusive();
    try {
      await _runFlowLocked(dev);
    } finally {
      endBleExclusive();
    }
  }

  Future<void> _runFlowLocked(BluetoothDevice dev) async {
    // Defensive disconnect: önceki başarısız reconnect, recovery transition
    // veya başka bir oturumdan kalmış half-open link, dev.connect()'i no-op'a
    // dönüştürür. Bu durumda discoverServices/setNotifyValue cached state
    // üzerinde çalışır ve BF cihazı yeniden subscribe event'i göndermez —
    // pairing.ecdh.exchange writes sessizce başarısız olur. Önce temiz
    // kopuş, sonra taze GAP connect.
    try {
      await dev.disconnect().timeout(PairingTimeouts.bleDisconnect);
      // Bağlantının GERÇEKTEN kapandığını bekle: bir önceki reconnect
      // transport'unun link'i hâlâ kapanıyorsa connect() cached state
      // üzerinde no-op'a döner, GATT keşfi eski state'i görür ve ECDH
      // yazısı sessizce hiçbir yere gitmez (gözlemlenen "X25519'da takılma").
      await dev.connectionState
          .firstWhere((s) => s == BluetoothConnectionState.disconnected)
          .timeout(PairingTimeouts.bleDisconnect);
    } catch (e) {
      _trace('pre-connect cleanup: $e (taze connect ile devam)');
    }
    await Future.delayed(PairingTimeouts.bleDisconnectSettle);

    // ── 1. Connect ────────────────────────────────────────────────────
    try {
      _set(_PairStage.connecting);
      _trace('bootstrap: connecting…');
      await dev
          .connect(timeout: PairingTimeouts.bleConnect, license: License.free)
          .timeout(PairingTimeouts.bleConnectOuter);
      try {
        await dev.requestMtu(247).timeout(PairingTimeouts.bleMtu);
      } catch (e) {
        _trace('MTU exchange failed ($e), negotiated default ile devam');
      }
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingBleConnectFailed(e.toString()));
      return;
    }

    // ── 2. Discover GATT + pairing linki ──────────────────────────────
    BluetoothCharacteristic cmdRx;
    BluetoothCharacteristic eventTx;
    final lEarly = mounted ? AppLocalizations.of(context) : null;
    try {
      _set(_PairStage.exchanging);
      _trace('bootstrap: discovering services…');
      final services =
          await dev.discoverServices().timeout(PairingTimeouts.bleDiscover);
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
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingGattDiscoveryFailed(e.toString()));
      return;
    }

    // Notify aboneliği + satır pompası artık BlePairingLink'te (listener
    // CCCD'den önce bağlanır — macOS notify yarışına karşı). `device`
    // veriliyor ki link kopuşu 20 s beklemek yerine anında yüzeye çıksın;
    // onTrace ile ham rx izleri ekrandaki debug paneline düşer.
    final link = BlePairingLink(
      cmdRx: cmdRx,
      eventTx: eventTx,
      device: dev,
      onTrace: _trace,
    );
    try {
      await link.start();
    } catch (e) {
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingGattDiscoveryFailed(e.toString()));
      return;
    }
    _pairingLink = link;
    _trace('bootstrap: GATT ready, notify subscribed');

    // Kimlik: install peer_id + görünen label. Secure-storage hatası temiz
    // eşleştirme hatasına inmeli — asla "key exchange"de dönen sonsuz
    // spinner değil. (X25519 takılmasının kök nedeni: appPeerId() macOS
    // ad-hoc imzalı build'de errSecMissingEntitlement -34018 fırlatıyordu.
    // Keychain düzeltildi; bu guard defence-in-depth.)
    final store = ref.read(bondStoreProvider);
    final Uint8List ourPeerId;
    final String label;
    try {
      // bond_store `label` slotu BU SKAPP kurulumunu tanıtır (cihazın
      // loglarında ve ERR_BOND_STORE_FULL peer listesinde görünür), bu
      // yüzden NetworkIdentity'den kendi adımızı okuyoruz.
      ourPeerId = await store.appPeerId();
      label = shortPairingLabel(ref.read(networkIdentityProvider).name);
    } catch (e) {
      _trace('bootstrap: peer-id/label failed (secure storage?): $e');
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingKeySendFailed(e.toString()));
      return;
    }

    // ── 3. Protokol: ortak PairingSession (BLE + TCP tek durum makinesi) ─
    _set(_PairStage.verifying);
    final PairingSessionResult result;
    try {
      result = await PairingSession(
        link: link,
        ourPeerId: ourPeerId,
        label: label,
        onTrace: _trace,
      ).run(promptPassphrase: (attemptsLeft) async {
        if (!mounted) return null;
        return promptPairingPassphrase(context, attemptsLeft: attemptsLeft);
      });
    } on PairingException catch (e) {
      // Cihaz pairing modunda DEĞİL (zaten bir bond'u var, pencere kapalı) →
      // yeni eşleşme değil, mevcut bond'la RECONNECT gerekir. Bu bağlantıyı
      // temizce kapatıp reconnect yoluna devret. (Bootstrap-first tasarımın
      // repair ayağı.)
      if (e.code == PairingErrorCode.pairingNotOpen) {
        _trace('bootstrap: device already bonded (window closed) → reconnect');
        await link.close();
        _pairingLink = null;
        try {
          await _btDevice?.disconnect();
        } catch (e2) {
          _trace('handoff disconnect: $e2 (zaten kopuk)');
        }
        _btDevice = null;
        ref.invalidate(deviceSessionProvider(widget.device.id));
        if (!mounted) return;
        setState(() => _isReconnect = true);
        await _runReconnect();
        return;
      }
      AppLogger.instance.warn('pair.ble', e);
      if (!mounted) return;
      _fail(pairingFailureMessage(context, e, wifiFlow: false));
      return;
    }

    // ── 4. Persist ────────────────────────────────────────────────────
    // Save under both the BLE MAC (widget.device.id, used for session
    // setup + paired-list ordering) AND the SmartKraft id (widget.device.
    // name, what BF firmware sends as X-SK-Device-Id in webhooks). Without
    // the alias every webhook lands at SKAPP, fails BondStore lookup, and
    // is rejected as "Device not paired with this SKAPP" — even though
    // the device is in fact paired.
    try {
      await store.save(
        widget.device.id,
        result.token,
        peerId: ourPeerId,
        slot: result.slot,
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
    } catch (e, st) {
      // Bond diske yazılamadıysa eşleşme TAMAMLANMAMIŞTIR — sessiz devam
      // "eşleşti ama hiç bağlanamıyor" hayalet durumu üretir (audit C1).
      AppLogger.instance.error('pair.ble', e, st);
      if (!mounted) return;
      _fail(pairingFailureMessage(
          context,
          PairingException(PairingStage.persist, PairingErrorCode.storage,
              cause: e, stackTrace: st),
          wifiFlow: false));
      return;
    }

    // The device closes the link itself once it's written the reply, but
    // we explicitly disconnect to make sure both sides agree about state.
    await link.close();
    _pairingLink = null;
    try {
      await _btDevice?.disconnect();
    } catch (e) {
      _trace('post-pair disconnect: $e (already gone is fine)');
    }
    // Hand off BLE ownership: the next screen's deviceSessionProvider
    // will open a *new* connection on the same BluetoothDevice handle.
    // If we keep `_btDevice` non-null, this State's dispose() would
    // call disconnect() on the singleton handle and tear down the
    // provider's freshly-opened transport, exactly the bug that
    // caused wifi.scan to never reach the device after Faz 2 added the
    // post-pair status probe.
    _btDevice = null;

    // ── 5. Done ──────────────────────────────────────────────────────
    _set(_PairStage.done);
    // Give NimBLE on the device side a beat to finish closing the
    // bootstrap link before the provider tries to re-open one. The
    // device-side gatt logs show ~250 ms between "ECDH complete" and
    // "advertising as ... pairable=0". 800 ms covered the device side but
    // not Android's own link teardown; the immediate re-connect then
    // stalled and the wizard timed out. 1.8 s gives both sides room.
    await Future.delayed(PairingTimeouts.blePostPairSettle);
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
          .timeout(TransportSelector.chainWorstCase);

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
      // Sessiz yönlendirme değişikliği (audit C5): probe hatası kullanıcıyı
      // sihirbaza sokar — güvenli varsayılan, ama artık iz bırakıyor.
      AppLogger.instance.warn('pair.ble', 'post-pair probe failed: $e — wizard fallback');
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
      // Hangi adımda kırıldığını sakla: adım listesi başarılı adımları
      // yeşil bırakıp yalnız kırılan adımı kırmızı gösterebilsin (eskiden
      // hepsi kırmızıya boyanıyordu, kullanıcı nerede koptuğunu göremezdi).
      _failedAt = _stage;
      _stage = _PairStage.failed;
      _errorMsg = msg;
    });
  }

  Future<void> _retry() async {
    // _manualRecovery ile aynı sözleşme: temizlik adımlarından biri
    // fırlarsa (link.close, disconnect, ref.invalidate) fire-and-forget
    // buton handler'ında yakalanmamış zone hatası olur ve ekran dönmeye
    // devam eder — _guardedRun bunu hata kartına çevirir.
    if (_decideRunning) {
      debugPrint('[PAIR] _retry: reentrancy blocked');
      return;
    }
    await _guardedRun(_retryLocked);
  }

  Future<void> _retryLocked() async {
    await _pairingLink?.close();
    _pairingLink = null;
    try {
      await _btDevice?.disconnect();
    } catch (e) {
      _trace('retry cleanup disconnect: $e');
    }
    // Yukarıdaki await'ler sırasında kullanıcı ekrandan çıkmış olabilir;
    // unmount sonrası `ref` kullanmak Riverpod'da fırlatır ve bu
    // fire-and-forget buton handler'ında yakalanmamış zone hatası olur.
    if (!mounted) return;
    // KRİTİK: deviceSessionProvider AsyncError state'inde takılı kalmış
    // olabilir; .future her okumada cached hatayı 1ms'de döndürür. Bu
    // yüzden retry sahte "transient" oluyordu — gerçek BLE denemesi
    // hiç başlamıyordu. Invalidate ederek provider'ı sıfırlıyoruz, bir
    // sonraki .read taze attempt başlatsın.
    ref.invalidate(deviceSessionProvider(widget.device.id));
    setState(() {
      _stage = _PairStage.connecting;
      _errorMsg = null;
      _failedAt = null;
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
    // Reentrancy guard: bu akış da _decideAndRun ile AYNI BLE kaynaklarını
    // kullanır. Onay dialogu ile setState arasında ekran hâlâ `failed`
    // durumunda olduğu için "Tekrar dene" butonu canlıdır; koruma olmadan
    // iki paralel BLE akışı başlayıp notify dinleyicilerini çakıştırıyordu.
    if (_decideRunning) {
      debugPrint('[PAIR] _manualRecovery: reentrancy blocked');
      return;
    }
    if (!mounted) return;
    final proceed = await _confirmPairingMode();
    if (!mounted) return;
    if (proceed != true) return;
    if (_decideRunning) return; // dialog açıkken başka akış başlamış olabilir
    _decideRunning = true;
    try {
      await _guardedRun(_manualRecoveryLocked);
    } finally {
      _decideRunning = false;
    }
  }

  Future<void> _manualRecoveryLocked() async {
    await _pairingLink?.close();
    _pairingLink = null;
    try {
      await _btDevice?.disconnect();
    } catch (e) {
      _trace('recovery cleanup disconnect: $e');
    }
    try {
      await ref.read(bondStoreProvider).clear(widget.device.id);
      await ref.read(bondStoreProvider).clear(widget.device.name);
    } catch (e, st) {
      // Bond temizlenemeden bootstrap'a girmek bilinen döngüye sokar
      // (ERR_PAIRING_NOT_OPEN → PlatformException) — hatayı yüzeye çıkar.
      AppLogger.instance.error('pair.ble', e, st);
      if (!mounted) return;
      _fail(AppLocalizations.of(context).pairingBondClearFailed(e.toString()));
      return;
    }
    if (!mounted) return;
    ref.invalidate(deviceSessionProvider(widget.device.id));
    setState(() {
      _isReconnect = false;
      _stage = _PairStage.connecting;
      _errorMsg = null;
      _failedAt = null;
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
      final failedAt = _failedAt ?? _PairStage.connecting;
      if (s.index < failedAt.index) return _StepState.done;
      if (s == failedAt) return _StepState.failed;
      return _StepState.pending;
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
