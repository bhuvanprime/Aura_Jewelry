import 'package:equatable/equatable.dart';
import '../domain/models/cart_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final CartItemModel item;
  const CartItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final String cartItemId;
  const CartItemRemoved(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class CartItemQuantityUpdated extends CartEvent {
  final String cartItemId;
  final int quantity;
  const CartItemQuantityUpdated(this.cartItemId, this.quantity);

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class CartCleared extends CartEvent {}
