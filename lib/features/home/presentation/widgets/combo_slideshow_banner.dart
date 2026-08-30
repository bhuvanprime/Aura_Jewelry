import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_url_resolver.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../admin/domain/models/combo_model.dart';
import '../screens/combo_detail_screen.dart';

/// Pure Cloud Firestore real-time slideshow banner for Curated Bridal Combos & Sets.
/// Zero hardcoded data - all combos are streamed live from project `aurajewelry-2d68d`.
class ComboSlideshowBanner extends StatefulWidget {
  const ComboSlideshowBanner({super.key});

  @override
  State<ComboSlideshowBanner> createState() => _ComboSlideshowBannerState();
}

class _ComboSlideshowBannerState extends State<ComboSlideshowBanner> {
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;
  int _totalCombos = 0;

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _resetTimer(int count) {
    if (count <= 1 || count == _totalCombos) return;
    _totalCombos = count;
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _totalCombos > 1) {
        final nextPage = (_currentPage + 1) % _totalCombos;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _navigateToCombo(ComboModel combo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => ComboDetailScreen(combo: combo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseService.instance.firestore.collection('combos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return _buildLoadingPlaceholder();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final combos = snapshot.data!.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ComboModel.fromJson(data);
        }).where((c) => c.inStock).toList();

        if (combos.isEmpty) {
          return const SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _resetTimer(combos.length);
        });

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
            if (combos.length > 1)
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

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 240,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairlineLight),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.maroonDeep),
      ),
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
              // Background Image from Firestore
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
