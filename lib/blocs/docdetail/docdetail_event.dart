part of 'docdetail_bloc.dart';

abstract class DocdetailEvent extends Equatable {
  const DocdetailEvent();

  @override
  List<Object> get props => [];
}

class DocdetailLoaded extends DocdetailEvent {
  late final String docNo;

  DocdetailLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DocdetailReLoaded extends DocdetailEvent {
  late final String docNo;

  DocdetailReLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DocdetailFormLoad extends DocdetailEvent {
  late final String docNo;

  DocdetailFormLoad({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class ProductScaned extends DocdetailEvent {
  final String barcode;
  final String textScan;
  ProductScaned({
    required this.barcode,
    required this.textScan,
  });

  @override
  List<Object> get props => [barcode, textScan];
}

class ProductRemoved extends DocdetailEvent {
  final String productCode;
  final String unitCode;

  ProductRemoved({
    required this.productCode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, unitCode];
}

class ProductQtyChanged extends DocdetailEvent {
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

class ProductQtyClear extends DocdetailEvent {
  @override
  List<Object> get props => [];
}

class ProductQtyIncreased extends DocdetailEvent {
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

class ProductQtyIncreasedMerge extends DocdetailEvent {
  final String productCode;
  final double qty;
  final String unitCode;

  ProductQtyIncreasedMerge({
    required this.productCode,
    double qty = 0,
    required this.unitCode,
  }) : this.qty = qty;

  @override
  List<Object> get props => [productCode, qty, unitCode];
}

class ProductQtyDecreased extends DocdetailEvent {
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
