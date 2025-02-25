import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/approval_detail_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/waiting_list_approval_response.dart';

abstract class WaitingListApprovalRepository {
  Future<List<ApvList>> getList(Map<String, dynamic> data);
  Future<List<Detail>> getDetail(Map<String, dynamic> data);
  Future<String> approvePO(Map<String, dynamic> data);
  Future<String> rejectPO(Map<String, dynamic> data);
}

class WaitingListApprovalRepositoryImpl extends WaitingListApprovalRepository {
  @override
  Future<List<ApvList>> getList(Map<String, dynamic> data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(
      Uri.parse(EndPoint.getApvList), // Pastikan ini adalah URI yang valid
      body: jsonParam,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<ApvList> rowset =
          GetWaitingApprovalListResponse.fromJson(dataa).getDataF55Orch1.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception('Failed to load approval list');
    }
  }

  @override
  Future<List<Detail>> getDetail(Map<String, dynamic> data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(
      Uri.parse(EndPoint.getApvDetail), // Pastikan ini adalah URI yang valid
      body: jsonParam,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<Detail> rowset =
          GetApprovalDetailResponse.fromJson(dataa).getDataF55Orch2.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception('Failed to load approval details');
    }
  }

  @override
  Future<String> approvePO(Map<String, dynamic> data) async {
    String statusCode;
    var jsonParam = jsonEncode(data);
    var response = await http.post(
      Uri.parse(EndPoint.approvePO), // Pastikan ini adalah URI yang valid
      body: jsonParam,
      headers: {"Content-Type": "application/json"},
    );
    statusCode = response.statusCode.toString();
    return statusCode;
  }

  @override
  Future<String> rejectPO(Map<String, dynamic> data) async {
    String statusCode;
    var jsonParam = jsonEncode(data);
    var response = await http.post(
      Uri.parse(EndPoint.rejectPO), // Pastikan ini adalah URI yang valid
      body: jsonParam,
      headers: {"Content-Type": "application/json"},
    );
    statusCode = response.statusCode.toString();
    return statusCode;
  }
}
