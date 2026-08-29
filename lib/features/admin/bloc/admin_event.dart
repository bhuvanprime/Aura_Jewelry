import 'package:equatable/equatable.dart';
import '../../products/domain/models/product_model.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class AdminLoadProducts extends AdminEvent {}

class AdminAddProduct extends AdminEvent {
  final ProductModel product;
  const AdminAddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class AdminUpdateProduct extends AdminEvent {
  final ProductModel product;
  const AdminUpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class AdminDeleteProduct extends AdminEvent {
  final String productId;
  const AdminDeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}
