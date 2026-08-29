import 'package:equatable/equatable.dart';
import '../domain/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  
  const CartState({this.items = const []});

  double get subtotal => items.fold(0, (total, item) => total + item.totalPrice);
  double get shipping => subtotal > 0 ? 50.0 : 0.0; // Flat $50 shipping if not empty
  double get total => subtotal + shipping;

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
