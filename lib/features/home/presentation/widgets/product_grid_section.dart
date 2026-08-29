import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/bloc/product_event.dart';
import '../../../products/bloc/product_state.dart';
import '../../../products/domain/models/product_model.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';

/// Reusable product grid section with Rajwada styling.
///
/// Features:
/// - Cormorant Garamond section title
/// - "View all →" link in gold antique
/// - Gold rule line (34px × 2px) below title
/// - Shimmer loading states
class ProductGridSection extends StatelessWidget {
  final String title;
  final bool Function(ProductModel) filter;

  const ProductGridSection({
    super.key,
    required this.title,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.maroonBlack,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to View All
                },
                child: Text(
                  'View all →',
                  style: AppTypography.sectionLink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Gold rule line
          Container(
            width: 34,
            height: 2,
            color: AppColors.auraGold,
          ),
          const SizedBox(height: 16),

          // ── Product Grid ──
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading || state is ProductInitial) {
                return _buildSkeletonGrid();
              }

              if (state is ProductLoaded) {
                final sectionProducts = state.products.where(filter).toList();

                if (sectionProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: Text(
                        'No products available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.charcoalMuted,
                            ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSpacing.gridColumns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: AppSpacing.gridChildAspectRatio,
                  ),
                  itemCount: sectionProducts.length,
                  itemBuilder: (context, index) {
                    final product = sectionProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          AuraPageRoute(
                            page: ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      onFavoriteTap: () {
                        context.read<ProductBloc>().add(
                          ProductToggleWishlist(
                            product.id,
                            !product.isWishlisted,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} wishlist status toggled!',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return Center(
                child: Text(
                  'Failed to load products.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.charcoalMuted,
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Shimmer skeleton grid matching the product grid layout
  Widget _buildSkeletonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSpacing.gridColumns,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: AppSpacing.gridChildAspectRatio,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}
