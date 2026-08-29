import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/constants/app_strings.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import 'checkout_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        title: Text(
          AppStrings.shoppingBag,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.charcoalFaint),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.yourBagIsEmpty,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.charcoalMuted,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: AppColors.maroonCta,
                      borderRadius: AppSpacing.borderRadiusPill,
                      boxShadow: AppShadows.whisper,
                    ),
                    child: ElevatedButton(
                      onPressed: () {}, // would route to Home/Shop in real app
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.transparent,
                        shadowColor: AppColors.transparent,
                        foregroundColor: AppColors.warmWhite,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: const Text(AppStrings.startShopping),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return CartItemTile(item: state.items[index]);
                  },
                ),
              ),
              // Order Summary
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.sandalDark,
                  border: const Border(
                    top: BorderSide(color: AppColors.hairlineLight),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SummaryRow(title: AppStrings.subtotal, amount: '\$${state.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _SummaryRow(title: AppStrings.flatShipping, amount: '\$${state.shipping.toStringAsFixed(2)}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      _SummaryRow(
                        title: AppStrings.total,
                        amount: '\$${state.total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.maroonCta,
                            borderRadius: AppSpacing.borderRadiusPill,
                            boxShadow: AppShadows.whisper,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(CartCleared());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutSuccessScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.transparent,
                              shadowColor: AppColors.transparent,
                              foregroundColor: AppColors.warmWhite,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            ),
                            child: const Text(AppStrings.checkout),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? Theme.of(context).textTheme.headlineSmall
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoalMuted,
                  ),
        ),
        Text(
          amount,
          style: isTotal
              ? Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.auraGold)
              : Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
