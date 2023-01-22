import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

enum ProductStatus { unknown, warning, success }

class Product {
  final String code;
  final String name;
  final String unitCode;
  bool isPremium;
  bool icSerialNo;
  String whCode;
  String shelfCode;
  String price;

  double qty = 1.0;
  List<SerialNumber> serialNumbers = <SerialNumber>[];

  ProductStatus productStatus = ProductStatus.unknown;

  Product({
    required this.code,
    required this.name,
    required this.unitCode,
    bool? isPremium,
    String? whCode,
    String? shelfCode,
    String? price,
    double qty = 1.0,
    List<SerialNumber>? serialNumbers,
    bool? icSerialNo,
    ProductStatus? productStatus,
  })  : this.whCode = whCode ?? '',
        this.shelfCode = shelfCode ?? '',
        this.price = price ?? '0',
        this.isPremium = isPremium ?? false,
        this.qty = qty,
        this.serialNumbers = serialNumbers ?? <SerialNumber>[],
        this.icSerialNo = icSerialNo ?? false,
        this.productStatus = productStatus ?? ProductStatus.unknown;

  factory Product.fromMap(Map<String, dynamic> map) {
    List<SerialNumber> serialNumbers = <SerialNumber>[];

    double qty = 0.0;

    qty = double.parse(map['qty']);

    return Product(
      code: map['item_code'] ?? map['code'] ?? map['itemCode'],
      name: map['item_name'] ?? map['name'] ?? map['itemName'],
      whCode: map['warehouse'] ?? '',
      shelfCode: map['location'] ?? '',
      price: map['price'] ?? '0',
      qty: qty,
      isPremium: map['is_premium'] ?? false,
      unitCode: map['unit_cost'] ?? map['unit_code'] ?? map['unitCode'],
      icSerialNo: map['ic_serial_no'] ?? false,
      serialNumbers: serialNumbers,
    );
  }

  factory Product.empty() {
    return Product(code: "", name: "", unitCode: "");
  }

  Map<String, dynamic> toMap() {
    return {
      'item_code': code,
      'item_name': name,
      'unit_code': unitCode,
      'wh_code': whCode,
      'shelf_code': shelfCode,
      'price': price,
      'qty': qty,
      'ic_serial_no': icSerialNo,
      'serialNumbers': serialNumbers.map((s) => s.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
