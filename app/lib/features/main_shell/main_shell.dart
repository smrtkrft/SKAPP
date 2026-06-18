import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/paired_ble_scanner.dart';
import '../../core/desktop_lifecycle/tray_lifecycle.dart';
import '../../core/network/mdns_browser.dart';
import '../../core/network/skapp_peer_health_prober.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../devices/devices_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../../core/network/skapp_http_server.dart';
import '../../core/network/skapp_listener_service.dart';
import '../skapi/data/bindings_trigger_service.dart';
import '../skapi/data/skapi_providers.dart';
import '../skapi/data/system_endpoint_sync_service.dart';
import '../skapi/skapi_screen.dart';
import 'selected_tab_provider.dart';

/// Bottom navigation on phones is a *floating pill* rather than an
/// edge-to-edge bar. Rationale: SKAPP is a configuration tool, not a
/// daily-driver app, the nav should feel like a control that rides above
/// content, not a wall that steals 80 px on every screen.
///
/// Desktop (>= [SkBreakpoints.expanded]) gets a permanent left rail
/// instead, because a phone-style bottom pill on a 1600 px window looks
/// like a stretched mobile mock-up, which is the exact problem we're
/// fixing.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  StreamSubscription<BindingTriggerNotice>? _bindingSub;
  StreamSubscription<void>? _firstHideSub;

  static const _tabs = [
    HomeScreen(),
    DevicesScreen(),
    SkapiScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Wire the SKAPI bindings trigger service: it watches paired-device
    // event streams and fires SKAPI scripts whose filter matches. The
    // service emits notices we surface as a SnackBar so the user has
    // immediate feedback that a device-driven action has fired.
    final service = ref.read(bindingsTriggerServiceProvider);
    service.start();
    _bindingSub = service.notices.listen(_onBindingNotice);

    // Tray bilgilendirme toast'i: pencere ilk kez X ile gizlendiginde
    // DesktopLifecycle stream yayinlar, biz burada SnackBar render
    // ederiz. Mobil/web'de desktopLifecycleSupported false oldugu icin
    // stream zaten asla yayin yapmaz; abone olmak guvenli.
    if (desktopLifecycleSupported) {
      _firstHideSub = DesktopLifecycle.instance.firstHideEvents
          .listen(_onTrayFirstHide);
    }

    // Periodically probe `/api/health` on every paired SKAPP peer so
    // the peer picker / Settings card reflects fresh online status +
    // `developerModeEnabled` flag without waiting for mDNS hops. Runs
    // on every platform: mobile uses it to surface dev-mode rozet on
    // peer rows; desktop uses it to keep desktop↔desktop pairings
    // (future) live. No-op when the paired list is empty.
    ref.read(skappPeerHealthProberProvider).start();

    // Boot the SKAPP HTTP listener on Desktop hosts so paired phones
    // can run scripts remotely. Mobile / web hosts skip this branch
    // (the server is platform-guarded) and only act as clients.
    final server = ref.read(skappHttpServerProvider);
    if (server.supported) {
      final listener = ref.read(skappListenerServiceProvider);
      listener.watchIdentity();
      // Developer mode (developerModeProvider) gates the mDNS announcer and
      // auto-restores lanVisible when turned off — see
      // SkappListenerService.watchProMode for the contract.
      listener.watchProMode();
      // Fire-and-forget start. Errors land in
      // `skappListenerLastErrorProvider`, the Settings card renders them
      // on first paint; we only swallow the rethrow here so an uncaught
      // async error doesn't kill the zone.
      unawaited(listener.start().catchError((_) => false));

      // Phase C.2/C.3: keep every paired BF's SYSTEM-kind endpoint slot
      // pointed at this SKAPP install's listener URL. Reactive — fires
      // on bindings / paired-list / port changes. Mobile is a no-op
      // because there is no listener URL to publish there. NOT gated by
      // Developer mode: BF webhooks must keep flowing regardless.
      ref.read(systemEndpointSyncServiceProvider).start();
    }

    // Surface the "LAN visibility auto-restored" snackbar when Developer mode is
    // turned off while `lanVisible` was false. The pulse counter only
    // changes during that exact transition, so listeners fire at most
    // once per toggle. ListenManual lets us register with the persistent
    // service lifecycle instead of build-coupled `ref.listen`.
    ref.listenManual<int>(
      lanVisibleAutoReopenedProvider,
      (previous, next) {
        if (previous == null || previous == next) return;
        if (!mounted) return;
        final l = AppLocalizations.of(context);
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger == null) return;
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(l.settingsLanVisibleAutoReopenedSnack, textAlign: TextAlign.center),
          ));
      },
    );
  }

  @override
  void dispose() {
    _bindingSub?.cancel();
    _firstHideSub?.cancel();
    super.dispose();
  }

  void _onTrayFirstHide(void _) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.trayFirstHideToast, textAlign: TextAlign.center),
        duration: const Duration(seconds: 4),
      ));
  }

  void _onBindingNotice(BindingTriggerNotice notice) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final text = notice.desktop
        ? l.skapiBindTriggeredDesktopToast(notice.binding.scriptId)
        : l.skapiBindTriggeredMobileToast(notice.eventName);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final index = ref.watch(selectedTabProvider);

    // Keep the mDNS browser running for the entire app lifetime so the
    // Devices tab can show "online" badges without waiting for the user
    // to visit SKAPI first. The provider is non-autoDispose, so the
    // first read latches it on for good.
    ref.watch(mdnsBrowserProvider);
    // Same lifecycle for the paired BLE scanner: paired devices that are
    // only reachable over BLE (no WiFi yet) appear "online" too. mDNS +
    // BLE feed the same lastSeen timestamp so the UI remains transport-
    // agnostic.
    ref.watch(pairedBleScannerProvider);
    final items = [
      _NavSpec(
        Icons.bolt_outlined, Icons.bolt_rounded, l.tabSmartKraft,
        logoAssetLight: 'assets/branding/logo_black.png',
        logoAssetDark: 'assets/branding/logo_white.png',
      ),
      _NavSpec(Icons.devices_outlined, Icons.devices_rounded, l.tabDevices),
      _NavSpec(Icons.extension_outlined, Icons.extension_rounded, l.tabSkapi),
      _NavSpec(Icons.tune_outlined, Icons.tune_rounded, l.tabSettings),
    ];

    // Dock her tab + her platformda görünür. Eski sticky-note dashboard
    // (laptop.html) kaldırıldı; SmartKraft ana sayfa kendi scroll'üne sahip
    // ve bottom dock ile birlikte çalışır.
    final isDesktop = context.isDesktop;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: _tabs),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: isDesktop ? 18 : 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FloatingNavPill(
                activeIndex: index,
                onSelect: _onSelect,
                items: items,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelect(int i) {
    ref.read(selectedTabProvider.notifier).set(i);
  }
}

/// Public floating-pill nav for use in pushed detail screens. The root
/// [MainShell] hides its bottom bar when a detail route is on top
/// (Material default), which means users have to hit back as many
/// times as the route stack is deep to reach another tab. This widget
/// embeds the same pill in any detail [Scaffold]'s `bottomNavigationBar`
/// slot — tap pops all routes to root and switches the tab in one
/// gesture, mirroring native mobile expectations.
///
/// Usage in a pushed screen:
/// ```dart
/// return Scaffold(
///   appBar: AppBar(...),
///   body: ...,
///   bottomNavigationBar: const ShellNavBar(),
/// );
/// ```
class ShellNavBar extends ConsumerWidget {
  const ShellNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final index = ref.watch(selectedTabProvider);
    final isDesktop = context.isDesktop;
    final items = <_NavSpec>[
      _NavSpec(
        Icons.bolt_outlined, Icons.bolt_rounded, l.tabSmartKraft,
        logoAssetLight: 'assets/branding/logo_black.png',
        logoAssetDark: 'assets/branding/logo_white.png',
      ),
      _NavSpec(Icons.devices_outlined, Icons.devices_rounded, l.tabDevices),
      _NavSpec(Icons.extension_outlined, Icons.extension_rounded, l.tabSkapi),
      _NavSpec(Icons.tune_outlined, Icons.tune_rounded, l.tabSettings),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: isDesktop ? 18 : 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FloatingNavPill(
              activeIndex: index,
              items: items,
              onSelect: (i) {
                // Stack'i kökten temizle: kullanıcı 3 push derinlikteyse
                // sekme tuşuna basınca 3 geri yerine tek seferde root'a
                // döner + yeni tab açılır.
                Navigator.of(context).popUntil((r) => r.isFirst);
                ref.read(selectedTabProvider.notifier).set(i);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.icon, this.activeIcon, this.label,
      {this.logoAssetLight, this.logoAssetDark});
  final IconData icon;
  final IconData activeIcon;
  final String label;
  /// SmartKraft tab uses the brand logo instead of a Material icon.
  /// When both are set, _NavTile picks the asset matching current theme
  /// brightness; falls back to [icon] otherwise.
  final String? logoAssetLight;
  final String? logoAssetDark;
}

class _FloatingNavPill extends StatelessWidget {
  const _FloatingNavPill({
    required this.activeIndex,
    required this.onSelect,
    required this.items,
  });

  /// Tüm tab'ların gerçek index'leri (0..5). Aktif tab da pill'de kalır
  /// (kullanıcı "buradayım" göstergesini sürekli görsün); tile activeIcon
  /// + tam opacity + soft bg highlight ile vurgulanır.
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final List<_NavSpec> items;

  @override
  Widget build(BuildContext context) {
    // Light: krem pill + siyah ikon (kâğıt üzerinde nazikçe öne çıkar).
    // Dark: warm-black pill + krem ikon (uyku odası karanlığında kontrast).
    // İki tema da köşeli olmayan yumuşak gölge ile ada hissi korunur.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1F1D18) : const Color(0xFFFFFEFA);
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    // 6 tile × 56px + 5 × 6px gap + 16px padding = 382px. Mobile
    // ekranlarda (360-420dp) rahat sığar, desktop dashboard'da zaten
    // hideDock true (sticky-note grid primary nav).
    final tiles = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (tiles.isNotEmpty) tiles.add(const SizedBox(width: 6));
      tiles.add(_NavTile(
        spec: items[i],
        foreground: fg,
        isActive: i == activeIndex,
        onTap: () => onSelect(i),
      ));
    }
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: fg.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tiles,
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.spec,
    required this.foreground,
    required this.isActive,
    required this.onTap,
  });

  final _NavSpec spec;
  final Color foreground;

  /// Aktif tab: activeIcon + tam opacity + label w600 + soft bg highlight.
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? foreground
        : foreground.withValues(alpha: 0.72);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = isDark ? spec.logoAssetDark : spec.logoAssetLight;
    final iconData = isActive ? spec.activeIcon : spec.icon;
    // Brand logo PNGs have ~6% inner padding by virtue of their stroke
    // construction; rendering at 24px puts the optical weight in line
    // with the surrounding 20px line-icons.
    final Widget glyph = logoAsset != null
        ? Image.asset(
            logoAsset,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
            filterQuality: FilterQuality.medium,
          )
        : Icon(iconData, size: 20, color: color);
    final tileBg = isActive
        ? foreground.withValues(alpha: isDark ? 0.10 : 0.07)
        : Colors.transparent;
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: tileBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                glyph,
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      spec.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            fontSize: 9,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: color,
                            letterSpacing: 0.1,
                            height: 1.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
