import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/paired_devices_store.dart';
import 'notification_state.dart';

/// mDNS freshness window. Devices not seen for longer than this are
/// rendered as offline on the card. Matches the discovery sweep cadence
/// (browser refreshes every 30s, so 90s = 3 missed sweeps).
const Duration _offlineThreshold = Duration(seconds: 90);

/// Returns the current [NotificationState] for the paired device with
/// [deviceId]. Null device id (not paired) returns [NotificationState.none]
/// so callers can render in a defaulted state without branching.
///
/// MVP scope: only offline detection. Battery and pairing-pending states
/// will land when the firmware exposes telemetry over the runtime CLI
/// channel (BF Faz D2). Until then this provider returns [none] for all
/// healthy devices.
final deviceNotificationStateProvider =
    Provider.family<NotificationState, String>((ref, deviceId) {
  final paired = ref.watch(pairedDevicesProvider);
  PairedDevice? device;
  for (final d in paired) {
    if (d.id == deviceId) {
      device = d;
      break;
    }
  }
  if (device == null) return NotificationState.none;

  // Mobile peer (prefix MS): online/offline tracking şu an mevcut değil.
  // mDNS/BLE keşfi telefon yayınını eşleştirmiyor, server middleware
  // peer auth'unda lastSeen'i refresh etmiyor, mobil heartbeat akışı
  // kurulmadı. Lastseen kontrolü mobil için yanıltıcı olduğundan (pairing
  // sonrası 90 sn boyunca yanlış "online", sonra sonsuza "offline"),
  // gerçek altyapı gelene kadar mobil peer'ları daima "none" döndürüyoruz
  // — bu sayede dot rengi vb. yanıltıcı sinyal üretmez, çağıran taraflar
  // (legend, online count) ise mobil peer'ları açıkça `isMobilePeer`
  // üzerinden ele alır.
  if (device.isMobilePeer) return NotificationState.none;

  // Offline check: if mDNS browser hasn't seen the device within the
  // freshness window, flag it as offline. A null lastSeen means we never
  // saw it post-pairing, also offline.
  final lastSeen = device.lastSeen;
  if (lastSeen == null) return NotificationState.offline;
  final age = DateTime.now().difference(lastSeen);
  if (age > _offlineThreshold) return NotificationState.offline;

  // TODO(faz-D2-firmware): low battery once telemetry stream is wired.
  return NotificationState.none;
});
