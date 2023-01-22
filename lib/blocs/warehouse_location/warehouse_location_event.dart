part of 'warehouse_location_bloc.dart';

abstract class WarehouseLocationEvent extends Equatable {
  const WarehouseLocationEvent();

  @override
  List<Object> get props => [];
}

class WarehouseLocationLoad extends WarehouseLocationEvent {}
