import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<ProductSubscriptionRequested>(_onSubscriptionRequested);
    on<ProductProductsUpdated>(_onProductsUpdated);
    on<ProductToggleWishlist>(_onToggleWishlist);
  }

  void _onSubscriptionRequested(ProductSubscriptionRequested event, Emitter<ProductState> emit) {
    emit(ProductLoading());
    _productSubscription?.cancel();
    _productSubscription = _productRepository.watchProducts().listen(
      (products) {
        add(ProductProductsUpdated(products));
      },
      onError: (error) {
        // Fallback for development if Firebase is not fully configured
        debugPrint("Product stream error: $error");
        add(const ProductProductsUpdated([]));
      },
    );
  }

  void _onProductsUpdated(ProductProductsUpdated event, Emitter<ProductState> emit) {
    emit(ProductLoaded(event.products));
  }

  Future<void> _onToggleWishlist(ProductToggleWishlist event, Emitter<ProductState> emit) async {
    // Optimistic UI Update
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final updatedProducts = currentState.products.map((p) {
        if (p.id == event.productId) {
          return p.copyWith(isWishlisted: event.isWishlisted);
        }
        return p;
      }).toList();
      emit(ProductLoaded(updatedProducts));
    }

    try {
      await _productRepository.toggleWishlist(event.productId, event.isWishlisted);
    } catch (e) {
      debugPrint("Failed to toggle wishlist: $e");
      // Optional: Revert optimistic update here if needed
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
