import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../admin/domain/models/admin_category_model.dart';
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
  final String segment;
  final List<CategoryStyle> styles;

  MainCategory(
    this.id,
    this.name,
    this.iconUrl,
    this.styles, {
    this.segment = 'Women',
  });
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
  int? _womenExpandedIndex = 0; // Default first category open
  int? _menExpandedIndex = 0;
  bool _isShopByStyle = true;

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

  void _toggleWomenCategory(int index) {
    setState(() {
      if (_womenExpandedIndex == index) {
        _womenExpandedIndex = null;
      } else {
        _womenExpandedIndex = index;
        _isShopByStyle = true;
      }
    });
  }

  void _toggleMenCategory(int index) {
    setState(() {
      if (_menExpandedIndex == index) {
        _menExpandedIndex = null;
      } else {
        _menExpandedIndex = index;
        _isShopByStyle = true;
      }
    });
  }

  List<MainCategory> _getDefaultMenCategories() {
    return [
      MainCategory(
        'men_kada',
        "Men's Kada",
        'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=400&q=80',
        [
          CategoryStyle('22K Royal Lion Kada', 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Rudraksha Gold Kada', 'https://images.unsplash.com/photo-1573408301145-b98c4af3066b?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Solid 24K Heritage Bangle', 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=400&q=80'),
        ],
        segment: 'Men',
      ),
      MainCategory(
        'men_rings',
        'Signet Rings',
        'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=400&q=80',
        [
          CategoryStyle('Diamond Solitaire Band', 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Navratna Royal Ring', 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Platinum Classic Band', 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=400&q=80'),
        ],
        segment: 'Men',
      ),
      MainCategory(
        'men_chains',
        'Chains & Pendants',
        'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=400&q=80',
        [
          CategoryStyle('Rope Link Gold Chain', 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Lord Shiva Trishul Pendant', 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Cuban 22K Solid Link', 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=400&q=80'),
        ],
        segment: 'Men',
      ),
      MainCategory(
        'men_cufflinks',
        'Cufflinks & Buttons',
        'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=400&q=80',
        [
          CategoryStyle('Emerald Kurta Buttons', 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=400&q=80'),
          CategoryStyle('Gold & Diamond Cufflinks', 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=400&q=80'),
        ],
        segment: 'Men',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.categories,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.maroonDeep,
                fontWeight: FontWeight.bold,
              ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.maroonDeep,
          labelColor: AppColors.maroonDeep,
          unselectedLabelColor: AppColors.charcoalMuted,
          labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
          tabs: const [
            Tab(text: 'WOMEN & BRIDAL'),
            Tab(text: "MEN'S ROYAL EDIT"),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseService.instance.firestore.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.maroonDeep),
            );
          }

          final liveCategories = (snapshot.data?.docs ?? []).map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            final cat = AdminCategoryModel.fromJson(data);
            return MainCategory(
              cat.id,
              cat.name,
              cat.iconUrl,
              cat.styles.isNotEmpty
                  ? cat.styles.map((s) => CategoryStyle(s.name, s.imageUrl)).toList()
                  : [CategoryStyle('All ${cat.name}', cat.iconUrl)],
              segment: cat.segment,
            );
          }).toList();

          // Filter by segment
          final womenCategories = liveCategories.where((c) {
            final s = c.segment.toLowerCase();
            return s != 'men';
          }).toList();

          var menCategories = liveCategories.where((c) {
            final s = c.segment.toLowerCase();
            return s == 'men' || s == 'unisex';
          }).toList();

          if (menCategories.isEmpty) {
            menCategories = _getDefaultMenCategories();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryBody(
                categories: womenCategories,
                expandedIndex: _womenExpandedIndex,
                onToggle: _toggleWomenCategory,
              ),
              _buildCategoryBody(
                categories: menCategories,
                expandedIndex: _menExpandedIndex,
                onToggle: _toggleMenCategory,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryBody({
    required List<MainCategory> categories,
    required int? expandedIndex,
    required ValueChanged<int> onToggle,
  }) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noResults,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.charcoalMuted,
              ),
        ),
      );
    }

    final safeExpandedIndex = (expandedIndex != null && expandedIndex < categories.length)
        ? expandedIndex
        : (categories.isNotEmpty ? 0 : null);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'EXPLORE BY CATEGORY',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Horizontal scrollable category pill chips
          SizedBox(
            height: 54,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isExpanded = safeExpandedIndex == index;
                return _CategoryChip(
                  category: cat,
                  isExpanded: isExpanded,
                  onTap: () => onToggle(index),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Expanded accordion dropdown section
          AnimatedSize(
            duration: AppAnimations.normal,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: safeExpandedIndex != null
                ? _buildExpandedSection(categories[safeExpandedIndex], safeExpandedIndex)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Expanded Section (dropdown accordion)
  // ─────────────────────────────────────────────

  Widget _buildExpandedSection(MainCategory category, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Content card with jaali-styled borders
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.auraGold.withValues(alpha: 0.5),
                width: 1.2,
              ),
              boxShadow: AppShadows.whisper,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Category Title & "View Full Catalog" link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.maroonDeep,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => CategoryItemsScreen(
                              categoryId: category.id,
                              categoryName: category.name,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View All Items →',
                        style: TextStyle(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                // Style / Price toggle
                _buildToggleTabs(),
                const SizedBox(height: AppSpacing.lg),
                // Sub-style Grid
                _isShopByStyle
                    ? _buildStyleGrid(category.styles, category.id)
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
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

  // ─────────────────────────────────────────────
  // Shop By Style / Shop By Price Toggle
  // ─────────────────────────────────────────────

  Widget _buildToggleTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sandal,
        borderRadius: AppSpacing.borderRadiusPill,
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isShopByStyle = true),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _isShopByStyle ? AppColors.maroonDeep : AppColors.transparent,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.shopByStyle,
                  style: TextStyle(
                    color: _isShopByStyle ? AppColors.warmWhite : AppColors.charcoal,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !_isShopByStyle ? AppColors.maroonDeep : AppColors.transparent,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.shopByPrice,
                  style: TextStyle(
                    color: !_isShopByStyle ? AppColors.warmWhite : AppColors.charcoal,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
  // 3-Column / 4-Column Sub-Style Grid with circular images
  // ─────────────────────────────────────────────

  Widget _buildStyleGrid(List<CategoryStyle> styles, String categoryId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.8,
      ),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final style = styles[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => CategoryItemsScreen(
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
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warmWhite,
                  border: Border.all(
                    color: AppColors.auraGold,
                    width: 1.2,
                  ),
                  boxShadow: AppShadows.whisper,
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: style.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ShimmerSkeleton(width: 68, height: 68),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.diamond_outlined,
                    color: AppColors.maroonDeep,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Label
              Text(
                style.name,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
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
// Horizontal Category Chip (Pill card)
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
          color: isExpanded ? AppColors.maroonDeep : AppColors.warmWhite,
          borderRadius: AppSpacing.borderRadiusPill,
          border: Border.all(
            color: isExpanded ? AppColors.maroonDeep : AppColors.auraGold.withValues(alpha: 0.5),
            width: isExpanded ? 1.5 : 1.0,
          ),
          boxShadow: isExpanded ? AppShadows.soft : AppShadows.whisper,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isExpanded ? AppColors.auraGold : AppColors.hairlineLight,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: category.iconUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerSkeleton(width: 32, height: 32),
                errorWidget: (context, url, error) => Icon(
                  Icons.star,
                  size: 16,
                  color: isExpanded ? AppColors.warmWhite : AppColors.maroonDeep,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              category.name,
              style: TextStyle(
                color: isExpanded ? AppColors.warmWhite : AppColors.charcoal,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isExpanded ? AppColors.auraGold : AppColors.charcoalMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
