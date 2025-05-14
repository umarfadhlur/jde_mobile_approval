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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state is ApproveSuccess
                        ? 'Approval Success'
                        : 'Reject Success',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(Duration(seconds: 1), () {
                BotToast.closeAllLoading();
                Get.off(ApprovalListPage());
              });
            }
          },
          child: BlocBuilder<WaitingListApprovalBloc, WaitingListApprovalState>(
            builder: (context, state) {
              if (state is DetailLoadedState) {
                return buildList(state.details);
              }
              return Center(child: CircularProgressIndicator());
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

  // void _handleFileAttachment() {
  //   const String basePath =
  //       '/data/user/0/com.example.jde_mobile_approval/cache/';
  //   final String zipPath = '$basePath$_noPo.zip';
  //   final file = File(zipPath);

  //   print('Mencari file: $zipPath');

  //   if (file.existsSync()) {
  //     print('Ada');
  //     OpenFile.open(zipPath);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('File .zip tidak ditemukan')),
  //     );
  //   }
  // }

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

    // Ekstrak ZIP di luar penggunaan context
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

      // Baru gunakan context di sini (sudah aman)
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Attached Files'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: extractedFiles.length,
                itemBuilder: (ctx, index) {
                  final file = extractedFiles[index];
                  final fileName = path.basename(file.path);
                  return ListTile(
                    title: Text(fileName),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      OpenFile.open(file.path);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Reject Confirmations",
                        style: GoogleFonts.dmSans(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    Text(
                      _origName,
                      style: GoogleFonts.dmSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _supplierName,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Text(
                        _noPo,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _description,
                      decoration: InputDecoration(
                        labelText: 'Remarks (Required)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize:
                                  Size(size.width * 0.3, size.width * 0.1)),
                          onPressed: () {
                            if (_description.text.length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Remarks Cannot be Empty'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              _waitingListApprovalBloc.add(
                                RejectEntry(
                                  orderNumber: _orderNumber,
                                  remarks: _description.text,
                                ),
                              );
                              Navigator.pop(context);
                              BotToast.showLoading();
                            }
                          },
                          child: Text(
                            'Reject',
                            style: GoogleFonts.dmSans(),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorCustom.blueColor,
                              minimumSize:
                                  Size(size.width * 0.3, size.width * 0.1)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAttachment(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: size.height * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: File('/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.pdf')
                            .existsSync() ==
                        true
                    ? SfPdfViewer.file(File(
                        '/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.pdf'))
                    : const Center(child: Text('No Attachment')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPicture(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: size.height * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: File(_filePath).existsSync() == true
                    ? PhotoView(imageProvider: FileImage(File(_filePath)))
                    : Center(child: Text('No Attachment')),
              ),
            ],
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
