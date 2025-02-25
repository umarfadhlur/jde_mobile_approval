import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/count_wo_response.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_an8_params.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_connect_watchlist.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_data_f980051.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/get_watchlist.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/watchlist_count_wo_response.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/repository/menu_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/get_an8_response.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;

  MenuBloc({required MenuRepository menuRepository})
      : _menuRepository = menuRepository,
        super(MenuInitial()) {
    on<GetF980051>(_getF980051);
    on<GetWatch>(_getWatchList);
    on<GetNewWatch>(_getNewList);
    on<GetAll>(_getAll);
  }

  Future<void> _getF980051(GetF980051 event, Emitter<MenuState> emit) async {
    emit(LoadingState());

    try {
      final _prefs = await SharedPreferences.getInstance();
      final token = _prefs.getString(SharedPref.token) ?? '';
      final userID = _prefs.getString(SharedPref.username);

      if (userID == null || userID.isEmpty) {
        emit(F980051FailedState(message: 'User ID tidak ditemukan'));
        return;
      }

      final listParam = ParamsAn8(token: token, inputs: [
        Input(name: "Notification Subscriber", value: userID),
      ]);

      final rowset = await _menuRepository.getList(listParam.toJson());
      emit(F980051LoadedState(details: rowset));
    } catch (e) {
      print("Error in _getF980051: $e");
      emit(F980051FailedState(
          message: 'Terjadi kesalahan saat mengambil data.'));
    }
  }

  Future<void> _getWatchList(GetWatch event, Emitter<MenuState> emit) async {
    emit(LoadingState());

    try {
      final _prefs = await SharedPreferences.getInstance();
      final token = _prefs.getString(SharedPref.token) ?? '';
      final userID = _prefs.getString(SharedPref.username);

      if (userID == null || userID.isEmpty) {
        emit(WatchlistFailedState(message: 'User ID tidak ditemukan'));
        return;
      }

      final listParam = ParamsAn8(token: token, inputs: [
        Input(name: "User", value: userID),
      ]);

      final rowset = await _menuRepository.getWatchlist(listParam.toJson());
      emit(WatchlistLoadedState(details: rowset));
    } catch (e) {
      print("Error in _getWatchList: $e");
      emit(WatchlistFailedState(
          message: 'Terjadi kesalahan saat mengambil data.'));
    }
  }

  Future<void> _getNewList(GetNewWatch event, Emitter<MenuState> emit) async {
    emit(LoadingState());

    try {
      final _prefs = await SharedPreferences.getInstance();
      final token = _prefs.getString(SharedPref.token) ?? '';
      final userID = _prefs.getString(SharedPref.username);

      if (userID == null || userID.isEmpty) {
        emit(NewWatchlistFailedState(message: 'User ID tidak ditemukan'));
        return;
      }

      final listParam = ParamsAn8(token: token, inputs: [
        Input(name: "User", value: userID),
      ]);

      final rowset = await _menuRepository.getNewList(listParam.toJson());
      emit(NewWatchlistLoadedState(details: rowset));
    } catch (e) {
      print("Error in _getNewList: $e");
      emit(NewWatchlistFailedState(
          message: 'Terjadi kesalahan saat mengambil data.'));
    }
  }

  Future<void> _getAll(GetAll event, Emitter<MenuState> emit) async {
    emit(LoadingState());

    try {
      final _prefs = await SharedPreferences.getInstance();
      final token = _prefs.getString(SharedPref.token) ?? '';
      final userID = _prefs.getString(SharedPref.username);

      if (userID == null || userID.isEmpty) {
        emit(GetAllFailed(message: 'User ID tidak ditemukan'));
        return;
      }

      final notifyParam = ParamsAn8(token: token, inputs: [
        Input(name: "Notification Subscriber", value: userID),
      ]);
      final watchParam = ParamsAn8(token: token, inputs: [
        Input(name: "User", value: userID),
      ]);

      final notifyList = await _menuRepository.getList(notifyParam.toJson());
      final watchList = await _menuRepository.getNewList(watchParam.toJson());

      emit(GetAllSuccess(notify: notifyList, watchList: watchList));
    } catch (e) {
      print("Error in _getAll: $e");
      emit(GetAllFailed(message: 'Terjadi kesalahan saat mengambil data.'));
    }
  }
}
