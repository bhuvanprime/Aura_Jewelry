import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../admin/domain/models/admin_category_model.dart';
import '../../../categories/presentation/screens/category_items_screen.dart';

/// Premium category strip connected 100% live to Cloud Firestore `/categories`.
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key});

  IconData _getIconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ring')) return Icons.diamond_outlined;
    if (lower.contains('neck') || lower.contains('haar')) return Icons.accessibility_new_outlined;
    if (lower.contains('ear') || lower.contains('jhumka')) return Icons.radio_button_unchecked;
    if (lower.contains('bangle') || lower.contains('kada') || lower.contains('bracelet')) return Icons.panorama_fish_eye;
    if (lower.contains('bridal') || lower.contains('wedding')) return Icons.auto_awesome_outlined;
    return Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseService.instance.firestore.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final categories = snapshot.data!.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return AdminCategoryModel.fromJson(data);
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl,
            horizontal: AppSpacing.lg,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => CategoryItemsScreen(
                          categoryId: cat.id,
                          categoryName: cat.name,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.warmWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.auraGold.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getIconForCategory(cat.name),
                              color: AppColors.maroonDeep,
                              size: 23,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat.name,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.charcoalMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
