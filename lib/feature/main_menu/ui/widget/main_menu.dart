import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jde_mobile_approval/feature/approval/ui/approval_list.dart';
import 'package:jde_mobile_approval/feature/approval/ui/qr_code_page.dart';
// import 'package:jde_mobile_approval/feature/po_receipt/ui/po_receipt.dart.orig';
import 'package:jde_mobile_approval/core/constant/constants.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              children: mainMenuItem,
            ),
          ),
        ),
      ),
    );
  }
}

List<MainMenuItem> mainMenuItem = [
  MainMenuItem(
    title: 'PO Approval',
    icon: Icons.check,
    colorBox: ColorCustom.blueColor,
    iconColor: Colors.white,
    page: ApprovalListPage(),
  ),
  MainMenuItem(
    title: 'QR Code',
    icon: Icons.qr_code,
    colorBox: ColorCustom.blueColor,
    iconColor: Colors.white,
    page: QRCodePage(),
  ),
  // MainMenuItem(
  //   title: 'PO Receipt',
  //   icon: Icons.upload_outlined,
  //   colorBox: ColorCustom.blueColor,
  //   iconColor: Colors.white,
  //   page: PoReceipt(),
  // ),
  // MainMenuItem(
  //   title: 'Equipment'\

  //   icon: Icons.handyman,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   //page: EquipmentNumber(),
  //   // page: EquipmentNumberDetail(),
  //   page: EquipMasterList(),
  // ),
  // MainMenuItem(
  //   title: 'Work Order List',
  //   icon: Icons.format_list_numbered_outlined,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: WorkOrderList(),

  // ),
  // MainMenuItem(
  //   title: 'Offline WO',
  //   icon: Icons.format_list_numbered_outlined,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: WorkOrderListOffline(),
  // ),
  // MainMenuItem(
  //   title: 'Stock Opname',
  //   icon: Icons.inventory,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: StockOpname(),
  // ),
  // MainMenuItem(
  //   title: 'Offline SO',
  //   icon: Icons.format_list_numbered_outlined,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: StockOpnameListOffline(),
  // ),
  // MainMenuItem(
  //   title: 'Upload File',
  //   icon: Icons.upload_outlined,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: UploadFiles(),
  // ),
  // MainMenuItem(
  //   title: 'PO Receipt',
  //   icon: Icons.upload_outlined,
  //   colorBox: Colors.cyan,
  //   iconColor: Colors.white,
  //   page: PoReceipt(),
  // ),
];

class MainMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color colorBox, iconColor;
  final dynamic page;
  MainMenuItem(
      {required this.title,
      required this.icon,
      required this.colorBox,
      required this.iconColor,
      required this.page});
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(page);
          },
          child: Container(
            height: MediaQuery.of(context).size.width * 0.17,
            width: MediaQuery.of(context).size.width * 0.17,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorBox,
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
