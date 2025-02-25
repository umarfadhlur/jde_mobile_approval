import 'package:flutter/material.dart';

Widget approvalCount({
  required String title,
  required String count,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(
          Icons.file_present,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
        trailing: Text(
          count,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ),
  );
}
