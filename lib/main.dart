import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';
import 'package:jde_mobile_approval/core/helper/vpn_checker_service.dart';
import 'package:jde_mobile_approval/feature/login/ui/page/login_page.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: ColorCustom.primaryBlue,
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      home: Builder(
        // Gunakan Builder agar dapat context
        builder: (context) {
          // Mulai pengecekan VPN setelah build pertama
          WidgetsBinding.instance.addPostFrameCallback((_) {
            VpnCheckerService.start(context);
          });
          return const LoginPage();
        },
      ),
    );
  }
}
