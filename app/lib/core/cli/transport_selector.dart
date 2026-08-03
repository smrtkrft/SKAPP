// TCP-cache → mDNS → BLE fallback chain, extracted from deviceSessionProvider
// for independent testability. Production code calls:
//
//   TransportSelector(ref: ref).selectAndConnect(deviceId)
//
// Tests inject [tcpClientFactory], [bleClientFactory] and [mdnsResolver] to
// avoid real sockets / BLE adapters while exercising the full selection logic.

import 'dart:async' show TimeoutException, unawaited;
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/ble_service.dart';
import '../storage/paired_devices_store.dart';
import 'ble_transport.dart';
import 'bond_store.dart';
import 'cli_client.dart';
import 'cli_session.dart';
import 'cli_signer.dart';
import 'cli_transport.dart';
import 'mdns_discovery.dart';
import 'tcp_transport.dart';

class TransportSelector {
  TransportSelector({
    required this.ref,
    @visibleForTesting this.tcpClientFactory,
    @visibleForTesting this.bleClientFactory,
    @visibleForTesting this.mdnsResolver,
  });

  final Ref ref;

  /// Override for tests: returns a [CliClient] over a fake TCP transport
  /// without opening a real socket.
  @visibleForTesting
  final CliClient Function(String host, int port, List<int> token)?
      tcpClientFactory;

  /// Override for tests: returns a [CliClient] over a fake BLE transport
  /// without requiring a Bluetooth adapter.
  @visibleForTesting
  final CliClient Function(String deviceId, List<int> token)? bleClientFactory;

  /// Override for tests: replaces the live multicast-DNS sweep.
  @visibleForTesting
  final Future<MdnsDeviceEndpoint?> Function(
    String instance, {
    Duration? timeout,
  })? mdnsResolver;

  // All timeouts are named constants so tests can verify which path was taken
  // (the transport kind on the returned session) without needing to inspect
  // wall-clock behaviour. Invariant: dış sarmalayıcı ≥ iç aşamaların toplamı
  // (timeout_budget_test.dart) — eski değerler (cache 3 s, fresh 8 s,
  // BLE 15 s) iç bütçelerin ALTINDAYDI ve yavaş-ama-sağlıklı bağlantıları
  // yapay olarak kesiyordu.
  /// Cache yolunda Socket.connect bütçesi: ölü IP hızlı düşsün.
  static const tcpCacheConnectTimeout = Duration(seconds: 3);
  /// Cache yolu toplamı: connect 3 s + auth 10 s + 1 s pay. Eski tek 3 s
  /// tavan, canlı-ama-yavaş endpoint'te auth'u kesip İYİ cache'i siliyordu.
  static const tcpCacheTimeout = Duration(seconds: 14);
  // In-process multicast_dns resolve. Kept short: where it works (mobile,
  // macOS) it answers in well under a second, and where it's blocked (the
  // Windows firewall routinely drops the app's own UDP-5353 socket) we want
  // to fail fast and let the `.local` OS-resolver step below carry the
  // connection instead of stalling here.
  static const mdnsResolveTimeout = Duration(seconds: 2);
  /// connect 5 s + auth 10 s + 1 s pay.
  static const tcpFreshTimeout = Duration(seconds: 16);
  /// BLE zincirinin iç bütçesi + 4 s pay. 15 s'lik eski tavan ~41 s'lik
  /// zinciri ortadan kesiyor, aşama bilgisini yok ediyor ve cihazın
  /// pairing.required ipucuyla yarışıyordu (audit C11).
  static Duration get bleTimeout =>
      BleCliTransport.connectBudget + const Duration(seconds: 4);

  /// Ekranların oturum-açma sarmalayıcıları için zincirin en kötü durumu.
  /// Tek kaynak: wifi_password'ün eski 12 s'i gibi ekran-başına kopyalanan
  /// (ve iç bütçenin altında kalan) literal'lerin yerini alır.
  static Duration get chainWorstCase =>
      tcpCacheTimeout +
      mdnsResolveTimeout +
      tcpFreshTimeout * 2 +
      bleTimeout +
      const Duration(seconds: 5);

  /// Tries TCP cache → mDNS fresh-resolve + TCP → BLE in order.
  ///
  /// Throws [BondMissingException] if no stored bond is found.
  /// Throws [PairingRequiredException] or [AuthRejectedException] (re-thrown
  /// from BLE) when the device reports it needs re-pairing or rejects our
  /// bond — do NOT wrap these in [DeviceUnreachableException]; the caller's
  /// pairing recovery (isHardBondRejection) depends on seeing the real type.
  /// Throws [DeviceUnreachableException] when all three paths fail.
  Future<DeviceSession> selectAndConnect(String deviceId) async {
    final bondStore = ref.read(bondStoreProvider);
    final token = await bondStore.tokenFor(deviceId);
    if (token == null) throw BondMissingException(deviceId);

    // ID canonicalization: matchDeviceId handles exact-id, exact-name and
    // case-insensitive fallbacks (see paired_devices_store.dart). Falls back
    // to the raw deviceId as mDNS instance name when no PairedDevice matches.
    final paired = ref.read(pairedDevicesProvider).matchDeviceId(deviceId);
    final mdnsInstance = paired?.name ?? deviceId;
    if (paired == null) {
      debugPrint(
          '[session] WARN: no PairedDevice match for "$deviceId"; '
          'mdns resolve will try raw id as instance name');
    }

    final attempts = <String>[];

    // 1) TCP cache fast-path — connect 3 s ile ölü IP hızlı düşer; bağlantı
    //    kurulamazsa cache temizlenir ki sonraki cold-start ölü endpoint'e
    //    takılmasın. Auth aşaması hatası cache'i SİLMEZ (endpoint canlı).
    if (paired != null && paired.lastIp != null) {
      final port = paired.lastPort ?? 8080;
      final s = await _attemptTcp(
        deviceId,
        paired.lastIp!,
        port,
        token,
        attempts,
        timeout: tcpCacheTimeout,
        connectTimeout: tcpCacheConnectTimeout,
        clearCacheOnFail: true,
      );
      if (s != null) return s;
    } else {
      attempts.add("TCP cache: atlandı (paired record'da lastIp henüz yok)");
    }

    // 2) mDNS fresh-resolve → TCP with full 8 s timeout.
    MdnsDeviceEndpoint? ep;
    try {
      ep = await _resolveMdns(mdnsInstance, mdnsResolveTimeout);
    } catch (e) {
      attempts.add('mDNS resolve($mdnsInstance): $e');
    }
    if (ep == null) {
      attempts.add('mDNS resolve($mdnsInstance): cevap yok');
    } else {
      final s = await _attemptTcp(deviceId, ep.host, ep.port, token, attempts,
          identityAuthoritative: true);
      if (s != null) return s;
    }

    // 2b) OS-resolver `.local` fast-path. Windows 10+ and macOS resolve
    //     `<instance>.local` through the *system* mDNS responder (the
    //     Windows DNS Client / Bonjour), which carries its own firewall
    //     exception — far more reliable than our in-process multicast_dns
    //     socket, which the Windows firewall routinely blocks. That block is
    //     the usual reason a WiFi device pings fine yet the app can't resolve
    //     it and drops onto a (desktop-flaky) BLE fallback. Socket.connect
    //     does the hostname→A/AAAA lookup via the OS; no extra dependency.
    //     On success `_attemptTcp` caches the `.local` name as lastIp, so the
    //     next connect rides the TCP fast-path.
    {
      final port = paired?.lastPort ?? ep?.port ?? 8080;
      final s = await _attemptTcp(
          deviceId, '$mdnsInstance.local', port, token, attempts,
          identityAuthoritative: true);
      if (s != null) return s;
    }

    // 3) BLE fallback — last resort; beginBleExclusive / endBleExclusive in
    //    paired_ble_scanner.dart are called by the scanner before this path
    //    to prevent concurrent BLE operations on Android.
    try {
      return await _openBle(deviceId, token);
    } catch (e) {
      // Tipli "bond çürümüş" sinyalleri DeviceUnreachable içine gömülmemeli:
      // pairing_screen bunlara bakıp bond'u temizleyip bootstrap'a düşüyor.
      // Sarmalanınca sınıflandırıcı transient sanıyor ve kullanıcı sonsuz
      // "Tekrar dene" döngüsüne sıkışıyordu (ör. cihaz başka bir telefonla
      // yeniden eşleşmişse: cihaz pairing.required DEĞİL, auth.challenge
      // gönderir ve doğrulama başarısız olur).
      if (e is PairingRequiredException || e is AuthRejectedException) rethrow;
      attempts.add('BLE fallback: $e');
      throw DeviceUnreachableException(List.unmodifiable(attempts));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers

  Future<MdnsDeviceEndpoint?> _resolveMdns(String instance, Duration timeout) {
    if (mdnsResolver != null) return mdnsResolver!(instance, timeout: timeout);
    return MdnsDiscovery.resolveInstance(instance, timeout: timeout);
  }

  CliClient _makeTcpClient(String host, int port, List<int> token,
      {Duration? connectTimeout}) {
    if (tcpClientFactory != null) return tcpClientFactory!(host, port, token);
    return CliClient(
      TcpCliTransport(
        host: host,
        port: port,
        token: token,
        connectTimeout: connectTimeout ?? const Duration(seconds: 5),
      ),
      signer: CliSigner(token),
    );
  }

  CliClient _makeBleClient(String deviceId, List<int> token) {
    if (bleClientFactory != null) return bleClientFactory!(deviceId, token);
    final ble = ref.read(bleServiceProvider);
    final btDevice = ble.deviceFor(deviceId);
    return CliClient(
      BleCliTransport(device: btDevice, token: token),
      signer: CliSigner(token),
    );
  }

  Future<DeviceSession?> _attemptTcp(
    String deviceId,
    String host,
    int port,
    List<int> token,
    List<String> attempts, {
    Duration timeout = tcpFreshTimeout,
    Duration? connectTimeout,
    bool clearCacheOnFail = false,
    bool identityAuthoritative = false,
  }) async {
    final client = _makeTcpClient(host, port, token,
        connectTimeout: connectTimeout);

    try {
      await client.start().timeout(timeout);
    } catch (e) {
      debugPrint('[session] TCP open failed ($host:$port): $e');
      attempts.add('TCP $host:$port: $e');
      try {
        await client.stop();
      } catch (e2) {
        debugPrint('[session] TCP cleanup stop failed (best-effort): $e2');
      }
      // Ad-hedefli denemede (mDNS çözümü / `<ad>.local`) karşı taraf KESİN
      // bizim cihazımız: auth reddi "bond çürümüş" demektir; zincire devam
      // edip DeviceUnreachable'a gömmek onarım CTA'sını gizliyordu. Cache
      // IP adımı bilinçli olarak hariç — DHCP sonrası o IP'de BAŞKA bir
      // SmartKraft cihazı oturuyor olabilir.
      if (identityAuthoritative && e is AuthRejectedException) {
        rethrow;
      }
      // Cache'i YALNIZ "bu uçta SKAPP cihazı yok" anlamına gelen hatalarda
      // temizle: SocketException = connect reddi/ulaşılamaz,
      // TimeoutException = dış tavan, TransportClosedException = uç el
      // sıkışma bitmeden kapattı (yeni DHCP kirası sonrası o IP'de başka
      // bir servis olması tipik durumu). Auth aşaması hatası
      // (AuthRejectedException) endpoint'in CANLI ve SKAPP olduğunu
      // kanıtlar — iyi cache'i silmek her cold-start'ı yavaşlatır.
      if (clearCacheOnFail &&
          (e is SocketException ||
              e is TimeoutException ||
              e is TransportClosedException)) {
        try {
          await ref
              .read(pairedDevicesProvider.notifier)
              .clearLastEndpoint(deviceId);
        } catch (e2) {
          // Ölü IP diskte kalırsa her cold-start cache bütçesini boşa
          // yakar — en azından görünür olsun.
          debugPrint('[session] clearLastEndpoint($deviceId) failed: $e2');
        }
      }
      return null;
    }

    try {
      await ref.read(pairedDevicesProvider.notifier).touch(
            deviceId,
            lastIp: host,
            lastPort: port,
          );
    } catch (e) {
      debugPrint('[session] touch($deviceId) failed (best-effort): $e');
    }

    final session = DeviceSession(
      deviceId: deviceId,
      client: client,
      transportKind: CliTransportKind.tcp,
    );
    _wireSessionLifetime(client, session);
    _pushDeviceClock(client, deviceId);
    return session;
  }

  Future<DeviceSession> _openBle(String deviceId, List<int> token) async {
    final client = _makeBleClient(deviceId, token);

    try {
      await client.start().timeout(bleTimeout);
    } catch (e) {
      try {
        await client.stop();
      } catch (e2) {
        debugPrint('[session] BLE cleanup stop failed (best-effort): $e2');
      }
      rethrow;
    }

    try {
      await ref.read(pairedDevicesProvider.notifier).touch(deviceId);
    } catch (e) {
      debugPrint('[session] touch($deviceId) failed (best-effort): $e');
    }

    final session = DeviceSession(
      deviceId: deviceId,
      client: client,
      transportKind: CliTransportKind.ble,
    );
    _wireSessionLifetime(client, session);
    _pushDeviceClock(client, deviceId);
    return session;
  }

  /// Two-way Riverpod ↔ CliClient lifetime wiring.
  ///
  ///   1. Provider teardown (invalidate / app shutdown) → session.dispose()
  ///      → transport close.
  ///   2. Transport drop (device reboot, AP roam) → provider invalidates
  ///      itself so the next read opens a fresh session automatically.
  ///
  /// Called from both TCP and BLE success paths. The BLE exclusive lock
  /// (beginBleExclusive / endBleExclusive in paired_ble_scanner.dart) is
  /// managed by the scanner layer before this method is reached.
  /// Oturum kurulur kurulmaz cihaz saatini ayarla — GÜVENLİK gereği.
  ///
  /// Firmware'in imzalı-mesaj tekrar-oynatma (replay) savunmasının zaman
  /// penceresi YALNIZCA cihaz saati kurulmuşsa devrededir
  /// (`sk_auth_verify_message`: `if (wall > SK_AUTH_CLOCK_SET_EPOCH)`).
  /// ESP32'de saat her reboot/güç kesintisinde sıfırlanır ve SKAPP `time.set`
  /// komutunu yalnızca WiFi kurulum sihirbazında gönderiyordu — yani normal
  /// yeniden bağlanmalarda cihaz ~1970'te kalıyor, zaman penceresi hiç
  /// çalışmıyor ve savunma tek başına 64 kayıtlık nonce halkasına iniyor.
  /// Yakalanan imzalı bir zarf, nonce'u halkadan düştükten sonra (yoğun bir
  /// senkronda 64 komut = birkaç saniye) yeniden oynatılabiliyordu.
  ///
  /// Fire-and-forget: bağlantı gecikmesini artırmaz, başarısızlığı loglanır
  /// (eski firmware `time.set` bilmiyorsa akış bozulmasın).
  void _pushDeviceClock(CliClient client, String deviceId) {
    final unix = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    unawaited(client
        .send('time.set',
            args: {'unix': '$unix'}, timeout: const Duration(seconds: 5))
        .then((r) {
      if (!r.ok) {
        debugPrint('[session] time.set rejected by $deviceId: ${r.err} — '
            'firmware replay window stays inactive');
      }
    }).catchError((Object e) {
      debugPrint('[session] time.set failed for $deviceId: $e');
    }, test: (_) => true));
  }

  void _wireSessionLifetime(CliClient client, DeviceSession session) {
    ref.onDispose(session.dispose);
    client.whenClosed.then((_) {
      final r = client.closedReason;
      if (r != null) debugPrint('[session] transport closed: $r');
      // Wrap in microtask: whenClosed can fire during the current provider
      // build dispatch (e.g. transport closes immediately after connect);
      // deferring to a microtask avoids Riverpod re-entrancy and the
      // parallel-session race that caused BLE reconnect notify loss.
      Future.microtask(() {
        try {
          ref.invalidateSelf();
        } catch (e) {
          // Oturum yeniden AÇILMAYACAK — sessiz kalırsa "neden hep offline"
          // sorusunun cevabı kaybolur.
          debugPrint('[session] invalidateSelf after close failed: $e');
        }
      });
    });
  }
}
