import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/tags/widgets/tagImageCard.dart';
import 'package:snagom_app/pages/tags/widgets/tagTextCard.dart';
import 'package:snagom_app/pages/tags/widgets/tagVideoCard.dart';
import 'package:snagom_app/widgets/textCard.dart';
import 'package:snagom_app/widgets/videoCard.dart';

import 'imageCard.dart';

class FullScreenStory extends StatelessWidget {
  Map postDetail;
  FullScreenStory(this.postDetail);
  Widget whichCard() {
    if (postDetail['type'].toString() == '0') {
      if (postDetail['isImage']) {
        return ImageCard(postDetail);
      } else {
        return VideoCard(postDetail);
      }
    } else {
      return TextCard(postDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: whichCard(),
    );
  }
}
