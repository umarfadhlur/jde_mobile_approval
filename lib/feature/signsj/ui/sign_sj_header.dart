import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/generatesj/data/model/complete_shipment_header_data.dart';
import 'package:jde_mobile_approval/feature/signsj/cubit/sign_sj_cubit.dart';
import 'package:jde_mobile_approval/feature/signsj/cubit/sign_sj_state.dart';
import 'package:jde_mobile_approval/feature/signsj/data/repository/sign_sj_repository.dart';
import 'package:jde_mobile_approval/feature/signsj/ui/sign_sj_detail.dart';

class SignSJPageHeader extends StatelessWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  final String supir;
  const SignSJPageHeader({
    super.key,
    required this.vehicleNumber,
    required this.shipmentNumber,
    required this.suratJalanNumber,
    required this.supir,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignSJCubit(repository: SignSJRepositoryImpl()),
      child: Builder(
        builder: (context) {
          // Dapatkan context baru yang mewarisi BlocProvider
          return SignSJViewHeader(
            vehicleNumber: vehicleNumber,
            shipmentNumber: shipmentNumber,
            suratJalanNumber: suratJalanNumber,
            supir: supir,
          );
        },
      ),
    );
  }
}

class SignSJViewHeader extends StatefulWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  final String supir;
  const SignSJViewHeader({
    super.key,
    required this.vehicleNumber,
    required this.shipmentNumber,
    required this.suratJalanNumber,
    required this.supir,
  });

  @override
  State<SignSJViewHeader> createState() => _SignSJViewHeaderState();
}

class _SignSJViewHeaderState extends State<SignSJViewHeader> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _sjController = TextEditingController();
  final TextEditingController _supirController = TextEditingController();
  final TextEditingController _penerimaController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  final _isSearching = true;
  Timer? _debounce;

  void _navigateToDetail() {
    String vehicleNumber = widget.vehicleNumber;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignSJPageDetail(vehicleNumber: vehicleNumber),
      ),
    );
  }

  void deliverSJ(BuildContext context) {
    final state = context.read<SignSJCubit>().state;

    if (state is SignSJHeaderSuccess) {
      final shipmentNumber = state
          .shipmentData.shipmentHeader.rowset.first.shipmentNumber
          .toString();

      context.read<SignSJCubit>().updateSJ(
            nomorSJ: widget.suratJalanNumber,
            supir: widget.supir,
            vehicleNo: widget.vehicleNumber,
            shipmentNumber: shipmentNumber,
            penerima: _penerimaController.text,
            deliveryDate: _deliveryDateController.text,
            deliveryTime: _deliveryTimeController.text,
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

  // void _showRecipientDialog(BuildContext parentContext) {
  //   showDialog(
  //     context: parentContext,
  //     barrierDismissible: false, // Dialog tidak bisa ditutup dengan tap di luar
  //     builder: (context) {
  //       return BlocProvider.value(
  //         value: parentContext.read<SignSJCubit>(), // Ambil cubit dari parent
  //         child: Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Header dengan judul dan tombol close
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     const Text(
  //                       "Masukkan Data Penerima",
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () => Navigator.pop(context),
  //                       child: const Icon(Icons.close),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Input Penerima
  //                 const Text(
  //                   "Penerima*",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 TextField(
  //                   controller: _penerimaController,
  //                   decoration: const InputDecoration(
  //                     hintText: "Masukkan nama penerima disini...",
  //                     border: OutlineInputBorder(),
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),

  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const Text(
  //                             "Delivery Date*",
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           TextField(
  //                             controller: _deliveryDateController,
  //                             decoration: const InputDecoration(
  //                               hintText: "mm-dd-yyyy",
  //                               border: OutlineInputBorder(),
  //                               contentPadding: EdgeInsets.symmetric(
  //                                   horizontal: 12, vertical: 8),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const Text(
  //                             "Delivery Time*",
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           TextField(
  //                             controller: _deliveryTimeController,
  //                             decoration: const InputDecoration(
  //                               hintText: "--:--",
  //                               border: OutlineInputBorder(),
  //                               contentPadding: EdgeInsets.symmetric(
  //                                   horizontal: 12, vertical: 8),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),

  //                 // Tombol Aksi
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Text(
  //                         "Batal",
  //                         style: TextStyle(
  //                             color: Colors.red, fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // deliverSJ(parentContext);
  //                         Navigator.pop(context);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: ColorCustom.primaryBlue,
  //                         foregroundColor: Colors.white,
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 20, vertical: 12),
  //                       ),
  //                       child: const Text("Simpan"),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showRecipientDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false, // Dialog tidak bisa ditutup dengan tap di luar
      builder: (context) {
        return BlocProvider.value(
          value: parentContext.read<SignSJCubit>(), // Ambil cubit dari parent
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan judul dan tombol close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Masukkan Data Penerima",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Input Penerima
                  const Text(
                    "Penerima*",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _penerimaController,
                    decoration: const InputDecoration(
                      hintText: "Masukkan nama penerima disini...",
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery Date*",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _deliveryDateController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year}";
                                  _deliveryDateController.text = formattedDate;
                                  _deliveryDateController.text =
                                      "${pickedDate.month.toString().padLeft(2, '0')}${pickedDate.day.toString().padLeft(2, '0')}${pickedDate.year}";
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "mm/dd/yyyy",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery Time*",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _deliveryTimeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  String formattedTime =
                                      "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                  _deliveryTimeController.text = formattedTime;
                                  _deliveryTimeController.text =
                                      "${pickedTime.hour.toString().padLeft(2, '0')}${pickedTime.minute.toString().padLeft(2, '0')}00";
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "--:--",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // deliverSJ(parentContext);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorCustom.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Simpan"),
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

  @override
  void initState() {
    super.initState();
    context.read<SignSJCubit>().fetchShipmentHeaders(widget.vehicleNumber);
    _sjController.text = widget.suratJalanNumber;
    _supirController.text = widget.supir;
    _penerimaController.addListener(updateButtonState);
    _deliveryDateController.addListener(updateButtonState);
    _deliveryTimeController.addListener(updateButtonState);
  }

  void updateButtonState() {
    isButtonEnabled.value = _penerimaController.text.isNotEmpty &&
        _deliveryDateController.text.isNotEmpty &&
        _deliveryTimeController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _vehicleController.dispose();
    _penerimaController.dispose();
    _deliveryDateController.dispose();
    _deliveryTimeController.dispose();
    isButtonEnabled.dispose();
    super.dispose();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: GestureDetector(
                onTap: () {
                  _showRecipientDialog(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorCustom.blueColor, // Warna default
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Data Penerima*",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.person, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _buildSearchResults()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                              deliverSJ(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled
                            ? ColorCustom.primaryBlue
                            : Colors.grey[300],
                        foregroundColor:
                            isEnabled ? Colors.white : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Konfirmasi Pengiriman",
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
        } else if (state is SignSJHeaderSuccess) {
          return _buildShipmentDetails(state.shipmentData);
        } else if (state is SignSJSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(context);
          });
        } else if (state is PopSignSJFailure) {
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
                const SizedBox(height: 4),
                TextField(
                  controller: _supirController,
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
                const SizedBox(height: 16),
                Text(
                  "Vehicle Registration",
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  // widget.vehicleNumber,
                  widget.vehicleNumber.contains('-')
                      ? widget.vehicleNumber.split('-').first
                      : widget.vehicleNumber,
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
