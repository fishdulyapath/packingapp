part of 'productdetail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailLoad extends ProductDetailEvent {
  final String keyWord;

  ProductDetailLoad({this.keyWord = ""});

  @override
  List<Object> get props => [keyWord];
}
