import 'package:flutter/material.dart';

/// Aura Luxury Jewelry — Spacing & Layout Constants
///
/// All spacing, padding, margins, and radii must use these tokens.
/// No magic numbers in widget code.
///
/// Luxury principle: generous whitespace — the product breathes,
/// the UI disappears into the background.
class AppSpacing {
  AppSpacing._();

  // ─────────────────────────────────────────────
  // Spacing Scale
  // ─────────────────────────────────────────────

  /// 4px — Icon-to-text micro gap
  static const double xxs = 4.0;

  /// 8px — Intra-component spacing
  static const double xs = 8.0;

  /// 12px — Tight component spacing
  static const double sm = 12.0;

  /// 16px — Standard gap between components
  static const double md = 16.0;

  /// 20px — Card padding, comfortable gaps
  static const double lg = 20.0;

  /// 24px — Screen horizontal margins, section gaps
  static const double xl = 24.0;

  /// 32px — Between major sections
  static const double xxl = 32.0;

  /// 48px — Hero padding, major visual breaks
  static const double xxxl = 48.0;

  /// 64px — Bottom safe area, top hero padding
  static const double huge = 64.0;

  // ─────────────────────────────────────────────
  // Border Radii
  // ─────────────────────────────────────────────

  /// 12px — Input fields, dialogs, snackbars
  static const double radiusSm = 12.0;

  /// 14px — Product cards, image containers
  static const double radiusMd = 14.0;

  /// 16px — Chips, badges
  static const double radiusLg = 16.0;

  /// 20px — Bottom nav bar top corners, bottom sheets
  static const double radiusXl = 20.0;

  /// 9999px — Pill-shaped buttons (full stadium)
  static const double radiusPill = 9999.0;

  // ─────────────────────────────────────────────
  // Convenience BorderRadius objects
  // ─────────────────────────────────────────────

  static final BorderRadius borderRadiusSm =
      BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd =
      BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg =
      BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl =
      BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusPill =
      BorderRadius.circular(radiusPill);

  // ─────────────────────────────────────────────
  // Layout Constants
  // ─────────────────────────────────────────────

  /// Screen horizontal padding (left + right)
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: xl);

  /// Product grid: 2 columns, generous spacing
  static const int gridColumns = 2;
  static const double gridCrossAxisSpacing = md;
  static const double gridMainAxisSpacing = lg;
  static const double gridChildAspectRatio = 0.62;

  /// Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// Section title bottom margin
  static const double sectionTitleGap = lg;

  /// Bottom nav bar scroll clearance
  static const double bottomNavClearance = 100.0;

  /// Hero banner height
  static const double heroBannerHeight = 360.0;

  /// Category chip diameter
  static const double categoryChipSize = 68.0;

  /// Icon sizes
  static const double iconSizeNav = 22.0;
  static const double iconSizeContent = 24.0;
  static const double iconSizeLarge = 48.0;

  /// Card border width
  static const double hairlineWidth = 1.0;

  /// Focused border width
  static const double focusBorderWidth = 1.5;
}
