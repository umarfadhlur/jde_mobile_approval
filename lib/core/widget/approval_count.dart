import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        leading: const Icon(
          Icons.file_present,
          size: 30,
        ),
        title: Text(
          title,
          style: GoogleFonts.dmSans(fontSize: 18.0),
        ),
        trailing: Text(
          count,
          style: GoogleFonts.dmSans(fontSize: 18.0),
        ),
      ),
    ),
  );
}
