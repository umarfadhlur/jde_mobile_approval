import 'package:jde_mobile_approval/feature/generatesj/data/model/get_address.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_header.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_vehicle.dart';

class CompleteShipmentHeaderData {
  final GetVehicle vehicle;
  final GetShipmentHeaderResponse shipmentHeader;
  final GetAddressResponse address;

  CompleteShipmentHeaderData({
    required this.vehicle,
    required this.shipmentHeader,
    required this.address,
  });
}
