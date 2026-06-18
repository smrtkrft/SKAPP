// BF Cihaz günlükleri. Ortak DeviceLogsScreen'ı BfSession ile bağlar.
// Yapılandırılmış event log formatını (esp32/COMMON_LOG_SPEC.md) tüketir.

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/device_logs_screen.dart';
import 'bf_session.dart';

class BfLogsScreen extends StatelessWidget {
  const BfLogsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DeviceLogsScreen(
      client: BfSession.of(context).client,
      deviceId: deviceId,
      title: l.bfLogsTitle,
    );
  }
}
