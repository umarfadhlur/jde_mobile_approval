import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }
}

Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
  yield AuthenticationLoading();
  final sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString(SharedPref.token) ?? '';
  String? co =
      sharedPreferences.getString(SharedPref.co) ?? ''; // Fixed key for 'co'
  String? address = sharedPreferences.getString(SharedPref.token) ??
      ''; // Fixed key for 'address'

  if (token == null && co == null && address == null) {
    yield AuthenticationNotAuthenticated();
  } else {
    yield AuthenticationAuthenticated(token: token, co: co, address: address);
  }
}

Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
  yield AuthenticationLoading();
  final sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString(SharedPref.token) ?? '';
  String? co =
      sharedPreferences.getString(SharedPref.token) ?? ''; // Fixed key for 'co'
  String? address = sharedPreferences.getString(SharedPref.token) ??
      ''; // Fixed key for 'address'

  if (token == null && co != null && address != null) {
    yield AuthenticationAuthenticated(token: token, co: co, address: address);
  } else {
    yield AuthenticationNotAuthenticated();
  }
}

Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  yield AuthenticationNotAuthenticated();
}
