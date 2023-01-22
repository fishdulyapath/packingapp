import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobilepacking/repositories/client.dart';

class WarehouseLocationRepository {
  Future<ApiResponse> fetchAllWarehouseLocation({String q = ''}) async {
    Dio client = Client().init();
    try {
      final response = await client.get('v3/api/common/warehouselocations');
      return ApiResponse.fromMap(json.decode(response.toString()));
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }
}
