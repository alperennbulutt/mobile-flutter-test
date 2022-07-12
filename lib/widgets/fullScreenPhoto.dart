import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';

class FullScreenPhoto extends StatelessWidget {
  String photoUrl;
  FullScreenPhoto(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScaffoldColor,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              child: SvgPicture.asset(
                'assets/icons/backIcon.svg',
                height: 30,
                width: 30,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Image.network(
          photoUrl,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
