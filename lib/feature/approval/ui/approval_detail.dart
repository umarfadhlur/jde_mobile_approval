import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/approval/bloc/waiting_list_approval_bloc.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/approval_detail_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/repository/waiting_list_approval_repository.dart';
import 'package:jde_mobile_approval/feature/approval/ui/approval_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ApprovalDetailPage extends StatefulWidget {
  @override
  _ApprovalDetailPageState createState() => _ApprovalDetailPageState();
}

class _ApprovalDetailPageState extends State<ApprovalDetailPage> {
  final WaitingListApprovalBloc _waitingListApprovalBloc =
      WaitingListApprovalBloc(
          waitingListApprovalRepository: WaitingListApprovalRepositoryImpl());

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
  final oCcy = NumberFormat("#,##0.00", "en_US");
  final oy = NumberFormat("#,##0", "en_US");
  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    BotToast.showLoading();
    SharedPreferences.getInstance().then(
      (prefVal) => {
        setState(
          () {
            _company = prefVal.getString(SharedPref.company) ?? "";
            _origName = prefVal.getString(SharedPref.origName) ?? "";
            _supplierName = prefVal.getString(SharedPref.supplierName) ?? "";
            _quantityOrdered =
                prefVal.getString(SharedPref.quantityOrdered) ?? "";
            _orderNumber = prefVal.getString(SharedPref.orderNumber) ?? "";
            _noPo = prefVal.getString(SharedPref.noPo) ?? "";
            _orderDate = prefVal.getString(SharedPref.orderDate) ?? "";
            _orTy = prefVal.getString(SharedPref.orTy) ?? "";
            _curCod = prefVal.getString(SharedPref.curCod) ?? "";
            _filePath = prefVal.getString(SharedPref.filePath) ?? "";
            _waitingListApprovalBloc.add(DetailListSelectEvent(
              orderCompany: _company,
              orderNumber: _orderNumber,
              orderType: _orTy,
            ));
            print(
                'test $_company, $_origName, $_supplierName, $_quantityOrdered, $_orderNumber, $_noPo, $_orderDate, $_orTy, $_curCod');
          },
        ),
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(SharedPref.filePath);
            Get.back();
          },
        ),
        elevation: 0,
        title: Image.asset(
          'assets/images/logoOpusB.png',
          fit: BoxFit.fitHeight,
          height: 32,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: BlocProvider<WaitingListApprovalBloc>(
          create: (context) => WaitingListApprovalBloc(
            waitingListApprovalRepository: WaitingListApprovalRepositoryImpl(),
          ),
          child:
              BlocListener<WaitingListApprovalBloc, WaitingListApprovalState>(
            bloc: _waitingListApprovalBloc,
            listener: (BuildContext context, WaitingListApprovalState state) {
              if (state is DetailLoadedState) {
                BotToast.closeAllLoading();
              }
              if (state is ApproveSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Approval Success'),
                    backgroundColor: Colors.green,
                  ),
                );
                Future.delayed(Duration(seconds: 1), () {
                  BotToast.closeAllLoading();
                  Get.off(ApprovalListPage());
                });
              }
              if (state is RejectSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reject Success'),
                    backgroundColor: Colors.green,
                  ),
                );
                Future.delayed(Duration(seconds: 1), () {
                  BotToast.closeAllLoading();
                  Get.off(ApprovalListPage());
                });
              }
            },
            child: BlocBuilder(
              bloc: _waitingListApprovalBloc,
              builder: (context, state) {
                if (state is WaitingListApprovalInitial) {
                  return Container();
                } else if (state is DetailLoadedState) {
                  return buildList(state.details);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildList(List<Detail> details) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _origName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Opacity(
                                opacity: File(_filePath).existsSync() == true
                                    ? 1.0
                                    : 0.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.attach_file,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    if (File('/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.pdf')
                                            .existsSync() ==
                                        true) {
                                      _showAttachment(context);
                                    } else if (File(
                                                '/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.jpg')
                                            .existsSync() ==
                                        true) {
                                      _showPicture(context);
                                    } else if (File(
                                                '/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.jpeg')
                                            .existsSync() ==
                                        true) {
                                      _showPicture(context);
                                    } else if (File(
                                                '/data/user/0/com.example.jde_mobile_approval/cache/$_noPo.png')
                                            .existsSync() ==
                                        true) {
                                      _showPicture(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Text(
                            _supplierName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  oCcy.format(
                                        int.parse(_quantityOrdered),
                                      ) +
                                      ' ' +
                                      _curCod,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Requested:',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _orderDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Text(
                              _noPo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorCustom.blueColor,
                                    minimumSize: Size(
                                        size.width * 0.3, size.width * 0.1)),
                                onPressed: () {
                                  _waitingListApprovalBloc.add(ApproveEntry(
                                    orderNumber: _orderNumber,
                                  ));
                                  BotToast.showLoading();
                                },
                                child: Text('Approve'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorCustom.blueColor,
                                    minimumSize: Size(
                                        size.width * 0.3, size.width * 0.1)),
                                onPressed: () {
                                  _showDialog(context);
                                },
                                child: Text('Reject'),
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
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: details.length,
            itemBuilder: (context, item) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details[item].itemDescription,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Quantity: ${oy.format(details[item].quantity)} ${details[item].uom}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Line: ${oy.format(details[item].lineNumber)}.000',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Price: ${oCcy.format(details[item].price)} ${details[item].curCod}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Total: ${oCcy.format(details[item].price * details[item].quantity)} ${details[item].curCod}',
                          style: TextStyle(
                            fontSize: 16,
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
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    Text(
                      _origName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _supplierName,
                      style: TextStyle(
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
                        style: TextStyle(
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
                              primary: ColorCustom.blueColor,
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
                          child: Text('Reject'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorCustom.blueColor,
                              minimumSize:
                                  Size(size.width * 0.3, size.width * 0.1)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
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
}
