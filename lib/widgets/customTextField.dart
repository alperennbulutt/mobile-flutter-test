import 'package:flutter/material.dart';
import 'package:snagom_app/globals/colors.dart';

customTextField(String prefixText, TextEditingController controller,
    {bool obscureText = false, TextInputType textInputType}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(2),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 0),
          color: Colors.grey[200],
          spreadRadius: 1,
          blurRadius: 5,
        )
      ],
    ),
    child: TextField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: textInputType,
      style: TextStyle(
        color: oceanGreen,
        fontSize: 12,
      ),
      cursorColor: oceanGreen,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        border: InputBorder.none,
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(top: 12.0, left: 10),
        //   child: Text(
        //     '$prefixText',
        //     style: TextStyle(
        //       color: colorTextGrey,
        //       fontSize: 15,
        //     ),
        //   ),
        // ),
        //  hintText: prefixText,
        labelText: prefixText,
        labelStyle: TextStyle(
          color: colorTextGrey,
          fontSize: 12,
        ),
      ),
    ),
  );
}
