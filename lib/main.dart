import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiteke/constants/colors.dart';
import 'package:jiteke/views/splash_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: bgColor,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',

      ),
      home: SplashView(),
    );
  }
}