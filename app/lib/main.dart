import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/desktop_lifecycle/single_instance.dart';
import 'core/desktop_lifecycle/tray_lifecycle.dart';
import 'core/network/peer_tokens_provider.dart';
import 'core/storage/preferences_provider.dart';
import 'core/system/network_identity_provider.dart';
import 'core/window/window_mode_provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Item 22 single-instance koruma: SKAPP zaten arka planda (tray'de)
  // calisirken kullanici masaüstü kisayoluna tekrar tiklarsa YENI bir
  // pencere/process acmayalim — onceki SKAPP'in penceresini one getirip
  // kendi sessizce cikalim. Mobile/web ve fail-open durumlarda no-op.
  // tryAcquire()'i WidgetsFlutterBinding sonrasi, runApp'tan once
  // calistiriyoruz; tray + autostart kurulumundan da once (gereksiz
  // baslatma maliyetine girmeyelim ikinci instance ise).
  final acquired = await SingleInstance.instance.tryAcquire();
  if (!acquired) {
    await SingleInstance.instance.signalAndExit();
  }

  // Item 22: autostart entry'si --hidden flag'i ile yazilir. Bu flag
  // gorulurse pencereyi acmadan tray'de baslat (kullanici PC'yi acti,
  // SKAPP arka planda hazir). Normal launch (Start menu, desktop
  // kisayolu, flutter run) bu flag'i tasimaz, pencere normal acilir.
  final startHidden = args.contains(kHiddenStartFlag);

  // SKAPP, telefonda dikey kullanılan bir konfigürasyon aracıdır:
  // yatay/landscape görsel hatalar üretiyor (sticky-note gridi taşıyor,
  // brand block + watermark çakışıyor). Mobil platformlarda portrait'e
  // kilitliyoruz; masaüstü / web'de SystemChrome no-op olduğu için
  // gate gerekmez ama açıkça `Platform.isAndroid || Platform.isIOS`
  // kontrolüyle niyeti netleştiriyoruz.
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
  }

  final prefs = await SharedPreferences.getInstance();

  // Desktop window bootstrap. `ensureInitialized` MUST run before
  // `runApp` so the native plugin channel registers; `waitUntilReadyToShow`
  // however must NOT be awaited — its callback fires inside the Flutter
  // view setup phase which only happens after `runApp`. Awaiting here
  // creates a deadlock where `runApp` never runs, the engine spins on a
  // blank window, and the user sees a partial / empty UI. Fire-and-forget
  // is the documented pattern.
  //
  // Pencere serbest boyutlanabilir: sensible bir laptop boyutuyla
  // baslar, maximize edilir, kullanici manuel resize ile kuculttugunde
  // responsive.dart tablet/mobile layout'a otomatik geciyor.
  if (windowModeSupported) {
    await WindowManager.instance.ensureInitialized();
    // Don't pass `backgroundColor: Color(0x00000000)` here — Windows
    // runner's frame doesn't have Mica/Acrylic backdrop wired up, so a
    // fully-transparent window background lands as "no compositor
    // layer" and the Flutter content fails to paint. Default backdrop
    // (opaque) is the safe choice.
    final options = WindowOptions(
      size: kDesktopInitialSize,
      minimumSize: kDesktopMinimumSize,
      center: true,
      titleBarStyle: TitleBarStyle.normal,
    );
    // Intentionally NOT awaited.
    unawaited(windowManager.waitUntilReadyToShow(options, () async {
      // Item 22: tray + autostart kurulumu. Pencere goruntulemeden
      // ONCE setup cagrilmali — autostart yolunda lifecycle hide()
      // cagiracak, gostermek istemiyoruz. Normal launch'ta setup
      // pencereyi gostermez, asagidaki show/maximize/focus yapar.
      await DesktopLifecycle.instance.setup(startHidden: startHidden);
      if (!startHidden) {
        await windowManager.show();
        try {
          await windowManager.maximize();
        } catch (e) {
          debugPrint('[window] maximize failed: $e');
        }
        await windowManager.focus();
      }
      // Single-instance focus listener: ikinci kez baslatildiginda
      // varolan instance bunu alir ve pencereyi öne getirir (autostart
      // ile gizli baslayip tray'de bekleyen instance da burada
      // pencereyi gosterir). windowManager init bittikten SONRA
      // register etmemiz lazim ki callback'in show/focus cagrilari
      // hazir olsun.
      SingleInstance.instance.listenForFocus(() async {
        try {
          await windowManager.show();
          await windowManager.focus();
        } catch (e) {
          debugPrint('[single-instance] focus restore failed: $e');
        }
      });
    }));
  }

  // Pre-read the bearer token from secure storage so the provider graph
  // can construct `NetworkIdentity` synchronously inside its Notifier.
  // Null is a legitimate value here: first launch, or secure storage
  // unavailable (e.g. Linux without libsecret). Both cases are handled
  // by `NetworkIdentityNotifier.build` via SharedPreferences migration
  // or fresh-token generation.
  String? bearerFromSecure;
  try {
    const storage = FlutterSecureStorage();
    bearerFromSecure = await storage.read(key: bearerTokenSecureKey);
  } catch (e) {
    debugPrint('[secure-storage] bootstrap read failed: $e');
    bearerFromSecure = null;
  }

  // Faz B step 3: per-peer tokens resolved from secure storage. The
  // notifier reads this map synchronously inside `build()` so HMAC
  // verification can stay off the async hot path. Failure here returns
  // an empty map; previously paired phones will hit `unknown_peer` and
  // the user has to re-pair, which matches the secure-storage-missing
  // fallback semantics used for the install bearer above.
  Map<String, String> peerTokens;
  try {
    peerTokens = await resolvePeerTokenBootstrap(prefs);
  } catch (e) {
    debugPrint('[secure-storage] peer-token bootstrap read failed: $e');
    peerTokens = const {};
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        bearerTokenBootstrapProvider.overrideWithValue(bearerFromSecure),
        peerTokenBootstrapProvider.overrideWithValue(peerTokens),
      ],
      child: const SkApp(),
    ),
  );
}
