import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/models/storyModel.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:snagom_app/widgets/fullScreenPhoto.dart';
import 'package:uuid/uuid.dart';

class ProfileController extends GetxController {
  var profileTabbarIndex = 0.obs;
  var popupShow = false.obs;
  var popUpData = {}.obs;
  File file;
  String photoUrl;
  FetchData f = FetchData();
  var targetProfileDatas = {}.obs;
  var targetProfilePosts = [].obs;
  var profileActiveStories = RxList<Story>();
  var profileActiveStoriesLoading = false.obs;
  var profileLoading = false.obs;
  var profilePostsLoading = false.obs;
  var isFollowed = false.obs;
  var targetProfileMediaPosts = [].obs;
  var targetProfileTextPosts = [].obs;
  var isPhotoUploaded = false.obs;
  var isPinnedPostsLoading = false.obs;
  var pinnedPosts = [].obs;
  var myAllStories = [].obs;
  var myAllStoriesLoading = false.obs;
  var myAllMediaStories = [].obs;
  var myAllTextStories = [].obs;
  var myProfileData = {}.obs;
  Future follonUnfollow(String userID) async {
    f.isUserFollowed(userID).then((value) {
      isFollowed.value = value;
      if (isFollowed.value) {
        unFollowUser(userID);
      } else {
        followUser(userID);
      }
    });
  }

  getPinnedPosts(String userId) async {
    isPinnedPostsLoading.value = true;
    pinnedPosts.value = await f.getPinnedPosts(userId);
    isPinnedPostsLoading.value = false;
  }

  pinStory(String storyId, String userId) async {
    var result = await f.pinStory(storyId);
    Get.snackbar('Success', 'You have successfuly pinned story');
    getPinnedPosts(userId);
  }

  unpinStory(String storyId, String userId) async {
    var result = await f.unpinStory(storyId);
    Get.snackbar('Success', 'You have successfuly unpin story');
    getPinnedPosts(userId);
  }

  openGallary(bool isGallery, {bool isCoverImage}) async {
    if (isGallery) {
      PickedFile picture =
          await ImagePicker().getImage(source: ImageSource.gallery);
      file = File(picture.path);
    } else {
      PickedFile picture =
          await ImagePicker().getImage(source: ImageSource.camera);
      file = File(picture.path);
    }
    isPhotoUploaded.value = true;
    if (isCoverImage) {
      uploadImage(file).then((fileUrl) {
        f.updateCoverImage(fileUrl).then((value) {
          var user = GetStorage().read('UserData');
          user['coverImageUrl'] = fileUrl;
          GetStorage().write('UserData', user);
          Get.snackbar(
              'Success', 'You have successfuly change the cover image!');
        });
      });
    } else {
      uploadImage(file).then((fileUrl) {
        f.updateImage(fileUrl).then((value) {
          var user = GetStorage().read('UserData');
          user['imageUrl'] = fileUrl;
          GetStorage().write('UserData', user);
          Get.snackbar(
              'Success', 'You have successfuly change the cover image!');
        });
      });
    }
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    photoUrl = downloadUrl;
    isPhotoUploaded.value = false;
    return downloadUrl;
  }

  // 0 media 1 text
  getProfileDatas(String userID) async {
    targetProfileMediaPosts.clear();
    targetProfileTextPosts.clear();
    profileActiveStories.clear();
    profileActiveStoriesLoading.value = true;
    f.getActiveStories(userID).then((value) {
      profileActiveStories.value =
          (value as List).map((e) => Story.fromJson(e)).toList();
      profileActiveStoriesLoading.value = false;
    });
    profileLoading.value = true;
    isFollowed.value = await f.isUserFollowed(userID);
    targetProfileDatas.value = {};
    targetProfileDatas.value = await f.getProfileDatas(userID);
    profileLoading.value = false;
    profilePostsLoading.value = true;
    targetProfilePosts.value = [];
    targetProfilePosts.value = await f.getProfilePosts(userID);

    targetProfilePosts.value.forEach((element) {
      if (element['type'].toString() == '0') {
        targetProfileMediaPosts.value.add(element);
      } else {
        targetProfileTextPosts.value.add(element);
      }
    });
    targetProfileMediaPosts.value =
        new List.from(targetProfileMediaPosts.value.reversed);
    targetProfileTextPosts.value =
        new List.from(targetProfileTextPosts.value.reversed);

    profilePostsLoading.value = false;
  }

  getMyProfileData(String userID) async {
    targetProfileMediaPosts.clear();
    targetProfileTextPosts.clear();
    profilePostsLoading.value = true;
    targetProfilePosts.value = [];
    profileActiveStoriesLoading.value = true;
    f.getActiveStories(userID).then((value) {
      profileActiveStories.value =
          (value as List).map((e) => Story.fromJson(e)).toList();
      profileActiveStoriesLoading.value = false;
    });
    targetProfilePosts.value = await f.getProfilePosts(userID);
    myProfileData.value = await f.getProfileDatas(userID);
    if (myProfileData['coverImageUrl'] == null) {
      myProfileData['coverImageUrl'] =
          'https://galeri14.uludagsozluk.com/854/kapak-fotografi-yapilabilecek-fotograflar_1959425.png';
    }
    targetProfilePosts.value.forEach((element) {
      if (element['type'].toString() == '0') {
        targetProfileMediaPosts.value.add(element);
      } else {
        targetProfileTextPosts.value.add(element);
      }
    });
    targetProfileMediaPosts.value =
        new List.from(targetProfileMediaPosts.value.reversed);
    targetProfileTextPosts.value =
        new List.from(targetProfileTextPosts.value.reversed);
    profilePostsLoading.value = false;
  }

  onFollowButtonPressed(followedUserId) {
    if (!isFollowed.value) {
      unFollowUser(followedUserId);
    } else {
      followUser(followedUserId);
    }
  }

  followUser(String followedUserId) {
    f.followUser(followedUserId);
  }

  unFollowUser(followedUserId) {
    f.unfollowUser(followedUserId);
  }

  popup(String imageUrl, bool isCoverImage) {
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
                  'What are your plans?',
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
                        Get.to(FullScreenPhoto(imageUrl));
                      },
                      child: Column(
                        children: [
                          Text(
                            'View',
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
                        Get.back();
                        Get.defaultDialog(
                          title: 'Gallery/Camera',
                          content: Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    openGallary(true,
                                        isCoverImage: isCoverImage);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2,
                                    child: Center(
                                      child: Text(
                                        'Gallery',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'SamsungSharpsansMedium',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    openGallary(false,
                                        isCoverImage: isCoverImage);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2,
                                    child: Center(
                                      child: Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'SamsungSharpsansMedium',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Change',
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

  getMyAllStories() async {
    myAllStoriesLoading.value = true;
    myAllStories.value = await f.getMyAllStories();
    myAllTextStories.clear();
    myAllMediaStories.clear();
    myAllStories.value.forEach((element) {
      if (element['type'].toString() == '0') {
        myAllMediaStories.value.add(element);
      } else {
        myAllTextStories.value.add(element);
      }
    });
    myAllStoriesLoading.value = false;
  }
}
