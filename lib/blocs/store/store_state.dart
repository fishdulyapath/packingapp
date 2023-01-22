part of 'store_bloc.dart';

enum StoreType { Initial, PackingSO, Packcar, Packbox }

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoadInProgress extends StoreState {}

class StoreLoadSuccess extends StoreState {
  final StoreType type;
  late final String docNo;
  late final Branch branch;
  late final WarehouseLocation warehouseLocation;
  final List<Product> products;
  late final List<Product> refProducts;

  StoreLoadSuccess({
    required this.type,
    required this.products,
    String? docNo,
    Branch? branch,
    WarehouseLocation? warehouseLocation,
    List<Product>? refProducts,
  })  : this.docNo = docNo ?? '',
        this.branch = branch ?? Branch.empty(),
        this.refProducts = refProducts ?? <Product>[],
        this.warehouseLocation = warehouseLocation ?? WarehouseLocation.empty();

  StoreLoadSuccess copyWith({
    StoreType? type,
    String? docNo,
    Branch? branch,
    WarehouseLocation? warehouseLocation,
    List<Product>? products,
    List<Product>? refProducts,
  }) =>
      StoreLoadSuccess(
        type: type ?? this.type,
        docNo: docNo ?? this.docNo,
        branch: branch ?? this.branch,
        warehouseLocation: warehouseLocation ?? this.warehouseLocation,
        products: products ?? this.products,
        refProducts: refProducts ?? this.refProducts,
      );

  @override
  List<Object> get props => [
        type,
        branch,
        warehouseLocation,
        products,
      ];
}

class StoreScanProductFailure extends StoreState {
  final String message;
  StoreScanProductFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class StoreLoadFailure extends StoreState {}
