import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'client.dart';

class ProductRepository {
  Future<ApiResponse> fetchAllProduct(StoreType storeType,
      {int page = 1, int size = 10, String search = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('v3/api/product',
          queryParameters: {'page': page, 'size': size, 'q': search});
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

  Future<ApiResponse> fetchAllDropoff() async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/Getdropoff', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName
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

  Future<ApiResponse> getBoxScan(String doc_no, String doc_jo) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetBoxScan', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_no': doc_no,
        'doc_jo': doc_jo
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

  Future<ApiResponse> getBoxSend(String doc_no, int status) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/SendDocCar', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'doc_jo': doc_no,
        'status': status
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

  Future<ApiResponse> fetchAllCustomer() async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/GetCustomer', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'key_word': ''
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

  Future<ApiResponse> fetchProductByCode(
      String productCode, StoreType storeType) async {
    Dio client = Client().init();

    try {
      final response = await client.get('v3/api/product/$productCode');
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

  Future<ApiResponse> fetchProductByScanbarcode(
      String barcode, StoreType storeType) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/getProductScan', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'barcode': barcode
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

  Future<ApiResponse> fetchProductByScan(String barcode) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/getProductScan', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'barcode': barcode
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

  Future<ApiResponse> fetchProductByList(String keyword) async {
    Dio client = Client().init();
    final appConfig = GetStorage('AppConfig');
    try {
      final response = await client.get('/getProductSearch', queryParameters: {
        'provider_name': appConfig.read("hoProviderName") ?? AppConfig.provider,
        'database_name':
            appConfig.read("hoDatabaseName") ?? AppConfig.databaseName,
        'keyword': keyword
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
}
