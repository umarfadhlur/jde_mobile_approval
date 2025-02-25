import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget itemSearch({
  required VoidCallback onPress,
  required TextEditingController controller,
  required ValueChanged<String> onchange,
  required String textHint,
}) {
  return Container(
    height: 50.0,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), color: Colors.white),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.back();
            },
            iconSize: 30.0,
          ),
        ),
        Expanded(
          flex: 9,
          child: TextField(
            textInputAction: TextInputAction.search,
            onChanged: onchange,
            controller: controller,
            decoration: InputDecoration(
              hintText: textHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 15.0, top: 15.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: onPress,
                iconSize: 30.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
