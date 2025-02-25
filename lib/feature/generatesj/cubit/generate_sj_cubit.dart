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
    print("Fetching shipment details for: $requestData");

    try {
      emit(GenerateSJLoading());

      // Step 1: Fetch Vehicle
      print("Fetching vehicle data...");
      final vehicle = await repository.fetchVehicle(requestData);
      print("Vehicle data fetched: $vehicle");

      if (vehicle == null) {
        print("Error: No shipment data found for vehicle: $requestData");
        emit(GenerateSJFailure(error: "No shipment data found"));
        return;
      }

      // Step 2: Fetch Shipment Detail
      print(
          "Fetching shipment detail for shipmentNumber: ${vehicle.shipmentNumber}");
      final shipmentDetail =
          await repository.fetchShipmentDetail(vehicle.shipmentNumber);
      print("Shipment detail fetched: $shipmentDetail");

      if (shipmentDetail == null) {
        print("Error: Failed to fetch shipment header");
        emit(GenerateSJFailure(error: "Failed to fetch shipment header"));
        return;
      }

      // Step 3: Gabungkan Data
      print("Combining vehicle and shipment detail data...");
      final completeData = CompleteShipmentDetailData(
        vehicle: vehicle,
        shipmentDetail: shipmentDetail,
      );
      print("Complete data: $completeData");

      emit(GenerateSJDetailSuccess(completeData));
    } catch (e, stacktrace) {
      print("Error occurred: $e");
      print("Stacktrace: $stacktrace");
      emit(GenerateSJFailure(error: e.toString()));
    }
  }
}
