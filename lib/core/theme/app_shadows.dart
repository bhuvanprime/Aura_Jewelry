import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Aura Luxury Jewelry — Shadow Tokens
///
/// Shadows should be barely perceptible — they suggest depth without
/// declaring it. No harsh drop shadows. No neumorphic effects.
///
/// Rules:
/// - Maximum blur radius: 20px
/// - Maximum opacity: 0.15 (only for gold glow on CTAs)
/// - Standard shadow opacity: 0.04–0.06
class AppShadows {
  AppShadows._();

  /// Whisper shadow — barely visible depth for cards, chips
  /// offset(0, 2), blur 8, charcoal at 4%
  static List<BoxShadow> get whisper => [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 8,
          color: AppColors.charcoal.withValues(alpha: 0.04),
        ),
      ];

  /// Soft shadow — slightly more depth for sheets, dialogs
  /// offset(0, 4), blur 16, charcoal at 6%
  static List<BoxShadow> get soft => [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 16,
          color: AppColors.charcoal.withValues(alpha: 0.06),
        ),
      ];

  /// Gold whisper — subtle gold glow for primary CTA hover/pressed
  /// offset(0, 2), blur 12, auraGold at 15%
  static List<BoxShadow> get goldWhisper => [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 12,
          color: AppColors.auraGold.withValues(alpha: 0.15),
        ),
      ];

  /// Navigation bar shadow — upward-casting soft shadow
  /// offset(0, -4), blur 20, charcoal at 4%
  static List<BoxShadow> get navBar => [
        BoxShadow(
          offset: const Offset(0, -4),
          blurRadius: 20,
          color: AppColors.charcoal.withValues(alpha: 0.04),
        ),
      ];

  /// Phone-style deep shadow for premium containers
  static List<BoxShadow> get phoneDeep => [
        BoxShadow(
          offset: const Offset(0, 30),
          blurRadius: 80,
          spreadRadius: -20,
          color: AppColors.maroonBlack.withValues(alpha: 0.45),
        ),
      ];
}
