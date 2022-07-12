// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:holding_gesture/holding_gesture.dart';
// import 'package:snagom_app/globals/colors.dart';
// import 'package:snagom_app/pages/story/storyController.dart';
// import 'package:snagom_app/pages/story/widgets/storyImageCard.dart';
// import 'package:snagom_app/pages/story/widgets/storyScreenBottomBar.dart';
// import 'package:snagom_app/pages/story/widgets/storyTabCard.dart';
// import 'package:snagom_app/pages/story/widgets/storyTextCard.dart';
// import 'package:snagom_app/pages/story/widgets/storyVideoCard.dart';

// class StoryScreen extends StatelessWidget {
//   List stories;
//   StoryScreen(this.stories);
//   StoryController storyController = Get.put(StoryController());
//   Widget whichCard(int index) {
//     if (stories[index]['type'] == 1) {
//       return StoryTextCard(stories[index]);
//     } else {
//       if (stories[index].toString().split('.').elementAt(
//               stories[index]['imageUrl'].toString().split('.').length - 1) ==
//           'mp4') {
//         return StoryVideoCard(stories[index]);
//       } else {
//         return StoryImageCard(stories[index]);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: storyScreenBottomBar(),
//         backgroundColor: colorBackgroundBlack,
//         body: HoldDetector(
//           onHold: () {},
//           onTap: () {
//             storyController.activeStoryIndex.value++;
//           },
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     height: 5,
//                     width: Get.width,
//                     child: ListView.builder(
//                       itemCount: stories.length,
//                       scrollDirection: Axis.horizontal,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return StoryTabCard(stories, index);
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15.0, left: 8),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 15,
//                                   backgroundColor: Colors.white,
//                                   backgroundImage: NetworkImage(
//                                       storyController.userData['imageUrl']),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   storyController.userData['fullName'],
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   '15h',
//                                   style: TextStyle(
//                                     color: Colors.white30,
//                                     fontWeight: FontWeight.w100,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey[300],
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: SvgPicture.asset(
//                                       'assets/icons/cancelIcon.svg',
//                                       height: 20,
//                                       width: 20,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                               ],
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 12),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                       radius: 15,
//                                       backgroundColor: Colors.transparent),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           colorLightGreen,
//                                           colorGrassGreen,
//                                         ],
//                                       ),
//                                     ),
//                                     child: Obx(
//                                       () => Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 8.0,
//                                             right: 20,
//                                             top: 4,
//                                             bottom: 4),
//                                         child: Text(
//                                           '#' +
//                                               stories[storyController
//                                                   .activeStoryIndex
//                                                   .value]['tag']['name'],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Obx(
//                 () => whichCard(storyController.activeStoryIndex.value),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/models/storyModel.dart';
import 'package:snagom_app/pages/messages/messageController.dart';
import 'package:snagom_app/pages/profile/targetProfile.dart';
import 'package:snagom_app/pages/story/widgets/storyTextCard.dart';
import 'package:snagom_app/pages/tags/tagDetail.dart';
import 'package:snagom_app/services/fetch.dart';
import 'package:snagom_app/userMain/userMainController.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryScreen({@required this.stories});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  var ref;
  var user;
  TextEditingController textEditingController = TextEditingController();
  PageController _pageController;
  AnimationController _animController;
  VideoPlayerController _videoController;
  String roomID = '';
  MessageController messageController = Get.find();
  int _currentIndex = 0;
  bool isStopped = false;
  double animValue;
  @override
  void initState() {
    super.initState();
    user = GetStorage().read('UserData');
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: widget.stories[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref = FirebaseDatabase.instance.reference();
    final Story story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: HoldDetector(
        onHold: () {
          if (!isStopped) {
            isStopped = true;
            animValue = _animController.value;
            _animController.stop();
            if (story.media == MediaType.video) {
              _videoController.pause();
            }
          }
        },
        onCancel: () {
          if (isStopped) {
            isStopped = false;
            _animController.reset();
            _animController.forward(from: animValue);
            if (story.media == MediaType.video) {
              _videoController.play();
            }
          }
        },
        child: GestureDetector(
          onTapDown: (details) {
            if (!isStopped) {
              _onTapDown(details, story);
            }
          },
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.stories.length,
                itemBuilder: (context, i) {
                  final Story story = widget.stories[i];
                  switch (story.media) {
                    case MediaType.image:
                      {
                        return CachedNetworkImage(
                          imageUrl: story.url,
                          fit: BoxFit.cover,
                        );
                      }
                    case MediaType.video:
                      {
                        if (_videoController != null &&
                            _videoController.value.isInitialized) {
                          return FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                      break;
                    case MediaType.text:
                      {
                        return StoryTextCard(story);
                      }
                  }
                  // if (story.media == MediaType.image) {
                  //   CachedNetworkImage(
                  //     imageUrl: story.url,
                  //     fit: BoxFit.cover,
                  //   );
                  // } else if (story.media == MediaType.video) {
                  //   if (_videoController != null &&
                  //       _videoController.value.isInitialized) {
                  //     return FittedBox(
                  //       fit: BoxFit.cover,
                  //       child: SizedBox(
                  //         width: _videoController.value.size.width,
                  //         height: _videoController.value.size.height,
                  //         child: VideoPlayer(_videoController),
                  //       ),
                  //     );
                  //   }
                  // } else {
                  //   return StoryTextCard(story);
                  // }
                  return const SizedBox.shrink();
                },
              ),
              Positioned(
                top: 40.0,
                left: 10.0,
                right: 10.0,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: widget.stories
                          .asMap()
                          .map((i, e) {
                            return MapEntry(
                              i,
                              AnimatedBar(
                                animController: _animController,
                                position: i,
                                currentIndex: _currentIndex,
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (story.user['userId'] == FetchData().getUserId()) {
                          UserMainController mainController = Get.find();
                          mainController.bodyIndex.value = 4;
                          Get.back();
                        } else {
                          Get.to(TargetProfile(story.user['userId']));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                story.user['imageUrl'].toString() == 'null'
                                    ? profileIcon
                                    : story.user['imageUrl'],
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      story.user['fullName'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      story.deadLine.toString().toLowerCase(),
                                      style: TextStyle(
                                        color: Colors.white30,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    // Get.to(
                                    //   TagDetail(
                                    //     story.tag['id'],
                                    //     story.tag['name'],
                                    //     story.tag['storyCount'],
                                    //     story.tag['type'].toString(),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorLightGreen,
                                          colorGrassGreen,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 10,
                                          top: 4,
                                          bottom: 4),
                                      child: Text(
                                        '#' + story.tag['name'],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/cancelIcon.svg',
                                    height: 20,
                                    width: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              story.user['userId'] == FetchData().getUserId()
                  ? Container()
                  : Positioned(
                      bottom: 30,
                      child: storyScreenBottomBar(story),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSendChannelMessage(Story story) async {
    MessageController messageController = Get.put(MessageController());
    String text = textEditingController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      DateTime now = DateTime.now();
      ref.child(roomID).push().set({
        'message': textEditingController.text,
        'sender_date': now.toString().split('.')[0],
        'sender_nickname': user['fullName'],
        'sender_image': user['image'].toString(),
        'sender_id': user['id'],
        'answerStory_id': story.id,
        'answerStoryImage': story.url,
        'answerStoryIsImage': story.media == MediaType.image ? true : false,
        'isImage': false,
        'isLiked': false,
      });
      messageController.increaseMessageCount(roomID);
      textEditingController.clear();
      // await _channel.sendMessage(AgoraRtmMessage.fromText(text));
    } catch (errorCode) {
      print(errorCode);
      //_log('Send channel message error: ' + errorCode.toString());
    }
  }

  storyScreenBottomBar(Story story) {
    return Container(
      width: Get.width,
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: Get.width - 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[800],
            ),
            child: Theme(
              data: ThemeData(primaryColor: oceanGreen),
              child: TextField(
                controller: textEditingController,
                cursorColor: oceanGreen,
                onTap: () async {
                  if (!isStopped) {
                    isStopped = true;
                    animValue = _animController.value;
                    _animController.stop();
                    if (story.media == MediaType.video) {
                      _videoController.pause();
                    }
                  }
                },
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: '    Make a comment...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              story.toJson()['user']['id'] = story.toJson()['user']['userId'];
              messageController
                  .getMyLastConversationReturnRoomID(story.toJson()['user'])
                  .then((value) {
                roomID = value;
                _toggleSendChannelMessage(story);
                if (isStopped) {
                  isStopped = false;
                  _animController.reset();
                  _animController.forward(from: animValue);
                  if (story.media == MediaType.video) {
                    _videoController.play();
                  }
                }
              });
            },
            child: Container(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/sendIcon.svg',
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (!isStopped) {
                isStopped = true;
                animValue = _animController.value;
                _animController.stop();
                if (story.media == MediaType.video) {
                  _videoController.pause();
                }
              }
              showCupertinoModalPopup(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return CupertinoActionSheet(
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (isStopped) {
                          isStopped = false;
                          _animController.reset();
                          _animController.forward(from: animValue);
                          if (story.media == MediaType.video) {
                            _videoController.play();
                          }
                        }
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          FetchData().reportSpam(story.id);
                          Get.snackbar(
                              'Success', 'You have succesfully reported');
                        },
                        child: Text("Report",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/threeDotIcon.svg',
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex += 1;
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _currentIndex = 0;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
          _animController.stop();
        } else {
          _videoController.play();
          _animController.forward();
        }
      }
    }
  }

  void _loadStory({Story story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    if (story.media == MediaType.image) {
      _animController.duration = story.duration;
      _animController.forward();
    } else if (story.media == MediaType.video) {
      _videoController = null;
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(story.url)
        ..initialize().then((_) {
          setState(() {});
          if (_videoController.value.isInitialized) {
            _animController.duration = _videoController.value.duration;
            _videoController.play();
            _animController.forward();
          }
        });
    } else {
      _animController.duration = story.duration;
      _animController.forward();
    }

    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
