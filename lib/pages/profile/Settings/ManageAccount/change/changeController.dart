import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/pages/profile/Settings/ManageAccount/change/changeBiography.dart';
import 'package:snagom_app/services/fetch.dart';

class ChangeController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController usernicknameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController biographyController = TextEditingController();
  var userData = {}.obs;
  @override
  void onInit() {
    super.onInit();
    userData.value = GetStorage().read('UserData');
  }

  changeUserName() async {
    updateLoading.value = true;
    var result = await f.updateFullname(userNameController.text);
    if (result['success']) {
      Get.snackbar('Success', 'You have successfully changed the user name!');
      userData.value['fullName'] = userNameController.text;
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
    updateLoading.value = false;
  }

  changeBiography() async {
    updateLoading.value = true;
    var result = await f.updateBiography(biographyController.text);
    if (result['success']) {
      Get.snackbar('Success', 'You have successfully changed the biography!');
      userData.value['fullName'] = userNameController.text;
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
    updateLoading.value = false;
  }

  FetchData f = FetchData();
  var updateLoading = false.obs;
  updateEmail() async {
    updateLoading.value = true;
    var result = await f.updateEmail(emailController.text);
    if (result['success']) {
      Get.snackbar('Success', 'You have successfully changed the e-mail!');
      userData.value['email'] = emailController.text;
      GetStorage().write('UserData', userData.value);
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
    updateLoading.value = false;
  }

  updatePassword() async {
    if (passwordController.text != passwordCheckController.text) {
      Get.snackbar('Error', 'Passwords is not same');
    } else {
      updateLoading.value = true;
      var result = await f.updatePassword(passwordController.text);
      if (result['success']) {
        Get.snackbar('Success', 'You have successfully changed the password!');
        Get.back();
      } else {
        Get.snackbar('Error', result['message']);
      }
      updateLoading.value = false;
    }
  }

  updatePhone() async {
    updateLoading.value = true;
    var result = await f.updatePhone(telephoneController.text);
    if (result['success']) {
      Get.snackbar(
          'Success', 'You have successfully changed the phone number!');
      userData.value['phoneNumber'] = telephoneController.text;
      GetStorage().write('UserData', userData.value);
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
    updateLoading.value = false;
  }

  updateNickname() async {
    updateLoading.value = true;
    var result = await f.updateNickname(usernicknameController.text);
    if (result['success']) {
      Get.snackbar('Success', 'You have successfully changed the nickname!');
      userData.value['nickname'] = usernicknameController.text;
      GetStorage().write('UserData', userData.value);
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
    updateLoading.value = false;
  }
}
