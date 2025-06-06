import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_detail_data.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/repository/update_sj_repository.dart';

import '../cubit/update_sj_cubit.dart';
import '../cubit/update_sj_state.dart';

class UpdateSJPageDetail extends StatelessWidget {
  final String vehicleNumber;

  const UpdateSJPageDetail({Key? key, required this.vehicleNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateSJCubit(repository: UpdateSJRepositoryImpl()),
      child: UpdateSJViewDetail(vehicleNumber: vehicleNumber),
    );
  }
}

class UpdateSJViewDetail extends StatefulWidget {
  final String vehicleNumber;

  const UpdateSJViewDetail({super.key, required this.vehicleNumber});

  @override
  State<UpdateSJViewDetail> createState() => _UpdateSJViewDetailState();
}

class _UpdateSJViewDetailState extends State<UpdateSJViewDetail> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = true;
  Timer? _debounce;

  @override
  void initState() {
    print(widget.vehicleNumber);
    super.initState();
    context.read<UpdateSJCubit>().fetchShipmentDetails(widget.vehicleNumber);
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
          "Detail E-Surat Jalan",
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
        } else if (state is UpdateSJDetailSuccess) {
          return _buildShipmentDetails(state.shipmentData);
        }
        return _buildEmptyState();
      },
    );
  }

  Widget _buildShipmentDetails(CompleteShipmentDetailData shipmentData) {
    return ListView.builder(
      itemCount: shipmentData.shipmentDetail.rowset.length,
      itemBuilder: (context, index) {
        final shipment = shipmentData.shipmentDetail.rowset[index];
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No. Sales Order",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.orderNumber.toString(),
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
                            "Item Number",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.shortItemNumber.toString(),
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
                            "Item Description",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            shipment.shortItemDesc,
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
                            "Qty Ship",
                            style: GoogleFonts.dmSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${shipment.quantityShipped.toString()} ${shipment.unitMeasureDesc}',
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
                            '${shipment.shipmentWeight.floor()} ${shipment.weightUnitDesc}',
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
                            '${shipment.scheduledVolume.floor()} ${shipment.volumeUnitDesc}',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
