import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/messages/messageCard.dart';
import 'package:snagom_app/pages/messages/messageController.dart';

class MessageList extends StatelessWidget {
  MessageController messageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff6f6f6),
        toolbarHeight: 50,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              'assets/icons/backIcon.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          SvgPicture.asset(
            'assets/icons/settingsIcon.svg',
            height: 20,
            width: 20,
          ),
          SizedBox(width: 10),
          SvgPicture.asset(
            'assets/icons/messagePencilIcon.svg',
            height: 20,
            width: 20,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // ButtonsTabBar(
          //   height: 40,
          //   contentPadding: EdgeInsets.all(0),
          //   buttonMargin: EdgeInsets.all(0),
          //   radius: 0,
          //   backgroundColor: Color(0xfff6f6f6),
          //   unselectedBackgroundColor: Colors.grey[300],
          //   unselectedLabelStyle: TextStyle(color: Colors.black),
          //   labelStyle: TextStyle(color: Colors.white),
          //   tabs: [
          //     Tab(
          //       child: Container(
          //         width: Get.width / 3,
          //         child: Center(
          //             child: Text(
          //           'fundemental',
          //           style: TextStyle(color: Colors.black),
          //         )),
          //       ),
          //     ),
          //     Tab(
          //       child: Container(
          //         width: Get.width / 3,
          //         child: Center(
          //           child: SvgPicture.asset(
          //             'assets/icons/logo.svg',
          //             color: Colors.black,
          //             height: 30,
          //             width: 30,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Tab(
          //       child: Container(
          //         width: Get.width / 3,
          //         child: Center(
          //             child: Text(
          //           'spam',
          //           style: TextStyle(color: Colors.black),
          //         )),
          //       ),
          //     ),
          //   ],
          // ),
          Obx(
            () => messageController.myMessageBoxesLoading.value
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CupertinoActivityIndicator(),
                  ))
                : Expanded(
                    child: Container(
                      height: 1000,
                      child: ListView.builder(
                        itemCount: messageController.myMessageBoxes.length,
                        itemBuilder: (context, index) {
                          return MessageCard(
                              messageController.myMessageBoxes.value[index]);
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
