import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/approval_detail_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/waiting_list_approval_param.dart';
import 'package:jde_mobile_approval/feature/approval/data/model/waiting_list_approval_response.dart';
import 'package:jde_mobile_approval/feature/approval/data/repository/waiting_list_approval_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'waiting_list_approval_state.dart';
part 'waiting_list_approval_event.dart';

class WaitingListApprovalBloc
    extends Bloc<WaitingListApprovalEvent, WaitingListApprovalState> {
  final WaitingListApprovalRepository waitingListApprovalRepository;

  WaitingListApprovalBloc({required this.waitingListApprovalRepository})
      : super(WaitingListApprovalInitial());

  @override
  Stream<WaitingListApprovalState> mapEventToState(
      WaitingListApprovalEvent event) async* {
    if (event is SearchListSelectEvent) {
      print('yang search');
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(SharedPref.token);
      final an8 = sharedPreferences.getString(SharedPref.addressnumber);

      if (token == null || an8 == null) {
        yield ArticleErrorState(message: "Token or Address is missing.");
        return;
      }

      List<Input> paramList = [
        Input(name: "Person Responsible 1", value: an8),
        Input(name: "EnterpriseOne Event Point 01 1", value: "W"),
      ];

      final listParam =
          GetWaitingApprovalListParam(token: token, inputs: paramList);
      List<ApvList> rowset1 = [];
      List<ApvList> rowset2 = [];

      if (event.descriptionF1201 != null) {
        try {
          print('No data ${event.descriptionF1201}');
          rowset2.clear();
          rowset1 =
              await waitingListApprovalRepository.getList(listParam.toJson());

          // Sort rowset1 by orderDate
          rowset1.sort((a, b) => b.orderDate.compareTo(a.orderDate));

          print('Sorted data: $rowset1');
          yield ArticleLoadedState(articles: rowset1);
        } catch (e) {
          yield ArticleErrorState(message: "Data Tidak di temukan");
        }
      }
    } else if (event is FilterListSelectEvent) {
      print('yang filter');
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(SharedPref.token);

      if (token == null) {
        yield ArticleErrorState(message: "Token is missing.");
        return;
      }

      List<Input> paramList = [
        Input(name: "Person Responsible 1", value: event.personResponsible),
        Input(name: "EnterpriseOne Event Point 01 1", value: 'W'),
      ];

      final listParam =
          GetWaitingApprovalListParam(token: token, inputs: paramList);
      List<ApvList> rowset1 = [];
      List<ApvList> rowset2 = [];

      if (event.personResponsible != null) {
        try {
          print('No data ${event.personResponsible}');
          rowset2.clear();
          rowset1 =
              await waitingListApprovalRepository.getList(listParam.toJson());

          // Sort rowset1 by orderDate
          rowset1.sort((a, b) => b.orderDate.compareTo(a.orderDate));

          print('Sorted data: $rowset1');
          yield ArticleLoadedState(articles: rowset1);
        } catch (e) {
          yield ArticleErrorState(message: "Data Tidak di temukan");
        }
      } else {
        try {
          rowset1.clear();
          rowset1 =
              await waitingListApprovalRepository.getList(listParam.toJson());

          // Sort rowset1 by orderDate
          rowset1.sort((a, b) => b.orderDate.compareTo(a.orderDate));

          if (rowset1.isNotEmpty) {
            yield ArticleLoadedState(articles: rowset1);
            print('data1');
          } else {
            yield ArticleErrorState(message: 'Data Kosong');
          }
        } catch (e) {
          yield ArticleErrorState(message: "Data Tidak di temukan");
        }
      }
    } else if (event is DetailListSelectEvent) {
      print('yang detail');
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(SharedPref.token);

      if (token == null) {
        yield DetailErrorState(message: "Token is missing.");
        return;
      }

      List<Input> paramList = [
        Input(name: "Order Company", value: event.orderCompany),
        Input(name: "Order Number ", value: event.orderNumber),
        Input(name: "Order Type ", value: event.orderType),
      ];

      print(event.orderCompany);
      print(event.orderNumber);
      print(event.orderType);

      final listParam =
          GetWaitingApprovalListParam(token: token, inputs: paramList);
      List<Detail> rowset1 = [];
      List<Detail> rowset2 = [];

      if (event.orderNumber != null) {
        try {
          print('No data ${event.orderNumber}');
          rowset2.clear();
          rowset1 =
              await waitingListApprovalRepository.getDetail(listParam.toJson());
          print('No data1 $rowset2');
          yield DetailLoadedState(details: rowset1);
        } catch (e) {
          yield DetailErrorState(message: "Data Tidak di temukan");
        }
      } else {
        try {
          rowset1.clear();
          rowset1 =
              await waitingListApprovalRepository.getDetail(listParam.toJson());
          if (rowset1.isNotEmpty) {
            yield DetailLoadedState(details: rowset1);
            print('data1');
          } else {
            yield DetailErrorState(message: 'Data Kosong');
          }
        } catch (e) {
          yield DetailErrorState(message: "Data Tidak di temukan");
        }
      }
    } else if (event is ApproveEntry) {
      print('Approve');
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(SharedPref.token);

      if (token == null) {
        yield ApproveFailed(message: "Token is missing.");
        return;
      }

      List<Input> paramList = [
        Input(name: "Document_Number", value: event.orderNumber),
      ];

      print('Document_Number: ${event.orderNumber}');

      final listParam =
          GetWaitingApprovalListParam(token: token, inputs: paramList);
      String statusCode;
      if (event.orderNumber != null) {
        try {
          statusCode =
              await waitingListApprovalRepository.approvePO(listParam.toJson());
          print(statusCode);
          if (statusCode == "200") {
            print('Success');
            yield ApproveSuccess(message: 'PO Approved');
          } else {
            print('Failed');
            yield ApproveFailed(message: 'Error');
          }
        } catch (e) {
          yield ApproveFailed(message: 'Error');
        }
      }
    } else if (event is RejectEntry) {
      print('Reject');
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(SharedPref.token);

      if (token == null) {
        yield RejectFailed(message: "Token is missing.");
        return;
      }

      List<Input> paramList = [
        Input(name: "Document_Number", value: event.orderNumber),
        Input(name: "Description", value: event.remarks),
      ];

      print('Document_Number: ${event.orderNumber}');
      print('Description: ${event.remarks}');

      final listParam =
          GetWaitingApprovalListParam(token: token, inputs: paramList);
      String statusCode;
      if (event.orderNumber != null) {
        try {
          statusCode =
              await waitingListApprovalRepository.rejectPO(listParam.toJson());
          print(statusCode);
          if (statusCode == "200") {
            print('Success');
            yield RejectSuccess(message: 'PO Approved');
          } else {
            print('Failed');
            yield RejectFailed(message: 'Error');
          }
        } catch (e) {
          yield RejectFailed(message: 'Error');
        }
      }
    }
  }
}
