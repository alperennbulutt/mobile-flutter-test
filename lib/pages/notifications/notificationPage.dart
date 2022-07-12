import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/notifications/notificationController.dart';

import 'notificationCard.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationController notificationController = Get.find();
    notificationController.notificationsSeen();
    return Scaffold(
      body: Obx(
        () => notificationController.notificationsLoading.value
            ? Container()
            : notificationController.notifications.length == 0
                ? Center(
                    child: Text(
                      'There is no notification to see',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notificationController.notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                          notificationController.notifications[index]);
                    },
                  ),
      ),
    );
  }
}
