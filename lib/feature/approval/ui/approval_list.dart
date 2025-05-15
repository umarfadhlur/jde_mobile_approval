import 'dart:io';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/core/widget/approval_count.dart';
import 'package:jde_mobile_approval/feature/approval/bloc/waiting_list_approval_bloc.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/waiting_list_approval_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/repository/waiting_list_approval_repository.dart';
import 'package:jde_mobile_approval/feature/approval/ui/approval_detail.dart';
import 'package:jde_mobile_approval/feature/login/ui/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApprovalListPage extends StatefulWidget {
  const ApprovalListPage({super.key});

  @override
  ApprovalListPageState createState() => ApprovalListPageState();
}

class ApprovalListPageState extends State<ApprovalListPage> {
  final WaitingListApprovalBloc _waitingListApprovalBloc =
      WaitingListApprovalBloc(
          waitingListApprovalRepository: WaitingListApprovalRepositoryImpl());

  late String _company, _username, _environment, _address;
  final oCcy = NumberFormat("#,##0.00", "en_US");
  final TextEditingController _description = TextEditingController();

  void initState() {
    SharedPreferences.getInstance().then(
      (prefVal) => {
        setState(
          () {
            _company = prefVal.getString(SharedPref.company) ?? "";
            _username = prefVal.getString(SharedPref.username) ?? "";
            _environment = prefVal.getString(SharedPref.environtment) ?? "";
            _address = prefVal.getString(SharedPref.addressnumber) ?? "";
            _waitingListApprovalBloc.add(FilterListSelectEvent(
                personResponsible: _address, eventPoint: "W"));
            print('test $_company, $_username, $_environment, $_address');
          },
        ),
      },
    );
    super.initState();
  }

  Future<void> getFile(String doco, String dcto, String kcoo) async {
    Map recBody = {
      "username": "jde",
      "password": "jde",
      "inputs": [
        {"name": "Order Company", "value": kcoo},
        {"name": "Order Number ", "value": doco},
        {"name": "Order Type ", "value": dcto}
      ]
    };
    Map attBody = {
      "username": "jde",
      "password": "jde",
      "inputs": [
        {"name": "mnDocumentorderinvoicee", "value": doco},
        {"name": "szOrdertype", "value": dcto},
        {"name": "szDocumentCompany", "value": kcoo},
        {"name": "szOrderSuffix", "value": "000"}
      ]
    };

    try {
      // Take Records Count
      final checkRec = await http.post(Uri.parse(EndPoint.getApvDetail),
          headers: {
            "Content-Type": "application/json",
          },
          body: utf8.encode(json.encode(recBody)));
      var testRec = jsonDecode(checkRec.body);
      int rec = testRec['GetDataF55ORCH2']['records'];
      print('Count: ' + rec.toString());

      // Header Attachments
      final checkHeadExt = await http.post(Uri.parse(EndPoint.dlAttach),
          headers: {
            "Content-Type": "application/json",
          },
          body: utf8.encode(json.encode(attBody)));
      final dlHeadAttach = await http.post(Uri.parse(EndPoint.dlAttach),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/octet-stream",
          },
          body: utf8.encode(json.encode(attBody)));
      if (dlHeadAttach.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Gunakan ekstensi zip langsung
        File file = File('$tempPath/$doco-$dcto-$kcoo.zip');
        await file.writeAsBytes(dlHeadAttach.bodyBytes);

        // Simpan path ke shared preferences
        await prefs.setString(SharedPref.filePath, file.path);
        print('File path saved: ${prefs.getString(SharedPref.filePath)}');
      } else {
        print('Tidak Ada');
      }
    } catch (value) {
      print(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustom.primaryBlue,
        title: Text(
          "Approval List",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.off(() => const HomePage());
          },
        ),
      ),
      body: BlocProvider<WaitingListApprovalBloc>(
        create: (context) => WaitingListApprovalBloc(
          waitingListApprovalRepository: WaitingListApprovalRepositoryImpl(),
        ),
        child: BlocListener<WaitingListApprovalBloc, WaitingListApprovalState>(
          bloc: _waitingListApprovalBloc,
          listener: (BuildContext context, WaitingListApprovalState state) {
            if (state is ArticleLoadedState) {
              BotToast.closeAllLoading();
            }
            if (state is ArticleErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
            if (state is ApproveSuccess || state is RejectSuccess) {
              BotToast.closeAllLoading();

              final isApprove = state is ApproveSuccess;
              _showSuccessDialog(context,
                  title: isApprove
                      ? "Purchase Order Approved!"
                      : "Purchase Order Rejected!",
                  message: isApprove
                      ? "Purchase order has been approved."
                      : "Purchase order has been rejected.",
                  onClose: () => Get.offAll(const ApprovalListPage()));
            }
          },
          child: BlocBuilder<WaitingListApprovalBloc, WaitingListApprovalState>(
            bloc: _waitingListApprovalBloc,
            builder: (context, state) {
              if (state is WaitingListApprovalInitial) {
                return buildLoading();
              } else if (state is ArticleLoadedState) {
                return buildList(state.articles);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildList(List<ApvList> articles) {
    return articles.isEmpty
        ? Center(
            child: Text(
              'No Pending Approval',
              style: GoogleFonts.dmSans(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                approvalCount(
                    count: articles.length.toString(),
                    title: 'Approval Purchase Order'),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final item = articles[index];

                    return Dismissible(
                      key: ValueKey(item.orderNumber), // pastikan unik
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await handleApprove(item);
                        } else if (direction == DismissDirection.endToStart) {
                          await handleReject(item);
                          // return true;
                        }
                        return false;
                      },
                      child: InkWell(
                        onTap: () async {
                          BotToast.showLoading();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                              SharedPref.origName, item.origName);
                          await prefs.setString(
                              SharedPref.supplierName, item.supplierName);
                          await prefs.setString(SharedPref.quantityOrdered,
                              item.quantityOrdered.toString());
                          await prefs.setString(SharedPref.orderDate,
                              item.orderDate.toString().substring(0, 10));
                          await prefs.setString(SharedPref.orderNumber,
                              item.orderNumber.toString());
                          await prefs.setString(SharedPref.noPo, item.noPo);
                          await prefs.setString(SharedPref.orTy, item.orTy);
                          await prefs.setString(
                              SharedPref.company, item.orderCo);
                          await prefs.setString(SharedPref.curCod, item.curCod);

                          await getFile(item.orderNumber.toString(), item.orTy,
                                  item.orderCo)
                              .then((_) {
                            Get.to(() => const ApprovalDetailPage());
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item.origName,
                                            style: GoogleFonts.dmSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item.branch,
                                            style: GoogleFonts.dmSans(
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.supplierName,
                                          style:
                                              GoogleFonts.dmSans(fontSize: 13),
                                        ),
                                        const Text('',
                                            style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${oCcy.format(item.quantityOrdered / 100)} ${item.curCod}',
                                          style:
                                              GoogleFonts.dmSans(fontSize: 13),
                                        ),
                                        const Text('',
                                            style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item.noPo,
                                            style: GoogleFonts.dmSans(
                                                fontSize: 13),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item.orderDate
                                                .toString()
                                                .substring(0, 10),
                                            style: GoogleFonts.dmSans(
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

  Future<void> handleApprove(ApvList item) async {
    // _waitingListApprovalBloc.add(
    //   ApproveEntry(
    //     orderNumber: item.orderNumber.toString(),
    //   ),
    // );
    // BotToast.showLoading();
    _showDialogApprove(
      context,
      item.origName,
      item.supplierName,
      item.noPo,
      item.orderNumber,
    );
  }

  Future<void> handleReject(ApvList item) async {
    _showDialogReject(
      context,
      item.origName,
      item.supplierName,
      item.noPo,
      item.orderNumber,
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

  Future<void> _showDialogApprove(
    BuildContext context,
    String origName,
    String supplierName,
    String noPo,
    int orderNumber,
  ) async {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Approve Confirmation",
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                Center(
                  child: Text(
                    "Are you sure you want to approve\nthis Purchase Order?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Informasi PO
                Text(
                  origName,
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  supplierName,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    noPo,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Approve
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _waitingListApprovalBloc.add(
                            ApproveEntry(orderNumber: orderNumber.toString()),
                          );
                          BotToast.showLoading();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Approve',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Cancel
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
  }

  Future<void> _showDialogReject(
    BuildContext context,
    String origName,
    String supplierName,
    String noPo,
    int orderNumber,
  ) async {
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
                      origName,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      supplierName,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        noPo,
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
                                        orderNumber: orderNumber.toString(),
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
}
