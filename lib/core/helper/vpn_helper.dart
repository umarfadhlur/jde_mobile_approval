import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';

import '../../main.dart';
import '../constant/color.dart'; // pastikan import navigatorKey

bool _hasPrompted = false;

class VpnHelper {
  static Future<bool> promptVpnIfNeeded() async {
    // Cek koneksi awal ke intranet
    final isConnected = await canConnectTo('10.30.1.147', 9282);

    if (isConnected) {
      final info = NetworkInfo();
      final ip = await info.getWifiIP();
      debugPrint("✅ Terhubung ke intranet dengan IP: $ip");
      return true;
    }

    // Jika sudah pernah memunculkan dialog, skip
    if (_hasPrompted) {
      debugPrint(
          "❗ Dialog VPN sudah pernah ditampilkan, tidak akan muncul lagi.");
      return false;
    }

    // Pastikan context tersedia
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("❌ Context tidak tersedia untuk showDialog");
      return false;
    }

    _hasPrompted = true; // tandai sudah pernah tampil

    final shouldOpen = await showDialog<bool>(
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
                    "VPN Not Connected",
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
                    "You are not connected to the internal network yet.\nOpen FortiClient VPN now?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _hasPrompted = false;
                          Navigator.pop(context, false);
                        },
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

                    const SizedBox(width: 12),
                    // Batal
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _hasPrompted = false;
                          Navigator.pop(context, false);
                        },
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

    if (shouldOpen == true) {
      await openForticlient();
      await Future.delayed(const Duration(seconds: 10));

      final recheck = await canConnectTo('10.30.1.147', 9282);
      if (recheck) {
        debugPrint("✅ Terhubung setelah membuka FortiClient.");
        return true;
      } else {
        debugPrint("❌ Masih belum terhubung setelah membuka FortiClient.");
        return false;
      }
    }

    return false;
  }

  static Future<void> openForticlient() async {
    try {
      await LaunchApp.openApp(
        androidPackageName: 'com.fortinet.forticlient_vpn',
        openStore: true,
      );
    } catch (e) {
      print('Gagal membuka Forticlient VPN');
    }
  }

  static Future<bool> isConnectedToIntranetIP() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    print("Current IP: $ip");
    return ip != null && ip.startsWith("10.");
  }

  static Future<bool> isIntranetReachable(
      {String target = '10.212.134.1'}) async {
    try {
      final result = await InternetAddress.lookup(target);
      print('Lookup result: $result');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Lookup to $target failed: $e');
      return false;
    }
  }

  static Future<bool> canConnectTo(String host, int port) async {
    try {
      print('Mencoba koneksi TCP ke $host:$port ...');
      final socket =
          await Socket.connect(host, port, timeout: const Duration(seconds: 3));
      socket.destroy();
      print('Berhasil terhubung ke $host:$port');
      return true;
    } catch (e) {
      print('Gagal koneksi ke $host:$port: $e');
      return false;
    }
  }
}
