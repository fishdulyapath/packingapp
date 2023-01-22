import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'boxcartlist_event.dart';
part 'boxcartlist_state.dart';

class BoxcartlistBloc extends Bloc<BoxcartlistEvent, BoxcartlistState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  BoxcartlistBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(BoxcartlistInitial());

  @override
  Stream<BoxcartlistState> mapEventToState(
    BoxcartlistEvent event,
  ) async* {
    if (event is BoxcartlistLoaded) {
      yield* _mapBoxcartlistLoadedToState(event);
    }
  }

  Stream<BoxcartlistState> _mapBoxcartlistLoadedToState(
      BoxcartlistLoaded event) async* {
    yield BoxcartlistInProgress();

    final dataResponse =
        await _docListRepository.fetchBoxcartlist(doc_no: event.docNo);
    try {
      List<StorePack> docdetails = (dataResponse.data as List)
          .map((docdetails) => StorePack.fromMap(docdetails))
          .toList();

      yield BoxcartlistLoadSuccess(
          status: BoxcartlistStateStatus.success, storePack: docdetails);
    } catch (e) {
      yield BoxcartlistLoadFailure(message: e.toString());
    }
  }
}
