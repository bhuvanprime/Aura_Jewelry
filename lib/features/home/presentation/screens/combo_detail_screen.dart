import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/image_url_resolver.dart';
import '../../../admin/domain/models/combo_model.dart';
import '../../../cart/domain/models/cart_item_model.dart';
import '../../../cart/bloc/cart_bloc.dart';
import '../../../cart/bloc/cart_event.dart';
import '../../../cart/presentation/screens/cart_screen.dart';

class ComboDetailScreen extends StatelessWidget {
  final ComboModel combo;

  const ComboDetailScreen({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = ImageUrlResolver.resolve(combo.imageUrl);
    final savings = combo.originalPrice - combo.comboPrice;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.maroonDeep, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Curated Bridal Combo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.maroonDeep,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.maroonDeep),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.maroonDeep),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.maroonDeep,
                  content: Text('Bridal set link copied: ${combo.title}'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image Frame with Royal Jaali Border
            Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: AppShadows.whisper,
                border: Border.all(color: AppColors.auraGold, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.15,
                      child: Image.network(
                        resolvedImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(Icons.diamond_outlined, size: 80, color: AppColors.auraGold),
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.maroonBlack.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldCta,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                combo.tag.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.maroonBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.auraGoldLight.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                '${combo.includedProductNames.length} Items Set',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Title, Description & Pricing Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    combo.title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          height: 1.25,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    combo.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.charcoalMuted,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Pricing Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.hairlineLight),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Special Combo Price',
                              style: TextStyle(color: AppColors.charcoalMuted, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${combo.comboPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.maroonDeep,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (combo.originalPrice > combo.comboPrice)
                              Text(
                                'MRP: ₹${combo.originalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppColors.charcoalFaint,
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        if (savings > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                              ),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${combo.discountPercent.toStringAsFixed(0)}% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Save ₹${savings.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFFA5D6A7),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 3. Included Pieces in Combo
                  Text(
                    'Included in this Set (${combo.includedProductNames.length} Pieces)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (combo.includedProductNames.isNotEmpty)
                    ...combo.includedProductNames.asMap().entries.map((entry) {
                      final idx = entry.key + 1;
                      final name = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.warmWhite,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.hairlineLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.auraGoldLight.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$idx',
                                  style: const TextStyle(
                                    color: AppColors.maroonDeep,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: AppColors.charcoal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
                          ],
                        ),
                      );
                    })
                  else
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.warmWhite,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Text(
                        'Full handcrafted heritage bridal jewellery ensemble.',
                        style: TextStyle(color: AppColors.charcoalMuted),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.lg),

                  // 4. Hallmarking & Authenticity Guarantee Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.maroonDeep, AppColors.maroonBlack],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.auraGold),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.auraGoldLight, size: 36),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '100% Certified 22K Hallmarked',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Insured armored doorstep delivery with lifetime exchange guarantee.',
                                style: TextStyle(
                                  color: AppColors.auraGoldLight.withValues(alpha: 0.85),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120), // Bottom padding for actions
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Video consultation action
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.maroonDeep),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: IconButton(
                icon: const Icon(Icons.videocam_outlined, color: AppColors.maroonDeep),
                tooltip: 'Book Video Consultation',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.maroonDeep,
                      content: Text('VIP Video Consultation Request Submitted! Our jeweler will reach out shortly.'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Add Entire Set to Cart
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, color: AppColors.maroonBlack, size: 20),
                label: const Text(
                  'Add Entire Set to Cart',
                  style: TextStyle(
                    color: AppColors.maroonBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.auraGold,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                onPressed: () {
                  final prod = combo.toProductModel();
                  context.read<CartBloc>().add(CartItemAdded(CartItemModel(product: prod)));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.maroonDeep,
                      content: Text('${combo.title} added to your Cart!'),
                      action: SnackBarAction(
                        label: 'VIEW CART',
                        textColor: AppColors.auraGoldLight,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => const CartScreen()),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
