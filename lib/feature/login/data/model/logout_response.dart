// To parse this JSON data, do
//
//     final logoutResponse = logoutResponseFromJson(jsonString);

import 'dart:convert';

LogoutResponse logoutResponseFromJson(String str) =>
    LogoutResponse.fromJson(json.decode(str));

String logoutResponseToJson(LogoutResponse data) => json.encode(data.toJson());

class LogoutResponse {
  LogoutResponse({
    required this.status,
  });

  final String status;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
