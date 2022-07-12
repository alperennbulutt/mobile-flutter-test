import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/register/registerController.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class RegisterFirstStep extends StatelessWidget {
  RegisterController registerController = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: Image.asset('assets/images/loginBottom.png'),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: Get.height * 0.07),
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Register 1/2',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: customTextField(
                        '* E-Mail: ', registerController.emailController),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: customTextField(
                        '* Username: ', registerController.nicknameController),
                  ),
                  SizedBox(height: 20),
                  button(),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Do you have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: colorLightGreen,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Image.asset('assets/images/loginBottom.png')
            ],
          ),
        ),
      ),
    );
  }

  button() {
    return GestureDetector(
      onTap: () {
        registerController.check();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorGrassGreen,
                colorLightGreen,
              ],
            ),
          ),
          child: Obx(
            () => Center(
              child: registerController.checkLoading.value
                  ? CupertinoActivityIndicator()
                  : Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
