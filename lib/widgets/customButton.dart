import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';

class CustomButton extends StatelessWidget {
  Function func;
  Widget buttonText;
  CustomButton(this.func, this.buttonText);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          width: Get.width,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                oceanGreen,
                colorGrassGreen,
                oceanGreen,
              ],
            ),
          ),
          child: Center(child: buttonText),
        ),
      ),
    );
  }
}
