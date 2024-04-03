import 'package:apptoeic_admin/admin_main_page.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/const_container.dart';
import 'package:apptoeic_admin/utils/data_helper.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userName = TextEditingController();
  final password = TextEditingController();

  late SharedPreferences logindata;
  final _scaffoldKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController loginController =
      RoundedLoadingButtonController();
  String pss = "test";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    check();
  }

  void check() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Form(
              key: _scaffoldKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/bee.png"),
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  inputDecoration(
                    hint: 'Enter your email',
                    inputcontroller: userName,
                  ),
                  inputDecorationPassword(
                    passwordHint: "Password",
                    passwordController: password,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          // Bo góc
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 4, // Độ đổ bóng
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future login() async {
    if (userName.text.isNotEmpty) {
      String user = userName.text.toString().trim();
      String pass = password.text.toString().trim();
      bool isLoggedIn = await checkLogin(user, pass);
      if (isLoggedIn) {
        nextScreenReplace(context, Admin(index: 0,));
      } else {
        const snackBar = SnackBar(content: Text("Your information is not correct"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(content: Text("Please enter your account name"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // loginController.reset();
    }
  }
}
