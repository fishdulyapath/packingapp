part of 'doccardetail_bloc.dart';

abstract class DoccardetailEvent extends Equatable {
  const DoccardetailEvent();

  @override
  List<Object> get props => [];
}

class DoccardetailLoaded extends DoccardetailEvent {
  late final String docNo;

  DoccardetailLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DoccardetailReLoaded extends DoccardetailEvent {
  late final String docNo;

  DoccardetailReLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DoccardetailFormLoad extends DoccardetailEvent {
  late final String docNo;

  DoccardetailFormLoad({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class ProductScaned extends DoccardetailEvent {
  final String barcode;
  final String textScan;
  ProductScaned({
    required this.barcode,
    required this.textScan,
  });

  @override
  List<Object> get props => [barcode, textScan];
}

class ProductRemoved extends DoccardetailEvent {
  final String productCode;
  final String unitCode;

  ProductRemoved({
    required this.productCode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, unitCode];
}

class ProductQtyChanged extends DoccardetailEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  ProductQtyChanged({
    required this.productCode,
    required this.qty,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, qty, unitCode];
}

class ProductQtyIncreased extends DoccardetailEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  ProductQtyIncreased({
    required this.productCode,
    double qty = 1,
    required this.unitCode,
  }) : this.qty = qty;

  @override
  List<Object> get props => [productCode, qty, unitCode];
}

class ProductQtyDecreased extends DoccardetailEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  ProductQtyDecreased({
    required this.productCode,
    double qty = 1,
    required this.unitCode,
  }) : this.qty = qty;

  @override
  List<Object> get props => [productCode, qty, unitCode];
}
