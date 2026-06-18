// Item 22: SKAPP desktop iki state'li. Pencere X butonu uygulamayi
// kapatmaz, tray'e indirir; cihaz listener'lari (BF webhook, BLE
// scanner, mDNS browse, SKAPI tetikleyici) arka planda kesintisiz
// calismaya devam eder. Tam kapatma sadece tray sag tik > Cikis.
// OS basinda zorunlu autostart (--hidden flag'i ile gizli baslar).
//
// Mobile (Android/iOS) ve Web: bu mantik UYGULANMAZ. Gate `desktopLifecycleSupported`.
//
// Detay karar memory: project_desktop_tray_background.md

import 'dart:async';
import 'dart:io' show File, Platform, exit;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:win32_registry/win32_registry.dart';
import 'package:window_manager/window_manager.dart';

/// Autostart entry'sine bu CLI flag'i ile yazilir. main() bu flag'i
/// gorurse pencereyi acmadan tray'de baslatir.
const String kHiddenStartFlag = '--hidden';

// Windows tray native LoadImage(LR_LOADFROMFILE) cagriyor: asset bundle
// path'i degil DISK uzerinde mutlak path bekliyor. Asset'ler bundle'da
// `<exe_dir>\data\flutter_assets\<asset_path>` altinda; runtime'da
// resolvedExecutable'dan hesapliyoruz. .ico format Windows tray icin
// dogru secenek (PNG yuklenince fallback gri/yesil placeholder geliyor).
const String _kTrayIconAssetWindows = 'assets/branding/tray.ico';
const String _kTrayIconAssetMacLinux = 'assets/branding/logo_black.png';

const String _kMenuItemShow = 'sk_tray_show';
const String _kMenuItemQuit = 'sk_tray_quit';

/// SharedPreferences key: pencerenin tray'e ilk indirildigi anda set edilir.
/// `true` ise sonraki kapatmalarda bilgi toast'i yayinlanmaz. Factory Reset
/// SharedPreferences.clear() ile beraber bu flag'i da temizler, yeni kurulum
/// kullanicisi toast'i tekrar gorebilir.
const String _kTrayFirstHideSeenKey = 'tray_first_hide_seen';

/// Toast'in gorunur kalmasi icin gizleme islemini geciktirdigimiz sure.
/// SnackBar render edildikten sonra pencere kapaniyor; kullanici mesajl
/// gorebilsin diye 3.5 saniye bekliyoruz (SnackBar varsayilan duration
/// 4 sn, 0.5 sn marj birakiyoruz). Ikinci kapatmada delay yok.
const Duration _kFirstHideToastDelay = Duration(milliseconds: 3500);

bool get desktopLifecycleSupported {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

class DesktopLifecycle with WindowListener, TrayListener {
  DesktopLifecycle._();

  static final DesktopLifecycle instance = DesktopLifecycle._();

  bool _initialized = false;

  /// Pencere ilk kez tray'e indirildiginde tek event yayinlar; sonraki
  /// kapatmalarda sessiz kalir. MainShell bu stream'i dinleyip SnackBar
  /// gosterir (BuildContext gerekiyor, lifecycle layer'inda yok).
  final StreamController<void> _firstHideController =
      StreamController<void>.broadcast();
  Stream<void> get firstHideEvents => _firstHideController.stream;

  /// Tray + autostart entegrasyonu. Mobile/web no-op.
  ///
  /// `startHidden` true ise pencere goruntulenmez (autostart yolu).
  /// false ise normal pencere acilir; tray ikonu yine de yerlestirilir.
  Future<void> setup({required bool startHidden}) async {
    if (!desktopLifecycleSupported) return;
    if (_initialized) return;
    _initialized = true;

    // X butonu interceptor: window_manager preventClose true iken
    // pencere kapatma istegi onWindowClose'a dusulur, biz orada
    // hide() cagiririz. setQuitOnClose(true)'u native runner zaten
    // ayarladi; preventClose o davranisin onunde calisir.
    try {
      await windowManager.setPreventClose(true);
      windowManager.addListener(this);
    } catch (e) {
      debugPrint('[desktop-lifecycle] preventClose setup failed: $e');
    }

    await _setupTray();
    await _setupAutostart();

    // Autostart ile gelindiyse pencereyi gizle. Normal launch'ta
    // main.dart pencereyi gosterir (waitUntilReadyToShow callback'i).
    if (startHidden) {
      try {
        await windowManager.hide();
      } catch (e) {
        debugPrint('[desktop-lifecycle] hide on autostart failed: $e');
      }
    }
  }

  Future<void> _setupTray() async {
    try {
      final assetRelative = Platform.isWindows
          ? _kTrayIconAssetWindows
          : _kTrayIconAssetMacLinux;
      final iconPath = _resolveBundledAssetPath(assetRelative);
      debugPrint('[desktop-lifecycle] tray icon = $iconPath');
      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('SKAPP');
      await trayManager.setContextMenu(_buildMenu());
      trayManager.addListener(this);
    } catch (e) {
      debugPrint('[desktop-lifecycle] tray setup failed: $e');
    }
  }

  /// Bundle'daki bir asset'in disk uzerindeki mutlak yolunu hesaplar.
  /// Windows ve Linux'ta `<exe_dir>/data/flutter_assets/<asset_path>`;
  /// macOS'ta `<exe_dir>/../Frameworks/App.framework/Resources/flutter_assets/`.
  /// tray_manager native plugin'lerinin disk-path'e ihtiyaci var.
  String _resolveBundledAssetPath(String assetRelative) {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final sep = Platform.pathSeparator;
    final normalized = assetRelative.replaceAll('/', sep);
    if (Platform.isMacOS) {
      return '$exeDir$sep..${sep}Frameworks${sep}App.framework'
          '${sep}Resources${sep}flutter_assets$sep$normalized';
    }
    return '$exeDir${sep}data${sep}flutter_assets$sep$normalized';
  }

  Menu _buildMenu() {
    return Menu(items: <MenuItem>[
      MenuItem(key: _kMenuItemShow, label: "SKAPP'i Ac"),
      MenuItem.separator(),
      MenuItem(key: _kMenuItemQuit, label: 'Cikis'),
    ]);
  }

  Future<void> _setupAutostart() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final exe = Platform.resolvedExecutable;
      // Sanity: dosya yoksa autostart entry'si kirik kalir, hic yazma.
      if (!await File(exe).exists()) {
        debugPrint('[desktop-lifecycle] resolvedExecutable missing: $exe');
        return;
      }
      launchAtStartup.setup(
        appName: info.appName,
        appPath: exe,
        args: const <String>[kHiddenStartFlag],
      );
      await launchAtStartup.enable();
    } catch (e) {
      debugPrint('[desktop-lifecycle] autostart enable failed: $e');
    }
  }

  // WindowListener

  @override
  void onWindowClose() async {
    // preventClose true oldugu icin native WM_CLOSE bize geliyor.
    // Davranis: pencereyi gizle (tray'e indir), process'i sonlandirma.
    try {
      final prevent = await windowManager.isPreventClose();
      if (!prevent) return;

      // Ilk kapatmada bilgi toast'i yayinla + pencereyi gizlemeyi
      // gecikt­ir, kullanici mesaji okusun. Flag SharedPreferences'ta
      // tutulur; ayni install'da bir daha tetiklenmez.
      final firstTime = await _consumeFirstHideFlag();
      if (firstTime && !_firstHideController.isClosed) {
        _firstHideController.add(null);
        await Future<void>.delayed(_kFirstHideToastDelay);
      }
      await windowManager.hide();
    } catch (e) {
      debugPrint('[desktop-lifecycle] onWindowClose hide failed: $e');
    }
  }

  /// `true` doner: bu install'da pencere ilk kez tray'e iniyor; flag'i
  /// kalici olarak true'ya cevirir. Sonraki cagrilar `false` doner.
  /// Hata olursa (SharedPreferences acilamadi) `false` doner: emin
  /// olmadigimiz durumda toast gostermemek daha az rahatsiz edici.
  Future<bool> _consumeFirstHideFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_kTrayFirstHideSeenKey) == true) return false;
      await prefs.setBool(_kTrayFirstHideSeenKey, true);
      return true;
    } catch (e) {
      debugPrint('[desktop-lifecycle] first-hide flag read failed: $e');
      return false;
    }
  }

  // TrayListener

  @override
  void onTrayIconMouseDown() async {
    // Sol tik: pencereyi getir + odakla. Windows konvansiyonu.
    await _restoreWindow();
  }

  @override
  void onTrayIconRightMouseDown() async {
    // Sag tik: context menu. macOS otomatik gosterir, Windows/Linux'ta
    // popUp cagirmak gerekiyor.
    try {
      await trayManager.popUpContextMenu();
    } catch (e) {
      debugPrint('[desktop-lifecycle] popUpContextMenu failed: $e');
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case _kMenuItemShow:
        await _restoreWindow();
        break;
      case _kMenuItemQuit:
        await _quitFully();
        break;
    }
  }

  Future<void> _restoreWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (e) {
      debugPrint('[desktop-lifecycle] restore failed: $e');
    }
  }

  /// Gercek cikis. Eski yol `windowManager.destroy()` cagiriyordu
  /// ama Flutter engine graceful shutdown (GPU resources, isolate
  /// teardown, plugin disposal) 3-4 saniye suruyor ve kullanici
  /// pencerenin once cokup/donup sonra kapandigini goruyordu.
  ///
  /// Yeni yol: kullaniciya gorunur islemler INSTANT (pencereyi gizle,
  /// tray ikonunu kaldir — her ikisi de <100ms native call), sonra
  /// `exit(0)` ile OS-level termination. Tum persistent state (Shared-
  /// Preferences, secure storage, BondStore) zaten kullanici click'ten
  /// once async olarak diske yazilmis durumdadir; quit-anlik flush
  /// gereken bir state yok.
  Future<void> _quitFully() async {
    // 1) Pencereyi gizle: kullanici ekranda anlik kayboldugunu gorur
    try {
      await windowManager.hide();
    } catch (e) {
      debugPrint('[desktop-lifecycle] hide on quit failed: $e');
    }
    // 2) Tray ikonu (rogue ikon kalmasin — Windows tray bazen process
    //    ölunce hemen temizlemiyor, manuel destroy hizli ve garantili)
    try {
      await trayManager.destroy();
    } catch (e) {
      debugPrint('[desktop-lifecycle] tray destroy failed: $e');
    }
    // 3) OS-level exit; Flutter engine teardown (GPU+isolate+plugin) ile
    //    ugrasmiyoruz, OS process'i ve tum kaynaklarini reclaim eder.
    exit(0);
  }

  /// Factory Reset için: Windows autostart registry entry'sini siler.
  /// launch_at_startup paketinde `disable()` API'si YOK (v0.5.1), o yüzden
  /// win32_registry ile manuel `HKCU\Software\Microsoft\Windows\
  /// CurrentVersion\Run\<appName>` value'sunu siliyoruz. macOS/Linux için
  /// Faz 2 desktop'a ertelendi.
  ///
  /// `true` döner: entry vardı ve silindi (ya da zaten yoktu).
  /// `false` döner: silme sırasında hata oluştu.
  Future<bool> unregisterAutostart() async {
    if (!desktopLifecycleSupported) return true;
    if (!Platform.isWindows) {
      debugPrint('[desktop-lifecycle] autostart unregister: '
          'platform ${Platform.operatingSystem} not implemented yet, no-op');
      return true;
    }
    try {
      final info = await PackageInfo.fromPlatform();
      final key = Registry.openPath(
        RegistryHive.currentUser,
        path: r'Software\Microsoft\Windows\CurrentVersion\Run',
        desiredAccessRights: AccessRights.allAccess,
      );
      // Value yoksa deleteValue ArgumentError firlatabiliyor; mevcut mu
      // diye getStringValue ile bakıyoruz, varsa silip aksi halde
      // sessizce gecitiyoruz (idempotent).
      final existing = key.getStringValue(info.appName);
      if (existing != null) {
        key.deleteValue(info.appName);
        debugPrint('[desktop-lifecycle] autostart entry removed: '
            '${info.appName} = $existing');
      } else {
        debugPrint('[desktop-lifecycle] autostart entry already absent');
      }
      key.close();
      return true;
    } catch (e) {
      debugPrint('[desktop-lifecycle] autostart unregister failed: $e');
      return false;
    }
  }
}
