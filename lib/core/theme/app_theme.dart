import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light({Color? seedColor}) => _build(
        brightness: Brightness.light,
        seedColor: seedColor ?? AppColors.seed,
      );

  static ThemeData dark({Color? seedColor}) => _build(
        brightness: Brightness.dark,
        seedColor: seedColor ?? AppColors.seed,
      );

  static ThemeData _build({required Brightness brightness, required Color seedColor}) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
    );

    // Overwrite key roles to keep the palette aligned with the app brand.
    final cs = base.colorScheme.copyWith(
      primary: AppColors.primaryTeal,
      secondary: AppColors.secondaryIndigo,
      tertiary: AppColors.tertiarySea,
      background: brightness == Brightness.light ? AppColors.background : base.colorScheme.background,
      surface: brightness == Brightness.light ? AppColors.surface : base.colorScheme.surface,
    );

    return base.copyWith(
      colorScheme: cs,
      scaffoldBackgroundColor: cs.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: cs.onSurface,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Softer fill for a “card-like” input feel.
        fillColor: brightness == Brightness.light
            ? AppColors.surfaceSoft
            : cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(color: cs.outlineVariant),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
      ),
    );
  }
}
