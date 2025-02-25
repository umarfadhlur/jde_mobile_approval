import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:get/get.dart';

Widget appBarMenuCustom({
  required VoidCallback logOut,
  String? judul,
}) {
  return AppBar(
    elevation: 0.0,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: const Icon(
        Icons.chevron_left,
        color: Colors.white,
      ),
      onPressed: () {
        Get.back();
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        tooltip: "info",
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        tooltip: "logout",
        onPressed: logOut,
      ),
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: ColorCustom.blueGradient1),
      ),
    ),
  );
}
