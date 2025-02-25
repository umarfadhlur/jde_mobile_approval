import 'package:flutter/material.dart';

Widget itemList({
  required String number,
  required String title,
  required String subtitle,
}) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Card(
      color: Colors.white,
      child: ListTile(
        leading: Text(number),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    ),
  );
}
