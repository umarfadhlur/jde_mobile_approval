class GetShipmentHeader {
  final int shipmentNumber;
  final String transportMode;
  final String transportModeDesc;
  final int carrierNumber;
  final String carrierNumberDesc;
  final int destinationAddress;
  final String destinationAddressDesc;
  final String promisedDeliveryDate;
  final int promisedDeliveryTime;
  final String actualShipDate;
  final int actualShipTime;
  final int shipmentWeight;
  final String weightUnit;
  final String weightUnitDesc;
  final int scheduledVolume;
  final String volumeUnit;
  final String volumeUnitDesc;

  GetShipmentHeader({
    required this.shipmentNumber,
    required this.transportMode,
    required this.transportModeDesc,
    required this.carrierNumber,
    required this.carrierNumberDesc,
    required this.destinationAddress,
    required this.destinationAddressDesc,
    required this.promisedDeliveryDate,
    required this.promisedDeliveryTime,
    required this.actualShipDate,
    required this.actualShipTime,
    required this.shipmentWeight,
    required this.weightUnit,
    required this.weightUnitDesc,
    required this.scheduledVolume,
    required this.volumeUnit,
    required this.volumeUnitDesc,
  });

  factory GetShipmentHeader.fromJson(Map<String, dynamic> json) {
    return GetShipmentHeader(
      shipmentNumber: json['F4941_SHPN'],
      transportMode: json['F4941_MOT'],
      transportModeDesc: json['F4941_MOT_desc'],
      carrierNumber: json['F4941_CARS'],
      carrierNumberDesc: json['F4941_CARS_desc'],
      destinationAddress: json['F4941_ANCC'],
      destinationAddressDesc: json['F4941_ANCC_desc'],
      promisedDeliveryDate: json['F4941_RSDJ'],
      promisedDeliveryTime: json['F4941_RSDT'],
      actualShipDate: json['F4941_ADDJ'],
      actualShipTime: json['F4941_ADTM'],
      shipmentWeight: json['F4941_WGTS'],
      weightUnit: json['F4941_WTUM'],
      weightUnitDesc: json['F4941_WTUM_desc'],
      scheduledVolume: json['F4941_SCVL'],
      volumeUnit: json['F4941_VLUM'],
      volumeUnitDesc: json['F4941_VLUM_desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F4941_SHPN': shipmentNumber,
      'F4941_MOT': transportMode,
      'F4941_MOT_desc': transportModeDesc,
      'F4941_CARS': carrierNumber,
      'F4941_CARS_desc': carrierNumberDesc,
      'F4941_ANCC': destinationAddress,
      'F4941_ANCC_desc': destinationAddressDesc,
      'F4941_RSDJ': promisedDeliveryDate,
      'F4941_RSDT': promisedDeliveryTime,
      'F4941_ADDJ': actualShipDate,
      'F4941_ADTM': actualShipTime,
      'F4941_WGTS': shipmentWeight,
      'F4941_WTUM': weightUnit,
      'F4941_WTUM_desc': weightUnitDesc,
      'F4941_SCVL': scheduledVolume,
      'F4941_VLUM': volumeUnit,
      'F4941_VLUM_desc': volumeUnitDesc,
    };
  }
}

class GetShipmentHeaderResponse {
  final List<GetShipmentHeader> rowset;

  GetShipmentHeaderResponse({required this.rowset});

  factory GetShipmentHeaderResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> rowsetJson = json['ServiceRequest1']['fs_DATABROWSE_V4941A']
        ['data']['gridData']['rowset'];

    return GetShipmentHeaderResponse(
      rowset: rowsetJson.map((e) => GetShipmentHeader.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rowset': rowset.map((e) => e.toJson()).toList(),
    };
  }
}
