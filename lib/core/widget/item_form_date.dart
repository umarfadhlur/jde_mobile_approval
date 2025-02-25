import 'package:flutter/material.dart';

Widget inputFormDate({
  required String title,
  required TextEditingController controller,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Material(
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black)),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      onTap: onTap,
                      controller: controller,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            icon,
                            size: 20,
                          ),
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
