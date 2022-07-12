import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/addContent/addContentController.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'CameraViewImage.dart';
import 'CamereViewVideo.dart';

class AddContentText extends StatelessWidget {
  AddContentController addContentController = Get.put(AddContentController());
  @override
  Widget build(BuildContext context) {
    addContentController.searchTag('text');
    addContentController.choosenTagEmpty.value = true;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
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
          Obx(() => addContentController.storyCreateLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CupertinoActivityIndicator(),
                )
              : InkWell(
                  onTap: () {
                    addContentController.createTwit();
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
                          child: Icon(
                            Icons.chevron_right,
                          )),
                    ),
                  ),
                ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorLightGreen,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              GetStorage()
                                          .read('UserData')['imageUrl']
                                          .toString() ==
                                      'null'
                                  ? profileIcon
                                  : GetStorage().read('UserData')['imageUrl'],
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
                    Expanded(
                      child: Container(
                        child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            addContentController.addTwitTextFieldLength.value =
                                double.parse(value.length.toString());
                          },
                          maxLength: 231,
                          controller: addContentController.postField,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: oceanGreen,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: "What's happening?",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            ),
            TextField(
              controller: addContentController.tagSearchController,
              onChanged: (value) {
                addContentController.searchTag('text');
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 20),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16, bottom: 16),
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
                      addContentController.choosenTag.value.clear();
                      addContentController.choosenTagEmpty.value = true;
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Obx(
                  () => ListView.builder(
                    itemCount:
                        addContentController.tagSearchResult.value.length,
                    itemBuilder: (context, index) {
                      return tagSearchResultCard(
                          addContentController.tagSearchResult.value[index]);
                    },
                  ),
                ),
              ),
            ),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (addContentController.cameraSubIndex.value != 1) {
                          addContentController.cameraSubIndex.value = 1;
                          Get.off(AddContentText());
                        }
                      },
                      child: Container(
                        width: Get.width / 3 - 5,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/textIcon.svg',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 1.5,
                              width: 40,
                              color:
                                  addContentController.cameraSubIndex.value == 1
                                      ? Colors.black
                                      : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (addContentController.cameraSubIndex.value != 2) {
                          addContentController.cameraSubIndex.value = 2;
                          Get.off(CameraViewVideo());
                        }
                      },
                      child: Container(
                        width: Get.width / 3 - 5,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/videoIcon.svg',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 1.5,
                              width: 40,
                              color:
                                  addContentController.cameraSubIndex.value == 2
                                      ? Colors.black
                                      : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Container(
                        width: Get.width / 3 - 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey[200],
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    radiusFactor: 1,
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        color: oceanGreen,
                                        value: addContentController
                                            .addTwitTextFieldLength.value,
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                      )
                                    ],
                                    minimum: 0,
                                    maximum: 231,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.endCurve,
                                      color: Color.fromARGB(30, 50, 150, 200),
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
