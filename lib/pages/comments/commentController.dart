import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/services/fetch.dart';

class CommentController extends GetxController {
  FetchData f = FetchData();
  var commentList = [].obs;
  var commentsLoading = false.obs;
  TextEditingController commentTextFieldController = TextEditingController();
  getPostComments(String postID) async {
    commentsLoading.value = true;
    commentList.value = await f.getPostComments(postID);
    commentsLoading.value = false;
  }

  toComment(String postId) async {
    if (commentTextFieldController.text.length < 2) {
      Get.snackbar('Error', 'Your comment is too short');
    } else {
      try {
        f.toComment(postId, commentTextFieldController.text).then((value) {
          if (value['success'] == true) {
            getPostComments(postId);
            commentTextFieldController.clear();
          } else {
            Get.snackbar('error', value['error'].toString());
          }
        });
      } catch (e) {
        getPostComments(postId);
        print(e);
      }
    }
  }
}
