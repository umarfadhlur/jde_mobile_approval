import 'package:bloc/bloc.dart';
import '../data/model/complete_shipment_detail_data.dart';
import '../data/model/complete_shipment_header_data.dart';
import '../data/repository/generate_sj_repository.dart';
import 'generate_sj_state.dart';

class GenerateSJCubit extends Cubit<GenerateSJState> {
  final GenerateSJRepository repository;

  GenerateSJCubit({required this.repository}) : super(GenerateSJInitial());

  Future<void> fetchShipmentHeaders(String requestData) async {
    try {
      emit(GenerateSJLoading());

      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(GenerateSJFailure(error: "No shipment data found"));
        return;
      }

      // Ambil seluruh Surat Jalan
      final suratJalan = await repository.fetchSuratJalan();

      if (suratJalan != null && suratJalan.rowset.isNotEmpty) {
        bool isExists = suratJalan.rowset
            .any((element) => element.shipmentNumber == vehicle.shipmentNumber);

        if (isExists) {
          emit(GenerateSJExists(
              error: "Shipment Number ${vehicle.shipmentNumber} sudah ada",
              shipmentNumber: vehicle.shipmentNumber.toString()));
          return;
        }
      }

      // Step 2: Fetch GenerateSJ Header (GetGenerateSJHeader)
      final shipmentHeader =
          await repository.fetchShipmentHeader(vehicle.shipmentNumber);

      if (shipmentHeader == null) {
        emit(GenerateSJFailure(error: "Failed to fetch shipment header"));
        return;
      }

      // Step 3: Fetch Address berdasarkan shipment
      final address = await repository
          .fetchAddress(shipmentHeader.rowset.first.destinationAddress);
      if (address == null) {
        emit(GenerateSJFailure(error: "Alamat tidak ditemukan"));
        return;
      }

      // Gabungkan semua data
      final completeData = CompleteShipmentHeaderData(
        vehicle: vehicle,
        shipmentHeader: shipmentHeader,
        address: address,
      );

      emit(GenerateSJHeaderSuccess(completeData));
    } catch (e) {
      emit(GenerateSJFailure(error: e.toString()));
    }
  }

  Future<void> fetchShipmentDetails(String requestData) async {
    try {
      emit(GenerateSJLoading());

      // Step 1: Fetch Vehicle
      final vehicle = await repository.fetchVehicle(requestData);

      if (vehicle == null) {
        emit(GenerateSJFailure(error: "No shipment data found"));
        return;
      }

      // Step 2: Fetch Shipment Detail
      final shipmentDetail =
          await repository.fetchShipmentDetail(vehicle.shipmentNumber);

      if (shipmentDetail == null) {
        emit(GenerateSJFailure(error: "Failed to fetch shipment header"));
        return;
      }

      // Step 3: Gabungkan Data
      final completeData = CompleteShipmentDetailData(
        vehicle: vehicle,
        shipmentDetail: shipmentDetail,
      );

      emit(GenerateSJDetailSuccess(completeData));
    } catch (e) {
      emit(GenerateSJFailure(error: e.toString()));
    }
  }

  Future<void> generateSJ({
    required String nomorSJ,
    required String shipmentNumber,
    required String vehicleNo,
  }) async {
    emit(GenerateSJLoading());

    try {
      final isSuccess =
          await repository.generateSJ(nomorSJ, shipmentNumber, vehicleNo);

      if (isSuccess == true) {
        emit(GenerateSJSuccess());
      } else {
        emit(GenerateSJFailure(error: "Gagal generate Surat Jalan"));
      }
    } catch (e) {
      emit(GenerateSJFailure(error: "Terjadi kesalahan: $e"));
    }
  }
}
