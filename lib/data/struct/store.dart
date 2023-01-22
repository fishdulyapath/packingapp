import 'dart:convert';

import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/exception/product_exception.dart';

class Store {
  final String docNo;
  final String docRef;
  late final String docDate;
  final String docFormatCode;
  final double totalAmount;
  final String docTime;
  final String branchCode;
  final String whCode;
  final String shelfCode;

  List<Product> details = <Product>[];

  Store({
    required this.docNo,
    required this.docDate,
    required this.docFormatCode,
    required this.totalAmount,
    required this.docTime,
    required this.branchCode,
    required this.whCode,
    required this.shelfCode,
    String? docRef,
    List<Product>? details,
  })  : this.docRef = docRef ?? '',
        this.details = details ?? <Product>[];

  Map<String, dynamic> toMap() {
    return {
      'doc_no': docNo,
      'doc_ref': docRef,
      'doc_date': docDate,
      'doc_format_code': docFormatCode,
      'total_amount': totalAmount,
      'doc_time': docTime,
      'branch_code': branchCode,
      'wh_code': whCode,
      'shelf_code': shelfCode,
      'details': details.map((product) => product.toMap()).toList()
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      docNo: map['doc_no'],
      docRef: map['doc_ref'] ?? '',
      docDate: map['doc_date'],
      docFormatCode: map['doc_format_code'],
      totalAmount: map['total_amount'] ?? 0.0,
      docTime: map['doc_time'] ?? '',
      branchCode: map['branch_code'] ?? '',
      whCode: map['wh_code'] ?? '',
      shelfCode: map['shelf_code'] ?? '',
      details:
          List<Product>.from(map['details']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  bool isMatchRefProduct(List<Product> refProducts) {
    //  check count item
    if (this.details.length != refProducts.length) {
      throw new ProductException("Product Item Not Match");
    }

    // check sum of item
    double sumProductQty = this.details.fold(0, (sum, item) => sum + item.qty);
    double sumRefProductQty =
        refProducts.fold(0, (sum, item) => sum + item.qty);

    if (sumProductQty != sumRefProductQty) {
      throw new ProductException("Sum QTY Not Match");
    }

    refProducts.forEach((p) {
      List<Product> findDetailProduct =
          this.details.where((element) => element.code == p.code).toList();
      if (findDetailProduct.length == 0) {
        throw new ProductException("Product Ref Not Found");
      }

      Product productForCheck = findDetailProduct[0];

      if (p.qty != findDetailProduct[0].qty) {
        throw new ProductException("Some QTY Not Match " + p.code);
      }

      if (p.icSerialNo) {
        p.serialNumbers.forEach((serial) {
          List<SerialNumber> serials = productForCheck.serialNumbers
              .takeWhile((value) => value.serialNumber == serial.serialNumber)
              .toList();
          if (serials.length != p.serialNumbers.length) {
            throw new ProductException(
                "Some Serial number Not Match" + serial.serialNumber);
          }
        });
      }
    });

    return true;
  }
}
