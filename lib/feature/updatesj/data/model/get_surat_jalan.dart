class GetSuratJalanResponse {
  final List<GetSuratJalan> rowset;

  GetSuratJalanResponse({required this.rowset});

  factory GetSuratJalanResponse.fromJson(Map<String, dynamic> json) =>
      GetSuratJalanResponse.fromMap(json);

  factory GetSuratJalanResponse.fromMap(Map<String, dynamic> json) {
    final serviceRequest = json["ServiceRequest1"]?["fs_DATABROWSE_V5549SJ"];
    final gridData = serviceRequest?["data"]?["gridData"];
    final rowset = gridData?["rowset"] as List<dynamic>? ?? [];

    return GetSuratJalanResponse(
      rowset: rowset.map((e) => GetSuratJalan.fromMap(e)).toList(),
    );
  }
}

class GetSuratJalan {
  final String remark;
  final int shipmentNumber;
  final String registrationNumber;
  final int deliveryTime;
  final String? deliveryDate;
  final String? descriptionLine1;
  final String? descriptionLine2;

  GetSuratJalan({
    required this.remark,
    required this.shipmentNumber,
    required this.registrationNumber,
    required this.deliveryTime,
    this.deliveryDate,
    this.descriptionLine1,
    this.descriptionLine2,
  });

  factory GetSuratJalan.fromMap(Map<String, dynamic> json) {
    return GetSuratJalan(
      remark: json["F5549SJ_VRMK"] ?? "",
      shipmentNumber: json["F5549SJ_SHPN"] ?? 0,
      registrationNumber: json["F5549SJ_RLNO"] ?? "",
      deliveryTime: json["F5549SJ_DLTM"] ?? 0,
      deliveryDate: json["F5549SJ_DLDT"], // Bisa null
      descriptionLine1: json["F5549SJ_DSC1"], // Bisa null
      descriptionLine2: json["F5549SJ_DSC2"], // Bisa null
    );
  }
}
