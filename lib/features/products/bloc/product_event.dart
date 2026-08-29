import 'package:equatable/equatable.dart';
import '../domain/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductSubscriptionRequested extends ProductEvent {}

class ProductProductsUpdated extends ProductEvent {
  final List<ProductModel> products;
  const ProductProductsUpdated(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductToggleWishlist extends ProductEvent {
  final String productId;
  final bool isWishlisted;
  const ProductToggleWishlist(this.productId, this.isWishlisted);

  @override
  List<Object?> get props => [productId, isWishlisted];
}
