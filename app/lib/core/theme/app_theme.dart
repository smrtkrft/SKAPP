import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: SkColors.cream,
        foreground: SkColors.black,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: SkColors.darkBg,
        foreground: SkColors.darkFg,
      );

  /// Tam ColorScheme: Material 3 token'larının HEPSİ açık şekilde
  /// tanımlanır. Aksi halde dark mode'da `onSurfaceVariant`,
  /// `surfaceContainerLow` gibi kritik token'lar default'a düşer ve
  /// metinler yanlış renkle (görünmez gri-üstüne-gri) çizilir.
  ///
  /// Light: krem zemin + siyah yazı, sırtüstü konteynerler hafifçe
  /// koyulaşan krem tonları.
  /// Dark: warm-black zemin + warm off-white yazı, sırtüstü konteynerler
  /// hafifçe açılan kahverengimsi karanlık tonlar.
  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color foreground,
  }) {
    final isDark = brightness == Brightness.dark;

    // Surface container kademesi · M3 Elevation Surface Tint pattern.
    // Light'ta krem'den hafifçe koyu doğru kademeli, dark'ta warm-black'ten
    // hafifçe açık doğru kademeli. Tek bir merkez palet, tematik tutarlı.
    final surfaceLowest = isDark ? const Color(0xFF060604) : const Color(0xFFFDFAF3);
    final surfaceLow    = isDark ? const Color(0xFF15130F) : const Color(0xFFF0EAD8);
    final surface       = background; // krem ya da warm-black
    final surfaceHigh   = isDark ? const Color(0xFF1F1D18) : const Color(0xFFEBE5D2);
    final surfaceHigher = isDark ? const Color(0xFF25221C) : const Color(0xFFE6DFCA);
    final surfaceTop    = isDark ? const Color(0xFF2B2820) : const Color(0xFFE0D8C0);

    final onSurface          = foreground;
    final onSurfaceVariant   = foreground.withValues(alpha: 0.70);
    final outline            = foreground.withValues(alpha: 0.25);
    final outlineVariant     = foreground.withValues(alpha: 0.12);
    final shadow             = Colors.black;
    final inverseSurface     = isDark ? SkColors.cream : SkColors.darkBg;
    final onInverseSurface   = isDark ? SkColors.black : SkColors.darkFg;

    final colorScheme = ColorScheme(
      brightness: brightness,
      // Primary (interaktif/CTA): mevcut foreground/background ile aynı,
      // bu sayede ElevatedButton vs. değişmez.
      primary:            foreground,
      onPrimary:          background,
      primaryContainer:   surfaceHigh,
      onPrimaryContainer: foreground,
      secondary:            foreground,
      onSecondary:          background,
      secondaryContainer:   surfaceHigh,
      onSecondaryContainer: foreground,
      tertiary:            SkColors.attentionMustard,
      onTertiary:          SkColors.black,
      tertiaryContainer:   SkColors.attentionMustard.withValues(alpha: 0.18),
      onTertiaryContainer: foreground,
      error:           SkColors.warnRed,
      onError:         SkColors.white,
      errorContainer:  SkColors.warnRed.withValues(alpha: isDark ? 0.20 : 0.12),
      onErrorContainer: isDark ? SkColors.darkFg : SkColors.warnRed,
      surface:                  surface,
      onSurface:                onSurface,
      surfaceDim:               isDark ? const Color(0xFF080706) : const Color(0xFFE8E1CD),
      surfaceBright:            isDark ? const Color(0xFF2D2A22) : const Color(0xFFFDFAF3),
      surfaceContainerLowest:   surfaceLowest,
      surfaceContainerLow:      surfaceLow,
      surfaceContainer:         surface,
      surfaceContainerHigh:     surfaceHigh,
      surfaceContainerHighest:  surfaceHigher,
      onSurfaceVariant:         onSurfaceVariant,
      outline:                  outline,
      outlineVariant:           outlineVariant,
      shadow:                   shadow,
      scrim:                    shadow,
      inverseSurface:           inverseSurface,
      onInverseSurface:         onInverseSurface,
      inversePrimary:           background,
      surfaceTint:              surfaceTop,
    );

    final baseText = Typography.englishLike2021.apply(
      bodyColor: foreground,
      displayColor: foreground,
    );
    final interText = GoogleFonts.interTextTheme(baseText).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.8,
        color: foreground,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.6,
        color: foreground,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.4,
        color: foreground,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2,
        color: foreground,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: foreground,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: foreground,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: foreground,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400, height: 1.45,
        color: foreground,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.45,
        color: foreground,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
        color: foreground.withValues(alpha: 0.75),
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1,
        color: foreground,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.6,
        color: foreground.withValues(alpha: 0.8),
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.4,
        color: foreground.withValues(alpha: 0.7),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: interText,
      primaryTextTheme: interText,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: interText.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: foreground.withValues(alpha: 0.08),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? foreground : foreground.withValues(alpha: 0.5),
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: selected ? foreground : foreground.withValues(alpha: 0.5),
          );
        }),
      ),
      iconTheme: IconThemeData(color: foreground),
      dividerTheme: DividerThemeData(
        color: foreground.withValues(alpha: 0.12),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: foreground,
        textColor: foreground,
      ),
      // Tactile redesign · text input alanları yumuşak fill + minimal border.
      // V2 well felsefesine uygun: input alanı zemine "gömülmüş" hisseder,
      // outline border yerine düşük alpha border + krem-darker fill.
      // Focus durumda hardal sarısı vurgu (1.5 px), siyah outline kalın
      // border yok.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.04),
        labelStyle: interText.bodyMedium?.copyWith(
          color: foreground.withValues(alpha: 0.7),
        ),
        hintStyle: interText.bodyMedium?.copyWith(
          color: foreground.withValues(alpha: 0.45),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: foreground.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: foreground.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: SkColors.attentionMustard, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SkColors.warnRed.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: SkColors.warnRed, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: foreground,
          foregroundColor: background,
          textStyle: interText.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          side: BorderSide(color: foreground.withValues(alpha: 0.4)),
          textStyle: interText.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          textStyle: interText.labelLarge,
        ),
      ),
      // Tactile redesign · dialog ve popup yüzeyleri.
      // AlertDialog ve Dialog'lar scaffold bg (krem) zemine soft drop shadow
      // ile oturur. Köşe radius 16, surfaceTintColor kapalı (M3'in default
      // mavi shade'i krem/siyah palete uymuyor).
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        titleTextStyle: interText.titleLarge,
        contentTextStyle: interText.bodyMedium,
      ),
      // Bottom sheet'ler (modal): aynı krem zemin, üst köşeler radius 20.
      // Drag handle Material default'una bırakılır.
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: background,
        modalElevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
      ),
      // SnackBar: floating davranış + krem zemine raised neumorphic gölge
      // taklit eden Material elevation. İçerik metni Inter ile aynı.
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? surfaceHigh : surfaceLow,
        contentTextStyle: interText.bodyMedium?.copyWith(color: onSurface),
        actionTextColor: SkColors.attentionMustard,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
