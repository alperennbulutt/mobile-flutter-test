import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/pages/bamboo/widgets/bambooVideoCard.dart';

class BambooAnimationCard extends StatefulWidget {
  Map myStory;
  Map matchStory;
  String tagName;
  BambooAnimationCard(this.myStory, this.matchStory, this.tagName);
  @override
  _BambooLeftCard createState() => _BambooLeftCard();
}

class _BambooLeftCard extends State<BambooAnimationCard> {
  double leftValue;
  double rightValue;
  double pandaValue = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leftValue = 0.0;
    rightValue = 0.0;
    Timer(Duration(milliseconds: 1), () {
      setState(() {
        leftValue = Get.height * 0.35;
        rightValue = Get.height * 0.4;
      });
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        pandaValue = 1.0;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        pandaValue = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.5,
      child: Stack(
        children: [
          Positioned(
            left: -Get.width * 0.70,
            bottom: 0,
            child: AnimatedPadding(
              duration: Duration(seconds: 1),
              padding: EdgeInsets.only(
                //left: Get.height * 0.35,
                left: leftValue,
              ),
              child: Container(
                height: Get.height * 0.35,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200],
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: Get.width * 0.4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4,
                          ),
                          child: Center(
                            child: Text('#' + widget.tagName),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: Get.height * 0.3,
                        width: Get.width * 0.55,
                        child: widget.myStory['type'].toString() == '0'
                            ? widget.myStory['isImage']
                                ? Image.network(
                                    widget.myStory['imageUrl'],
                                    height: Get.height * 0.4,
                                    width: Get.width * 0.55,
                                    fit: BoxFit.cover,
                                  )
                                : BambooVideoCard(widget.myStory)
                            : Center(
                                child: Text(
                                  widget.myStory['description'],
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -Get.width * 0.70,
            child: AnimatedPadding(
              duration: Duration(seconds: 1),
              padding: EdgeInsets.only(
                right: rightValue,
              ),
              child: Container(
                height: Get.height * 0.35,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200],
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: Get.width * 0.4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4,
                          ),
                          child: Text('#' + widget.tagName),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: Get.height * 0.3,
                        width: Get.width * 0.55,
                        child: widget.matchStory['type'].toString() == '0'
                            ? widget.matchStory['isImage']
                                ? Image.network(
                                    widget.matchStory['imageUrl'],
                                    height: Get.height * 0.4,
                                    width: Get.width * 0.55,
                                    fit: BoxFit.cover,
                                  )
                                : BambooVideoCard(widget.matchStory)
                            : Center(
                                child: Text(
                                  widget.matchStory['description'],
                                ),
                              ),
                      ),
                    )
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Container(
                    //     color: Colors.white,
                    //     width: 100,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           SvgPicture.asset(
                    //             'assets/icons/hearthIcon.svg',
                    //             height: 20,
                    //             width: 20,
                    //             color: oceanGreen,
                    //           ),
                    //         //  Text('237')
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: pandaValue,
            duration: Duration(seconds: 1),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/pandaIcon.svg',
                height: 200,
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
