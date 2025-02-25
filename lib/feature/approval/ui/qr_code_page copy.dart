import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as move;
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/login/ui/page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  late String _company, _username, _environment, _address;

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
    void getFile(String url) async {
      Map body = {
        "username": "jde",
        "password": "jde",
        "inputs": [
          {"name": "mnAddressNumber", "value": "151"},
          {"name": "sequence", "value": "2"}
        ]
      };
      try {
        final checkExt = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: utf8.encode(json.encode(body)));
        final response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/octet-stream",
            },
            body: utf8.encode(json.encode(body)));
        var test = jsonDecode(checkExt.body);
        List<String> ext = test['fileName'].toString().split('.');
        print('Extension: ' + ext.last);
        if (response.statusCode == 200) {
          if (ext.last == 'pdf') {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file = new File('$tempPath/new.pdf');
            await file.writeAsBytes(response.bodyBytes);
            print(file.path);
          } else if (ext.last == 'png') {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file = new File('$tempPath/new.png');
            await file.writeAsBytes(response.bodyBytes);
            print(file.path);
          } else if (ext.last == 'jpg') {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file = new File('$tempPath/new.jpg');
            await file.writeAsBytes(response.bodyBytes);
            print(file.path);
          } else if (ext.last == 'jpeg') {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file = new File('$tempPath/new.jpeg');
            await file.writeAsBytes(response.bodyBytes);
            print(file.path);
          }
        } else {
          print('Tidak Ada');
        }
      } catch (value) {
        print(value);
      }
    }

    void deleteFile() async {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/new.pdf');
      await file.delete();
    }

    return Scaffold(
      key: _scaffoldstate,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorCustom.blueColor,
                  ),
                  onPressed: () {
                    getFile(EndPoint.test);
                  },
                  child: Text('Test'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    deleteFile();
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
            SfPdfViewer.file(File(
                '/data/user/0/com.example.jde_mobile_approval/cache/new.pdf')),
            // Image.file(File(
            //     '/data/user/0/com.example.jde_mobile_approval/cache/new.pdf')),
          ],
        ),
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
      title: const Text(
        'Attachment Test',
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
