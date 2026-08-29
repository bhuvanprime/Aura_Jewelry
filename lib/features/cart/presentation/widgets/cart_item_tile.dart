import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/cart_item_model.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: AppColors.hairlineLight),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.sandal,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        context.read<CartBloc>().add(CartItemRemoved(item.cartItemId));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                if (item.selectedSize != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${item.selectedSize}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.charcoalMuted,
                        ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.auraGold,
                          ),
                    ),
                    // Quantity Stepper
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.hairline),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                    CartItemQuantityUpdated(item.cartItemId, item.quantity - 1),
                                  );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              child: Icon(Icons.remove, size: 16, color: AppColors.charcoal),
                            ),
                          ),
                          Text(
                            item.quantity.toString(),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.charcoal),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                    CartItemQuantityUpdated(item.cartItemId, item.quantity + 1),
                                  );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              child: Icon(Icons.add, size: 16, color: AppColors.charcoal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
