// To parse this JSON data, do
//
//     final checkLotResponse = checkLotResponseFromJson(jsonString);

import 'dart:convert';

CheckPoResponse checkLotResponseFromJson(String str) =>
    CheckPoResponse.fromJson(json.decode(str));

String checkLotResponseToJson(CheckPoResponse data) =>
    json.encode(data.toJson());

class CheckPoResponse {
  CheckPoResponse({
    required this.ardF55ScanrCheck,
  });

  final ArdF55ScanrCheck ardF55ScanrCheck;

  factory CheckPoResponse.fromJson(Map<String, dynamic> json) =>
      CheckPoResponse(
        ardF55ScanrCheck: ArdF55ScanrCheck.fromJson(json["ARD_F55SCANR_CHECK"]),
      );

  Map<String, dynamic> toJson() => {
        "ARD_F55SCANR_CHECK": ardF55ScanrCheck.toJson(),
      };
}

class ArdF55ScanrCheck {
  ArdF55ScanrCheck({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<Parent> rowset;
  final int records;
  final bool moreRecords;

  factory ArdF55ScanrCheck.fromJson(Map<String, dynamic> json) =>
      ArdF55ScanrCheck(
        tableId: json["tableId"],
        rowset:
            List<Parent>.from(json["rowset"].map((x) => Parent.fromJson(x))),
        records: json["records"],
        moreRecords: json["moreRecords"],
      );

  Map<String, dynamic> toJson() => {
        "tableId": tableId,
        "rowset": List<dynamic>.from(rowset.map((x) => x.toJson())),
        "records": records,
        "moreRecords": moreRecords,
      };
}

class Parent {
  Parent({
    required this.parentNumber,
  });

  final String parentNumber;

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        parentNumber: json["Parent Number"],
      );

  Map<String, dynamic> toJson() => {
        "Parent Number": parentNumber,
      };
}
