import 'dart:async';
import 'package:flutter/material.dart';
import '../helper/vpn_helper.dart'; // sesuaikan path ke file VpnHelper

class VpnCheckerService {
  static Timer? _timer;

  static void start(BuildContext context) {
    _timer ??= Timer.periodic(const Duration(seconds: 5), (timer) async {
      await VpnHelper.promptVpnIfNeeded();
    });
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
