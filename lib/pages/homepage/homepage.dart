import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/addContent/CamereViewVideo.dart';
import 'package:snagom_app/pages/addContent/addContentController.dart';
import 'package:snagom_app/pages/addContent/addContentText.dart';
import 'package:snagom_app/pages/homepage/homePageController.dart';
import 'package:snagom_app/pages/tags/tagDetail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  HomePageController homePageController = Get.put(HomePageController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tabController.addListener(() {
    //   setState(() {
    //     if (tabController.index == 0) {
    //       if (homePageController.selectedSubIndex.value == 0) {
    //         homePageController.getTagList('general', 'media');
    //       } else {
    //         homePageController.getTagList('general', 'text');
    //       }
    //     } else {
    //       if (homePageController.selectedSubIndex.value == 0) {
    //         homePageController.getTagList('friend', 'media');
    //       } else {
    //         homePageController.getTagList('friend', 'text');
    //       }
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: (details) {
          // Swiping in right direction.
          if (details.delta.dx > 0) {
            AddContentController addContentController =
                Get.put(AddContentController());
            addContentController.cameraSubIndex.value = 0;
            Get.to(CameraViewVideo());
          }

          // Swiping in left direction.
          if (details.delta.dx < 0) {
            AddContentController addContentController =
                Get.put(AddContentController());
            addContentController.cameraSubIndex.value = 1;
            Get.to(AddContentText());
          }
        },
        child: Column(
          children: [
            topBar(),
            Container(
              height: 1,
              width: Get.width,
              color: Colors.grey[200],
            ),
            Obx(
              () => homePageController.error.value
                  ? Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            homePageController.errorString.value,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    )
                  : pageContent(),
            )
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: IconButton(
                onPressed: () {
                  if (homePageController.selectedIndex.value == 0) {
                    homePageController.selectedIndex.value = 1;
                  } else {
                    homePageController.selectedIndex.value = 0;
                  }
                  if (homePageController.selectedIndex.value == 0) {
                    if (homePageController.selectedSubIndex.value == 0) {
                      homePageController.getTagList('general', 'media');
                    } else {
                      homePageController.getTagList('general', 'text');
                    }
                  } else {
                    if (homePageController.selectedSubIndex.value == 0) {
                      homePageController.getTagList('friend', 'media');
                    } else {
                      homePageController.getTagList('friend', 'text');
                    }
                  }
                },
                icon: Icon(
                  Icons.chevron_left,
                  color: oceanGreen,
                ),
              ),
            ),
            Container(
              height: 70,
              child: Column(
                children: [
                  Obx(
                    () => SvgPicture.asset(
                      homePageController.selectedIndex.value == 0
                          ? 'assets/icons/worldIcon.svg'
                          : 'assets/icons/pandaIconColorful.svg',
                      width: Get.width / 2,
                      height: 70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: IconButton(
                onPressed: () {
                  if (homePageController.selectedIndex.value == 0) {
                    homePageController.selectedIndex.value = 1;
                  } else {
                    homePageController.selectedIndex.value = 0;
                  }
                  if (homePageController.selectedIndex.value == 0) {
                    if (homePageController.selectedSubIndex.value == 0) {
                      homePageController.getTagList('general', 'media');
                    } else {
                      homePageController.getTagList('general', 'text');
                    }
                  } else {
                    if (homePageController.selectedSubIndex.value == 0) {
                      homePageController.getTagList('friend', 'media');
                    } else {
                      homePageController.getTagList('friend', 'text');
                    }
                  }
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: oceanGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pageContent() {
    String tagFilter;
    if (homePageController.selectedIndex.value == 0) {
      tagFilter = 'general';
    } else {
      tagFilter = 'friend';
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: Colors.grey[200],
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            children: [
              Obx(
                () => homePageController.error.value
                    ? Center(
                        child: Text(
                          homePageController.errorString.value,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              homePageController.selectedSubIndex.value = 0;
                              homePageController.getTagList(tagFilter, 'media');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    homePageController.selectedSubIndex.value !=
                                            0
                                        ? Color(0xffececec)
                                        : null,
                                gradient:
                                    homePageController.selectedSubIndex.value ==
                                            0
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
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  'assets/icons/mediaIcon.svg',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 1,
                            color: Colors.grey[200],
                          ),
                          GestureDetector(
                            onTap: () {
                              homePageController.selectedSubIndex.value = 2;
                              homePageController.getTagList(tagFilter, 'text');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    homePageController.selectedSubIndex.value !=
                                            2
                                        ? Color(0xffececec)
                                        : null,
                                gradient:
                                    homePageController.selectedSubIndex.value ==
                                            2
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
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  'assets/icons/textIcon.svg',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              Container(height: 1, width: Get.width, color: Colors.grey[200]),
              Obx(
                () => Expanded(
                  child: homePageController.tagListLoading.value
                      ? CupertinoActivityIndicator()
                      : Container(
                          child: ListView.builder(
                            itemCount: homePageController.tagList.value.length,
                            itemBuilder: (context, index) {
                              return tagCard(
                                  homePageController.tagList.value[index]);
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tagCard(var json) {
    return InkWell(
      onTap: () {
        Get.to(TagDetail(json['id'], json['name'], json['storyCount'],
            json['type'].toString()));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '      #' + json['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      json['deadline'].toString().toLowerCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            width: Get.width,
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }
}
