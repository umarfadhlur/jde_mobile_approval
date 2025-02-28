import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/repository/generate_sj_repository.dart';
import 'package:jde_mobile_approval/feature/generatesj/ui/generate_sj_detail.dart';

import '../cubit/generate_sj_cubit.dart';
import '../cubit/generate_sj_state.dart';

class GenerateSJPage extends StatelessWidget {
  const GenerateSJPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenerateSJCubit(repository: GenerateSJRepositoryImpl()),
      child: const GenerateSJView(),
    );
  }
}

class GenerateSJView extends StatefulWidget {
  const GenerateSJView({super.key});

  @override
  State<GenerateSJView> createState() => _GenerateSJViewState();
}

class _GenerateSJViewState extends State<GenerateSJView> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _sjController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  void _navigateToDetail() {
    String vehicleNumber =
        _vehicleController.text; // Ambil teks dari controller

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GenerateSJPageDetail(vehicleNumber: vehicleNumber),
      ),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // _searchData();
    });
  }

  void _searchData() {
    setState(() {
      _isSearching = _vehicleController.text.isNotEmpty;
    });
    if (_isSearching) {
      context
          .read<GenerateSJCubit>()
          .fetchShipmentHeaders(_vehicleController.text);
    }
  }

  void saveSJ(BuildContext context) {
    final state = context.read<GenerateSJCubit>().state;

    if (state is GenerateSJHeaderSuccess) {
      final shipmentNumber = state
          .shipmentData.shipmentHeader.rowset.first.shipmentNumber
          .toString();

      if (_sjController.text.isEmpty || _vehicleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field harus diisi")),
        );
        return;
      }

      context.read<GenerateSJCubit>().generateSJ(
            nomorSJ: _sjController.text,
            shipmentNumber: shipmentNumber,
            vehicleNo: _vehicleController.text,
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
                  "Surat Jalan berhasil dibuat!",
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

  void _showExistDialog(BuildContext context, String shipment) {
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
                  "Shipment Number $shipment Sudah Ada!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Surat Jalan tidak dapat dibuat ulang.\nSilahkan gunakan data berbeda!",
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
                  "Surat Jalan gagal dibuat!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Surat Jalan tidak dapat dibuat.\nSilahkan coba lagi!",
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
          "Generate E-Surat Jalan",
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
            Text("Cari Nomor Kendaraan",
                style: GoogleFonts.dmSans(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              "Untuk generate Surat Jalan, masukkan nomor kendaraan anda di bawah ini.",
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vehicleController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Masukkan Nomor Kendaraan",
                hintStyle: GoogleFonts.dmSans(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: ColorCustom.primaryBlue),
                  onPressed: _searchData,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildSearchResults()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: SizedBox(
                width: double.infinity, // Lebar full
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _sjController,
                  builder: (context, value, child) {
                    bool isButtonEnabled = value.text.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              saveSJ(context);
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
                          "Confirm No. SJ",
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
    return BlocBuilder<GenerateSJCubit, GenerateSJState>(
      builder: (context, state) {
        if (!_isSearching) return _buildEmptyState();
        if (state is GenerateSJLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GenerateSJFailure) {
          return Center(
            child: Text(
              "Error: ${state.error}",
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          );
        } else if (state is GenerateSJHeaderSuccess) {
          return _buildShipmentDetails(state.shipmentData);
        } else if (state is GenerateSJSuccess) {
          // Menjalankan showDialog setelah frame selesai dirender
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(context);
          });
        } else if (state is GenerateSJExists) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showExistDialog(context, state.shipmentNumber);
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
                RichText(
                  text: TextSpan(
                    text: "No. Surat Jalan",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: const [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _sjController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) {
                      return Text(
                        "Untuk generate surat jalan, input No. Surat Jalan",
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
                  controller: _sjController,
                  decoration: InputDecoration(
                    hintText: "Masukkan surat jalan di sini...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),

                const SizedBox(height: 16), // Beri jarak sebelum konten lainnya
                Text(
                  "Vehicle Registration",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _vehicleController.text,
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
