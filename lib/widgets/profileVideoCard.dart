import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'fullScreenStory.dart';

class ProfileVideoCard extends StatefulWidget {
  Map json;
  ProfileVideoCard(this.json);
  @override
  _ProfileVideoCard createState() => _ProfileVideoCard(json);
}

class _ProfileVideoCard extends State<ProfileVideoCard> {
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
      child: GestureDetector(
        onTap: () {
          Get.to(FullScreenStory(json));
        },
        child: Container(
          height: Get.height * 0.2,
          width: Get.height * 0.2,
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
                      height: Get.height * 0.17,
                      width: Get.width,
                      child: AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    )
                  : Container(
                      height: Get.height * 0.17,
                      width: Get.width,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DateTime.parse(json['created']).toString().split(' ')[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '#' + json['tag']['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
