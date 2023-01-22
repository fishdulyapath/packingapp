part of 'store_form_cart_bloc.dart';

abstract class StoreFormCartEvent extends Equatable {
  const StoreFormCartEvent();

  @override
  List<Object> get props => [];
}

class StoreFormCartPackingSOSaved extends StoreFormCartEvent {
  final String docNo;

  StoreFormCartPackingSOSaved({
    required this.docNo,
  });

  @override
  List<Object> get props => [docNo];
}

class StoreFormCartPackingBoxSaved extends StoreFormCartEvent {
  final StorePack storePack;

  StoreFormCartPackingBoxSaved({required this.storePack});

  @override
  List<Object> get props => [storePack];
}

class StoreFormCartPackingBoxUpdate extends StoreFormCartEvent {
  final StorePack storePack;

  StoreFormCartPackingBoxUpdate({required this.storePack});

  @override
  List<Object> get props => [storePack];
}

class StoreFormCartPackingBoxDeleted extends StoreFormCartEvent {
  final String docNo;

  StoreFormCartPackingBoxDeleted({required this.docNo});

  @override
  List<Object> get props => [docNo];
}

class StoreFormCartPackingBoxSend extends StoreFormCartEvent {
  final String docNo;
  final String dropPoint;
  final String custCode;

  StoreFormCartPackingBoxSend(
      {required this.docNo, required this.dropPoint, required this.custCode});

  @override
  List<Object> get props => [docNo, dropPoint, custCode];
}

class StoreFormCartWithdrawSaved extends StoreFormCartEvent {
  final Store store;

  StoreFormCartWithdrawSaved({
    required this.store,
  });

  @override
  List<Object> get props => [store];
}
