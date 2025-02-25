import 'dart:convert';

import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:http/http.dart' as http;
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_connect_watchlist.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_data_f980051.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_watchlist.dart';

abstract class MenuRepository {
  Future<List<F980051>> getList(Map data);
  Future<List<Watchlist>> getWatchlist(Map data);
  Future<List<AbConnectWatchlistRepeating>> getNewList(Map data);
}

class MenuRepositoryImpl implements MenuRepository {
  @override
  Future<List<F980051>> getList(Map data) async {
    print('jalan');
    var jsonParam = jsonEncode(data);
    print(jsonParam);
    var response = await http.post(Uri.parse(EndPoint.notification),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<F980051> rowset =
          GetDataF980051.fromJson(dataa).ufGetf980051New.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<Watchlist>> getWatchlist(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.watchlist),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<Watchlist> rowset =
          GetWatchlist.fromJson(dataa).abGetWatchList.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<AbConnectWatchlistRepeating>> getNewList(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.newWatchlist),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<AbConnectWatchlistRepeating> rowset =
          GetConnectWatchlist.fromJson(dataa).abConnectWatchlistRepeating;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }
}
