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
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  void _navigateToDetail() {
    String vehicleNumber = _controller.text; // Ambil teks dari controller

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
      _isSearching = _controller.text.isNotEmpty;
    });
    if (_isSearching) {
      context.read<GenerateSJCubit>().fetchShipmentHeaders(_controller.text);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
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
              controller: _controller,
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
                  "Vehicle Registration",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _controller.text,
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
                        onPressed: () {
                          _navigateToDetail();
                        },
                        child: Text(
                          "Detail",
                          style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
          Text("Masukkan nomor kendaraan\nanda terlebih dahulu",
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
