import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

class Customer {
  final String code;
  final String name;

  Customer({
    required this.code,
    required this.name,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
    );
  }

  factory Customer.empty() {
    return Customer(code: "", name: "");
  }

  String toShowLabel() {
    if (code != '') {
      return '$code~$name';
    } else {
      return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));
}
