import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BambooVideoCard extends StatefulWidget {
  var json;
  BambooVideoCard(this.json);
  @override
  _BambooVideoCard createState() => _BambooVideoCard();
}

class _BambooVideoCard extends State<BambooVideoCard> {
  VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.json['imageUrl'])
      ..initialize().then((_) {
        setState(() {
          print('init video');
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Container(
        child: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  backgroundColor: !_controller.value.isPlaying
                      ? Colors.white
                      : Colors.transparent,
                  radius: 20,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: !_controller.value.isPlaying
                        ? Colors.black
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
