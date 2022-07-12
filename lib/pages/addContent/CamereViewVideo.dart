import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/addContent/addContentController.dart';
import 'package:snagom_app/pages/addContent/addContentText.dart';
import 'package:video_player/video_player.dart';
import 'SeeMedia.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CameraViewVideo extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _CameraExampleHomeState extends State<CameraViewVideo>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController controller;
  XFile imageFile;
  XFile videoFile;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  AnimationController _flashModeControlRowAnimationController;
  Animation<double> _flashModeControlRowAnimation;
  AnimationController _exposureModeControlRowAnimationController;
  AnimationController _focusModeControlRowAnimationController;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool loading = true;
  bool recording = false;
  List<CameraDescription> cameras;
  int cameraIndex = 0;
  Timer _timer;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  bool isFlashOn = false;
  String downloadUrl;
  AddContentController addContentController = Get.put(AddContentController());
  initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[cameraIndex], ResolutionPreset.max);
    await controller.initialize().then((value) {
      print("camera initiliazed");
      setState(() {
        loading = false;
      });
    });
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (addContentController.startTime.value == 31000) {
          addContentController.startTime.value = 0;
          timer.cancel();
        } else {
          setState(() {
            addContentController.startTime.value++;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    _fetchAssets();
    _ambiguate(WidgetsBinding.instance).addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance).removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    addContentController.startTime.value = 0;
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Container()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: _cameraPreviewWidget(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      height: 175,
                      width: MediaQuery.of(context).size.width,
                      // child: Column(
                      //   children: [
                      //     _captureControlRowWidget(),
                      //     _modeControlRowWidget(),
                      //     Padding(
                      //       padding: const EdgeInsets.all(5.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           _thumbnailWidget(),
                      //           _cameraTogglesRowWidget(),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _thumbnailWidget(),
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: HoldDetector(
                                  onHold: () {
                                    if (controller != null &&
                                        controller.value.isInitialized &&
                                        !controller.value.isRecordingVideo) {
                                      if (recording == false) {
                                        recording = true;
                                        print('onrecording');
                                        onVideoRecordButtonPressed();
                                        startTimer();
                                        Timer(Duration(seconds: 31), () {
                                          print('timer end');

                                          if (recording == true) {
                                            recording = false;
                                            addContentController
                                                .startTime.value = 0;
                                            _timer.cancel();
                                            addContentController
                                                .startTime.value = 0;
                                            onStopButtonPressed();
                                          }
                                        });
                                      }
                                    }
                                  },
                                  onTap: () {
                                    if (controller != null &&
                                        controller.value.isInitialized &&
                                        !controller.value.isRecordingVideo) {
                                      onTakePictureButtonPressed();
                                    }
                                  },
                                  onCancel: () {
                                    if (controller != null &&
                                        controller.value.isInitialized &&
                                        controller.value.isRecordingVideo) {
                                      if (recording == true) {
                                        recording = false;
                                        addContentController.startTime.value =
                                            0;
                                        print('onpaused');
                                        addContentController.startTime.value =
                                            0;
                                        _timer.cancel();
                                        onStopButtonPressed();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: CircularPercentIndicator(
                                      radius: 100.0,
                                      lineWidth: 5.0,
                                      percent: (addContentController
                                                  .startTime.value *
                                              1) /
                                          31000,
                                      backgroundColor: Colors.transparent,
                                      center: Image.asset(
                                        'assets/icons/videoPlay.png',
                                        height: 75,
                                        width: 75,
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: oceanGreen,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              _cameraTogglesRowWidget(),
                            ],
                          ),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     if (addContentController
                                  //             .cameraSubIndex.value !=
                                  //         0) {
                                  //       addContentController
                                  //           .cameraSubIndex.value = 0;
                                  //       Get.off(CameraViewImage());
                                  //     }
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       SvgPicture.asset(
                                  //         'assets/icons/mediaIcon.svg',
                                  //         height: 40,
                                  //         width: 40,
                                  //         color: Colors.white,
                                  //       ),
                                  //       SizedBox(height: 10),
                                  //       Container(
                                  //         height: 1.5,
                                  //         width: 40,
                                  //         color: addContentController
                                  //                     .cameraSubIndex.value ==
                                  //                 0
                                  //             ? Colors.white
                                  //             : Colors.transparent,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      if (addContentController
                                              .cameraSubIndex.value !=
                                          1) {
                                        addContentController
                                            .cameraSubIndex.value = 1;
                                        Get.off(AddContentText());
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/textIcon.svg',
                                          height: 40,
                                          width: 40,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 1.5,
                                          width: 40,
                                          color: addContentController
                                                      .cameraSubIndex.value ==
                                                  1
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (addContentController
                                              .cameraSubIndex.value !=
                                          2) {
                                        addContentController
                                            .cameraSubIndex.value = 2;
                                        Get.off(CameraViewVideo());
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/videoIcon.svg',
                                          height: 40,
                                          width: 40,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 1.5,
                                          width: 40,
                                          color: addContentController
                                                      .cameraSubIndex.value ==
                                                  2
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (isFlashOn) {
                                  setState(() {
                                    isFlashOn = false;
                                  });
                                  onSetFlashModeButtonPressed(FlashMode.off);
                                } else {
                                  setState(() {
                                    isFlashOn = true;
                                  });
                                  onSetFlashModeButtonPressed(FlashMode.torch);
                                }
                              },
                              child: Icon(
                                isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/cancelIcon.svg',
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
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

  openGalleryWidget() {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                File file =
                    await addContentController.openGallary(isVideo: true);
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeMedia(
                      videoFile: file,
                      isVideo: true,
                      photoFile: File(file.path),
                    ),
                  ),
                );
              },
              child: Text("Video",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blue)),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                File file = await addContentController.openGallary();
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeMedia(
                      videoFile: null,
                      isVideo: false,
                      photoFile: File(file.path),
                    ),
                  ),
                );
              },
              child: Text("Photo",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile file) {
      if (mounted) {
        setState(() {
          //  uploadImage(File(file.path));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeeMedia(
                videoFile: null,
                isVideo: false,
                photoFile: File(file.path),
              ),
            ),
          );
          imageFile = file;
          if (videoController != null) {
            videoController.dispose();
            videoController = null;
          }
        });
        if (file != null) print('Picture saved to ${file.path}');
      }
    });
  }

  Future<XFile> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  List<AssetEntity> assets = [];
  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1, // end at a very big index (to get all the assets)
    );
    print(recentAssets);
    setState(() {
      assets = recentAssets;
    });
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          openGalleryWidget();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            assets.length == 0
                ? Container(
                    width: 64.0,
                    height: 64.0,
                  )
                : FutureBuilder<File>(
                    future: assets.first
                        .file, // a previously-obtained Future<String> or null
                    builder:
                        (BuildContext context, AsyncSnapshot<File> snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.file(snapshot.data),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    final onChanged = (CameraDescription description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    };

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo
                  ? null
                  : onChanged,
            ),
          ),
        );
      }
    }

    //  return Row(children: toggles);
    return IconButton(
        onPressed: () async {
          if (controller != null && controller.value.isRecordingVideo) {
            return null;
          } else {
            if (cameraIndex == 1) {
              cameraIndex = 0;

              controller =
                  CameraController(cameras[cameraIndex], ResolutionPreset.max);
              await controller.initialize().then((value) {
                print("camera initiliazed");
                setState(() {
                  loading = false;
                });
              });
            } else {
              cameraIndex = 1;
              controller =
                  CameraController(cameras[cameraIndex], ResolutionPreset.max);
              await controller.initialize().then((value) {
                print("camera initiliazed");
                setState(() {
                  loading = false;
                });
              });
            }
          }
        },
        // onPressed: () => controller != null && controller.value.isRecordingVideo
        //     ? null
        //     : onChanged,
        icon: Icon(Icons.cameraswitch, color: Colors.white));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      print('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    print('start');
    startVideoRecording().then((_) {
      // if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        print('Video recorded to ${file.path}');
        videoFile = file;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeeMedia(
              videoFile: File(file.path),
              isVideo: true,
              photoFile: File(file.path),
            ),
          ),
        );
      }
    });
  }

  Future<void> startVideoRecording() async {
    if (controller == null || !controller.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      if (controller.value.isInitialized) {
        await controller.startVideoRecording();
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile> stopVideoRecording() async {
    final CameraController cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    print('Error: ${e.code}\n${e.description}');
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
// TODO(ianh): Remove this once we roll stable in late 2021.
T _ambiguate<T>(T value) => value;
