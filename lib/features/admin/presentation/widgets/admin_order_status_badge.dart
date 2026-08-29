import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/order_model.dart';

class AdminOrderStatusBadge extends StatelessWidget {
  final OrderLifecycleStatus status;

  const AdminOrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    IconData icon;

    switch (status) {
      case OrderLifecycleStatus.pending:
        bg = const Color(0xFFFFF4E5);
        textColor = const Color(0xFFB76E00);
        icon = Icons.hourglass_top_outlined;
        break;
      case OrderLifecycleStatus.processing:
        bg = const Color(0xFFE8F4FD);
        textColor = const Color(0xFF0C5460);
        icon = Icons.handyman_outlined;
        break;
      case OrderLifecycleStatus.shipped:
        bg = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF6B21A8);
        icon = Icons.local_shipping_outlined;
        break;
      case OrderLifecycleStatus.delivered:
        bg = const Color(0xFFE6F4EA);
        textColor = const Color(0xFF137333);
        icon = Icons.check_circle_outline;
        break;
      case OrderLifecycleStatus.rejected:
        bg = const Color(0xFFFCE8E6);
        textColor = const Color(0xFFC5221F);
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill.topLeft.x),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 13),
          const SizedBox(width: 4),
          Text(
            status.displayName.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
