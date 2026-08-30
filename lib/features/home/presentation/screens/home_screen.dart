import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/bloc/product_state.dart';
import '../../../products/bloc/product_event.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import 'wishlist_screen.dart';
import '../widgets/hero_banner.dart';
import '../widgets/combo_slideshow_banner.dart';
import '../widgets/category_strip.dart';
import '../widgets/product_grid_section.dart';
import '../widgets/trust_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 10000);
  final Set<String> _selectedSizes = {};
  final Set<String> _selectedCategories = {};

  // Mock available sizes and categories based on catalog
  final List<String> _allSizes = ['6', '7', '8', '9', 'S', 'M', 'L'];
  final List<String> _allCategories = ['ring', 'earring', 'watch', 'bracelet'];

  bool get _isFilterActive =>
      _searchQuery.isNotEmpty ||
      _priceRange.start > 0 ||
      _priceRange.end < 10000 ||
      _selectedSizes.isNotEmpty ||
      _selectedCategories.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.warmWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.xl,
                bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.filters, style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _priceRange = const RangeValues(0, 10000);
                            _selectedSizes.clear();
                            _selectedCategories.clear();
                          });
                          setState(() {});
                        },
                        child: Text(
                          AppStrings.clearAll,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.auraGold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Category Filter
                  Text(AppStrings.category, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _allCategories.map((cat) {
                      final isSelected = _selectedCategories.contains(cat);
                      return ChoiceChip(
                        label: Text(cat.toUpperCase()),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                          setState(() {});
                        },
                        selectedColor: AppColors.maroonDeep,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.warmWhite : AppColors.charcoalMuted,
                        ),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppSpacing.borderRadiusPill,
                          side: BorderSide(
                            color: isSelected ? AppColors.maroonDeep : AppColors.hairline,
                            width: AppSpacing.hairlineWidth,
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Price Filter
                  Text(
                    '${AppStrings.priceRange}: ₹${_priceRange.start.toInt()} - ₹${_priceRange.end.toInt()}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 20,
                    activeColor: AppColors.maroonDeep,
                    inactiveColor: AppColors.sandalDeep,
                    labels: RangeLabels(
                      '₹${_priceRange.start.toInt()}',
                      '₹${_priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        _priceRange = values;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Size Filter
                  Text(AppStrings.sizeFilter, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _allSizes.map((size) {
                      final isSelected = _selectedSizes.contains(size);
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              _selectedSizes.add(size);
                            } else {
                              _selectedSizes.remove(size);
                            }
                          });
                          setState(() {});
                        },
                        selectedColor: AppColors.maroonDeep,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.warmWhite : AppColors.charcoalMuted,
                        ),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppSpacing.borderRadiusPill,
                          side: BorderSide(
                            color: isSelected ? AppColors.maroonDeep : AppColors.hairline,
                            width: AppSpacing.hairlineWidth,
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.maroonCta,
                        borderRadius: AppSpacing.borderRadiusPill,
                        boxShadow: AppShadows.whisper,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: AppColors.warmWhite,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: const Text(AppStrings.applyFilters),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      body: CustomScrollView(
        slivers: [
          // ── Rajwada Maroon Header ──
          SliverToBoxAdapter(
            child: _buildRajwadaHeader(),
          ),
          // ── Gold Rate Bar ──
          SliverToBoxAdapter(
            child: _buildRateBar(),
          ),
          // ── Content ──
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: AppAnimations.normal,
              child: _isFilterActive ? _buildSearchResults() : _buildDefaultHome(),
            ),
          ),
        ],
      ),
    );
  }

  /// Rajwada-style maroon gradient header with logo, search, heart, cart icons
  Widget _buildRajwadaHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      // Logo mark
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.maroonBlack,
                          border: Border.all(
                            color: AppColors.auraGoldLight,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.diamond,
                          color: AppColors.auraGoldLight,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.auraGoldLight,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ],
                  ),
                  // Header icons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: AppColors.auraGoldLight, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            AuraPageRoute(page: const SearchScreen()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        icon: const Icon(Icons.favorite_outline, color: AppColors.auraGoldLight, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            AuraPageRoute(page: const WishlistScreen()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.auraGoldLight, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            AuraPageRoute(page: const CartScreen()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gold rate bar showing today's gold rate
  Widget _buildRateBar() {
    return Container(
      color: AppColors.auraGold,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.goldRateLabel,
            style: AppTypography.rateBar,
          ),
          Text(
            AppStrings.goldRateValue,
            style: AppTypography.rateBar,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultHome() {
    return Column(
      key: const ValueKey('default_home'),
      children: [
        const ComboSlideshowBanner(),
        const CategoryStrip(),
        ProductGridSection(
          title: AppStrings.bestsellers,
          filter: (p) => p.rating > 4.8,
        ),
        ProductGridSection(
          title: AppStrings.modern,
          filter: (p) => p.name.contains('Solitaire') || p.name.contains('Diamond'),
        ),
        ProductGridSection(
          title: AppStrings.classic,
          filter: (p) => p.name.contains('Pearl') || p.name.contains('Gold'),
        ),
        ProductGridSection(
          title: AppStrings.mostLiked,
          filter: (p) => p.rating == 5.0,
        ),
        const TrustStrip(),
        const SizedBox(height: 100), // Padding for Bottom Nav Bar
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<ProductBloc, ProductState>(
      key: const ValueKey('search_results'),
      builder: (context, state) {
        if (state is ProductLoading || state is ProductInitial) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: Center(child: CircularProgressIndicator(color: AppColors.maroonDeep)),
          );
        }

        if (state is ProductLoaded) {
          final filteredProducts = state.products.where((product) {
            // 1. Text Search
            final matchesText = _searchQuery.isEmpty ||
                product.name.toLowerCase().contains(_searchQuery) ||
                product.description.toLowerCase().contains(_searchQuery);
            
            if (!matchesText) return false;

            // 2. Price Range
            if (product.price < _priceRange.start || product.price > _priceRange.end) {
              return false;
            }

            // 3. Category (checked via ID prefix since we don't have a category field)
            if (_selectedCategories.isNotEmpty) {
              final matchesCategory = _selectedCategories.any((cat) => product.id.startsWith(cat));
              if (!matchesCategory) return false;
            }

            // 4. Size
            if (_selectedSizes.isNotEmpty) {
              if (product.availableSizes.isEmpty) return false;
              
              final matchesSize = product.availableSizes.any((size) => _selectedSizes.contains(size));
              if (!matchesSize) return false;
            }

            return true;
          }).toList();

          if (filteredProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 80, color: AppColors.charcoalFaint),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.noResultsFilters,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.charcoalMuted,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                          _priceRange = const RangeValues(0, 10000);
                          _selectedSizes.clear();
                          _selectedCategories.clear();
                        });
                      },
                      child: const Text(
                        AppStrings.clearFilters,
                        style: TextStyle(color: AppColors.auraGold),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredProducts.length} ${AppStrings.results}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: AppColors.maroonDeep),
                      onPressed: _showFilterBottomSheet,
                      tooltip: AppStrings.filters,
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs).copyWith(bottom: 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppSpacing.gridColumns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: AppSpacing.gridChildAspectRatio,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('${product.name} wishlist status toggled!'),
                         ),
                       );
                    },
                  );
                },
              ),
            ],
          );
        }

        return const Center(child: Text(AppStrings.failedToLoadProducts));
      },
    );
  }
}
