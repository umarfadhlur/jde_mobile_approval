import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_address.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_detail.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_shipment_header.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/get_vehicle.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/model/get_surat_jalan.dart';

import '../../../../core/constant/endpoint.dart';

abstract class SignSJRepository {
  Future<GetVehicle?> fetchVehicle(String vehicleNo);
  Future<GetSuratJalanResponse?> fetchSuratJalan();
  Future<GetShipmentHeaderResponse?> fetchShipmentHeader(int shipmentNumber);
  Future<GetAddressResponse?> fetchAddress(int addressNumber);
  Future<GetShipmentDetailResponse?> fetchShipmentDetail(int shipmentNumber);
  Future<bool?> updateSJ(
      String nomorSJ,
      String shipmentNumber,
      String vehicleNo,
      String supir,
      String penerima,
      String deliveryDate,
      String deliveryTime);
}

class SignSJRepositoryImpl implements SignSJRepository {
  @override
  Future<GetVehicle?> fetchVehicle(String vehicleNo) async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
      "No Kendaraan": vehicleNo,
    };
    try {
      var response = await http.post(
        Uri.parse(EndPoint.getVehicle),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var vehicleResponse = GetVehicleResponse.fromJson(data);

        if (vehicleResponse.rowset.isNotEmpty) {
          return vehicleResponse.rowset.first;
        }
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching shipment: $e");
    }
  }

  @override
  Future<GetSuratJalanResponse?> fetchSuratJalan() async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
    };

    try {
      print("Sending request to: ${EndPoint.getSJ} with body: $requestData");
      var response = await http.post(
        Uri.parse(EndPoint.getSJ),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return GetSuratJalanResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception("Error fetching address: $e");
    }
  }

  @override
  Future<GetShipmentHeaderResponse?> fetchShipmentHeader(
      int shipmentNumber) async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
      "Shipment Number": shipmentNumber,
    };
    try {
      var response = await http.post(
        Uri.parse(EndPoint.getShipmentHeader),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return GetShipmentHeaderResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching shipment header: $e");
    }
  }

  @override
  Future<GetAddressResponse?> fetchAddress(int addressNumber) async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
      "Address Number": addressNumber,
    };
    try {
      var response = await http.post(
        Uri.parse(EndPoint.getAddress),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return GetAddressResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching address: $e");
    }
  }

  @override
  Future<GetShipmentDetailResponse?> fetchShipmentDetail(
      int shipmentNumber) async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
      "Shipment Number": shipmentNumber,
    };
    try {
      var response = await http.post(
        Uri.parse(EndPoint.getShipmentDetail),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return GetShipmentDetailResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching shipment detail: $e");
    }
  }

  @override
  Future<bool?> updateSJ(
    String nomorSJ,
    String shipmentNumber,
    String vehicleNo,
    String supir,
    String penerima,
    String deliveryDate,
    String deliveryTime,
  ) async {
    Map<String, dynamic> requestData = {
      "username": "jde",
      "password": "jde",
      "Nomor_Surat_Jalan": nomorSJ,
      "Shipment_Number": shipmentNumber,
      "Vehicle_No": vehicleNo,
      "Supir": supir,
      "Penerima": penerima,
      "Delivery_Date": deliveryDate,
      "Delivery_Time": deliveryTime,
    };
    try {
      var response = await http.post(
        Uri.parse(EndPoint.updateSJ),
        body: jsonEncode(requestData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["jde__status"] == "SUCCESS";
      } else {
        throw Exception("Failed to generate SJ: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
