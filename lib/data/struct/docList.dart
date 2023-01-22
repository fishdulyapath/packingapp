import 'dart:convert';

import 'package:mobilepacking/data/struct/docDetail.dart';

enum DocListStatus { unknown, warning, success }

class DocList {
  final String docNo;
  final String docDate;
  final String transFlag;
  final String itemCount;
  final String itemSuccess;
  final String transportName;
  final String docFormatCode;
  final String toBranchCode;
  final String logisticArea;
  final String toBranchName2;
  final String toBranchName;
  final int status;

  DocListStatus docListStatus = DocListStatus.unknown;

  List<DocDetail> details = <DocDetail>[];
  DocList({
    required this.docNo,
    required this.docDate,
    required this.transFlag,
    required this.itemCount,
    required this.itemSuccess,
    required this.transportName,
    required this.docFormatCode,
    required this.toBranchCode,
    required this.logisticArea,
    required this.toBranchName,
    required this.toBranchName2,
    required this.status,
    List<DocDetail>? details,
    DocListStatus? docListStatus,
  }) : this.docListStatus = docListStatus ?? DocListStatus.unknown;

  factory DocList.fromMap(Map<String, dynamic> map) {
    return DocList(
        docNo: map['docNo'] ?? map['doc_no'],
        transportName: map['transport_name'] ?? '',
        docFormatCode: map['doc_format_code'] ?? '',
        toBranchCode: map['to_branch_code'] ?? '',
        logisticArea: map['logistic_area'] ?? '',
        toBranchName: map['to_branch_name'] ?? '',
        toBranchName2: map['to_branch_name_2'] ?? '',
        status: map['status'] ?? 0,
        docDate: map['docDate'] ?? map['doc_date'],
        transFlag: map['transFlag'] ?? map['trans_flag'],
        itemCount: map['itemCount'] ?? map['item_count'],
        itemSuccess: map['itemSuccess'] ?? map['item_success']);
  }

  factory DocList.empty() {
    return DocList(
        docNo: "",
        status: 0,
        docDate: "",
        transFlag: "0",
        itemCount: "0",
        itemSuccess: "0",
        transportName: '',
        docFormatCode: '',
        toBranchCode: '',
        logisticArea: '',
        toBranchName: '',
        toBranchName2: '');
  }

  Map<String, dynamic> toMap() {
    return {
      'doc_no': docNo,
      'status': status,
      'doc_date': docDate,
      'trans_flag': transFlag,
      'transport_name': transportName,
      'doc_format_code': docFormatCode,
      'to_branch_code': toBranchCode,
      'logistic_area': logisticArea,
      'to_branch_name': toBranchName,
      'to_branch_name_2': toBranchName2,
      'item_count': itemCount,
      'item_success': itemCount,
    };
  }

  String toJson() => json.encode(toMap());

  factory DocList.fromJson(String source) =>
      DocList.fromMap(json.decode(source));
}
