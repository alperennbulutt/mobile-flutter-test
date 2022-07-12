import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:snagom_app/pages/login/loginPage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snagom_app/pages/register/registerFirstStep.dart';
import 'package:snagom_app/pages/register/registerSecondStep.dart';
import 'package:snagom_app/userMain/userMain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Snagom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SamsungSharpsansMedium',
        primarySwatch: Colors.blue,
      ),
      home: GetStorage().read('jwtToken') == null ? LoginPage() : UserMain(),
    );
  }
}
