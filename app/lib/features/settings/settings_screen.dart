import 'dart:async';
import 'dart:io' show Platform, exit;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_info/version_provider.dart';
import '../../core/network/skapp_peer_store.dart';
import '../../core/reset/reset_service.dart';
import '../../core/settings/settings_providers.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/system/system_status_providers.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../about/about_screen.dart';
import '../dev/usb_console_screen.dart';
import '../license/license_screen.dart';
import '../skapi/data/skapi_catalog.dart';
import '../skapi/data/skapi_providers.dart';
import 'network_identity_card.dart';
import 'widgets/network_identity_dialogs.dart';
import 'widgets/peer_tokens_card.dart';
import 'widgets/remote_run_activity_card.dart';
import 'widgets/skapp_listener_card.dart';
import 'widgets/skapp_peers_card.dart';

/// Settings, card-grid layout.
///
/// Pattern by interaction type:
///   * Cycle (tap to change state)  → Theme, Update channel
///   * Toggle (switch inside card)  → Auto-check updates, Developer mode
///   * Picker (sheet)               → Language
///   * Status (read-only)           → Bluetooth adapter, WiFi connectivity
///   * Action (tap to run)          → Check for updates
///   * Nav (push route or system)   → Bluetooth permissions, About, Licenses
///
/// All status cards reflect *live* platform state (BluetoothAdapterState
/// stream + connectivity_plus). The OTA-related cards (channel cycle,
/// auto-check, manual check) persist their state in SharedPreferences;
/// the manual check shows a transparent "OTA service not yet wired"
/// notice instead of a fake "up to date", better than a misleading
/// success.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final channel = ref.watch(updateChannelProvider);
    final autoCheck = ref.watch(autoCheckUpdatesProvider);
    final developerMode = ref.watch(developerModeProvider);
    final versionAsync = ref.watch(appVersionProvider);
    final btAdapter = ref.watch(bluetoothAdapterStateProvider);
    final connectivity = ref.watch(connectivityStatusProvider);
    final identity = ref.watch(networkIdentityProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // V2 redesign: AppBar yerine SKAPI / Cihazlarım sekmelerindeki gibi
      // custom inline `_Header` widget'ı. AppBar Material elevation+border
      // tactile zemin ile uyumsuz görünüyordu; cream scaffold bg + ince
      // alt çizgi tüm sekmelerde aynı görsel dil.
      backgroundColor: isDark
          ? const Color(0xFF0E0D0A)
          : SkColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              versionText: _versionText(versionAsync),
              nodeName: identity.name,
            ),
            Expanded(
              child: SingleChildScrollView(
                // Bottom padding 102 = nav pill effective height (84) + 18 gap.
                // Tüm sekmeler ile aynı alt boşluk kuralı
                // (project_home_viewport_rules).
                padding: const EdgeInsets.only(top: 8, bottom: 102),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                  // ============ DÜĞÜM ADI ============
                  // Tek kart, sağda Düzenle. Live Cards yapısının dışında
                  // (kollâpse yok, doğrudan tap → edit dialog).
                  _NavCard(
                    title: l.settingsNodeNameTitle,
                    subtitle: l.settingsNodeNameSub(identity.name),
                    icon: Icons.hub_outlined,
                    onTap: () => _editNodeName(context, l, identity.name),
                  ),

                  // ============ GÖRÜNÜM ============
                  // Tema + Dil iki kart yan yana (Cycle + Picker pattern).
                  const SizedBox(height: 18),
                  _SectionHeader(text: l.settingsSectionAppearance),
                  _Row2(children: [
                    _CycleCard(
                      title: l.settingsTheme,
                      value: _themeLabel(l, themeMode),
                      icon: _themeIcon(themeMode),
                      hint: l.settingsThemeCycleHint,
                      onTap: () => _cycleTheme(themeMode),
                    ),
                    _PickerCard(
                      title: l.settingsLanguage,
                      value: _languageLabel(l, locale),
                      icon: Icons.translate_rounded,
                      onTap: () => _pickLanguage(context, ref, locale),
                    ),
                  ]),

                  // ============ BAĞLANTI ============
                  // Desktop'ta 3 kart yan yana (3-col responsive grid),
                  // mobile'da alt alta. LayoutBuilder ile genişlik eşiği
                  // 680 px (Tema+Dil ile aynı eşik).
                  const SizedBox(height: 18),
                  _SectionHeader(text: l.settingsSectionConnectivity),
                  _ConnectivityRow(
                    btCard: _LiveCard(
                      icon: Icons.bluetooth_rounded,
                      title: l.settingsBluetoothStatus,
                      subtitle: _bluetoothStatusLabel(l, btAdapter),
                      body: _BluetoothBody(
                        statusLabel: _bluetoothStatusLabel(l, btAdapter),
                        unauthorized: _isBluetoothUnauthorized(btAdapter),
                        grantLabel: l.settingsBluetoothGrantPermission,
                      ),
                    ),
                    wifiCard: _LiveCard(
                      icon: Icons.lan_outlined,
                      title: l.settingsNetworkStatus,
                      subtitle: _wifiStatusLabel(l, connectivity),
                      body: _WifiBody(
                        statusLabel: _wifiStatusLabel(l, connectivity),
                        hint: l.settingsWifiHint,
                      ),
                    ),
                    permissionsCard: _LiveCard(
                      icon: Icons.lock_outline_rounded,
                      title: l.settingsBluetoothPermissions,
                      subtitle: l.settingsBluetoothPermissionsHint,
                      body: _OpenAppSettingsBody(
                        label: l.settingsBluetoothPermissions,
                      ),
                    ),
                  ),

                  // ============ KONTROLLER ============
                  // Geliştirici Modu kart akordiyon DEĞİL — head-only
                  // (body: null). Title yanında "?" iconu info dialog
                  // tetikler, switch trailing'de açma/kapama yapar.
                  // Açıkken altta 6 panel kartı görünür; bunlar akordiyon.
                  const SizedBox(height: 18),
                  _SectionHeader(text: l.settingsSectionAdvanced),
                  _LiveCard(
                    icon: Icons.developer_mode_rounded,
                    title: l.settingsDeveloperMode,
                    headSwitch: _LiveCardSwitch(
                      value: developerMode,
                      onChanged: (v) =>
                          ref.read(developerModeProvider.notifier).set(v),
                    ),
                    infoOnTap: () => _showDeveloperModeInfo(context, l),
                  ),
                  if (developerMode) ...[
                    // USB Konsolu: desktop-only push route.
                    if (!kIsWeb &&
                        (Platform.isWindows ||
                            Platform.isMacOS ||
                            Platform.isLinux)) ...[
                      const SizedBox(height: 10),
                      _LiveCard(
                        icon: Icons.terminal_rounded,
                        title: l.settingsUsbConsoleTitle,
                        subtitle: l.settingsUsbConsoleSubtitle,
                        body: _NavBody(
                          label: l.settingsUsbConsoleTitle,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const UsbConsoleScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                    // Host SKAPI platformlarında 4 networking kartı:
                    // Network Identity, Listener, Peer Tokens, Remote Run.
                    if (hostSkapiPlatformId() != null) ...[
                      const SizedBox(height: 10),
                      _LiveCard(
                        icon: Icons.fingerprint_rounded,
                        title: l.settingsNetworkIdentityTitle,
                        body: const NetworkIdentityCard(),
                      ),
                      const SizedBox(height: 10),
                      _LiveCard(
                        icon: Icons.dns_rounded,
                        title: l.skappListenerCardTitle,
                        body: const SkappListenerCard(),
                      ),
                      const SizedBox(height: 10),
                      _LiveCard(
                        icon: Icons.key_rounded,
                        title: l.settingsPeerTokensTitle,
                        body: const PeerTokensCard(),
                      ),
                      const SizedBox(height: 10),
                      _LiveCard(
                        icon: Icons.history_rounded,
                        title: l.remoteRunActivityCardTitle,
                        body: const RemoteRunActivityCard(),
                      ),
                    ],
                    // SKAPP Peers (outgoing) tüm platformlarda anlamlı.
                    const SizedBox(height: 10),
                    _LiveCard(
                      icon: Icons.devices_other_rounded,
                      title: _skappPeersTitle(ref, l),
                      body: const SkappPeersCard(),
                    ),
                  ],

                  // Güncelleme: kanal cycle + auto-check + check button
                  // hepsi tek live card body'sinde.
                  const SizedBox(height: 10),
                  _LiveCard(
                    icon: Icons.system_update_alt_rounded,
                    title: l.settingsSectionUpdates,
                    subtitle: _channelLabel(l, channel),
                    body: _UpdateBody(
                      channel: channel,
                      channelLabel: _channelLabel(l, channel),
                      channelCycleHint: l.settingsChannelCycleHint,
                      autoCheck: autoCheck,
                      autoCheckLabel: l.settingsAutoCheckUpdates,
                      autoCheckHint: l.settingsAutoCheckUpdatesHint,
                      checkLabel: l.settingsCheckUpdates,
                      onCycleChannel: () => _cycleChannel(channel),
                      onToggleAutoCheck: (v) => ref
                          .read(autoCheckUpdatesProvider.notifier)
                          .set(v),
                      onCheckNow: () => _checkForUpdates(context, l),
                    ),
                  ),

                  // Hakkında: akordiyon değil, doğrudan 2 yan yana nav kart.
                  const SizedBox(height: 18),
                  _SectionHeader(text: l.settingsSectionInfo),
                  _Row2(children: [
                    _NavCard(
                      title: l.settingsOpenAbout,
                      icon: Icons.info_outline_rounded,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutScreen(),
                        ),
                      ),
                    ),
                    _NavCard(
                      title: l.settingsLicense,
                      icon: Icons.description_outlined,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LicenseScreen(),
                        ),
                      ),
                    ),
                  ]),

                  // Tehlikeli bölge: akordiyon değil, 2 yan yana danger
                  // nav kart. Factory Reset için iki aşamalı confirm akışı
                  // (`_TypeToConfirmDialog`) onTap içinde tetiklenir.
                  const SizedBox(height: 18),
                  _SectionHeader(text: l.settingsSectionDanger),
                  _Row2(children: [
                    _NavCard(
                      title: l.settingsResetPairings,
                      subtitle: l.settingsResetPairingsSub,
                      icon: Icons.link_off_rounded,
                      danger: true,
                      onTap: () => _confirmResetPairings(context, l),
                    ),
                    _NavCard(
                      title: l.settingsFactoryReset,
                      subtitle: l.settingsFactoryResetSub,
                      icon: Icons.restart_alt_rounded,
                      danger: true,
                      onTap: () => _confirmFactoryReset(context, l),
                    ),
                  ]),

                  // ============ FOOTER ============
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      l.settingsFooterCombined(
                          _versionText(versionAsync), identity.name),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editNodeName(
    BuildContext context,
    AppLocalizations l,
    String current,
  ) async {
    final next = await promptNetworkIdentityName(context, l, current);
    if (next == null) return;
    await ref.read(networkIdentityProvider.notifier).setName(next);
  }

  /// Compose the SKAPP Peers section title with peer context inline.
  /// Single paired peer → "Title · Name" so the user sees who's paired
  /// without expanding. Two-plus peers → "Title · N". Empty list → the
  /// plain title. Reads the provider at build time via `ref.watch` so
  /// the chip updates on every pairing change.
  String _skappPeersTitle(WidgetRef ref, AppLocalizations l) {
    final peers = ref.watch(skappPeersProvider);
    final base = l.skappPeersCardTitle;
    if (peers.isEmpty) return base;
    if (peers.length == 1) {
      return l.skappPeersCardHeaderSinglePeer(base, peers.first.name);
    }
    return l.skappPeersCardHeaderMultiPeer(base, peers.length);
  }

  /// Reset Pairings akışı. Confirm dialog (sayılı), progress dialog,
  /// summary dialog. Plan ref: ~/.claude/plans/reset.md Faz C.
  Future<void> _confirmResetPairings(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final paired = ref.read(pairedDevicesProvider).length;
    final bindings = ref.read(bindingsProvider).length;
    final peers = ref.read(skappPeersProvider).length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: Text(l.settingsResetPairingsConfirmTitle),
        content: Text(l.settingsResetPairingsConfirmBody(
            paired, bindings, peers)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: SkColors.warnRed,
            ),
            onPressed: () => Navigator.of(dlgCtx).pop(true),
            child: Text(l.settingsResetPairingsConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    await _runReset(context, l, factory: false);
  }

  /// Factory Reset iki aşamalı confirm: birinci dialog "geri alınamaz"
  /// uyarısı, ikinci dialog "SIL/ERASE" type-to-confirm. UX agresif çünkü
  /// kullanıcının yanlışlıkla basması durumunda tüm app state'i gider.
  Future<void> _confirmFactoryReset(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: Text(l.settingsFactoryResetConfirmTitle),
        content: Text(l.settingsFactoryResetConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: SkColors.warnRed,
            ),
            onPressed: () => Navigator.of(dlgCtx).pop(true),
            child: Text(l.settingsFactoryResetConfirmAction),
          ),
        ],
      ),
    );
    if (first != true) return;
    if (!context.mounted) return;

    final second = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dlgCtx) =>
          _TypeToConfirmDialog(localizations: l),
    );
    if (second != true) return;
    if (!context.mounted) return;
    await _runReset(context, l, factory: true);
  }

  /// Common runner: progress dialog goster, ResetService cagir, sonra
  /// summary dialog goster. Factory mode'da summary'de restart butonu olur.
  Future<void> _runReset(
    BuildContext context,
    AppLocalizations l, {
    required bool factory,
  }) async {
    // Progress dialog (cancel yok, atomik). Loading sirasinda kullanici
    // baska bir aksiyon yapamaz.
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResetProgressDialog(localizations: l),
    ));

    ResetSummary summary;
    try {
      final svc = ref.read(resetServiceProvider);
      summary = factory
          ? await svc.factoryReset()
          : await svc.resetPairings();
    } catch (e, st) {
      debugPrint('[settings] reset call failed: $e\n$st');
      summary = ResetSummary(
        kind: factory ? ResetKind.factory : ResetKind.pairings,
        errors: ['unexpected: $e'],
      );
    }
    if (!context.mounted) return;
    Navigator.of(context).pop(); // progress dialog kapat

    await showDialog<void>(
      context: context,
      builder: (_) => _ResetSummaryDialog(
        summary: summary,
        localizations: l,
      ),
    );
  }

  /// Developer mode toggle yanindaki "?" iconu ile acilir. 2026-05-14:
  /// kart subtitle'i kaldirildi, tüm aciklama buraya tasindi. Yapi:
  ///   1. Intro: ne ise yarar tek cümle
  ///   2. Use case 3'lüsü: CLI / SKAPI / Mobile remote (icon + başlik + gövde)
  ///   3. "Ayarlar'da ortaya cıkan kartlar" alt bölümü (4 madde)
  ///   4. Footer: "ücretli yokseğil" + SmartKraft devices bilgisi
  /// Toggle "satin alma" degil ([[project-no-paid-version]]).
  void _showDeveloperModeInfo(BuildContext context, AppLocalizations l) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: SkColors.attentionMustard.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.developer_mode_rounded,
                size: 18,
                color: SkColors.attentionMustard,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.settingsDeveloperModeInfoTitle,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.settingsDeveloperModeInfoIntro,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                _DeveloperModeUseCase(
                  icon: Icons.terminal_rounded,
                  title: l.settingsDeveloperModeUseCaseCliTitle,
                  body: l.settingsDeveloperModeUseCaseCliBody,
                ),
                const SizedBox(height: 10),
                _DeveloperModeUseCase(
                  icon: Icons.code_rounded,
                  title: l.settingsDeveloperModeUseCaseSkapiTitle,
                  body: l.settingsDeveloperModeUseCaseSkapiBody,
                ),
                const SizedBox(height: 10),
                _DeveloperModeUseCase(
                  icon: Icons.phone_iphone_rounded,
                  title: l.settingsDeveloperModeUseCaseMobileTitle,
                  body: l.settingsDeveloperModeUseCaseMobileBody,
                ),
                const SizedBox(height: 22),
                Divider(
                  height: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  l.settingsDeveloperModeInfoSurfacesHeader,
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                _DeveloperModeBullet(text: l.settingsDeveloperModeInfoItem1),
                _DeveloperModeBullet(text: l.settingsDeveloperModeInfoItem2),
                _DeveloperModeBullet(text: l.settingsDeveloperModeInfoItem3),
                _DeveloperModeBullet(text: l.settingsDeveloperModeInfoItem4),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.settingsDeveloperModeInfoNotPaid,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.75),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.commonClose),
          ),
        ],
      ),
    );
  }

  // ------------------------------ logic -------------------------------------

  void _cycleTheme(ThemeMode current) {
    const order = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    final next = order[(order.indexOf(current) + 1) % order.length];
    ref.read(themeModeProvider.notifier).set(next);
  }

  void _cycleChannel(UpdateChannel current) {
    final next = current == UpdateChannel.stable
        ? UpdateChannel.beta
        : UpdateChannel.stable;
    ref.read(updateChannelProvider.notifier).set(next);
  }

  /// Manual update probe. The OTA manifest service isn't wired yet (BF
  /// firmware ships sk_ota with a NULL manifest URL), so until that lands
  /// this surfaces a transparent notice rather than fake "up to date".
  void _checkForUpdates(BuildContext context, AppLocalizations l) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.settingsUpdateCheckPlaceholder, textAlign: TextAlign.center)));
  }

  String _versionText(AsyncValue<String> v) => switch (v) {
        AsyncData(:final value) => 'v$value',
        AsyncError() => '-',
        _ => '…',
      };

  String _themeLabel(AppLocalizations l, ThemeMode m) => switch (m) {
        ThemeMode.light => l.settingsThemeLight,
        ThemeMode.dark => l.settingsThemeDark,
        ThemeMode.system => l.settingsThemeSystem,
      };

  IconData _themeIcon(ThemeMode m) => switch (m) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.phone_android_rounded,
      };

  String _languageLabel(AppLocalizations l, Locale? locale) => switch (
          locale?.languageCode) {
        'tr' => l.langTurkish,
        'en' => l.langEnglish,
        _ => l.settingsThemeSystem,
      };

  String _channelLabel(AppLocalizations l, UpdateChannel c) => switch (c) {
        UpdateChannel.stable => l.settingsUpdateChannelStable,
        UpdateChannel.beta => l.settingsUpdateChannelBeta,
      };

  /// Adapter state "unauthorized" (Android'de runtime izin reddi, iOS'ta
  /// Info.plist eksiği gibi) iken inline "İzin Ver" butonu görünür.
  bool _isBluetoothUnauthorized(AsyncValue<BluetoothAdapterState> async) {
    return async.maybeWhen(
      data: (s) => s == BluetoothAdapterState.unauthorized,
      orElse: () => false,
    );
  }

  /// Map flutter_blue_plus adapter state to user-readable label.
  String _bluetoothStatusLabel(
    AppLocalizations l,
    AsyncValue<BluetoothAdapterState> async,
  ) {
    return async.maybeWhen(
      data: (s) => switch (s) {
        BluetoothAdapterState.on => l.settingsBluetoothStatusOn,
        BluetoothAdapterState.off => l.settingsBluetoothStatusOff,
        BluetoothAdapterState.turningOn => l.settingsBluetoothStatusTurningOn,
        BluetoothAdapterState.turningOff => l.settingsBluetoothStatusTurningOff,
        BluetoothAdapterState.unauthorized =>
          l.settingsBluetoothStatusUnauthorized,
        BluetoothAdapterState.unavailable =>
          l.settingsBluetoothStatusUnsupported,
        _ => l.settingsBluetoothStatusUnknown,
      },
      orElse: () => l.settingsBluetoothStatusUnknown,
    );
  }

  /// Map connectivity_plus result list to user-readable label. A phone can
  /// be on multiple transports at once; we collapse to the single most
  /// relevant for a settings card.
  String _wifiStatusLabel(
    AppLocalizations l,
    AsyncValue<List<ConnectivityResult>> async,
  ) {
    return async.maybeWhen(
      data: (list) {
        if (list.contains(ConnectivityResult.wifi)) {
          return l.settingsWifiStatusConnected;
        }
        if (list.contains(ConnectivityResult.ethernet)) {
          return l.settingsWifiStatusEthernet;
        }
        if (list.contains(ConnectivityResult.mobile)) {
          return l.settingsWifiStatusMobile;
        }
        if (list.contains(ConnectivityResult.none) || list.isEmpty) {
          return l.settingsWifiStatusDisconnected;
        }
        return l.settingsWifiStatusUnknown;
      },
      orElse: () => l.settingsWifiStatusUnknown,
    );
  }

  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    Locale? current,
  ) async {
    final l = AppLocalizations.of(context);
    const systemLocale = Locale('system');
    final currentChoice = current ?? systemLocale;

    // Dil listesi tek noktada: ileride 8 dil tamamlandığında yeni
    // `_LanguageOption` ekle, dialog otomatik scroll edecek. Her
    // entry hem native ad (Türkçe/English/Deutsch...) hem ASCII kod
    // (TR/EN/DE/...) taşır → görsel arama hızlı.
    final options = <_LanguageOption>[
      _LanguageOption(
        locale: systemLocale,
        nativeName: l.settingsThemeSystem,
        secondary: l.settingsLanguageSystemHint,
        code: 'AUTO',
        pinned: true,
      ),
      const _LanguageOption(
        locale: Locale('en'),
        nativeName: 'English',
        secondary: 'English',
        code: 'En',
      ),
      const _LanguageOption(
        locale: Locale('tr'),
        nativeName: 'Türkçe',
        secondary: 'Turkish',
        code: 'Tr',
      ),
    ];

    final chosen = await showDialog<Locale>(
      context: context,
      builder: (dlgCtx) => _LanguagePickerDialog(
        title: l.settingsLanguage,
        options: options,
        current: currentChoice,
      ),
    );
    if (chosen == null) return;
    final asAppLocale = chosen == systemLocale ? null : chosen;
    await ref.read(localeProvider.notifier).set(asAppLocale);
  }
}

/// Dil seçeneği tek satır içerik kaynağı. Locale, native name (kullanıcı
/// kendi dilinde nasıl görür), secondary (English fallback ya da auto
/// açıklaması), code (2-3 harf kısa kod, sağda rozet), pinned (üstte ayrı
/// bir bölümde durur, raised tactile + push pin ikonu).
class _LanguageOption {
  const _LanguageOption({
    required this.locale,
    required this.nativeName,
    required this.secondary,
    required this.code,
    this.pinned = false,
  });
  final Locale locale;
  final String nativeName;
  final String secondary;
  final String code;
  final bool pinned;
}

/// Dil seçici dialog · V2 tactile (sarı yok, arama yok).
///
/// Yapı:
///   - Header: translate ikonu + başlık + close X
///   - Pinned zone: Sistem (auto) tile, raised tactile (kabarık), push pin
///   - Divider
///   - Section header: "Tüm diller" + A → Z N dil
///   - Scrollable list: gerçek desteklenen diller (şu an En + Tr; gelecekte
///     yeni dil eklenince options listesine eklenecek)
///
/// Selected state: tile V2 well (içe basılı, SkNeuCard inset shadow ile)
/// + siyah check ikonu. Mustard kullanılmaz; tactile metafora sadık seçim
/// = fiziksel basma. Bkz: popup.html dil seçici tasarımı.
class _LanguagePickerDialog extends StatelessWidget {
  const _LanguagePickerDialog({
    required this.title,
    required this.options,
    required this.current,
  });
  final String title;
  final List<_LanguageOption> options;
  final Locale current;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final pinned = options.where((o) => o.pinned).toList();
    final regular = options.where((o) => !o.pinned).toList()
      ..sort((a, b) => a.nativeName.toLowerCase().compareTo(
            b.nativeName.toLowerCase(),
          ));

    return Dialog(
      // Shape ve background theme.dialogTheme'den geliyor (Tactile redesign).
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 22,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),

            // ===== Pinned zone (Sistem) =====
            if (pinned.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final opt in pinned)
                      _LanguageTile(
                        option: opt,
                        selected: opt.locale == current,
                        onTap: () => Navigator.of(context).pop(opt.locale),
                      ),
                  ],
                ),
              ),

            // ===== Section header: Tüm diller =====
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      l.settingsLanguagePickerAllSection.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  Text(
                    'A → Z · ${regular.length}',
                    style: tt.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 0.4,
                      color: cs.onSurface.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Scrollable regular list =====
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final opt in regular)
                      _LanguageTile(
                        option: opt,
                        selected: opt.locale == current,
                        onTap: () => Navigator.of(context).pop(opt.locale),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek dil satırı · 3 state:
///   - Pinned + not selected: raised (kabarık) tactile + push_pin ikonu
///   - Pinned + selected: well (içe basılı, SkNeuCard inset) + push_pin + check
///   - Regular + not selected: flat (saydam), hover bg
///   - Regular + selected: well (içe basılı) + siyah check
///
/// Mustard hardal sarısı KULLANILMAZ. Check ikonu daima siyah (onSurface).
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final _LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tileContent = Row(
      children: [
        // Badge: native script (En/Tr/Ру/Ελ). Pinned'de "AUTO" (mono).
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            option.code,
            style: option.pinned
                ? tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  )
                : tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                option.nativeName,
                style: tt.titleSmall?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                option.secondary,
                style: tt.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 0.2,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Pinned ikonu: hep görünür (pinned tile'larda)
        if (option.pinned) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.push_pin_rounded,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.45),
          ),
        ],
        // Selected check (siyah)
        if (selected) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.check_rounded,
            size: 22,
            color: cs.onSurface,
          ),
        ],
      ],
    );

    const radius = 14.0;
    const tilePadding =
        EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    // 3 state'i ayrı widget kabuklarıyla render et (her birinin gölgesi
    // farklı: well, raised, flat).
    if (selected) {
      // V2 well (inset) — SkNeuCard ile zaten doğru gölge.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: SkNeuCard(
          onTap: onTap,
          borderRadius: radius,
          padding: tilePadding,
          child: tileContent,
        ),
      );
    }

    if (option.pinned) {
      // Raised (kabarık) — basit BoxShadow, sk_neu_card.dart pinned-tile
      // CSS karşılığı.
      final bg = Theme.of(context).scaffoldBackgroundColor;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.78),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: Padding(
                padding: tilePadding,
                child: tileContent,
              ),
            ),
          ),
        ),
      );
    }

    // Regular (flat) — saydam, hover bg.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: tilePadding,
            child: tileContent,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Layout primitives
// ============================================================================

/// Settings sekmesinin inline header'ı. SKAPI ve Cihazlarım sekmeleriyle
/// aynı kalıp: scaffold zemininde Container, sol tarafta başlık + alt
/// monospaced özet, sağda küçük bir hesap göstergesi yok (Settings yeni
/// action açmıyor). AppBar yerine bu widget kullanılır; tactile yüzeyle
/// kaynaşır, Material elevation çizgisi kalkar.
class _Header extends StatelessWidget {
  const _Header({
    required this.versionText,
    required this.nodeName,
  });

  final String versionText;
  final String nodeName;

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
            : SkColors.cream,
        border: Border(
          bottom: BorderSide(
            color: fg.withValues(alpha: 0.12),
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
                  l.settingsTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  // Footer ile aynı format ("SKAPP {version} · {node}"),
                  // tek satır + ellipsis; mobile'da dar ekranda overflow
                  // riskini düşürür. Versiyon yükleme bekleniyorsa
                  // "…" karakteri görünür, kullanıcı bilinçli olarak
                  // hangi build'i çalıştırdığını burada da görür.
                  l.settingsFooterCombined(versionText, nodeName),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

/// Developer mode info dialog'unun "Ayarlar'da gorunen kartlar" alt
/// bolumunde kullanilan kucuk madde widget'i. Sol tarafta hardal sari
/// mini nokta, sagda metin.
class _DeveloperModeBullet extends StatelessWidget {
  const _DeveloperModeBullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: SkColors.attentionMustard,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// Developer mode info dialog'unun üst kismindaki 3 ana kullanim
/// senaryosu icin satir widget'i. Sol tarafta kare kart icinde hardal
/// sari icon, sagda baslik (titleSmall, bold) + gövde (bodySmall).
class _DeveloperModeUseCase extends StatelessWidget {
  const _DeveloperModeUseCase({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: SkColors.attentionMustard.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 20,
            color: SkColors.attentionMustard,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  title,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Two cards side-by-side with equal width and a 10 px gap. Each child's
/// height snaps to the tallest sibling via `IntrinsicHeight`, keeps the
/// grid tidy even when subtitles differ in line count.
class _Row2 extends StatelessWidget {
  const _Row2({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 10),
          Expanded(child: children[1]),
        ],
      ),
    );
  }
}

// ============================================================================
// Card variants
// ============================================================================

/// Cycle card, tap cycles through a finite set of states. No sheet, no
/// dialog. Meant for 2–3 option settings where label + icon make the current
/// state legible in-place.
class _CycleCard extends StatelessWidget {
  const _CycleCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.hint,
    required this.onTap,
  });
  final String title;
  final String value;
  final IconData icon;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SkNeuIconSlot(icon: icon, size: 36, iconSize: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
          ),
        ],
      ),
    );
  }
}

/// Picker card, taps opens a bottom sheet for selection. Identical shell
/// to _CycleCard but shows a ▾ chevron to signal the sheet interaction.
class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SkNeuIconSlot(icon: icon, size: 36, iconSize: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 20,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// _StatusCard, _ToggleCard, _ActionCard 2026-05-15'te kaldırıldı:
// Live Cards refactor'ı bu üç widget'ı `_LiveCard` body'leri ile değiştirdi.
// (Status → _BluetoothBody/_WifiBody, Toggle → _LiveCard.headSwitch +
// inline SwitchListTile, Action → OutlinedButton.icon inline).

/// Live Cards primitif: head (icon + title + subtitle + trailing) +
/// kollâpse edilebilir body. Tüm Ayarlar kartları (Bağlantı, Güncelleme,
/// Hakkında, Tehlikeli bölge, Geliştirici Modu paneller) bu paradigma
/// altında birleşir. Önceki `_DevCollapsibleCard`'ın daha kapsamlı halidir:
/// switch trailing + danger varyant + subtitle desteği eklendi.
///
/// Tasarım kararları (mockup `ayar.html`'den):
///   * Head tıklaması → body expand/collapse toggle.
///   * Switch tıklaması → sadece switch state, accordion'u etkilemez
///     (decoupled). Geliştirici Modu switch'i açık/kapalı olabilir,
///     kart içeriği expanded/collapsed olabilir, bağımsız.
///   * Body collapsed iken widget tree'de yok (provider subscription
///     boşa harcanmaz).
///   * Danger varyant: kırmızı border + kırmızı title (Tehlikeli bölge).
///   * Body olmadan kullanılamaz; sadece nav için [_NavCard] kullanılır.
class _LiveCard extends StatefulWidget {
  const _LiveCard({
    required this.icon,
    required this.title,
    this.body,
    this.subtitle,
    this.headSwitch,
    this.infoOnTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;

  /// Akordiyon gövdesi. `null` → kart head-only davranır: chev yok,
  /// head tap toggle yok. Geliştirici Modu gibi yalnız switch+info
  /// taşıyan kartlar için kullanılır.
  final Widget? body;
  final _LiveCardSwitch? headSwitch;

  /// Title yanında "?" iconu. Tap eder, accordion'u açmaz/kapatmaz —
  /// genelde info dialog çağırır (örn `_showDeveloperModeInfo`).
  final VoidCallback? infoOnTap;

  @override
  State<_LiveCard> createState() => _LiveCardState();
}

class _LiveCardSwitch {
  const _LiveCardSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
}

class _LiveCardState extends State<_LiveCard> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titleColor = cs.onSurface;
    final hasBody = widget.body != null;
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Head row: tap on title/subtitle area toggles expand (body varsa).
          // Switch, info ve chev head InkWell'inin dışında — switch ve info
          // kendi tıklamalarını ezecek.
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: hasBody ? _toggle : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
                    child: Row(
                      children: [
                        SkNeuIconSlot(
                          icon: widget.icon,
                          size: 36,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: titleColor),
                                    ),
                                  ),
                                  if (widget.infoOnTap != null) ...[
                                    const SizedBox(width: 6),
                                    InkWell(
                                      onTap: widget.infoOnTap,
                                      customBorder: const CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.help_outline_rounded,
                                          size: 16,
                                          color: cs.onSurface
                                              .withValues(alpha: 0.55),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle!,
                                  // Tek satır + ellipsis: dar 3-col grid'de
                                  // (Bağlantı, ileride Hakkında vs.)
                                  // farklı subtitle uzunlukları head
                                  // yüksekliğini değiştirmesin. Yan yana
                                  // kartlar collapsed iken aynı boyda
                                  // kalır; biri expand olduğunda alttaki
                                  // body büyür, diğerleri kısa kalır.
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: cs.onSurface
                                            .withValues(alpha: 0.65),
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
              ),
              if (widget.headSwitch != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SkNeuSwitch(
                    value: widget.headSwitch!.value,
                    onChanged: widget.headSwitch!.onChanged,
                  ),
                )
              else if (hasBody)
                InkWell(
                  onTap: _toggle,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 8),
            ],
          ),
          if (hasBody)
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: cs.outlineVariant.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 12),
                          widget.body!,
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
        ],
      ),
    );
  }
}

/// Nav card, tapping pushes to another screen. Subtitle optional.
class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.danger = false,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  /// Tehlikeli aksiyonlar için: kırmızı border + warn-red title rengi.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titleColor = danger ? SkColors.warnRed : cs.onSurface;
    return SkNeuCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SkNeuIconSlot(
            icon: icon,
            tone: danger ? SkNeuIconSlotTone.danger : SkNeuIconSlotTone.neutral,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: titleColor,
                          fontWeight: danger ? FontWeight.w700 : null,
                        ),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.65),
                          )),
                ],
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Live Card body widget'ları
// ============================================================================
//
// Her body widget bir `_LiveCard.body` parametresine geçer. Body expanded
// iken görünür; collapsed iken widget tree'de yok (provider subscription
// boşa harcanmaz). Bağlantı/Güncelleme/Hakkında/Tehlikeli bölge ve dev
// panel cards (Network Identity, Listener vs.) kendi widget'larını body
// olarak alır — `_LiveCard` sadece head + chev/switch + animate kapsülü.

class _BluetoothBody extends StatelessWidget {
  const _BluetoothBody({
    required this.statusLabel,
    required this.unauthorized,
    required this.grantLabel,
  });
  final String statusLabel;
  final bool unauthorized;
  final String grantLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(statusLabel, style: Theme.of(context).textTheme.bodyMedium),
        if (unauthorized) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: openAppSettings,
            icon: const Icon(Icons.lock_open_outlined, size: 16),
            label: Text(grantLabel),
            style: OutlinedButton.styleFrom(
              foregroundColor: SkColors.warnRed,
              side: BorderSide(
                  color: SkColors.warnRed.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ],
    );
  }
}

class _WifiBody extends StatelessWidget {
  const _WifiBody({required this.statusLabel, required this.hint});
  final String statusLabel;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(statusLabel, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(
          hint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
        ),
      ],
    );
  }
}

class _OpenAppSettingsBody extends StatelessWidget {
  const _OpenAppSettingsBody({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () => openAppSettings(),
        icon: const Icon(Icons.open_in_new_rounded, size: 16),
        label: Text(label),
      ),
    );
  }
}

class _NavBody extends StatelessWidget {
  const _NavBody({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: Text(label),
      ),
    );
  }
}

/// Bağlantı bölümünün responsive 3-col grid'i. `LayoutBuilder` ile
/// genişlik ≥ 680 px ise yan yana (Tema+Dil eşiği ile aynı), aksi halde
/// alt alta. Yan yana iken `IntrinsicHeight` YOK — her kart kendi boyunda
/// kalır, biri expand olursa diğerleri stretch etmez (mockup'taki
/// `align-items: start` davranışı).
class _ConnectivityRow extends StatelessWidget {
  const _ConnectivityRow({
    required this.btCard,
    required this.wifiCard,
    required this.permissionsCard,
  });
  final Widget btCard;
  final Widget wifiCard;
  final Widget permissionsCard;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        if (c.maxWidth >= 680) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: btCard),
              const SizedBox(width: 10),
              Expanded(child: wifiCard),
              const SizedBox(width: 10),
              Expanded(child: permissionsCard),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            btCard,
            const SizedBox(height: 10),
            wifiCard,
            const SizedBox(height: 10),
            permissionsCard,
          ],
        );
      },
    );
  }
}

class _UpdateBody extends StatelessWidget {
  const _UpdateBody({
    required this.channel,
    required this.channelLabel,
    required this.channelCycleHint,
    required this.autoCheck,
    required this.autoCheckLabel,
    required this.autoCheckHint,
    required this.checkLabel,
    required this.onCycleChannel,
    required this.onToggleAutoCheck,
    required this.onCheckNow,
  });
  final UpdateChannel channel;
  final String channelLabel;
  final String channelCycleHint;
  final bool autoCheck;
  final String autoCheckLabel;
  final String autoCheckHint;
  final String checkLabel;
  final VoidCallback onCycleChannel;
  final ValueChanged<bool> onToggleAutoCheck;
  final VoidCallback onCheckNow;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kanal cycle satırı: tap ile Stabil ↔ Beta.
        InkWell(
          onTap: onCycleChannel,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Icon(
                  channel == UpdateChannel.beta
                      ? Icons.science_outlined
                      : Icons.flag_outlined,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channelLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        channelCycleHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.swap_horiz_rounded,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Otomatik kontrol satırı · V2 tactile: SwitchListTile yerine
        // manuel Row + SkNeuSwitch. Adaptive switch Material'a göre
        // tasarlandı, tactile zeminle kontrast tutmuyor.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      autoCheckLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      autoCheckHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.55),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SkNeuSwitch(value: autoCheck, onChanged: onToggleAutoCheck),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: onCheckNow,
            icon: const Icon(Icons.sync_rounded, size: 16),
            label: Text(checkLabel),
          ),
        ),
      ],
    );
  }
}

// _AboutBody ve _DangerBody 2026-05-15'te kaldırıldı:
// Bilgi ve Tehlikeli bölge artık akordiyon değil; doğrudan 2 yan yana
// `_NavCard` (`_Row2` içinde) olarak kullanılıyor. Bu, kullanıcı için
// daha az tıklama (1 yerine 2 — doğrudan aksiyon) + mockup'ta da
// böyle istendi.

// ============================================================================
// Reset / Factory Reset dialogs (Faz 3, plan: ~/.claude/plans/reset.md)
// ============================================================================

/// Type-to-confirm dialog Factory Reset'in ikinci adımı. Kullanıcı
/// hint text'i ("SIL"/"ERASE") birebir yazana kadar "Anladım sil" butonu
/// disabled kalır. Yanlış yazılırsa hata mesajı görünmez, sadece buton
/// disable durur — UX hatırlatma yumuşak.
class _TypeToConfirmDialog extends StatefulWidget {
  const _TypeToConfirmDialog({required this.localizations});
  final AppLocalizations localizations;

  @override
  State<_TypeToConfirmDialog> createState() => _TypeToConfirmDialogState();
}

class _TypeToConfirmDialogState extends State<_TypeToConfirmDialog> {
  final _ctrl = TextEditingController();
  late final String _expected =
      widget.localizations.settingsFactoryResetSecondConfirmHint;
  String _typed = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.localizations;
    final match = _typed.trim().toUpperCase() == _expected.toUpperCase();
    return AlertDialog(
      title: Text(l.settingsFactoryResetSecondConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.settingsFactoryResetSecondConfirmBody),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: _expected,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _typed = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: SkColors.warnRed,
          ),
          onPressed:
              match ? () => Navigator.of(context).pop(true) : null,
          child: Text(l.settingsFactoryResetSecondConfirmAction),
        ),
      ],
    );
  }
}

/// Reset/Factory Reset sırasında gösterilen küçük progress dialog.
/// Cancel yok (atomik operasyon). 1-3 sn sürer normal koşullarda.
class _ResetProgressDialog extends StatelessWidget {
  const _ResetProgressDialog({required this.localizations});
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(localizations.settingsResetInProgress)),
          ],
        ),
      ),
    );
  }
}

/// Reset/Factory Reset sonrası özet dialog. Silinen sayılar +
/// uyarılar (varsa) listelenir. Factory mode'da "Şimdi yeniden başlat"
/// butonu ek olarak görünür.
class _ResetSummaryDialog extends StatelessWidget {
  const _ResetSummaryDialog({
    required this.summary,
    required this.localizations,
  });
  final ResetSummary summary;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final l = localizations;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isFactory = summary.kind == ResetKind.factory;
    final title = summary.hasErrors
        ? l.settingsResetDoneWithWarnings
        : l.settingsResetDoneTitle;

    final lines = <String>[
      if (summary.pairedDevicesRemoved > 0)
        l.settingsResetSummaryPaired(summary.pairedDevicesRemoved),
      if (summary.bondsCleared > 0)
        l.settingsResetSummaryBonds(summary.bondsCleared),
      if (summary.bindingsRemoved > 0)
        l.settingsResetSummaryBindings(summary.bindingsRemoved),
      if (summary.skappPeersRemoved > 0)
        l.settingsResetSummaryPeers(summary.skappPeersRemoved),
      if (summary.networkIdentityReset) l.settingsResetSummaryNetworkIdentity,
      if (summary.tlsCertCleared) l.settingsResetSummaryTlsCert,
      if (summary.autostartUnregistered) l.settingsResetSummaryAutostart,
    ];

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final line in lines) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line, style: tt.bodyMedium)),
                  ],
                ),
              ),
            ],
            if (summary.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l.settingsResetSummaryWarningHeader,
                style: tt.labelMedium?.copyWith(
                  color: SkColors.warnRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              for (final err in summary.errors)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• $err',
                    style: tt.bodySmall?.copyWith(
                      color: cs.error,
                    ),
                  ),
                ),
            ],
            if (isFactory) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: SkColors.attentionMustard,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: SkColors.attentionMustard,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.settingsResetRestartHint,
                        style: tt.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.settingsResetClose),
        ),
        if (isFactory)
          FilledButton.icon(
            onPressed: () {
              // Agresif restart yok; sadece exit çağrılır, kullanıcı
              // app'i manuel yeniden açar. windowManager.destroy + exit
              // ile process temiz sonlanır.
              Navigator.of(context).pop();
              exit(0);
            },
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(l.settingsResetRestartNow),
          ),
      ],
    );
  }
}
