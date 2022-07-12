import 'package:get/get.dart';
import 'package:snagom_app/services/fetch.dart';

class HomePageController extends GetxController {
  FetchData f = FetchData();
  var selectedSubIndex = 0.obs;
  var selectedIndex = 0.obs;
  var tagList = [].obs;
  var tagListLoading = true.obs;
  var searchResult = [].obs;
  var searchResultLoading = false.obs;
  var error = false.obs;
  var errorString = ''.obs;
  getTagList(String tagFilter, String tagDetail) async {
    tagList.clear();
    tagListLoading.value = true;
    var result = await f.getTags(tagFilter, tagDetail);
    if (result['success']) {
      tagList.value = result['data'];
      error.value = false;
    } else {
      errorString.value = result['error'];
      error.value = true;
    }

    tagListLoading.value = false;
  }

  search(String name, String type) async {
    searchResultLoading.value = true;
    searchResult.value = await f.getTagByName(name, type);
    searchResultLoading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTagList('general', 'media');
  }
}
