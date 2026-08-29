import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/admin_category_model.dart';
import '../../bloc/admin_bloc.dart';
import '../../bloc/admin_event.dart';
import '../widgets/image_picker_dialog.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final AdminCategoryModel? category;

  const AddEditCategoryScreen({super.key, this.category});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _segmentController;
  String _iconUrl = '';
  String _bannerUrl = '';
  List<AdminCategoryStyle> _styles = [];

  final _styleNameCtrl = TextEditingController();
  String _styleImage = 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80';

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameController = TextEditingController(text: c?.name ?? '');
    _segmentController = TextEditingController(text: c?.segment ?? 'Women');
    _iconUrl = c?.iconUrl ?? 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=300&q=80';
    _bannerUrl = c?.bannerUrl ?? 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=800&q=80';
    _styles = c != null ? List.from(c.styles) : [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _segmentController.dispose();
    _styleNameCtrl.dispose();
    super.dispose();
  }

  void _openImagePicker(bool isIcon) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ImagePickerDialog(
        currentImageUrl: isIcon ? _iconUrl : _bannerUrl,
        title: isIcon ? 'Select Category Icon Image' : 'Select Category Banner Image',
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        if (isIcon) {
          _iconUrl = result;
        } else {
          _bannerUrl = result;
        }
      });
    }
  }

  void _pickStyleImage() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ImagePickerDialog(
        currentImageUrl: _styleImage,
        title: 'Select Sub-Style Image Link',
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _styleImage = result;
      });
    }
  }

  void _editExistingStyleImage(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => ImagePickerDialog(
        currentImageUrl: _styles[index].imageUrl,
        title: 'Update Image for "${_styles[index].name}"',
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _styles[index] = _styles[index].copyWith(imageUrl: result);
      });
    }
  }

  void _addStyle() {
    final name = _styleNameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _styles.add(AdminCategoryStyle(
        id: 'style_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        imageUrl: _styleImage,
      ));
      _styleNameCtrl.clear();
    });
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    final cat = AdminCategoryModel(
      id: widget.category?.id ?? _nameController.text.trim().toLowerCase().replaceAll(' ', '_'),
      name: _nameController.text.trim(),
      iconUrl: _iconUrl,
      bannerUrl: _bannerUrl,
      segment: _segmentController.text.trim(),
      styles: _styles,
      itemCount: widget.category?.itemCount ?? 0,
    );

    if (widget.category == null) {
      context.read<AdminBloc>().add(AdminAddCategory(cat));
    } else {
      context.read<AdminBloc>().add(AdminUpdateCategory(cat));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        title: Text(isEdit ? 'Edit Category' : 'Create Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.auraGold),
            onPressed: _saveCategory,
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
              // Main Category Cover & Icon Image Picker
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.sandalDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.auraGold, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: _iconUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.category, size: 40),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: () => _openImagePicker(true),
                      icon: const Icon(Icons.photo_camera, size: 16, color: AppColors.auraGold),
                      label: const Text('Update Category Image (Instagram / URL)', style: TextStyle(color: AppColors.auraGold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Title',
                  hintText: 'e.g. Necklaces & Chokers, Bangles, Bridal',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Segment (Women, Men, Bridal, Kids)
              TextFormField(
                controller: _segmentController,
                decoration: const InputDecoration(
                  labelText: 'Audience / Segment',
                  hintText: 'e.g. Women, Men, Bridal, Unisex',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sub-styles & Collections section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUB-STYLES & IMAGES (${_styles.length})',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Add style field with image picker
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickStyleImage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.auraGold),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: _styleImage,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.image, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _styleNameCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Sub-style name (e.g. Solitaire, Choker)',
                        filled: true,
                        fillColor: AppColors.warmWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addStyle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.auraGold,
                      foregroundColor: AppColors.maroonBlack,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Style list with direct image change tap
              if (_styles.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _styles.length,
                  itemBuilder: (context, idx) {
                    final st = _styles[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        dense: true,
                        leading: GestureDetector(
                          onTap: () => _editExistingStyleImage(idx),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(st.imageUrl),
                            radius: 18,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.maroonDeep,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 8),
                              ),
                            ),
                          ),
                        ),
                        title: Text(st.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Tap thumbnail to change sub-style image', style: TextStyle(fontSize: 10, color: AppColors.charcoalMuted)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 18),
                          onPressed: () {
                            setState(() => _styles.removeAt(idx));
                          },
                        ),
                      ),
                    );
                  },
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
                    onPressed: _saveCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.maroonBlack,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: Text(
                      isEdit ? 'SAVE CATEGORY' : 'CREATE CATEGORY',
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
