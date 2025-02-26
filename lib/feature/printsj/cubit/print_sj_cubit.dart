import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/printsj/data/repository/print_sj_repository.dart';

import 'print_sj_state.dart';

class PrintSJCubit extends Cubit<PrintSJState> {
  final PrintSJRepository repository;

  PrintSJCubit({required this.repository}) : super(PrintSJInitial());

  Future<void> fetchSuratJalan() async {
    emit(PrintSJLoading());
    try {
      final suratJalan = await repository.fetchSuratJalan();
      if (suratJalan != null) {
        emit(ListPrintSJSuccess(suratJalan));
      } else {
        emit(const PrintSJFailure("Gagal mengambil data Surat Jalan"));
      }
    } catch (e) {
      emit(PrintSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentHeaders(String requestData) async {
    try {
      emit(PrintSJLoading());

      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(PrintSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch PrintSJ Header (GetPrintSJHeader)
      final shipmentHeader =
          await repository.fetchShipmentHeader(vehicle.shipmentNumber);

      if (shipmentHeader == null) {
        emit(PrintSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Fetch Address berdasarkan shipment
      final address = await repository
          .fetchAddress(shipmentHeader.rowset.first.destinationAddress);
      if (address == null) {
        emit(PrintSJFailure("Alamat tidak ditemukan"));
        return;
      }

      // Gabungkan semua data
      final completeData = CompleteShipmentHeaderData(
        vehicle: vehicle,
        shipmentHeader: shipmentHeader,
        address: address,
      );

      emit(PrintSJHeaderSuccess(completeData));
    } catch (e) {
      emit(PrintSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentDetails(String requestData) async {
    try {
      emit(PrintSJLoading());

      // Step 1: Fetch Vehicle
      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(PrintSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch Shipment Detail
      final shipmentDetail =
          await repository.fetchShipmentDetail(vehicle.shipmentNumber);

      if (shipmentDetail == null) {
        emit(PrintSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Gabungkan Data
      final completeData = CompleteShipmentDetailData(
        vehicle: vehicle,
        shipmentDetail: shipmentDetail,
      );

      emit(PrintSJDetailSuccess(completeData));
    } catch (e) {
      emit(PrintSJFailure(e.toString()));
    }
  }

  Future<void> updateSJ({
    required String nomorSJ,
    required String shipmentNumber,
    required String vehicleNo,
    required String supir,
    required String penerima,
    required String deliveryDate,
    required String deliveryTime,
  }) async {
    emit(PrintSJLoading());

    try {
      final isSuccess = await repository.updateSJ(nomorSJ, shipmentNumber,
          vehicleNo, supir, penerima, deliveryDate, deliveryTime);

      if (isSuccess == true) {
        emit(PrintSJSuccess());
      } else {
        emit(const PopPrintSJFailure("Gagal generate Surat Jalan"));
      }
    } catch (e) {
      emit(PopPrintSJFailure("Terjadi kesalahan: $e"));
    }
  }
}
