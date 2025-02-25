import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jde_mobile_approval/core/constant/shared_preference.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/get_item_description_response_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/get_qty_uom_response_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/po_receipt_new_param_modal.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/model/po_receipt_param_model.dart';
import 'package:jde_mobile_approval/feature/po_receipt/data/repository/po_receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'po_receipt_state.dart';
part 'po_receipt_event.dart';

class PoReceiptBloc extends Bloc<PoReceiptEvent, PoReceiptState> {
  final PoReceiptRepository poReceiptRepository;

  PoReceiptBloc({required this.poReceiptRepository})
      : super(PoReceiptInitial()) {
    on<PoEntry>(_onPoEntry);
    on<NewPoEntry>(_onNewPoEntry);
    on<LotCheck>(_onLotCheck);
    on<GetQtyUom>(_onGetQtyUom);
    on<UpdateItem>(_onUpdateItem);
    on<GetItemDesc>(_onGetItemDesc);
  }

  Future<void> _onPoEntry(PoEntry event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(FailedEntry(message: 'Token not found'));
      return;
    }

    List<Input> paramList = [
      Input(name: "NomorSuratJalan", value: event.noSurat),
      Input(name: "Driver", value: event.driver),
      Input(name: "Container ID", value: event.containerID),
      Input(name: "NomorKendaraan", value: event.noKendaraan),
      Input(name: "PO Number", value: event.poNumber),
      Input(name: "Lot Serial Number", value: event.lotNumber),
      Input(name: "Item Number", value: event.itemNumber),
      Input(name: "Quantity", value: event.quantity),
      Input(name: "UOM", value: event.uom),
    ];

    final listParam = PoReceiptParam(token: token, inputs: paramList);

    try {
      final statusCode = await poReceiptRepository.ccEntry(listParam.toJson());
      if (statusCode == "200") {
        emit(SuccessEntry(message: 'Nomor Surat Updated'));
      } else {
        emit(FailedEntry(message: 'Update Failed'));
      }
    } catch (e) {
      emit(FailedEntry(message: 'Update Failed'));
    }
  }

  Future<void> _onNewPoEntry(
      NewPoEntry event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(FailedEntry(message: 'Token not found'));
      return;
    }

    final listParam = PoReceiptNewParam(
      token: token,
      nomorSuratJalan: event.noSurat,
      driver: event.driver,
      containerId: event.containerID,
      nomorKendaraan: event.noKendaraan,
      gridData: event.gridData,
    );

    try {
      final statusCode = await poReceiptRepository.ccEntry(listParam.toJson());
      if (statusCode == "200") {
        emit(SuccessEntry(message: 'Nomor Surat Entered'));
      } else {
        emit(FailedEntry(message: 'Update Failed'));
      }
    } catch (e) {
      emit(FailedEntry(message: 'Update Failed'));
    }
  }

  Future<void> _onLotCheck(LotCheck event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(LotFound(message: 'Token not found'));
      return;
    }

    List<Input> paramList = [
      Input(name: "Lot Serial Number 1", value: event.lotNumber)
    ];
    final listParam = PoReceiptParam(token: token, inputs: paramList);

    try {
      final parentNumber =
          await poReceiptRepository.checkLot(listParam.toJson());
      if (parentNumber == 0) {
        emit(LotNotFound(message: ''));
      } else {
        emit(LotFound(message: 'Lot Number Already Defined'));
      }
    } catch (e) {
      emit(LotFound(message: 'Update Failed'));
    }
  }

  Future<void> _onGetQtyUom(
      GetQtyUom event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(QtyNotFound(message: 'Token not found'));
      return;
    }

    List<Input> paramList = [
      Input(name: "Lot Serial Number 1", value: event.lotNumber)
    ];
    final listParam = PoReceiptParam(token: token, inputs: paramList);

    try {
      final rowset1 = await poReceiptRepository.getQty(listParam.toJson());
      if (rowset1.isNotEmpty) {
        emit(QtyUomLoaded(qtyuoms: rowset1));
      } else {
        emit(QtyNotFound(message: 'Not Found'));
      }
    } catch (e) {
      emit(QtyNotFound(message: 'Not Found'));
    }
  }

  Future<void> _onUpdateItem(
      UpdateItem event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(QtyNotFound(message: 'Token not found'));
      return;
    }

    List<Input> paramList = [
      Input(name: "Lot Serial Number 1", value: event.lotNumber),
      Input(name: "2nd Item Number 1", value: event.itemNumber),
    ];
    final listParam = PoReceiptParam(token: token, inputs: paramList);

    try {
      final rowset1 = await poReceiptRepository.updateItem(listParam.toJson());
      emit(QtyUomLoaded(qtyuoms: rowset1));
    } catch (e) {
      emit(QtyNotFound(message: 'Not Found'));
    }
  }

  Future<void> _onGetItemDesc(
      GetItemDesc event, Emitter<PoReceiptState> emit) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(SharedPref.token);
    if (token == null) {
      emit(ItemDescNotFound(message: 'Token not found'));
      return;
    }

    List<Input> paramList = [
      Input(name: "2nd Item Number 1", value: event.itemDesc)
    ];
    final listParam = PoReceiptParam(token: token, inputs: paramList);

    try {
      final rowset1 = await poReceiptRepository.getDesc(listParam.toJson());
      emit(ItemDescLoaded(descs: rowset1));
    } catch (e) {
      emit(ItemDescNotFound(message: 'Not Found'));
    }
  }
}
