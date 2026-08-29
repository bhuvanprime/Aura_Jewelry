import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Aura Luxury Jewelry — Typography Scale
///
/// Display & Headlines: Cormorant Garamond (elegant serif)
/// Body & UI: Manrope (refined sans-serif)
///
/// Rules:
/// - Bold (w600+) reserved for prices and CTA labels ONLY
/// - Body text never exceeds w400
/// - All-caps only on labelSmall/labelMedium with generous letter-spacing
/// - Line height: body ≥ 1.5x, headlines ≥ 1.2x
class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────────
  // Font Family Helpers
  // ─────────────────────────────────────────────

  static TextStyle _cormorant({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
    double height = 1.3,
    Color color = AppColors.charcoal,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle _manrope({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
    double height = 1.5,
    Color color = AppColors.charcoal,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  // ─────────────────────────────────────────────
  // Full TextTheme (14 slots)
  // ─────────────────────────────────────────────

  static TextTheme get textTheme {
    return TextTheme(
      // ── Display: Serif, large hero text ──
      displayLarge: _cormorant(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        height: 1.2,
      ),
      displayMedium: _cormorant(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        height: 1.25,
      ),
      displaySmall: _cormorant(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.3,
      ),

      // ── Headlines: Serif, section/product titles ──
      headlineLarge: _cormorant(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.35,
      ),
      headlineMedium: _cormorant(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        height: 1.35,
      ),
      headlineSmall: _cormorant(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.4,
      ),

      // ── Title: Sans-serif, prominent UI labels ──
      titleLarge: _manrope(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleMedium: _manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleSmall: _manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      ),

      // ── Body: Sans-serif, regular weight, generous line-height ──
      bodyLarge: _manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: _manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodySmall: _manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.charcoalMuted,
      ),

      // ── Labels: Sans-serif, medium weight, letter-spaced ──
      labelLarge: _manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        height: 1.0,
      ),
      labelMedium: _manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        height: 1.0,
      ),
      labelSmall: _manrope(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        height: 1.0,
        color: AppColors.charcoalMuted,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Semantic Shortcuts (for common one-off styles)
  // ─────────────────────────────────────────────

  /// Price display: bold sans-serif in maroon deep
  static TextStyle get price => _manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.maroonDeep,
        height: 1.2,
      );

  /// Price on cards: slightly smaller, maroon deep
  static TextStyle get priceSmall => _manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.maroonDeep,
        height: 1.2,
      );

  /// Eyebrow label: all-caps overline above sections
  static TextStyle get eyebrow => _manrope(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.8,
        height: 1.0,
        color: AppColors.auraGoldLight,
      );

  /// Rate bar text: small bold
  static TextStyle get rateBar => _manrope(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        height: 1.0,
        color: AppColors.maroonBlack,
      );

  /// Section link: small bold gold
  static TextStyle get sectionLink => _manrope(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: AppColors.auraGold,
      );

  /// Certified tag: tiny bold
  static TextStyle get certifiedTag => _manrope(
        fontSize: 7.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        height: 1.0,
        color: AppColors.maroonBlack,
      );

  /// Product weight info: tiny sandstone
  static TextStyle get productWeight => _manrope(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.charcoalMuted,
      );
}
