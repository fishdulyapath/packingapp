part of 'store_form_bloc.dart';

abstract class StoreFormState extends Equatable {
  const StoreFormState();

  @override
  List<Object> get props => [];
}

class StoreFormInitial extends StoreFormState {}

class StoreFormSaveInProgress extends StoreFormState {}

class StoreFormSaveSuccess extends StoreFormState {}

class StoreFormSaveFailure extends StoreFormState {}

class StoreFormDeleteInProgress extends StoreFormState {}

class StoreFormDeleteSuccess extends StoreFormState {}

class StoreFormDeleteFailure extends StoreFormState {}

class StoreFormSendInProgress extends StoreFormState {}

class StoreFormSendSuccess extends StoreFormState {}

class StoreFormSendFailure extends StoreFormState {}
