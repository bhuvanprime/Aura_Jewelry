import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../products/domain/models/product_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../widgets/image_picker_dialog.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product; // If null, it's Add Mode. If not, it's Edit Mode.

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _sizesController;
  late TextEditingController _weightController;
  late TextEditingController _makingChargesController;
  late TextEditingController _stockController;

  String _imageUrl = '';
  String _selectedCategory = 'necklace';
  String _selectedKarat = '22K';

  final List<String> _categories = [
    'necklace',
    'earring',
    'ring',
    'bangle',
    'bridal',
  ];

  final List<String> _karats = [
    '24K',
    '22K',
    '18K',
    '14K',
    'Platinum',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _sizesController = TextEditingController(text: p?.availableSizes.join(', ') ?? '6, 7, 8, 9');
    _weightController = TextEditingController(text: p != null ? p.grossWeightGrams.toStringAsFixed(1) : '12.5');
    _makingChargesController = TextEditingController(text: p != null ? p.makingChargesPercent.toStringAsFixed(1) : '10.0');
    _stockController = TextEditingController(text: p != null ? p.stockCount.toString() : '10');

    _imageUrl = p?.imageUrl ?? 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80';
    _selectedCategory = p?.categoryId ?? 'necklace';
    _selectedKarat = p?.karat ?? '22K';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _sizesController.dispose();
    _weightController.dispose();
    _makingChargesController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _openImagePicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ImagePickerDialog(
        currentImageUrl: _imageUrl,
        title: 'Update Jewelry Piece Image',
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _imageUrl = result;
      });
    }
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();
    final weight = double.tryParse(_weightController.text.trim()) ?? 10.0;
    final makingCharges = double.tryParse(_makingChargesController.text.trim()) ?? 10.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 10;

    final sizes = _sizesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final productToSave = ProductModel(
      id: widget.product?.id ?? '',
      name: name,
      price: price,
      rating: widget.product?.rating ?? 4.9,
      imageUrl: _imageUrl,
      description: description,
      availableSizes: sizes,
      categoryId: _selectedCategory,
      karat: _selectedKarat,
      grossWeightGrams: weight,
      makingChargesPercent: makingCharges,
      stockCount: stock,
    );

    if (widget.product == null) {
      context.read<AdminBloc>().add(AdminAddProduct(productToSave));
    } else {
      context.read<AdminBloc>().add(AdminUpdateProduct(productToSave));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: Text(isEdit ? 'Edit Jewelry Item' : 'Add New Jewelry Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.auraGold),
            onPressed: _saveProduct,
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
              // Image Preview & Upload Banner
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.sandalDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.auraGold, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: _imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                            )
                          : const Icon(Icons.diamond_outlined, size: 50, color: AppColors.auraGold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: _openImagePicker,
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: const Text('Update / Choose Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.auraGold,
                        foregroundColor: AppColors.maroonBlack,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                'JEWELRY DETAILS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.charcoalMuted,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Item Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Jewelry Piece Name',
                  hintText: 'e.g. Royal Nizam Polki Necklace',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Category & Karat Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                      items: _categories.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedKarat,
                      decoration: const InputDecoration(
                        labelText: 'Purity / Metal',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                      items: _karats.map((k) {
                        return DropdownMenuItem(
                          value: k,
                          child: Text(k),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedKarat = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Price, Weight, Making Charges
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Retail Price (₹)',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Gross Weight (g)',
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
                      controller: _makingChargesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Making Charges (%)',
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
                        labelText: 'Stock Units',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Sizes
              TextFormField(
                controller: _sizesController,
                decoration: const InputDecoration(
                  labelText: 'Available Sizes (comma separated)',
                  hintText: 'e.g. 16 Inch, 18 Inch, 20 Inch',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Craftsmanship & Gemstone Description',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Save CTA
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.goldCta,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.maroonBlack,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: Text(
                      isEdit ? 'SAVE CHANGES' : 'PUBLISH TO CATALOG',
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
