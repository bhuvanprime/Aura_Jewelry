import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class StickyBottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const StickyBottomBar({
    super.key,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.sandal,
        border: Border(
          top: BorderSide(
            color: AppColors.auraGold.withValues(alpha: 0.25),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.charcoalMuted,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: AppTypography.price,
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
