import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:mobilepacking/data/struct/boxSend.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'boxsend_event.dart';
part 'boxsend_state.dart';

class BoxsendBloc extends Bloc<BoxsendEvent, BoxsendState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  BoxsendBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(BoxsendInitial());

  @override
  Stream<BoxsendState> mapEventToState(
    BoxsendEvent event,
  ) async* {
    if (event is BoxsendLoad) {
      yield* _mapBoxsendLoadToState(event);
    }
  }

  Stream<BoxsendState> _mapBoxsendLoadToState(event) async* {
    try {
      yield BoxsendInitial();
      final dataResponse =
          await _productRepository.getBoxSend(event.docno, event.status);

      yield BoxsendLoadSuccess();
    } catch (e) {
      print('error ${e.toString()}');
      yield BoxsendLoadFailure(message: e.toString());
    }
  }
}
