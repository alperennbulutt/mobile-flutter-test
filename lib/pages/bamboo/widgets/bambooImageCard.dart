import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BambooImageCard extends StatelessWidget {
  var json;
  BambooImageCard(this.json);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        json['imageUrl'],
        height: Get.height,
        width: Get.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
