import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/login/data/model/login_param.dart';
import 'package:jde_mobile_approval/feature/login/data/model/login_response.dart';
import 'package:jde_mobile_approval/feature/login/data/model/logout_param.dart';
import 'package:jde_mobile_approval/feature/login/data/model/logout_response.dart';
import 'package:jde_mobile_approval/feature/login/data/repository/login_repo.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final _logger = Logger();

  LoginBloc({required LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginSubmit) {
      yield* _mapAppLoginToState(event);
    } else if (event is LogoutSubmit) {
      yield* _mapAppLogoutToState(event);
    }
  }

  Stream<LoginState> _mapAppLoginToState(LoginSubmit event) async* {
    yield LoginLoadingState();
    final sharedPreferences = await SharedPreferences.getInstance();
    final loginParam =
        LoginParam(username: event.username, password: event.password);

    _logger.d("PASS ${event.password}");

    if (event.username.isEmpty || event.password.isEmpty) {
      yield LoginErrorState(message: 'Cek Kembali Username dan Password!');
    } else {
      _logger.d("Cek");
      try {
        LoginResponse user =
            await _loginRepository.getLogin(loginParam.toJson());
        _logger.d("user $user");
        if (user.userInfo.token.isEmpty) {
          _logger.d("gagal");
          yield LoginErrorState(message: 'Cek Kembali Username dan Password!');
        } else {
          await sharedPreferences.setString(
              SharedPref.token, user.userInfo.token);
          await sharedPreferences.setString(
              SharedPref.addressnumber, user.userInfo.addressNumber.toString());
          await sharedPreferences.setString(SharedPref.username, user.username);
          await sharedPreferences.setString(
              SharedPref.alphaName, user.userInfo.alphaName);
          await sharedPreferences.setString(
              SharedPref.password, event.password);
          await sharedPreferences.setString(
              SharedPref.environtment, user.environment);
          yield LoginSuccessState(
              username: user.username,
              environment: user.environment,
              token: user.userInfo.token);
          _logger.d("LoginSucces token ${user.userInfo.token}");
          _logger.d("LoginSucces addressNumber ${user.userInfo.addressNumber}");
        }
      } on DioError catch (e) {
        yield LoginErrorState(message: 'Server Error');
        _logger.d("LoginError $e");
      } catch (e) {
        yield LoginErrorState(message: 'Cek Kembali Username dan Password!');
        _logger.d("LoginError $e");
      }
    }
  }

  Stream<LoginState> _mapAppLogoutToState(LogoutSubmit event) async* {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(SharedPref.token);

    if (token != null) {
      final logoutParam = LogoutParam(token: token);

      try {
        LogoutResponse user =
            await _loginRepository.getLogout(logoutParam.toJson());
        if (user.status == "Sukses") {
          yield LogoutSuccess();
        }
      } catch (e) {
        yield LogoutErrorState(message: 'Logout Error');
      }
    } else {
      yield LogoutErrorState(message: 'Token not found');
    }
  }

  LoginState get initialState => LoginInitial();
}
