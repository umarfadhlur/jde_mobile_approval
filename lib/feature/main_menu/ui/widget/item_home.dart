import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';

Widget itemHomeMain({
  required String txtItem,
  required VoidCallback onTap,
  required String txtImg,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(
        color: ColorCustom.blueColor, // Assuming ColorCustom.blueColor is valid
        width: 2.0,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              txtImg,
              height: 60,
              width: 60,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            txtItem,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: ColorCustom
                  .darkGrey, // Assuming ColorCustom.darkGrey is valid
              fontFamily: "Product-Sans",
            ),
          ),
        ],
      ),
    ),
  );
}
