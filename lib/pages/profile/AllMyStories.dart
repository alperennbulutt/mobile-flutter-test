import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/profile/profileController.dart';
import 'package:snagom_app/widgets/fullScreenStory.dart';
import 'package:snagom_app/widgets/profileVideoCard.dart';
import 'package:snagom_app/widgets/videoCard.dart';

class AllMyStories extends StatelessWidget {
  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    profileController.getMyAllStories();
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          tabs(),
          SizedBox(height: 5),
          Obx(
            () => profileController.myAllStoriesLoading.value
                ? Container()
                : profileController.profileTabbarIndex.value == 0
                    ? Expanded(
                        child: Container(
                          child: GridView.count(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: List.generate(
                              profileController.myAllMediaStories.value.length,
                              (index) => postMediaCard(profileController
                                  .myAllMediaStories.value[index]),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return postTextCard(
                                profileController.myAllTextStories.value[index],
                              );
                            },
                            itemCount:
                                profileController.myAllTextStories.value.length,
                          ),
                        ),
                      ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: colorScaffoldColor,
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            child: SvgPicture.asset(
              'assets/icons/backIcon.svg',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
      title: Text(
        'My Stories',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  tabs() {
    return Row(
      children: [
        tab('mediaIcon', 0),
        tab('textIcon', 1),
        //  tab('videoIcon', 2),
      ],
    );
  }

  postTextCard(var json) {
    return GestureDetector(
      onTap: () {
        Get.to(FullScreenStory(json));
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
        child: GestureDetector(
          child: Container(
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: json['user']['image'] == null
                            ? NetworkImage(profileIcon)
                            : NetworkImage(json['user']['image']),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                Row(
                  children: [
                    CircleAvatar(
                        radius: 20, backgroundColor: Colors.transparent),
                    SizedBox(width: 10),
                    Container(
                      width: Get.width * 0.7,
                      child: Text(
                        json['description'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  postMediaCard(var json) {
    return !json['isImage']
        ? ProfileVideoCard(json)
        : GestureDetector(
            onTap: () {
              Get.to(FullScreenStory(json));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    Image.network(
                      json['imageUrl'],
                      height: Get.height * 0.17,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            DateTime.parse(json['created'])
                                .toString()
                                .split(' ')[0],
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

  tab(String icon, int index) {
    return Obx(
      () => Expanded(
        child: InkWell(
          onTap: () {
            profileController.profileTabbarIndex.value = index;
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: index == profileController.profileTabbarIndex.value
                  ? Colors.grey[300]
                  : Colors.transparent,
              border: Border.all(
                width: 0.5,
                color: Colors.grey[300],
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/$icon.svg',
                height: 20,
                width: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
