import 'package:get/get.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/profile/profileController.dart';

class StoryController extends GetxController {
  ProfileController profileController = Get.find();

  var activeStoryIndex = 0.obs;
  Map userData;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userData = profileController.profileActiveStories[0].user;
    if (userData['imageUrl'] == null) {
      userData['imageUrl'] = profileIcon;
    }
  }
}
