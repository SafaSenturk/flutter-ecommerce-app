import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extra design tokens that Material's ColorScheme has no slot for.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.muted,
    required this.border,
    required this.inkSoft,
    required this.accentSoft,
    required this.success,
    required this.star,
  });

  final Color muted;
  final Color border;
  final Color inkSoft;
  final Color accentSoft;
  final Color success;
  final Color star;

  static const light = AppColors(
    muted: Color(0xFFEEECE6),
    border: Color(0xFFE6E3DC),
    inkSoft: Color(0xFF6B6B76),
    accentSoft: Color(0xFFFFE6DF),
    success: Color(0xFF1E9E6A),
    star: Color(0xFFFFB020),
  );

  static const dark = AppColors(
    muted: Color(0xFF222228),
    border: Color(0xFF2C2C33),
    inkSoft: Color(0xFF9A9AA5),
    accentSoft: Color(0xFF3A211B),
    success: Color(0xFF3CCB8F),
    star: Color(0xFFFFC043),
  );

  @override
  AppColors copyWith({
    Color? muted,
    Color? border,
    Color? inkSoft,
    Color? accentSoft,
    Color? success,
    Color? star,
  }) =>
      AppColors(
        muted: muted ?? this.muted,
        border: border ?? this.border,
        inkSoft: inkSoft ?? this.inkSoft,
        accentSoft: accentSoft ?? this.accentSoft,
        success: success ?? this.success,
        star: star ?? this.star,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      star: Color.lerp(star, other.star, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  ColorScheme get scheme => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}

abstract final class AppTheme {
  static const accent = Color(0xFFFF5A36);
  static const radius = 20.0;

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: const Color(0xFFF5F4F0),
        surface: Colors.white,
        ink: const Color(0xFF15151A),
        tokens: AppColors.light,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: const Color(0xFF0E0E11),
        surface: const Color(0xFF18181C),
        ink: const Color(0xFFF4F3EF),
        tokens: AppColors.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color ink,
    required AppColors tokens,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      secondary: ink,
      onSecondary: background,
      error: const Color(0xFFE5484D),
      onError: Colors.white,
      surface: surface,
      onSurface: ink,
      surfaceContainerHighest: tokens.muted,
      outline: tokens.border,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: background,
      extensions: [tokens],
      splashFactory: InkSparkle.splashFactory,
    );

    final text = base.textTheme.apply(bodyColor: ink, displayColor: ink).copyWith(
          headlineMedium: base.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.8, color: ink),
          headlineSmall: base.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5, color: ink),
          titleLarge: base.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3, color: ink),
          titleMedium: base.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: ink),
          labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        );

    final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.w800),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          foregroundColor: ink,
          side: BorderSide(color: tokens.border, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: TextStyle(color: tokens.inkSoft, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: ink,
        side: BorderSide(color: tokens.border),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w600, color: ink),
        secondaryLabelStyle:
            TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w600, color: background),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF2A2A31) : ink,
        contentTextStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: isDark ? ink : background,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: accent,
        shape: rounded,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerTheme: DividerThemeData(color: tokens.border, space: 1, thickness: 1),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: tokens.muted,
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
