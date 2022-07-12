import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/story/storyController.dart';

class StoryTabCard extends StatefulWidget {
  List stories;
  int index;
  StoryTabCard(this.stories, this.index);
  @override
  _StoryTabCard createState() => _StoryTabCard();
}

class _StoryTabCard extends State<StoryTabCard> {
  double tabWidth;
  StoryController storyController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabWidth =
        (Get.width / widget.stories.length) - (widget.stories.length * 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    storyController.activeStoryIndex.value = 0;
  }

  progressBarDuration() {
    Timer(Duration(seconds: 15), () {
      if (widget.stories.length - 1 != storyController.activeStoryIndex.value) {
        storyController.activeStoryIndex.value++;
      } else {
        Get.back();
      }
    });
  }

  progressBar() {
    progressBarDuration();

    return Container(
      height: 5,
      width: tabWidth,
      child: FAProgressBar(
        size: 25,
        backgroundColor: Colors.white,
        currentValue: 100,
        progressColor: Color(0xFF228b22),
        changeProgressColor: Color(0xFF228b22),
        animatedDuration: Duration(seconds: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: storyController.activeStoryIndex.value == widget.index
            ? progressBar()
            : storyController.activeStoryIndex.value > widget.index
                ? Container(
                    height: 5,
                    width: tabWidth,
                    decoration: BoxDecoration(
                      color: Color(0xFF228b22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : Container(
                    height: 5,
                    width: tabWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
      ),
    );
  }
}
