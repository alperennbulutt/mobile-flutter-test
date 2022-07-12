import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/messages/messageController.dart';

import 'messageDetail.dart';

class MessageCard extends StatelessWidget {
  Map messageCardDetail;
  MessageCard(this.messageCardDetail);
  @override
  Widget build(BuildContext context) {
    if (messageCardDetail['members'][0]['imageUrl'].toString() == 'null') {
      messageCardDetail['members'][0]['imageUrl'] = profileIcon;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () {
          Get.to(
            MessageDetail(
              receiverUser: messageCardDetail['members'][0],
              roomID: messageCardDetail['messageBoxId'],
            ),
          );
          MessageController messageController = Get.find();
          if (messageCardDetail['unreadMessageCount'] != 0) {
            messageController.myUnreadMessagesLength.value--;
          }
        },
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: oceanGreen,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage:
                NetworkImage(messageCardDetail['members'][0]['imageUrl']),
          ),
        ),
        title: Text(
          messageCardDetail['members'][0]['fullName'].toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: messageCardDetail['unreadMessageCount'] == 0
            ? Text('')
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorLightGreen,
                      colorGrassGreen,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    messageCardDetail['unreadMessageCount'].toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
