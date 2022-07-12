import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/profile/profileController.dart';
import 'package:snagom_app/services/fetch.dart';

class TagController extends GetxController {
  var tagDetailLoading = true.obs;
  var tagDetailList = [].obs;
  String newTagId;
  FetchData f = FetchData();
  ProfileController profileController = Get.put(ProfileController());

  changeTagType(String tagID, String content) async {
    tagDetailLoading.value = true;
    //tagDetailList.clear();

    tagDetailList.value = await f.switchTag(tagID, content);
    if (tagDetailList.length != 0) {
      newTagId = tagDetailList.value[0]['tag']['id'];
    }
    tagDetailLoading.value = false;
  }

  getTagDetail(String tagID, String content) async {
    tagDetailLoading.value = true;
    tagDetailList.value = [];
    tagDetailList.value = await f.getTagList(tagID, content);
    tagDetailLoading.value = false;
  }

  Future pinStory(String storyId, String userId) async {
    var result = await f.pinStory(storyId);
    Get.snackbar('Success', 'You have successfuly pinned story');
    profileController.getPinnedPosts(userId);
  }

  Future unpinStory(String storyId, String userId) async {
    var result = await f.unpinStory(storyId);
    Get.snackbar('Success', 'You have successfuly unpin story');
    profileController.getPinnedPosts(userId);
  }

  likePost(String storyID) async {
    f.likePost(storyID);
  }

  threeDotPopUp(String postOwner, String storyID, {bool unpin: false}) {
    return Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width / 4,
          vertical: postOwner == FetchData().getUserId()
              ? Get.height * 0.42
              : Get.height * 0.4,
        ),
        child: Container(
          width: Get.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 10,
              right: 10,
              bottom: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                postOwner == FetchData().getUserId()
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          f.reportSpam(
                            storyID,
                          );
                          Get.snackbar(
                              'Success', 'You have succesfully reported');
                          Get.back();
                        },
                        child: Column(
                          children: [
                            Text(
                              'Report',
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
                postOwner == FetchData().getUserId()
                    ? GestureDetector(
                        onTap: () {
                          Get.back();
                          if (unpin) {
                            unpinStory(storyID, postOwner).then((value) {
                              profileController.getPinnedPosts(postOwner);
                            });
                          } else {
                            pinStory(storyID, postOwner).then((value) {
                              profileController.getPinnedPosts(postOwner);
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Text(
                              unpin ? 'Unpin' : 'Pin to Profile',
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
                      )
                    : GestureDetector(
                        onTap: () {
                          profileController.follonUnfollow(postOwner);
                          Get.back();
                        },
                        child: Column(
                          children: [
                            Text(
                              'Follow/Unfollow',
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
                          color: Colors.red,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'SamsungSharpsansMedium',
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 2,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
