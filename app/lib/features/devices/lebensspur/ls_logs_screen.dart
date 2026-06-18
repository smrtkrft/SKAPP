// LebensSpur Cihaz günlükleri. Ortak DeviceLogsScreen'ı LS'in Riverpod
// session provider'ı üzerinden bağlar. Yapılandırılmış event log formatını
// (esp32/COMMON_LOG_SPEC.md) tüketir.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/device_logs_screen.dart';

class LsLogsScreen extends ConsumerWidget {
  const LsLogsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sessionAsync = ref.watch(deviceSessionProvider(deviceId));

    return sessionAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l.bfLogsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: Text(l.bfLogsTitle)),
        body: Center(child: Text(err.toString())),
      ),
      data: (session) => DeviceLogsScreen(
        client: session.client,
        deviceId: deviceId,
        title: l.bfLogsTitle,
      ),
    );
  }
}
