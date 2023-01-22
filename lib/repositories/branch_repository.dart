import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/repositories/client.dart';

class BranchRepository {
  Future<ApiResponse> fetchAllBranch(StoreType storeType,
      {String q = ''}) async {
    Dio client = Client().init();
    try {
      final response = await client.get('v3/api/common/branches');
      print(response.toString());
      return ApiResponse.fromMap(json.decode(response.toString()));
    } on DioError catch (ex) {
      print(ex);
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }
}
