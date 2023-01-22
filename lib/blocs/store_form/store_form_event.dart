part of 'store_form_bloc.dart';

abstract class StoreFormEvent extends Equatable {
  const StoreFormEvent();

  @override
  List<Object> get props => [];
}

class StoreFormPackingSOSaved extends StoreFormEvent {
  final String docNo;

  StoreFormPackingSOSaved({
    required this.docNo,
  });

  @override
  List<Object> get props => [docNo];
}

class StoreFormPackingBoxSaved extends StoreFormEvent {
  final StorePack storePack;

  StoreFormPackingBoxSaved({required this.storePack});

  @override
  List<Object> get props => [storePack];
}

class StoreFormPackingBoxDeleted extends StoreFormEvent {
  final String docNo;

  StoreFormPackingBoxDeleted({required this.docNo});

  @override
  List<Object> get props => [docNo];
}

class StoreFormPackingBoxSend extends StoreFormEvent {
  final String docNo;
  final String dropPoint;
  final String custCode;

  StoreFormPackingBoxSend(
      {required this.docNo, required this.dropPoint, required this.custCode});

  @override
  List<Object> get props => [docNo, dropPoint, custCode];
}

class StoreFormWithdrawSaved extends StoreFormEvent {
  final Store store;

  StoreFormWithdrawSaved({
    required this.store,
  });

  @override
  List<Object> get props => [store];
}
