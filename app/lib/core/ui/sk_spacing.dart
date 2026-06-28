import 'package:flutter/widgets.dart';

/// Merkezi spacing ölçeği (4-tabanlı). Kod tabanındaki gözlemlenen örtük
/// ölçeği (4/8/12/16/24) tek yere toplar; yeni kod magic-number
/// `EdgeInsets.all(12)` yerine `SkSpacing.md` kullanmalı. Mevcut yerler
/// kademeli olarak buna göçürülür (tasarım cilası — Faz B).
abstract final class SkSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Bölümler arası dikey ritim (dashboard'larda yaygın 18 px).
  static const double section = 18;

  // Hazır SizedBox boşlukları (Column/Row arasında).
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
}
