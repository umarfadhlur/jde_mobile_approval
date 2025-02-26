import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/printsj/data/model/complete_shipment_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/model/get_surat_jalan.dart';

abstract class PrintSJState extends Equatable {
  const PrintSJState();

  @override
  List<Object?> get props => [];
}

class PrintSJInitial extends PrintSJState {}

class PrintSJLoading extends PrintSJState {}

class PrintSJSuccess extends PrintSJState {}

class ListPrintSJSuccess extends PrintSJState {
  final GetSuratJalanResponse suratJalan;

  const ListPrintSJSuccess(this.suratJalan);

  @override
  List<Object?> get props => [suratJalan];
}

class PrintSJCompleteSuccess extends PrintSJState {
  final CompleteShipmentData data;

  const PrintSJCompleteSuccess(this.data);
  
  @override
  List<Object?> get props => [data];
}

class PrintSJFailure extends PrintSJState {
  final String error;

  const PrintSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PopPrintSJFailure extends PrintSJState {
  final String error;

  const PopPrintSJFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PrintSJHeaderSuccess extends PrintSJState {
  final CompleteShipmentHeaderData shipmentData;

  PrintSJHeaderSuccess(this.shipmentData);
}

class PrintSJDetailSuccess extends PrintSJState {
  final CompleteShipmentDetailData shipmentData;

  PrintSJDetailSuccess(this.shipmentData);
}
