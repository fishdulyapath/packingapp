import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

class BoxScan {
  final String doc_no;
  final String doc_bo;

  BoxScan({
    required this.doc_no,
    required this.doc_bo,
  });

  factory BoxScan.fromMap(Map<String, dynamic> map) {
    return BoxScan(
      doc_no: map['doc_no'] ?? '',
      doc_bo: map['doc_bo'] ?? '',
    );
  }

  factory BoxScan.empty() {
    return BoxScan(doc_no: "", doc_bo: "");
  }

  String toShowLabel() {
    if (doc_no != '') {
      return '$doc_no~$doc_bo';
    } else {
      return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_no': doc_no,
      'doc_bo': doc_bo,
    };
  }

  String toJson() => json.encode(toMap());

  factory BoxScan.fromJson(String source) =>
      BoxScan.fromMap(json.decode(source));
}
