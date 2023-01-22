import 'dart:convert';

class DocDetailSend {
  final String doc_bo;
  String sender_code;
  String address;
  String drop_code;
  String cust_code;

  String event_qty;
  String send_qty;
  String total_amount;
  String send_time;
  bool isChecked = false;

  DocDetailSend({
    required this.doc_bo,
    required this.sender_code,
    required this.drop_code,
    required this.address,
    required this.cust_code,
    required this.event_qty,
    required this.send_qty,
    required this.total_amount,
    required this.send_time,
    bool isChecked = false,
  }) : this.isChecked = isChecked ?? false;

  factory DocDetailSend.fromMap(Map<String, dynamic> map) {
    return DocDetailSend(
      doc_bo: map['doc_bo'] ?? '',
      sender_code: map['sender_code'] ?? '',
      drop_code: map['drop_code'] ?? '',
      address: map['address'] ?? '',
      cust_code: map['cust_code'] ?? '',
      event_qty: map['event_qty'] ?? '',
      send_qty: map['send_qty'] ?? '',
      total_amount: map['total_amount'] ?? '',
      send_time: map['send_time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_bo': doc_bo,
      'sender_code': sender_code,
      'drop_code': drop_code,
      'address': address,
      'cust_code': cust_code,
      'event_qty': event_qty,
      'send_qty': send_qty,
      'total_amount': total_amount,
      'send_time': send_time,
    };
  }

  String toJson() => json.encode(toMap());

  factory DocDetailSend.fromJson(String source) =>
      DocDetailSend.fromMap(json.decode(source));
}
