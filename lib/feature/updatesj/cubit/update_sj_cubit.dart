import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/repository/update_sj_repository.dart';

import 'update_sj_state.dart';

class UpdateSJCubit extends Cubit<UpdateSJState> {
  final UpdateSJRepository repository;

  UpdateSJCubit({required this.repository}) : super(UpdateSJInitial());

  Future<void> fetchSuratJalan() async {
    emit(UpdateSJLoading());
    try {
      final suratJalan = await repository.fetchSuratJalan();
      if (suratJalan != null) {
        emit(ListUpdateSJSuccess(suratJalan));
      } else {
        emit(const UpdateSJFailure("Gagal mengambil data Surat Jalan"));
      }
    } catch (e) {
      emit(UpdateSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentHeaders(String requestData) async {
    try {
      emit(UpdateSJLoading());

      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(UpdateSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch UpdateSJ Header (GetUpdateSJHeader)
      final shipmentHeader =
          await repository.fetchShipmentHeader(vehicle.shipmentNumber);

      if (shipmentHeader == null) {
        emit(UpdateSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Fetch Address berdasarkan shipment
      final address = await repository
          .fetchAddress(shipmentHeader.rowset.first.destinationAddress);
      if (address == null) {
        emit(UpdateSJFailure("Alamat tidak ditemukan"));
        return;
      }

      // Gabungkan semua data
      final completeData = CompleteShipmentHeaderData(
        vehicle: vehicle,
        shipmentHeader: shipmentHeader,
        address: address,
      );

      emit(UpdateSJHeaderSuccess(completeData));
    } catch (e) {
      emit(UpdateSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentDetails(String requestData) async {
    try {
      emit(UpdateSJLoading());

      // Step 1: Fetch Vehicle
      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(UpdateSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch Shipment Detail
      final shipmentDetail =
          await repository.fetchShipmentDetail(vehicle.shipmentNumber);

      if (shipmentDetail == null) {
        emit(UpdateSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Gabungkan Data
      final completeData = CompleteShipmentDetailData(
        vehicle: vehicle,
        shipmentDetail: shipmentDetail,
      );

      emit(UpdateSJDetailSuccess(completeData));
    } catch (e) {
      emit(UpdateSJFailure(e.toString()));
    }
  }

  Future<void> updateSJ({
    required String nomorSJ,
    required String shipmentNumber,
    required String vehicleNo,
    required String supir,
  }) async {
    emit(UpdateSJLoading());

    try {
      final isSuccess =
          await repository.updateSJ(nomorSJ, shipmentNumber, vehicleNo, supir);

      if (isSuccess == true) {
        emit(UpdateSJSuccess());
      } else {
        emit(const PopUpdateSJFailure("Gagal generate Surat Jalan"));
      }
    } catch (e) {
      emit(PopUpdateSJFailure("Terjadi kesalahan: $e"));
    }
  }
}
