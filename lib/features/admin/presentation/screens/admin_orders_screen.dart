import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/order_model.dart';
import '../widgets/admin_order_status_badge.dart';
import 'order_detail_screen.dart';

class AdminOrdersScreen extends StatefulWidget {
  final List<OrderModel> orders;

  const AdminOrdersScreen({super.key, required this.orders});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> _filterOrders(int tabIndex) {
    List<OrderModel> baseList;
    switch (tabIndex) {
      case 1:
        baseList = widget.orders.where((o) => o.status.isActive).toList();
        break;
      case 2:
        baseList = widget.orders.where((o) => o.status.isCompleted).toList();
        break;
      case 3:
        baseList = widget.orders.where((o) => o.status.isRejected).toList();
        break;
      case 0:
      default:
        baseList = widget.orders;
        break;
    }

    if (_searchQuery.isEmpty) return baseList;

    return baseList.where((o) {
      return o.orderNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.customerPhone.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = widget.orders.where((o) => o.status.isActive).length;
    final completedCount = widget.orders.where((o) => o.status.isCompleted).length;
    final rejectedCount = widget.orders.where((o) => o.status.isRejected).length;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: const Text('Customer Orders & Fulfillment'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.auraGold,
          labelColor: AppColors.maroonDeep,
          unselectedLabelColor: AppColors.charcoalMuted,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: [
            Tab(text: 'ALL (${widget.orders.length})'),
            Tab(text: 'ACTIVE ($activeCount)'),
            Tab(text: 'COMPLETED ($completedCount)'),
            Tab(text: 'REJECTED ($rejectedCount)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search order number, customer name or phone...',
                prefixIcon: const Icon(Icons.search, color: AppColors.auraGold),
                filled: true,
                fillColor: AppColors.warmWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(_filterOrders(0)),
                _buildOrderList(_filterOrders(1)),
                _buildOrderList(_filterOrders(2)),
                _buildOrderList(_filterOrders(3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No orders found under this category.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm).copyWith(bottom: 80),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final order = list[idx];

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: AppColors.auraGold.withValues(alpha: 0.2)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => OrderDetailScreen(order: order)),
              );
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      AdminOrderStatusBadge(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.customerName} · ${order.customerPhone}',
                    style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.items.length} Items · ${order.items.map((i) => i.productName).join(", ")}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${order.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                            style: const TextStyle(color: AppColors.charcoalFaint, fontSize: 11),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.auraGold, size: 20),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
