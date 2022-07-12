import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:uuid/uuid.dart';

import 'messageDetail.dart';

class MessageController extends GetxController {
  FetchData f = FetchData();
  var myMessageBoxesLoading = false.obs;
  var isMyLastConversationLoading = false.obs;
  var myMessageBoxes = [].obs;
  var myLastConversation = [].obs;
  var myUnreadMessagesLength = 0.obs;
  String photoUrl;
  File file;
  Future generateMessageBox() {
    return f.generateMessageBox();
  }

  getMessageBoxById(String messageBoxID) {
    f.getMessageBoxById(messageBoxID);
  }

  Future addMemberToMessageBox(String messageBoxId, String userId) {
    return f.addMemberToMessageBox(messageBoxId, userId);
  }

  increaseMessageCount(String messageBoxId) {
    f.increaseMessageCount(messageBoxId);
  }

  getMyMessageBoxes() async {
    myMessageBoxesLoading.value = true;
    myMessageBoxes.value = await f.getMyMessageBoxes();
    for (int i = 0; i < myMessageBoxes.length; i++) {
      if (myMessageBoxes[i]['unreadMessageCount'] != 0) {
        myUnreadMessagesLength++;
      }
    }
    myMessageBoxesLoading.value = false;
  }

  getMyLastConversation(Map user) async {
    isMyLastConversationLoading.value = true;
    myLastConversation.value = await f.getMyLastConversation(user['id']);
    isMyLastConversationLoading.value = false;
    if (myLastConversation.value.length == 0) {
      generateMessageBox().then((value) {
        print(value);
        addMemberToMessageBox(value['id'], f.getUserId()).then((value) {
          print(value);
        });
        addMemberToMessageBox(value['id'], user['id']).then((value) {
          print(value);
        });
        Get.to(MessageDetail(receiverUser: user, roomID: value['id']));
      });
    } else {
      Get.to(MessageDetail(
          roomID: myLastConversation.value[0], receiverUser: user));
    }
    return myLastConversation.value;
  }

  getMyLastConversationReturnRoomID(Map user) async {
    isMyLastConversationLoading.value = true;
    myLastConversation.value = await f.getMyLastConversation(user['id']);
    isMyLastConversationLoading.value = false;
    if (myLastConversation.value.length == 0) {
      generateMessageBox().then((value) {
        print(value);
        addMemberToMessageBox(value['id'], f.getUserId()).then((value) {
          print(value);
        });
        addMemberToMessageBox(value['id'], user['id']).then((value) {
          print(value);
        });
        return myLastConversation.value[0];
      });
    } else {
      return myLastConversation.value[0];
    }
  }

  resetMessageCount(String messageBox) {
    f.resetMessageCount(messageBox);
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    photoUrl = downloadUrl;
    return downloadUrl;
  }

  openGallary({bool isCamera = false}) async {
    PickedFile picture = await ImagePicker().getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 600);
    file = File(picture.path);
    String downloadUrl = await uploadImage(file);
    return downloadUrl;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyMessageBoxes();
  }
}
