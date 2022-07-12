import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/forgetPassword/forgetPasswordStepOne.dart';
import 'package:snagom_app/pages/login/loginController.dart';
import 'package:snagom_app/pages/register/registerFirstStep.dart';
import 'package:snagom_app/userMain/userMain.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
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
                    'Welcome Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    customTextField(
                        'user name: ', loginController.nicknameController),
                    SizedBox(height: 10),
                    customTextField(
                        'password: ', loginController.passwordController,
                        obscureText: true),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Get.to(ForgetPasswordStepOne());
                        },
                        child: Text(
                          'forget password?',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    button(),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "Don't you have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(RegisterFirstStep());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: colorLightGreen,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Image.asset(
                'assets/images/loginBottom.png',
              )
            ],
          ),
        ),
      ),
    );
  }

  button() {
    return InkWell(
      onTap: () {
        loginController.login();

        // Get.offAll(UserMain());
      },
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
            () => loginController.loginLoading.value
                ? CupertinoActivityIndicator()
                : Text(
                    'sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
