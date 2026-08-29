import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Premium category strip with Rajwada styling.
///
/// Features:
/// - 5 categories: Rings, Necklace, Earrings, Bangles, Bridal
/// - 52px circle icons with white fill and gold-tinted border
/// - Maroon deep icon color (not gold)
/// - Labels: 10px sandstone, w600
/// - Evenly spaced across the width
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Rings', 'icon': Icons.diamond_outlined},
    {'name': 'Necklace', 'icon': Icons.accessibility_new_outlined},
    {'name': 'Earrings', 'icon': Icons.radio_button_unchecked},
    {'name': 'Bangles', 'icon': Icons.panorama_fish_eye},
    {'name': 'Bridal', 'icon': Icons.auto_awesome_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((cat) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.warmWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.auraGold.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    cat['icon'] as IconData,
                    color: AppColors.maroonDeep,
                    size: 23,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['name'] as String,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.charcoalMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
