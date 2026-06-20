// Session value-types shared between cli_providers.dart and
// transport_selector.dart. Kept separate to avoid a circular import:
//   cli_providers.dart → transport_selector.dart → cli_session.dart ←
//   cli_providers.dart (re-exported, so all 17 callers stay unchanged).

import 'cli_client.dart';
import 'cli_transport.dart';

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
/// mesaj kalır.
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
/// yeniden eşleştirmeli.
class BondMissingException implements Exception {
  const BondMissingException(this.deviceId);
  final String deviceId;

  @override
  String toString() => 'BondMissingException($deviceId)';
}
