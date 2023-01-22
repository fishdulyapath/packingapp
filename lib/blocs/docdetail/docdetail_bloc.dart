import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'docdetail_event.dart';
part 'docdetail_state.dart';

class DocdetailBloc extends Bloc<DocdetailEvent, DocdetailState> {
  final ProductRepository _productRepository;
  final DocListRepository _docListRepository;

  DocdetailBloc({
    required ProductRepository productRepository,
    required DocListRepository docListRepository,
  })  : _productRepository = productRepository,
        _docListRepository = docListRepository,
        super(DocdetailInitial());

  @override
  Stream<DocdetailState> mapEventToState(
    DocdetailEvent event,
  ) async* {
    if (event is DocdetailLoaded) {
      yield* _mapDocdetailLoadedToState(event);
    } else if (event is DocdetailReLoaded) {
      yield* _mapDocdetailFormReLoadToState(event);
    } else if (event is DocdetailFormLoad) {
      yield* _mapDocdetailFormLoadToState(event);
    } else if (event is ProductScaned) {
      yield* _mapProductScanedToState(event);
    } else if (event is ProductQtyChanged) {
      yield* _mapProductQtyChangedToState(event);
    } else if (event is ProductQtyIncreased) {
      yield* _mapProductQtyIncreasedToState(event);
    } else if (event is ProductQtyDecreased) {
      yield* _mapProductQtyDecreasedToState(event);
    } else if (event is ProductRemoved) {
      yield* _mapProductRemovedToState(event);
    } else if (event is ProductQtyClear) {
      yield* _mapProductQtyClearToState(event);
    } else if (event is ProductQtyIncreasedMerge) {
      yield* _mapProductQtyIncreasedMergeToState(event);
    }
  }

  Stream<DocdetailState> _mapDocdetailLoadedToState(
      DocdetailLoaded event) async* {
    yield DocdetailInProgress();

    final dataResponse =
        await _docListRepository.fetchAllDocpackdetail(doc_no: event.docNo);
    try {
      List<DocDetail> docdetails = (dataResponse.data as List)
          .map((docdetails) => DocDetail.fromMap(docdetails))
          .toList();

      yield DocDetailLoadSuccess(
          status: DocdetailStateStatus.success, docDetail: docdetails);
    } catch (e) {
      yield DocdetailLoadFailure(message: e.toString());
    }
  }

  Stream<DocdetailState> _mapDocdetailFormReLoadToState(
      DocdetailReLoaded event) async* {
    yield DocdetailReLoadInProgress();

    final dataResponse =
        await _docListRepository.fetchAllDocpackdetail(doc_no: event.docNo);
    try {
      List<DocDetail> docdetails = (dataResponse.data as List)
          .map((docdetails) => DocDetail.fromMap(docdetails))
          .toList();

      yield DocDetailReLoadSuccess(
          status: DocdetailStateStatus.success, docDetail: docdetails);
    } catch (e) {
      yield DocdetailReLoadFailure(message: e.toString());
    }
  }

  Stream<DocdetailState> _mapDocdetailFormLoadToState(
      DocdetailFormLoad event) async* {
    yield DocdetailInProgress();

    final dataResponse =
        await _docListRepository.fetchAllDocpackdetail(doc_no: event.docNo);
    try {
      List<DocDetail> docdetails = (dataResponse.data as List)
          .map((docdetails) => DocDetail.fromMap(docdetails))
          .toList();

      yield DocDetailLoadSuccess(
          status: DocdetailStateStatus.success, docDetail: docdetails);
    } catch (e) {
      yield DocdetailLoadFailure(message: e.toString());
    }
  }

  Stream<DocdetailState> _mapProductScanedToState(ProductScaned event) async* {
    DocDetailLoadSuccess docDetailLoadSuccess;

    print(state);
    if (state is DocDetailLoadSuccess) {
      List<String> txtSplit = event.textScan.split("*");
      double _qty = 1;
      String _textScan = "";
      if (txtSplit.length > 1) {
        _qty = double.parse(txtSplit[0]);
        _textScan = txtSplit[1];
      } else {
        _textScan = txtSplit[0];
      }

      docDetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      yield DocdetailInProgress();
      final resp = await _productRepository.fetchProductByScan(_textScan);

      if (resp.success) {
        if (resp.data.length > 0) {
          final productInfo = resp.data[0];
          String _whCode = "";
          String _shelfCode = "";
          bool isPremiumProduct =
              (int.parse(productInfo?['item_type']) == 1) ? true : false;

          final product = DocDetail(
              itemCode: productInfo?['item_code'],
              itemName: productInfo?['item_name'],
              unitCode: productInfo?['unit_code'],
              qty_scan: _qty,
              isPremium: isPremiumProduct,
              price: double.parse(productInfo?['price']));

          DocDetail productSelected = docDetailLoadSuccess.docDetail.firstWhere(
              (element) =>
                  element.itemCode == product.itemCode &&
                  element.unitCode == product.unitCode,
              orElse: () => DocDetail.empty());
          ;
          if (isPremiumProduct) {
            product.qty_wait = _qty;
          }

          final bool isInProductPackingSO = productInPackingSOProductRef(
              product, docDetailLoadSuccess.docDetail, isPremiumProduct);

          final bool isNotInProductPackingSO = !isInProductPackingSO;

          if (isNotInProductPackingSO) {
            yield DocdetailScanProductFailure(
                message: 'สินค้านี้ ไม่ได้อยู่ในรายการสินค้า');
            // yield DocdetailScanProductFailure(message: '');
          }

          if (isInProductPackingSO) {
            if (productSelected.itemCode == '') {
              docDetailLoadSuccess.docDetail.add(product);
            } else {
              productSelected.qty_scan = productSelected.qty_scan + _qty;
              if ((productSelected.qty_scan > productSelected.qty_wait) &&
                  productSelected.isPremium == false) {
                productSelected.qty_scan = productSelected.qty_scan - _qty;
                yield DocdetailScanProductFailure(
                    message:
                        'ทำรายการไม่สำเร็จ จำนวนรับเข้ามากกว่าจำนวนค้างจัด');
              }
            }
          }
        }
        yield docDetailLoadSuccess.copyWith();
      } else {
        yield DocdetailScanProductFailure(message: 'ไม่พบสินค้านี้');
      }
    } else {
      yield DocdetailScanProductFailure(message: 'ดึงข้อมูลไม่สำเร็จ');
    }
  }

  bool productInPackingSOProductRef(
      DocDetail product, List<DocDetail> refProducts, bool isPremiumProduct) {
    if (isPremiumProduct) {
      return true;
    }

    DocDetail refProductSelected = refProducts.firstWhere(
        (element) =>
            element.itemCode == product.itemCode &&
            element.unitCode == product.unitCode,
        orElse: () => DocDetail.empty());
    if (refProductSelected.itemCode == '') {
      return false;
    } else {
      return true;
    }
  }

  Stream<DocdetailState> _mapProductRemovedToState(
      ProductRemoved event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      DocDetail productSelected = docdetailLoadSuccess.docDetail.firstWhere(
          (element) =>
              element.itemCode == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '' && productSelected.qty == 0) {
        docdetailLoadSuccess.docDetail.remove(productSelected);
      } else {
        productSelected.qty_scan = 0;
      }

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }

  Stream<DocdetailState> _mapProductQtyClearToState(
      ProductQtyClear event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      docdetailLoadSuccess.docDetail.forEach((data) {
        data.qty_scan = 0;
      });

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }

  Stream<DocdetailState> _mapProductQtyChangedToState(
      ProductQtyChanged event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      DocDetail productSelected = docdetailLoadSuccess.docDetail.firstWhere(
          (element) =>
              element.itemCode == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '') {
        productSelected.qty_scan = event.qty;
      }

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }

  Stream<DocdetailState> _mapProductQtyIncreasedMergeToState(
      ProductQtyIncreasedMerge event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      DocDetail productSelected = docdetailLoadSuccess.docDetail.firstWhere(
          (element) =>
              element.itemCode == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '') {
        productSelected.qty_scan = productSelected.qty_scan + event.qty;
        if ((productSelected.qty_scan > productSelected.qty_wait) &&
            productSelected.isPremium == false) {
          productSelected.qty_scan = productSelected.qty_scan;
        }
      }

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }

  Stream<DocdetailState> _mapProductQtyIncreasedToState(
      ProductQtyIncreased event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      DocDetail productSelected = docdetailLoadSuccess.docDetail.firstWhere(
          (element) =>
              element.itemCode == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '') {
        productSelected.qty_scan = productSelected.qty_scan + event.qty;
        if ((productSelected.qty_scan > productSelected.qty_wait) &&
            productSelected.isPremium == false) {
          productSelected.qty_scan = productSelected.qty_wait;
        }
      }

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }

  Stream<DocdetailState> _mapProductQtyDecreasedToState(
      ProductQtyDecreased event) async* {
    DocDetailLoadSuccess docdetailLoadSuccess;
    if (state is DocDetailLoadSuccess) {
      docdetailLoadSuccess = (state as DocDetailLoadSuccess).copyWith();
      DocDetail productSelected = docdetailLoadSuccess.docDetail.firstWhere(
          (element) =>
              element.itemCode == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '') {
        double sumQty = productSelected.qty_scan - event.qty;
        if (sumQty > 0) {
          productSelected.qty_scan = productSelected.qty_scan - event.qty;
        }
      }

      yield DocdetailInProgress();

      yield docdetailLoadSuccess.copyWith();
    }
  }
}
