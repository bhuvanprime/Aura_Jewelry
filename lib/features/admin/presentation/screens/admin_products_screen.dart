import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../products/domain/models/product_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import 'add_edit_product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  final List<ProductModel> products;

  const AdminProductsScreen({super.key, required this.products});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'necklace',
    'earring',
    'ring',
    'bangle',
    'bridal',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'all' || p.categoryId == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: const Text('Inventory & Catalog Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.auraGold, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const AddEditProductScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.sm),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by jewelry name or keyword...',
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

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
            child: Row(
              children: _categories.map((c) {
                final isSel = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c.toUpperCase()),
                    selected: isSel,
                    selectedColor: AppColors.auraGold,
                    checkmarkColor: AppColors.maroonBlack,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.maroonBlack : AppColors.charcoal,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11,
                    ),
                    backgroundColor: AppColors.warmWhite,
                    onSelected: (_) => setState(() => _selectedCategory = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Products List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No jewelry items found matching filter.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm)
                        .copyWith(bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isLowStock = item.stockCount <= 5;

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          side: BorderSide(
                            color: isLowStock
                                ? Colors.red.withValues(alpha: 0.5)
                                : AppColors.auraGold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.sandal,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl: item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${item.price.toStringAsFixed(0)} · ${item.karat} · ${item.grossWeightGrams}g',
                                      style: const TextStyle(
                                        color: AppColors.maroonDeep,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isLowStock
                                                ? const Color(0xFFFCE8E6)
                                                : const Color(0xFFE6F4EA),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isLowStock
                                                ? 'Low Stock: ${item.stockCount} left'
                                                : 'Stock: ${item.stockCount} units',
                                            style: TextStyle(
                                              color: isLowStock ? Colors.red : Colors.green.shade800,
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Making: ${item.makingChargesPercent}%',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            color: AppColors.charcoalFaint,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Actions
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.auraGold, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => AddEditProductScreen(product: item),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Jewelry Piece'),
                                          content: Text('Are you sure you want to remove "${item.name}" from catalog?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                context.read<AdminBloc>().add(AdminDeleteProduct(item.id));
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
