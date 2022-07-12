import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryVideoCard extends StatefulWidget {
  Map json;
  StoryVideoCard(this.json);
  @override
  _StoryVideoCard createState() => _StoryVideoCard();
}

class _StoryVideoCard extends State<StoryVideoCard> {
  VideoPlayerController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.network(widget.json['imageUrl'])
      ..initialize().then((_) {
        controller.setLooping(false);

        setState(() {
          controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : Container(),
    );
  }
}
