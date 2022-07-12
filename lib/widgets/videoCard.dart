import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  var json;
  VideoCard(this.json);
  @override
  _TagVideoCard createState() => _TagVideoCard(json);
}

class _TagVideoCard extends State<VideoCard> {
  var json;
  _TagVideoCard(this.json);
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
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
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
          height: 135 + Get.height * 0.4,
          child: Stack(
            children: [
              Container(
                height: 115 + Get.height * 0.4,
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
                        ? Container(
                            height: Get.height * 0.4,
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController),
                            ),
                          )
                        : Container(),
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
                                  ],
                                )
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
                bottom: 15,
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
              //     bottom: 15,
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
              Get.to(CommentPage(
                json['id'],
              ));
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
