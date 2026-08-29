import '../../../products/domain/models/product_model.dart';

abstract class AdminRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
}
