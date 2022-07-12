import 'package:flutter/material.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';

class NotificationCard extends StatelessWidget {
  var json;
  NotificationCard(this.json);
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    if (json['sourceUser']['imageUrl'].toString() == 'null') {
      imageUrl = profileIcon;
    } else {
      imageUrl = json['sourceUser']['imageUrl'];
    }
    return Container(
      decoration: BoxDecoration(
        gradient: json['status'] == 0
            ? LinearGradient(
                colors: [
                  oceanGreen.withOpacity(0.5),
                  colorGrassGreen.withOpacity(0.5)
                ],
              )
            : null,
        // border: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey,
        //     width: 0.5,
        //   ),
        // ),
      ),
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          json['sourceUser']['fullName'],
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          json['text'],
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
