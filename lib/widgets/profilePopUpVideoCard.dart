import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'fullScreenStory.dart';

class ProfilePopUpVideoCard extends StatefulWidget {
  Map json;
  ProfilePopUpVideoCard(this.json);
  @override
  _ProfileVideoCard createState() => _ProfileVideoCard(json);
}

class _ProfileVideoCard extends State<ProfilePopUpVideoCard> {
  Map json;
  _ProfileVideoCard(this.json);
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(json['imageUrl'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          videoPlayerController.play();
          videoPlayerController.setLooping(true);
          videoPlayerController.setVolume(0);
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: Get.width,
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: Colors.grey[200],
              spreadRadius: 4,
              blurRadius: 2,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            videoPlayerController.value.isInitialized
                ? Container(
                    width: Get.width,
                    height: Get.height * 0.5,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    ),
                  )
                : Container(
                    width: Get.width,
                    height: Get.height * 0.5,
                  ),
          ],
        ),
      ),
    );
  }
}
