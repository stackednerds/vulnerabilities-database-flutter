import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vulnerabilities_database/screens/splash_activity.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vulnerabilities Database',
      home: SplashActivity(),
    );
  }
}
