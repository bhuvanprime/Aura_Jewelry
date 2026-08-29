import 'package:equatable/equatable.dart';
import '../../../../features/products/domain/models/product_model.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final String? selectedSize;
  final int quantity;

  const CartItemModel({
    required this.product,
    this.selectedSize,
    this.quantity = 1,
  });

  CartItemModel copyWith({
    ProductModel? product,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  // Unique identifier for a cart item (product id + size)
  String get cartItemId => '${product.id}_${selectedSize ?? "nosize"}';

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, selectedSize, quantity];
}
