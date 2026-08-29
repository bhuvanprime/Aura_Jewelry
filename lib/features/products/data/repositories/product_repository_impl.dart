import 'dart:async';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final _controller = StreamController<List<ProductModel>>.broadcast();
  
  final List<ProductModel> _mockProducts = [
    // RINGS
    ProductModel(
      id: 'ring_1',
      name: 'Solitaire Diamond Ring',
      price: 1250.00,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=800&q=80',
      description: 'A classic 1-carat brilliant cut diamond solitaire set in 18k white gold.',
      availableSizes: ['6', '7', '8'],
    ),
    ProductModel(
      id: 'ring_2',
      name: 'Eternity Band',
      price: 2100.00,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=800&q=80',
      description: 'A beautiful eternity band featuring pave diamonds wrapping entirely around the finger.',
      availableSizes: ['6', '7', '8', '9'],
    ),
    ProductModel(
      id: 'ring_3',
      name: 'Sapphire Halo Ring',
      price: 3400.00,
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=800&q=80',
      description: 'Stunning deep blue sapphire surrounded by a halo of brilliant white diamonds.',
      availableSizes: ['6', '7', '8'],
    ),
    // EARRINGS
    ProductModel(
      id: 'earring_1',
      name: 'Diamond Studs',
      price: 850.00,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=800&q=80',
      description: 'Elegant and simple diamond stud earrings for everyday luxury.',
      availableSizes: [],
    ),
    ProductModel(
      id: 'earring_2',
      name: 'Pearl Drop Earrings',
      price: 650.00,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1629224316810-9d8805b95e76?auto=format&fit=crop&w=800&q=80',
      description: 'South Sea pearls elegantly dropping from a diamond-accented post.',
      availableSizes: [],
    ),
    ProductModel(
      id: 'earring_3',
      name: 'Gold Hoop Earrings',
      price: 450.00,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=800&q=80',
      description: 'Timeless 14k solid yellow gold hoops.',
      availableSizes: [],
    ),
    // WATCHES
    ProductModel(
      id: 'watch_1',
      name: 'Chronograph Classic',
      price: 5200.00,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=800&q=80',
      description: 'A precision-crafted Swiss chronograph with a rich leather band.',
      availableSizes: [],
    ),
    ProductModel(
      id: 'watch_2',
      name: 'Silver Aviator Watch',
      price: 4800.00,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=800&q=80',
      description: 'Sleek stainless steel aviator watch with automatic movement.',
      availableSizes: [],
    ),
    // BRACELETS
    ProductModel(
      id: 'bracelet_1',
      name: 'Tennis Bracelet',
      price: 4200.00,
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=800&q=80',
      description: 'A luxurious line of identical diamonds perfectly matched for brilliance.',
      availableSizes: ['S', 'M', 'L'],
    ),
    ProductModel(
      id: 'bracelet_2',
      name: 'Gold Chain Link',
      price: 1800.00,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1573408301145-b98c4af3066b?auto=format&fit=crop&w=800&q=80',
      description: 'Bold 18k yellow gold chain link bracelet, perfect for stacking.',
      availableSizes: ['M', 'L'],
    ),
  ];

  ProductRepositoryImpl() {
    // Initial emit
    _controller.add(_mockProducts);
  }

  @override
  Stream<List<ProductModel>> watchProducts() {
    // Always emit the current list to new listeners
    Future.microtask(() => _controller.add(_mockProducts));
    return _controller.stream;
  }

  @override
  Future<void> toggleWishlist(String productId, bool newStatus) async {
    final index = _mockProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = _mockProducts[index];
      _mockProducts[index] = ProductModel(
        id: product.id,
        name: product.name,
        price: product.price,
        rating: product.rating,
        imageUrl: product.imageUrl,
        description: product.description,
        availableSizes: product.availableSizes,
        isWishlisted: newStatus,
      );
      // Emit the updated list to all listeners
      _controller.add(List.from(_mockProducts));
    }
  }
  
  void dispose() {
    _controller.close();
  }
}
