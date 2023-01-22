import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/dropoff.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'dropoff_event.dart';
part 'dropoff_state.dart';

class DropoffBloc extends Bloc<DropoffEvent, DropoffState> {
  final ProductRepository _productRepository;

  DropoffBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(DropoffState(
          status: DropoffStateStatus.initial,
          dropoff: <Dropoff>[],
        ));

  @override
  Stream<DropoffState> mapEventToState(
    DropoffEvent event,
  ) async* {
    if (event is DropoffLoad) {
      yield* _mapDropoffStartedToState(event);
    }
  }

  Stream<DropoffState> _mapDropoffStartedToState(DropoffLoad event) async* {
    try {
      List<Dropoff> previousDropoff = <Dropoff>[];

      DropoffState previousState = state.copyWith();

      yield state.copyWith(status: DropoffStateStatus.inProcess);

      final dataResponse = await _productRepository.fetchAllDropoff();

      List<Dropoff> dropoff = (dataResponse.data as List)
          .map((dropoff) => Dropoff.fromMap(dropoff))
          .toList();

      yield state.copyWith(
        status: DropoffStateStatus.success,
        dropoff: dropoff,
      );
    } catch (e) {
      yield DropoffState(status: DropoffStateStatus.failure);
    }
  }
}
