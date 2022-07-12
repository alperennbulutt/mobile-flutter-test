import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/bamboo/bambooPage.dart';
import 'package:snagom_app/pages/homepage/homepage.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'package:snagom_app/pages/messages/messageList.dart';
import 'package:snagom_app/pages/notifications/notificationController.dart';
import 'package:snagom_app/pages/notifications/notificationPage.dart';
import 'package:snagom_app/pages/profile/myProfile.dart';
import 'package:snagom_app/pages/search/searchScreen.dart';
import 'package:snagom_app/pages/story/storyScreen.dart';
import 'package:snagom_app/userMain/userMainController.dart';

class UserMain extends StatelessWidget {
  UserMainController mainController = Get.put(UserMainController());
  NotificationController notificationController =
      Get.put(NotificationController());
  BambooController bambooController = Get.put(BambooController());
  MessageController messageController = Get.put(MessageController());
  String profileImage;
  List pages = [
    HomePage(),
    SearchScreen(),
    BambooPage(),
    NotificationPage(),
    MyProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    print(GetStorage().read('UserData'));
    try {
      if (GetStorage().read('UserData')['imageUrl'].toString() == 'null') {
        profileImage = profileIcon;
      } else {
        profileImage = GetStorage().read('UserData')['imageUrl'];
      }
    } catch (e) {
      profileImage = profileIcon;
    }
    return Obx(
      () => Scaffold(
        appBar: mainController.bodyIndex.value == 4 ||
                mainController.bodyIndex.value == 2 ||
                mainController.bodyIndex.value == 1
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                centerTitle: true,
                leading: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if (!mainController.profileActiveStoriesLoading.value &&
                        mainController.profileActiveStories.length != 0) {
                      Get.to(StoryScreen(
                        stories: mainController.profileActiveStories.value,
                      ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4,
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor:
                          mainController.profileActiveStories.length == 0
                              ? colorScaffoldColor
                              : colorLightGreen,
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profileImage),
                      ),
                    ),
                  ),
                ),
                title: SvgPicture.asset(
                  'assets/icons/appBarLogo.svg',
                  width: 150,
                  fit: BoxFit.fitWidth,
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Get.to(MessageList());
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 12.0, bottom: 4),
                            child: SvgPicture.asset(
                              'assets/icons/messageIcon.svg',
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        messageController.myMessageBoxesLoading.value ||
                                messageController
                                        .myUnreadMessagesLength.value ==
                                    0
                            ? Container()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: Text(
                                        messageController.myUnreadMessagesLength
                                                    .value ==
                                                0
                                            ? ''
                                            : messageController
                                                .myUnreadMessagesLength.value
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
        body: pages[mainController.bodyIndex.value],
        bottomNavigationBar: Container(
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
                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/icons/homeIcon.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  mainController.bodyIndex.value = 1;
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/icons/searchIcon.svg',
                      height: 30,
                      width: 30,
                    ),
                  ),
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
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 10,
                        child: notificationController
                                    .unSeenNotificationCount.value ==
                                0
                            ? Image.asset(
                                'assets/icons/notificationIcon.png',
                                height: 30,
                                width: 30,
                              )
                            : Image.asset(
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
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(profileImage),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
