import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BambooTextCard extends StatelessWidget {
  var json;
  BambooTextCard(this.json);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Text(
            json['description'],
            //textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
