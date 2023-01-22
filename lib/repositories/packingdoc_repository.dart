import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/doclist/doclist_bloc.dart';
import 'client.dart';

class DocListRepository {
  Future<ApiResponse> fetchAllDoclist(
      {String search = "",
      String from_date = "",
      String to_date = "",
      String branch_code = "",
      String status = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    String branchCode = appConfig.read("branch_code").toString();
    try {
      final response = await client.get('/GetDocPack', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'key_word': search,
        'branch_code': appConfig.read("branch_code").toString(),
        'from_date': from_date,
        'to_date': to_date,
        'status': status,
      });
      final rawData = json.decode(response.toString());

      if (rawData['error'] != null) {
        String errorMessage = '${rawData['code']}: ${rawData['message']}';
        print(errorMessage);
        throw new Exception('${rawData['code']}: ${rawData['message']}');
      }

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> fetchAllDocpackdetail({String doc_no = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetDocPackDetail', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': doc_no,
      });
      final rawData = json.decode(response.toString());

      if (rawData['success'] != true) {
        String errorMessage = '${rawData['ERROR']}';
        print(errorMessage);
        throw new Exception('${rawData['ERROR']}');
      }

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> fetchBoxList({String doc_no = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetBoxList', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': doc_no,
      });
      final rawData = json.decode(response.toString());

      if (rawData['success'] != true) {
        String errorMessage = '${rawData['ERROR']}';
        print(errorMessage);
        throw new Exception('${rawData['ERROR']}');
      }

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> fetchBoxcartlist({String doc_no = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetBoxCartList', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': doc_no,
      });
      final rawData = json.decode(response.toString());

      if (rawData['success'] != true) {
        String errorMessage = '${rawData['ERROR']}';
        print(errorMessage);
        throw new Exception('${rawData['ERROR']}');
      }

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> fetchProductByScanbarcode(
      String barcode, StoreType storeType) async {
    print(
        "----------------------------------------------------------------------------------00");
    Dio client = Client().init();
    try {
      final response =
          await client.get('v3/api/product/scan/?barcode=$barcode');
      final rawData = json.decode(response.toString());
      print(rawData);
      if (rawData['error'] != null) {
        String errorMessage = '${rawData['code']}: ${rawData['message']}';
        print(errorMessage);
        throw new Exception('${rawData['code']}: ${rawData['message']}');
      }

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }
}
