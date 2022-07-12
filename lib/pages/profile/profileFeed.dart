import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/tags/widgets/tagTextCard.dart';
import 'package:snagom_app/widgets/postCard.dart';

class ProfileFeed extends StatelessWidget {
  var json;
  bool isMedia;
  ProfileFeed(this.json, this.isMedia);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbfafa),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(
                'assets/icons/backIcon.svg',
                height: 15,
                width: 15,
              ),
            ),
          ),
        ),
        title: SvgPicture.asset(
          'assets/icons/appBarLogo.svg',
          width: 200,
          fit: BoxFit.fitWidth,
        ),
        //actions: [SvgPicture.asset('assets/icons/messageIcon.svg')],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SvgPicture.asset(
              'assets/icons/messageIcon.svg',
              height: 25,
              width: 25,
            ),
          )
        ],
      ),
      body: isMedia
          ? ListView.builder(
              itemCount: json.length,
              itemBuilder: (context, index) {
                return PostCard(json[index]);
              },
            )
          : ListView.builder(
              itemCount: json.length,
              itemBuilder: (context, index) {
                return TagTextCard(json[index]);
              },
            ),
    );
  }

  secondAppBar() {
    return Column(
      children: [
        Container(
          height: 1,
          width: Get.width,
          color: Colors.grey[200],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    'assets/icons/backIcon.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              Text(
                '#coronavirus',
                style: TextStyle(
                  color: colorBoldGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(
                  'assets/icons/textIcon.svg',
                  height: 25,
                  width: 25,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1,
          width: Get.width,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
