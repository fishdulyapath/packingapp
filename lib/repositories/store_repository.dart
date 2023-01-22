import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';

import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';

import 'client.dart';

class StoreRepository {
  Future<ApiResponse> savePackingSO(String docNo) async {
    Dio client = Client().init();

    try {
      final response = await client.post(
        'saleorder/updateapprovestatus/',
        data: {"docNo": docNo},
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
      print(errorMessage);
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> savePackingBox(StorePack store) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    print(store.toJson());
    String prov = appConfig.read("hoProviderName") ?? AppConfig.provider;
    String dbn = appConfig.read("hoDatabaseName") ?? AppConfig.databaseName;
    try {
      final response = await client.post(
        '/createBoxPacking?provider_name=' + prov + '&database_name=' + dbn,
        data: store.toJson(),
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
      print(errorMessage);
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> updatePackingBoxCart(StorePack store) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    print(store.toJson());
    String prov = appConfig.read("hoProviderName") ?? AppConfig.provider;
    String dbn = appConfig.read("hoDatabaseName") ?? AppConfig.databaseName;
    try {
      final response = await client.post(
        '/editBoxPackingTemp?provider_name=' + prov + '&database_name=' + dbn,
        data: store.toJson(),
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
      print(errorMessage);
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> savePackingBoxCart(StorePack store) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    print(store.toJson());
    String prov = appConfig.read("hoProviderName") ?? AppConfig.provider;
    String dbn = appConfig.read("hoDatabaseName") ?? AppConfig.databaseName;
    try {
      final response = await client.post(
        '/createBoxPackingTemp?provider_name=' + prov + '&database_name=' + dbn,
        data: store.toJson(),
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
      print(errorMessage);
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> deletePackingBox(String docNo) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/deletePackingBox', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': docNo,
      });
      final rawData = json.decode(response.toString());

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> deletePackingBoxCart(String docNo) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response =
          await client.get('/deletePackingBoxCart', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': docNo,
      });
      final rawData = json.decode(response.toString());

      return ApiResponse.fromMap(rawData);
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> sendPackingBox(
      String docNo, String custCode, String dropPoint) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/sendPackingBox', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': docNo,
        'cust_code': custCode,
        'drop_point': dropPoint,
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

  Future<ApiResponse> fetchDocdetail(String doc_no) async {
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

  Future<ApiResponse> saveWithdraw(Store store) async {
    Dio client = Client().init();
    try {
      final response = await client.post(
        'restapi/takeoutitem',
        data: store.toJson(),
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
      print(errorMessage);
      throw new Exception(errorMessage);
    }
  }

  Future<ApiResponse> fetchSaleSO(String docNo) async {
    Dio client = Client().init();
    // try {
    final response = await client.get('saleorder/$docNo');
    final rawData = json.decode(response.toString());

    bool isError = !rawData['success'];
    if (isError) {
      String errorMessage = '${rawData['code']}: ${rawData['message']}';
      print(errorMessage);
      throw new Exception('${rawData['code']}: ${rawData['message']}');
    }

    return ApiResponse.fromMap(rawData);
    // } catch (ex) {
    //   String errorMessage = ex.toString();
    //   throw new Exception(errorMessage);
    // }
  }
}
