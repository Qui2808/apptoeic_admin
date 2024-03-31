import 'dart:async';

import 'package:apptoeic_admin/HomePage.dart';
import 'package:apptoeic_admin/admin_main_page.dart';
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
      // sp.isSignedIn == false
      //     ? nextScreen(context, LoginScreen())
      //     : nextScreen(context, const HomeScreen());
      // print(sp.role);
      // if (sp.role == 1) {
      //   nextScreenReplace(context, const MainPageAdmin());
      // } else if (sp.role == 2) {
      //   nextScreenReplace(context, const MainPageStaff());
      // } else {
      //   nextScreenReplace(context, const MainPage());
      // }
       nextScreenReplace(context, Admin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            //color: Color.fromRGBO(117, 132, 103, 1),
            color: Colors.white,
            child: const Center(
                child: Image(
              image: AssetImage('assets/events/sukien1.jpg'),
              height: 80,
              width: 80,
            ))));
  }
}
