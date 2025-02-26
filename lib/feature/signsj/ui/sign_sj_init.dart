import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/signsj/cubit/sign_sj_cubit.dart';
import 'package:jde_mobile_approval/feature/signsj/cubit/sign_sj_state.dart';
import 'package:jde_mobile_approval/feature/signsj/data/repository/sign_sj_repository.dart';
import 'package:jde_mobile_approval/feature/signsj/ui/sign_sj_header.dart';
import 'package:jde_mobile_approval/feature/updatesj/data/model/get_surat_jalan.dart';

class SignSJPageInit extends StatelessWidget {
  const SignSJPageInit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignSJCubit(repository: SignSJRepositoryImpl()),
      child: const SignSJViewInit(),
    );
  }
}

class SignSJViewInit extends StatefulWidget {
  const SignSJViewInit({super.key});

  @override
  State<SignSJViewInit> createState() => _SignSJViewInitState();
}

class _SignSJViewInitState extends State<SignSJViewInit> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _sjController = TextEditingController();
  final _isSearching = true;
  Timer? _debounce;

  void _navigateToHeader(int selectedIndex) {
    final state = context.read<SignSJCubit>().state;

    if (state is ListSignSJSuccess) {
      final selectedItem = state.suratJalan.rowset[selectedIndex];

      print(selectedItem.registrationNumber);
      print(selectedItem.shipmentNumber);
      print(selectedItem.remark);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignSJPageHeader(
            vehicleNumber: selectedItem.registrationNumber,
            shipmentNumber: selectedItem.shipmentNumber.toString(),
            suratJalanNumber: selectedItem.remark,
            supir: selectedItem.descriptionLine1 ?? '',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<SignSJCubit>().fetchSuratJalan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustom.primaryBlue,
        title: Text(
          "Sign E-Surat Jalan",
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
    return BlocBuilder<SignSJCubit, SignSJState>(
      builder: (context, state) {
        if (!_isSearching) return _buildEmptyState();
        if (state is SignSJLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SignSJFailure) {
          return Center(
            child: Text(
              "Error: ${state.error}",
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          );
        } else if (state is ListSignSJSuccess) {
          return _buildShipmentDetails(state.suratJalan);
        }
        return _buildEmptyState();
      },
    );
  }

  Widget _buildShipmentDetails(GetSuratJalanResponse suratJalan) {
    return ListView.builder(
      itemCount: suratJalan.rowset.length,
      itemBuilder: (context, index) {
        final suratjalan = suratJalan.rowset[index];
        return InkWell(
          onTap: () {
            _navigateToHeader(index);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "No. Surat Jalan",
                    style: GoogleFonts.dmSans(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    suratjalan.remark,
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      color: ColorCustom.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No. Shipment",
                              style: GoogleFonts.dmSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              suratjalan.shipmentNumber.toString(),
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
                              "Vehicle No.",
                              style: GoogleFonts.dmSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              suratjalan.registrationNumber,
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
                              "Supir",
                              style: GoogleFonts.dmSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              suratjalan.descriptionLine1.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "",
                          style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
