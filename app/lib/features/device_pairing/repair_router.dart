// Onarım ("Yeniden eşleştir") yönlendiricisi: cihazın HANGİ akışla
// eşleştiğine göre doğru ekranı seçer.
//
// Eskiden üç ev ekranı da (BF/SD/LS) onarımı BLE PairingScreen'e
// yönlendiriyordu. WiFi/mDNS akışıyla eşleşmiş cihazın PairedDevice.id'si
// mDNS instance adıdır (örn. "SD-K2M4X9"); BluetoothDevice.fromId bu
// string'i geçerli bir remoteId saymaz → BLE connect her seferinde düşer
// ve kullanıcı "BLE bağlantısı başarısız" döngüsünde kalırdı. Tek kurtuluş
// cihazı unutup baştan eşleşmekti.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/cli/mdns_discovery.dart';
import '../../core/storage/paired_devices_store.dart';
import 'pairing_screen.dart';
import 'wifi_pairing_screen.dart';

/// Ev ekranlarının "Yeniden eşleştir" CTA'sı için tek giriş noktası.
/// Dönüşte oturumu tazeler (eski davranış korunur).
Future<void> startRepairFlow(
  BuildContext context,
  WidgetRef ref,
  String deviceId,
) async {
  final paired = ref.read(pairedDevicesProvider).matchDeviceId(deviceId) ??
      PairedDevice(
        id: deviceId,
        name: deviceId,
        prefix: '',
        pairedAt: DateTime.now(),
      );

  if (DiscoveredDevice.isSmartKraftIdentity(paired.id)) {
    // WiFi/mDNS ile eşleşmiş cihaz: BLE MAC yok, onarım TCP üstünden.
    // Canlı IP biliniyorsa onu, yoksa OS-resolver'lı `<ad>.local`ı kullan
    // (Windows'ta in-process mDNS engelliyken de çalışan yol, 9691f53).
    final endpoint = MdnsDeviceEndpoint(
      instance: paired.name,
      host: paired.lastIp ?? '${paired.name}.local',
      port: paired.lastPort ?? 8080,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WifiPairingScreen(endpoint: endpoint)),
    );
  } else {
    final device = DiscoveredDevice(
      id: paired.id,
      name: paired.name,
      rssi: 0,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PairingScreen(device: device)),
    );
  }

  if (!context.mounted) return;
  ref.invalidate(deviceSessionProvider(deviceId));
}
