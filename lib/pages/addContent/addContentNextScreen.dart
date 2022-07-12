import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/addContent/addContentController.dart';
import 'package:video_player/video_player.dart';

class AddContentNextScreen extends StatefulWidget {
  bool isVideo;
  AddContentNextScreen(this.isVideo);
  @override
  _AddContentNextScreen createState() => _AddContentNextScreen();
}

class _AddContentNextScreen extends State<AddContentNextScreen> {
  AddContentController addContentController = Get.find();

  getPopulerTags() async {
    addContentController.searchTag('media');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPopulerTags();
    addContentController.choosenTag.clear();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isVideo) {
      addContentController.videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    addContentController.choosenTagEmpty.value = true;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'new post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SvgPicture.asset(
              'assets/icons/cancelIcon.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (addContentController.tagSearchController.text == '') {
                Get.snackbar('Error', 'Tag Giriniz');
              } else if (addContentController.fileLoading.value) {
                Get.snackbar('Error', 'Please wait for upload your file');
              } else {
                addContentController.createStory(
                    addContentController.downloadUrl.value,
                    'media',
                    widget.isVideo);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[500],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: addContentController.storyCreateLoading.value
                      ? CupertinoActivityIndicator()
                      : Icon(
                          Icons.chevron_right,
                        ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              height: Get.height * 0.15,
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Obx(
                        () => !widget.isVideo
                            ? addContentController.fileLoading.value
                                ? Container()
                                : Image.network(
                                    addContentController.downloadUrl.value,
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.2,
                                    fit: BoxFit.cover,
                                  )
                            : addContentController.fileLoading.value
                                ? Container()
                                : Container(
                                    height: Get.height * 0.1,
                                    width: Get.width * 0.2,
                                    child: AspectRatio(
                                      aspectRatio: addContentController
                                                  .videoPlayerController
                                                  .value
                                                  .size !=
                                              null
                                          ? addContentController
                                              .videoPlayerController
                                              .value
                                              .aspectRatio
                                          : 1.0,
                                      child: VideoPlayer(addContentController
                                          .videoPlayerController),
                                    ),
                                  ),
                      ),
                      Obx(
                        () => addContentController.choosenTagEmpty.value
                            ? addContentController.newTag.value != ''
                                ? Text(
                                    '#' + addContentController.newTag.value,
                                    style: TextStyle(
                                      color: oceanGreen,
                                      fontSize: 8,
                                    ),
                                  )
                                : Container()
                            : Text(
                                '#' + addContentController.choosenTag['name'],
                                style: TextStyle(
                                  color: oceanGreen,
                                  fontSize: 8,
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: Get.height * 0.15,
                    width: Get.width * 0.7,
                    child: TextField(
                      controller: addContentController.postField,
                      keyboardType: TextInputType.multiline,
                      maxLength: 25,
                      maxLines: null,
                      cursorColor: oceanGreen,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: "Write a caption...",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => addContentController.currentAddressLoading.value
                  ? Container()
                  : TextField(
                      cursorColor: oceanGreen,
                      controller: addContentController.addressController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
              // : Text(addContentController.currentAddress),
            ),
            Container(
              height: 1,
              width: Get.width,
              color: Colors.grey[200],
            ),
            TextField(
              controller: addContentController.tagSearchController,
              onChanged: (value) {
                addContentController.searchTag('media');
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 20),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 16.0, right: 16, bottom: 16),
                  child: SvgPicture.asset(
                    'assets/icons/searchIcon.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    onPressed: () {
                      addContentController.tagSearchResult.value.clear();
                      addContentController.tagSearchController.text = '';
                      addContentController.choosenTagEmpty.value = true;
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Obx(
                  () => addContentController.tagSearchLoading.value
                      ? Container()
                      : ListView.builder(
                          itemCount:
                              addContentController.tagSearchResult.value.length,
                          itemBuilder: (context, index) {
                            return tagSearchResultCard(addContentController
                                .tagSearchResult.value[index]);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tagSearchResultCard(Map tag) {
    return InkWell(
      onTap: () {
        addContentController.tagSearchController.text = tag['name'];
        addContentController.choosenTag.value = tag;
        addContentController.choosenTagEmpty.value = false;
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Color(0xfff5f5f6),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
          child: Text('#' + tag['name']),
        ),
      ),
    );
  }
}
