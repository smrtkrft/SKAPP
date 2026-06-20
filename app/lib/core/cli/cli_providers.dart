// Riverpod wiring for the CLI client, event stream and device-specific
// providers.
//
// Transport selection is handled by [TransportSelector]
// (transport_selector.dart):
//   1. TCP cache fast-path (3 s) using the last-known host:port.
//   2. mDNS fresh-resolve (1.5 s) → TCP (8 s).
//   3. BLE fallback (15 s).
//
// Both transports run the same sk_secure_session handshake and accept
// HMAC envelopes (CliSigner) for command traffic, so downstream code
// (BF home tabs, WiFi setup, ...) is transport-agnostic once the
// session resolves.
//
// Re-exports [DeviceSession], [DeviceUnreachableException] and
// [BondMissingException] from cli_session.dart so the 17+ call sites
// importing this file continue to find these types here without change.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cli_client.dart';
import 'cli_session.dart';
import 'secure_store_client.dart';
import 'transport_selector.dart';

export 'cli_session.dart';

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
/// widget'ında hangi adımın neden fail ettiğini tek bakışta görür.
///
/// **autoDispose YOK**, kullanıcı isteği: bağlantı bir kez kurulduktan
/// sonra navigation arasında kalsın, her sub-screen ziyaretinde yeniden
/// handshake/HMAC/auth başlamasın. Eski autoDispose davranışı her tap'ta
/// session.dispose → re-open yaratıyor; pratikte kullanıcı her ekran
/// geçişinde 0.5–8 sn bağlantı bekliyor. Persistent tarafı, transport
/// gerçekten ölünce (cihaz reboot, ağ kopması) TransportSelector içindeki
/// `whenClosed → invalidateSelf` zinciriyle otomatik yenileniyor.
/// Kullanıcı cihazı eşleşmeden kaldırırsa `pairedDevicesProvider.remove`
/// + `ref.invalidate(deviceSessionProvider(id))` ile manuel kapanır.
final deviceSessionProvider =
    FutureProvider.family<DeviceSession, String>(
  (ref, deviceId) => TransportSelector(ref: ref).selectAndConnect(deviceId),
);

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
