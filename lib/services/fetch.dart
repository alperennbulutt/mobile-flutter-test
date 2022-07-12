import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/services/rest_connector.dart';
import 'package:crypto/crypto.dart';

class FetchData extends GetxController {
  getJwtToken() {
    return GetStorage().read('jwtToken');
  }

  getUserId() {
    return GetStorage().read('userId');
  }

  checkEmailUsername(String nickname, String email) async {
    Map body = {
      "nickname": nickname,
      "email": email,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + '/api/v1/User/CheckNicknameEmail',
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  login(String nickname, String password) async {
    Map body = {
      "username": nickname,
      "password": md5.convert(utf8.encode(password)).toString(),
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + '/api/v1/User/Authenticate',
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  register(
      {String nickname,
      String email,
      String name,
      String surname,
      String password,
      String phone = ''}) async {
    Map body = {
      "nickname": nickname,
      "fullName": name,
      "email": email,
      "password": md5.convert(utf8.encode(password)).toString(),
      "phoneNumber": phone,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlRegister,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  getTags(String tagFilter, String tagFilterDetail) async {
    var response = await RestConnector(
      domain + urlTag + '/Search?Content=$tagFilter&Type=$tagFilterDetail',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response;
  }

  getTagList(String tagID, String content) async {
    var response = await RestConnector(
      domain + urlStory + '/Search?TagId=$tagID&content=$content',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getPostComments(String postID) async {
    var response = await RestConnector(
      domain + urlComments + '/GetByStoryId/$postID',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  toComment(String postID, String text) async {
    Map body = {
      "text": text,
      "userId": getUserId(),
      "storyId": postID,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlComments + '/CreateComment',
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  likePost(String postID) async {
    Map body = {
      "userId": getUserId(),
      "storyId": postID,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlLike,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  getProfileDatas(String userID) async {
    var response = await RestConnector(
      domain + urlGetUserDatas + '/$userID',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getProfilePosts(String userID) async {
    var response = await RestConnector(
      domain + '/api/v1/Story/GetPinnedStories' + '/$userID',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  Future isUserFollowed(String userID) async {
    var response = await RestConnector(
      domain + urlIsFollowed + '/$userID',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getTagByName(String name, String type) async {
    var response = await RestConnector(
      domain + urlGetTagByName + '?Name=$name&Type=$type',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getUserByName(String name) async {
    var response = await RestConnector(
      domain + urlGetUserByNmae + '?Name=$name',
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getNotifications() async {
    var response = await RestConnector(
      domain + urlGetNotifications,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  Future setNotifications() async {
    var response = await RestConnector(
      domain + urlSetNotifications,
      getJwtToken(),
      requestType: "POST",
      data: '',
    ).getData();
    return response['data'];
  }

  getNonBambooStories() async {
    var response = await RestConnector(
      domain + urlGetNonBambooStories + getUserId(),
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getBambooStories(String storyId) async {
    var response = await RestConnector(
      domain + urlGetBambooStory + storyId,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response;
  }

  followUser(String followedUserId) async {
    Map body = {
      "followedUserId": followedUserId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlFollowUser,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  unfollowUser(String followedUserId) async {
    Map body = {
      "followedUserId": followedUserId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUnFollowUser,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  getActiveStories(String userId) async {
    var response = await RestConnector(
      domain + urlGetActiveStories + userId,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  createPost({
    String desc,
    String mediaUrl,
    String type,
    String tagId,
    bool isImage,
    String location,
  }) async {
    Map body = {
      "description": desc,
      "imageUrl": mediaUrl,
      "type": type,
      "tagId": tagId,
      'isImage': isImage,
      'location': location,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      'http://snagom-env.eba-y2qhxe9g.us-east-2.elasticbeanstalk.com/api/v1/Story/CreateStory',
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['success'];
  }

  archiveStory(String postID) async {
    Map body = {
      "id": postID,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlArchiveStory,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  getPinnedPosts(String userId) async {
    var response = await RestConnector(
      domain + urlGetPinnedStory + userId,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  pinStory(String storyId) async {
    Map body = {
      "storyId": storyId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlPinStory,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  unpinStory(String storyId) async {
    Map body = {
      "storyId": storyId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUnPinStory,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  updateCoverImage(String newCoverImageUrl) async {
    Map body = {
      "newCoverImageUrl": newCoverImageUrl,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUpdateCoverImageUrl,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updateImage(String newImageUrl) async {
    Map body = {
      "newImageUrl": newImageUrl,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUpdateImage,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updatePhone(String newPhoneNumber) async {
    Map body = {
      "newPhoneNumber": newPhoneNumber,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUpdatePhone,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updateEmail(String newEmail) async {
    Map body = {
      "newEmail": newEmail,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUpdatePhone,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updatePassword(String newPassword) async {
    Map body = {
      "newPassword": md5.convert(utf8.encode(newPassword)).toString(),
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlUpdatePhone,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  getMyAllStories() async {
    var response = await RestConnector(
      domain + urlGetMyAllStories,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  generateMessageBox() async {
    var response = await RestConnector(
      domain + urlGenerateMessageBox,
      getJwtToken(),
      requestType: "POST",
      data: '',
    ).getData();
    return response['data'];
  }

  getMessageBoxById(String messageBoxID) async {
    var response = await RestConnector(
      domain + urlGetMessageBoxById,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  addMemberToMessageBox(String messageBoxId, String userId) async {
    Map body = {
      "messageBoxId": messageBoxId,
      "userId": userId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlAddMemberToMessageBox,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  increaseMessageCount(String messageBoxId) async {
    Map body = {
      "messageBoxId": messageBoxId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlIncreaseMessageCount,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  resetMessageCount(String messageBoxId) async {
    Map body = {
      "messageBoxId": messageBoxId,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlResetMessageCount,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  getMyMessageBoxes() async {
    var response = await RestConnector(
      domain + urlGetMyMessageBoxes,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getMyLastConversation(String userId) async {
    var response = await RestConnector(
      domain + urlGetMyLastCoversation + userId,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    return response['data'];
  }

  getResetCode(String email) async {
    Map body = {
      "email": email,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlForgetPasswordToken,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  confirmResetCode(String email, String resetCode) async {
    Map body = {
      "email": email,
      "resetCode": resetCode,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlConfirmResetCode,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  changePassword(String email, String resetCode, String password) async {
    Map body = {
      "email": email,
      "resetCode": resetCode,
      'password': md5.convert(utf8.encode(password)).toString(),
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlChangePassword,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  createTag(String name, int type) async {
    Map body = {
      "name": name,
      'type': type,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlCreateTag,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response['data'];
  }

  switchTag(String tagID, String content) async {
    var response = await RestConnector(
      domain + urlSwitchTag + '?tagId=' + tagID + '&content=' + content,
      getJwtToken(),
      requestType: "GET",
      data: '',
    ).getData();
    if (response['success']) {
      return response['data'];
    } else {
      return response['data'] = [];
    }
  }

  reportSpam(String storyId) async {
    Map body = {
      "reportTypeId": "13e910b1-b9a3-4049-865a-d4fde9748875",
      "about": storyId,
      "message": GetStorage().read('UserData')['nickname'] + ' bildirdi',
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlReport,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
  }

  reportBug(String topic, String content) async {
    Map body = {
      "reportTypeId": "a3e7ec8c-94e8-43b8-91c0-45f05d98b272",
      "about": topic,
      "message": content,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlReport,
      getJwtToken(),
      requestType: "POST",
      data: jsonBody,
    ).getData();
    return response;
  }

  updateNickname(String newNickname) async {
    Map body = {
      'newNickname': newNickname,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlChangeNickname,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updateFullname(String newName) async {
    Map body = {
      'newFullname': newName,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlChangeFullname,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }

  updateBiography(String newBiography) async {
    Map body = {
      'newBiography': newBiography,
    };
    var jsonBody = JsonEncoder().convert(body);
    var response = await RestConnector(
      domain + urlupdateBiography,
      getJwtToken(),
      requestType: "PUT",
      data: jsonBody,
    ).getData();
    return response;
  }
}
