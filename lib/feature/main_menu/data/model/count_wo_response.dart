// To parse this JSON data, do
//
//     final responseCountWo = responseCountWoFromJson(jsonString);

import 'dart:convert';

ResponseCountWo responseCountWoFromJson(String str) =>
    ResponseCountWo.fromJson(json.decode(str));

String responseCountWoToJson(ResponseCountWo data) =>
    json.encode(data.toJson());

class ResponseCountWo {
  ResponseCountWo({
    required this.rudCountwopertypeF4801DrRepeating,
  });

  List<RudCountwopertypeF4801DrRepeating> rudCountwopertypeF4801DrRepeating;

  factory ResponseCountWo.fromJson(Map<String, dynamic> json) =>
      ResponseCountWo(
        rudCountwopertypeF4801DrRepeating:
            List<RudCountwopertypeF4801DrRepeating>.from(
                json["RUD_COUNTWOPERTYPE_F4801_DR_Repeating"]
                    .map((x) => RudCountwopertypeF4801DrRepeating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RUD_COUNTWOPERTYPE_F4801_DR_Repeating": List<dynamic>.from(
            rudCountwopertypeF4801DrRepeating.map((x) => x.toJson())),
      };
}

class RudCountwopertypeF4801DrRepeating {
  RudCountwopertypeF4801DrRepeating({
    required this.rudCountwopertypeF4801Dr,
  });

  RudCountwopertypeF4801Dr rudCountwopertypeF4801Dr;

  factory RudCountwopertypeF4801DrRepeating.fromJson(
          Map<String, dynamic> json) =>
      RudCountwopertypeF4801DrRepeating(
        rudCountwopertypeF4801Dr: RudCountwopertypeF4801Dr.fromJson(
            json["RUD_COUNTWOPERTYPE_F4801_DR"]),
      );

  Map<String, dynamic> toJson() => {
        "RUD_COUNTWOPERTYPE_F4801_DR": rudCountwopertypeF4801Dr.toJson(),
      };
}

class RudCountwopertypeF4801Dr {
  RudCountwopertypeF4801Dr({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  String tableId;
  List<Rowset> rowset;
  int records;
  bool moreRecords;

  factory RudCountwopertypeF4801Dr.fromJson(Map<String, dynamic> json) =>
      RudCountwopertypeF4801Dr(
        tableId: json["tableId"],
        rowset:
            List<Rowset>.from(json["rowset"].map((x) => Rowset.fromJson(x))),
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

class Rowset {
  Rowset({
    required this.countWo,
    required this.woType,
  });

  int countWo;
  String woType;

  factory Rowset.fromJson(Map<String, dynamic> json) => Rowset(
        countWo: json["Count WO"],
        woType: json["WO Type"],
      );

  Map<String, dynamic> toJson() => {
        "Count WO": countWo,
        "WO Type": woType,
      };
}
