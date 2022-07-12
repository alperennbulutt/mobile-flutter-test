import 'package:get/get.dart';
import 'package:snagom_app/services/fetch.dart';

class SearchController extends GetxController {
  var searchResult = [].obs;
  var resultsLoading = false.obs;
  FetchData f = FetchData();
  searchTag(String name, String type) async {
    resultsLoading.value = true;
    searchResult.value = await f.getTagByName(name, type);
    resultsLoading.value = false;
  }

  searchUser(String name) async {
    resultsLoading.value = true;
    searchResult.value = await f.getUserByName(name);
    resultsLoading.value = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
