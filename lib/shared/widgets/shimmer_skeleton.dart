import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_animations.dart';

/// Elegant gold-tinted shimmer skeleton for loading states.
///
/// Replaces all CircularProgressIndicator instances throughout the app.
/// The shimmer sweeps a warm gold gradient left → right, matching
/// the Aura brand palette instead of generic gray skeletons.
///
/// Factory constructors for common shapes:
/// - [ShimmerSkeleton.card] — Full product card placeholder
/// - [ShimmerSkeleton.text] — Single line of text
/// - [ShimmerSkeleton.circle] — Circular avatar/icon placeholder
/// - [ShimmerSkeleton.rect] — Custom rectangle
class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  /// Product card skeleton with image area + text lines
  factory ShimmerSkeleton.card({Key? key}) {
    return ShimmerSkeleton(
      key: key,
      width: double.infinity,
      height: 280,
      borderRadius: AppSpacing.borderRadiusMd,
    );
  }

  /// Single line text placeholder
  factory ShimmerSkeleton.text({
    Key? key,
    double width = 120,
    double height = 14,
  }) {
    return ShimmerSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Circular placeholder (avatars, category icons)
  factory ShimmerSkeleton.circle({
    Key? key,
    double size = 48,
  }) {
    return ShimmerSkeleton(
      key: key,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }

  /// Custom rectangle placeholder
  factory ShimmerSkeleton.rect({
    Key? key,
    required double width,
    required double height,
    double radius = 8,
  }) {
    return ShimmerSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.shimmer,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: const [
                AppColors.sandalDeep,
                AppColors.auraGoldMuted,
                AppColors.sandalDeep,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// A product card shaped skeleton for grid loading states.
///
/// Mimics the layout of [ProductCard] with shimmer placeholders
/// for image, title, price, and rating.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: AppColors.hairline,
          width: AppSpacing.hairlineWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          const AspectRatio(
            aspectRatio: 1,
            child: ShimmerSkeleton(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Text area
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton.text(width: 100, height: 14),
                const SizedBox(height: AppSpacing.xs),
                ShimmerSkeleton.text(width: 60, height: 16),
                const SizedBox(height: AppSpacing.xs),
                ShimmerSkeleton.text(width: 40, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
