import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/services/fetch.dart';

import 'bambooMatchPage.dart';

class BambooController extends GetxController {
  var selectedTabIndex = 0.obs;
  var nonBambooStories = [].obs;
  var bambooLoading = true.obs;
  var chooseLoading = false.obs;
  var chooseResult = {}.obs;
  FetchData f = FetchData();
  @override
  void onInit() {
    super.onInit();
    getNonBambooStories();
  }

  getNonBambooStories() async {
    bambooLoading.value = true;
    nonBambooStories.value = await f.getNonBambooStories();
    bambooLoading.value = false;
  }

  choose(Map story, String tagName) async {
    chooseLoading.value = true;
    var result = await f.getBambooStories(story['id']);
    if (result['success']) {
      chooseResult.value = result['data'];
      for (int i = 0; i < nonBambooStories.length; i++) {
        if (nonBambooStories[i]['id'] == story['id']) {
          nonBambooStories.removeAt(i);
        }
      }

      Get.to(BambooMatchPage(story, chooseResult.value, tagName));
    } else {
      Get.snackbar('Warning', result['error']);
    }
    chooseLoading.value = false;
  }

  onChooseButtonPressed(Map story, String tagName) {
    return Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: Get.height * 0.4,
        ),
        child: Container(
          width: Get.width * 0.9,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'The post you have choosen cannot be removed for 20:32 minutes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'SamsungSharpsansMedium',
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Column(
                        children: [
                          Text(
                            'cancel',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SamsungSharpsansMedium',
                            ),
                          ),
                          Container(
                            width: 75,
                            height: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        choose(story, tagName);
                        Get.back();
                      },
                      child: Column(
                        children: [
                          Text(
                            'contiune',
                            style: TextStyle(
                              fontSize: 12,
                              color: oceanGreen,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SamsungSharpsansMedium',
                            ),
                          ),
                          Container(
                            width: 75,
                            height: 2,
                            color: oceanGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
