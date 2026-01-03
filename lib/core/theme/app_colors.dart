import 'package:flutter/material.dart';

/// Palette tuned to a calm "mental wellness" look (Wysa-style).
/// This file is the SINGLE SOURCE OF TRUTH for colors.
/// Do NOT remove fields without checking screen usage.
class AppColors {
  // ---------------------------------------------------------------------------
  // Core brand tones
  // ---------------------------------------------------------------------------

  /// Primary teal (main actions)
  static const Color primaryTeal = Color(0xFF1E8E8A);

  /// Supporting indigo (cards, accents)
  static const Color secondaryIndigo = Color(0xFF3B4CC0);

  /// Soft sea tone (background accents)
  static const Color tertiarySea = Color(0xFF4DB6AC);

  // ---------------------------------------------------------------------------
  // Neutrals / surfaces
  // ---------------------------------------------------------------------------

  static const Color background = Color(0xFFF3F6F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF7FAFC);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  /// Main text (titles)
  static const Color ink = Color(0xFF0F172A);

  /// Muted text (subtitles, hints)
  static const Color inkMuted = Color(0xFF64748B);

  // ---------------------------------------------------------------------------
  // Borders / dividers
  // ---------------------------------------------------------------------------

  static const Color outline = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Theme seed (used by MaterialColorScheme)
  // ---------------------------------------------------------------------------

  static const Color seed = primaryTeal;

  // ---------------------------------------------------------------------------
  // BACKWARD-COMPATIBILITY ALIASES
  // ⚠️ These are REQUIRED because older screens still reference them.
  // ---------------------------------------------------------------------------

  /// Used across many screens
  static const Color primary = primaryTeal;

  /// Used in icons, highlights
  static const Color accent = secondaryIndigo;

  /// Used in TextStyle(color: AppColors.text)
  static const Color text = ink;

  /// Used in TextStyle(color: AppColors.textMuted)
  static const Color textMuted = inkMuted;

  /// Used in BoxDecoration / Border
  static const Color border = outline;

  /// Used by cards / chips
  static const Color primarySoft = Color(0xFFBFE9E6);
}
