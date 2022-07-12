import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/login/loginPage.dart';
import 'package:snagom_app/pages/register/registerSecondStep.dart';
import 'package:snagom_app/services/fetch.dart';

class RegisterController extends GetxController {
  FetchData f = FetchData();

  var checkLoading = false.obs;
  var registerLoading = false.obs;
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  check() async {
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Hatali email formati');
    } else {
      checkLoading.value = true;
      var result = await f.checkEmailUsername(
          nicknameController.text, emailController.text);
      checkLoading.value = false;
      try {
        //user yok ise
        if (result['data']['doesUserExist'] == false) {
          Get.to(RegisterSecondStep());
        }
// user var
        else {
          Get.snackbar('Error', 'This user is exist');
        }
      } catch (e) {
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }

  bool isPasswordStrong() {
    String password = passwordController.text;
    int upperCaseCount = 0;
    int numberCount = 0;
    bool canGo = false;
    for (int i = 0; i < password.length; i++) {
      if (!password[i].isNum) {
        if (password[i].toUpperCase() == password[i]) {
          upperCaseCount++;
        }
      }
      if (password[i].isNum) {
        numberCount++;
      }
    }
    if (password.length < 8) {
      canGo = true;
      Get.snackbar('Warning', '8 karakterden az olamaz');
    }
    if (upperCaseCount == 0) {
      canGo = true;
      Get.snackbar('Warning', 'En az bir buyuk harf kullaniniz');
    }
    if (numberCount == 0) {
      canGo = true;
      Get.snackbar('Warning', 'En az bir numara kullaniniz');
    }
    return canGo;
  }

  register() async {
    if (!isPasswordStrong()) {
      registerLoading.value = true;
      var result = await f.register(
        name: nameController.text,
        surname: surnameController.text,
        nickname: nicknameController.text,
        password: passwordController.text,
        phone: phoneController.text,
        email: emailController.text,
      );
      if (result['success']) {
        print('1');
        nameController.clear();
        surnameController.clear();
        nicknameController.clear();
        passwordController.clear();
        phoneController.clear();
        emailController.clear();
        print('2');
        Fluttertoast.showToast(
            msg: result['result'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print('3');
        Get.offAll(LoginPage());
      } else {
        Get.snackbar('Error', result['result']);
      }
      registerLoading.value = false;
    }
  }
}
