import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/cubit/update_sj_cubit.dart';
import 'package:jde_mobile_approval/feature/updatesj/cubit/update_sj_state.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/repository/update_sj_repository.dart';
import 'package:jde_mobile_approval/feature/updatesj/ui/update_sj_detail.dart';

class UpdateSJPageHeader extends StatelessWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  const UpdateSJPageHeader({
    super.key,
    required this.vehicleNumber,
    required this.shipmentNumber,
    required this.suratJalanNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateSJCubit(repository: UpdateSJRepositoryImpl()),
      child: UpdateSJViewHeader(
        vehicleNumber: vehicleNumber,
        shipmentNumber: shipmentNumber,
        suratJalanNumber: suratJalanNumber,
      ),
    );
  }
}

class UpdateSJViewHeader extends StatefulWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  const UpdateSJViewHeader(
      {super.key,
      required this.vehicleNumber,
      required this.shipmentNumber,
      required this.suratJalanNumber});

  @override
  State<UpdateSJViewHeader> createState() => _UpdateSJViewHeaderState();
}

class _UpdateSJViewHeaderState extends State<UpdateSJViewHeader> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _sjController = TextEditingController();
  final TextEditingController _supirController = TextEditingController();
  final _isSearching = true;
  Timer? _debounce;

  void _navigateToDetail() {
    String vehicleNumber = widget.vehicleNumber;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSJPageDetail(vehicleNumber: vehicleNumber),
      ),
    );
  }

  void updateSJ(BuildContext context) {
    final state = context.read<UpdateSJCubit>().state;

    if (state is UpdateSJHeaderSuccess) {
      final shipmentNumber = state
          .shipmentData.shipmentHeader.rowset.first.shipmentNumber
          .toString();

      context.read<UpdateSJCubit>().updateSJ(
            nomorSJ: _sjController.text,
            shipmentNumber: shipmentNumber,
            vehicleNo: widget.vehicleNumber,
            supir: _supirController.text,
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shipment belum tersedia!")),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Success.gif',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),

                // Pesan Sukses
                Text(
                  "Surat Jalan berhasil di-update!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCustom.primaryBlue, // Warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Kembali",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Gagal.gif',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),

                // Pesan Sukses
                Text(
                  "Surat Jalan gagal di-update!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Surat Jalan tidak dapat di-update.\nSilahkan coba lagi!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCustom.primaryBlue, // Warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Kembali",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<UpdateSJCubit>().fetchShipmentHeaders(widget.vehicleNumber);
    _sjController.text = widget.suratJalanNumber;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustom.primaryBlue,
        title: Text(
          "Update E-Surat Jalan",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSearchResults()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: SizedBox(
                width: double.infinity, // Lebar full
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _supirController,
                  builder: (context, value, child) {
                    bool isButtonEnabled = value.text.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              updateSJ(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? ColorCustom.primaryBlue
                            : Colors.grey[300],
                        foregroundColor: isButtonEnabled
                            ? Colors.white
                            : Colors.grey[600], // Warna teks
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Update E-Surat Jalan",
                          style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<UpdateSJCubit, UpdateSJState>(
      builder: (context, state) {
        if (!_isSearching) return _buildEmptyState();
        if (state is UpdateSJLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpdateSJFailure) {
          return Center(
            child: Text(
              "Error: ${state.error}",
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          );
        } else if (state is UpdateSJHeaderSuccess) {
          return _buildShipmentDetails(state.shipmentData);
        } else if (state is UpdateSJSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(context);
          });
        } else if (state is PopUpdateSJFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorDialog(context);
          });
        }
        return _buildEmptyState();
      },
    );
  }

  Widget _buildShipmentDetails(CompleteShipmentHeaderData shipmentData) {
    return ListView.builder(
      itemCount: shipmentData.shipmentHeader.rowset.length,
      itemBuilder: (context, index) {
        final shipment = shipmentData.shipmentHeader.rowset[index];
        final address = shipmentData.address.rowset[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No. Surat Jalan",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _sjController,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.grey.shade400), // Warna border abu-abu
                    ),
                    filled: true,
                    fillColor:
                        Colors.grey.shade200, // Warna latar belakang abu-abu
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Supir",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _supirController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) {
                      return Text(
                        "Untuk mengupdate surat jalan, masukkan nama Supir terlebih dahulu.",
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _supirController,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama supir di sini...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Vehicle Registration",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.vehicleNumber,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipment Number",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.shipmentNumber.toString(),
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ship to Address",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.destinationAddressDesc,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mode of Transport",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.transportModeDesc,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Carrier",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.carrierNumberDesc,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Promised Delivery Date",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatDate(shipment.promisedDeliveryDate),
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Promised Delivery Time",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.promisedDeliveryTime.toString(),
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Actual Ship Date",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatDate(shipment.actualShipDate),
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Actual Ship Time",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.actualShipTime.toString(),
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipment Weight",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${shipment.shipmentWeight} ${shipment.weightUnitDesc}',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Scheduled Volume",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${shipment.scheduledVolume} ${shipment.volumeUnitDesc}',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Address1",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  address.addressLine1,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Address2",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  address.addressLine2,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "",
                        style: GoogleFonts.dmSans(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorCustom.primaryBlue),
                        ),
                        onPressed: () {
                          _navigateToDetail();
                        },
                        child: Text(
                          "Detail",
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_data.png", width: 150),
          const SizedBox(height: 16),
          Text("Data tidak ditemukan!",
              style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700])),
          Text("Masukkan nomor kendaraan\nanda terlebih dahulu.",
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
