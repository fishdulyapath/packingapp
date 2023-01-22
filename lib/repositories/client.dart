import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';

class Client {
  Dio init() {
    final appConfig = GetStorage('AppConfig');
    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());

    String endPointService =
        appConfig.read("hoServiceUrl") ?? AppConfig.serviceApi;

    endPointService +=
        endPointService[endPointService.length - 1] == "/" ? "" : "/";
    endPointService += "PackingServiceAPI/service/packingservice";

    _dio.options.baseUrl = endPointService;

    return _dio;
  }

  Dio initAuth() {
    final appConfig = GetStorage('AppConfig');
    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());

    String endPointService =
        appConfig.read("hoServiceUrl") ?? AppConfig.serviceApi;

    endPointService +=
        endPointService[endPointService.length - 1] == "/" ? "" : "/";
    endPointService += "PackingServiceAuth/";

    _dio.options.baseUrl = endPointService;

    return _dio;
  }
}

class ApiResponse<T> {
  late final bool success;
  late final bool error;
  // ignore: unnecessary_question_mark
  late final dynamic? data;
  late final message;
  late final code;
  final Page? page;

  ApiResponse({
    required this.success,
    required this.data,
    this.error = true,
    this.message = "",
    this.code = 00,
    this.page,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      success: map['success'] ?? false,
      error: map['error'] ?? true,
      data: map['data'],
      page: map['pages'] == null ? Page.empty : Page.fromMap(map['pages']),
    );
  }
}

class Page {
  final int size;
  final int currentPage;
  final int totalRecord;
  final int maxPage;

  const Page({
    required this.size,
    required this.currentPage,
    required this.totalRecord,
    required this.maxPage,
  });

  static const empty =
      Page(size: 0, currentPage: 0, totalRecord: 0, maxPage: 0);

  bool get isEmpty => this == Page.empty;

  bool get isNotEmpty => this == Page.empty;

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
        size: map['size'],
        currentPage: map['page'],
        totalRecord: map['total_record'],
        maxPage: map['max_page']);
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appConfig = GetStorage('AppConfig');

    options.headers['GUID'] = AppConfig.serviceGUID;
    options.headers['provider'] =
        appConfig.read("hoProviderName") ?? AppConfig.provider;
    ;
    options.headers['databaseName'] =
        appConfig.read("hoDatabaseName") ?? AppConfig.databaseName;
    options.headers['configFileName'] = AppConfig.configFileName;

    String authorization = options.extra['Authorization'] ??= '';
    if (authorization.length > 0) {
      options.headers['Authorization'] = authorization;
    }

    super.onRequest(options, handler);
  }
}
