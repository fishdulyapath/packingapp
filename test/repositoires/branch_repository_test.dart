import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/repositories/branch_repository.dart';

void main() {
  test('get all branch', () async {
    var branchRepository = BranchRepository();
    try {
      var resp = await branchRepository.fetchAllBranch(StoreType.PackingSO);
      print(resp.toString());
    } on DioError catch (ex) {
      print('msg ${ex.response.toString()}');
    }
  });
}

class Branchx {
  Branchx({
    required this.code,
    required this.name,
    barcodes,
  }) : this.barcodes = barcodes ?? <String>[];

  final String code;
  final String name;
  final List<String> barcodes;

  static empty() {
    return Branchx(code: "", name: "");
  }
}
