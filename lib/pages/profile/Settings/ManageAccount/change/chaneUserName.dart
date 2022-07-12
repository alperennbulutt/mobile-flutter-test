import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/profile/Settings/ManageAccount/change/changeController.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class ChangeUserName extends StatelessWidget {
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
                'New User Name', changeController.userNameController),
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
        'Change User Name',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            changeController.changeUserName();
          },
          icon: Icon(Icons.done, color: oceanGreen),
        ),
      ],
    );
  }
}
