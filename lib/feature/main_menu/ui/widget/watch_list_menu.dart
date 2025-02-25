import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/feature/main_menu/data/model/watchlist_count_wo_response.dart';

Widget watchList(ResponseWatchlistCountWo watchList) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          // Get.to(WorkOrderList());
        },
        child: ListTile(
          tileColor: Colors.white,
          title: const Text(
            'Number of Work Orders',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Text(
              watchList.rudCountwoF4801Dr.rowset.first.countWo.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
