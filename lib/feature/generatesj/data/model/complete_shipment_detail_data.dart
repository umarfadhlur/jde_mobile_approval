import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_detail.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_vehicle.dart';

class CompleteShipmentDetailData {
  final GetVehicle vehicle;
  final GetShipmentDetailResponse shipmentDetail;

  CompleteShipmentDetailData({
    required this.vehicle,
    required this.shipmentDetail,
  });
}
