import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/repositories/store_repository.dart';

part 'store_form_cart_event.dart';
part 'store_form_cart_state.dart';

class StoreFormCartBloc extends Bloc<StoreFormCartEvent, StoreFormCartState> {
  final StoreRepository _storeRepository;

  StoreFormCartBloc({required StoreRepository storeRepository})
      : _storeRepository = storeRepository,
        super(StoreFormCartInitial());

  @override
  Stream<StoreFormCartState> mapEventToState(
    StoreFormCartEvent event,
  ) async* {
    if (event is StoreFormCartPackingSOSaved) {
      yield* _mapStoreFormCartPackingSOSavedToState(event);
    } else if (event is StoreFormCartWithdrawSaved) {
      yield* _mapStoreFormCartWithdrawSavedToState(event);
    } else if (event is StoreFormCartPackingBoxSaved) {
      yield* _mapStoreFormCartPackingBoxSavedToState(event);
    } else if (event is StoreFormCartPackingBoxUpdate) {
      yield* _mapStoreFormCartPackingBoxUpdateToState(event);
    } else if (event is StoreFormCartPackingBoxDeleted) {
      yield* _mapStoreFormCartPackingBoxDeletedToState(event);
    } else if (event is StoreFormCartPackingBoxSend) {
      yield* _mapStoreFormCartPackingBoxSendToState(event);
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartWithdrawSavedToState(
      StoreFormCartWithdrawSaved event) async* {
    yield StoreFormCartSaveInProgress();

    List<Product> products = event.store.details;

    try {
      await _storeRepository.saveWithdraw(event.store);
      yield StoreFormCartSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartSaveFailure();
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartPackingSOSavedToState(
      StoreFormCartPackingSOSaved event) async* {
    yield StoreFormCartSaveInProgress();

    try {
      await _storeRepository.savePackingSO(event.docNo);
      yield StoreFormCartSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartSaveFailure();
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartPackingBoxSavedToState(
      StoreFormCartPackingBoxSaved event) async* {
    yield StoreFormCartSaveInProgress();

    try {
      await _storeRepository.savePackingBoxCart(event.storePack);
      yield StoreFormCartSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartSaveFailure();
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartPackingBoxUpdateToState(
      StoreFormCartPackingBoxUpdate event) async* {
    yield StoreFormCartSaveInProgress();

    try {
      await _storeRepository.updatePackingBoxCart(event.storePack);
      yield StoreFormCartSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartSaveFailure();
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartPackingBoxDeletedToState(
      StoreFormCartPackingBoxDeleted event) async* {
    yield StoreFormCartDeleteInProgress();

    try {
      await _storeRepository.deletePackingBoxCart(event.docNo);
      yield StoreFormCartDeleteSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartDeleteFailure();
    }
  }

  Stream<StoreFormCartState> _mapStoreFormCartPackingBoxSendToState(
      StoreFormCartPackingBoxSend event) async* {
    yield StoreFormCartSendInProgress();

    try {
      await _storeRepository.sendPackingBox(
          event.docNo, event.custCode, event.dropPoint);
      yield StoreFormCartSendSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormCartSendFailure();
    }
  }
}
