import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/order_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../widgets/admin_order_status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  void _showRejectDialog(BuildContext context) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.sandal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        title: const Text('Decline / Reject Order', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provide reason for declining Order ${order.orderNumber}:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Gemstone out of stock / Address unverified / Size unavailable',
                filled: true,
                fillColor: AppColors.warmWhite,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              final reason = reasonCtrl.text.trim();
              Navigator.pop(ctx);
              context.read<AdminBloc>().add(
                    AdminUpdateOrderStatus(
                      order.id,
                      OrderLifecycleStatus.rejected,
                      rejectionReason: reason.isNotEmpty ? reason : 'Declined by store administrator.',
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Reject Order', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: Text(order.orderNumber),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Date Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.auraGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER STATUS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.charcoalMuted,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                      ),
                      const SizedBox(height: 4),
                      AdminOrderStatusBadge(status: order.status),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'PLACED ON',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.charcoalMuted,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (order.rejectionReason != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE8E6),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rejection Reason: ${order.rejectionReason}',
                        style: const TextStyle(color: Color(0xFFC5221F), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Customer Details
            Text(
              'CUSTOMER & SHIPPING DETAILS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: AppColors.auraGold, size: 18),
                        const SizedBox(width: 8),
                        Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, color: AppColors.auraGold, size: 18),
                        const SizedBox(width: 8),
                        Text(order.customerPhone, style: const TextStyle(color: AppColors.charcoalMuted)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.auraGold, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(order.shippingAddress, style: const TextStyle(color: AppColors.charcoalMuted)),
                        ),
                      ],
                    ),
                    if (order.trackingNumber != null) ...[
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping, color: AppColors.auraGold, size: 18),
                          const SizedBox(width: 8),
                          Text('Armored Tracking: ${order.trackingNumber}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.maroonDeep)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Ordered Items
            Text(
              'ORDERED JEWELRY PIECES (${order.items.length})',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, idx) {
                final item = order.items[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.sandal,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover),
                    ),
                    title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    subtitle: Text('Qty: ${item.quantity} · ${item.karat} · ${item.grossWeightGrams}g ${item.size != null ? "· Size: ${item.size}" : ""}'),
                    trailing: Text(
                      '₹${item.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.maroonDeep),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Payment Summary
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('₹${order.subtotal.toStringAsFixed(0)}'),
                      ],
                    ),
                    if (order.discountAmount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount:', style: TextStyle(color: Colors.green)),
                          Text('-₹${order.discountAmount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GST / Insured Tax (3%):'),
                        Text('₹${order.taxAmount.toStringAsFixed(0)}'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Paid:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('₹${order.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.maroonDeep)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action / Status Changer Buttons
            Text(
              'UPDATE ORDER LIFECYCLE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (order.status == OrderLifecycleStatus.pending) ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Accept & Move to Workshop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5460),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<AdminBloc>().add(
                            AdminUpdateOrderStatus(order.id, OrderLifecycleStatus.processing),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
                if (order.status == OrderLifecycleStatus.processing) ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.local_shipping, size: 16),
                    label: const Text('Dispatch / Mark Shipped'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B21A8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<AdminBloc>().add(
                            AdminUpdateOrderStatus(order.id, OrderLifecycleStatus.shipped),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
                if (order.status == OrderLifecycleStatus.shipped) ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.verified, size: 16),
                    label: const Text('Mark Delivered & Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF137333),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<AdminBloc>().add(
                            AdminUpdateOrderStatus(order.id, OrderLifecycleStatus.delivered),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
                if (order.status.isActive) ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
                    label: const Text('Decline / Reject Order', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () => _showRejectDialog(context),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
