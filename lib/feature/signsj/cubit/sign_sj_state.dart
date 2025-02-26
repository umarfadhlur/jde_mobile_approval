import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/model/get_surat_jalan.dart';

abstract class SignSJState extends Equatable {
  const SignSJState();

  @override
  List<Object?> get props => [];
}

class SignSJInitial extends SignSJState {}

class SignSJLoading extends SignSJState {}

class SignSJSuccess extends SignSJState {}

class ListSignSJSuccess extends SignSJState {
  final GetSuratJalanResponse suratJalan;

  const ListSignSJSuccess(this.suratJalan);

  @override
  List<Object?> get props => [suratJalan];
}

class SignSJFailure extends SignSJState {
  final String error;

  const SignSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PopSignSJFailure extends SignSJState {
  final String error;

  const PopSignSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class SignSJHeaderSuccess extends SignSJState {
  final CompleteShipmentHeaderData shipmentData;

  SignSJHeaderSuccess(this.shipmentData);
}

class SignSJDetailSuccess extends SignSJState {
  final CompleteShipmentDetailData shipmentData;

  SignSJDetailSuccess(this.shipmentData);
}
