import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../products/domain/models/product_model.dart';
import '../../domain/models/offer_model.dart';
import '../../domain/models/combo_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import 'add_edit_offer_screen.dart';
import 'add_edit_combo_screen.dart';

class AdminOffersCombosScreen extends StatefulWidget {
  final List<OfferModel> offers;
  final List<ComboModel> combos;
  final List<ProductModel> products;

  const AdminOffersCombosScreen({
    super.key,
    required this.offers,
    required this.combos,
    required this.products,
  });

  @override
  State<AdminOffersCombosScreen> createState() => _AdminOffersCombosScreenState();
}

class _AdminOffersCombosScreenState extends State<AdminOffersCombosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: const Text('Offers & Combo Sets'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.auraGold,
          labelColor: AppColors.maroonDeep,
          unselectedLabelColor: AppColors.charcoalMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'PROMO OFFERS (${widget.offers.length})'),
            Tab(text: 'CURATED COMBOS (${widget.combos.length})'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.auraGold, size: 28),
            onPressed: () {
              if (_tabController.index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const AddEditOfferScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AddEditComboScreen(allProducts: widget.products),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Offers Tab
          _buildOffersTab(),
          // Combos Tab
          _buildCombosTab(),
        ],
      ),
    );
  }

  Widget _buildOffersTab() {
    if (widget.offers.isEmpty) {
      return const Center(child: Text('No active promo coupons.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl).copyWith(bottom: 80),
      itemCount: widget.offers.length,
      itemBuilder: (context, idx) {
        final offer = widget.offers[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(
              color: offer.isActive
                  ? AppColors.auraGold.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.sandalDark,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.auraGold),
                      ),
                      child: Text(
                        offer.code,
                        style: const TextStyle(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          offer.isActive ? 'Active' : 'Paused',
                          style: TextStyle(
                            color: offer.isActive ? Colors.green.shade800 : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Switch(
                          value: offer.isActive,
                          activeColor: AppColors.auraGold,
                          onChanged: (val) {
                            context.read<AdminBloc>().add(AdminToggleOfferStatus(offer.id, val));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  offer.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.discountType == 'percentage'
                      ? 'Discount: ${offer.discountValue.toStringAsFixed(0)}% (Min Cart: ₹${offer.minOrderValue.toStringAsFixed(0)})'
                      : 'Discount: Flat ₹${offer.discountValue.toStringAsFixed(0)} (Min Cart: ₹${offer.minOrderValue.toStringAsFixed(0)})',
                  style: const TextStyle(color: AppColors.maroonDeep, fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valid till: ${offer.validTill} · Redeemed: ${offer.usageCount} times',
                  style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 11.5),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => AddEditOfferScreen(offer: offer)),
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        context.read<AdminBloc>().add(AdminDeleteOffer(offer.id));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCombosTab() {
    if (widget.combos.isEmpty) {
      return const Center(child: Text('No curated combo sets created.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl).copyWith(bottom: 80),
      itemCount: widget.combos.length,
      itemBuilder: (context, idx) {
        final combo = widget.combos[idx];

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: AppColors.auraGold.withValues(alpha: 0.25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.sandal,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: combo.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.auraGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          combo.tag.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.maroonDeep,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        combo.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '₹${combo.comboPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.maroonDeep,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${combo.originalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.charcoalFaint,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${combo.discountPercent.toStringAsFixed(0)}% OFF)',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Includes ${combo.includedProductNames.length} Pieces · Stock: ${combo.stockCount}',
                        style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.auraGold, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => AddEditComboScreen(
                              combo: combo,
                              allProducts: widget.products,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () {
                        context.read<AdminBloc>().add(AdminDeleteCombo(combo.id));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
