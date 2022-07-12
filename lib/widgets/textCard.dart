import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';

class TextCard extends StatefulWidget {
  var json;
  TextCard(this.json);
  @override
  _TagTextCard createState() => _TagTextCard(json);
}

class _TagTextCard extends State<TextCard> {
  var json;
  _TagTextCard(this.json);
  double descheight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descheight = ((json['description'].length) / 35).ceil() * 20.0;
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
          height: 135 + descheight,
          child: Stack(
            children: [
              Container(
                height: 115 + descheight,
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
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 20, backgroundColor: Colors.transparent),
                        SizedBox(width: 10),
                        Container(
                          height: descheight,
                          width: Get.width * 0.7,
                          child: Text(
                            json['description'],
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  width: Get.width * 0.9,
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
                      // Spacer(),
                      // buttons('shareIcon.svg', false, ''),
                      // SizedBox(width: 15)
                    ],
                  ),
                ),
              ),
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
              setState(() {});
            }
            if (icon == 'hearthIcon.svg') {
              TagController tagController = Get.put(TagController());

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
