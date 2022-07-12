import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/notifications/notificationController.dart';
import 'package:snagom_app/pages/tags/tagController.dart';
import 'package:snagom_app/pages/tags/widgets/tagImageCard.dart';
import 'package:snagom_app/pages/tags/widgets/tagTextCard.dart';
import 'package:snagom_app/pages/tags/widgets/tagVideoCard.dart';
import 'package:snagom_app/userMain/userMain.dart';
import 'package:snagom_app/userMain/userMainController.dart';

class TagDetail extends StatefulWidget {
  String tagID;
  String tagName;
  String contentCount;
  String type;
  TagDetail(this.tagID, this.tagName, this.contentCount, this.type);
  @override
  _TagDetail createState() => _TagDetail();
}

class _TagDetail extends State<TagDetail> with SingleTickerProviderStateMixin {
  TagController tagController = Get.put(TagController());
  UserMainController mainController = Get.find();
  NotificationController notificationController = Get.find();
  BambooController bambooController = Get.find();
  TabController tabController;
  String type;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      initialIndex: 0,
      length: 2,
    );
    type = widget.type;
    tabController.addListener(() {
      if (tabController.index == 0) {
        tagController.getTagDetail(widget.tagID, 'BEST');
      } else {
        tagController.getTagDetail(widget.tagID, 'SHUFFLE');
      }
    });
    tagController.getTagDetail(widget.tagID, 'BEST');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              stretch: false,
              centerTitle: false,
              shadowColor: Colors.black,
              backgroundColor: colorScaffoldColor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: tabController,
                  labelPadding: EdgeInsets.only(left: 5, right: 5),
                  labelColor: Colors.yellow,
                  unselectedLabelColor: Colors.red,
                  tabs: [
                    Tab(
                      child: Container(
                        width: Get.width / 2 - 15,
                        child: Center(
                          child: Text(
                            'BEST',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: Get.width / 2 - 15,
                        child: Center(
                          child: Text(
                            'SHUFFLE',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  indicatorColor: oceanGreen,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: AppBar(
                  backgroundColor: colorScaffoldColor,
                  elevation: 0.1,
                  centerTitle: true,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/icons/backIcon.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  title: Column(
                    children: [
                      Text(
                        '#' + widget.tagName,
                        style: TextStyle(
                          color: colorBoldGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'total story: ' + widget.contentCount,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (type == '0') {
                            type = '1';
                            if (tabController.index == 0) {
                              tagController.changeTagType(widget.tagID, 'BEST');
                            } else {
                              tagController.changeTagType(
                                  widget.tagID, 'SHUFFLE');
                            }
                          } else {
                            type = '0';
                            if (tabController.index == 0) {
                              tagController.changeTagType(widget.tagID, 'BEST');
                            } else {
                              tagController.changeTagType(
                                  widget.tagID, 'SHUFFLE');
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8.0),
                        child: type == '0'
                            ? SvgPicture.asset(
                                'assets/icons/mediaIcon.svg',
                                height: 25,
                                width: 25,
                              )
                            : SvgPicture.asset(
                                'assets/icons/textIcon.svg',
                                height: 25,
                                width: 25,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            Obx(
              () => tagController.tagDetailLoading.value
                  ? Container()
                  : Container(
                      height: 1000,
                      child: ListView.builder(
                        itemCount: tagController.tagDetailList.value.length,
                        itemBuilder: (context, index) {
                          return tagController.tagDetailList.value[index]
                                      ['type'] ==
                                  0
                              ? !tagController.tagDetailList.value[index]
                                      ['isImage']
                                  ? TagVideoCard(
                                      tagController.tagDetailList[index])
                                  : TagImageCard(
                                      tagController.tagDetailList[index])
                              : TagTextCard(tagController.tagDetailList[index]);
                        },
                      ),
                    ),
            ),
            // Obx(
            //   () => tagController.tagDetailLoading.value
            //       ? Container()
            //       : Container(
            //           height: 1000,
            //           child: ListView.builder(
            //             itemCount: tagController.tagDetailList.value.length,
            //             itemBuilder: (context, index) {
            //               return tagController.tagDetailList.value[index]
            //                           ['type'] ==
            //                       0
            //                   ? TagImageCard(
            //                       tagController.tagDetailList[index])
            //                   : TagTextCard(
            //                       tagController.tagDetailList[index]);
            //             },
            //           ),
            //         ),
            // ),
            Obx(
              () => tagController.tagDetailLoading.value
                  ? Container()
                  : Container(
                      height: 1000,
                      child: ListView.builder(
                        itemCount: tagController.tagDetailList.value.length,
                        itemBuilder: (context, index) {
                          return tagController.tagDetailList.value[index]
                                      ['type'] ==
                                  0
                              ? !tagController.tagDetailList.value[index]
                                      ['isImage']
                                  ? TagVideoCard(
                                      tagController.tagDetailList[index])
                                  : TagImageCard(
                                      tagController.tagDetailList[index])
                              : TagTextCard(tagController.tagDetailList[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // body: Column(
      //   children: [
      //     ButtonsTabBar(
      //       controller: tabController,
      //       height: 50,
      //       backgroundColor: Colors.grey[300],
      //       unselectedBackgroundColor: Color(0xfff6f6f6),
      //       unselectedLabelStyle: TextStyle(color: Colors.black),
      //       labelStyle: TextStyle(color: Colors.white),
      //       tabs: [
      //         Tab(
      //           child: Container(
      //             width: Get.width / 2 - 15,
      //             child: Center(
      //               child: Text(
      //                 'BEST',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Tab(
      //           child: Container(
      //             width: Get.width / 2 - 15,
      //             child: Center(
      //               child: Text(
      //                 'SHUFFLE',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     Expanded(
      //       child: TabBarView(
      //         controller: tabController,
      //         children: <Widget>[
      //           Obx(
      //             () => tagController.tagDetailLoading.value
      //                 ? Container()
      //                 : Container(
      //                     height: 1000,
      //                     child: ListView.builder(
      //                       itemCount: tagController.tagDetailList.value.length,
      //                       itemBuilder: (context, index) {
      //                         return tagController.tagDetailList.value[index]
      //                                     ['type'] ==
      //                                 0
      //                             ? TagImageCard(
      //                                 tagController.tagDetailList[index])
      //                             : TagTextCard(
      //                                 tagController.tagDetailList[index]);
      //                       },
      //                     ),
      //                   ),
      //           ),
      //           // Obx(
      //           //   () => tagController.tagDetailLoading.value
      //           //       ? Container()
      //           //       : Container(
      //           //           height: 1000,
      //           //           child: ListView.builder(
      //           //             itemCount: tagController.tagDetailList.value.length,
      //           //             itemBuilder: (context, index) {
      //           //               return tagController.tagDetailList.value[index]
      //           //                           ['type'] ==
      //           //                       0
      //           //                   ? TagImageCard(
      //           //                       tagController.tagDetailList[index])
      //           //                   : TagTextCard(
      //           //                       tagController.tagDetailList[index]);
      //           //             },
      //           //           ),
      //           //         ),
      //           // ),
      //           Obx(
      //             () => tagController.tagDetailLoading.value
      //                 ? Container()
      //                 : Container(
      //                     height: 1000,
      //                     child: ListView.builder(
      //                       itemCount: tagController.tagDetailList.value.length,
      //                       itemBuilder: (context, index) {
      //                         return tagController.tagDetailList.value[index]
      //                                     ['type'] ==
      //                                 0
      //                             ? TagImageCard(
      //                                 tagController.tagDetailList[index])
      //                             : TagTextCard(
      //                                 tagController.tagDetailList[index]);
      //                       },
      //                     ),
      //                   ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
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
              Get.offAll(UserMain());
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
