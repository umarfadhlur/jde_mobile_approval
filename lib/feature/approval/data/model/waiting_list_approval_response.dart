// To parse this JSON data, do
//
//     final getWaitingApprovalListResponse = getWaitingApprovalListResponseFromJson(jsonString);

import 'dart:convert';

GetWaitingApprovalListResponse getWaitingApprovalListResponseFromJson(
        String str) =>
    GetWaitingApprovalListResponse.fromJson(json.decode(str));

String getWaitingApprovalListResponseToJson(
        GetWaitingApprovalListResponse data) =>
    json.encode(data.toJson());

class GetWaitingApprovalListResponse {
  GetWaitingApprovalListResponse({
    required this.getDataF55Orch1,
  });

  final GetDataF55Orch1 getDataF55Orch1;

  factory GetWaitingApprovalListResponse.fromJson(Map<String, dynamic> json) =>
      GetWaitingApprovalListResponse(
        getDataF55Orch1: GetDataF55Orch1.fromJson(json["GetDataF55ORCH1"]),
      );

  Map<String, dynamic> toJson() => {
        "GetDataF55ORCH1": getDataF55Orch1.toJson(),
      };
}

class GetDataF55Orch1 {
  GetDataF55Orch1({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<ApvList> rowset;
  final int records;
  final bool moreRecords;

  factory GetDataF55Orch1.fromJson(Map<String, dynamic> json) =>
      GetDataF55Orch1(
        tableId: json["tableId"],
        rowset:
            List<ApvList>.from(json["rowset"].map((x) => ApvList.fromJson(x))),
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

class ApvList {
  ApvList({
    required this.orderCo,
    required this.orderNumber,
    required this.orTy,
    required this.curCod,
    required this.orderDate,
    required this.origName,
    required this.branch,
    required this.supplierName,
    required this.quantityOrdered,
    required this.noPo,
    required this.personResponsible,
    required this.enterpriseOneEventPoint01,
  });

  final String orderCo;
  final int orderNumber;
  final String orTy;
  final String curCod;
  final DateTime orderDate;
  final String origName;
  final String branch;
  final String supplierName;
  final int quantityOrdered;
  final String noPo;
  final int personResponsible;
  final String enterpriseOneEventPoint01;

  factory ApvList.fromJson(Map<String, dynamic> json) => ApvList(
        orderCo: json["Order Co"],
        orderNumber: json["Order Number"],
        orTy: json["Or Ty"],
        curCod: json["Cur Cod"],
        orderDate: DateTime.parse(json["Order Date"]),
        origName: json["Orig Name"],
        branch: json["Branch"],
        supplierName: json["Supplier Name"],
        quantityOrdered: json["Quantity Ordered"],
        noPo: json["No Po"],
        personResponsible: json["Person Responsible"],
        enterpriseOneEventPoint01: json["EnterpriseOne Event Point 01"],
      );

  Map<String, dynamic> toJson() => {
        "Order Co": orderCo,
        "Order Number": orderNumber,
        "Or Ty": orTy,
        "Cur Cod": curCod,
        "Order Date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "Orig Name": origName,
        "Branch": branch,
        "Supplier Name": supplierName,
        "Quantity Ordered": quantityOrdered,
        "No Po": noPo,
        "Person Responsible": personResponsible,
        "EnterpriseOne Event Point 01": enterpriseOneEventPoint01,
      };
}
