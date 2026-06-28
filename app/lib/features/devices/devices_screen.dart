import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/ble/device_model.dart';
import '../../core/ble/notification_state.dart';
import '../../core/ble/notification_state_provider.dart';
import '../../core/network/mdns_browser.dart';
import '../../core/network/skapp_http_client.dart';
import '../../core/network/skapp_peer_store.dart';
import '../../core/network/skapp_peer_target.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_centered_dialog.dart';
import '../../core/ui/sk_confirm_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../device_discovery/setup_choice_screen.dart';
import '../device_home/device_home_screen.dart';
import '../skapi/data/mobile_event_catalog.dart';
import '../skapi/data/skapi_providers.dart';
import 'widgets/constellation_view.dart';
import 'widgets/devices_legend.dart';
import 'widgets/devices_stats_card.dart';

/// Cihazlarım sekmesi · takımyıldız görünümü (laptop_s2.html C / mobil_d
/// .html bölüm 2). Mevcut liste view burada bırakılmış değil; constellation
/// merkezinde hub (host adı) ve etrafında dağılmış cihaz kartları yer alır.
///
/// Pairing flow değişmedi: header sağ "+ Yeni Cihaz Ekle" pill veya empty
/// state'in mustard CTA'sı doğrudan [SetupChoiceScreen] route'una push
/// eder, BLE/WiFi seçim akışı korunur.
///
/// Veri kaynakları:
///   * `pairedDevicesProvider` — paired list (lastSeen mDNS sweep ile yenilenir)
///   * `deviceNotificationStateProvider` — başına dot rengi + notif satırı
///   * `networkIdentityProvider` — hub (node) adı default "ofis-mac" yerine
///     kullanıcının ayarladığı mDNS instance adı
class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final devices = ref.watch(pairedDevicesProvider);
    // mDNS sweep'i canlı tut: her sweep `lastSeen` günceller, halka
    // animasyonu tek başına yetmeyebilir (uygulama back planda iken
    // değişen değer rebuild tetiklemez), bu provider zorunlu izleyici.
    ref.watch(mdnsBrowserProvider);
    // Mobil sürümde paired Desktop SKAPP'ler. Desktop sürümde bu liste boş
    // kalır (oradaki yön zaten tersine, PairedDevice MS olarak yazılır).
    final desktopPeers = ref.watch(skappPeersProvider);

    final identity = ref.watch(networkIdentityProvider);
    final compact = !context.isDesktop;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0E0D0A)
          : const Color(0xFFFBF8EE),
      body: SafeArea(
        // Tüm sekmeler ile aynı alt boşluk: nav pill üstüne 18 px gap.
        // SafeArea zaten nav inset'i consume etti, ek 18 px Padding bu boşluğu
        // bütün constellation Stack'ine uygulayarak nav pill ile temas önler.
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            children: [
              _Header(
                compact: compact,
                // Header sayacı: SK cihazları (BF, LS, ...) + mobil sürümde
                // paired desktop peer'lar. Mobil peer'lar (prefix MS)
                // online/offline takibi yok diye ayrı kategoride, sayıma
                // sokulmaz; sağ alttaki stats card'da ayrı görünür.
                total: _skDeviceCount(devices) + desktopPeers.length,
                online: _onlineCount(devices) +
                    _onlineDesktopPeerCount(desktopPeers),
                onAdd: () => _pushAdd(context),
              ),
              Expanded(
                child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Constellation merkez
                  Positioned.fill(
                    child: ConstellationView(
                      devices: devices,
                      desktopPeers: desktopPeers,
                      hubLabel: _hubLabel(l, identity.name),
                      onDeviceTap: (d) => _onDeviceTap(context, d),
                      onDeviceLongPress: (d) =>
                          _onDeviceLongPress(context, ref, d),
                      onDesktopPeerTap: (peer) =>
                          _onDesktopPeerTap(context, ref, peer),
                      onDesktopPeerLongPress: (peer) =>
                          _onDesktopPeerLongPress(context, ref, peer),
                      onAddTap: () => _pushAdd(context),
                      compact: compact,
                    ),
                  ),

                  // Empty state hint chip (sol-alt) veya legend
                  if (devices.isEmpty && desktopPeers.isEmpty)
                    Positioned(
                      left: 14,
                      bottom: compact ? 16 : 24,
                      child: _HintChip(text: l.devicesEmptyHintChip),
                    )
                  else ...[
                    Positioned(
                      left: 14,
                      bottom: compact ? 16 : 24,
                      child: _DevicesLegendFromDevices(
                        devices: devices,
                        desktopPeers: desktopPeers,
                      ),
                    ),
                    Positioned(
                      right: 14,
                      bottom: compact ? 16 : 24,
                      child: _DevicesStatsFromDevices(
                        devices: devices,
                        desktopPeers: desktopPeers,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  String _hubLabel(AppLocalizations l, String identityName) {
    // Network identity name is e.g. "cem-laptop-skapp" — kısalt ve
    // baş harfini büyük yap. mDNS instance boş kalmasın diye fallback
    // var, bu durumda "Bilinmeyen" göster.
    if (identityName.isEmpty) return l.devicesEmptyHubLabel;
    final stripped = identityName
        .replaceAll(RegExp(r'-skapp$'), '')
        .replaceAll('-', ' ')
        .trim();
    if (stripped.isEmpty) return l.devicesEmptyHubLabel;
    return stripped
        .split(' ')
        .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}')
        .join(' ');
  }

  /// SK cihaz (BF, LS, ...) sayısı. Mobil peer'lar (prefix MS) hariç;
  /// onlar telefon olarak ayrı kategori sayılır.
  int _skDeviceCount(List<PairedDevice> list) {
    int c = 0;
    for (final d in list) {
      if (!d.isMobilePeer) c++;
    }
    return c;
  }

  /// Çevrim içi (SK) cihaz sayısı. Mobil peer'lar hariç — telefon için
  /// gerçek online tespit altyapısı yok; lastSeen sadece pairing anında
  /// set ediliyor, sonra hiç refresh edilmiyor, bu yüzden online sayımına
  /// dahil edilmezler.
  int _onlineCount(List<PairedDevice> list) {
    int c = 0;
    for (final d in list) {
      if (d.isMobilePeer) continue;
      final ls = d.lastSeen;
      if (ls != null &&
          DateTime.now().difference(ls) < const Duration(seconds: 90)) {
        c++;
      }
    }
    return c;
  }

  /// Çevrim içi paired desktop SKAPP sayısı (mobil sürümde).
  /// skapp_peer_health_prober her 30sn /api/health ile lastSeen taze tutar;
  /// 90sn pencereyle gerçek online sinyali (sahte değil).
  int _onlineDesktopPeerCount(List<SkappPeerTarget> peers) {
    int c = 0;
    for (final p in peers) {
      if (p.online) c++;
    }
    return c;
  }

  void _pushAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SetupChoiceScreen()),
    );
  }

  /// Dispatch: SK cihazları kendi detay sayfasına push'lar; mobil peer'lar
  /// detay sayfası açmaz, yalnız ipucu SnackBar gösterir (telefon SKAPP'te
  /// event source'tur, kendi başına bir route'u yoktur).
  ///
  /// Offline SK cihazı: BLE/TCP connect denemesi `_Error` ekranı kusarken
  /// kullaniciya degerli bilgi vermiyor; bunun yerine alt SnackBar ile
  /// "cihaz çevrimdışı" gösterip kullaniciyi route'a sokmuyoruz. Online
  /// kriteri header sayacindaki ile bire bir ayni: lastSeen <= 90 sn.
  void _onDeviceTap(BuildContext context, PairedDevice paired) {
    final l = AppLocalizations.of(context);
    if (paired.isMobilePeer) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.devicesMobileNoDetailHint, textAlign: TextAlign.center),
          duration: const Duration(seconds: 2),
        ));
      return;
    }
    final ls = paired.lastSeen;
    final offline = ls == null ||
        DateTime.now().difference(ls) >= const Duration(seconds: 90);
    if (offline) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            l.devicesOfflineTapHint(paired.displayNameFull),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ));
      return;
    }
    _openDevice(context, paired);
  }

  /// Dispatch: mobil peer için uzun bas, ara "Yönet / Sil" sheet'ini
  /// atlayıp doğrudan eşleşmeyi kaldırma onayına gider; SK cihazları için
  /// klasik sheet açılır (Yönet seçeneği gelecekte buraya eklenir).
  Future<void> _onDeviceLongPress(
    BuildContext context,
    WidgetRef ref,
    PairedDevice paired,
  ) async {
    if (paired.isMobilePeer) {
      await _confirmForget(context, ref, paired);
      return;
    }
    await _showDeviceActions(context, ref, paired);
  }

  /// Mobil sürümde paired desktop kartına tıklama: "SKAPI komutu
  /// gönderilsin mi?" onay dialogu açar, onaylanırsa emitEvent ile o
  /// desktop'a `skapp.mobile.tap` event'i gönderilir, desktop tarafı bu
  /// event'e bağlı binding'leri çalıştırır.
  Future<void> _onDesktopPeerTap(
    BuildContext context,
    WidgetRef ref,
    SkappPeerTarget peer,
  ) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showSkConfirm(
      context,
      title: l.devicesDesktopTriggerDialogTitle,
      message: l.devicesDesktopTriggerDialogBody(peer.name),
      cancelLabel: l.devicesDesktopTriggerDialogCancel,
      confirmLabel: l.devicesDesktopTriggerDialogConfirm,
    );
    if (!confirmed) return;
    if (!context.mounted) return;
    try {
      final client = ref.read(skappHttpClientProvider);
      await client.emitEvent(
        peer: peer,
        eventName: kDefaultMobileEvent,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            l.mobileTriggerSentToast(peer.name),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ));
    } on SkappPeerOfflineException {
      _showDesktopErr(context, l.skapiRunRemoteOfflineError);
    } on SkappPeerUnauthorizedException {
      _showDesktopErr(context, l.skapiRunRemoteUnauthorizedError);
    } on SkappPeerHttpException catch (e) {
      final isDevModeOff =
          e.statusCode == 403 && e.body.contains('pro_mode_disabled');
      _showDesktopErr(
        context,
        isDevModeOff
            ? l.skapiRunRemoteDeveloperModeDisabled
            : l.skapiRunRemoteHttpError(e.toString()),
      );
    } catch (e) {
      _showDesktopErr(context, l.skapiRunRemoteHttpError(e.toString()));
    }
  }

  /// Mobil sürümde paired desktop kartına uzun basma: eşleşmeyi kaldırma
  /// onay dialogu, onaylanırsa skappPeersProvider'dan silinir.
  Future<void> _onDesktopPeerLongPress(
    BuildContext context,
    WidgetRef ref,
    SkappPeerTarget peer,
  ) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showSkConfirm(
      context,
      title: l.devicesDesktopForgetDialogTitle,
      message: l.devicesDesktopForgetDialogBody(peer.name),
      cancelLabel: l.devicesForgetDialogCancel,
      confirmLabel: l.devicesForgetDialogConfirm,
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(skappPeersProvider.notifier).remove(peer.uuid);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          l.devicesDesktopForgotToast(peer.name),
          textAlign: TextAlign.center,
        ),
      ));
  }

  void _showDesktopErr(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        duration: const Duration(seconds: 3),
      ));
  }

  void _openDevice(BuildContext context, PairedDevice paired) {
    final dd = DiscoveredDevice(
      id: paired.id,
      name: paired.name,
      rssi: 0,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DeviceHomeScreen(device: dd)),
    );
  }

  /// Long-press menu on a constellation card. Faz B kararı: SKAPP'tan
  /// silmek için cihazın canlı olması gerekmez (PairedDevicesStore tamamen
  /// yerel SharedPreferences). Bu yüzden offline BF'ler de buradan
  /// kaldırılabilir; cihazın kendi BLE bond'u sıfırlanmaz, kullanıcı onu
  /// cihaz üzerinden ayrıca temizler.
  Future<void> _showDeviceActions(
    BuildContext context,
    WidgetRef ref,
    PairedDevice paired,
  ) async {
    final l = AppLocalizations.of(context);
    final action = await showDialog<_DeviceAction>(
      context: context,
      builder: (sheetCtx) {
        final tt = Theme.of(sheetCtx).textTheme;
        return SkCenteredDialog(
          title: l.devicesActionsSheetTitle(paired.displayName),
          icon: Icons.devices_rounded,
          subtitle: paired.name,
          maxWidth: 460,
          maxHeight: 320,
          bodyPadding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.link_off_rounded, color: SkColors.warnRed),
                title: Text(
                  l.devicesActionForget,
                  style: tt.titleSmall?.copyWith(
                    color: SkColors.warnRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(l.devicesActionForgetSubtitle),
                onTap: () => Navigator.of(sheetCtx).pop(_DeviceAction.forget),
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: Text(l.devicesActionCancel),
                onTap: () => Navigator.of(sheetCtx).pop(_DeviceAction.cancel),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted) return;
    if (action == _DeviceAction.forget) {
      await _confirmForget(context, ref, paired);
    }
  }

  Future<void> _confirmForget(
    BuildContext context,
    WidgetRef ref,
    PairedDevice paired,
  ) async {
    final l = AppLocalizations.of(context);
    // Bu cihaza bagli aksiyon sayisini dialog gövdesinde göster.
    // bindingsProvider doğrudan tüm liste; bindingsForDeviceProvider
    // enabled olanlari da filtreliyor, biz disabled dahil hepsini
    // saymak istiyoruz cunku cascade hepsini siler.
    final variants = <String>{
      paired.id,
      paired.id.toUpperCase(),
      paired.id.toLowerCase(),
    };
    final boundActionCount = ref
        .read(bindingsProvider)
        .where((b) => variants.contains(b.deviceId))
        .length;
    final confirmed = await showSkConfirm(
      context,
      title: l.devicesForgetDialogTitle(paired.displayName),
      message: boundActionCount > 0
          ? l.devicesForgetDialogBodyWithActions(boundActionCount)
          : l.devicesForgetDialogBody,
      cancelLabel: l.devicesForgetDialogCancel,
      confirmLabel: l.devicesForgetDialogConfirm,
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(pairedDevicesProvider.notifier).remove(paired.id);
    // Cascade: bu cihaza bagli tum SKAPI binding'lerini de sil. UI
    // soylestiren mevcut: orphan binding'ler kalmasin (kullanici karari
    // 2026-05-13). Re-pair durumunda bindings geri gelmez; kullanici
    // gerekirse yeniden olusturur.
    await ref
        .read(bindingsProvider.notifier)
        .removeForDevice(paired.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.devicesForgotToast(paired.displayName), textAlign: TextAlign.center),
      ));
  }
}

enum _DeviceAction { forget, cancel }

class _Header extends StatelessWidget {
  const _Header({
    required this.compact,
    required this.total,
    required this.online,
    required this.onAdd,
  });

  final bool compact;
  final int total;
  final int online;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0E0D0A)
            : const Color(0xFFFBF8EE),
        border: Border(
          bottom: BorderSide(
            color: fg.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.devicesTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: compact ? 17 : 19,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 2),
                  Text(
                    l.devicesHeaderSub(total, online),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: fg.withValues(alpha: 0.55),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _AddPillButton(
            label: l.devicesAddPillLabel,
            onTap: onAdd,
            iconOnly: compact,
          ),
        ],
      ),
    );
  }
}

class _AddPillButton extends StatelessWidget {
  const _AddPillButton({
    required this.label,
    required this.onTap,
    this.iconOnly = false,
  });
  final String label;
  final VoidCallback onTap;
  /// Compact ekranda (mobile) sadece + ikonu görünür, label gizli; aksi
  /// halde label + ikonu birlikte gösterilir.
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Dark'ta inversion: koyu zemine siyah CTA çakışacağı için krem
    // zemin + siyah ikon/yazı; light'ta klasik siyah CTA + krem yazı.
    final bg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final fg = isDark ? SkColors.black : SkColors.cream;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: iconOnly
              ? const EdgeInsets.all(10)
              : const EdgeInsets.fromLTRB(12, 9, 14, 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: fg),
              if (!iconOnly) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.55),
        border: Border.all(
          color: fg.withValues(alpha: 0.16),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: fg.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

class _DevicesLegendFromDevices extends ConsumerWidget {
  const _DevicesLegendFromDevices({
    required this.devices,
    required this.desktopPeers,
  });
  final List<PairedDevice> devices;
  final List<SkappPeerTarget> desktopPeers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int online = 0;
    int offline = 0;
    int low = 0;
    for (final d in devices) {
      // Mobil peer'lar online/offline takibi olmadığı için legend'a
      // sokulmaz; sağ alttaki stats kart'ta ayrı "telefon" sayacında
      // görünürler.
      if (d.isMobilePeer) continue;
      final s = ref.watch(deviceNotificationStateProvider(d.id));
      switch (s) {
        case NotificationState.none:
          online++;
          break;
        case NotificationState.offline:
          offline++;
          break;
        case NotificationState.lowBattery:
          low++;
          // pil düşük olan da çevrimiçidir, yine sayalım
          online++;
          break;
        case NotificationState.pairingPending:
          // henüz aktif değil; legend'da göstermiyoruz
          break;
      }
    }
    // Desktop peer'lar (mobil sürümde). Online tespiti gerçek
    // (skapp_peer_health_prober her 30sn /api/health pingliyor), legend'a
    // dahil edilir.
    for (final p in desktopPeers) {
      if (p.online) {
        online++;
      } else {
        offline++;
      }
    }
    return DevicesLegend(
      online: online,
      offline: offline,
      lowBattery: low,
    );
  }
}

class _DevicesStatsFromDevices extends StatelessWidget {
  const _DevicesStatsFromDevices({
    required this.devices,
    required this.desktopPeers,
  });
  final List<PairedDevice> devices;
  final List<SkappPeerTarget> desktopPeers;

  @override
  Widget build(BuildContext context) {
    int bf = 0;
    int ls = 0;
    int ms = 0;
    for (final d in devices) {
      if (d.prefix == 'BF') bf++;
      if (d.prefix == 'LS') ls++;
      if (d.prefix == 'MS') ms++;
    }
    final dk = desktopPeers.length;
    // BAĞLI sayacı SK cihazlarını (BF + LS) + mobil sürümde paired
    // desktop'ları toplar. Telefon (MS) ve desktop (DK) ayrı sayaç'larla
    // bağımsız görünür; bu sayede header sub-text + legend + stats card
    // arası tutarlı: bağlı = takip edilen online/offline cihazlar (SK +
    // desktop), telefon ayrı kategori.
    return DevicesStatsCard(
      paired: bf + ls + dk,
      bf: bf,
      ls: ls,
      ms: ms,
      dk: dk,
    );
  }
}
