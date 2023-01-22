import 'dart:convert';

import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docDetailCar.dart';

enum DoclistSendStatus { unknown, warning, success }

class DoclistSend {
  final String docNo;
  final String docDate;

  final String carDriverName;
  final String carDriverCode;
  final String boxEventCount;
  final String boxSendCount;
  final String carCode;
  final String carAssisName;
  final String carAssisCode;

  DoclistSendStatus doclistSendStatus = DoclistSendStatus.unknown;

  DoclistSend({
    required this.docNo,
    required this.docDate,
    required this.carDriverName,
    required this.carDriverCode,
    required this.boxEventCount,
    required this.carCode,
    required this.boxSendCount,
    required this.carAssisName,
    required this.carAssisCode,
    DoclistSendStatus? doclistSendStatus,
  }) : this.doclistSendStatus = doclistSendStatus ?? DoclistSendStatus.unknown;

  factory DoclistSend.fromMap(Map<String, dynamic> map) {
    return DoclistSend(
        docNo: map['docNo'] ?? map['doc_no'],
        docDate: map['docDate'] ?? map['doc_date'],
        carDriverName: map['car_driver_name'] ?? '',
        carDriverCode: map['car_driver_code'] ?? '',
        boxEventCount: map['box_event_count'] ?? '',
        carCode: map['car_code'] ?? '',
        boxSendCount: map['box_send_count'] ?? '',
        carAssisName: map['car_assis_name'] ?? map['car_assis_name'],
        carAssisCode: map['car_assis_code'] ?? map['car_assis_code']);
  }

  factory DoclistSend.empty() {
    return DoclistSend(
        docNo: '',
        docDate: '',
        carDriverName: '',
        carDriverCode: '',
        boxEventCount: '',
        carCode: '',
        boxSendCount: '',
        carAssisName: '',
        carAssisCode: '');
  }

  Map<String, dynamic> toMap() {
    return {
      "doc_no": docNo,
      "doc_date": docDate,
      "car_driver_name": carDriverName,
      "car_driver_code": carDriverCode,
      "box_event_count": boxEventCount,
      "car_code": carCode,
      "box_send_count": boxSendCount,
      "car_assis_name": carAssisName,
      "car_assis_code": carAssisCode
    };
  }

  String toJson() => json.encode(toMap());

  factory DoclistSend.fromJson(String source) =>
      DoclistSend.fromMap(json.decode(source));
}
