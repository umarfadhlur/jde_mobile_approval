import 'package:flutter/material.dart';

Widget rowListItem({
  required String judul,
  required String val,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        judul,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          color: Colors.black,
        ),
      ),
      const SizedBox(width: 10),
      Text(
        val,
        style: const TextStyle(
          fontSize: 13.0,
          color: Colors.black,
        ),
      ),
    ],
  );
}
