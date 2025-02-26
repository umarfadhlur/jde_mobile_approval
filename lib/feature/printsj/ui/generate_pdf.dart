import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class PDFPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview PDF")),
      body: PdfPreview(
        build: (format) =>
            generatePDF(), // Fungsi generatePDF akan membuat dokumen
      ),
    );
  }

  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    final logo = await rootBundle.load('assets/images/logoOpusB.png');
    final logoImage = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(logoImage, width: 100),
                      pw.Text('PT. DOVER CHEMICAL',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Gedung Blugreen-Boutique Office...'),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('SURAT JALAN',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Shipment No: SHPN',
                          style: pw.TextStyle(color: PdfColors.blue)),
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Vehicle Registration: RLNO  |  Vehicle No: RLNO'),
                    pw.Text(
                        'Actual Ship Date: ADDJ  |  Actual Ship Time: ADTM'),
                    pw.Text('Ship to Address: ANCC'),
                    pw.Text('Supir: Umar  |  Carrier: CARS'),
                    pw.Text('Address1: HDN_GET_ADDRESS {ANCC}'),
                    pw.Text('Address2: HDN_GET_ADDRESS {ANCC}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  'No. Sales Order',
                  'Item Number',
                  'Item Description',
                  'Qty Ship',
                  'UOM'
                ],
                data: [
                  ['12345', 'ITEM001', 'Deskripsi Item', '10', 'KG'],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Supir',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('(--------------------)'),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Penerima',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('(--------------------)'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
