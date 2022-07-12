import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/homepage/homePageController.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:snagom_app/userMain/userMain.dart';
import 'dart:core';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:geocoding/geocoding.dart';
import 'addContentNextScreen.dart';

class AddContentController extends GetxController {
  var fileLoading = false.obs;
  var cameraSubIndex = 0.obs;
  var tagSearchResult = [].obs;
  var choosenTag = {}.obs;
  var newTag = ''.obs;
  var choosenTagEmpty = true.obs;
  var storyCreateLoading = false.obs;
  var tagSearchLoading = false.obs;
  var downloadUrl = ''.obs;
  var addTwitTextFieldLength = 0.0.obs;
  var startTime = 0.0.obs;
  FetchData f = FetchData();
  TextEditingController postField = TextEditingController();
  TextEditingController tagSearchController = TextEditingController();
  VideoPlayerController videoPlayerController;
  TextEditingController addressController = TextEditingController();
  HomePageController homePageController = Get.find();
  BambooController bambooController = Get.find();
  var currentAddressLoading = false.obs;
  Position currentposition;
  File willDeleteFile;
  @override
  void onInit() {
    super.onInit();
    addressController.text = '';
    _determinePosition();
    tagSearchController.addListener(() {
      newTag.value = tagSearchController.text;
    });
  }

  getNewTags() async {
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
  }

  Future _determinePosition() async {
    currentAddressLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      currentposition = position;
      addressController.text =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      currentAddressLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage(File imageFile) async {
    fileLoading.value = true;
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    Get.to(AddContentNextScreen(false));
    (await uploadTask).ref.getDownloadURL().then((value) {
      downloadUrl.value = value;
      willDeleteFile = imageFile;
      fileLoading.value = false;
    });
  }

  Future<void> uploadVideo(File imageFile) async {
    fileLoading.value = true;
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.mp4");
    UploadTask uploadTask = ref.putFile(imageFile);
    Get.to(AddContentNextScreen(true));
    (await uploadTask).ref.getDownloadURL().then((value) {
      downloadUrl.value = value;

      videoPlayerController = VideoPlayerController.network(downloadUrl.value)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

          videoPlayerController.play();
          videoPlayerController.setLooping(true);
        });

      fileLoading.value = false;
    });
    willDeleteFile = imageFile;
  }

  searchTag(String type) async {
    tagSearchLoading.value = true;
    tagSearchResult.value =
        await f.getTagByName(tagSearchController.text, type);
    tagSearchLoading.value = false;
  }

  createStory(String mediaUrl, String type, bool isVideo) async {
    if (tagSearchController.text == '') {
      Get.snackbar('Error', 'You must enter a tag');
    } else if (postField.text == '') {
      Get.snackbar('Error', 'You must enter a description');
    } else {
      storyCreateLoading.value = true;
      if (choosenTag.value.isEmpty) {
        choosenTag.value = await f.createTag(tagSearchController.text, 0);
      }

      var result = await f.createPost(
        desc: postField.text,
        mediaUrl: mediaUrl,
        type: type,
        tagId: choosenTag.value['id'],
        isImage: !isVideo,
        location: addressController.text,
      );
      choosenTag.value = {};
      choosenTagEmpty.value = true;
      if (result) {
        Get.offAll(UserMain());
        bambooController.getNonBambooStories();
      } else {
        Get.snackbar('Error', 'Bir sorun oluştu');
      }
      willDeleteFile.delete().then((value) {
        print('file deleted');
      });
      storyCreateLoading.value = false;
      postField.clear();
      tagSearchController.clear();
    }
  }

  createTwit() async {
    if (tagSearchController.text == '') {
      Get.snackbar('Error', 'You must enter a tag');
    } else if (postField.text == '') {
      Get.snackbar('Error', 'You must enter a description');
    } else {
      storyCreateLoading.value = true;

      if (choosenTag.value.isEmpty) {
        choosenTag.value = await f.createTag(tagSearchController.text, 1);
      }

      var result = await f.createPost(
        desc: postField.text,
        mediaUrl: '',
        type: '1',
        tagId: choosenTag.value['id'],
        isImage: false,
        location: addressController.text,
      );
      choosenTag.value = {};
      choosenTagEmpty.value = true;
      if (result) {
        Get.offAll(UserMain());
        bambooController.getNonBambooStories();
      } else {
        Get.snackbar('Error', 'Bir sorun oluştu');
      }
      storyCreateLoading.value = false;
      postField.clear();
      tagSearchController.clear();
    }
  }

  openGallary({bool isVideo = false}) async {
    PickedFile picture;
    if (isVideo) {
      picture = await ImagePicker().getVideo(
        source: ImageSource.gallery,
      );
    } else {
      picture = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
    }
    return File(picture.path);
  }
}
