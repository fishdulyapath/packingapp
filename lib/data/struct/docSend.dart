import 'dart:convert';

import 'package:mobilepacking/data/struct/serial_number.dart';

class Docsend {
  final String doc_no;
  final String doc_bo;
  final String imagefile;

  Docsend(
      {required this.doc_no, required this.doc_bo, required this.imagefile});

  factory Docsend.fromMap(Map<String, dynamic> map) {
    return Docsend(
        doc_no: map['doc_no'] ?? '',
        doc_bo: map['doc_bo'],
        imagefile: map['image_file']);
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_no': doc_no,
      'doc_bo': doc_bo,
      'image_file': imagefile,
    };
  }

  String toJson() => json.encode(toMap());

  factory Docsend.fromJson(String source) =>
      Docsend.fromMap(json.decode(source));
}
