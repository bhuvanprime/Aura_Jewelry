import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_animations.dart';
import '../../core/theme/app_typography.dart';
import '../../features/products/domain/models/product_model.dart';
import 'shimmer_skeleton.dart';

/// Premium product card with Rajwada luxury styling.
///
/// Features:
/// - White bg, 14px rounded corners, gold-tinted border
/// - Maroon gradient image background with gold radial overlay
/// - BIS 916 certified tag in top-left
/// - Cormorant Garamond product name
/// - Maroon deep price
/// - Weight info in sandstone
/// - Scale-down press animation (98%)
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const ProductCard({
    super.key,
    required this.product,
    this.onFavoriteTap,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.pressedScale,
    ).animate(
      CurvedAnimation(parent: _scaleController, curve: AppAnimations.press),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();
  void _onTapUp(TapUpDetails _) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.maroonDeep
                  : AppColors.hairline,
              width: widget.isSelected ? 2.0 : AppSpacing.hairlineWidth,
            ),
            boxShadow: AppShadows.whisper,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Section (1:1 Aspect Ratio) ──
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.productImageGradient,
                  ),
                  child: Stack(
                    children: [
                      // Radial gold overlay for premium feel
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.7, -0.5),
                              radius: 1.2,
                              colors: [
                                AppColors.auraGoldLight.withValues(alpha: 0.28),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Product image with shimmer loading
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ShimmerSkeleton(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.diamond_outlined,
                              color: AppColors.auraGoldLight,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      // BIS 916 Certified tag
                      Positioned(
                        top: 9,
                        left: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.auraGold,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            'BIS 916',
                            style: AppTypography.certifiedTag,
                          ),
                        ),
                      ),
                      // Wishlist heart
                      Positioned(
                        top: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: GestureDetector(
                          onTap: widget.onFavoriteTap,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.warmWhite.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedSwitcher(
                              duration: AppAnimations.medium,
                              switchInCurve: AppAnimations.morph,
                              child: Icon(
                                widget.product.isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                key: ValueKey(widget.product.isWishlisted),
                                color: widget.product.isWishlisted
                                    ? AppColors.wishlistActive
                                    : AppColors.charcoalMuted,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Selection checkmark overlay
                      if (widget.isSelected)
                        Positioned.fill(
                          child: Container(
                            color: AppColors.maroonDeep.withValues(alpha: 0.2),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.maroonDeep,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Details Section ──
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name — serif
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price — bold in maroon deep
                    Text(
                      '₹${widget.product.price.toStringAsFixed(0)}',
                      style: AppTypography.priceSmall.copyWith(fontSize: 12.5),
                    ),
                    const SizedBox(height: 2),
                    // Weight info
                    Text(
                      '22K gold · ${widget.product.rating}g',
                      style: AppTypography.productWeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
