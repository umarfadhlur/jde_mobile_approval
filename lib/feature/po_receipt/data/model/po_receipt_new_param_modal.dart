// To parse this JSON data, do
//
//     final poReceiptNewParam = poReceiptNewParamFromJson(jsonString);

import 'dart:convert';

PoReceiptNewParam poReceiptNewParamFromJson(String str) =>
    PoReceiptNewParam.fromJson(json.decode(str));

String poReceiptNewParamToJson(PoReceiptNewParam data) =>
    json.encode(data.toJson());

class PoReceiptNewParam {
  PoReceiptNewParam({
    required this.token,
    required this.nomorSuratJalan,
    required this.driver,
    required this.containerId,
    required this.nomorKendaraan,
    required this.gridData,
  });

  final String token;
  final String nomorSuratJalan;
  final String driver;
  final String containerId;
  final String nomorKendaraan;
  final List<GridDatum> gridData;

  factory PoReceiptNewParam.fromJson(Map<String, dynamic> json) =>
      PoReceiptNewParam(
        token: json["token"],
        nomorSuratJalan: json["NomorSuratJalan"],
        driver: json["Driver"],
        containerId: json["Container ID"],
        nomorKendaraan: json["NomorKendaraan"],
        gridData: List<GridDatum>.from(
            json["GridData"].map((x) => GridDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "NomorSuratJalan": nomorSuratJalan,
        "Driver": driver,
        "Container ID": containerId,
        "NomorKendaraan": nomorKendaraan,
        "GridData": List<dynamic>.from(gridData.map((x) => x.toJson())),
      };
}

class GridDatum {
  GridDatum({
    required this.poNumber,
    required this.lotSerialNumber,
    required this.itemNumber,
    required this.quantity,
    required this.uom,
  });

  final String poNumber;
  final String lotSerialNumber;
  final String itemNumber;
  final String quantity;
  final String uom;

  factory GridDatum.fromJson(Map<String, dynamic> json) => GridDatum(
        poNumber: json["PO Number"],
        lotSerialNumber: json["Lot Serial Number"],
        itemNumber: json["Item Number"],
        quantity: json["Quantity"],
        uom: json["UOM"],
      );

  Map<String, dynamic> toJson() => {
        "PO Number": poNumber,
        "Lot Serial Number": lotSerialNumber,
        "Item Number": itemNumber,
        "Quantity": quantity,
        "UOM": uom,
      };
}
