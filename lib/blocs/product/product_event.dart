part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductLoad extends ProductEvent {
  final bool newLoad;
  final String keyWord;
  final bool isSearch;
  final StoreType storeType;

  ProductLoad(
      {this.newLoad = false,
      this.keyWord = "",
      this.isSearch = false,
      required this.storeType});

  @override
  List<Object> get props => [newLoad, keyWord, isSearch];
}
