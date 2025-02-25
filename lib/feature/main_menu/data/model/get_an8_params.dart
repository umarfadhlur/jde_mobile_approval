// To parse this JSON data, do
//
//     final paramsAn8 = paramsAn8FromJson(jsonString);

import 'dart:convert';

ParamsAn8 paramsAn8FromJson(String str) => ParamsAn8.fromJson(json.decode(str));

String paramsAn8ToJson(ParamsAn8 data) => json.encode(data.toJson());

class ParamsAn8 {
  ParamsAn8({
    required this.token,
    required this.inputs,
  });

  String token;
  List<Input> inputs;

  factory ParamsAn8.fromJson(Map<String, dynamic> json) => ParamsAn8(
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

  String name;
  String value;

  factory Input.fromJson(Map<String, dynamic> json) => Input(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
