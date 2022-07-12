import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/widgets/customButton.dart';
import 'package:snagom_app/widgets/customTextField.dart';

import 'forgetPasswordController.dart';

class ChangePassword extends StatelessWidget {
  ForgetPasswordController forgetPasswordController = Get.find();
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
              'Enter your new password',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: customTextField(
              'Enter your password',
              forgetPasswordController.newPasswordController,
              obscureText: true,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: customTextField(
              'Enter your password again',
              forgetPasswordController.newPasswordCheckController,
              obscureText: true,
            ),
          ),
          Spacer(),
          CustomButton(
            () {
              forgetPasswordController.changePassword();
            },
            Obx(
              () => forgetPasswordController.confirmResetCodeLoading.value
                  ? Center(child: CupertinoActivityIndicator())
                  : Text(
                      'Change',
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
