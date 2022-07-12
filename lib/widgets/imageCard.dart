import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';

class ImageCard extends StatefulWidget {
  var json;
  ImageCard(this.json);
  @override
  _TagImageCard createState() => _TagImageCard(json);
}

class _TagImageCard extends State<ImageCard> {
  var json;
  _TagImageCard(this.json);
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
                          GetStorage().read('UserData')['id'],
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
                    Image.network(
                      json['imageUrl'],
                      height: Get.height * 0.4,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                bottom: 0,
                left: 10,
                child: Row(
                  children: [
                    buttons('commentIcon.svg', false,
                        json['commentCount'].toString()),
                    SizedBox(width: 15),
                    buttons(
                        'hearthIcon.svg', false, json['likeCount'].toString()),
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
              Get.to(CommentPage(
                json['id'],
              ));
              setState(() {});
            }
            if (icon == 'hearthIcon.svg') {
              TagController tagController = Get.put(TagController());

              tagController.likePost(json['id']);
              setState(() {
                colorful = !colorful;
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
              gradient: json['isLiked'] && icon == 'hearthIcon.svg'
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorLightGreen,
                        colorGrassGreen,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffececec), Color(0xffececec)],
                    ),
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
