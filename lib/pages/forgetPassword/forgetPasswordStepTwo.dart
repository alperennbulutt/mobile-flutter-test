import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/login/loginPage.dart';
import 'package:snagom_app/widgets/customButton.dart';
import 'package:snagom_app/widgets/customTextField.dart';
import 'changePassword.dart';
import 'forgetPasswordController.dart';

class ForgetPasswordStepTwo extends StatelessWidget {
  ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              'assets/icons/backIcon.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: SvgPicture.asset(
          'assets/icons/appBarLogo.svg',
          width: 200,
          fit: BoxFit.fitWidth,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Check your email',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "You'll receive a code to verify here so you can reset your account password",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: customTextField('Enter your code',
                forgetPasswordController.emailCodeController),
          ),
          // SizedBox(height: 30),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15),
          //   child: customTextField('Enter your password',
          //       forgetPasswordController.newPasswordController,
          //       obscureText: true),
          // ),
          // SizedBox(height: 30),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15),
          //   child: customTextField('Enter your password again',
          //       forgetPasswordController.newPasswordCheckController,
          //       obscureText: true),
          // ),
          Spacer(),
          CustomButton(
            () async {
              var result = await forgetPasswordController.confirmResetCode(
                  forgetPasswordController.emailCodeController.text);
              if (result['success']) {
                Get.to(ChangePassword());
              } else {
                Get.snackbar('Error', result['error']);
              }
            },
            Obx(
              () => forgetPasswordController.confirmResetCodeLoading.value
                  ? CupertinoActivityIndicator()
                  : Text(
                      'Verify',
                      style: TextStyle(color: Colors.black54),
                    ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
