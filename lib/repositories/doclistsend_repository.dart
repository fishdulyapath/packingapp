import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';

import 'client.dart';

class DoclistSendRepository {
  Future<ApiResponse> fetchAllDoclistSend(
      {String search = "",
      String from_date = "",
      String to_date = "",
      String branch_code = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    String branchCode = appConfig.read("branch_code").toString();
    try {
      final response = await client.get('/GetDocSend', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'key_word': search,
        'branch_code': appConfig.read("branch_code").toString(),
        'from_date': from_date,
        'to_date': to_date
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

  Future<ApiResponse> fetchAllDocSenddetail({String doc_no = ""}) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetDocSendDetail', queryParameters: {
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

  Future<ApiResponse> sendBox(
      String docno, String docbo, String Imagefile) async {
    final appConfig = GetStorage('AppConfig');
    print(
        "----------------------------------------------------------------------------------00");
    Dio client = Client().init();
    try {
      final response = await client.post(
        '/sendDocBo',
        queryParameters: {
          'provider_name':
              appConfig.read("hoProviderName") ?? AppConfig.provider,
          'database_name':
              appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        },
        data: {"doc_no": docno, "doc_bo": docbo, "image_file": Imagefile},
      );
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
