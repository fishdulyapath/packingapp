part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class StoreLoaded extends StoreEvent {
  final StoreType type;
  late final String docNo;
  late final Branch branch;
  late final WarehouseLocation warehouseLocation;
  final List<Product> products;

  StoreLoaded({
    required this.type,
    required this.products,
    String? docNo,
    Branch? branch,
    WarehouseLocation? warehouseLocation,
  })  : this.docNo = docNo ?? '',
        this.branch = branch ?? Branch.empty(),
        this.warehouseLocation = warehouseLocation ?? WarehouseLocation.empty();

  @override
  List<Object> get props => [type, docNo, branch, warehouseLocation, products];
}

class StorePackingSOLoaded extends StoreEvent {
  final Store store;

  StorePackingSOLoaded({
    required this.store,
  });

  @override
  List<Object> get props => [store];
}

class StorePackingFMLoaded extends StoreEvent {
  final Store store;

  StorePackingFMLoaded({
    required this.store,
  });

  @override
  List<Object> get props => [store];
}

class StoreProductAded extends StoreEvent {
  final Product product;
  final double qty;
  final User user;

  StoreProductAded({required this.product, this.qty = 1, required this.user});

  @override
  List<Object> get props => [product, user];
}

class StoreProductScaned extends StoreEvent {
  final String barcode;
  final User user;
  final StoreType storeType;
  StoreProductScaned({
    required this.barcode,
    required this.user,
    required this.storeType,
  });

  @override
  List<Object> get props => [barcode, user];
}

class StoreProductTextScaned extends StoreEvent {
  final String textScan;
  final User user;
  final StoreType storeType;
  StoreProductTextScaned({
    required this.textScan,
    required this.user,
    required this.storeType,
  });

  @override
  List<Object> get props => [textScan, user];
}

class StoreProductBarcodeScaned extends StoreEvent {
  final String productCode;
  final String barcode;
  final String unitCode;

  StoreProductBarcodeScaned({
    required this.productCode,
    required this.barcode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, barcode, unitCode];
}

class StoreProductBarcodeRemoved extends StoreEvent {
  final String productCode;
  final String barcode;
  final String unitCode;
  StoreProductBarcodeRemoved({
    required this.productCode,
    required this.barcode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, barcode, unitCode];
}

class StoreProductRemoved extends StoreEvent {
  final String productCode;
  final String unitCode;

  StoreProductRemoved({
    required this.productCode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, unitCode];
}

class StoreProductQtyChanged extends StoreEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  StoreProductQtyChanged({
    required this.productCode,
    required this.qty,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, qty, unitCode];
}

class StoreProductQtyIncreased extends StoreEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  StoreProductQtyIncreased({
    required this.productCode,
    double qty = 1,
    required this.unitCode,
  }) : this.qty = qty;

  @override
  List<Object> get props => [productCode, qty, unitCode];
}

class StoreProductQtyDecreased extends StoreEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  StoreProductQtyDecreased({
    required this.productCode,
    double qty = 1,
    required this.unitCode,
  }) : this.qty = qty;

  @override
  List<Object> get props => [productCode, qty, unitCode];
}
