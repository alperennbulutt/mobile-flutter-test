import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/comments/commentController.dart';

class CommentPage extends StatelessWidget {
  String postID;
  CommentPage(
    this.postID,
  );
  CommentController commentController = Get.put(CommentController());
  @override
  Widget build(BuildContext context) {
    commentController.getPostComments(postID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbfafa),
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SvgPicture.asset(
              'assets/icons/backIcon.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
      ),
      body: Obx(
        () => commentController.commentsLoading.value
            ? Container()
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: commentController.commentList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              print('sikayet etme pop upu');
                            },
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  commentController.commentList[index]['user']
                                              ['image'] ==
                                          null
                                      ? NetworkImage(profileIcon)
                                      : NetworkImage(commentController
                                          .commentList[index]['user']['image']),
                            ),
                            title: Text(commentController.commentList[index]
                                ['user']['fullName']),
                            subtitle: Text(
                                commentController.commentList[index]['text']),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, bottom: 20.0, right: 14),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                cursorColor: oceanGreen,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                minLines: 1,
                                maxLines: 4,
                                controller: commentController
                                    .commentTextFieldController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Comment as ${GetStorage().read('UserData')['fullName']}...',
                                  border: InputBorder.none,
                                  suffixIcon: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          .unfocus();
                                      commentController.toComment(postID);
                                    },
                                    child: Icon(Icons.send, color: Colors.blue),
                                  ),
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
    );
  }
}
