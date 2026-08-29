import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_url_resolver.dart';

/// Modal dialog allowing the single authorized Admin to update images
/// via custom URL or choose from curated high-resolution luxury jewelry presets.
class ImagePickerDialog extends StatefulWidget {
  final String currentImageUrl;
  final String title;

  const ImagePickerDialog({
    super.key,
    required this.currentImageUrl,
    this.title = 'Select or Update Image',
  });

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  late TextEditingController _urlController;
  String _previewUrl = '';

  static const List<Map<String, String>> _curatedLuxuryImages = [
    {
      'title': 'Nizam Polki Choker',
      'category': 'Necklace',
      'url': 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Royal Temple Haar',
      'category': 'Necklace',
      'url': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Solitaire Diamond Ring',
      'category': 'Ring',
      'url': 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Kundan Peacock Ring',
      'category': 'Ring',
      'url': 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Mayur Chandbali Jhumka',
      'category': 'Earrings',
      'url': 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Diamond Floral Studs',
      'category': 'Earrings',
      'url': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Rajwada Antique Kada',
      'category': 'Bangles',
      'url': 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Diamond Tennis Bracelet',
      'category': 'Bangles',
      'url': 'https://images.unsplash.com/photo-1599643477877-530eb83abc8e?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Complete Bridal Trousseau',
      'category': 'Bridal Sets',
      'url': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.currentImageUrl);
    _previewUrl = widget.currentImageUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.sandal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: const BorderSide(color: AppColors.auraGold, width: 1.5),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 680),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.charcoal),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter an image URL or choose from curated high-res heritage jewelry assets.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.charcoalMuted,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Live Preview Container
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.sandalDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.auraGold, width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _previewUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _previewUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, color: AppColors.charcoalFaint, size: 40),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image, color: AppColors.auraGold, size: 48),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // URL Input
              TextField(
                controller: _urlController,
                onChanged: (val) {
                  final resolved = ImageUrlResolver.resolve(val);
                  setState(() {
                    _previewUrl = resolved;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Image Web URL or Instagram Post Link',
                  hintText: 'https://instagram.com/p/... or https://...',
                  filled: true,
                  fillColor: AppColors.warmWhite,
                  prefixIcon: const Icon(Icons.link, color: AppColors.auraGold),
                  helperText: 'Supports Instagram public post links, Pinterest, Imgur & web image URLs',
                  helperStyle: const TextStyle(fontSize: 10.5, color: AppColors.charcoalMuted),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: AppColors.auraGold),
                    onPressed: () {
                      final resolved = ImageUrlResolver.resolve(_urlController.text);
                      setState(() {
                        _previewUrl = resolved;
                        _urlController.text = resolved;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              Text(
                'Curated Luxury Jewelry Gallery:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Grid of presets
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _curatedLuxuryImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, idx) {
                  final item = _curatedLuxuryImages[idx];
                  final isSelected = _previewUrl == item['url'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _previewUrl = item['url']!;
                        _urlController.text = item['url']!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: isSelected ? AppColors.auraGold : AppColors.hairline,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item['url']!,
                            fit: BoxFit.cover,
                          ),
                          if (isSelected)
                            Container(
                              color: AppColors.maroonDeep.withValues(alpha: 0.35),
                              child: const Center(
                                child: Icon(Icons.check_circle, color: AppColors.auraGoldLight, size: 28),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.hairline),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.goldCta,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, _previewUrl.trim());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: AppColors.maroonBlack,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                        child: const Text('Save Image'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
