import 'package:flutter/material.dart';

Widget textFormInput({
  required String hintText,
  bool isPassword = false,
  void Function(String?)? onSaved,
  bool isEmail = false,
  bool isURL = false,
  EdgeInsets paddingForm = const EdgeInsets.symmetric(vertical: 8.0),
  String? Function(String?)? validator,
  required TextEditingController controllerName,
  required Icon iconName,
  Widget? pass,
}) {
  return Padding(
    padding: paddingForm,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(fontFamily: "Product-Sans", fontSize: 15.0),
        decoration: InputDecoration(
          suffixIcon: pass,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: iconName,
          ),
        ),
        obscureText: isPassword,
        controller: controllerName,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isURL
                ? TextInputType.url
                : TextInputType.text,
        onSaved: onSaved,
        validator: validator,
      ),
    ),
  );
}
