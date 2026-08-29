import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import '../../bloc/product_state.dart';
import '../../domain/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_event.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';

/// Breakpoint for switching to desktop side-by-side layout.
const double _kDesktopBreakpoint = 720;
const double _kMaxContentWidth = 1200;

/// Premium product detail screen with luxury styling.
/// Responsive: mobile = stacked, desktop = side-by-side.
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  int _currentImageIndex = 0;
  final PageController _imagePageController = PageController();

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= _kDesktopBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      extendBodyBehindAppBar: !isDesktop,
      appBar: AppBar(
        backgroundColor: isDesktop ? AppColors.sandal : Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.charcoal,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              bool isWishlisted = widget.product.isWishlisted;
              if (state is ProductLoaded) {
                final updatedProduct = state.products.cast<ProductModel?>().firstWhere(
                  (p) => p?.id == widget.product.id,
                  orElse: () => null,
                );
                if (updatedProduct != null) {
                  isWishlisted = updatedProduct.isWishlisted;
                }
              }

              return IconButton(
                icon: AnimatedSwitcher(
                  duration: AppAnimations.medium,
                  switchInCurve: AppAnimations.morph,
                  child: Icon(
                    isWishlisted
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    key: ValueKey(isWishlisted),
                    color: isWishlisted
                        ? AppColors.wishlistActive
                        : AppColors.charcoal,
                    size: 22,
                  ),
                ),
                onPressed: () {
                  context.read<ProductBloc>().add(
                    ProductToggleWishlist(
                      widget.product.id,
                      !isWishlisted,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.product.name} ${AppStrings.wishlistToggled}',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // ─────────────────────────────────────────────
  // MOBILE LAYOUT (stacked — original)
  // ─────────────────────────────────────────────

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(height: 420),
                _buildProductInfo(),
              ],
            ),
          ),
        ),
        _buildBottomCta(),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // DESKTOP LAYOUT (side-by-side)
  // ─────────────────────────────────────────────

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Hero image (constrained width, full height)
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: ClipRRect(
                        borderRadius: AppSpacing.borderRadiusLg,
                        child: _buildHeroImage(height: null), // fill available
                      ),
                    ),
                  ),
                  // Right: Product details (scrollable)
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.xxl,
                        right: AppSpacing.xxl,
                        bottom: AppSpacing.xxl,
                      ),
                      child: _buildProductInfo(),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomCta(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Shared Components
  // ─────────────────────────────────────────────

  Widget _buildHeroImage({double? height}) {
    final images = widget.product.allImages;

    return Column(
      children: [
        SizedBox(
          height: height ?? 420,
          width: double.infinity,
          child: Stack(
            children: [
              // PageView Slideshow
              PageView.builder(
                controller: _imagePageController,
                itemCount: images.length,
                onPageChanged: (idx) {
                  setState(() => _currentImageIndex = idx);
                },
                itemBuilder: (context, idx) {
                  final imgUrl = images[idx];
                  return CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerSkeleton(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.sandalDark,
                      child: const Center(
                        child: Icon(
                          Icons.diamond_outlined,
                          color: AppColors.auraGold,
                          size: 60,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Counter Pill (e.g. 1 / 4)
              if (images.length > 1)
                Positioned(
                  top: 50,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.maroonBlack.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.auraGold.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1} / ${images.length}',
                      style: const TextStyle(
                        color: AppColors.auraGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Indicator dots
              if (images.length > 1)
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (idx) {
                      final isSelected = _currentImageIndex == idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isSelected ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.auraGold : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),

        // Thumbnail strip
        if (images.length > 1)
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: AppColors.sandalDark,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, idx) {
                final isSelected = _currentImageIndex == idx;
                return GestureDetector(
                  onTap: () {
                    _imagePageController.animateToPage(
                      idx,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? AppColors.auraGold : AppColors.hairline,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: images[idx],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sandalDark,
                  borderRadius: AppSpacing.borderRadiusPill,
                  border: Border.all(
                    color: AppColors.hairline,
                    width: AppSpacing.hairlineWidth,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_outline,
                      color: AppColors.auraGoldLight,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      widget.product.rating.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Price
          Text(
            '\$${widget.product.price.toStringAsFixed(0)}',
            style: AppTypography.price,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Size Selector
          if (widget.product.availableSizes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.selectSize,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Size Guide',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: AppColors.maroonDeep,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.maroonDeep,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: widget.product.availableSizes.map((size) {
                final isSelected = _selectedSize == size;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSize = _selectedSize == size ? null : size;
                    });
                  },
                  child: AnimatedContainer(
                    duration: AppAnimations.normal,
                    curve: AppAnimations.morph,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.maroonDeep
                          : Colors.transparent,
                      borderRadius: AppSpacing.borderRadiusPill,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.maroonDeep
                            : AppColors.hairline,
                        width: AppSpacing.hairlineWidth,
                      ),
                    ),
                    child: Text(
                      size,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: isSelected
                                ? AppColors.warmWhite
                                : AppColors.charcoalMuted,
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],

          // Description
          Text(
            AppStrings.description,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.product.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  color: AppColors.charcoalMuted,
                ),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildBottomCta() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= _kDesktopBreakpoint;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
        child: Container(
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
              // Price summary
              Expanded(
                flex: isDesktop ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Price',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.charcoalFaint,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(0)}',
                      style: AppTypography.price,
                    ),
                  ],
                ),
              ),
              // Add to Cart CTA
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.maroonCta,
                    borderRadius: AppSpacing.borderRadiusPill,
                    boxShadow: AppShadows.whisper,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSize == null &&
                          widget.product.availableSizes.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.pleaseSelectSize),
                          ),
                        );
                        return;
                      }

                      final cartItem = CartItemModel(
                        product: widget.product,
                        selectedSize: _selectedSize,
                      );
                      context.read<CartBloc>().add(CartItemAdded(cartItem));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.product.name} ${AppStrings.addedToCart}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.warmWhite,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: const Text(AppStrings.addToCart),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
