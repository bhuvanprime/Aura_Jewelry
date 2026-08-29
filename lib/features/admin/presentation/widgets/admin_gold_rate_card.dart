import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../../domain/models/gold_rate_model.dart';

class AdminGoldRateCard extends StatelessWidget {
  final GoldRateModel rates;

  const AdminGoldRateCard({super.key, required this.rates});

  void _showEditRatesDialog(BuildContext context) {
    final gold24kCtrl = TextEditingController(text: rates.gold24kPerGram.toStringAsFixed(0));
    final gold22kCtrl = TextEditingController(text: rates.gold22kPerGram.toStringAsFixed(0));
    final gold18kCtrl = TextEditingController(text: rates.gold18kPerGram.toStringAsFixed(0));
    final silverCtrl = TextEditingController(text: rates.silverPerGram.toStringAsFixed(2));
    final changeCtrl = TextEditingController(text: rates.dailyChangePercent.toStringAsFixed(2));
    bool isUp = rates.isUp;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.sandal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            side: const BorderSide(color: AppColors.auraGold, width: 1.5),
          ),
          title: Row(
            children: [
              const Icon(Icons.currency_rupee, color: AppColors.auraGold),
              const SizedBox(width: 8),
              Text(
                'Update Live Metal Rates',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: gold24kCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '24K Gold Rate (₹/g)',
                    filled: true,
                    fillColor: AppColors.warmWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: gold22kCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '22K Gold Rate (₹/g)',
                    filled: true,
                    fillColor: AppColors.warmWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: gold18kCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '18K Gold Rate (₹/g)',
                    filled: true,
                    fillColor: AppColors.warmWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: silverCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Silver Rate (₹/g)',
                    filled: true,
                    fillColor: AppColors.warmWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: changeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Variation %',
                          filled: true,
                          fillColor: AppColors.warmWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ChoiceChip(
                      label: Text(isUp ? '▲ Up' : '▼ Down'),
                      selected: isUp,
                      selectedColor: isUp ? const Color(0xFFD4EDDA) : const Color(0xFFF8D7DA),
                      onSelected: (val) {
                        setDialogState(() {
                          isUp = !isUp;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.charcoalMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.auraGold,
                foregroundColor: AppColors.maroonBlack,
              ),
              onPressed: () {
                final updatedRates = rates.copyWith(
                  gold24kPerGram: double.tryParse(gold24kCtrl.text) ?? rates.gold24kPerGram,
                  gold22kPerGram: double.tryParse(gold22kCtrl.text) ?? rates.gold22kPerGram,
                  gold18kPerGram: double.tryParse(gold18kCtrl.text) ?? rates.gold18kPerGram,
                  silverPerGram: double.tryParse(silverCtrl.text) ?? rates.silverPerGram,
                  dailyChangePercent: double.tryParse(changeCtrl.text) ?? rates.dailyChangePercent,
                  isUp: isUp,
                  lastUpdated: DateTime.now(),
                );
                Navigator.pop(ctx);
                context.read<AdminBloc>().add(AdminUpdateGoldRates(updatedRates));
              },
              child: const Text('Broadcast Live Rate'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.maroonDeep, AppColors.maroonBlack],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.auraGold, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.auraGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.show_chart, color: AppColors.maroonBlack, size: 16),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'LIVE MARKET METALS (TODAY)',
                    style: TextStyle(
                      color: AppColors.auraGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_note, color: AppColors.auraGoldLight, size: 22),
                tooltip: 'Edit Live Metal Prices',
                onPressed: () => _showEditRatesDialog(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildMetalTile(
                context,
                title: '22K Gold',
                rate: '₹${rates.gold22kPerGram.toStringAsFixed(0)}/g',
                change: '${rates.isUp ? '▲' : '▼'} ${rates.dailyChangePercent}%',
                isHighlight: true,
              ),
              const SizedBox(width: 8),
              _buildMetalTile(
                context,
                title: '24K Gold',
                rate: '₹${rates.gold24kPerGram.toStringAsFixed(0)}/g',
                change: 'Pure Standard',
              ),
              const SizedBox(width: 8),
              _buildMetalTile(
                context,
                title: 'Silver 999',
                rate: '₹${rates.silverPerGram.toStringAsFixed(2)}/g',
                change: 'Per Gram',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetalTile(
    BuildContext context, {
    required String title,
    required String rate,
    required String change,
    bool isHighlight = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isHighlight
              ? AppColors.auraGold.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isHighlight ? AppColors.auraGold : AppColors.hairline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isHighlight ? AppColors.auraGoldLight : Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              rate,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              change,
              style: TextStyle(
                color: isHighlight ? AppColors.auraGoldLight : Colors.white54,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
