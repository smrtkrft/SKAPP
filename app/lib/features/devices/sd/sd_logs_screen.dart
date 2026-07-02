// SD Cihaz günlükleri. Ortak DeviceLogsScreen'ı SdSession ile bağlar
// (bf_logs_screen deseni).

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/device_logs_screen.dart';
import 'sd_session.dart';

class SdLogsScreen extends StatelessWidget {
  const SdLogsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DeviceLogsScreen(
      client: SdSession.of(context).client,
      deviceId: deviceId,
      title: l.bfLogsTitle,
    );
  }
}
