class GetVehicle {
  final int orderNumber;
  final String orderType;
  final int shipmentNumber;

  GetVehicle({
    required this.orderNumber,
    required this.orderType,
    required this.shipmentNumber,
  });

  factory GetVehicle.fromJson(Map<String, dynamic> json) {
    return GetVehicle(
      orderNumber: json['F49211_DOCO'],
      orderType: json['F49211_DCTO'],
      shipmentNumber: json['F49211_PTNR'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F49211_DOCO': orderNumber,
      'F49211_DCTO': orderType,
      'F49211_PTNR': shipmentNumber,
    };
  }
}

class GetVehicleResponse {
  final List<GetVehicle> rowset;

  GetVehicleResponse({required this.rowset});

  factory GetVehicleResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> rowsetJson = json['ServiceRequest1']['fs_DATABROWSE_V49211A']
        ['data']['gridData']['rowset'];

    return GetVehicleResponse(
      rowset: rowsetJson.map((e) => GetVehicle.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rowset': rowset.map((e) => e.toJson()).toList(),
    };
  }
}
