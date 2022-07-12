import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/bamboo/widgets/bambooTextCard.dart';

import '../bambooController.dart';
import 'bambooImageCard.dart';
import 'bambooVideoCard.dart';

class BambooCard extends StatelessWidget {
  BambooController bambooController = Get.find();
  var json;
  int index;
  BambooCard(this.json, this.index);
  Widget whichCard() {
    if (json['type'] == 1) {
      return BambooTextCard(json);
    } else {
      if (!json['isImage']) {
        return BambooVideoCard(json);
      } else {
        return BambooImageCard(json);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bambooController.nonBambooStories.length - 1 == index
          ? EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 200)
          : EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      child: Container(
        height: Get.height / 2,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: Stack(
          children: [
            whichCard(),
            Positioned(
              bottom: 0,
              left: Get.width * 0.22 - 8,
              child: InkWell(
                  onTap: () {
                    if (!bambooController.chooseLoading.value) {
                      bambooController.onChooseButtonPressed(
                          json,
                          bambooController.nonBambooStories[index]['tag']
                              ['name']);
                    }
                  },
                  child: Obx(
                    () => Container(
                      width: Get.width * 0.4,
                      decoration: BoxDecoration(
                        color: bambooController.chooseLoading.value
                            ? Colors.white
                            : Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: bambooController.chooseLoading.value
                              ? CupertinoActivityIndicator()
                              : Text(
                                  'Choose',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
