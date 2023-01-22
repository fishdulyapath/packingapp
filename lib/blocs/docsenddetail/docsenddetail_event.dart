part of 'docsenddetail_bloc.dart';

abstract class DocSenddetailEvent extends Equatable {
  const DocSenddetailEvent();

  @override
  List<Object> get props => [];
}

class DocSenddetailLoaded extends DocSenddetailEvent {
  late final String docNo;

  DocSenddetailLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DocSenddetailReLoaded extends DocSenddetailEvent {
  late final String docNo;

  DocSenddetailReLoaded({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class DocSenddetailFormLoad extends DocSenddetailEvent {
  late final String docNo;

  DocSenddetailFormLoad({
    this.docNo = "",
  });

  @override
  List<Object> get props => [docNo];
}

class ProductScaned extends DocSenddetailEvent {
  final String barcode;
  final String textScan;
  ProductScaned({
    required this.barcode,
    required this.textScan,
  });

  @override
  List<Object> get props => [barcode, textScan];
}

class ProductRemoved extends DocSenddetailEvent {
  final String productCode;
  final String unitCode;

  ProductRemoved({
    required this.productCode,
    required this.unitCode,
  });

  @override
  List<Object> get props => [productCode, unitCode];
}

class ProductQtyChanged extends DocSenddetailEvent {
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

class ProductQtyIncreased extends DocSenddetailEvent {
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

class ProductQtyDecreased extends DocSenddetailEvent {
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
