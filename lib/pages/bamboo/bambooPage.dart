import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_list_tabview/model/list_tab.dart';
import 'package:scrollable_list_tabview/model/scrollable_list_tab.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/bamboo/widgets/bambooCard.dart';

class BambooPage extends StatelessWidget {
  BambooController bambooController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorLightGreen,
                  colorGrassGreen,
                ],
              ),
            ),
          ),
          // Obx(
          //   () => bambooController.bambooLoading.value
          //       ? Container()
          //       : ScrollableListTabView(
          //           tabHeight: 95,
          //           bodyAnimationDuration: const Duration(milliseconds: 150),
          //           tabAnimationCurve: Curves.easeOut,
          //           tabAnimationDuration: const Duration(milliseconds: 200),
          //           tabs: [
          //             for (int i = 0;
          //                 i < bambooController.nonBambooStories.value.length;
          //                 i++)
          //               ScrollableListTab(
          //                 tab: ListTab(
          //                     borderRadius: BorderRadius.circular(0),
          //                     activeBackgroundColor: colorTabGreen,
          //                     inactiveBackgroundColor: selectedTabGreen,
          //                     label: bambooController.nonBambooStories[i]['tag']
          //                         ['name'],
          //                     icon: Icon(Icons.group),
          //                     isMedia: bambooController.nonBambooStories[i]
          //                                 ['type'] ==
          //                             0
          //                         ? true
          //                         : false,
          //                     showIconOnList: true),
          //                 body: BambooCard(
          //                     bambooController.nonBambooStories[i], i),
          //               ),
          //           ],
          //         ),
          // ),
        ],
      ),
    );
  }

  tabList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        tab('UmutFelik', 0, 'mediaIcon.svg'),
        tab('quantumJourney', 1, 'textIcon.svg'),
      ],
    );
  }

  tab(String tagName, int index, String icon) {
    return InkWell(
      onTap: () {
        bambooController.selectedTabIndex.value = index;
      },
      child: Container(
        width: double.parse((tagName.length * 15).toString()),
        height: 75,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Obx(
                () => Container(
                  width: double.parse((tagName.length * 15).toString()),
                  height: 50,
                  color: bambooController.selectedTabIndex.value == index
                      ? selectedTabGreen
                      : colorTabGreen,
                  child: Center(
                    child: Text(
                      '#' + tagName,
                      style: TextStyle(
                        // color: colorTextBlue,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: (double.parse((tagName.length * 15).toString()) - 30) / 2,
              child: Center(
                  child: Obx(
                () => Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bambooController.selectedTabIndex.value == index
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/icons/$icon',
                      height: 25,
                      width: 25,
                      color: bambooController.selectedTabIndex.value != index
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
