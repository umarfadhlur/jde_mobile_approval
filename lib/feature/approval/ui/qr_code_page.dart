import 'package:flutter/material.dart';
import 'package:get/get.dart' as move;
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/login/ui/page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  late String _company, _username, _environment, _address;

  @override
  void initState() {
    SharedPreferences.getInstance().then(
      (prefVal) => {
        setState(
          () {
            _company = prefVal.getString(SharedPref.company) ?? "";
            _username = prefVal.getString(SharedPref.username) ?? "";
            _environment = prefVal.getString(SharedPref.environtment) ?? "";
            _address = prefVal.getString(SharedPref.addressnumber) ?? "";
            print('test $_company, $_username, $_environment, $_address');
          },
        ),
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: _appBar(),
      body: SfPdfViewer.network(
        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
        controller: _pdfViewerController,
      ),
    );
  }

  PreferredSizeWidget? _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Transform.translate(
        offset: const Offset(-10, 0),
        child: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () {
            move.Get.to(HomePage());
          },
        ),
      ),
      titleSpacing: -20,
      title: Text(
        'QR Code Test',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Product-Sans",
          fontSize: SizeConstant.textContentMedium,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: ColorCustom.blueGradient1),
        ),
      ),
    );
  }
}
