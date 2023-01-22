import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/repositories/doclistcar_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'doclistcarpack_event.dart';
part 'doclistcarpack_state.dart';

class DoclistCarBloc extends Bloc<DoclistCarEvent, DoclistCarState> {
  final ProductRepository _productRepository;
  final DoclistCarRepository _doclistCarRepository;

  DoclistCarBloc({
    required ProductRepository productRepository,
    required DoclistCarRepository doclistCarRepository,
  })  : _productRepository = productRepository,
        _doclistCarRepository = doclistCarRepository,
        super(DoclistCarInitial());

  @override
  Stream<DoclistCarState> mapEventToState(
    DoclistCarEvent event,
  ) async* {
    if (event is DoclistCarLoaded) {
      yield* _mapDoclistCarLoadedToState(event);
    }
  }

  Stream<DoclistCarState> _mapDoclistCarLoadedToState(
      DoclistCarLoaded event) async* {
    yield DoclistCarInProgress();

    yield state.copyWith(status: DoclistCarStateStatus.inProcess);

    final dataResponse = await _doclistCarRepository.fetchAllDoclistCar(
        branch_code: event.branchCode,
        search: event.keyWord,
        from_date: event.fromDate,
        to_date: event.toDate);

    try {
      List<DoclistCar> doclistCars = (dataResponse.data as List)
          .map((doclistCars) => DoclistCar.fromMap(doclistCars))
          .toList();

      yield state.copyWith(
        status: DoclistCarStateStatus.success,
        doclistCar: doclistCars,
      );
    } catch (e) {
      yield DoclistCarState(status: DoclistCarStateStatus.failure);
    }
  }
}
