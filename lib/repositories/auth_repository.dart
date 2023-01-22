import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:mobilepacking/repositories/client.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  refreshauthenticated
}

class AuthRepository {
  Future<void> login() async {
    print('attempting login');
    await Future.delayed(Duration(seconds: 3));
    print('logged in');
    //throw Exception('failed log in');
  }

  Future<AuthenticationToken> signin(String userName, String password) async {
    Dio client = Client().initAuth();

    UserLogin userLogin = new UserLogin(username: userName, password: password);
    try {
      final response = await client.post('/auth/', data: userLogin.toJson());
      final rawData = json.decode(response.toString());
      return AuthenticationToken.fromMap(rawData);
    } on DioError catch (ex) {
      throw new Exception(ex.response.toString());
    }
  }

  Future<User> getUser(AuthenticationToken token) async {
    Dio client = Client().initAuth();
    try {
      final response = await client.get('/user/',
          options:
              Options(extra: {'Authorization': 'Bearer ' + token.accessToken}));
      final rawData = json.decode(response.toString());
      bool isSuccess = rawData['success'] ?? false;
      if (isSuccess == false) {
        throw new Exception("Unauthorize");
      }
      final appConfig = GetStorage("AppConfig");
      print("['branchCode'] " + rawData['data']['branchCode']);
      appConfig.write("branch_code", rawData['data']['branchCode']);

      return User.fromMap(rawData['data']);
    } on DioError catch (ex) {
      throw new Exception(ex.response.toString());
    }
  }
}

class AuthenticationToken {
  AuthenticationToken(
      {required this.accessToken,
      required this.refreshToken,
      required this.expireIn,
      required this.tokenType});

  final String accessToken;
  final String refreshToken;
  final int expireIn;
  final String tokenType;

  factory AuthenticationToken.fromMap(Map<String, dynamic> map) {
    return AuthenticationToken(
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      expireIn: map['expireIn'],
      tokenType: map['tokenType'],
    );
  }

  factory AuthenticationToken.fromString(String str) {
    final rawData = json.decode(str);
    return AuthenticationToken.fromMap(rawData);
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expireIn': expireIn,
      'tokenType': tokenType
    };
  }

  String toJson() => json.encode(toMap());
}

class User {
  User(
      {required this.userCode,
      required this.userName,
      required this.branchCode,
      required this.icWht,
      required this.icShelf});

  final String userCode;
  final String userName;
  final String branchCode;
  final String icWht;
  final String icShelf;

  factory User.empty() {
    return User(
        userCode: "", userName: "", branchCode: "", icWht: "", icShelf: "");
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userCode: map['userCode'],
      userName: map['userName'],
      branchCode: map['branchCode'] ??= '',
      icWht: map['icWht'] ??= '',
      icShelf: map['icShelf'] ??= '',
    );
  }
}

class UserLogin {
  UserLogin({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toMap() {
    return {'username': this.username, 'password': this.password};
  }

  String toJson() => json.encode(toMap());
}
