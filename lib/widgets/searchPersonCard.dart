import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';

class SearchPersonCard extends StatelessWidget {
  var json;
  SearchPersonCard(this.json);
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    if (json['iamgeUrl'].toString() == 'null') {
      imageUrl = profileIcon;
    } else {
      imageUrl = json['imageUrl'];
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to(TargetProfile(json['id']));
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: oceanGreen,
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            title: Text(
              json['fullName'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  '@' + json['nickname'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                Text(' | '),
                Text(
                  json['isFollowed'] ? 'following' : 'not follow',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: Get.width * 0.9,
            color: colorLightGrey,
          ),
        ],
      ),
    );
  }
}
