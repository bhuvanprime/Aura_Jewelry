import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';

/// Redesigned trust badge strip with Rajwada styling.
///
/// Features:
/// - Ivory/sandalDark background
/// - Thin-line outlined icons in antique gold
/// - All-caps title with subtitle description
/// - Vertical gold hairline dividers between items
/// - Generous 28px vertical padding
class TrustStrip extends StatelessWidget {
  const TrustStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sandalDark,
      margin: const EdgeInsets.only(top: AppSpacing.xxl),
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _TrustItem(
              icon: Icons.local_shipping_outlined,
              title: AppStrings.freeShipping,
              subtitle: AppStrings.freeShippingDesc,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _TrustItem(
              icon: Icons.verified_outlined,
              title: AppStrings.lifetimeWarranty,
              subtitle: AppStrings.lifetimeWarrantyDesc,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _TrustItem(
              icon: Icons.sync_outlined,
              title: AppStrings.thirtyDayReturns,
              subtitle: AppStrings.thirtyDayReturnsDesc,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: AppSpacing.hairlineWidth,
      height: 40,
      color: AppColors.auraGold.withValues(alpha: 0.35),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.auraGold,
          size: AppSpacing.iconSizeNav,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.charcoal,
                fontSize: 9,
                letterSpacing: 1.0,
              ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.charcoalFaint,
                fontSize: 9,
              ),
        ),
      ],
    );
  }
}
