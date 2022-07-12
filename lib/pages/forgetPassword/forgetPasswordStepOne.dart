import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/forgetPassword/forgetPasswordController.dart';
import 'package:snagom_app/pages/forgetPassword/forgetPasswordStepTwo.dart';
import 'package:snagom_app/widgets/customButton.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class ForgetPasswordStepOne extends StatelessWidget {
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
              'Find your Snagom account',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: customTextField(
                'Enter your email', forgetPasswordController.emailController),
          ),
          Spacer(),
          CustomButton(
            () async {
              var result = await forgetPasswordController.getResetCode();
              if (result['success']) {
                Get.to(ForgetPasswordStepTwo());
              } else {
                Get.snackbar('Error', result['error']);
              }
            },
            Obx(
              () => forgetPasswordController.getResetCodeLoading.value
                  ? Center(child: CupertinoActivityIndicator())
                  : Text(
                      'Search',
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
