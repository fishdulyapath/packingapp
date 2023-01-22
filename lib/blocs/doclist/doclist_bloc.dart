import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'doclist_event.dart';
part 'doclist_state.dart';

class DoclistBloc extends Bloc<DoclistEvent, DoclistState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  DoclistBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(DoclistInitial());

  @override
  Stream<DoclistState> mapEventToState(
    DoclistEvent event,
  ) async* {
    if (event is DoclistLoaded) {
      yield* _mapDoclistLoadedToState(event);
    }
  }

  Stream<DoclistState> _mapDoclistLoadedToState(DoclistLoaded event) async* {
    yield DoclistInProgress();

    yield state.copyWith(status: DoclistStateStatus.inProcess);

    final dataResponse = await _docListRepository.fetchAllDoclist(
        branch_code: event.branchCode,
        search: event.keyWord,
        from_date: event.fromDate,
        to_date: event.toDate,
        status: event.status);

    try {
      List<DocList> docLists = (dataResponse.data as List)
          .map((docLists) => DocList.fromMap(docLists))
          .toList();

      yield state.copyWith(
        status: DoclistStateStatus.success,
        doclist: docLists,
      );
    } catch (e) {
      yield DoclistState(status: DoclistStateStatus.failure);
    }
  }
}
