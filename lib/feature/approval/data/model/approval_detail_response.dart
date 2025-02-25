import 'dart:convert';

GetApprovalDetailResponse getApprovalDetailResponseFromJson(String str) =>
    GetApprovalDetailResponse.fromJson(json.decode(str));

String getApprovalDetailResponseToJson(GetApprovalDetailResponse data) =>
    json.encode(data.toJson());

class GetApprovalDetailResponse {
  GetApprovalDetailResponse({
    required this.getDataF55Orch2,
  });

  final GetDataF55Orch2 getDataF55Orch2;

  factory GetApprovalDetailResponse.fromJson(Map<String, dynamic> json) =>
      GetApprovalDetailResponse(
        getDataF55Orch2: GetDataF55Orch2.fromJson(json["GetDataF55ORCH2"]),
      );

  Map<String, dynamic> toJson() => {
        "GetDataF55ORCH2": getDataF55Orch2.toJson(),
      };
}

class GetDataF55Orch2 {
  GetDataF55Orch2({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<Detail> rowset;
  final int records;
  final bool moreRecords;

  factory GetDataF55Orch2.fromJson(Map<String, dynamic> json) =>
      GetDataF55Orch2(
        tableId: json["tableId"],
        rowset:
            List<Detail>.from(json["rowset"].map((x) => Detail.fromJson(x))),
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

class Detail {
  Detail({
    required this.orderCo,
    required this.orderNumber,
    required this.orTy,
    required this.itemNumber,
    required this.itemDescription,
    required this.quantity,
    required this.uom,
    required this.lineNumber,
    required this.curCod,
    required this.price,
    required this.total,
  });

  final String orderCo;
  final int orderNumber;
  final String orTy;
  final String itemNumber;
  final String itemDescription;
  final int quantity;
  final String uom;
  final int lineNumber;
  final String curCod;
  final double price;
  final double total;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        orderCo: json["Order Co"],
        orderNumber: json["Order Number"],
        orTy: json["Or Ty"],
        itemNumber: json["Item Number"],
        itemDescription: json["Item Description"],
        quantity: json["Quantity"],
        uom: json["UOM"],
        lineNumber: json["Line Number"],
        curCod: json["Cur Cod"],
        price: json["Price"].toDouble(),
        total: json["Total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Order Co": orderCo,
        "Order Number": orderNumber,
        "Or Ty": orTy,
        "Item Number": itemNumber,
        "Item Description": itemDescription,
        "Quantity": quantity,
        "UOM": uom,
        "Line Number": lineNumber,
        "Cur Cod": curCod,
        "Price": price,
        "Total": total,
      };
}
