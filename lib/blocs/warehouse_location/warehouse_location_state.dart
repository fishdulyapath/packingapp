part of 'warehouse_location_bloc.dart';

abstract class WarehouseLocationState extends Equatable {
  const WarehouseLocationState();

  @override
  List<Object> get props => [];
}

class WarehouseLocationInitial extends WarehouseLocationState {}

class WarehouseLocationSeuucess extends WarehouseLocationState {
  final List<WarehouseLocation> warehouseLocations;

  const WarehouseLocationSeuucess([this.warehouseLocations = const []]);

  @override
  List<Object> get props => [warehouseLocations];
}

class WarehouseLocationFailure extends WarehouseLocationState {}
