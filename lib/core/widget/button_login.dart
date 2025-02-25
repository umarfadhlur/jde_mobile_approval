import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';

Widget buttonLogin({
  required VoidCallback onPress,
  required String textName,
  required List<Color> color,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: PaddingConstant.formInputLow,
      left: PaddingConstant.formInput,
      right: PaddingConstant.formInput,
    ),
    child: ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            textName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: SizeConstant.textContentMedium,
              fontFamily: "Product-Sans",
            ),
          ),
        ),
      ),
    ),
  );
}
