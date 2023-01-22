import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:mobilepacking/data/struct/docSend.dart';
import 'package:mobilepacking/repositories/doclistsend_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'docsend_event.dart';
part 'docsend_state.dart';

class DocsendBloc extends Bloc<DocsendEvent, DocsendState> {
  final ProductRepository _productRepository;
  final DoclistSendRepository _docListRepository;

  DocsendBloc({
    required ProductRepository productRepository,
    required DoclistSendRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(DocsendInitial());

  @override
  Stream<DocsendState> mapEventToState(
    DocsendEvent event,
  ) async* {
    if (event is DocsendLoad) {
      yield* _mapDocsendLoadToState(event);
    }
  }

  Stream<DocsendState> _mapDocsendLoadToState(event) async* {
    try {
      yield DocsendInitial();
      print(event.docbo);
      print(event.imagebase64);
      event.docbo.forEach((element) async {
        await _docListRepository.sendBox(
            event.docno, element, event.imagebase64);
      });

      yield DocsendLoadSuccess();
    } catch (e) {
      print('error ${e.toString()}');
      yield DocsendLoadFailure(message: e.toString());
    }
  }
}
