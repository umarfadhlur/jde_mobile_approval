// To parse this JSON data, do
//
//     final logoutParam = logoutParamFromJson(jsonString);

import 'dart:convert';

LogoutParam logoutParamFromJson(String str) =>
    LogoutParam.fromJson(json.decode(str));

String logoutParamToJson(LogoutParam data) => json.encode(data.toJson());

class LogoutParam {
  LogoutParam({
    required this.token,
  });

  final String token;

  factory LogoutParam.fromJson(Map<String, dynamic> json) => LogoutParam(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
