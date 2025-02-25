// To parse this JSON data, do
//
//     final getAn8 = getAn8FromJson(jsonString);

import 'dart:convert';

GetAn8 getAn8FromJson(String str) => GetAn8.fromJson(json.decode(str));

String getAn8ToJson(GetAn8 data) => json.encode(data.toJson());

class GetAn8 {
  GetAn8({
    required this.rudGetan8P0092Dr,
  });

  RudGetan8P0092Dr rudGetan8P0092Dr;

  factory GetAn8.fromJson(Map<String, dynamic> json) => GetAn8(
        rudGetan8P0092Dr:
            RudGetan8P0092Dr.fromJson(json["RUD_GETAN8_P0092_DR"]),
      );

  Map<String, dynamic> toJson() => {
        "RUD_GETAN8_P0092_DR": rudGetan8P0092Dr.toJson(),
      };
}

class RudGetan8P0092Dr {
  RudGetan8P0092Dr({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  String tableId;
  List<Rowset> rowset;
  int records;
  bool moreRecords;

  factory RudGetan8P0092Dr.fromJson(Map<String, dynamic> json) =>
      RudGetan8P0092Dr(
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
    required this.addressNumber,
  });

  String addressNumber;

  factory Rowset.fromJson(Map<String, dynamic> json) => Rowset(
        addressNumber: json["Address Number"],
      );

  Map<String, dynamic> toJson() => {
        "Address Number": addressNumber,
      };
}
