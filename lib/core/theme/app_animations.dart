import 'package:flutter/material.dart';

/// Aura Luxury Jewelry — Animation Constants & Custom Page Route
///
/// Motion guidelines:
/// - Slow, smooth easing (300–400ms) — never snappy/bouncy
/// - No Curves.bounceOut or spring animations
/// - Minimum transition: 200ms, Maximum: 400ms
/// - Prefer opacity crossfade over hard cuts
class AppAnimations {
  AppAnimations._();

  // ─────────────────────────────────────────────
  // Durations
  // ─────────────────────────────────────────────

  /// Quick feedback — button press, micro-interaction
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard interaction — card tap, icon morph
  static const Duration normal = Duration(milliseconds: 200);

  /// Wishlist heart fill, chip selection
  static const Duration medium = Duration(milliseconds: 300);

  /// Page transitions, modal sheets
  static const Duration slow = Duration(milliseconds: 350);

  /// Reverse page transition (slightly faster)
  static const Duration slowReverse = Duration(milliseconds: 300);

  /// Sheet/overlay entry
  static const Duration sheet = Duration(milliseconds: 400);

  /// Shimmer sweep cycle
  static const Duration shimmer = Duration(milliseconds: 1500);

  // ─────────────────────────────────────────────
  // Curves
  // ─────────────────────────────────────────────

  /// Page transitions — smooth in-out
  static const Curve pageTransition = Curves.easeInOutCubic;

  /// Page exit — smooth out
  static const Curve pageExit = Curves.easeOutCubic;

  /// Card/button press — quick settle
  static const Curve press = Curves.easeOut;

  /// Heart fill, icon morph — balanced
  static const Curve morph = Curves.easeInOut;

  /// Sheet slide up — decelerating
  static const Curve sheetEntry = Curves.easeOutCubic;

  /// Scroll physics
  static const Curve decelerate = Curves.decelerate;

  // ─────────────────────────────────────────────
  // Scale Values
  // ─────────────────────────────────────────────

  /// Card/button pressed scale (subtle press-down)
  static const double pressedScale = 0.98;

  /// Page slide offset (very gentle upward drift)
  static const Offset pageSlideBegin = Offset(0, 0.03);
}

/// Premium page transition route for Aura
///
/// Combines a soft fade with a gentle upward slide.
/// Usage:
/// ```dart
/// Navigator.push(context, AuraPageRoute(page: DetailScreen()));
/// ```
class AuraPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AuraPageRoute({required this.page})
      : super(
          transitionDuration: AppAnimations.slow,
          reverseTransitionDuration: AppAnimations.slowReverse,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: AppAnimations.pageTransition,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: AppAnimations.pageSlideBegin,
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: AppAnimations.pageExit,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}
