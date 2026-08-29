import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import 'category_items_screen.dart';

// ─────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────

class CategoryStyle {
  final String name;
  final String imageUrl;
  CategoryStyle(this.name, this.imageUrl);
}

class MainCategory {
  final String id;
  final String name;
  final String iconUrl;
  final List<CategoryStyle> styles;

  MainCategory(this.id, this.name, this.iconUrl, this.styles);
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _expandedIndex;
  bool _isShopByStyle = true;

  // ─────────────────────────────────────────────
  // Mock Category Data
  // ─────────────────────────────────────────────

  final List<MainCategory> _womenCategories = [
    MainCategory(
      'ring',
      'Rings',
      'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=150&q=80',
      [
        CategoryStyle('All Rings', 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Engagement', 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Solitaire', 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Dailywear', 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Platinum', 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Bands', 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Cocktail', 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('22KT', 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=200&q=80'),
      ],
    ),
    MainCategory(
      'earring',
      'Earrings',
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=150&q=80',
      [
        CategoryStyle('All Earrings', 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Studs', 'https://images.unsplash.com/photo-1629224316810-9d8805b95e76?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Hoops', 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Drops', 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=200&q=80'),
      ],
    ),
    MainCategory(
      'bracelet',
      'Bracelets & Bangles',
      'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=150&q=80',
      [
        CategoryStyle('Tennis', 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Bangles', 'https://images.unsplash.com/photo-1573408301145-b98c4af3066b?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Chain Link', 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=200&q=80'),
      ],
    ),
    MainCategory(
      'watch',
      'Watches',
      'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=150&q=80',
      [
        CategoryStyle('Luxury', 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=200&q=80'),
        CategoryStyle('Automatic', 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=200&q=80'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleCategory(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null; // collapse
      } else {
        _expandedIndex = index; // expand new
        _isShopByStyle = true; // reset to style tab
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        title: Text(
          AppStrings.categories,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.maroonDeep,
          labelColor: AppColors.maroonDeep,
          unselectedLabelColor: AppColors.charcoalMuted,
          labelStyle: Theme.of(context).textTheme.headlineSmall,
          unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
          tabs: const [
            Tab(text: AppStrings.women),
            Tab(text: AppStrings.men),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryBody(_womenCategories),
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        AppStrings.comingSoon,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.charcoalMuted,
            ),
      ),
    );
  }

  Widget _buildCategoryBody(List<MainCategory> categories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.lg),
          // "Top Categories" heading
          Text(
            AppStrings.topCategories,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.charcoalMuted,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Horizontal scrollable category cards
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isExpanded = _expandedIndex == index;
                return _CategoryChip(
                  category: cat,
                  isExpanded: isExpanded,
                  onTap: () => _toggleCategory(index),
                );
              },
            ),
          ),

          // Expanded accordion section
          AnimatedSize(
            duration: AppAnimations.normal,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: _expandedIndex != null
                ? _buildExpandedSection(categories[_expandedIndex!])
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Expanded Section (accordion below the strip)
  // ─────────────────────────────────────────────

  Widget _buildExpandedSection(MainCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Triangle pointer
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: _getTriangleOffset()),
              child: CustomPaint(
                size: const Size(16, 10),
                painter: _TrianglePainter(color: AppColors.sandal),
              ),
            ),
          ),

          // Content card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.sandal,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.hairlineLight,
                width: AppSpacing.hairlineWidth,
              ),
              boxShadow: AppShadows.whisper,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Style / Price toggle
                _buildToggleTabs(),
                const SizedBox(height: AppSpacing.lg),
                // Style grid or price placeholder
                _isShopByStyle
                    ? _buildStyleGrid(category.styles, category.id)
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Center(
                          child: Text(
                            AppStrings.priceFiltersComingSoon,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.charcoalMuted,
                                ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getTriangleOffset() {
    // Rough center of the first visible chip — adjust as needed
    if (_expandedIndex == null) return 40;
    // Each chip is ~150px wide + 12px gap, starting at 16px padding
    return 16 + (_expandedIndex! * 162.0) + 60;
  }

  // ─────────────────────────────────────────────
  // Shop By Style / Shop By Price Toggle
  // ─────────────────────────────────────────────

  Widget _buildToggleTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppSpacing.borderRadiusPill,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isShopByStyle = true),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _isShopByStyle ? AppColors.maroonDeep : AppColors.transparent,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.shopByStyle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _isShopByStyle ? AppColors.warmWhite : AppColors.charcoal,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isShopByStyle = false),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: !_isShopByStyle ? AppColors.maroonDeep : AppColors.transparent,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.shopByPrice,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: !_isShopByStyle ? AppColors.warmWhite : AppColors.charcoal,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 4-Column Style Grid (small circular images)
  // ─────────────────────────────────────────────

  Widget _buildStyleGrid(List<CategoryStyle> styles, String categoryId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final style = styles[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the items listing for this category
            Navigator.push(
              context,
              AuraPageRoute(
                page: CategoryItemsScreen(
                  categoryId: categoryId,
                  categoryName: style.name,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular image
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmWhite,
                  border: Border.all(
                    color: AppColors.hairlineLight,
                    width: AppSpacing.hairlineWidth,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: style.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ShimmerSkeleton(width: 64, height: 64),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              // Label
              Text(
                style.name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.charcoal,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Horizontal Category Chip (small card)
// ─────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final MainCategory category;
  final bool isExpanded;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.press,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppSpacing.borderRadiusPill,
          border: Border.all(
            color: isExpanded ? AppColors.maroonDeep : AppColors.hairline,
            width: isExpanded ? 2.0 : AppSpacing.hairlineWidth,
          ),
          boxShadow: isExpanded ? AppShadows.whisper : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Small circular category image
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hairlineLight),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: category.iconUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerSkeleton(width: 36, height: 36),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Category name
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.charcoal,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Chevron / dropdown icon
            Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
              color: isExpanded ? AppColors.maroonDeep : AppColors.charcoalMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Triangle Pointer Painter
// ─────────────────────────────────────────────

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
