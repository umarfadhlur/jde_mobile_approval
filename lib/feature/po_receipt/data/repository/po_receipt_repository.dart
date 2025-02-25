import 'dart:convert';

import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:http/http.dart' as http;
import 'package:jde_mobile_approval/feature/po_receipt/data/model/check_po_response_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/get_item_description_response_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/get_qty_uom_response_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/po_receipt_response_model.dart';

abstract class PoReceiptRepository {
  Future<PoReceiptResponse> getScanInNumber(Map data);
  Future<String> ccEntry(Map data);
  Future<int> checkLot(Map data);
  Future<List<QtyUom>> getQty(Map data);
  Future<List<QtyUom>> updateItem(Map data);
  Future<List<ItemDesc>> getDesc(Map data);
}

class PoReceiptRepositoryImpl extends PoReceiptRepository {
  @override
  Future<PoReceiptResponse> getScanInNumber(Map data) async {
    var jsonParam = jsonEncode(data);
    print(jsonParam);
    var response = await http.post(Uri.parse(EndPoint.addPO),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    print("status code ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      final scanInNumber = PoReceiptResponse.fromJson(data);
      print(scanInNumber.scanInNumber);
      return scanInNumber;
    } else {
      throw Exception();
    }
  }

  @override
  Future<String> ccEntry(Map data) async {
    String statusCode;
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.addPO),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      statusCode = response.statusCode.toString();
    } else {
      statusCode = response.statusCode.toString();
    }
    return statusCode;
  }

  @override
  Future<int> checkLot(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.checkLot),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    print("status ${response.statusCode}");
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      int parent = CheckPoResponse.fromJson(dataa).ardF55ScanrCheck.records;
      print("equipment $parent");
      return parent;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<QtyUom>> getQty(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.getQty),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<QtyUom> rowset =
          GetQtyUomResponse.fromJson(dataa).ardGetF55Brcd2QtyUom.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<QtyUom>> updateItem(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.updateItem),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<QtyUom> rowset =
          GetQtyUomResponse.fromJson(dataa).ardGetF55Brcd2QtyUom.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<ItemDesc>> getDesc(Map data) async {
    var jsonParam = jsonEncode(data);
    var response = await http.post(Uri.parse(EndPoint.getDesc),
        body: jsonParam, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      List<ItemDesc> rowset =
          GetItemDescriptionResponse.fromJson(dataa).ardGetF4101.rowset;
      print("data $rowset");
      return rowset;
    } else {
      throw Exception();
    }
  }
}
