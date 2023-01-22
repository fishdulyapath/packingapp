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

part 'boxlist_event.dart';
part 'boxlist_state.dart';

class BoxlistBloc extends Bloc<BoxlistEvent, BoxlistState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  BoxlistBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(BoxlistInitial());

  @override
  Stream<BoxlistState> mapEventToState(
    BoxlistEvent event,
  ) async* {
    if (event is BoxlistLoaded) {
      yield* _mapBoxlistLoadedToState(event);
    }
  }

  Stream<BoxlistState> _mapBoxlistLoadedToState(BoxlistLoaded event) async* {
    yield BoxlistInProgress();

    final dataResponse =
        await _docListRepository.fetchBoxList(doc_no: event.docNo);
    try {
      List<StorePack> docdetails = (dataResponse.data as List)
          .map((docdetails) => StorePack.fromMap(docdetails))
          .toList();

      yield BoxlistLoadSuccess(
          status: BoxlistStateStatus.success, storePack: docdetails);
    } catch (e) {
      yield BoxlistLoadFailure(message: e.toString());
    }
  }
}
