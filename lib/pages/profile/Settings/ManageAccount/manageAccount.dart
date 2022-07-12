import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/profile/Settings/ManageAccount/change/changeController.dart';
import 'package:snagom_app/pages/profile/Settings/ManageAccount/change/changeEmail.dart';

import 'change/chaneUserName.dart';
import 'change/changeBiography.dart';
import 'change/changeNickname.dart';
import 'change/changePassword.dart';
import 'change/changePhone.dart';

class ManageAccount extends StatelessWidget {
  ChangeController changeController = Get.put(ChangeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          accountRow('Fullname', changeController.userData['fullName'],
              ChangeUserName()),
          divider(),
          accountRow('Nickname', '@' + changeController.userData['nickname'],
              ChangeNickName()),
          divider(),
          accountRow(
              'Biography',
              changeController.userData['biography'].toString() == 'null'
                  ? ''
                  : changeController.userData['biography'].toString(),
              ChangeBiography()),
          divider(),
          accountRow(
              'Phone', changeController.userData['phoneNumber'], ChangePhone()),
          divider(),
          accountRow(
              'Email', changeController.userData['email'], ChangeEmail()),
          divider(),
          accountRow('Password', '*************', ChangePassword()),
          divider(),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      width: Get.width * 0.95,
      color: Colors.grey[200],
    );
  }

  Widget accountRow(String key, String value, page) {
    return InkWell(
      onTap: () {
        Get.to(page);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 3),
        child: Row(
          children: [
            SizedBox(width: 10),
            Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.chevron_right, color: Colors.grey),
            SizedBox(width: 10),
          ],
        ),
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
      title: Column(
        children: [
          Text(
            'Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            '@' + changeController.userData['fullName'],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
