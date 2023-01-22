import 'dart:convert';

import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/exception/product_exception.dart';

class StorePack {
  final String docNo;
  final String docRef;
  late final String docDate;
  final String dropCode;
  final String docTime;
  final int boxNumber;
  final int status;
  final String creatorCode;
  final double totalAmount;
  final String branchCode;
  List<DocDetail> details = <DocDetail>[];

  StorePack({
    required this.docNo,
    required this.docDate,
    required this.dropCode,
    required this.totalAmount,
    required this.boxNumber,
    required this.status,
    required this.docTime,
    required this.branchCode,
    required this.creatorCode,
    required this.docRef,
    List<DocDetail>? details,
  }) : this.details = details ?? <DocDetail>[];

  Map<String, dynamic> toMap() {
    return {
      'doc_no': docNo,
      'doc_ref': docRef,
      'doc_date': docDate,
      'total_amount': totalAmount,
      'doc_time': docTime,
      'branch_code': branchCode,
      'drop_code': dropCode,
      'status': status,
      'box_number': boxNumber,
      'creator_code': creatorCode,
      'details': details.map((product) => product.toMap()).toList()
    };
  }

  factory StorePack.fromMap(Map<String, dynamic> map) {
    double totalAmount = 0.0;
    totalAmount = double.tryParse(map['total_amount'].toString()) ?? 0.0;
    return StorePack(
      docNo: map['doc_no'],
      docRef: map['doc_ref'] ?? '',
      docDate: map['doc_date'],
      dropCode: map['drop_code'],
      totalAmount: totalAmount,
      docTime: map['doc_time'] ?? '',
      branchCode: map['branch_code'] ?? '',
      creatorCode: map['creator_code'] ?? '',
      status: map['status'] ?? 0,
      boxNumber: map['box_number'] ?? 0,
      details: List<DocDetail>.from(
          map['details']?.map((x) => DocDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());
}
