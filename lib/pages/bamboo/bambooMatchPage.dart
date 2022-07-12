import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'widgets/bambooAnimationCard.dart';

class BambooMatchPage extends StatelessWidget {
  Map myStory;
  Map matchStory;
  String tagName;
  BambooMatchPage(this.myStory, this.matchStory, this.tagName);
  Map profileData;
  String roomId;
  TextEditingController textEditingController = TextEditingController();
  DatabaseReference ref;
  MessageController messageController = Get.put(MessageController());
  void _toggleSendChannelMessage() async {
    String text = textEditingController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      DateTime now = DateTime.now();

      ref.child(roomId).push().set({
        'message': textEditingController.text,
        'sender_date': now.toString().split('.')[0],
        'sender_nickname': profileData['fullName'],
        'sender_image': profileData['image'].toString(),
        'sender_id': profileData['id'],
        'isImage': false,
        'isLiked': false,
        'answerBambooId': matchStory['id'],
        'answerBambooIsImage': myStory['isImage'],
        'answerBambooImage': matchStory['imageUrl'],
      });

      messageController.increaseMessageCount(roomId);
      textEditingController.clear();
      // await _channel.sendMessage(AgoraRtmMessage.fromText(text));
    } catch (errorCode) {
      print(errorCode);
      //_log('Send channel message error: ' + errorCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref = FirebaseDatabase.instance.reference();
    profileData = GetStorage().read('UserData');
    if (profileData['imageUrl'] == null) {
      profileData['imageUrl'] = profileIcon;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorLightGreen,
                colorGrassGreen,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topbar(),
              BambooAnimationCard(myStory, matchStory, tagName),
              bottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Container(
        color: Colors.white,
        child: TextField(
          onTap: () async {
            roomId = await messageController
                .getMyLastConversationReturnRoomID(matchStory['user']);
          },
          cursorColor: Colors.transparent,
          controller: textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '       Make a comments...',
            hintStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () async {
                    if (roomId != null) {
                      _toggleSendChannelMessage();
                    } else {
                      roomId = await messageController
                          .getMyLastConversationReturnRoomID(
                              matchStory['user']);
                    }
                  },
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  topbar() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          profileData['imageUrl'],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        profileData['fullName'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "@" + profileData['nickname'].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  height: 60,
                  width: 60,
                  color: Colors.white,
                  // child: SvgPicture.asset(
                  //   'assets/icons/peopleAdd.svg',
                  //   height: 40,
                  //   width: 40,
                  // ),
                  child: Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 30,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    // child: SvgPicture.asset(
                    //   'assets/icons/cancelIcon.svg',
                    //   height: 20,
                    //   width: 20,
                    //   color: Colors.black,
                    // ),
                    child: Text(
                      'X',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
