import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/signsj/data/repository/sign_sj_repository.dart';

import 'sign_sj_state.dart';

class SignSJCubit extends Cubit<SignSJState> {
  final SignSJRepository repository;

  SignSJCubit({required this.repository}) : super(SignSJInitial());

  Future<void> fetchSuratJalan() async {
    emit(SignSJLoading());
    try {
      final suratJalan = await repository.fetchSuratJalan();
      if (suratJalan != null) {
        emit(ListSignSJSuccess(suratJalan));
      } else {
        emit(const SignSJFailure("Gagal mengambil data Surat Jalan"));
      }
    } catch (e) {
      emit(SignSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentHeaders(String requestData) async {
    try {
      emit(SignSJLoading());

      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(SignSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch SignSJ Header (GetSignSJHeader)
      final shipmentHeader =
          await repository.fetchShipmentHeader(vehicle.shipmentNumber);

      if (shipmentHeader == null) {
        emit(SignSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Fetch Address berdasarkan shipment
      final address = await repository
          .fetchAddress(shipmentHeader.rowset.first.destinationAddress);
      if (address == null) {
        emit(SignSJFailure("Alamat tidak ditemukan"));
        return;
      }

      // Gabungkan semua data
      final completeData = CompleteShipmentHeaderData(
        vehicle: vehicle,
        shipmentHeader: shipmentHeader,
        address: address,
      );

      emit(SignSJHeaderSuccess(completeData));
    } catch (e) {
      emit(SignSJFailure(e.toString()));
    }
  }

  Future<void> fetchShipmentDetails(String requestData) async {
    try {
      emit(SignSJLoading());

      // Step 1: Fetch Vehicle
      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(SignSJFailure("No shipment data found"));
        return;
      }

      // Step 2: Fetch Shipment Detail
      final shipmentDetail =
          await repository.fetchShipmentDetail(vehicle.shipmentNumber);

      if (shipmentDetail == null) {
        emit(SignSJFailure("Failed to fetch shipment header"));
        return;
      }

      // Step 3: Gabungkan Data
      final completeData = CompleteShipmentDetailData(
        vehicle: vehicle,
        shipmentDetail: shipmentDetail,
      );

      emit(SignSJDetailSuccess(completeData));
    } catch (e) {
      emit(SignSJFailure(e.toString()));
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
    emit(SignSJLoading());

    try {
      final isSuccess = await repository.updateSJ(nomorSJ, shipmentNumber,
          vehicleNo, supir, penerima, deliveryDate, deliveryTime);

      if (isSuccess == true) {
        emit(SignSJSuccess());
      } else {
        emit(const PopSignSJFailure("Gagal generate Surat Jalan"));
      }
    } catch (e) {
      emit(PopSignSJFailure("Terjadi kesalahan: $e"));
    }
  }
}
