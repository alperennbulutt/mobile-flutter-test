import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/addContent/addContentController.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class SeeMedia extends StatefulWidget {
  File videoFile;
  File photoFile;
  bool isVideo;
  SeeMedia({this.videoFile, this.photoFile, this.isVideo});
  @override
  _SeeMedia createState() => _SeeMedia();
}

class _SeeMedia extends State<SeeMedia> {
  AddContentController addContentController = Get.put(AddContentController());
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isVideo) {
      videoPlayerController = VideoPlayerController.file(widget.videoFile)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            videoPlayerController.play();
            videoPlayerController.setLooping(true);
          });
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isVideo) {
      videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          widget.isVideo
              ? Center(
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.size != null
                        ? videoPlayerController.value.aspectRatio
                        : 1.0,
                    child: VideoPlayer(videoPlayerController),
                  ),
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.file(
                    widget.photoFile,
                    fit: BoxFit.cover,
                    height: Get.height,
                    width: Get.width,
                  ),
                ),
          Positioned(
            top: 40,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[500],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/icons/cancelIcon.svg',
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 10,
            child: GestureDetector(
              onTap: () {
                if (widget.isVideo) {
                  addContentController.uploadVideo(widget.videoFile);
                } else {
                  addContentController.uploadImage(widget.photoFile);
                }
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      colorLightGreen,
                      colorGrassGreen,
                    ],
                  ),
                ),
                child: Obx(
                  () => addContentController.fileLoading.value
                      ? Container(
                          height: 15,
                          width: 15,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 40),
                            child: CupertinoActivityIndicator(),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(height: 15, width: 15),
                            Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/arrowRight.svg',
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
