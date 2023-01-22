import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

class Boxsend {
  final String doc_no;

  Boxsend({required this.doc_no});

  factory Boxsend.fromMap(Map<String, dynamic> map) {
    return Boxsend(doc_no: map['doc_no'] ?? '');
  }

  factory Boxsend.empty() {
    return Boxsend(doc_no: "");
  }

  String toShowLabel() {
    if (doc_no != '') {
      return '$doc_no';
    } else {
      return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_no': doc_no,
    };
  }

  String toJson() => json.encode(toMap());

  factory Boxsend.fromJson(String source) =>
      Boxsend.fromMap(json.decode(source));
}
