import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/profile/Settings/profileSettingsController.dart';
import 'package:snagom_app/widgets/customTextField.dart';

class ReportProblem extends StatelessWidget {
  ProfileSettingsController profileSettingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: customTextField(
                'Topic', profileSettingsController.reportTopicController),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: customTextField(
                'Content', profileSettingsController.reportContentController),
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
        'Report Problem',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            profileSettingsController.reportSpam();
          },
          icon: Icon(Icons.done, color: oceanGreen),
        ),
      ],
    );
  }
}
