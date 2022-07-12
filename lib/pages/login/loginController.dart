import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/bamboo/bambooController.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'package:snagom_app/pages/profile/profileController.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:snagom_app/userMain/userMain.dart';
import 'package:snagom_app/userMain/userMainController.dart';

class LoginController extends GetxController {
  var loginLoading = false.obs;
  FetchData f = FetchData();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  oneSignalInit(profileData) async {
    GetStorage().write('UserData', profileData);
    //Remove this method to stop OneSignal Debuggingx
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("87d79d5b-6eaa-4bd6-9ebf-c6d50c21e981");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

// Setting External User Id with Callback Available in SDK Version 3.9.3+
    OneSignal.shared.setExternalUserId(profileData['id']).then((results) {
      print(results.toString());
    }).catchError((error) {
      print(error.toString());
    });
  }

  login() async {
    // if (!loginLoading.value) {
    //   loginLoading.value = true;
    //   var result =
    //       await f.login(nicknameController.text, passwordController.text);
    //   var parsedResponse = json.decode(result.body);
    //   var profileData;
    //   if (parsedResponse['success']) {
    //     String refreshToken = result.headers['set-cookie']
    //         .toString()
    //         .split(';')[0]
    //         .split('refreshToken=')[1];
    //     GetStorage().write('refreshToken', refreshToken);
    //     GetStorage().write('jwtToken', parsedResponse['data']['jwtToken']);
    //     GetStorage().write('userId', parsedResponse['data']['id']);
    //     BambooController bambooController = Get.put(BambooController());
    //     MessageController messageController = Get.put(MessageController());
    //     UserMainController mainController = Get.put(UserMainController());
    //     mainController.getActiveStories();
    //     bambooController.getNonBambooStories();
    //     messageController.getMyMessageBoxes();

    //     profileData = await f.getProfileDatas(parsedResponse['data']['id']);
    //     nicknameController.clear();
    //     passwordController.clear();
    //     oneSignalInit(profileData);
    //     Get.offAll(UserMain());
    //   } else {
    //     Get.snackbar('Error', parsedResponse['error'].toString());
    //   }
    Get.offAll(UserMain());
    loginLoading.value = false;
  }
}
