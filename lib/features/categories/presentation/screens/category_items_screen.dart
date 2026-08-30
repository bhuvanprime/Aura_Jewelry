import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/bloc/product_state.dart';
import '../../../products/bloc/product_event.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';

/// Product listing screen for a specific category.
/// Navigated to from the Categories tab — shows a filtered product grid
/// identical in style to the Home screen layout.
class CategoryItemsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryItemsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.charcoal,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductInitial) {
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.xl),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppSpacing.gridColumns,
                crossAxisSpacing: AppSpacing.gridCrossAxisSpacing,
                mainAxisSpacing: AppSpacing.gridMainAxisSpacing,
                childAspectRatio: AppSpacing.gridChildAspectRatio,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const ProductCardSkeleton(),
            );
          }

          if (state is ProductLoaded) {
            // Filter products by category or show all
            final categoryProducts = state.products.where((p) {
              if (categoryId == 'all' || categoryId.isEmpty) return true;
              final catLower = categoryId.toLowerCase();
              final nameLower = categoryName.toLowerCase();
              final pCatLower = p.categoryId.toLowerCase();
              final pNameLower = p.name.toLowerCase();
              return pCatLower.contains(catLower) ||
                  pCatLower.contains(nameLower) ||
                  pNameLower.contains(catLower) ||
                  pNameLower.contains(nameLower) ||
                  p.id.toLowerCase().contains(catLower);
            }).toList();

            final displayProducts = categoryProducts.isNotEmpty
                ? categoryProducts
                : (categoryId == 'all' ? state.products : categoryProducts);

            if (displayProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.charcoalFaint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AppStrings.noResults,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.charcoalMuted,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Text(
                    '${displayProducts.length} ${AppStrings.results}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSpacing.gridColumns,
                    crossAxisSpacing: AppSpacing.gridCrossAxisSpacing,
                    mainAxisSpacing: AppSpacing.gridMainAxisSpacing,
                    childAspectRatio: AppSpacing.gridChildAspectRatio,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
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
                            ProductToggleWishlist(product.id, !product.isWishlisted));
                      },
                    );
                  },
                ),
              ],
            );
          }

          return const Center(child: Text(AppStrings.failedToLoadProducts));
        },
      ),
    );
  }
}
