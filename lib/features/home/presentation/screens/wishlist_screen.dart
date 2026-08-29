import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/bloc/product_state.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_event.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../../products/bloc/product_event.dart';
import '../../../../core/theme/app_animations.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final Set<String> _selectedItemIds = {};

  void _toggleSelection(String productId) {
    setState(() {
      if (_selectedItemIds.contains(productId)) {
        _selectedItemIds.remove(productId);
      } else {
        _selectedItemIds.add(productId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItemIds.clear();
    });
  }

  void _selectAll(List<String> allProductIds) {
    setState(() {
      _selectedItemIds.addAll(allProductIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = _selectedItemIds.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        title: Text(
          isSelectionMode ? '${_selectedItemIds.length} Selected' : 'Favorites',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.charcoal),
                onPressed: _clearSelection,
              )
            : null,
        actions: [
          if (isSelectionMode)
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded) {
                  final allIds = state.wishlistedProducts.map((p) => p.id).toList();
                  final allSelected = _selectedItemIds.length == allIds.length;
                  return TextButton(
                    onPressed: () {
                      if (allSelected) {
                        _clearSelection();
                      } else {
                        _selectAll(allIds);
                      }
                    },
                    child: Text(
                      allSelected ? 'Deselect All' : 'Select All',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.maroonDeep,
                          ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductInitial) {
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
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
            final wishlistItems = state.wishlistedProducts;

            if (wishlistItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: AppSpacing.huge,
                      color: AppColors.charcoalFaint,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No favorites yet.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.charcoalMuted,
                          ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: 100, // Padding for the bottom bar if visible
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppSpacing.gridColumns,
                crossAxisSpacing: AppSpacing.gridCrossAxisSpacing,
                mainAxisSpacing: AppSpacing.gridMainAxisSpacing,
                childAspectRatio: AppSpacing.gridChildAspectRatio,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                final isSelected = _selectedItemIds.contains(product.id);

                return ProductCard(
                  product: product,
                  isSelected: isSelected,
                  onLongPress: () {
                    _toggleSelection(product.id);
                  },
                  onTap: () {
                    if (isSelectionMode) {
                      _toggleSelection(product.id);
                    } else {
                      Navigator.push(
                        context,
                        AuraPageRoute(
                          page: ProductDetailScreen(product: product),
                        ),
                      );
                    }
                  },
                  onFavoriteTap: () {
                    if (isSelectionMode) {
                      _toggleSelection(product.id);
                    } else {
                      context.read<ProductBloc>().add(
                        ProductToggleWishlist(product.id, !product.isWishlisted),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} wishlist status toggled!'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
          
          return Center(
            child: Text(
              'Failed to load favorites.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoalMuted,
                  ),
            ),
          );
        },
      ),
      bottomSheet: isSelectionMode
          ? Container(
              padding: EdgeInsets.only(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.sandal,
                border: const Border(
                  top: BorderSide(
                    color: AppColors.hairlineLight,
                    width: AppSpacing.hairlineWidth,
                  ),
                ),
                boxShadow: AppShadows.navBar,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.maroonCta,
                        borderRadius: AppSpacing.borderRadiusPill,
                        boxShadow: AppShadows.whisper,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Move selected items to cart
                          final state = context.read<ProductBloc>().state;
                          if (state is ProductLoaded) {
                            final selectedProducts = state.wishlistedProducts
                                .where((p) => _selectedItemIds.contains(p.id))
                                .toList();
                                
                            for (final product in selectedProducts) {
                              final cartItem = CartItemModel(
                                product: product,
                                selectedSize: product.availableSizes.isNotEmpty 
                                  ? product.availableSizes.first 
                                  : null,
                              );
                              context.read<CartBloc>().add(CartItemAdded(cartItem));
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${selectedProducts.length} items added to cart',
                                ),
                              ),
                            );
                            
                            _clearSelection();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: AppColors.warmWhite,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: Text('Add ${_selectedItemIds.length} to Cart'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
