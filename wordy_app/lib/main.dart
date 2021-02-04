// Wordy
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordy_app/page/splash_page.dart';
import 'package:wordy_app/util/app_constant.dart';
import 'package:wordy_app/page/home/home_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstant.appName,
      initialRoute: AppConstant.pageSplash,
      routes: {
        AppConstant.pageSplash: (context) => SplashPage(),
        AppConstant.pageHome: (context) => HomeNavigator(),
      },
    );
  }
}
