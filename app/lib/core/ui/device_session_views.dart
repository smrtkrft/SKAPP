// Shared loading + error views for any device session screen.
//
// Önceden her cihaz ekranı (BF home, BF session route gate, LS home) kendi
// `_Loading` / `_Error` ikilisini taşıyordu. Üçü de aynı işi yapıyor ama
// hata durumunda ham `e.toString()` döküyordu: "Bad state: Cihaza
// bağlanılamadı." + arkasına TCP/mDNS/BLE attempt log'u. Retry butonu yoktu,
// kullanıcı geri çıkıp tekrar girmek zorundaydı; `PairingRequiredException`
// ise "PairingRequiredException(reason=no_bond)" olarak sızıyordu.
//
// Bu dosya o üç kopyayı tek yerde toplar:
//   - DeviceSessionLoading: spinner + opsiyonel etiket.
//   - DeviceSessionError: kullanıcı-dostu başlık + katlanır teknik ayrıntı +
//     "Tekrar dene" (deviceSessionProvider invalidate) + eşleşme gerektiğinde
//     "Yeniden eşleştir" CTA.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../cli/ble_transport.dart' show PairingRequiredException;
import '../cli/cli_providers.dart';

/// Cihaz oturumu çözülürken gösterilen spinner.
class DeviceSessionLoading extends StatelessWidget {
  const DeviceSessionLoading({super.key, this.label, this.withScaffold = true});

  /// Spinner altında gösterilecek opsiyonel açıklama ("Bağlanılıyor…" vb.).
  final String? label;

  /// BF home gibi kendi Scaffold'unu isteyen yerler true bırakır; LS gibi
  /// zaten bir Scaffold body'sine gömülecek yerler false geçer.
  final bool withScaffold;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox ile kare boyut: Column içinde sınırsız bırakılırsa
          // CircularProgressIndicator parent genişliğine yayılıp elips görünür.
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(),
          ),
          if (label != null) ...[
            const SizedBox(height: 16),
            Text(label!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
    if (!withScaffold) return content;
    return Scaffold(appBar: AppBar(), body: content);
  }
}

/// Cihaz oturumu hata ile sonuçlandığında gösterilen ekran.
///
/// [error] tipine göre üç farklı mesaj sunar:
///   - [PairingRequiredException] / [BondMissingException] → "Eşleşme
///     yenilenmeli" + (varsa) [onRepair] CTA.
///   - [DeviceUnreachableException] ve diğer her şey → "Cihaza ulaşılamıyor"
///     + her zaman bir "Tekrar dene".
class DeviceSessionError extends ConsumerWidget {
  const DeviceSessionError({
    super.key,
    required this.deviceId,
    required this.error,
    this.onRepair,
    this.withScaffold = true,
  });

  final String deviceId;
  final Object error;

  /// Eşleşme gerektiğinde gösterilecek "Yeniden eşleştir" eylemi. null ise
  /// CTA gizlenir (çağıran ekran yeniden eşleştirme akışına erişemiyorsa).
  final VoidCallback? onRepair;

  final bool withScaffold;

  bool get _needsRepair =>
      error is PairingRequiredException || error is BondMissingException;

  /// Katlanır panelde gösterilecek teknik döküm. Unreachable'da her attempt
  /// satırı; diğer tiplerde ham `toString()`.
  String get _technical {
    final e = error;
    if (e is DeviceUnreachableException) return e.attempts.join('\n');
    return e.toString();
  }

  void _retry(WidgetRef ref) {
    // AsyncError state'inde takılı provider'ı yenile; bir sonraki watch
    // taze bir TCP→mDNS→BLE denemesi başlatır.
    ref.invalidate(deviceSessionProvider(deviceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    final title =
        _needsRepair ? l.deviceConnRepairTitle : l.deviceConnUnreachableTitle;
    final body =
        _needsRepair ? l.deviceConnRepairBody : l.deviceConnUnreachableBody;

    final content = ListView(
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      children: [
        Icon(Icons.error_outline, color: cs.error, size: 40),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Eşleşme gerektiğinde önce "Yeniden eşleştir", her durumda
        // "Tekrar dene". Unreachable'da retry birincil eylem.
        if (_needsRepair && onRepair != null) ...[
          FilledButton.icon(
            onPressed: onRepair,
            icon: const Icon(Icons.link),
            label: Text(l.deviceConnRepairButton),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _retry(ref),
            icon: const Icon(Icons.refresh),
            label: Text(l.commonRetry),
          ),
        ] else
          FilledButton.icon(
            onPressed: () => _retry(ref),
            icon: const Icon(Icons.refresh),
            label: Text(l.commonRetry),
          ),
        const SizedBox(height: 16),
        // Teknik döküm: varsayılan kapalı, meraklı/destek için açılır.
        Theme(
          data: Theme.of(context)
              .copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              l.deviceConnTechnicalDetails,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: [
              SelectableText(
                _technical,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );

    if (!withScaffold) return content;
    return Scaffold(appBar: AppBar(), body: content);
  }
}
