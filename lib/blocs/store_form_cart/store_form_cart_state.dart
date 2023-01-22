part of 'store_form_cart_bloc.dart';

abstract class StoreFormCartState extends Equatable {
  const StoreFormCartState();

  @override
  List<Object> get props => [];
}

class StoreFormCartInitial extends StoreFormCartState {}

class StoreFormCartSaveInProgress extends StoreFormCartState {}

class StoreFormCartSaveSuccess extends StoreFormCartState {}

class StoreFormCartSaveFailure extends StoreFormCartState {}

class StoreFormCartDeleteInProgress extends StoreFormCartState {}

class StoreFormCartDeleteSuccess extends StoreFormCartState {}

class StoreFormCartDeleteFailure extends StoreFormCartState {}

class StoreFormCartSendInProgress extends StoreFormCartState {}

class StoreFormCartSendSuccess extends StoreFormCartState {}

class StoreFormCartSendFailure extends StoreFormCartState {}
