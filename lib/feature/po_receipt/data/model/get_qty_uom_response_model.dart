// To parse this JSON data, do
//
//     final getQtyUomResponse = getQtyUomResponseFromJson(jsonString);

import 'dart:convert';

GetQtyUomResponse getQtyUomResponseFromJson(String str) =>
    GetQtyUomResponse.fromJson(json.decode(str));

String getQtyUomResponseToJson(GetQtyUomResponse data) =>
    json.encode(data.toJson());

class GetQtyUomResponse {
  GetQtyUomResponse({
    required this.ardGetF55Brcd2QtyUom,
  });

  final ArdGetF55Brcd2QtyUom ardGetF55Brcd2QtyUom;

  factory GetQtyUomResponse.fromJson(Map<String, dynamic> json) =>
      GetQtyUomResponse(
        ardGetF55Brcd2QtyUom:
            ArdGetF55Brcd2QtyUom.fromJson(json["ARD_GET-F55BRCD2_QTY-UOM"]),
      );

  Map<String, dynamic> toJson() => {
        "ARD_GET-F55BRCD2_QTY-UOM": ardGetF55Brcd2QtyUom.toJson(),
      };
}

class ArdGetF55Brcd2QtyUom {
  ArdGetF55Brcd2QtyUom({
    required this.tableId,
    required this.rowset,
    required this.records,
    required this.moreRecords,
  });

  final String tableId;
  final List<QtyUom> rowset;
  final int records;
  final bool moreRecords;

  factory ArdGetF55Brcd2QtyUom.fromJson(Map<String, dynamic> json) =>
      ArdGetF55Brcd2QtyUom(
        tableId: json["tableId"],
        rowset:
            List<QtyUom>.from(json["rowset"].map((x) => QtyUom.fromJson(x))),
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

class QtyUom {
  QtyUom({
    required this.poNumber,
    required this.poType,
    required this.branch,
    required this.itemNumber,
    required this.quantity,
    required this.uom,
  });

  final String poNumber;
  final String poType;
  final String branch;
  final String itemNumber;
  final String quantity;
  final String uom;

  factory QtyUom.fromJson(Map<String, dynamic> json) => QtyUom(
        poNumber: json["PO Number"],
        poType: json["PO Type"],
        branch: json["Branch"],
        itemNumber: json["Item Number"],
        quantity: json["Quantity"],
        uom: json["UOM"],
      );

  Map<String, dynamic> toJson() => {
        "PO Number": poNumber,
        "PO Type": poType,
        "Branch": branch,
        "Item Number": itemNumber,
        "Quantity": quantity,
        "UOM": uom,
      };
}
