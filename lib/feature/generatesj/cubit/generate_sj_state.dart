import 'package:equatable/equatable.dart';
import '../data/model/complete_shipment_detail_data.dart';
import '../data/model/complete_shipment_header_data.dart';
import '../data/model/get_shipment_header.dart';
import '../data/model/get_vehicle.dart';

abstract class GenerateSJState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateSJInitial extends GenerateSJState {}

class GenerateSJLoading extends GenerateSJState {}

// class GenerateSJSuccess extends GenerateSJState {
//   final GetVehicle vehicle;
//   final GetShipmentHeaderResponse shipmentHeader;

//   GenerateSJSuccess({required this.vehicle, required this.shipmentHeader});

//   @override
//   List<Object?> get props => [vehicle, shipmentHeader];
// }

class GenerateSJHeaderSuccess extends GenerateSJState {
  final CompleteShipmentHeaderData shipmentData;

  GenerateSJHeaderSuccess(this.shipmentData);
}

class GenerateSJDetailSuccess extends GenerateSJState {
  final CompleteShipmentDetailData shipmentData;

  GenerateSJDetailSuccess(this.shipmentData);
}

class GenerateSJFailure extends GenerateSJState {
  final String error;

  GenerateSJFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
