import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final ProductRepository _productRepository;

  StoreBloc({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(StoreInitial());

  @override
  Stream<StoreState> mapEventToState(
    StoreEvent event,
  ) async* {
    if (event is StoreLoaded) {
      yield* _mapStoreLoadedToState(event);
    } else if (event is StoreProductAded) {
      yield* _mapStoreProductAdedToState(event);
    } else if (event is StoreProductScaned) {
      yield* _mapStoreProductScanedToState(event);
    } else if (event is StoreProductTextScaned) {
      yield* _mapStoreProductTextScanedToState(event);
    } else if (event is StoreProductRemoved) {
      yield* _mapStoreProductRemovedToState(event);
    } else if (event is StoreProductQtyChanged) {
      yield* _mapStoreProductQtyChangedToState(event);
    } else if (event is StoreProductQtyIncreased) {
      yield* _mapStoreProductQtyIncreasedToState(event);
    } else if (event is StoreProductQtyDecreased) {
      yield* _mapStoreProductQtyDecreasedToState(event);
    } else if (event is StoreProductBarcodeScaned) {
      yield* _mapStoreProductBarcodeScanedToState(event);
    } else if (event is StoreProductBarcodeRemoved) {
      yield* _mapStoreProductBarcodeRemovedToState(event);
    } else if (event is StorePackingSOLoaded) {
      yield* _mapStorePackingSOLoadedToState(event);
    } else if (event is StorePackingFMLoaded) {
      yield* _mapStorePackingFMLoadedToState(event);
    }
  }

  Stream<StoreState> _mapStoreLoadedToState(StoreLoaded event) async* {
    yield StoreLoadInProgress();
    if (event.type == StoreType.PackingSO) {
      yield StoreLoadSuccess(
        type: event.type,
        docNo: event.docNo,
        products: event.products,
      );
    }
  }

  Stream<StoreState> _mapStorePackingSOLoadedToState(
      StorePackingSOLoaded event) async* {
    yield StoreLoadInProgress();

    final store = event.store;

    yield StoreLoadSuccess(
      type: StoreType.PackingSO,
      docNo: store.docNo,
      branch: Branch(
        code: store.branchCode,
        name: '',
      ),
      warehouseLocation: WarehouseLocation(
        whcode: store.whCode,
        whname: '',
        locationcode: store.shelfCode,
        locationname: '',
      ),
      products: <Product>[],
      refProducts: event.store.details,
    );
  }

  Stream<StoreState> _mapStorePackingFMLoadedToState(
      StorePackingFMLoaded event) async* {
    yield StoreLoadInProgress();

    final store = event.store;

    yield StoreLoadSuccess(
      type: StoreType.PackingSO,
      docNo: store.docNo,
      branch: Branch(
        code: store.branchCode,
        name: '',
      ),
      warehouseLocation: WarehouseLocation(
        whcode: store.whCode,
        whname: '',
        locationcode: store.shelfCode,
        locationname: '',
      ),
      products: <Product>[],
      refProducts: event.store.details,
    );
  }

  Stream<StoreState> _mapStoreProductAdedToState(
      StoreProductAded event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.product.code &&
              element.unitCode == event.product.unitCode,
          orElse: () => Product.empty());

      final bool isInProductPackingSO =
          productInPackingSOProductRef(storeLoadSuccess, productSelected, '');
      final bool isNotInProductPackingSO = !isInProductPackingSO;

      if (storeLoadSuccess.type == StoreType.PackingSO &&
          isNotInProductPackingSO) {
        // yield StoreScanProductFailure(
        //     message: 'สินค้านี้ ไม่ได้อยู่ในรายการเบิกสินค้า');
        yield StoreScanProductFailure(message: '');
      }

      if (event.product.whCode == '') {
        if (storeLoadSuccess.warehouseLocation.whcode != '') {
          event.product.whCode = storeLoadSuccess.warehouseLocation.whcode;
        } else if (event.user.icWht != '') {
          event.product.whCode = event.user.icWht;
        }
      }

      if (event.product.shelfCode == '') {
        if (storeLoadSuccess.warehouseLocation.locationcode != '') {
          event.product.shelfCode =
              storeLoadSuccess.warehouseLocation.locationcode;
        } else if (event.user.icShelf != '') {
          event.product.shelfCode = event.user.icShelf;
        }
      }

      if ((storeLoadSuccess.type == StoreType.PackingSO &&
          isInProductPackingSO)) {
        if (productSelected.code == '') {
          event.product.qty = event.qty;
          storeLoadSuccess.products.add(event.product);
        } else {
          productSelected.qty = productSelected.qty + event.qty;
        }
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductTextScanedToState(
      StoreProductTextScaned event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      List<String> txtSplit = event.textScan.split("*");
      double _qty = 1;
      String _textScan = "";
      if (txtSplit.length > 1) {
        _qty = double.parse(txtSplit[0]);
        _textScan = txtSplit[1];
      } else {
        _textScan = txtSplit[0];
      }
      final resp = await _productRepository.fetchProductByScanbarcode(
          _textScan, event.storeType);

      if (resp.success) {
        final productInfo = resp.data;
        String _whCode = "";
        String _shelfCode = "";

        /* if (storeLoadSuccess.type == StoreType.Packbox) {
          _whCode = event.user.icWht;
          _shelfCode = event.user.icShelf;
        }*/
        bool premium = (productInfo?['item_type'] == '1') ? true : false;
        final product = Product(
          code: productInfo?['item_code'],
          name: productInfo?['item_name'],
          unitCode: productInfo?['unit_code'],
          whCode: _whCode,
          shelfCode: _shelfCode,
          isPremium: premium,
          icSerialNo: false,
        );
        Product productSelected = product;
        String barcode = productInfo?['barcode'];
        final bool isInProductPackingSO =
            productInPackingSOProductRef(storeLoadSuccess, product, barcode);
        final bool isNotInProductPackingSO = !isInProductPackingSO;

        if (storeLoadSuccess.type == StoreType.PackingSO &&
            isNotInProductPackingSO) {
          // yield StoreScanProductFailure(
          //     message: 'สินค้านี้ ไม่ได้อยู่ในรายการเบิกสินค้า');
          yield StoreScanProductFailure(message: '');
        }

        if ((storeLoadSuccess.type == StoreType.PackingSO &&
            isInProductPackingSO)) {
          if (productSelected.code == '') {
            product.qty = _qty;
            storeLoadSuccess.products.add(product);
          } else {
            productSelected.qty = productSelected.qty + _qty;
          }
        }
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductScanedToState(
      StoreProductScaned event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();

      final resp = await _productRepository.fetchProductByScanbarcode(
          event.barcode, event.storeType);

      if (resp.success) {
        final productInfo = resp.data;
        String _whCode = "";
        String _shelfCode = "";
        bool isPremiumProduct =
            (productInfo?['item_type'] == "1") ? true : false;

        if (storeLoadSuccess.type == StoreType.Packbox) {
          _whCode = event.user.icWht;
          _shelfCode = event.user.icShelf;
        }

        print("whCode " + _whCode);
        final product = Product(
          code: productInfo?['ic_code'],
          name: productInfo?['description'],
          unitCode: productInfo?['unit_code'],
          price: productInfo?['price'],
          whCode: _whCode,
          isPremium: isPremiumProduct,
          shelfCode: _shelfCode,
          icSerialNo: false,
        );
        Product productSelected = storeLoadSuccess.products.firstWhere(
            (element) =>
                element.code == product.code &&
                element.unitCode == product.unitCode,
            orElse: () => Product.empty());
        ;

        String barcode = productInfo?['barcode'];
        final bool isInProductPackingSO =
            productInPackingSOProductRef(storeLoadSuccess, product, barcode);

        final bool isNotInProductPackingSO = !isInProductPackingSO;

        if (storeLoadSuccess.type == StoreType.Packbox &&
            isNotInProductPackingSO) {
          // yield StoreScanProductFailure(
          //     message: 'สินค้านี้ ไม่ได้อยู่ในรายการสินค้า');
          yield StoreScanProductFailure(message: '');
        }

        if ((storeLoadSuccess.type == StoreType.Packbox &&
            isInProductPackingSO)) {
          if (productSelected.code == '') {
            storeLoadSuccess.products.add(product);
          } else {
            productSelected.qty = productSelected.qty + 1;
          }
        }
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductRemovedToState(
      StoreProductRemoved event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        storeLoadSuccess.products.remove(productSelected);
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductQtyChangedToState(
      StoreProductQtyChanged event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        productSelected.qty = event.qty;
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductQtyIncreasedToState(
      StoreProductQtyIncreased event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        productSelected.qty = productSelected.qty + event.qty;
      }

      print(productSelected.qty);

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductQtyDecreasedToState(
      StoreProductQtyDecreased event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();
      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        double sumQty = productSelected.qty - event.qty;
        if (sumQty > 0) {
          productSelected.qty = productSelected.qty - event.qty;
        }
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductBarcodeScanedToState(
      StoreProductBarcodeScaned event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();

      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        SerialNumber serialNumberFinded = productSelected.serialNumbers
            .firstWhere((serial) => serial.serialNumber == event.barcode,
                orElse: () => SerialNumber.empty());
        if (serialNumberFinded.serialNumber == '') {
          productSelected.serialNumbers
              .add(SerialNumber(serialNumber: event.barcode));
          productSelected.qty += 1;
        }
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  Stream<StoreState> _mapStoreProductBarcodeRemovedToState(
      StoreProductBarcodeRemoved event) async* {
    StoreLoadSuccess storeLoadSuccess;
    if (state is StoreLoadSuccess) {
      storeLoadSuccess = (state as StoreLoadSuccess).copyWith();

      Product productSelected = storeLoadSuccess.products.firstWhere(
          (element) =>
              element.code == event.productCode &&
              element.unitCode == event.unitCode,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        productSelected.serialNumbers
            .removeWhere((serial) => serial.serialNumber == event.barcode);
        productSelected.qty -= 1;
      }

      yield StoreLoadInProgress();

      yield storeLoadSuccess.copyWith();
    }
  }

  bool productInPackingSOProductRef(
      StoreLoadSuccess storeLoadSuccess, Product product, String serialNumber) {
    if (product.isPremium) {
      return true;
    }
    if (storeLoadSuccess.type == StoreType.Packbox) {
      Product refProductSelected = storeLoadSuccess.refProducts.firstWhere(
          (element) =>
              element.code == product.code &&
              element.unitCode == product.unitCode,
          orElse: () => Product.empty());
      if (refProductSelected.code == '') {
        return false;
      }

      if (product.icSerialNo) {
        int serialFindIndex = refProductSelected.serialNumbers
            .lastIndexWhere((element) => element.serialNumber == serialNumber);
        if (serialFindIndex == -1) return false;
      }
      return true;
    }
    return false;
  }
}
