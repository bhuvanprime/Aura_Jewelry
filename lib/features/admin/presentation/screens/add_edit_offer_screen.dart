import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/offer_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';

class AddEditOfferScreen extends StatefulWidget {
  final OfferModel? offer;

  const AddEditOfferScreen({super.key, this.offer});

  @override
  State<AddEditOfferScreen> createState() => _AddEditOfferScreenState();
}

class _AddEditOfferScreenState extends State<AddEditOfferScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountValueController;
  late TextEditingController _minOrderController;
  late TextEditingController _maxDiscountController;
  late TextEditingController _validTillController;
  String _discountType = 'percentage';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final o = widget.offer;
    _codeController = TextEditingController(text: o?.code ?? '');
    _titleController = TextEditingController(text: o?.title ?? '');
    _descriptionController = TextEditingController(text: o?.description ?? '');
    _discountValueController = TextEditingController(text: o != null ? o.discountValue.toStringAsFixed(0) : '15');
    _minOrderController = TextEditingController(text: o != null ? o.minOrderValue.toStringAsFixed(0) : '50000');
    _maxDiscountController = TextEditingController(text: o != null ? o.maxDiscount.toStringAsFixed(0) : '20000');
    _validTillController = TextEditingController(text: o?.validTill ?? '2026-12-31');
    _discountType = o?.discountType ?? 'percentage';
    _isActive = o?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _validTillController.dispose();
    super.dispose();
  }

  void _saveOffer() {
    if (!_formKey.currentState!.validate()) return;

    final offer = OfferModel(
      id: widget.offer?.id ?? '',
      code: _codeController.text.trim().toUpperCase(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      discountType: _discountType,
      discountValue: double.tryParse(_discountValueController.text.trim()) ?? 10.0,
      minOrderValue: double.tryParse(_minOrderController.text.trim()) ?? 0,
      maxDiscount: double.tryParse(_maxDiscountController.text.trim()) ?? 0,
      validTill: _validTillController.text.trim(),
      isActive: _isActive,
      usageCount: widget.offer?.usageCount ?? 0,
    );

    if (widget.offer == null) {
      context.read<AdminBloc>().add(AdminAddOffer(offer));
    } else {
      context.read<AdminBloc>().add(AdminUpdateOffer(offer));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.offer != null;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: Text(isEdit ? 'Edit Promo Coupon' : 'Create Offer Coupon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.auraGold),
            onPressed: _saveOffer,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Coupon Promo Code',
                  hintText: 'e.g. FESTIVE20, ROYALBRIDAL',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                  prefixIcon: Icon(Icons.local_offer_outlined, color: AppColors.auraGold),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Campaign Title',
                  hintText: 'e.g. Imperial Festive 15% Off',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _discountType,
                      decoration: const InputDecoration(
                        labelText: 'Discount Type',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'percentage', child: Text('Percentage (%)')),
                        DropdownMenuItem(value: 'flat', child: Text('Flat Amount (₹)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _discountType = val);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _discountValueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _discountType == 'percentage' ? 'Discount %' : 'Discount ₹',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minOrderController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Min Cart Total (₹)',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _maxDiscountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max Discount Cap (₹)',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _validTillController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (YYYY-MM-DD)',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                  prefixIcon: Icon(Icons.calendar_today, color: AppColors.auraGold),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Terms & Conditions / Description',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              SwitchListTile(
                title: const Text('Offer Status Active'),
                subtitle: Text(_isActive ? 'Coupon is currently redeemable by customers' : 'Paused / Inactive'),
                value: _isActive,
                activeColor: AppColors.auraGold,
                onChanged: (val) => setState(() => _isActive = val),
              ),

              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.goldCta,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: ElevatedButton(
                    onPressed: _saveOffer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.maroonBlack,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: Text(
                      isEdit ? 'SAVE COUPON' : 'PUBLISH COUPON',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
