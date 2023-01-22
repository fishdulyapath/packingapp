import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docDetailCar.dart';
import 'package:mobilepacking/repositories/doclistcar_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'doccardetail_event.dart';
part 'doccardetail_state.dart';

class DocdetailcarBloc extends Bloc<DoccardetailEvent, DoccardetailState> {
  final ProductRepository _productRepository;
  final DoclistCarRepository _docListRepository;

  DocdetailcarBloc({
    required ProductRepository productRepository,
    required DoclistCarRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(DoccardetailInitial());

  @override
  Stream<DoccardetailState> mapEventToState(
    DoccardetailEvent event,
  ) async* {
    if (event is DoccardetailLoaded) {
      yield* _mapDoccardetailLoadedToState(event);
    }
  }

  Stream<DoccardetailState> _mapDoccardetailLoadedToState(
      DoccardetailLoaded event) async* {
    yield DoccardetailInProgress();

    final dataResponse =
        await _docListRepository.fetchAllDoccardetail(doc_no: event.docNo);
    try {
      List<DocDetailCar> doccardetails = (dataResponse.data as List)
          .map((doccardetails) => DocDetailCar.fromMap(doccardetails))
          .toList();

      yield DoccarDetailLoadSuccess(
          status: DoccardetailStateStatus.success, doccarDetail: doccardetails);
    } catch (e) {
      yield DoccardetailLoadFailure(message: e.toString());
    }
  }
}
