import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryImageCard extends StatelessWidget {
  Map json;
  StoryImageCard(this.json);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Center(
        child: Image.network(
          json['imageUrl'],
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
