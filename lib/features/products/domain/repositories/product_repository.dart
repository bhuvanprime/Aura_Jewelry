import '../models/product_model.dart';

abstract class ProductRepository {
  Stream<List<ProductModel>> watchProducts();
  Future<void> toggleWishlist(String productId, bool isWishlisted);
}
