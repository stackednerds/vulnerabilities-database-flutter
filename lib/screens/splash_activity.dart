import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vulnerabilities_database/main_activity.dart';

class SplashActivity extends StatefulWidget {
  const SplashActivity({Key? key}) : super(key: key);

  @override
  State<SplashActivity> createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 1900),
          () => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainActivity(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: const Text(
                'version 1.0 beta',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 14.0,
                    color: Colors.white
                ),
              ),
            ),
            Column(
              children: [
                const Text(
                  'Vulnerabilities\nDatabase',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 37.0,
                      color: Colors.white,
                      letterSpacing: 2.0
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Powered by  |   ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                    Image.asset("assets/logo.png"),
                  ],
                ),
              ],
            ),
            LoadingAnimationWidget.waveDots(
              size: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

