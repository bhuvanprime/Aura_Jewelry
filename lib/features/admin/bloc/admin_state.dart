import 'package:equatable/equatable.dart';
import '../../products/domain/models/product_model.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<ProductModel> products;
  const AdminLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class AdminOperationSuccess extends AdminState {
  final String message;
  const AdminOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
