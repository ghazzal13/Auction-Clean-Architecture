import 'package:flutter/material.dart';

Widget textFormField(
  context, {
  required TextEditingController? controller,
  required TextInputType type,
  bool isPassword = false,
  required String? Function(String?)? validate,
  required String hintText,
  IconData? prefix,
  Widget? suffix,
  Function? suffixPressed,
  TextInputAction? textInputAction = TextInputAction.done,
}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    width: size.width / 1.25,
    alignment: Alignment.center,
    padding: EdgeInsets.only(right: size.width / 30),
    // ),
    child: TextFormField(
      controller: controller,
      validator: validate,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(.9),
      ),
      obscureText: isPassword,
      keyboardType: type,
      cursorColor: Colors.white.withOpacity(.9),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.9),
            width: .1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.9),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        prefixIcon: Icon(
          prefix,
          color: Colors.white.withOpacity(.8),
        ),
        suffixIcon: suffix,
        suffixIconColor: Colors.white.withOpacity(.9),
        border: InputBorder.none,
        hintMaxLines: 1,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(.9),
        ),
      ),
      textInputAction: textInputAction,
    ),
  );
}
