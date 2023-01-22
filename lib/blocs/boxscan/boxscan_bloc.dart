import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/boxScan.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'boxscan_event.dart';
part 'boxscan_state.dart';

class BoxscanBloc extends Bloc<BoxscanEvent, BoxscanState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  BoxscanBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(BoxscanInitial());

  @override
  Stream<BoxscanState> mapEventToState(
    BoxscanEvent event,
  ) async* {
    if (event is BoxscanLoad) {
      yield* _mapBoxscanLoadToState(event);
    }
  }

  Stream<BoxscanState> _mapBoxscanLoadToState(event) async* {
    try {
      yield BoxscanInitial();
      final dataResponse =
          await _productRepository.getBoxScan(event.docno, event.docjo);

      List<BoxScan> boxscan = (dataResponse.data as List)
          .map((boxscan) => BoxScan.fromMap(boxscan))
          .toList();

      yield BoxscanLoadSuccess(boxscan);
    } catch (e) {
      print('error ${e.toString()}');
      yield BoxscanLoadFailure(message: e.toString());
    }
  }
}
