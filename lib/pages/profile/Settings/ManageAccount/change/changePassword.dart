import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/profile/Settings/ManageAccount/change/changeController.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class ChangePassword extends StatelessWidget {
  ChangeController changeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: customTextField(
                'New Password', changeController.passwordController,
                textInputType: TextInputType.emailAddress),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: customTextField(
                'New Password Again', changeController.passwordCheckController,
                textInputType: TextInputType.emailAddress),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: colorScaffoldColor,
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            child: SvgPicture.asset(
              'assets/icons/backIcon.svg',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
      title: Text(
        'Change Password',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        Obx(
          () => changeController.updateLoading.value
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : IconButton(
                  onPressed: () {
                    changeController.updatePassword();
                  },
                  icon: Icon(Icons.done, color: oceanGreen),
                ),
        ),
      ],
    );
  }
}
