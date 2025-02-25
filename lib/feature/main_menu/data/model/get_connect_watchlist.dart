// To parse this JSON data, do
//
//     final getConnectWatchlist = getConnectWatchlistFromJson(jsonString);

import 'dart:convert';

GetConnectWatchlist getConnectWatchlistFromJson(String str) =>
    GetConnectWatchlist.fromJson(json.decode(str));

String getConnectWatchlistToJson(GetConnectWatchlist data) =>
    json.encode(data.toJson());

class GetConnectWatchlist {
  GetConnectWatchlist({
    required this.abConnectWatchlistRepeating,
  });

  final List<AbConnectWatchlistRepeating> abConnectWatchlistRepeating;

  factory GetConnectWatchlist.fromJson(Map<String, dynamic> json) =>
      GetConnectWatchlist(
        abConnectWatchlistRepeating: List<AbConnectWatchlistRepeating>.from(
            json["AB_Connect_Watchlist_Repeating"]
                .map((x) => AbConnectWatchlistRepeating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AB_Connect_Watchlist_Repeating": List<dynamic>.from(
            abConnectWatchlistRepeating.map((x) => x.toJson())),
      };
}

class AbConnectWatchlistRepeating {
  AbConnectWatchlistRepeating({
    required this.rowcountRecords,
    required this.name,
    required this.criticalThreshold,
    required this.abConnectWatchlist,
  });

  final int rowcountRecords;
  final String name;
  final String criticalThreshold;
  final AbConnectWatchlist abConnectWatchlist;

  factory AbConnectWatchlistRepeating.fromJson(Map<String, dynamic> json) =>
      AbConnectWatchlistRepeating(
        rowcountRecords: json["rowcount.records"],
        name: json["name"],
        criticalThreshold: json["criticalThreshold"],
        abConnectWatchlist:
            AbConnectWatchlist.fromJson(json["AB_Connect_Watchlist"]),
      );

  Map<String, dynamic> toJson() => {
        "rowcount.records": rowcountRecords,
        "name": name,
        "criticalThreshold": criticalThreshold,
        "AB_Connect_Watchlist": abConnectWatchlist.toJson(),
      };
}

class AbConnectWatchlist {
  AbConnectWatchlist({
    required this.rowcountRecords,
    required this.name,
    required this.criticalThreshold,
  });

  final int rowcountRecords;
  final String name;
  final int criticalThreshold;

  factory AbConnectWatchlist.fromJson(Map<String, dynamic> json) =>
      AbConnectWatchlist(
        rowcountRecords: json["rowcount.records"],
        name: json["name"],
        criticalThreshold: json["criticalThreshold"],
      );

  Map<String, dynamic> toJson() => {
        "rowcount.records": rowcountRecords,
        "name": name,
        "criticalThreshold": criticalThreshold,
      };
}
