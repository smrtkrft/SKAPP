// Desktop pencere bootstrap'i. Eskiden "maximize / mini" toggle vardi
// (Settings'te cycle card); kullanici mini moda alinca title bar X
// butonu kayboluyor ve pencere ekran altina taşıyordu, toggle kaldirildi
// (2026-05-13). Pencere artik serbest boyutlanabilir; sadece sensible
// default + maximize ile baslar. Kullanici manuel olarak pencereyi
// kuculttuğunde `responsive.dart` SkBreakpoints'a gore tablet/mobile
// layout zaten otomatik devreye giriyor.
//
// Bu dosyada artik sadece platform gate var: mobile/web `window_manager`
// API'lerine sahip degil, native pencere yok demektir.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Native pencere host edebilen platformlar. Mobile, web, ve CI snapshot'lari
/// false doner; window_manager cagrilari bu gate ile atlanir.
bool get windowModeSupported {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

/// Desktop bootstrap'inda WindowOptions'a verilen baslangic boyutu.
/// Maximize edilmeden once kisaca goruntulenecegi icin sensible bir
/// laptop boyutu (1280x800) sectik. Maximize uygulandiktan sonra
/// kullanici unmaximize ederse bu boyuta doner.
const Size kDesktopInitialSize = Size(1280, 800);

/// Manual resize altsiniri. Bundan kucuk degerler `responsive.dart`
/// breakpoint'lerinin altina dustugu icin layout zaten mobile'a gecer;
/// ama 640x480'in altinda `IndexedStack` cocuklari icin sefil bir
/// alan kaliyor, en kucuk anlamli pencere boyutu olarak bu degeri
/// kilitliyoruz.
const Size kDesktopMinimumSize = Size(640, 480);
