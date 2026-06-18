// Riverpod wiring for the CLI client, event stream and device-specific
// providers.
//
// Transport selection (deviceSessionProvider):
//   1. mDNS sweep `_skapp._tcp.local` for the device's identity. Bounded
//      (~2 s), if the LAN path isn't available we don't want to delay
//      every session.
//   2. If mDNS resolved a host:port → try TcpCliTransport with a full
//      authenticated handshake. On ANY failure (socket connect, auth,
//      timeout) the partial session is closed and we fall through to BLE.
//   3. BLE, open BleCliTransport. If THIS fails too, the error
//      propagates to the caller (UI surfaces the underlying message).
//
// Both transports run the same sk_secure_session handshake and accept
// HMAC envelopes (CliSigner) for command traffic, so downstream code
// (BF home tabs, WiFi setup, ...) is transport-agnostic once the
// session resolves.

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/ble_service.dart';
import '../storage/paired_devices_store.dart';
import 'ble_transport.dart';
import 'bond_store.dart';
import 'cli_client.dart';
import 'cli_signer.dart';
import 'cli_transport.dart';
import 'mdns_discovery.dart';
import 'secure_store_client.dart';
import 'tcp_transport.dart';

class DeviceSession {
  DeviceSession({
    required this.deviceId,
    required this.client,
    required this.transportKind,
  });
  final String deviceId;
  final CliClient client;
  final CliTransportKind transportKind;

  Future<void> dispose() => client.stop();
}

/// Hiçbir transport (TCP cache / mDNS / BLE) cihaza ulaşamadı. Her denemenin
/// teknik açıklaması [attempts] içinde tutulur; UI bunları katlanır bir
/// "teknik ayrıntı" panelinde gösterir, başlıkta ise kullanıcı-dostu bir
/// mesaj kalır. Eski sürüm bunu `StateError('Cihaza bağlanılamadı.\n\n...')`
/// olarak fırlatıyordu; `toString()` "Bad state: " önekini ekleyip ham
/// attempt log'unu doğrudan ekrana döküyordu.
class DeviceUnreachableException implements Exception {
  const DeviceUnreachableException(this.attempts);

  /// Sırasıyla denenen yolların açıklamaları (TCP host:port, mDNS, BLE).
  final List<String> attempts;

  @override
  String toString() =>
      'DeviceUnreachableException(${attempts.length} attempt)';
}

/// Cihaz için saklı bir bond yok: eşleşme akışı hiç tamamlanmamış ya da
/// cihaz/uygulama tarafında temizlenmiş. Reconnect denenemez; kullanıcı
/// yeniden eşleştirmeli. Eski sürüm bunu `StateError('No bond stored...')`
/// olarak fırlatıyordu.
class BondMissingException implements Exception {
  const BondMissingException(this.deviceId);
  final String deviceId;

  @override
  String toString() => 'BondMissingException($deviceId)';
}

class CurrentDeviceIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? id) => state = id;
}

final currentDeviceIdProvider =
    NotifierProvider<CurrentDeviceIdNotifier, String?>(
        CurrentDeviceIdNotifier.new);

/// One CliClient per deviceId.
///
/// Akış: TCP cache → mDNS resolve → TCP → BLE fallback. Her adımın
/// hatası `attempts` listesine yazılır; hepsi başarısız olursa son
/// hata mesajı birleşik olarak fırlatılır, kullanıcı _Error
/// widget'ında hangi adımın neden fail ettiğini tek bakışta görver.
///
/// **autoDispose YOK**, kullanıcı isteği: bağlantı bir kez kurulduktan
/// sonra navigation arasında kalsın, her sub-screen ziyaretinde yeniden
/// handshake/HMAC/auth başlamasın. Eski autoDispose davranışı her tap'ta
/// session.dispose → re-open yaratıyor; pratikte kullanıcı her ekran
/// geçişinde 0.5–8 sn bağlantı bekliyor. Persistent tarafı, transport
/// gerçekten ölünce (cihaz reboot, ağ kopması) [_wireSessionLifetime]
/// içindeki `whenClosed → invalidateSelf` zinciriyle otomatik yenileniyor.
/// Kullanıcı cihazı eşleşmeden kaldırırsa `pairedDevicesProvider.remove`
/// + `ref.invalidate(deviceSessionProvider(id))` ile manuel kapanır.
final deviceSessionProvider =
    FutureProvider.family<DeviceSession, String>(
  (ref, deviceId) async {
    final bondStore = ref.read(bondStoreProvider);
    final token = await bondStore.tokenFor(deviceId);
    if (token == null) {
      throw BondMissingException(deviceId);
    }

    // ID canonicalization yarı yapıldı: BondStore alias üzerinden hem
    // BLE MAC hem SmartKraft id altında token saklanırken (bond_store.dart
    // save(aliasIds:[name])), PairedDevicesStore SADECE pairing anında
    // gelen `widget.device.id` ile upsert ediliyor. Legacy bond'larda veya
    // mDNS-only keşif üzerinden açılan eşleşmelerde MAC ile MAC eşleşmez,
    // SmartKraft id ile MAC eşleşmez; lookup `null` döner ve mdnsInstance
    // ham MAC olarak kalır ("98:A3:...local"). mDNS publisher SmartKraft
    // id ile advertise ettiği için resolve hep cevapsız, fallback BLE'ye
    // düşer. Bu yarış canonical refactor (Faz 4) bitene kadar burada
    // esnek lookup ile kapatılıyor: exact id, case-insensitive id ve
    // name eşleşmesini sırayla dene.
    final paired = ref.read(pairedDevicesProvider).matchDeviceId(deviceId);
    final mdnsInstance = paired?.name ?? deviceId;
    if (paired == null) {
      debugPrint(
          '[session] WARN: no PairedDevice match for "$deviceId"; '
          'mdns resolve will try raw id as instance name');
    }

    final attempts = <String>[];

    // 1) Cache fast-path. Tighter timeout than the fresh attempt: if
    //    the cached IP is stale (router reassigned), we want to fail
    //    fast and let mDNS find the new endpoint, not spend 8s waiting
    //    for a TCP SYN that's never going to be ACKed. On failure we
    //    also drop the cache itself, so the next cold-start skips the
    //    dead endpoint instead of waiting for the next mDNS sweep.
    if (paired != null && paired.lastIp != null) {
      final port = paired.lastPort ?? 8080;
      final s = await _attemptTcp(
        ref,
        deviceId,
        paired.lastIp!,
        port,
        token,
        attempts,
        timeout: const Duration(seconds: 3),
        clearCacheOnFail: true,
      );
      if (s != null) return s;
    } else {
      attempts.add(
          'TCP cache: atlandı (paired record\'da lastIp henüz yok)');
    }

    // 2) mDNS resolveInstance ile taze IP. 1.5sn timeout, mdnsBrowser
    //    paralel sweep yapıyor, daha uzun bir timeout iki sorgu
    //    arasında çakışma şansını artırıyor.
    MdnsDeviceEndpoint? ep;
    try {
      ep = await MdnsDiscovery.resolveInstance(
        mdnsInstance,
        timeout: const Duration(milliseconds: 1500),
      );
    } catch (e) {
      attempts.add('mDNS resolve($mdnsInstance): $e');
    }
    if (ep == null) {
      attempts.add('mDNS resolve($mdnsInstance): cevap yok');
    } else {
      final s = await _attemptTcp(
          ref, deviceId, ep.host, ep.port, token, attempts);
      if (s != null) return s;
    }

    // 3) BLE fallback
    try {
      return await _openBle(ref, deviceId, token);
    } catch (e) {
      // PairingRequiredException: cihaz pairing modunda olduğunu hint
      // event'iyle bildirdi (bond yok, kendisi de NORMAL'da değil). Diğer
      // transport attempt'leri zaten bond'a dayalı, çalışmayacak; bu
      // exception'ı StateError'e gömmek pairing_screen'in hard-rejection
      // tanısını bozar. Fail-fast olarak doğrudan caller'a ilet, o
      // PairingRequired'ı yakalayıp dialog'unu açar.
      if (e is PairingRequiredException) rethrow;
      attempts.add('BLE fallback: $e');
      throw DeviceUnreachableException(List.unmodifiable(attempts));
    }
  },
);

/// Sade TCP attempt: socket + auth handshake, configurable timeout.
/// Başarısız olursa attempts listesine hatayı yazıp null döner;
/// başarılıysa cache'i tazeler ve session döner.
///
/// [timeout] cache fast-path için 3s, mDNS fresh-path için varsayılan 8s.
/// [clearCacheOnFail] cache attempt fail ederse PairedDevice.lastIp/Port'u
/// nullify et, bir sonraki cold-start dead endpoint'i atlar.
Future<DeviceSession?> _attemptTcp(
  Ref ref,
  String deviceId,
  String host,
  int port,
  List<int> token,
  List<String> attempts, {
  Duration timeout = const Duration(seconds: 8),
  bool clearCacheOnFail = false,
}) async {
  final transport = TcpCliTransport(host: host, port: port, token: token);
  final signer = CliSigner(token);
  final client = CliClient(transport, signer: signer);

  try {
    await client.start().timeout(timeout);
  } catch (e) {
    debugPrint('[session] TCP open failed ($host:$port): $e');
    attempts.add('TCP $host:$port: $e');
    try {
      await client.stop();
    } catch (_) {/* already torn down */}
    if (clearCacheOnFail) {
      try {
        await ref
            .read(pairedDevicesProvider.notifier)
            .clearLastEndpoint(deviceId);
      } catch (_) {/* silent */}
    }
    return null;
  }

  try {
    await ref.read(pairedDevicesProvider.notifier).touch(
          deviceId,
          lastIp: host,
          lastPort: port,
        );
  } catch (_) {/* silent */}

  final session = DeviceSession(
    deviceId: deviceId,
    client: client,
    transportKind: CliTransportKind.tcp,
  );
  _wireSessionLifetime(ref, client, session);
  return session;
}

/// BLE fallback. Hata yukarı propagate eder, son çare. Handshake için
/// 15sn timeout; aksi halde adapter cevap vermediğinde provider
/// sonsuza kadar AsyncLoading'de takılı kalır.
Future<DeviceSession> _openBle(
  Ref ref,
  String deviceId,
  List<int> token,
) async {
  final ble = ref.read(bleServiceProvider);
  final btDevice = ble.deviceFor(deviceId);
  final transport = BleCliTransport(device: btDevice, token: token);
  final signer = CliSigner(token);
  final client = CliClient(transport, signer: signer);

  try {
    await client.start().timeout(const Duration(seconds: 15));
  } catch (e) {
    try {
      await client.stop();
    } catch (_) {/* swallow */}
    rethrow;
  }

  try {
    await ref.read(pairedDevicesProvider.notifier).touch(deviceId);
  } catch (_) {/* silent */}

  final session = DeviceSession(
    deviceId: deviceId,
    client: client,
    transportKind: CliTransportKind.ble,
  );
  _wireSessionLifetime(ref, client, session);
  return session;
}

/// Two-way wiring between Riverpod and the live [CliClient]:
///
///   1. When the provider tears down (autoDispose, manual invalidate,
///      app shutdown) the session must close its socket / BLE link.
///   2. When the *transport* dies on its own (device reboots, AP drops
///      the socket, BLE link supervision timeout) the provider must
///      invalidate itself so the next read opens a fresh session.
///      Without (2), pending I/O fails fast, but the cached
///      AsyncValue.data still points at a dead client, so subsequent
///      sends on the same session would all hit `transport not connected`.
void _wireSessionLifetime(
  Ref ref,
  CliClient client,
  DeviceSession session,
) {
  ref.onDispose(session.dispose);
  client.whenClosed.then((_) {
    // ref.invalidateSelf is a no-op once the provider is already gone
    // (e.g. the user navigated away and autoDispose already fired);
    // it only takes effect when there's still a listener that wants a
    // live session, exactly the moment we want a clean reconnect.
    //
    // Microtask wrapping: whenClosed bazen current dispatch içinde
    // (örn. provider build sırasında transport hemen kapanırsa)
    // tetiklenebiliyor; invalidateSelf'i microtask'a alarak current
    // dispatch'in dışına çıkarıyoruz, Riverpod re-entrancy ve provider
    // build hâlâ devam ederken invalidate çağrısı sonucu oluşan
    // potansiyel yarışı eliyoruz. Bu yarış BLE reconnect'te paralel
    // session'ların çakışmasına ve handshake notify'larının kaybolmasına
    // yol açıyordu.
    Future.microtask(() {
      try {
        ref.invalidateSelf();
      } catch (_) {/* provider already disposed */}
    });
  });
}

final deviceEventsProvider =
    StreamProvider.family<CliEvent, String>((ref, deviceId) async* {
  final session = await ref.watch(deviceSessionProvider(deviceId).future);
  yield* session.client.events;
});

/// SKAPP-only encrypted store client (`secure.*` + `userdata.*`). Always
/// rides the authenticated CliClient, never falls back to an unsigned
/// transport, since the firmware will reject the calls.
///
/// Lifetime matches [deviceSessionProvider] (now persistent). Both stay
/// alive once a device is opened and only tear down on transport drop /
/// explicit invalidate; this keeps every sub-screen tap instant instead
/// of paying the handshake cost per navigation.
final secureStoreProvider =
    FutureProvider.family<SecureStoreClient, String>(
        (ref, deviceId) async {
  final session = await ref.watch(deviceSessionProvider(deviceId).future);
  return SecureStoreClient(session.client);
});
