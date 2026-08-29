import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../domain/models/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onItemQuantityUpdated);
    on<CartCleared>(_onCartCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final updatedItems = List<CartItemModel>.from(state.items);
    
    // Check if item already exists (same product AND same size)
    final existingIndex = updatedItems.indexWhere(
        (item) => item.cartItemId == event.item.cartItemId);

    if (existingIndex >= 0) {
      // Increment quantity
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.item.quantity,
      );
    } else {
      // Add new item
      updatedItems.add(event.item);
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedItems = state.items.where((item) => item.cartItemId != event.cartItemId).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) {
    final updatedItems = List<CartItemModel>.from(state.items);
    final index = updatedItems.indexWhere((item) => item.cartItemId == event.cartItemId);
    
    if (index >= 0) {
      if (event.quantity <= 0) {
        updatedItems.removeAt(index);
      } else {
        updatedItems[index] = updatedItems[index].copyWith(quantity: event.quantity);
      }
      emit(state.copyWith(items: updatedItems));
    }
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
