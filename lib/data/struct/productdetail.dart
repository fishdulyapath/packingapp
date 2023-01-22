import 'dart:convert';

class ProductDetail {
  final String itemCode;
  final String itemName;
  final String unitCode;
  final String price;
  ProductDetail({
    required this.itemCode,
    required this.itemName,
    required this.unitCode,
    required this.price,
  });

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      itemCode: map['item_code'] ?? map['code'] ?? map['itemCode'],
      itemName: map['item_name'] ?? map['itemName'],
      unitCode: map['unit_cost'] ?? map['unit_code'] ?? map['unitCode'],
      price: map['price'],
    );
  }

  factory ProductDetail.empty() {
    return ProductDetail(itemCode: "", itemName: "", unitCode: "", price: "");
  }

  Map<String, dynamic> toMap() {
    return {
      'item_code': itemCode,
      'name': itemName,
      'unit_code': unitCode,
      'price': price,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProductDetail.fromJson(String source) =>
      ProductDetail.fromMap(json.decode(source));
}
