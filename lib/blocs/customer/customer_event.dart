part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class CustomerLoad extends CustomerEvent {
  CustomerLoad();

  @override
  List<Object> get props => [];
}
