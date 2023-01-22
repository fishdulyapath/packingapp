import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/repositories/client.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductState(
          status: ProductStateStatus.initial,
          page: Page.empty,
          products: <Product>[],
        ));

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is ProductLoad) {
      yield* _mapProductStartedToState(event);
    }
  }

  Stream<ProductState> _mapProductStartedToState(ProductLoad event) async* {
    bool isNotNewLoad = !event.newLoad;

    if (isNotNewLoad && state.page.currentPage >= state.page.maxPage) {
      yield state.copyWith();
    } else {
      try {
        List<Product> previousProduct = <Product>[];
        Page previousPage = Page.empty;
        int nextPage = 1;

        ProductState previousState = state.copyWith();

        if (isNotNewLoad && previousState.products.length > 0) {
          previousProduct = previousState.products;
          previousPage = previousState.page;
          nextPage =
              (previousPage.currentPage < 1 ? 1 : previousPage.currentPage) + 1;
        }

        if (event.isSearch) {
          yield state.copyWith(status: ProductStateStatus.searchProcess);
        } else {
          yield state.copyWith(status: ProductStateStatus.inProcess);
        }

        final dataResponse = await _productRepository.fetchAllProduct(
            event.storeType,
            page: nextPage,
            search: event.keyWord);

        List<Product> products = (dataResponse.data as List)
            .map((product) => Product.fromMap(product))
            .toList();

        Page page = dataResponse.page ?? Page.empty;
        products.insertAll(0, previousProduct);

        yield state.copyWith(
          status: ProductStateStatus.success,
          page: page,
          products: products,
        );
      } catch (e) {
        yield ProductState(status: ProductStateStatus.failure);
      }
    }
  }
}
