import 'package:google_fonts/google_fonts.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';
import 'package:jde_mobile_approval/feature/generatesj/ui/generate_sj.dart';
import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/shared_preference.dart';
import 'package:jde_mobile_approval/feature/printsj/ui/print_sj_init.dart';
import 'package:jde_mobile_approval/feature/signsj/ui/sign_sj_init.dart';
import 'package:jde_mobile_approval/feature/updatesj/ui/update_sj_init.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _environment = "", _username = "", _token = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefVal = await SharedPreferences.getInstance();

    setState(() {
      _username = prefVal.getString(SharedPref.username) ?? "";
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
                      _username.isNotEmpty ? _username : 'User',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          menuCard(
                            'Generate\nSurat Jalan',
                            'assets/images/generatesj.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenerateSJPage(),
                                ),
                              );
                            },
                          ),
                          menuCard(
                            'Update\nSurat Jalan',
                            'assets/images/updatesj.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateSJPageInit(),
                                ),
                              );
                            },
                          ),
                          menuCard(
                            'Cetak\nSurat Jalan',
                            'assets/images/cetaksj.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrintSJPageInit(),
                                ),
                              );
                            },
                          ),
                          menuCard(
                            'Sign\nE-Surat Jalan',
                            'assets/images/signsj.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignSJPageInit(),
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
              style: GoogleFonts.dmSans(fontSize: 16)),
        ],
      ),
    );
  }
}
