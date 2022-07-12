import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentPage.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/tags/tagController.dart';
import 'package:path_provider/path_provider.dart';

class TagImageCard extends StatefulWidget {
  var json;
  TagImageCard(this.json);
  @override
  _TagImageCard createState() => _TagImageCard(json);
}

class _TagImageCard extends State<TagImageCard> {
  var json;
  _TagImageCard(this.json);
  File file;
  var decodedImage;
  bool loading = false;
  double imageHeight = 400;
  getImage() async {
    file = await urlToFile(json['imageUrl']);
    decodedImage = await decodeImageFromList(file.readAsBytesSync());
    imageHeight = double.parse(decodedImage.height.toString());
    setState(() {
      if (imageHeight * 1.5 > Get.height) {
        imageHeight = imageHeight / 3;
      } else if (imageHeight * 1.2 > Get.height) {
        imageHeight = imageHeight / 2;
      }
      loading = false;
    });
    file.delete();
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getImage();
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
                    Image.network(
                      json['imageUrl'],
                      height: imageHeight,
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
                                Container(
                                  child: Row(
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
    RxInt commentCount = 0.obs;
    commentCount.value = json['commentCount'];
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
        Text(count),
      ],
    );
  }
}
