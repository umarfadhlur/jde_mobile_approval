import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/login/bloc/login_bloc.dart';
import 'package:jde_mobile_approval/feature/login/data/repository/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bot_toast/bot_toast.dart';

import '../../../../core/helper/vpn_helper.dart';
import '../../../../core/helper/vpn_checker_service.dart'; // Tambahkan ini
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final LoginBloc _loginBloc;
  bool _isHidePass = true;
  bool _isLoading = true;
  Timer? _vpnCheckTimer;
  bool isCheckingVpn = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(loginRepository: LoginRepositoryImpl());

    // Cek pertama kali saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkInitialVpn();
    });

    // Setup auto-check VPN setiap 5 detik
    _vpnCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (mounted && !isCheckingVpn) {
        isCheckingVpn = true;
        bool isConnected = await VpnHelper.canConnectTo('10.30.1.147', 9282);
        if (isConnected) {
          debugPrint("✅ VPN aktif, intranet bisa diakses.");
        } else {
          debugPrint("⚠️ VPN tidak aktif, prompt muncul.");
          await VpnHelper.promptVpnIfNeeded();
        }
        isCheckingVpn = false;
      }
    });
  }

  Future<void> _checkInitialVpn() async {
    final isConnected = await VpnHelper.promptVpnIfNeeded();
    if (isConnected) {
      _checkAutoLogin();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString(SharedPref.username);
    String? savedPassword = prefs.getString(SharedPref.password);

    if (savedUsername != null && savedPassword != null) {
      _loginProgress(savedUsername, savedPassword, isAutoLogin: true);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _loginProgress(String username, String password,
      {bool isAutoLogin = false}) {
    if (!isAutoLogin) BotToast.showLoading();
    _loginBloc.add(LoginSubmit(username: username, password: password));
  }

  Future<void> _clearCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPref.username);
    await prefs.remove(SharedPref.password);
  }

  @override
  void dispose() {
    // _vpnCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginErrorState) {
            BotToast.closeAllLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ),
            );
            await _clearCredentials();
          } else if (state is LoginSuccessState) {
            BotToast.closeAllLoading();
            Get.off(() => const HomePage());
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logoOpusB.png',
                              height: 80),
                          const SizedBox(height: 20),
                          Text("Sign In to Your Account",
                              style: GoogleFonts.dmSans(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Enter your username",
                              hintStyle: GoogleFonts.dmSans(),
                              prefixIcon: Icon(Icons.person,
                                  color: ColorCustom.primaryBlue),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _passwordController,
                            obscureText: _isHidePass,
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: GoogleFonts.dmSans(),
                              prefixIcon: Icon(Icons.lock,
                                  color: ColorCustom.primaryBlue),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _isHidePass
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ColorCustom.primaryBlue),
                                onPressed: () =>
                                    setState(() => _isHidePass = !_isHidePass),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _loginProgress(
                                _emailController.text,
                                _passwordController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorCustom.primaryBlue,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("LOGIN",
                                style: GoogleFonts.dmSans(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
