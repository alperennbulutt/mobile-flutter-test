import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';

class PostCard extends StatefulWidget {
  var json;
  PostCard(this.json);
  @override
  _PostCard createState() => _PostCard(json);
}

class _PostCard extends State<PostCard> {
  var json;
  _PostCard(this.json);
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
          height: Get.height * 0.57,
          child: Stack(
            children: [
              Container(
                height: Get.height * 0.53,
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
                          unpin: true,
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
                    json['type'] == 0
                        ? Image.network(
                            json['imageUrl'],
                            height: Get.height * 0.4,
                            width: Get.width,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: Get.height * 0.4,
                            width: Get.width,
                            child: Center(
                              child: Text(
                                json['description'],
                              ),
                            ),
                          ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
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
                                      json['deadline'].toString().toLowerCase(),
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
                              )
                            ],
                          ),
                        ],
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
              Positioned(
                  right: 0,
                  bottom: 15,
                  child: buttons(
                    'shareIcon.svg',
                    false,
                    '',
                  ))
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
