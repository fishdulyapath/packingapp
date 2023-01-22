import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/repositories/warehouse_location_repository.dart';

part 'warehouse_location_event.dart';
part 'warehouse_location_state.dart';

class WarehouseLocationBloc
    extends Bloc<WarehouseLocationEvent, WarehouseLocationState> {
  final WarehouseLocationRepository _warehouseLocationRepository;

  WarehouseLocationBloc(
      {required WarehouseLocationRepository warehouseLocationRepository})
      : _warehouseLocationRepository = warehouseLocationRepository,
        super(WarehouseLocationInitial());

  @override
  Stream<WarehouseLocationState> mapEventToState(
    WarehouseLocationEvent event,
  ) async* {
    if (event is WarehouseLocationLoad) {
      yield* _mapWarehouseLocationStartedToState();
    }
  }

  Stream<WarehouseLocationState> _mapWarehouseLocationStartedToState() async* {
    try {
      final dataResponse =
          await _warehouseLocationRepository.fetchAllWarehouseLocation();
      List<WarehouseLocation> warehouseLocations = (dataResponse.data as List)
          .map((warehouseLocations) =>
              WarehouseLocation.fromMap(warehouseLocations))
          .toList();
      yield WarehouseLocationSeuucess(warehouseLocations);
    } catch (e) {
      print('error ::  ${e.toString()}');
      yield WarehouseLocationFailure();
    }
  }
}
