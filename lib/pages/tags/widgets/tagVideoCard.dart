import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';
import 'package:video_player/video_player.dart';

class TagVideoCard extends StatefulWidget {
  var json;
  TagVideoCard(this.json);
  @override
  _TagVideoCard createState() => _TagVideoCard(json);
}

class _TagVideoCard extends State<TagVideoCard> {
  var json;
  _TagVideoCard(this.json);
  VideoPlayerController videoPlayerController;
  bool loading = true;
  double imageHeight = 300;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(json['imageUrl'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          imageHeight = videoPlayerController.value.size.height;

          videoPlayerController.setLooping(false);

          if (imageHeight * 1.5 > Get.height) {
            imageHeight = imageHeight / 3;
          }
          if (imageHeight * 1.2 > Get.height) {
            imageHeight = imageHeight / 2;
          }
          loading = false;
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
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
      child: GestureDetector(
        onDoubleTap: () {
          TagController tagController = Get.find();

          tagController.likePost(json['id']);
          setState(() {
            if (json['isLiked']) {
              json['likeCount']--;
              json['isLiked'] = false;
            } else {
              json['likeCount']++;
              json['isLiked'] = true;
            }
          });
        },
        child: Container(
          height: 135 + imageHeight,
          child: Stack(
            children: [
              Container(
                height: 115 + imageHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        TagController tagController = Get.put(TagController());
                        tagController.threeDotPopUp(
                          json['user']['userId'],
                          json['id'],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            'assets/icons/threeDotIcon.svg',
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    videoPlayerController.value.isInitialized
                        ? GestureDetector(
                            onTap: () {
                              if (videoPlayerController.value.isPlaying) {
                                videoPlayerController.pause();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                videoPlayerController.play();
                                setState(() {
                                  isPlaying = true;
                                });
                              }
                            },
                            child: Container(
                              height: imageHeight,
                              child: Stack(
                                children: [
                                  Center(
                                    child: AspectRatio(
                                      aspectRatio: videoPlayerController
                                          .value.aspectRatio,
                                      child: VideoPlayer(videoPlayerController),
                                    ),
                                  ),
                                  isPlaying
                                      ? Container()
                                      : Center(
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.grey,
                                            size: 100,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          )
                        : CupertinoActivityIndicator(),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(TargetProfile(json['user']['userId']));
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage: json['user']['image'] == null
                                    ? NetworkImage(profileIcon)
                                    : NetworkImage(json['user']['image']),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      //name
                                      Text(
                                        json['user']['fullName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      //username
                                      // Text(
                                      //   json['user']['nickname'],
                                      //   style: TextStyle(
                                      //     fontWeight: FontWeight.w100,
                                      //     fontSize: 10,
                                      //   ),
                                      // ),
                                      SizedBox(width: 5),
                                      //time
                                      Text(
                                        json['deadline']
                                            .toString()
                                            .toLowerCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 4,
                                      color: colorPurple,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      json['tag']['name'],
                                      style: TextStyle(
                                        color: colorPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      json['description'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  json['location'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 10,
                child: Row(
                  children: [
                    buttons('commentIcon.svg', false,
                        json['commentCount'].toString()),
                    SizedBox(width: 15),
                    buttons('hearthIcon.svg', json['isLiked'],
                        json['likeCount'].toString()),
                    SizedBox(width: 15),
                    buttons(
                        'viewIcon.svg', false, json['viewCount'].toString()),
                  ],
                ),
              ),
              // Positioned(
              //     right: 0,
              //     bottom: 0,
              //     child: buttons(
              //       'shareIcon.svg',
              //       false,
              //       '',
              //     ))
            ],
          ),
        ),
      ),
    );
  }

  buttons(String icon, bool colorful, String count) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (icon == 'commentIcon.svg') {
              Get.to(CommentPage(json['id']));
              setState(() {});
            }
            if (icon == 'hearthIcon.svg') {
              TagController tagController = Get.find();

              tagController.likePost(json['id']);
              setState(() {
                if (json['isLiked']) {
                  json['likeCount']--;
                  json['isLiked'] = false;
                } else {
                  json['likeCount']++;
                  json['isLiked'] = true;
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorful ? null : Color(0xffececec),
              gradient: colorful
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorLightGreen,
                        colorGrassGreen,
                      ],
                    )
                  : null,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/icons/$icon',
                height: 15,
                width: 15,
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(count)
      ],
    );
  }
}
