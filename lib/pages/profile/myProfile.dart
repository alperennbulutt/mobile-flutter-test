import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/profile/AllMyStories.dart';
import 'package:snagom_app/pages/profile/profileController.dart';
import 'package:snagom_app/pages/profile/Settings/profileSettings.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/story/storyScreen.dart';
import 'package:snagom_app/widgets/fullScreenStory.dart';
import 'package:snagom_app/widgets/profilePopUpVideoCard.dart';
import 'package:snagom_app/widgets/profileVideoCard.dart';

class MyProfile extends StatelessWidget {
  ProfileController profileController = Get.put(ProfileController());
  Map profileData;
  @override
  Widget build(BuildContext context) {
    profileData = GetStorage().read('UserData');

    profileController.getMyProfileData(profileData['id']);
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  primary: false,
                  expandedHeight: Get.height * 0.2,
                  pinned: false,
                  snap: false,
                  floating: false,
                  elevation: 0,
                  centerTitle: true,
                  toolbarHeight: Get.height * 0.27,
                  titleSpacing: 0,
                  title: Container(
                    height: Get.height * 0.27,
                    width: Get.width,
                    color: colorScaffoldColor,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              profileController.popup(
                                  profileController
                                      .myProfileData['coverImageUrl'],
                                  true);
                            },
                            child: Image.network(
                              profileController.myProfileData['coverImageUrl'],
                              height: Get.height * 0.2,
                              width: Get.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(ProfileSettings());
                            },
                            child: SvgPicture.asset(
                              'assets/icons/profileSettings.svg',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(AllMyStories());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.pin_drop_outlined),
                              ),
                            ),
                          ),
                        ),
                        Align(
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
                            onDoubleTap: () {
                              if (profileController.myProfileData['imageUrl'] ==
                                  null) {
                                profileController.myProfileData['imageUrl'] =
                                    profileIcon;
                              }
                              profileController.popup(
                                  profileController.myProfileData['imageUrl'],
                                  false);
                            },
                            child: Container(
                              height: Get.height * 0.15,
                              width: Get.height * 0.15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: !profileController
                                        .profileActiveStoriesLoading.value
                                    ? profileController
                                                .profileActiveStories.length ==
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
                                                            .myProfileData[
                                                        'imageUrl'] ==
                                                    null
                                                ? profileIcon
                                                : profileController
                                                    .myProfileData['imageUrl']),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          profileController.myProfileData['fullName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        profileController.myProfileData['biography'] == null ||
                                profileController.myProfileData['biography'] ==
                                    ''
                            ? Container()
                            : Text(
                                profileController.myProfileData['biography']
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                  profileController.myProfileData['likeCount']
                                      .toString()),
                              SizedBox(width: 5),
                              statistics(
                                  'peopleInside',
                                  profileController
                                      .myProfileData['followerCount']
                                      .toString()),
                              SizedBox(width: 5),
                              statistics(
                                  'peopleOutside',
                                  profileController
                                      .myProfileData['followingCount']
                                      .toString()),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        tabs(),
                      ],
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
                                        .targetProfileMediaPosts.value.length,
                                    (index) => postMediaCard(profileController
                                        .targetProfileMediaPosts.value[index]),
                                  ),
                                )
                          : profileController.targetProfileTextPosts.length == 0
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Text('There is no twit post'),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return postTextCard(
                                        profileController.targetProfileTextPosts
                                            .value[index],
                                      );
                                    },
                                    childCount: profileController
                                        .targetProfileTextPosts.value.length,
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
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
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
                            json['location'],
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
                CircleAvatar(radius: 20, backgroundColor: Colors.transparent),
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
    );
  }

  postMediaCard(var json) {
    return HoldDetector(
      onTap: () {
        // Get.to(
        //     ProfileFeed(profileController.targetProfileMediaPosts.value, true));
      },
      onHold: () {
        profileController.popupShow.value = true;
        profileController.popUpData.value = json;
      },
      onCancel: () {
        profileController.popUpData.value = {};
        profileController.popupShow.value = false;
      },
      enableHapticFeedback: true,
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
        //  tab('videoIcon', 2),
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
}
