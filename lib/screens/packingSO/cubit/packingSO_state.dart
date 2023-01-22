part of 'packingSO_cubit.dart';

abstract class PackingSOState extends Equatable {
  const PackingSOState();

  @override
  List<Object> get props => [];
}

class PackingSOInitial extends PackingSOState {}

class PackingSOLoadProducInProgress extends PackingSOState {}

class PackingSOLoadProducSuccess extends PackingSOState {
  final Store store;
  final List<Product> products;

  PackingSOLoadProducSuccess({
    required this.store,
    required this.products,
  });

  @override
  List<Object> get props => [store];
}

class PackingSOLoadProducFailure extends PackingSOState {
  final String message;

  PackingSOLoadProducFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
