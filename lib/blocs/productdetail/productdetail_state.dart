part of 'productdetail_bloc.dart';

enum ProductDetailStateStatus {
  initial,
  inProcess,
  searchProcess,
  success,
  failure
}

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStateStatus.initial,
    this.products = const <ProductDetail>[],
  });

  final ProductDetailStateStatus status;

  final List<ProductDetail> products;

  ProductDetailState copyWith({
    ProductDetailStateStatus? status,
    List<ProductDetail>? products,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object> get props => [status, products];
}
