import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/login/loginPage.dart';
import 'package:snagom_app/pages/profile/Settings/profileSettingsController.dart';
import 'package:snagom_app/pages/profile/Settings/reportProblem.dart';
import 'package:snagom_app/userMain/userMainController.dart';

import 'ManageAccount/manageAccount.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettingsController profileSettingsController =
      Get.put(ProfileSettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Setttings and privacy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      body: ListView(
        children: [
          title('ACCOUNT'),
          button(Icons.person_outline, 'Manage Account', () {
            Get.to(ManageAccount());
          }),
          button(Icons.lock_outline, 'Privacy', () {}),
          button(Icons.security_outlined, 'Security and login', () {}),
          divider(),
          title('SUPPORT'),
          button(Icons.enhance_photo_translate_outlined, 'Report a problem',
              () {
            Get.to(ReportProblem());
          }),
          button(Icons.info_outline, 'Help Center', () {}),
          button(Icons.safety_divider_outlined, 'Safety Center', () {}),
          divider(),
          title('ABAOUT'),
          button(Icons.commute_outlined, 'Community Guidlines', () {}),
          button(Icons.device_thermostat_rounded, 'Terms of Service', () {}),
          button(Icons.privacy_tip, 'Privacy Policy', () {}),
          button(Icons.copyright, 'Copyright Policy', () {}),
          divider(),
          //Spacer(),
          button(Icons.exit_to_app, 'Exit', () {
            GetStorage().remove('refreshToken');
            GetStorage().remove('jwtToken');
            GetStorage().remove('userId');
            Get.offAll(LoginPage());
            UserMainController userMainController = Get.find();
            userMainController.bodyIndex.value = 0;
          }, isRed: true),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 1,
        width: Get.width * 0.9,
        color: colorTextGrey.withOpacity(0.3),
      ),
    );
  }

  Widget title(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 20,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: colorTextGrey,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  button(IconData icon, String content, VoidCallback function,
      {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20,
        top: 10,
      ),
      child: InkWell(
        onTap: () {
          function();
        },
        child: Container(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isRed ? Colors.red : Colors.black,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  content,
                  style: TextStyle(
                    color: isRed ? Colors.red : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
