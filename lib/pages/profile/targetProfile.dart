import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'package:snagom_app/pages/notifications/notificationController.dart';
import 'package:snagom_app/pages/profile/profileController.dart';
import 'package:snagom_app/pages/story/storyScreen.dart';
import 'package:snagom_app/userMain/userMain.dart';
import 'package:snagom_app/userMain/userMainController.dart';
import 'package:snagom_app/widgets/fullScreenStory.dart';
import 'package:snagom_app/widgets/profilePopUpVideoCard.dart';
import 'package:snagom_app/widgets/profileVideoCard.dart';

class TargetProfile extends StatelessWidget {
  String profileID;
  TargetProfile(this.profileID);
  ProfileController profileController = Get.put(ProfileController());
  UserMainController mainController = Get.find();
  MessageController messageController = Get.find();
  NotificationController notificationController = Get.find();
  BambooController bambooController = Get.find();
  @override
  Widget build(BuildContext context) {
    profileController.getProfileDatas(profileID);
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      body: Obx(
        () => Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: Get.height * 0.2,
                  pinned: false,
                  snap: false,
                  floating: false,
                  primary: false,
                  elevation: 0,
                  centerTitle: true,
                  toolbarHeight: Get.height * 0.27,
                  leadingWidth: 0,
                  titleSpacing: 0,
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                  title: Container(
                    height: Get.height * 0.27,
                    width: Get.width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Image.network(
                            profileController.targetProfileDatas
                                        .value['coverImageUrl']
                                        .toString() ==
                                    'null'
                                ? 'https://galeri14.uludagsozluk.com/854/kapak-fotografi-yapilabilecek-fotograflar_1959425.png'
                                : profileController
                                    .targetProfileDatas.value['coverImageUrl'],
                            height: Get.height * 0.2,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              child: SvgPicture.asset(
                                'assets/icons/backIcon.svg',
                                height: 30,
                                width: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/icons/threeDotIcon.svg',
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                if (!profileController
                                        .profileActiveStoriesLoading.value &&
                                    profileController
                                            .profileActiveStories.length !=
                                        0) {
                                  Get.to(StoryScreen(
                                      stories: profileController
                                          .profileActiveStories.value));
                                }
                              },
                              child: Container(
                                height: Get.height * 0.15,
                                width: Get.height * 0.15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: !profileController
                                          .profileActiveStoriesLoading.value
                                      ? profileController.profileActiveStories
                                                  .length ==
                                              0
                                          ? LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.grey,
                                                Colors.grey,
                                              ],
                                            )
                                          : LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                colorLightGreen,
                                                colorGrassGreen,
                                              ],
                                            )
                                      : null,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    child: Container(
                                      height: Get.height * 0.13,
                                      width: Get.height * 0.13,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: profileController
                                                      .targetProfileDatas ==
                                                  null
                                              ? NetworkImage(profileIcon)
                                              : NetworkImage(profileController
                                                              .targetProfileDatas[
                                                          'imageUrl'] ==
                                                      null
                                                  ? profileIcon
                                                  : profileController
                                                          .targetProfileDatas[
                                                      'imageUrl']),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => profileController.profileLoading.value
                      ? SliverToBoxAdapter()
                      : SliverToBoxAdapter(
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  profileController
                                      .targetProfileDatas['fullName']
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                profileController
                                                .targetProfileDatas['biography']
                                                .toString() ==
                                            'null' ||
                                        profileController
                                                .targetProfileDatas['biography']
                                                .toString() ==
                                            ''
                                    ? Container()
                                    : Text(
                                        profileController
                                            .targetProfileDatas['biography']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Container(
                                    height: 0.5,
                                    width: 50,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      statistics(
                                          'hearthIcon',
                                          profileController
                                              .targetProfileDatas['likeCount']
                                              .toString()),
                                      SizedBox(width: 5),
                                      statistics(
                                          'peopleInside',
                                          profileController.targetProfileDatas[
                                                  'followerCount']
                                              .toString()),
                                      SizedBox(width: 5),
                                      statistics(
                                          'peopleOutside',
                                          profileController.targetProfileDatas[
                                                  'followingCount']
                                              .toString()),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: Get.width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: oceanGreen),
                                        color: Colors.white,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          profileController.isFollowed.value =
                                              !profileController
                                                  .isFollowed.value;
                                          profileController
                                              .onFollowButtonPressed(profileID);
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0),
                                            child: profileController
                                                    .isFollowed.value
                                                ? Text('Following')
                                                : Text('Follow'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        messageController.getMyLastConversation(
                                          profileController
                                              .targetProfileDatas.value,
                                        );
                                      },
                                      child: Container(
                                        width: Get.width / 3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: messageController
                                                  .isMyLastConversationLoading
                                                  .value
                                              ? CupertinoActivityIndicator()
                                              : Text('Message'),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                tabs(),
                              ],
                            ),
                          ),
                        ),
                ),
                SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
                Obx(
                  () => profileController.profilePostsLoading.value
                      ? SliverToBoxAdapter()
                      : profileController.profileTabbarIndex.value == 0
                          ? profileController.targetProfileMediaPosts.length ==
                                  0
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Text('There is no media post'),
                                  ),
                                )
                              : SliverGrid.count(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                    profileController
                                        .targetProfileMediaPosts.length,
                                    (index) => postMediaCard(profileController
                                        .targetProfileMediaPosts[index]),
                                  ),
                                )
                          : profileController.targetProfileTextPosts.length == 0
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Text('There is no twit post'),
                                  ),
                                )
                              : SliverGrid.count(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                    profileController
                                        .targetProfileTextPosts.length,
                                    (index) => postTextCard(profileController
                                        .targetProfileTextPosts[index]),
                                  ),
                                ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 50)),
              ],
            ),
            profileController.popupShow.value
                ? Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: Get.height,
                        width: Get.width,
                        color: Colors.white.withOpacity(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileController.popUpData['isImage']
                                ? Image.network(
                                    profileController.popUpData['imageUrl'],
                                    width: Get.width,
                                    height: Get.height * 0.5,
                                    fit: BoxFit.cover,
                                  )
                                : ProfilePopUpVideoCard(
                                    profileController.popUpData),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buttons(
                                    'commentIcon.svg',
                                    false,
                                    profileController.popUpData['commentCount']
                                        .toString()),
                                SizedBox(width: 10),
                                buttons(
                                    'hearthIcon.svg',
                                    profileController.popUpData['isLiked'],
                                    profileController.popUpData['likeCount']
                                        .toString()),
                                SizedBox(width: 10),
                                buttons(
                                    'viewIcon.svg',
                                    false,
                                    profileController.popUpData['viewCount']
                                        .toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  buttons(String icon, bool colorful, String count) {
    return Row(
      children: [
        Container(
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
        SizedBox(width: 5),
        Text(count)
      ],
    );
  }

  postTextCard(var json) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            json['user']['imageUrl'].toString() == 'null'
                ? profileIcon
                : json['user']['imageUrl'],
          ),
          backgroundColor: Colors.transparent,
        ),
        title: Text(json['user']['fullName']),
        subtitle: Text(
          json['description'],
        ),
      ),
    );
  }

  postMediaCard(var json) {
    return HoldDetector(
      onHold: () {
        profileController.popupShow.value = true;
        profileController.popUpData.value = json;
      },
      onCancel: () {
        profileController.popUpData.value = {};
        profileController.popupShow.value = false;
      },
      onTap: () {},
      child: !json['isImage']
          ? ProfileVideoCard(json)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(FullScreenStory(json));
                },
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
            ),
    );
  }

  tabs() {
    return Row(
      children: [
        tab('mediaIcon', 0),
        tab('textIcon', 1),
        //   tab('videoIcon', 2),
      ],
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

  statistics(String icon, String count) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/$icon.svg',
          height: 20,
          width: 20,
        ),
        Text('  $count'),
      ],
    );
  }

  bottomNavBar() {
    return Container(
      height: 60,
      width: Get.width,
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xff998eaf),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              mainController.bodyIndex.value = 0;
              Get.offAll(UserMain());
            },
            child: SvgPicture.asset(
              'assets/icons/homeIcon.svg',
              height: 30,
              width: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              mainController.bodyIndex.value = 1;
              Get.offAll(UserMain());
            },
            child: SvgPicture.asset(
              'assets/icons/searchIcon.svg',
              height: 30,
              width: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (bambooController.nonBambooStories.value.length == 0 &&
                  bambooController.bambooLoading.value == false) {
                Get.snackbar('Warning',
                    'Bamboo alanini kullanabilmek icin son 24 saat icerisinde icerik paylasmis olmalisiniz.');
              } else if (bambooController.bambooLoading.value == false) {
                mainController.bodyIndex.value = 2;
                Get.offAll(UserMain());
              }
            },
            child: Container(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  height: 30,
                  width: 30,
                  color: bambooController.nonBambooStories.value.length == 0
                      ? Colors.black
                      : null,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              mainController.bodyIndex.value = 3;
              Get.offAll(UserMain());
            },
            child: Container(
              height: 50,
              width: 50,
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Image.asset(
                      'assets/icons/notificationIcon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  notificationController.unSeenNotificationCount.value == 0
                      ? Container()
                      : Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(notificationController
                                  .unSeenNotificationCount.value
                                  .toString()),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              mainController.bodyIndex.value = 4;
              Get.offAll(UserMain());
            },
            child: Container(
              height: 50,
              width: 50,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      GetStorage().read('UserData')['imageUrl'].toString() ==
                              'null'
                          ? profileIcon
                          : GetStorage().read('UserData')['imageUrl'],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
