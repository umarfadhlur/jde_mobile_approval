// To parse this JSON data, do
//
//     final poReceiptParam = poReceiptParamFromJson(jsonString);

import 'dart:convert';

PoReceiptParam poReceiptParamFromJson(String str) =>
    PoReceiptParam.fromJson(json.decode(str));

String poReceiptParamToJson(PoReceiptParam data) => json.encode(data.toJson());

class PoReceiptParam {
  PoReceiptParam({
    required this.token,
    required this.inputs,
  });

  final String token;
  final List<Input> inputs;

  factory PoReceiptParam.fromJson(Map<String, dynamic> json) => PoReceiptParam(
        token: json["token"],
        inputs: List<Input>.from(json["inputs"].map((x) => Input.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "inputs": List<dynamic>.from(inputs.map((x) => x.toJson())),
      };
}

class Input {
  Input({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  factory Input.fromJson(Map<String, dynamic> json) => Input(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
