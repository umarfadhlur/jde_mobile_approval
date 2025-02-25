import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';

Widget doubleButton({
  required BuildContext context,
  required String txtRight,
  required String txtLeft,
  required VoidCallback onTapRight,
  required VoidCallback onTapLeft,
}) {
  return Container(
    color: Colors.white,
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 50,
            color: Colors.red[600],
            child: Center(
              child: InkWell(
                onTap: onTapRight,
                focusColor: Colors.red[600],
                splashColor: Colors.white,
                child: Text(
                  txtRight,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Product-Sans",
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            color: ColorCustom.darkGrey,
            child: Center(
              child: InkWell(
                onTap: onTapLeft,
                focusColor: Colors.black45,
                splashColor: Colors.white,
                child: Text(
                  txtLeft,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Product-Sans",
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
