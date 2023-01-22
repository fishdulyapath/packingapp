import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';

import 'package:mobilepacking/data/struct/docDetailSend.dart';
import 'package:mobilepacking/repositories/doclistcar_repository.dart';
import 'package:mobilepacking/repositories/doclistsend_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'docsenddetail_event.dart';
part 'docsenddetail_state.dart';

class DocdetailsendBloc extends Bloc<DocSenddetailEvent, DocSenddetailState> {
  final ProductRepository _productRepository;
  final DoclistSendRepository _docListRepository;

  DocdetailsendBloc({
    required ProductRepository productRepository,
    required DoclistSendRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(DocSenddetailInitial());

  @override
  Stream<DocSenddetailState> mapEventToState(
    DocSenddetailEvent event,
  ) async* {
    if (event is DocSenddetailLoaded) {
      yield* _mapDocSenddetailLoadedToState(event);
    }
  }

  Stream<DocSenddetailState> _mapDocSenddetailLoadedToState(
      DocSenddetailLoaded event) async* {
    yield DocSenddetailInProgress();

    final dataResponse =
        await _docListRepository.fetchAllDocSenddetail(doc_no: event.docNo);
    try {
      List<DocDetailSend> docSenddetails = (dataResponse.data as List)
          .map((docSenddetails) => DocDetailSend.fromMap(docSenddetails))
          .toList();

      yield DocSendDetailLoadSuccess(
          status: DocSenddetailStateStatus.success,
          docDetailSend: docSenddetails);
    } catch (e) {
      yield DocSenddetailLoadFailure(message: e.toString());
    }
  }
}
