import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/analytics_model.dart';
import '../widgets/admin_metric_card.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  final AdminAnalyticsModel analytics;

  const AdminAnalyticsScreen({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final double completionRate = analytics.totalOrders > 0
        ? (analytics.completedOrdersCount / analytics.totalOrders) * 100
        : 0;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: const Text('Store Analytics & Insights'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue & Performance Metrics
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AdminMetricCard(
                  title: 'Gross Revenue',
                  value: '₹${(analytics.totalRevenue / 100000).toStringAsFixed(2)}L',
                  subtitle: 'All time processed sales',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.auraGold,
                ),
                AdminMetricCard(
                  title: 'Avg Order Value',
                  value: '₹${(analytics.averageOrderValue / 1000).toStringAsFixed(1)}K',
                  subtitle: 'Per transaction size',
                  icon: Icons.shopping_basket_outlined,
                  iconColor: const Color(0xFF0C5460),
                ),
                AdminMetricCard(
                  title: 'Total Orders',
                  value: '${analytics.totalOrders}',
                  subtitle: '${analytics.activeOrdersCount} in workshop/transit',
                  icon: Icons.receipt_long_outlined,
                  iconColor: AppColors.maroonDeep,
                ),
                AdminMetricCard(
                  title: 'Fulfillment Rate',
                  value: '${completionRate.toStringAsFixed(0)}%',
                  subtitle: '${analytics.rejectedOrdersCount} declined orders',
                  icon: Icons.verified_outlined,
                  iconColor: const Color(0xFF137333),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Low Stock / Inventory Alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'INVENTORY HEALTH ALERTS (${analytics.lowStockProducts.length})',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            if (analytics.lowStockProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF137333), size: 18),
                    SizedBox(width: 8),
                    Text('All jewelry pieces are adequately stocked in vault.'),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: analytics.lowStockProducts.length,
                itemBuilder: (context, idx) {
                  final item = analytics.lowStockProducts[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    child: ListTile(
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${item.karat} · ₹${item.price.toStringAsFixed(0)}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE8E6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Only ${item.stockCount} left',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Category Distribution Breakdown
            Text(
              'CATEGORY CATALOG DISTRIBUTION',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: analytics.categoryDistribution.entries.map((entry) {
                    final int total = analytics.totalProducts > 0 ? analytics.totalProducts : 1;
                    final double ratio = entry.value / total;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                '${entry.value} items (${(ratio * 100).toStringAsFixed(0)}%)',
                                style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 11.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: ratio,
                            backgroundColor: AppColors.sandal,
                            color: AppColors.auraGold,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
