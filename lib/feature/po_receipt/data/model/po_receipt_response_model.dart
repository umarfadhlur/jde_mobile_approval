// To parse this JSON data, do
//
//     final poReceiptResponse = poReceiptResponseFromJson(jsonString);

import 'dart:convert';

PoReceiptResponse poReceiptResponseFromJson(String str) =>
    PoReceiptResponse.fromJson(json.decode(str));

String poReceiptResponseToJson(PoReceiptResponse data) =>
    json.encode(data.toJson());

class PoReceiptResponse {
  PoReceiptResponse({
    required this.scanInNumber,
  });

  final String scanInNumber;

  factory PoReceiptResponse.fromJson(Map<String, dynamic> json) =>
      PoReceiptResponse(
        scanInNumber: json["Scan In Number"],
      );

  Map<String, dynamic> toJson() => {
        "Scan In Number": scanInNumber,
      };
}
