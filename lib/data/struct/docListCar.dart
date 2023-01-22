import 'dart:convert';

import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docDetailCar.dart';

enum DoclistCarStatus { unknown, warning, success }

class DoclistCar {
  final String docNo;
  final String docDate;
  final String branchCode;
  final String carDriverName;
  final String carDriverCode;
  final String boQty;
  final String carCode;
  final String boSuccess;
  final String carAssisName;
  final String docTime;
  final String carAssisCode;
  final String carCheckout;
  final int status;

  DoclistCarStatus doclistCarStatus = DoclistCarStatus.unknown;

  List<DocDetailCar> details = <DocDetailCar>[];
  DoclistCar({
    required this.docNo,
    required this.docDate,
    required this.branchCode,
    required this.carDriverName,
    required this.carDriverCode,
    required this.boQty,
    required this.carCode,
    required this.boSuccess,
    required this.carAssisName,
    required this.docTime,
    required this.carAssisCode,
    required this.carCheckout,
    required this.status,
    List<DocDetailCar>? details,
    DoclistCarStatus? doclistCarStatus,
  }) : this.doclistCarStatus = doclistCarStatus ?? DoclistCarStatus.unknown;

  factory DoclistCar.fromMap(Map<String, dynamic> map) {
    return DoclistCar(
        docNo: map['docNo'] ?? map['doc_no'],
        docDate: map['docDate'] ?? map['doc_date'],
        branchCode: map['branch_code'] ?? '',
        carDriverName: map['car_driver_name'] ?? '',
        carDriverCode: map['car_driver_code'] ?? '',
        boQty: map['bo_qty'] ?? '',
        carCode: map['car_code'] ?? '',
        boSuccess: map['bo_success'] ?? '',
        status: map['status'] ?? 0,
        carAssisName: map['car_assis_name'] ?? map['car_assis_name'],
        docTime: map['doc_time'] ?? map['doc_time'],
        carCheckout: map['car_checkout'] ?? map['car_checkout'],
        carAssisCode: map['car_assis_code'] ?? map['car_assis_code']);
  }

  factory DoclistCar.empty() {
    return DoclistCar(
        docNo: '',
        docDate: '',
        branchCode: '',
        carDriverName: '',
        carDriverCode: '',
        boQty: '',
        carCode: '',
        boSuccess: '',
        status: 0,
        carAssisName: '',
        docTime: '',
        carCheckout: '',
        carAssisCode: '');
  }

  Map<String, dynamic> toMap() {
    return {
      "doc_no": docNo,
      "doc_date": docDate,
      "branch_code": branchCode,
      "car_driver_name": carDriverName,
      "car_driver_code": carDriverCode,
      "bo_qty": boQty,
      "car_code": carCode,
      "bo_success": boSuccess,
      "status": status,
      "car_assis_name": carAssisName,
      "doc_time": docTime,
      "car_checkout": carCheckout,
      "car_assis_code": carAssisCode
    };
  }

  String toJson() => json.encode(toMap());

  factory DoclistCar.fromJson(String source) =>
      DoclistCar.fromMap(json.decode(source));
}
