import 'dart:convert';

class DocDetail {
  final String itemCode;
  final String itemName;
  final String unitCode;

  double qty = 0;
  double price = 0;

  double sumAmount = 0;
  bool isPremium = false;
  double qty_scan = 0;
  double qty_success = 0;
  double qty_wait = 0;

  DocDetail({
    required this.itemCode,
    required this.itemName,
    required this.unitCode,
    int lineNumber = 0,
    double qty = 0,
    double price = 0,
    double sumAmount = 0,
    double qty_success = 0,
    double qty_wait = 0,
    double qty_scan = 0,
    bool isPremium = false,
  })  : this.qty = qty,
        this.price = price,
        this.qty_wait = qty - qty_success,
        this.qty_scan = qty_scan,
        this.qty_success = qty_success,
        this.sumAmount = sumAmount,
        this.isPremium = isPremium;

  factory DocDetail.fromMap(Map<String, dynamic> map) {
    double qty = 0.0;
    double price = 0.0;
    double sumAmount = 0.0;
    double qty_wait = 0.0;
    double qty_scan = 0.0;
    double qty_success = 0.0;
    bool isPremium = false;

    qty = double.tryParse(map['qty'].toString()) ?? 0.0;

    qty_success = double.tryParse(map['qty_success'].toString()) ?? 0.0;

    price = double.tryParse(map['price'].toString()) ?? 0.0;

    sumAmount = double.tryParse(map['sum_amount'].toString()) ?? 0.0;

    return DocDetail(
        itemCode: map['item_code'] ?? map['code'] ?? map['itemCode'],
        itemName: map['item_name'] ?? map['itemName'],
        unitCode: map['unit_cost'] ?? map['unit_code'] ?? map['unitCode'],
        qty: qty,
        qty_scan: qty_scan,
        qty_success: qty_success,
        qty_wait: qty - qty_success,
        price: price,
        sumAmount: sumAmount,
        isPremium: isPremium);
  }

  factory DocDetail.empty() {
    return DocDetail(
      itemCode: '',
      itemName: '',
      unitCode: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_code': itemCode,
      'item_name': itemName,
      'unit_code': unitCode,
      'qty': qty,
      'qty_scan': qty_scan,
      'qty_success': qty_success,
      'qty_wait': qty_wait,
      'price': price,
      'sum_amount': sumAmount
    };
  }

  String toJson() => json.encode(toMap());

  factory DocDetail.fromJson(String source) =>
      DocDetail.fromMap(json.decode(source));
}
