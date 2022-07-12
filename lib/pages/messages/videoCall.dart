// // App state class
// /// Define App ID and Token
// /// import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:flutter/material.dart';

// const APP_ID = '41e1bcfa94c640058e22076d2ea2e830';

// class VideoChannel extends StatefulWidget {
//   String roomID;
//   VideoChannel(this.roomID);
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<VideoChannel> {
//   bool _joined = false;
//   int _remoteUid = 0;
//   bool _switch = false;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // Init the app
//   Future<void> initPlatformState() async {
//     // Create RTC client instance
//     RtcEngineContext context = RtcEngineContext(APP_ID);
//     var engine = await RtcEngine.createWithContext(context);
//     // Define event handling logic
//     engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print('joinChannelSuccess ${channel} ${uid}');
//           setState(() {
//             _joined = true;
//           });
//         },
//         userJoined: (int uid, int elapsed) {
//           print('userJoined ${uid}');
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print('userOffline ${uid}');
//           setState(() {
//             _remoteUid = 0;
//           });
//         },
//       ),
//     );
//     // Enable video
//     await engine.enableVideo();
//     // Join channel with channel name as 123
//     print('kel');
//     print('tahir');
//     await engine.joinChannel(
//       '00641e1bcfa94c640058e22076d2ea2e830IABZYnjChmfaMF+7q7jxuz30UQ26E7BzoEcIAAD33HFyABJ7GgUAAAAAEADEGoyZMlp1YQEAAQAyWnVh',
//       'tahir',
//       null,
//       0,
//     );
//   }

//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter example app'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               width: 100,
//               height: 100,
//               color: Colors.blue,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _switch = !_switch;
//                   });
//                 },
//                 child: Center(
//                   child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Local preview
//   Widget _renderLocalPreview() {
//     if (_joined) {
//       return RtcLocalView.SurfaceView();
//     } else {
//       return Text(
//         'Please join channel first',
//         textAlign: TextAlign.center,
//       );
//     }
//   }

//   // Remote preview
//   Widget _renderRemoteVideo() {
//     if (_remoteUid != 0) {
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid,
//         channelId: "123",
//       );
//     } else {
//       return Text(
//         'Please wait remote user join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
