import 'package:jde_mobile_approval/feature/generatesj/data/model/get_address.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_detail.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_header.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_vehicle.dart';

class CompleteShipmentData {
  final GetVehicle vehicle;
  final GetShipmentHeaderResponse shipmentHeader;
  final GetAddressResponse address;
  final GetShipmentDetailResponse shipmentDetail;

  CompleteShipmentData({
    required this.vehicle,
    required this.shipmentHeader,
    required this.address,
    required this.shipmentDetail,
  });
}
