import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/register/registerController.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class RegisterSecondStep extends StatelessWidget {
  RegisterController registerController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   bottomNavigationBar: Image.asset('assets/images/loginBottom.png'),
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
                  SizedBox(height: 10),
                  Text(
                    'Register 2/2',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: customTextField(
                          '*name: ', registerController.nameController),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: customTextField(
                          'Phone:   +1', registerController.phoneController),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: customTextField(
                          '*password: ', registerController.passwordController,
                          obscureText: true),
                    ),
                    SizedBox(height: 20),
                    button(),
                  ],
                ),
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
        registerController.register();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          child: Center(
            child: Obx(
              () => registerController.registerLoading.value
                  ? CupertinoActivityIndicator()
                  : Text(
                      'Register',
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
