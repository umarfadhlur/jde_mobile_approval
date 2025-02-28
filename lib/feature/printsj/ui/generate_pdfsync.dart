import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';
import 'package:jde_mobile_approval/feature/printsj/cubit/print_sj_cubit.dart';
import 'package:jde_mobile_approval/feature/printsj/cubit/print_sj_state.dart';
import 'package:jde_mobile_approval/feature/printsj/data/model/complete_shipment_data.dart';
import 'package:jde_mobile_approval/feature/printsj/data/repository/print_sj_repository.dart';
import 'package:jde_mobile_approval/feature/printsj/ui/generate_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFSyncPage extends StatelessWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  final String supir;

  const PDFSyncPage(
      {super.key,
      required this.vehicleNumber,
      required this.shipmentNumber,
      required this.suratJalanNumber,
      required this.supir});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrintSJCubit(repository: PrintSJRepositoryImpl()),
      child: PDFSyncView(
        vehicleNumber: vehicleNumber,
        shipmentNumber: shipmentNumber,
        suratJalanNumber: suratJalanNumber,
        supir: supir,
      ),
    );
  }
}

class PDFSyncView extends StatefulWidget {
  final String vehicleNumber;
  final String shipmentNumber;
  final String suratJalanNumber;
  final String supir;

  const PDFSyncView(
      {super.key,
      required this.vehicleNumber,
      required this.shipmentNumber,
      required this.suratJalanNumber,
      required this.supir});

  @override
  State<PDFSyncView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFSyncView> {
  Uint8List? pdfBytes;
  Uint8List? signature;
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    _generatePDF();
  }

  void _onSigned(Uint8List data) {
    setState(() {
      signature = data;
    });
  }

  Future<void> _generatePDF() async {
    final cubit = context.read<PrintSJCubit>();
    await cubit.fetchCompleteShipmentData(widget.vehicleNumber);

    final state = cubit.state;
    if (state is PrintSJCompleteSuccess) {
      final pdfData = await generatePDF(state.data);
      setState(() {
        pdfBytes = pdfData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustom.primaryBlue,
        title: Text(
          "Print E-Surat Jalan",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: pdfBytes == null
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.memory(pdfBytes!),
      // : Column(
      //     children: [
      //       SfPdfViewer.memory(pdfBytes!),
      //       Expanded(
      //           child: SignaturePad(
      //         controller: _signatureController,
      //         onSigned: _onSigned,
      //       )),
      //       ElevatedButton(
      //         onPressed: signature != null
      //             ? () => Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => PDFPage(
      //                       pdfBytes: pdfBytes!,
      //                       signature: signature!,
      //                     ),
      //                   ),
      //                 )
      //             : null,
      //         child: const Text("Lanjutkan"),
      //       ),
      //     ],
      //   ),
    );
  }

  Future<Uint8List> generatePDF(CompleteShipmentData data) async {
    final pdf = pw.Document();
    final logo = await rootBundle.load('assets/images/logoDover.png');
    final logoImage = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return List.generate(data.shipmentHeader.rowset.length, (index) {
            final shipment = data.shipmentHeader.rowset[index];
            final address = data.address.rowset[index];

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Image(logoImage, width: 100),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'PT. DOVER CHEMICAL',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            pw.Text(
                                'Jalan Raya Merak Km 117 Kelurahan Gerem, Kecamatan Grogol'),
                            pw.Text('Kodya Cilegon 42438, Banten, Indonesia'),
                            pw.Text('Tel: +62-21-2952 7180'),
                            pw.Text('Fax: +62-21-2952 7183'),
                          ],
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('SURAT JALAN',
                              style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('Shipment No: ${widget.suratJalanNumber}',
                              style: const pw.TextStyle(color: PdfColors.blue)),
                        ],
                      ),
                    ),
                  ],
                ),
                // Informasi Kendaraan dan Pengiriman
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Vehicle Registration",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  // widget.vehicleNumber,
                                  widget.vehicleNumber.contains('-')
                                      ? widget.vehicleNumber.split('-').first
                                      : widget.vehicleNumber,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Vehicle No.",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  // widget.vehicleNumber,
                                  widget.vehicleNumber.contains('-')
                                      ? widget.vehicleNumber.split('-').first
                                      : widget.vehicleNumber,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Supir",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  widget.supir,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Carrier",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  shipment.carrierNumberDesc,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Actual Ship Date",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  shipment.actualShipDate,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Actual Ship Time",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  shipment.actualShipTime.toString(),
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Address1",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  address.addressLine1,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Ship to Address",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  shipment.destinationAddressDesc,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(""),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Address2",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  address.addressLine2,
                                ),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),

                // Tabel Detail Pengiriman
                pw.Table.fromTextArray(
                  headers: [
                    'No. Sales Order',
                    'Item Number',
                    'Item Description',
                    'Qty Ship',
                    'Ship Weight',
                    'Ship Volume',
                  ],
                  data: data.shipmentDetail.rowset
                      .map((item) => [
                            item.orderNumber,
                            item.shortItemNumber,
                            item.shortItemDesc,
                            '${item.quantityShipped} ${item.unitMeasureDesc}',
                            '${item.shipmentWeight.floor()} ${item.weightUnitDesc}',
                            '${shipment.scheduledVolume.floor()} ${shipment.volumeUnitDesc}',
                          ])
                      .toList(),
                ),

                pw.SizedBox(height: 20),

                // Tanda Tangan
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(''),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Tanggal, __________________',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.Text('Penerima',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 40),
                        pw.Text('(--------------------)'),
                      ],
                    ),
                  ],
                ),

                // Tambahkan halaman baru untuk shipment berikutnya
                if (index < data.shipmentHeader.rowset.length - 1)
                  pw.SizedBox(height: 30),
              ],
            );
          });
        },
      ),
    );

    return pdf.save();
  }
}

// class SignaturePad extends StatelessWidget {
//   final Function(Uint8List) onSigned;
//   final SignatureController controller;

//   const SignaturePad({
//     super.key,
//     required this.onSigned,
//     required this.controller,
//   });

//   Future<void> _handleOnDrawEnd() async {
//   final image = await _signatureController.toImage();
//   final bytes = await image?.toByteData(format: ImageByteFormat.png);
//   if (bytes != null) {
//     onSigned(bytes.buffer.asUint8List());
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     controller.onDrawEnd = _handleOnDrawEnd;

//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Signature(
//         controller: controller,
//         backgroundColor: Colors.white,
//         width: 3.0,
//       ),
//     );
//   }
// }
