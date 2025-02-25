// To parse this JSON data, do
//
//     final getDataF980051 = getDataF980051FromJson(jsonString);

import 'dart:convert';

GetDataF980051 getDataF980051FromJson(String str) =>
    GetDataF980051.fromJson(json.decode(str));

String getDataF980051ToJson(GetDataF980051 data) => json.encode(data.toJson());

class GetDataF980051 {
  GetDataF980051({
    required this.ufGetf980051New,
  });

  final UfGetf980051New ufGetf980051New;

  factory GetDataF980051.fromJson(Map<String, dynamic> json) => GetDataF980051(
        ufGetf980051New: UfGetf980051New.fromJson(json["UF_GETF980051NEW"]),
      );

  Map<String, dynamic> toJson() => {
        "UF_GETF980051NEW": ufGetf980051New.toJson(),
      };
}

class UfGetf980051New {
  UfGetf980051New({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<F980051> rowset;
  final int records;
  final bool moreRecords;

  factory UfGetf980051New.fromJson(Map<String, dynamic> json) =>
      UfGetf980051New(
        tableId: json["tableId"],
        rowset:
            List<F980051>.from(json["rowset"].map((x) => F980051.fromJson(x))),
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

class F980051 {
  F980051({
    required this.notificationLastNotifiedUTime,
    required this.repositoryBlob,
  });

  final String notificationLastNotifiedUTime;
  final String repositoryBlob;

  factory F980051.fromJson(Map<String, dynamic> json) => F980051(
        notificationLastNotifiedUTime: json["Notification Last Notified UTime"],
        repositoryBlob: json["Repository BLOB"],
      );

  Map<String, dynamic> toJson() => {
        "Notification Last Notified UTime": notificationLastNotifiedUTime,
        "Repository BLOB": repositoryBlob,
      };
}
