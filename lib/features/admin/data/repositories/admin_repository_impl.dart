import '../../../../core/firebase/firebase_service.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../products/domain/models/product_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _firebaseService.firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ProductModel.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    // Generate a new document reference if we want Firestore to create the ID
    // or use the product.id if we generated it. We'll let Firestore generate it
    // by using add() and then updating the model ID.
    // However, our model has an ID. We can just use doc().set()
    final docRef = _firebaseService.firestore.collection('products').doc();
    
    // We update the product with the firestore generated ID
    final newProduct = ProductModel(
      id: docRef.id,
      name: product.name,
      price: product.price,
      rating: product.rating,
      imageUrl: product.imageUrl,
      isWishlisted: product.isWishlisted,
      description: product.description,
      availableSizes: product.availableSizes,
    );

    await docRef.set(newProduct.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _firebaseService.firestore
        .collection('products')
        .doc(product.id)
        .update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _firebaseService.firestore.collection('products').doc(productId).delete();
  }
}
