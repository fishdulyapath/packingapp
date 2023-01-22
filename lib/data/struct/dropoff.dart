import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

class Dropoff {
  final String code;
  final String name;

  Dropoff({
    required this.code,
    required this.name,
  });

  factory Dropoff.fromMap(Map<String, dynamic> map) {
    return Dropoff(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
    );
  }

  factory Dropoff.empty() {
    return Dropoff(code: "", name: "");
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

  factory Dropoff.fromJson(String source) =>
      Dropoff.fromMap(json.decode(source));
}
