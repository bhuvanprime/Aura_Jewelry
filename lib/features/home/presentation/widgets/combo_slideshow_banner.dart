import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/image_url_resolver.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../admin/domain/models/combo_model.dart';
import '../screens/combo_detail_screen.dart';

class ComboSlideshowBanner extends StatefulWidget {
  const ComboSlideshowBanner({super.key});

  @override
  State<ComboSlideshowBanner> createState() => _ComboSlideshowBannerState();
}

class _ComboSlideshowBannerState extends State<ComboSlideshowBanner> {
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<ComboModel> _defaultCombos = const [
    ComboModel(
      id: 'combo_bridal_1',
      title: 'Maharani Kundan Bridal Ensemble',
      description: 'Opulent 4-piece 22K gold wedding set featuring layered choker, matching jhumkas, maang tikka, and antique kada.',
      originalPrice: 385000,
      comboPrice: 345000,
      discountPercent: 10.4,
      includedProductIds: ['prod_1', 'prod_2', 'prod_4', 'prod_5'],
      includedProductNames: [
        'Nizam Heritage Polki Choker (48.5g)',
        'Mayur Jhumka Chandbalis (16.2g)',
        'Padmavati Floral Maang Tikka (12.0g)',
        'Rajwada Antique Kada Bangle (36.4g)',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=800&q=80',
      tag: '👑 Royal Bridal Set',
      inStock: true,
      stockCount: 4,
    ),
    ComboModel(
      id: 'combo_festive_2',
      title: 'Padmavati Heritage Solitaire Trio',
      description: 'Handcrafted 18K yellow gold cocktail ring, matching diamond studs, and tennis bracelet.',
      originalPrice: 198000,
      comboPrice: 175000,
      discountPercent: 11.6,
      includedProductIds: ['prod_3', 'prod_2'],
      includedProductNames: [
        'Padmavati Solitaire VVS1 Ring (6.8g)',
        'Brilliant Cut Diamond Studs (8.5g)',
        'Solid Gold Tennis Bracelet (18.2g)',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=800&q=80',
      tag: '✨ Festive Trio',
      inStock: true,
      stockCount: 6,
    ),
    ComboModel(
      id: 'combo_nizam_3',
      title: 'Nizam Heritage Polki & Bangle Set',
      description: 'Antique 22K temple-engraved bridal kada with heirloom Polki necklace studded with rubies.',
      originalPrice: 327000,
      comboPrice: 289000,
      discountPercent: 11.6,
      includedProductIds: ['prod_1', 'prod_4'],
      includedProductNames: [
        'Nizam Antique Choker (48.5g)',
        'Kada Rajwada Engraved Bangles Pair (72.8g)',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=800&q=80',
      tag: '💎 Nizam Heritage',
      inStock: true,
      stockCount: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _defaultCombos.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToCombo(ComboModel combo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => ComboDetailScreen(combo: combo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.instance.firestore.collection('combos').snapshots(),
      builder: (context, snapshot) {
        List<ComboModel> combos = _defaultCombos;
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
          try {
            combos = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return ComboModel.fromJson(data);
            }).toList();
          } catch (_) {
            combos = _defaultCombos;
          }
        }

        if (combos.isEmpty) combos = _defaultCombos;

        return Column(
          children: [
            Container(
              height: 255,
              margin: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: PageView.builder(
                controller: _pageController,
                itemCount: combos.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (context, index) {
                  final combo = combos[index];
                  return _buildComboSlide(combo);
                },
              ),
            ),
            // Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(combos.length, (index) {
                final isSelected = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: isSelected ? 22 : 6,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.maroonDeep : AppColors.auraGoldLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComboSlide(ComboModel combo) {
    final resolvedUrl = ImageUrlResolver.resolve(combo.imageUrl);
    final savings = combo.originalPrice - combo.comboPrice;

    return GestureDetector(
      onTap: () => _navigateToCombo(combo),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.auraGold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                resolvedUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: AppColors.maroonDeep,
                  child: const Center(
                    child: Icon(Icons.diamond_outlined, size: 60, color: AppColors.auraGoldLight),
                  ),
                ),
              ),

              // Deep Dark Gradient Overlay for Maximum Readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.maroonBlack.withValues(alpha: 0.25),
                      AppColors.maroonBlack.withValues(alpha: 0.65),
                      AppColors.maroonBlack.withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),

              // Decorative Border Lattice Frame
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.auraGoldLight.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Slide Content
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Top tag pill
                    Row(
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
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (savings > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'SAVE ₹${savings.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),

                    // Combo Title
                    Text(
                      combo.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.sandal,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 4),

                    // Included items preview
                    if (combo.includedProductNames.isNotEmpty)
                      Text(
                        'Includes: ${combo.includedProductNames.take(2).join(" • ")}${combo.includedProductNames.length > 2 ? " + more" : ""}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.auraGoldLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Price & CTA Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${combo.comboPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.auraGoldLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            if (combo.originalPrice > combo.comboPrice)
                              Text(
                                'MRP: ₹${combo.originalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppColors.charcoalFaint,
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldCta,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Set',
                                style: TextStyle(
                                  color: AppColors.maroonBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 11, color: AppColors.maroonBlack),
                            ],
                          ),
                        ),
                      ],
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
