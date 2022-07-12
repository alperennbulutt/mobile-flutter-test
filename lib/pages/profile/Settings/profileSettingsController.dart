import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:uuid/uuid.dart';

class ProfileSettingsController extends GetxController {
  TextEditingController reportTopicController = TextEditingController();
  TextEditingController reportContentController = TextEditingController();
  var fileLoading = false.obs;
  FetchData f = FetchData();
  File file;
  openGallary() async {
    PickedFile picture = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 600);
    file = File(picture.path);
    uploadImage(file);
  }

  Future<void> uploadImage(File imageFile) async {
    fileLoading.value = true;
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    downloadUrl = downloadUrl;
    fileLoading.value = false;
  }

  Future reportSpam() {
    f.reportBug(reportTopicController.text, reportContentController.text);
    Get.snackbar('Success', 'Thanks your feedback');
  }
}
