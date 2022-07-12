import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/forgetPassword/changePassword.dart';
import 'package:snagom_app/pages/login/loginPage.dart';
import 'package:snagom_app/services/fetch.dart';

class ForgetPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController emailCodeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordCheckController = TextEditingController();
  FetchData f = FetchData();
  var getResetCodeLoading = false.obs;
  var resetCode = {}.obs;
  var confirmResetCodeLoading = false.obs;
  getResetCode() async {
    getResetCodeLoading.value = true;
    resetCode.value = await f.getResetCode(emailController.text);
    getResetCodeLoading.value = false;
    return resetCode.value;
  }

  confirmResetCode(String resetCode) async {
    confirmResetCodeLoading.value = true;
    var result = await f.confirmResetCode(emailController.text, resetCode);
    confirmResetCodeLoading.value = false;
    return result;
  }

  changePassword() async {
    if (newPasswordCheckController.text == newPasswordController.text) {
      confirmResetCodeLoading.value = true;
      var result = await f.changePassword(emailController.text,
          emailCodeController.text, newPasswordController.text);
      confirmResetCodeLoading.value = false;
      if (result['success']) {
        Get.offAll(LoginPage());
      } else {
        Get.snackbar('Error', result['error'].toString());
      }
    } else {
      Get.snackbar('Error', 'Passwords is not same');
    }
  }
}
