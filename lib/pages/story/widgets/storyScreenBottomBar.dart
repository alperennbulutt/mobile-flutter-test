import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';

storyScreenBottomBar() {
  return Container(
    width: Get.width,
    height: 50,
    child: Row(
      children: [
        Container(
          height: 50,
          width: Get.width - 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Theme(
            data: ThemeData(primaryColor: oceanGreen),
            child: TextField(
              decoration: InputDecoration(
                hintText: '       Make a comment...',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            //bottomsheet -- friend list
          },
          child: Container(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/icons/sendIcon.svg',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            //bottomsheet -- report cancel
          },
          child: Container(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/icons/threeDotIcon.svg',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
