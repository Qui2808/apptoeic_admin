import 'dart:async';

import 'package:apptoeic_admin/login_page.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    Timer(const Duration(seconds: 3), () {
       nextScreenReplace(context, Login());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            //color: Color.fromRGBO(117, 132, 103, 1),
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/plashscreen.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ));
  }
}
