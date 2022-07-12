import 'package:get/get.dart';
import 'package:snagom_app/services/fetch.dart';

class NotificationController extends GetxController {
  FetchData f = FetchData();
  var notifications = [].obs;
  var notificationsLoading = true.obs;
  var unSeenNotificationCount = 0.obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    notifications.value = await f.getNotifications();
    if (notifications.value == null) {
      notifications.value = [];
    }
    for (int i = 0; i < notifications.value.length; i++) {
      if (notifications.value[i]['status'] == 0) {
        unSeenNotificationCount.value++;
      }
    }
    notificationsLoading.value = false;
  }

  notificationsSeen() {
    if (notifications.length != 0) {
      for (int i = 0; i < notifications.value.length; i++) {
        if (notifications.value[i]['status'] == 0) {
          notifications.value[i]['status'] = 1;
        }
      }
      f.setNotifications().then((value) {
        unSeenNotificationCount.value = 0;
      });
    }
  }
}
