import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/admin_category_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import 'add_edit_category_screen.dart';

class AdminCategoriesScreen extends StatelessWidget {
  final List<AdminCategoryModel> categories;

  const AdminCategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: const Text('Store Categories & Styles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.auraGold, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const AddEditCategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No categories created yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.xl).copyWith(bottom: 80),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    side: BorderSide(color: AppColors.auraGold.withValues(alpha: 0.25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.sandalDark,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: cat.iconUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => const Icon(Icons.category, color: AppColors.auraGold),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${cat.segment} · ${cat.styles.length} Sub-styles',
                                    style: const TextStyle(
                                      color: AppColors.charcoalMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.auraGold),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => AddEditCategoryScreen(category: cat),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Category'),
                                    content: Text('Are you sure you want to remove "${cat.name}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context.read<AdminBloc>().add(AdminDeleteCategory(cat.id));
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
                        if (cat.styles.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const Divider(height: 1),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: cat.styles.map((st) {
                              return Chip(
                                label: Text(st.name, style: const TextStyle(fontSize: 11)),
                                backgroundColor: AppColors.sandal,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
