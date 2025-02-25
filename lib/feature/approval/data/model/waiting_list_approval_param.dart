// To parse this JSON data, do
//
//     final getWaitingApprovalListParam = getWaitingApprovalListParamFromJson(jsonString);

import 'dart:convert';

GetWaitingApprovalListParam getWaitingApprovalListParamFromJson(String str) =>
    GetWaitingApprovalListParam.fromJson(json.decode(str));

String getWaitingApprovalListParamToJson(GetWaitingApprovalListParam data) =>
    json.encode(data.toJson());

class GetWaitingApprovalListParam {
  GetWaitingApprovalListParam({
    required this.token,
    required this.inputs,
  });

  final String token;
  final List<Input> inputs;

  factory GetWaitingApprovalListParam.fromJson(Map<String, dynamic> json) =>
      GetWaitingApprovalListParam(
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
