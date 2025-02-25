// To parse this JSON data, do
//
//     final getWatchlist = getWatchlistFromJson(jsonString);

import 'dart:convert';

GetWatchlist getWatchlistFromJson(String str) =>
    GetWatchlist.fromJson(json.decode(str));

String getWatchlistToJson(GetWatchlist data) => json.encode(data.toJson());

class GetWatchlist {
  GetWatchlist({
    required this.abGetWatchList,
  });

  final AbGetWatchList abGetWatchList;

  factory GetWatchlist.fromJson(Map<String, dynamic> json) => GetWatchlist(
        abGetWatchList: AbGetWatchList.fromJson(json["AB_GetWatchList"]),
      );

  Map<String, dynamic> toJson() => {
        "AB_GetWatchList": abGetWatchList.toJson(),
      };
}

class AbGetWatchList {
  AbGetWatchList({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<Watchlist> rowset;
  final int records;
  final bool moreRecords;

  factory AbGetWatchList.fromJson(Map<String, dynamic> json) => AbGetWatchList(
        tableId: json["tableId"],
        rowset: List<Watchlist>.from(
            json["rowset"].map((x) => Watchlist.fromJson(x))),
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

class Watchlist {
  Watchlist({
    required this.objectId,
  });

  final String objectId;

  factory Watchlist.fromJson(Map<String, dynamic> json) => Watchlist(
        objectId: json["Object ID"],
      );

  Map<String, dynamic> toJson() => {
        "Object ID": objectId,
      };
}
