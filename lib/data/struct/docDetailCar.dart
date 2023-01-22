import 'dart:convert';

class DocDetailCar {
  final String doc_bo;
  final String drop_code;
  final String address;
  double event_qty = 0;
  int is_approve = 0;
  double box_qty = 0;

  DocDetailCar({
    required this.doc_bo,
    required this.drop_code,
    required this.address,
    double event_qty = 0,
    int is_approve = 0,
    double box_qty = 0,
  })  : this.event_qty = event_qty,
        this.is_approve = is_approve,
        this.box_qty = box_qty;

  factory DocDetailCar.fromMap(Map<String, dynamic> map) {
    double event_qty = 0.0;
    double box_qty = 0.0;
    int is_approve = 0;

    event_qty = double.tryParse(map['event_qty'].toString()) ?? 0.0;

    box_qty = double.tryParse(map['box_qty'].toString()) ?? 0.0;

    is_approve = int.tryParse(map['is_approve'].toString()) ?? 0;

    return DocDetailCar(
      doc_bo: map['doc_bo'] ?? '',
      drop_code: map['drop_code'] ?? '',
      address: map['address'] ?? '',
      event_qty: event_qty,
      box_qty: box_qty,
      is_approve: is_approve,
    );
  }

  factory DocDetailCar.empty() {
    return DocDetailCar(
      doc_bo: '',
      drop_code: '',
      address: '',
      event_qty: 0,
      box_qty: 0,
      is_approve: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_bo': doc_bo,
      'drop_code': drop_code,
      'address': address,
      'event_qty': event_qty,
      'box_qty': box_qty,
      'is_approve': is_approve,
    };
  }

  String toJson() => json.encode(toMap());

  factory DocDetailCar.fromJson(String source) =>
      DocDetailCar.fromMap(json.decode(source));
}
