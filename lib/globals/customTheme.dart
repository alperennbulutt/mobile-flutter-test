import 'package:flutter/material.dart';

switchCircleDecoration() {
  var decoration = BoxDecoration(
    border: Border.all(color: Color(0xFFFDFDFD)),
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
          offset: Offset(5, 6),
          blurRadius: 10,
          spreadRadius: -2,
          color: Color.fromRGBO(144, 158, 212, 1)),
      BoxShadow(
          offset: Offset(-3, -4),
          blurRadius: 6,
          color: Color.fromRGBO(252, 252, 252, 1)),
    ],
  );
  return decoration;
}

switchCircleDecoration2(bool isTrue) {
  return BoxDecoration(
    border: Border.all(color: Color(0xFFFDFDFD)),
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
          offset: Offset(5, 6),
          blurRadius: 10,
          spreadRadius: -2,
          color: Color.fromRGBO(144, 158, 212, 1)),
      BoxShadow(
          offset: Offset(-3, -4),
          blurRadius: 6,
          color: Color.fromRGBO(252, 252, 252, 1)),
    ],
  );
}

switchDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15.0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 14,
          spreadRadius: -1,
          color: Color(0x0ffcfcfe2)),
    ],
  );
}
