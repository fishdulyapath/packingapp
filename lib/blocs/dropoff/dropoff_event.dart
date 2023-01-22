part of 'dropoff_bloc.dart';

abstract class DropoffEvent extends Equatable {
  const DropoffEvent();

  @override
  List<Object> get props => [];
}

class DropoffLoad extends DropoffEvent {
  DropoffLoad();

  @override
  List<Object> get props => [];
}
