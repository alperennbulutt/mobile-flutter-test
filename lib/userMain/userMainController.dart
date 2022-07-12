import 'package:get/get.dart';
import 'package:snagom_app/models/storyModel.dart';
import 'package:snagom_app/services/fetch.dart';

class UserMainController extends GetxController {
  var bodyIndex = 0.obs;
  var isTagDetail = false.obs;
  var profileActiveStories = RxList<Story>();
  var profileActiveStoriesLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getActiveStories();
  }

  getActiveStories() {
    profileActiveStoriesLoading.value = true;
    String userID = FetchData().getUserId();
    if (userID != null) {
      FetchData().getActiveStories(userID).then((value) {
        profileActiveStories.value =
            (value as List).map((e) => Story.fromJson(e)).toList();
        profileActiveStoriesLoading.value = false;
      });
    } else {
      profileActiveStories.clear();
      profileActiveStoriesLoading.value = false;
    }
  }
}
