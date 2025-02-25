// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.username,
    required this.environment,
    required this.role,
    required this.jasserver,
    required this.userInfo,
  });

  String username;
  String environment;
  String role;
  String jasserver;
  UserInfo userInfo;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        username: json["username"],
        environment: json["environment"],
        role: json["role"],
        jasserver: json["jasserver"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "environment": environment,
        "role": role,
        "jasserver": jasserver,
        "userInfo": userInfo.toJson(),
      };
}

class UserInfo {
  UserInfo({
    required this.token,
    required this.langPref,
    required this.locale,
    required this.dateFormat,
    required this.dateSeperator,
    required this.simpleDateFormat,
    required this.decimalFormat,
    required this.addressNumber,
    required this.alphaName,
    required this.appsRelease,
    required this.country,
    required this.username,
  });

  String token;
  String langPref;
  String locale;
  String dateFormat;
  String dateSeperator;
  String simpleDateFormat;
  String decimalFormat;
  int addressNumber;
  String alphaName;
  String appsRelease;
  String country;
  String username;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        token: json["token"],
        langPref: json["langPref"],
        locale: json["locale"],
        dateFormat: json["dateFormat"],
        dateSeperator: json["dateSeperator"],
        simpleDateFormat: json["simpleDateFormat"],
        decimalFormat: json["decimalFormat"],
        addressNumber: json["addressNumber"],
        alphaName: json["alphaName"],
        appsRelease: json["appsRelease"],
        country: json["country"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "langPref": langPref,
        "locale": locale,
        "dateFormat": dateFormat,
        "dateSeperator": dateSeperator,
        "simpleDateFormat": simpleDateFormat,
        "decimalFormat": decimalFormat,
        "addressNumber": addressNumber,
        "alphaName": alphaName,
        "appsRelease": appsRelease,
        "country": country,
        "username": username,
      };
}
