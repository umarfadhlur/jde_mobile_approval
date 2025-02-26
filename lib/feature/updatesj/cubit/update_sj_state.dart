import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/model/get_surat_jalan.dart';

abstract class UpdateSJState extends Equatable {
  const UpdateSJState();

  @override
  List<Object?> get props => [];
}

class UpdateSJInitial extends UpdateSJState {}

class UpdateSJLoading extends UpdateSJState {}

class UpdateSJSuccess extends UpdateSJState {}

class ListUpdateSJSuccess extends UpdateSJState {
  final GetSuratJalanResponse suratJalan;

  const ListUpdateSJSuccess(this.suratJalan);

  @override
  List<Object?> get props => [suratJalan];
}

class UpdateSJFailure extends UpdateSJState {
  final String error;

  const UpdateSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PopUpdateSJFailure extends UpdateSJState {
  final String error;

  const PopUpdateSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UpdateSJHeaderSuccess extends UpdateSJState {
  final CompleteShipmentHeaderData shipmentData;

  UpdateSJHeaderSuccess(this.shipmentData);
}

class UpdateSJDetailSuccess extends UpdateSJState {
  final CompleteShipmentDetailData shipmentData;

  UpdateSJDetailSuccess(this.shipmentData);
}
