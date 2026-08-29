import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/global_loading.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../../bloc/admin_state.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../widgets/admin_metric_card.dart';
import '../widgets/admin_gold_rate_card.dart';
import 'admin_products_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_offers_combos_screen.dart';
import 'admin_analytics_screen.dart';
import 'add_edit_product_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(AdminLoadAllData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.maroonDeep,
              ),
              child: const Icon(Icons.shield, color: AppColors.auraGoldLight, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'AURA ADMIN PORTAL',
              style: TextStyle(
                color: AppColors.maroonDeep,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.maroonDeep),
            tooltip: 'Refresh Store Data',
            onPressed: () {
              context.read<AdminBloc>().add(AdminLoadAllData());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.maroonDeep),
            tooltip: 'Logout Admin',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.sandal,
                  title: const Text('Logout Administrator'),
                  content: const Text('Are you sure you want to end your Admin session?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.maroonDeep),
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.maroonDeep,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading && state is! AdminLoaded) {
            return const GlobalLoading(message: 'Loading Royal Catalog & Operations...');
          }

          if (state is AdminLoaded) {
            return IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildOverviewTab(context, state),
                AdminProductsScreen(products: state.products),
                AdminOrdersScreen(orders: state.orders),
                AdminCategoriesScreen(categories: state.categories),
                AdminOffersCombosScreen(
                  offers: state.offers,
                  combos: state.combos,
                  products: state.products,
                ),
                AdminAnalyticsScreen(analytics: state.analytics),
              ],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_sync, color: AppColors.auraGold, size: 50),
                const SizedBox(height: 12),
                const Text('Initializing store data...'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<AdminBloc>().add(AdminLoadAllData()),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.auraGold),
                  child: const Text('Retry Load'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          border: const Border(top: BorderSide(color: AppColors.hairlineLight)),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (idx) => setState(() => _selectedTabIndex = idx),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.warmWhite,
          selectedItemColor: AppColors.maroonDeep,
          unselectedItemColor: AppColors.charcoalMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.diamond_outlined),
              activeIcon: Icon(Icons.diamond),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AdminLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Authorized Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.sandalDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.auraGold.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: AppColors.auraGold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Logged in as Master Administrator (Admin@acj.com) · Full Access',
                    style: TextStyle(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Live Gold Rate Controller Card
          AdminGoldRateCard(rates: state.goldRates),
          const SizedBox(height: AppSpacing.xl),

          // High-level Performance Metrics Grid
          Text(
            'KEY BUSINESS METRICS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.maroonDeep,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AdminMetricCard(
                title: 'Total Revenue',
                value: '₹${(state.analytics.totalRevenue / 100000).toStringAsFixed(2)}L',
                subtitle: 'All-time volume',
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => setState(() => _selectedTabIndex = 5),
              ),
              AdminMetricCard(
                title: 'Active Orders',
                value: '${state.analytics.activeOrdersCount}',
                subtitle: 'In workshop / transit',
                icon: Icons.local_shipping_outlined,
                iconColor: const Color(0xFF0C5460),
                onTap: () => setState(() => _selectedTabIndex = 2),
              ),
              AdminMetricCard(
                title: 'Catalog Items',
                value: '${state.products.length}',
                subtitle: '${state.analytics.lowStockProducts.length} low in stock',
                icon: Icons.diamond_outlined,
                iconColor: state.analytics.lowStockProducts.isNotEmpty ? Colors.red : AppColors.auraGold,
                onTap: () => setState(() => _selectedTabIndex = 1),
              ),
              AdminMetricCard(
                title: 'Categories',
                value: '${state.categories.length}',
                subtitle: '${state.offers.length} active coupons',
                icon: Icons.category_outlined,
                iconColor: const Color(0xFF6B21A8),
                onTap: () => setState(() => _selectedTabIndex = 3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Quick Management Actions
          Text(
            'EXECUTIVE SHORTCUTS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.maroonDeep,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Jewelry Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.auraGold,
                    foregroundColor: AppColors.maroonBlack,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const AddEditProductScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long, size: 18),
                  label: const Text('Manage Orders'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.maroonDeep,
                    side: const BorderSide(color: AppColors.maroonDeep),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => setState(() => _selectedTabIndex = 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
