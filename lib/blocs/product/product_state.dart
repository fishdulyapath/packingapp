part of 'product_bloc.dart';

enum ProductStateStatus { initial, inProcess, searchProcess, success, failure }

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStateStatus.initial,
    this.products = const <Product>[],
    this.page = Page.empty,
  });

  final ProductStateStatus status;
  final Page page;
  final List<Product> products;

  ProductState copyWith({
    ProductStateStatus? status,
    Page? page,
    List<Product>? products,
  }) {
    return ProductState(
      status: status ?? this.status,
      page: page ?? this.page,
      products: products ?? this.products,
    );
  }

  @override
  List<Object> get props => [status, products, page];
}
