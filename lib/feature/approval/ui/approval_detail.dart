import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/approval/bloc/waiting_list_approval_bloc.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/approval_detail_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/repository/waiting_list_approval_repository.dart';
import 'package:jde_mobile_approval/feature/approval/ui/approval_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;

class ApprovalDetailPage extends StatefulWidget {
  const ApprovalDetailPage({super.key});

  @override
  ApprovalDetailPageState createState() => ApprovalDetailPageState();
}

class ApprovalDetailPageState extends State<ApprovalDetailPage> {
  final WaitingListApprovalBloc _waitingListApprovalBloc =
      WaitingListApprovalBloc(
    waitingListApprovalRepository: WaitingListApprovalRepositoryImpl(),
  );

  final oCcy = NumberFormat("#,##0.00", "en_US");
  final oy = NumberFormat("#,##0", "en_US");

  late String _company,
      _origName,
      _supplierName,
      _quantityOrdered,
      _orderNumber,
      _noPo,
      _orderDate,
      _orTy,
      _curCod,
      _filePath;

  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    BotToast.showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _company = prefs.getString(SharedPref.company) ?? "";
    _origName = prefs.getString(SharedPref.origName) ?? "";
    _supplierName = prefs.getString(SharedPref.supplierName) ?? "";
    _quantityOrdered = prefs.getString(SharedPref.quantityOrdered) ?? "0";
    _orderNumber = prefs.getString(SharedPref.orderNumber) ?? "";
    _noPo = prefs.getString(SharedPref.noPo) ?? "";
    _orderDate = prefs.getString(SharedPref.orderDate) ?? "";
    _orTy = prefs.getString(SharedPref.orTy) ?? "";
    _curCod = prefs.getString(SharedPref.curCod) ?? "";
    _filePath = prefs.getString(SharedPref.filePath) ?? "";

    print('_filePath: $_filePath');

    _waitingListApprovalBloc.add(DetailListSelectEvent(
      orderCompany: _company,
      orderNumber: _orderNumber,
      orderType: _orTy,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustom.primaryBlue,
        title: Text(
          "Approval Detail",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(SharedPref.filePath, "");
              Navigator.pop(context);
            }),
      ),
      body: BlocProvider.value(
        value: _waitingListApprovalBloc,
        child: BlocListener<WaitingListApprovalBloc, WaitingListApprovalState>(
          listener: (context, state) {
            if (state is DetailLoadedState) {
              BotToast.closeAllLoading();
            }
            if (state is ApproveSuccess || state is RejectSuccess) {
              BotToast.closeAllLoading();

              final isApprove = state is ApproveSuccess;
              _showSuccessDialog(
                context,
                title: isApprove
                    ? "Purchase Order Approved!"
                    : "Purchase Order Rejected!",
                message: isApprove
                    ? "Purchase order has been approved."
                    : "Purchase order has been rejected.",
                onClose: () {
                  Get.off(const ApprovalListPage());
                },
              );
            }
          },
          child: BlocBuilder<WaitingListApprovalBloc, WaitingListApprovalState>(
            builder: (context, state) {
              if (state is DetailLoadedState) {
                return buildList(state.details);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget buildList(List<Detail> details) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _origName,
                            style: GoogleFonts.dmSans(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (File(_filePath).existsSync())
                          IconButton(
                            icon: Icon(Icons.attach_file, size: 40),
                            onPressed: () {
                              _handleFileAttachment();
                            },
                          )
                      ],
                    ),
                    Text(
                      _supplierName,
                      style: GoogleFonts.dmSans(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    _buildDetailRow('Total:',
                        '${oCcy.format(int.parse(_quantityOrdered) / 100)} $_curCod'),
                    _buildDetailRow('Requested:', _orderDate),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _noPo,
                        style: GoogleFonts.dmSans(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize:
                                Size(size.width * 0.3, size.width * 0.1),
                          ),
                          onPressed: () {
                            _waitingListApprovalBloc
                                .add(ApproveEntry(orderNumber: _orderNumber));
                            BotToast.showLoading();
                          },
                          child: Text('Approve', style: GoogleFonts.dmSans()),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize:
                                Size(size.width * 0.3, size.width * 0.1),
                          ),
                          onPressed: () => _showDialog(context),
                          child: Text('Reject', style: GoogleFonts.dmSans()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.itemDescription,
                          style: GoogleFonts.dmSans(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        _buildDetailRow('Quantity:',
                            '${oy.format(detail.quantity)} ${detail.uom}'),
                        _buildDetailRow(
                            'Line:', '${oy.format(detail.lineNumber)}.000'),
                        _buildDetailRow('Price:',
                            '${oCcy.format(detail.price)} ${detail.curCod}'),
                        _buildDetailRow(
                          'Total:',
                          '${oCcy.format(detail.price * detail.quantity)} ${detail.curCod}',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(label, style: GoogleFonts.dmSans(fontSize: 16))),
          Expanded(
              flex: 2,
              child: Text(value, style: GoogleFonts.dmSans(fontSize: 16))),
        ],
      ),
    );
  }

  void _handleFileAttachment() async {
    const basePath = '/data/user/0/com.example.jde_mobile_approval/cache/';
    final zipPath = '$basePath$_noPo.zip';
    final zipFile = File(zipPath);

    print('Mencari file: $zipPath');

    if (!zipFile.existsSync()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File .zip tidak ditemukan')),
        );
      }
      return;
    }

    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tempDir = await getTemporaryDirectory();

    List<File> extractedFiles = [];

    for (final archiveFile in archive) {
      if (!archiveFile.isFile) continue;

      final fileName = archiveFile.name;
      final data = archiveFile.content as List<int>;
      final outFile = File('${tempDir.path}/$fileName');
      await outFile.create(recursive: true);
      await outFile.writeAsBytes(data);
      extractedFiles.add(outFile);
    }

    if (context.mounted) {
      if (extractedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tidak ada file yang berhasil diekstrak')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul
                  Row(
                    children: [
                      Icon(Icons.attach_file, color: ColorCustom.primaryBlue),
                      const SizedBox(width: 8),
                      Text(
                        'Attached Files',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List file dengan scrollbar
                  SizedBox(
                    height: 200,
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(8),
                      child: ListView.separated(
                        itemCount: extractedFiles.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (ctx, index) {
                          final file = extractedFiles[index];
                          final fileName = path.basename(file.path);
                          final extension =
                              path.extension(file.path).toLowerCase();

                          final icon = extension == '.pdf'
                              ? Icons.picture_as_pdf
                              : extension == '.jpg' ||
                                      extension == '.jpeg' ||
                                      extension == '.png'
                                  ? Icons.image
                                  : Icons.insert_drive_file;

                          return ListTile(
                            leading: Icon(icon, color: ColorCustom.primaryBlue),
                            title: Text(
                              fileName,
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () => OpenFile.open(file.path),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Tutup
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorCustom.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Close',
                        style: GoogleFonts.dmSans(
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
  }

  Future<void> _showDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isRemarksEmpty = _description.text.trim().isEmpty;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Reject Confirmation",
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(thickness: 1),

                    // Informasi PO
                    Text(
                      _origName,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _supplierName,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _noPo,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    // Input Remarks
                    TextField(
                      controller: _description,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Remarks (Required)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    // Error di bawah TextField
                    if (isRemarksEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          'Remarks must be filled!',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isRemarksEmpty
                                ? null
                                : () {
                                    _waitingListApprovalBloc.add(
                                      RejectEntry(
                                        orderNumber: _orderNumber,
                                        remarks: _description.text,
                                      ),
                                    );
                                    Navigator.pop(context);
                                    BotToast.showLoading();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              disabledBackgroundColor: Colors.red.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Reject',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isRemarksEmpty
                                    ? Colors.white60
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tombol Cancel
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorCustom.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Cancel',
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

                // Judul
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Pesan
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCustom.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Close",
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
    _description.dispose();
    _waitingListApprovalBloc.close();
    super.dispose();
  }
}
