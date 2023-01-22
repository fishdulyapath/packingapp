import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docList.dart';

import 'package:mobilepacking/data/struct/docListSend.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/repositories/doclistsend_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'doclistsend_event.dart';
part 'doclistsend_state.dart';

class DoclistSendBloc extends Bloc<DoclistSendEvent, DoclistSendState> {
  final ProductRepository _productRepository;
  final DoclistSendRepository _doclistSendRepository;

  DoclistSendBloc({
    required ProductRepository productRepository,
    required DoclistSendRepository doclistSendRepository,
  })  : _productRepository = productRepository,
        _doclistSendRepository = doclistSendRepository,
        super(DoclistSendInitial());

  @override
  Stream<DoclistSendState> mapEventToState(
    DoclistSendEvent event,
  ) async* {
    if (event is DoclistSendLoaded) {
      yield* _mapDoclistSendLoadedToState(event);
    }
  }

  Stream<DoclistSendState> _mapDoclistSendLoadedToState(
      DoclistSendLoaded event) async* {
    yield DoclistSendInProgress();

    yield state.copyWith(status: DoclistSendStateStatus.inProcess);

    final dataResponse = await _doclistSendRepository.fetchAllDoclistSend(
        branch_code: event.branchCode,
        search: event.keyWord,
        from_date: event.fromDate,
        to_date: event.toDate);

    try {
      List<DoclistSend> DoclistSends = (dataResponse.data as List)
          .map((DoclistSends) => DoclistSend.fromMap(DoclistSends))
          .toList();

      yield state.copyWith(
        status: DoclistSendStateStatus.success,
        DoclistSend: DoclistSends,
      );
    } catch (e) {
      yield DoclistSendState(status: DoclistSendStateStatus.failure);
    }
  }
}
