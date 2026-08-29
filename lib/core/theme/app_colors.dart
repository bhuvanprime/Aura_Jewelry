import 'package:flutter/material.dart';

/// Aura Luxury Jewelry — Semantic Color Tokens
///
/// Rajwada / Mughal-inspired palace palette.
/// Deep maroon & antique gold are the signature colors.
///
/// Design principle: regal, warm, handcrafted — deep maroon
/// paired with antique gold accents on ivory backgrounds.
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // Backgrounds & Surfaces
  // ─────────────────────────────────────────────

  /// Primary scaffold/page background — warm ivory
  static const Color sandal = Color(0xFFF8F1E0);

  /// Elevated surface containers (cards, sheets, nav bar)
  static const Color sandalDark = Color(0xFFEDE7DA);

  /// Pressed/hover surface state, skeleton shimmer base
  static const Color sandalDeep = Color(0xFFE5DDD0);

  /// Card interiors, input field backgrounds
  static const Color warmWhite = Color(0xFFFFFFFF);

  /// Transparent color
  static const Color transparent = Colors.transparent;

  // ─────────────────────────────────────────────
  // Brand — Antique Gold
  // ─────────────────────────────────────────────

  /// Signature accent — CTAs, active states, rate bar
  static const Color auraGold = Color(0xFFB8863B);

  /// Gold highlight — dividers, icon tint, shimmer peaks
  static const Color auraGoldLight = Color(0xFFE4C77E);

  /// Soft gold — borders, inactive gold elements
  static const Color auraGoldMuted = Color(0x59B8863B); // ~35% opacity

  // ─────────────────────────────────────────────
  // Brand — Maroon (Rajwada)
  // ─────────────────────────────────────────────

  /// Deep maroon — header gradient start, active nav, category icons
  static const Color maroonDeep = Color(0xFF5C0F1E);

  /// Dark maroon-black — header gradient end, hero gradient end
  static const Color maroonBlack = Color(0xFF2B0710);

  // ─────────────────────────────────────────────
  // Text
  // ─────────────────────────────────────────────

  /// Primary text — warm deep brown-black
  static const Color charcoal = Color(0xFF241812);

  /// Secondary text — sandstone descriptions, labels
  static const Color charcoalMuted = Color(0xFF8C7A5C);

  /// Tertiary text — hints, placeholders, captions
  static const Color charcoalFaint = Color(0xFFA89880);

  // ─────────────────────────────────────────────
  // Hero Gradient (maroon deep → maroon black)
  // ─────────────────────────────────────────────

  /// Hero gradient start — deep royal maroon
  static const Color magentaDeep = Color(0xFF5C0F1E);

  /// Hero gradient end — dark maroon-black
  static const Color blushPink = Color(0xFF2B0710);

  // ─────────────────────────────────────────────
  // Borders & Dividers
  // ─────────────────────────────────────────────

  /// Card borders, primary dividers — gold-tinted
  static const Color hairline = Color(0x40B8863B); // ~25% gold

  /// Subtle separators, section dividers
  static const Color hairlineLight = Color(0x25B8863B); // ~15% gold

  // ─────────────────────────────────────────────
  // Status Colors (muted, never saturated)
  // ─────────────────────────────────────────────

  /// Muted sage green — "Available" / success status
  static const Color success = Color(0xFF7A9B6D);

  /// Muted warm gray — "Made to order" / unavailable status
  static const Color unavailable = Color(0xFFB8A99A);

  /// Muted terracotta — form errors, validation
  static const Color error = Color(0xFFC4756A);

  /// Bright red — wishlisted heart
  static const Color wishlistActive = Color(0xFFE53935);

  // ─────────────────────────────────────────────
  // Gradients
  // ─────────────────────────────────────────────

  /// Hero banner gradient — maroon deep → maroon black (150°)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [maroonDeep, maroonBlack],
  );

  /// Header gradient — maroon deep → maroon black (150°)
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment(-0.5, -0.5),
    end: Alignment(0.5, 0.5),
    colors: [maroonDeep, maroonBlack],
  );

  /// Primary CTA button fill — deep maroon → maroon black
  static const LinearGradient maroonCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [maroonDeep, maroonBlack],
  );

  /// Primary CTA button fill — gold light → gold antique
  static const LinearGradient goldCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [auraGoldLight, auraGold],
  );

  /// Product card image background — maroon with gold radial
  static const LinearGradient productImageGradient = LinearGradient(
    begin: Alignment(-0.4, -0.8),
    end: Alignment(0.4, 0.8),
    colors: [maroonDeep, maroonBlack],
  );

  /// Skeleton loading shimmer — gold-tinted sweep
  static const LinearGradient shimmerGold = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [sandalDeep, Color(0xFFE4C77E), sandalDeep],
  );

  // ─────────────────────────────────────────────
  // Legacy Compatibility Aliases
  // (Remove these once all widgets migrate to new tokens)
  // ─────────────────────────────────────────────

  /// @deprecated Use [auraGold] instead
  static const Color primary = auraGold;

  /// @deprecated Use [auraGoldLight] instead
  static const Color primaryContainer = auraGoldLight;

  /// @deprecated Use [charcoal] instead
  static const Color onPrimaryContainer = charcoal;

  /// @deprecated Use [warmWhite] instead
  static const Color onPrimary = warmWhite;

  /// @deprecated Use [sandal] instead
  static const Color surface = sandal;

  /// @deprecated Use [sandalDeep] instead
  static const Color surfaceContainer = sandalDeep;

  /// @deprecated Use [sandalDark] instead
  static const Color surfaceContainerLow = sandalDark;

  /// @deprecated Use [warmWhite] instead
  static const Color surfaceContainerLowest = warmWhite;

  /// @deprecated Use [charcoal] instead
  static const Color onSurface = charcoal;

  /// @deprecated Use [charcoalMuted] instead
  static const Color onSurfaceVariant = charcoalMuted;

  /// @deprecated Use [hairline] instead
  static const Color outlineVariant = hairline;

  /// @deprecated Use [charcoalFaint] instead
  static const Color outline = charcoalFaint;
}
