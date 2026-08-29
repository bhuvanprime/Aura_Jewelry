import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../products/domain/models/product_model.dart';
import '../../domain/models/combo_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../widgets/image_picker_dialog.dart';

class AddEditComboScreen extends StatefulWidget {
  final ComboModel? combo;
  final List<ProductModel> allProducts;

  const AddEditComboScreen({
    super.key,
    this.combo,
    required this.allProducts,
  });

  @override
  State<AddEditComboScreen> createState() => _AddEditComboScreenState();
}

class _AddEditComboScreenState extends State<AddEditComboScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _comboPriceController;
  late TextEditingController _tagController;
  late TextEditingController _stockController;

  String _imageUrl = '';
  List<String> _selectedProductIds = [];
  bool _inStock = true;

  @override
  void initState() {
    super.initState();
    final c = widget.combo;
    _titleController = TextEditingController(text: c?.title ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _comboPriceController = TextEditingController(text: c != null ? c.comboPrice.toStringAsFixed(0) : '');
    _tagController = TextEditingController(text: c?.tag ?? 'Bridal Special');
    _stockController = TextEditingController(text: c != null ? c.stockCount.toString() : '5');
    _imageUrl = c?.imageUrl ?? 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80';
    _selectedProductIds = c != null ? List.from(c.includedProductIds) : [];
    _inStock = c?.inStock ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _comboPriceController.dispose();
    _tagController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  double get _calculatedOriginalPrice {
    double total = 0;
    for (final id in _selectedProductIds) {
      final p = widget.allProducts.firstWhere(
        (prod) => prod.id == id,
        orElse: () => const ProductModel(id: '', name: '', price: 0, rating: 0, imageUrl: ''),
      );
      total += p.price;
    }
    return total;
  }

  void _openImagePicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ImagePickerDialog(
        currentImageUrl: _imageUrl,
        title: 'Select Jewelry Set / Combo Image',
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _imageUrl = result;
      });
    }
  }

  void _saveCombo() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one included jewelry item.')),
      );
      return;
    }

    final originalPrice = _calculatedOriginalPrice;
    final comboPrice = double.tryParse(_comboPriceController.text.trim()) ?? originalPrice;
    final discount = originalPrice > 0 ? (((originalPrice - comboPrice) / originalPrice) * 100) : 0.0;

    final names = _selectedProductIds.map((id) {
      final p = widget.allProducts.firstWhere(
        (prod) => prod.id == id,
        orElse: () => const ProductModel(id: '', name: 'Jewelry Piece', price: 0, rating: 0, imageUrl: ''),
      );
      return p.name;
    }).toList();

    final combo = ComboModel(
      id: widget.combo?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      originalPrice: originalPrice,
      comboPrice: comboPrice,
      discountPercent: discount > 0 ? discount : 0,
      includedProductIds: _selectedProductIds,
      includedProductNames: names,
      imageUrl: _imageUrl,
      tag: _tagController.text.trim(),
      inStock: _inStock,
      stockCount: int.tryParse(_stockController.text.trim()) ?? 5,
    );

    if (widget.combo == null) {
      context.read<AdminBloc>().add(AdminAddCombo(combo));
    } else {
      context.read<AdminBloc>().add(AdminUpdateCombo(combo));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.combo != null;
    final originalPrice = _calculatedOriginalPrice;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: Text(isEdit ? 'Edit Combo Set' : 'Create Bridal / Combo Set'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.auraGold),
            onPressed: _saveCombo,
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
              // Image Picker
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.sandalDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.auraGold, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: _imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: _openImagePicker,
                      icon: const Icon(Icons.photo_library_outlined, size: 16, color: AppColors.auraGold),
                      label: const Text('Update Combo Image', style: TextStyle(color: AppColors.auraGold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Combo / Set Name',
                  hintText: 'e.g. Imperial Nizam Bridal Suite',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: 'Tag / Badge',
                        hintText: 'e.g. Bridal Special, Wedding Edit',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Combo Stock Count',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Price Breakdown Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warmWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.auraGold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Individual Sum Price:', style: TextStyle(color: AppColors.charcoalMuted)),
                        Text('₹${originalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _comboPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discounted Combo Offer Price (₹)',
                        hintText: 'e.g. 345000',
                        filled: true,
                        fillColor: AppColors.sandal,
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'SELECT INCLUDED PIECES (${_selectedProductIds.length})',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Multi-select product list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.allProducts.length,
                itemBuilder: (context, idx) {
                  final p = widget.allProducts[idx];
                  final isChecked = _selectedProductIds.contains(p.id);

                  return CheckboxListTile(
                    value: isChecked,
                    activeColor: AppColors.auraGold,
                    checkColor: AppColors.maroonBlack,
                    title: Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('₹${p.price.toStringAsFixed(0)} · ${p.karat}'),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.sandal,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.cover),
                    ),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedProductIds.add(p.id);
                        } else {
                          _selectedProductIds.remove(p.id);
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Combo Description & Inclusions',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.goldCta,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: ElevatedButton(
                    onPressed: _saveCombo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.maroonBlack,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: Text(
                      isEdit ? 'SAVE COMBO' : 'PUBLISH COMBO SET',
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
