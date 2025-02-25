// To parse this JSON data, do
//
//     final responseWatchlistCountWo = responseWatchlistCountWoFromJson(jsonString);

import 'dart:convert';

ResponseWatchlistCountWo responseWatchlistCountWoFromJson(String str) =>
    ResponseWatchlistCountWo.fromJson(json.decode(str));

String responseWatchlistCountWoToJson(ResponseWatchlistCountWo data) =>
    json.encode(data.toJson());

class ResponseWatchlistCountWo {
  ResponseWatchlistCountWo({
    required this.rudGetan8P0092Dr,
    required this.rudCountwoF4801Dr,
  });

  final RudGetan8P0092Dr rudGetan8P0092Dr;
  final RudCountwoF4801Dr rudCountwoF4801Dr;

  factory ResponseWatchlistCountWo.fromJson(Map<String, dynamic> json) =>
      ResponseWatchlistCountWo(
        rudGetan8P0092Dr:
            RudGetan8P0092Dr.fromJson(json["RUD_GETAN8_P0092_DR"]),
        rudCountwoF4801Dr:
            RudCountwoF4801Dr.fromJson(json["RUD_COUNTWO_F4801_DR"]),
      );

  Map<String, dynamic> toJson() => {
        "RUD_GETAN8_P0092_DR": rudGetan8P0092Dr.toJson(),
        "RUD_COUNTWO_F4801_DR": rudCountwoF4801Dr.toJson(),
      };
}

class RudCountwoF4801Dr {
  RudCountwoF4801Dr({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<RudCountwoF4801DrRowset> rowset;
  final int records;
  final bool moreRecords;

  factory RudCountwoF4801Dr.fromJson(Map<String, dynamic> json) =>
      RudCountwoF4801Dr(
        tableId: json["tableId"],
        rowset: List<RudCountwoF4801DrRowset>.from(
            json["rowset"].map((x) => RudCountwoF4801DrRowset.fromJson(x))),
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

class RudCountwoF4801DrRowset {
  RudCountwoF4801DrRowset({
    required this.countWo,
  });

  final int countWo;

  factory RudCountwoF4801DrRowset.fromJson(Map<String, dynamic> json) =>
      RudCountwoF4801DrRowset(
        countWo: json["Count WO"],
      );

  Map<String, dynamic> toJson() => {
        "Count WO": countWo,
      };
}

class RudGetan8P0092Dr {
  RudGetan8P0092Dr({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<RudGetan8P0092DrRowset> rowset;
  final int records;
  final bool moreRecords;

  factory RudGetan8P0092Dr.fromJson(Map<String, dynamic> json) =>
      RudGetan8P0092Dr(
        tableId: json["tableId"],
        rowset: List<RudGetan8P0092DrRowset>.from(
            json["rowset"].map((x) => RudGetan8P0092DrRowset.fromJson(x))),
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

class RudGetan8P0092DrRowset {
  RudGetan8P0092DrRowset({
    required this.addressNumber,
  });

  final String addressNumber;

  factory RudGetan8P0092DrRowset.fromJson(Map<String, dynamic> json) =>
      RudGetan8P0092DrRowset(
        addressNumber: json["Address Number"],
      );

  Map<String, dynamic> toJson() => {
        "Address Number": addressNumber,
      };
}
