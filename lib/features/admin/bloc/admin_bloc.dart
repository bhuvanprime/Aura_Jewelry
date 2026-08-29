import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminInitial()) {
    on<AdminLoadProducts>(_onLoadProducts);
    on<AdminAddProduct>(_onAddProduct);
    on<AdminUpdateProduct>(_onUpdateProduct);
    on<AdminDeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(AdminLoadProducts event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final products = await _adminRepository.fetchProducts();
      emit(AdminLoaded(products));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AdminAddProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.addProduct(event.product);
      emit(const AdminOperationSuccess('Product added successfully'));
      add(AdminLoadProducts());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadProducts()); // Reload to restore previous state
    }
  }

  Future<void> _onUpdateProduct(AdminUpdateProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.updateProduct(event.product);
      emit(const AdminOperationSuccess('Product updated successfully'));
      add(AdminLoadProducts());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadProducts());
    }
  }

  Future<void> _onDeleteProduct(AdminDeleteProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.deleteProduct(event.productId);
      emit(const AdminOperationSuccess('Product deleted successfully'));
      add(AdminLoadProducts());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadProducts());
    }
  }
}
