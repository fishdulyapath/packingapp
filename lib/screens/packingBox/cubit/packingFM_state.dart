part of 'packingFM_cubit.dart';

abstract class PackingFMState extends Equatable {
  const PackingFMState();

  @override
  List<Object> get props => [];
}

class PackingFMInitial extends PackingFMState {}

class PackingFMLoadProducInProgress extends PackingFMState {}

class PackingFMLoadProducSuccess extends PackingFMState {
  final Store store;
  final List<Product> products;

  PackingFMLoadProducSuccess({
    required this.store,
    required this.products,
  });

  @override
  List<Object> get props => [store];
}

class PackingFMLoadProducFailure extends PackingFMState {
  final String message;

  PackingFMLoadProducFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
