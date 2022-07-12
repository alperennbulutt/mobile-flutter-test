import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/models/storyModel.dart';

class StoryTextCard extends StatelessWidget {
  Story story;
  StoryTextCard(this.story);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Center(
        child: Text(
          story.description,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
