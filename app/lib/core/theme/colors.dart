import 'package:flutter/material.dart';

/// SmartKraft brand colors.
/// Strict rule: only these tokens. Any other color requires explicit user
/// approval. Both light and dark themes share the same accent palette
/// (mustard + warn-red); only the neutral pair flips.
class SkColors {
  SkColors._();

  // ── Neutral pair · light tema ────────────────────────────────────
  static const Color black = Color(0xFF0A0A0A);

  /// Light-theme background. "Dirty white" / eggshell, off-white with a
  /// barely perceptible warm tint. Not cream (was too yellow), not pure white
  /// (was too harsh). Easy on the eyes for long reading sessions.
  static const Color cream = Color(0xFFF5F2EC);
  static const Color white = Color(0xFFF5F5F5);

  // ── Neutral pair · dark tema (warm-black palette) ────────────────
  /// Dark-theme background. Warm-black, not pure black; kraft kâğıt
  /// karanlığı hissi. SkColors.black ile aynı değil, dark mode için
  /// özel olarak ayrı tutuluyor.
  static const Color darkBg = Color(0xFF0E0D0A);

  /// Dark-theme surface containers için bir adım daha açık warm-black.
  static const Color darkBgRaised = Color(0xFF1F1D18);

  /// Dark-theme yazı/ikon rengi. Saf beyaz değil, warm off-white,
  /// uzun bakışta göz yormaz, krem palettesinin ton dengesini korur.
  static const Color darkFg = Color(0xFFF5EFDE);

  // ── Accent (her iki tema) ────────────────────────────────────────
  static const Color warnRed = Color(0xFFD32F2F);
  static const Color attentionMustard = Color(0xFFD4A017);

  // ── Neumorphic tactile · light tema ──────────────────────────────
  /// Tactile redesign'ın ana zemini (light). Krem'in biraz daha sıcak/koyu
  /// kuzeni; neumorphic raised kartların çift gölgesi bu zeminde doğru
  /// kontrast veriyor. SkCard ile çatışmaz, mevcut surfaceContainerLow
  /// (#F0EAD8) zeminin üstüne çıkar.
  static const Color neuBg = Color(0xFFEBE6D8);

  /// Neumorphic raised gölge · top-left'ten gelen ışık.
  static const Color neuShadowLight = Color(0xFFFFFBED);

  /// Neumorphic raised gölge · bottom-right'tan düşen koyu ton.
  /// rgba(120,108,86,0.30) Color formuna çevrilmiş.
  static const Color neuShadowDark = Color(0x4D786C56);

  // ── Neumorphic tactile · dark tema ───────────────────────────────
  /// Dark tema neumorphic zemini. darkBgRaised'tan biraz daha açık,
  /// gölge kontrastı için. Yeni primitif sk_neu_card kullanıldığında
  /// dark tema şu an darkBg'ye düşer; ileride Faz B'de kalibre edilecek.
  static const Color neuBgDark = Color(0xFF1A1814);
  static const Color neuShadowLightDark = Color(0xFF2A2620);
  static const Color neuShadowDarkDark = Color(0xCC000000);
}
