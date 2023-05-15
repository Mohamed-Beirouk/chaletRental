import 'package:flutter/material.dart';
import 'package:nudilk/constants.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _mockCheckForSession().then(
      (status) {
        if (status) {
          _navigationToLogin();
        } else {
          _navigationToHome();
        }
      },
    );
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(seconds: 3), () {});
    return false;
  }

  void _navigationToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
    );
  }

  void _navigationToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Nadulk",
              style: TextStyle(
                fontSize: 40,
                color: kMainAppColor,
                fontFamily: 'Poppins',
              ),
            ),
            const Text(
              "RESERVE IT NOW!",
              style: TextStyle(
                fontSize: 14,
                color: kMainAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
