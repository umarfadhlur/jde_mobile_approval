class GetShipmentDetailResponse {
  final List<ShipmentDetail> rowset;

  GetShipmentDetailResponse({required this.rowset});

  factory GetShipmentDetailResponse.fromJson(Map<String, dynamic> json) {
    final rowset = (json['ServiceRequest1']['fs_DATABROWSE_V4942A']['data']
            ['gridData']['rowset'] as List)
        .map((e) => ShipmentDetail.fromJson(e))
        .toList();
    return GetShipmentDetailResponse(rowset: rowset);
  }
}

class ShipmentDetail {
  final int orderNumber;
  final String orderType;
  final double shipmentWeight;
  final String weightUnit;
  final String weightUnitDesc;
  final int shortItemNumber;
  final String shortItemDesc;
  final int quantityShipped;
  final String unitMeasure;
  final String unitMeasureDesc;
  final double scheduledVolume;
  final String volumeUnit;
  final String volumeUnitDesc;

  ShipmentDetail({
    required this.orderNumber,
    required this.orderType,
    required this.shipmentWeight,
    required this.weightUnit,
    required this.weightUnitDesc,
    required this.shortItemNumber,
    required this.shortItemDesc,
    required this.quantityShipped,
    required this.unitMeasure,
    required this.unitMeasureDesc,
    required this.scheduledVolume,
    required this.volumeUnit,
    required this.volumeUnitDesc,
  });

  factory ShipmentDetail.fromJson(Map<String, dynamic> json) {
    return ShipmentDetail(
      orderNumber: json['F4942_DOCO'],
      orderType: json['F4942_DCTO'],
      shipmentWeight: (json['F4942_WGTS'] as num).toDouble(),
      weightUnit: json['F4942_WTUM'],
      weightUnitDesc: json['F4942_WTUM_desc'],
      shortItemNumber: json['F4942_ITM'],
      shortItemDesc: json['F4942_ITM_desc'],
      quantityShipped: json['F4942_SOQS'],
      unitMeasure: json['F4942_UOM'],
      unitMeasureDesc: json['F4942_UOM_desc'],
      scheduledVolume: (json['F4942_SCVL'] as num).toDouble(),
      volumeUnit: json['F4942_VLUM'],
      volumeUnitDesc: json['F4942_VLUM_desc'],
    );
  }
}
