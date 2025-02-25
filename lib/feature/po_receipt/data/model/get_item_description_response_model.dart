// To parse this JSON data, do
//
//     final getItemDescriptionResponse = getItemDescriptionResponseFromJson(jsonString);

import 'dart:convert';

GetItemDescriptionResponse getItemDescriptionResponseFromJson(String str) =>
    GetItemDescriptionResponse.fromJson(json.decode(str));

String getItemDescriptionResponseToJson(GetItemDescriptionResponse data) =>
    json.encode(data.toJson());

class GetItemDescriptionResponse {
  GetItemDescriptionResponse({
    required this.ardGetF4101,
  });

  final ArdGetF4101 ardGetF4101;

  factory GetItemDescriptionResponse.fromJson(Map<String, dynamic> json) =>
      GetItemDescriptionResponse(
        ardGetF4101: ArdGetF4101.fromJson(json["ARD_Get F4101"]),
      );

  Map<String, dynamic> toJson() => {
        "ARD_Get F4101": ardGetF4101.toJson(),
      };
}

class ArdGetF4101 {
  ArdGetF4101({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<ItemDesc> rowset;
  final int records;
  final bool moreRecords;

  factory ArdGetF4101.fromJson(Map<String, dynamic> json) => ArdGetF4101(
        tableId: json["tableId"],
        rowset: List<ItemDesc>.from(
            json["rowset"].map((x) => ItemDesc.fromJson(x))),
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

class ItemDesc {
  ItemDesc({
    required this.description,
    required this.descriptionLine2,
  });

  final String description;
  final String descriptionLine2;

  factory ItemDesc.fromJson(Map<String, dynamic> json) => ItemDesc(
        description: json["Description"],
        descriptionLine2: json["Description Line 2"],
      );

  Map<String, dynamic> toJson() => {
        "Description": description,
        "Description Line 2": descriptionLine2,
      };
}
