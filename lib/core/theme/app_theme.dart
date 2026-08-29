import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Aura Luxury Jewelry — ThemeData Assembly
///
/// Assembles all design tokens (colors, typography, spacing, shadows)
/// into a complete Flutter ThemeData. Every Material component is
/// themed to feel premium and aligned with the Rajwada Jewels brand.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ── Core Colors ──
      scaffoldBackgroundColor: AppColors.sandal,
      primaryColor: AppColors.auraGold,
      canvasColor: AppColors.sandal,
      cardColor: AppColors.warmWhite,
      dividerColor: AppColors.hairline,

      colorScheme: const ColorScheme.light(
        primary: AppColors.auraGold,
        onPrimary: AppColors.warmWhite,
        primaryContainer: AppColors.auraGoldLight,
        onPrimaryContainer: AppColors.charcoal,
        secondary: AppColors.maroonDeep,
        onSecondary: AppColors.auraGoldLight,
        secondaryContainer: AppColors.sandalDark,
        onSecondaryContainer: AppColors.charcoalMuted,
        surface: AppColors.sandal,
        onSurface: AppColors.charcoal,
        onSurfaceVariant: AppColors.charcoalMuted,
        surfaceContainerLow: AppColors.sandalDark,
        surfaceContainerLowest: AppColors.warmWhite,
        surfaceContainer: AppColors.sandalDeep,
        outline: AppColors.charcoalFaint,
        outlineVariant: AppColors.hairline,
        error: AppColors.error,
        onError: AppColors.warmWhite,
      ),

      // ── Typography ──
      textTheme: AppTypography.textTheme,

      // ── App Bar ──
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.textTheme.displayMedium,
        iconTheme: const IconThemeData(
          color: AppColors.charcoalMuted,
          size: AppSpacing.iconSizeNav,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.charcoalMuted,
          size: AppSpacing.iconSizeContent,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // ── Bottom Navigation Bar ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.warmWhite,
        selectedItemColor: AppColors.maroonDeep,
        unselectedItemColor: AppColors.charcoalMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.textTheme.labelSmall?.copyWith(
          color: AppColors.maroonDeep,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: AppTypography.textTheme.labelSmall?.copyWith(
          color: AppColors.charcoalMuted,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        selectedIconTheme: const IconThemeData(
          size: 19,
          color: AppColors.maroonDeep,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 19,
          color: AppColors.charcoalMuted,
        ),
      ),

      // ── Elevated Button (Primary CTA — maroonDeep) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maroonDeep,
          foregroundColor: AppColors.warmWhite,
          disabledBackgroundColor: AppColors.sandalDeep,
          disabledForegroundColor: AppColors.charcoalFaint,
          textStyle: AppTypography.textTheme.labelLarge,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
        ),
      ),

      // ── Outlined Button (Secondary CTA — ghost/outline) ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.maroonDeep,
          textStyle: AppTypography.textTheme.labelLarge,
          side: const BorderSide(color: AppColors.maroonDeep, width: 1),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // ── Text Button (Tertiary) ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.maroonDeep,
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.0,
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: AppColors.warmWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: const BorderSide(
            color: AppColors.hairline,
            width: AppSpacing.hairlineWidth,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input Decoration (Text Fields) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.sandal,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(
            color: AppColors.hairline,
            width: AppSpacing.hairlineWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(
            color: AppColors.hairline,
            width: AppSpacing.hairlineWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(
            color: AppColors.maroonDeep,
            width: AppSpacing.focusBorderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSpacing.hairlineWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSpacing.focusBorderWidth,
          ),
        ),
        labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.charcoalMuted,
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.charcoalFaint,
        ),
        errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
        ),
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.warmWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
        titleTextStyle: AppTypography.textTheme.headlineMedium,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.charcoalMuted,
        ),
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.warmWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.maroonDeep,
        disabledColor: AppColors.sandalDeep,
        labelStyle: AppTypography.textTheme.bodyMedium,
        secondaryLabelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.warmWhite,
        ),
        side: const BorderSide(
          color: AppColors.hairline,
          width: AppSpacing.hairlineWidth,
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: AppSpacing.hairlineWidth,
        space: 0,
      ),

      // ── Icon ──
      iconTheme: const IconThemeData(
        color: AppColors.charcoalMuted,
        size: AppSpacing.iconSizeContent,
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.maroonDeep,
        foregroundColor: AppColors.warmWhite,
      ),

      // ── Slider ──
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.maroonDeep,
        thumbColor: AppColors.maroonDeep,
        overlayColor: AppColors.maroonDeep.withValues(alpha: 0.12),
        inactiveTrackColor: AppColors.sandalDeep,
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.warmWhite,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),

      // ── Progress Indicator (fallback — prefer shimmer) ──
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.maroonDeep,
        linearTrackColor: AppColors.sandalDeep,
        circularTrackColor: AppColors.sandalDeep,
      ),

      // ── Tab Bar ──
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.maroonDeep,
        labelColor: AppColors.maroonDeep,
        unselectedLabelColor: AppColors.charcoalMuted,
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // ── Splash & Highlight ──
      splashColor: AppColors.maroonDeep.withValues(alpha: 0.08),
      highlightColor: AppColors.maroonDeep.withValues(alpha: 0.05),
      hoverColor: AppColors.maroonDeep.withValues(alpha: 0.03),
    );
  }
}
