import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/productdetail.dart';
import 'package:mobilepacking/repositories/client.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'productdetail_event.dart';
part 'productdetail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductDetailState(
          status: ProductDetailStateStatus.initial,
          products: <ProductDetail>[],
        ));

  @override
  Stream<ProductDetailState> mapEventToState(
    ProductDetailEvent event,
  ) async* {
    if (event is ProductDetailLoad) {
      yield* _mapProductDetailStartedToState(event);
    }
  }

  Stream<ProductDetailState> _mapProductDetailStartedToState(
      ProductDetailLoad event) async* {
    try {
      yield state.copyWith(status: ProductDetailStateStatus.inProcess);

      final dataResponse =
          await _productRepository.fetchProductByList(event.keyWord);

      List<ProductDetail> products = (dataResponse.data as List)
          .map((product) => ProductDetail.fromMap(product))
          .toList();

      yield state.copyWith(
        status: ProductDetailStateStatus.success,
        products: products,
      );
    } catch (e) {
      yield ProductDetailState(status: ProductDetailStateStatus.failure);
    }
  }
}
