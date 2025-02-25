// To parse this JSON data, do
//
//     final loginParam = loginParamFromJson(jsonString);

import 'dart:convert';

LoginParam loginParamFromJson(String str) =>
    LoginParam.fromJson(json.decode(str));

String loginParamToJson(LoginParam data) => json.encode(data.toJson());

class LoginParam {
  LoginParam({
    required this.username,
    required this.password,
  });

  String username;
  String password;

  factory LoginParam.fromJson(Map<String, dynamic> json) => LoginParam(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
