import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/repositories/store_repository.dart';

part 'store_form_event.dart';
part 'store_form_state.dart';

class StoreFormBloc extends Bloc<StoreFormEvent, StoreFormState> {
  final StoreRepository _storeRepository;

  StoreFormBloc({required StoreRepository storeRepository})
      : _storeRepository = storeRepository,
        super(StoreFormInitial());

  @override
  Stream<StoreFormState> mapEventToState(
    StoreFormEvent event,
  ) async* {
    if (event is StoreFormPackingSOSaved) {
      yield* _mapStoreFormPackingSOSavedToState(event);
    } else if (event is StoreFormWithdrawSaved) {
      yield* _mapStoreFormWithdrawSavedToState(event);
    } else if (event is StoreFormPackingBoxSaved) {
      yield* _mapStoreFormPackingBoxSavedToState(event);
    } else if (event is StoreFormPackingBoxDeleted) {
      yield* _mapStoreFormPackingBoxDeletedToState(event);
    } else if (event is StoreFormPackingBoxSend) {
      yield* _mapStoreFormPackingBoxSendToState(event);
    }
  }

  Stream<StoreFormState> _mapStoreFormWithdrawSavedToState(
      StoreFormWithdrawSaved event) async* {
    yield StoreFormSaveInProgress();

    List<Product> products = event.store.details;

    try {
      await _storeRepository.saveWithdraw(event.store);
      yield StoreFormSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormSaveFailure();
    }
  }

  Stream<StoreFormState> _mapStoreFormPackingSOSavedToState(
      StoreFormPackingSOSaved event) async* {
    yield StoreFormSaveInProgress();

    try {
      await _storeRepository.savePackingSO(event.docNo);
      yield StoreFormSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormSaveFailure();
    }
  }

  Stream<StoreFormState> _mapStoreFormPackingBoxSavedToState(
      StoreFormPackingBoxSaved event) async* {
    yield StoreFormSaveInProgress();

    try {
      await _storeRepository.savePackingBox(event.storePack);
      yield StoreFormSaveSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormSaveFailure();
    }
  }

  Stream<StoreFormState> _mapStoreFormPackingBoxDeletedToState(
      StoreFormPackingBoxDeleted event) async* {
    yield StoreFormDeleteInProgress();

    try {
      await _storeRepository.deletePackingBox(event.docNo);
      yield StoreFormDeleteSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormDeleteFailure();
    }
  }

  Stream<StoreFormState> _mapStoreFormPackingBoxSendToState(
      StoreFormPackingBoxSend event) async* {
    yield StoreFormSendInProgress();

    try {
      await _storeRepository.sendPackingBox(
          event.docNo, event.custCode, event.dropPoint);
      yield StoreFormSendSuccess();
    } catch (e) {
      print(e.toString());
      yield StoreFormSendFailure();
    }
  }
}
