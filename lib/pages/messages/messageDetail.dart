import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';

class MessageDetail extends StatefulWidget {
  Map receiverUser;
  String roomID;
  MessageDetail({this.receiverUser, this.roomID});
  @override
  _MessageDetail createState() => _MessageDetail();
}

class _MessageDetail extends State<MessageDetail> {
  TextEditingController textEditingController = TextEditingController();
  MessageController messageController = Get.find();
  DatabaseReference ref;
  List messageList = [];
  List messageKeys = [];
  List list = [];
  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = GetStorage().read('UserData');
    messageController.resetMessageCount(widget.roomID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.resetMessageCount(widget.roomID);
  }

  void _toggleSendChannelMessage(String text, {String url}) async {
    String text = textEditingController.text;
    if (text.isEmpty && url == null) {
      return;
    } else if (text.length > 100) {
      Get.snackbar('Warning', 'Message can not be more 100 character');
    } else {
      try {
        DateTime now = DateTime.now();
        if (url == null) {
          ref.child(widget.roomID).push().set({
            'message': textEditingController.text,
            'sender_date': now.toString().split('.')[0],
            'sender_nickname': user['fullName'],
            'sender_image': user['image'].toString(),
            'sender_id': user['id'],
            'isImage': false,
            'isLiked': false,
          });
        } else {
          ref.child(widget.roomID).push().set({
            'message': textEditingController.text,
            'sender_date': now.toString().split('.')[0],
            'sender_nickname': user['fullName'],
            'sender_image': user['image'].toString(),
            'sender_id': user['id'],
            'isImage': true,
            'imageUrl': url,
            'isLiked': false,
          });
        }
        messageController.increaseMessageCount(widget.roomID);
        textEditingController.clear();
        // await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      } catch (errorCode) {
        print(errorCode);
        //_log('Send channel message error: ' + errorCode.toString());
      }
    }
  }

  Widget _messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 1,
        child: Container(
          child: ListView.builder(
            reverse: true,
            itemCount: messageList.length,
            itemBuilder: (BuildContext context, int index) {
              if (messageList.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: messageList[index]['sender_id'] == user['id']
                      ? Column(
                          children: [
                            messageList[index]['isImage']
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        messageList[index]['imageUrl'],
                                        height: Get.height * 0.4,
                                        width: Get.width / 2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(),
                            messageList[index]['isImage']
                                ? Container()
                                : ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    trailing: Image.network(
                                      messageList[index]['sender_image']
                                                      .toString() ==
                                                  'null' ||
                                              messageList[index]
                                                      ['sender_image'] ==
                                                  ''
                                          ? profileIcon
                                          : messageList[index]['sender_image'],
                                      width: 32,
                                      height: 32,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        messageList[index]['answerStory_id']
                                                    .toString() ==
                                                'null'
                                            ? Container()
                                            : messageList[index]
                                                    ['answerStoryIsImage']
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        messageList[index][
                                                            'answerStoryImage'],
                                                        height:
                                                            Get.height * 0.15,
                                                        width: Get.width * 0.25,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                        messageList[index]['answerBambooId']
                                                    .toString() ==
                                                'null'
                                            ? Container()
                                            : Text(
                                                'Answering to Bamboo',
                                                style: TextStyle(
                                                  color: oceanGreen,
                                                  fontSize: 12,
                                                ),
                                              ),
                                        messageList[index]['answerBambooId']
                                                    .toString() ==
                                                'null'
                                            ? Container()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: messageList[index][
                                                          'answerBambooIsImage']
                                                      ? Image.network(
                                                          messageList[index][
                                                              'answerBambooImage'],
                                                          height:
                                                              Get.height * 0.15,
                                                          width:
                                                              Get.width * 0.25,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 0),
                                                color: Colors.grey,
                                                blurRadius: 1,
                                                spreadRadius: 0.5,
                                              )
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 8),
                                            child: Text(
                                              messageList[index]['message']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        )
                      : GestureDetector(
                          onDoubleTap: () {
                            ref
                                .child(widget.roomID)
                                .child(messageList[index]['key'])
                                .update({
                              'isLiked': true,
                            });
                          },
                          child: Column(
                            children: [
                              messageList[index]['isImage']
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          messageList[index]['imageUrl'],
                                          height: Get.height * 0.4,
                                          width: Get.width / 2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              messageList[index]['isImage']
                                  ? Container()
                                  : ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: GestureDetector(
                                        onTap: () {
                                          Get.to(TargetProfile(
                                              messageList[index]['sender_id']));
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Image.network(
                                                  messageList[index]['sender_image']
                                                                  .toString() ==
                                                              'null' ||
                                                          messageList[index][
                                                                  'sender_image'] ==
                                                              ''
                                                      ? profileIcon
                                                      : messageList[index]
                                                          ['sender_image'],
                                                  width: 32,
                                                  height: 32,
                                                ),
                                              ),
                                              messageList[index]['isLiked']
                                                  ? Positioned(
                                                      bottom: 5,
                                                      right: 10,
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          messageList[index]['answerStory_id']
                                                      .toString() ==
                                                  'null'
                                              ? Container()
                                              : messageList[index]
                                                      ['answerStoryIsImage']
                                                  ? Text(
                                                      'Answering to story',
                                                      style: TextStyle(
                                                        color: oceanGreen,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  : Container(),
                                          messageList[index]['answerStory_id']
                                                      .toString() ==
                                                  'null'
                                              ? Container()
                                              : messageList[index]
                                                      ['answerStoryIsImage']
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          messageList[index][
                                                              'answerStoryImage'],
                                                          height:
                                                              Get.height * 0.15,
                                                          width:
                                                              Get.width * 0.25,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                          messageList[index]['answerBambooId']
                                                      .toString() ==
                                                  'null'
                                              ? Container()
                                              : Text(
                                                  'Answering to Bamboo',
                                                  style: TextStyle(
                                                    color: oceanGreen,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          messageList[index]['answerBambooId']
                                                      .toString() ==
                                                  'null'
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: messageList[index][
                                                            'answerBambooIsImage']
                                                        ? Image.network(
                                                            messageList[index][
                                                                'answerBambooImage'],
                                                            height: Get.height *
                                                                0.15,
                                                            width: Get.width *
                                                                0.25,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 0),
                                                  color: Colors.grey,
                                                  blurRadius: 1,
                                                  spreadRadius: 0.5,
                                                )
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8),
                                              child: Text(
                                                messageList[index]['message']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref = FirebaseDatabase.instance.reference();
    return Scaffold(
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
          widget.receiverUser['fullName'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //          Get.to(VideoChannel(widget.roomID));
        //     },
        //     icon: SvgPicture.asset(
        //       'assets/icons/cameraIcon.svg',
        //       height: 20,
        //       width: 20,
        //     ),
        //   ),
        //   SizedBox(width: 10),
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height * 0.9,
          width: Get.width,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: ref.child(widget.roomID).onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        list.clear();
                        messageList.clear();
                        list.add(snapshot.data.snapshot);
                        if (list[0].value != null) {
                          Map<dynamic, dynamic> values = list[0].value;
                          values.forEach((key, values) {
                            messageList.add(values);
                            messageKeys.add(key);
                          });
                          for (int i = 0; i < messageList.length; i++) {
                            messageList[i]['key'] = messageKeys[i];
                          }
                          messageList.sort((a, b) {
                            return b['sender_date'].compareTo(a['sender_date']);
                          });
                        } else {
                          messageList = [];
                        }
                        return _messageList();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 14, bottom: 20.0, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Theme(
                      data: ThemeData(
                        primaryColorDark: Colors.red,
                      ),
                      child: Container(
                        width: Get.width - 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            cursorColor: oceanGreen,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            minLines: 1,
                            maxLines: 4,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Write your message...',
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  FocusManager.instance.primaryFocus.unfocus();
                                  _toggleSendChannelMessage(
                                      textEditingController.text);
                                },
                                child: Icon(Icons.send, color: Colors.blue),
                              ),
                              prefixIcon: cameraButton(),
                            ),
                            onFieldSubmitted: (data) {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cameraButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        showCupertinoModalPopup(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoActionSheet(
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    String url = await messageController.openGallary();
                    _toggleSendChannelMessage(textEditingController.text,
                        url: url);
                    FocusManager.instance.primaryFocus.unfocus();
                    Navigator.of(context).pop();
                  },
                  child: Text("Gallery",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue)),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    String url =
                        await messageController.openGallary(isCamera: true);
                    _toggleSendChannelMessage(textEditingController.text,
                        url: url);
                    FocusManager.instance.primaryFocus.unfocus();
                    Navigator.of(context).pop();
                  },
                  child: Text("Camera",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      },
      child: Icon(
        Icons.camera_alt,
        color: Colors.blue,
      ),
    );
  }
}
