import 'dart:convert';

import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/login/data/model/login_response.dart';
import 'package:jde_mobile_approval/feature/login/data/model/logout_response.dart';

import 'package:http/http.dart' as http;

abstract class LoginRepository {
  Future<LoginResponse> getLogin(Map login);
  Future<LogoutResponse> getLogout(Map data);
}

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<LoginResponse> getLogin(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.login),
        body: jsonParam, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      final userInfo = LoginResponse.fromJson(data);
      print("data user ${userInfo.username.toString()}");
      return userInfo;
    } else {
      throw Exception();
    }
  }

  @override
  Future<LogoutResponse> getLogout(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.logout),
        body: jsonParam, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      final success = LogoutResponse.fromJson(data);
      print("Status: ${success.status}");
      return success;
    } else {
      throw Exception();
    }
  }
}
