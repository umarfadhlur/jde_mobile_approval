import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';
import 'package:jde_mobile_approval/feature/approval/ui/approval_list.dart';
import 'package:jde_mobile_approval/feature/generatesj/ui/generate_sj.dart';
import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/shared_preference.dart';
import 'package:jde_mobile_approval/feature/login/bloc/login_bloc.dart';
import 'package:jde_mobile_approval/feature/login/data/repository/login_repo.dart';
import 'package:jde_mobile_approval/feature/login/ui/page/login_page.dart';
import 'package:jde_mobile_approval/feature/printsj/ui/print_sj_init.dart';
import 'package:jde_mobile_approval/feature/signsj/ui/sign_sj_init.dart';
import 'package:jde_mobile_approval/feature/updatesj/ui/update_sj_init.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../../../core/helper/vpn_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _environment = "", _username = "", _token = "", _alphaName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VpnHelper.promptVpnIfNeeded();
    });
    _loadUserData();
  }

  final LoginBloc _addLoginBloc =
      LoginBloc(loginRepository: LoginRepositoryImpl());

  Future<void> _loadUserData() async {
    final prefVal = await SharedPreferences.getInstance();

    setState(() {
      _username = prefVal.getString(SharedPref.username) ?? "";
      _alphaName = prefVal.getString(SharedPref.alphaName) ?? "";
      _environment = prefVal.getString(SharedPref.environtment) ?? "";
      _token = prefVal.getString(SharedPref.token) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorCustom.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: ColorCustom.primaryBlue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.2, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    'assets/images/vector.png', // Ganti dengan gambar Anda
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Text Selamat Datang
              Positioned(
                top: 100,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang,',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      _alphaName.isNotEmpty ? _alphaName : 'User',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                right: 15,
                child: IconButton(
                  onPressed: () async {
                    BotToast.showLoading(
                        duration: const Duration(milliseconds: 500));
                    _addLoginBloc.add(LogoutSubmit(token: _token));
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.off(() => const LoginPage());
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Saya',
                      style: GoogleFonts.dmSans(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          // menuCard(
                          //   'Generate\nSurat Jalan',
                          //   'assets/images/generatesj.png',
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const GenerateSJPage(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // menuCard(
                          //   'Update\nSurat Jalan',
                          //   'assets/images/updatesj.png',
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             const UpdateSJPageInit(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // menuCard(
                          //   'Cetak\nSurat Jalan',
                          //   'assets/images/cetaksj.png',
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const PrintSJPageInit(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // menuCard(
                          //   'Sign\nE-Surat Jalan',
                          //   'assets/images/signsj.png',
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const SignSJPageInit(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          menuCard(
                            'Approval List',
                            'assets/images/cetaksj.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ApprovalListPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuCard(String title, String imagePath, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed != null ? () => onPressed() : null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 40, // Sesuaikan ukuran gambar
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 14)),
        ],
      ),
    );
  }
}
