import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/profileWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/UserScreen/updateProfile_screen.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:nudilk/screens/auth/signUp_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/UsersProvider.dart';
import '../../services/auth_helper.dart';

class GuestProfileScreen extends StatefulWidget {
  static const String id = "GuestProfile_screen";

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: kMainAppColor,
      //   centerTitle: true,
      //   title: const Text('Profile'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'Log in to start booking your next chalet.',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: kMainAppColor,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  'Log in',
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const Text(
                  'Don\'t have an Account ?',
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
// Container(
// child: Stack(
// children: [
// Positioned(
// child: Container(
// height: height,
// width: width,
// color: Colors.white,
// )),
// Positioned(
// child: Container(
// height: 87,
// width: width,
// color: kMainAppColor,
// )),
// Positioned(
// left: 140,
// top: 30,
// child: Image.asset('assets/images/User.png'),
// ),
// Positioned(
// left: 150,
// top: 115,
// child: InkWell(
// onTap: () {
// Fluttertoast.showToast(
// msg: 'Please first login to update the profile ',
// toastLength: Toast.LENGTH_SHORT,
// gravity: ToastGravity.CENTER,
// timeInSecForIosWeb: 1,
// backgroundColor: Colors.red,
// textColor: Colors.white,
// fontSize: 16.0);
// },
// child: Image.asset('assets/images/editImageUser.png')),
// ),
// Positioned(
// left: 150,
// top: 168,
// child: Text(
// 'User Name',
// style:
// const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// ),
// ),
// Positioned(
// top: 200,
// child: Container(
// width: width,
// margin: const EdgeInsets.only(
// left: 25,
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// const Text(
// 'my info',
// style: TextStyle(fontSize: 22, color: kMainAppColor),
// ),
// IconButton(
// onPressed: () {
// Fluttertoast.showToast(
// msg:
// 'Please first login to update the profile ',
// toastLength: Toast.LENGTH_SHORT,
// gravity: ToastGravity.CENTER,
// timeInSecForIosWeb: 1,
// backgroundColor: Colors.red,
// textColor: Colors.white,
// fontSize: 16.0);
// },
// icon:
// Image.asset('assets/images/editImageUser.png')),
// ],
// ),
// ProfileWidget(
// width: width,
// containerText: "UserName",
// widgetIcon: const Icon(
// Icons.person,
// color: Color(0xff000033),
// ),
// ),
// ProfileWidget(
// width: width,
// containerText: "Test@test.com",
// widgetIcon: const Icon(
// Icons.email,
// color: Color(0xff000033),
// ),
// ),
// ProfileWidget(
// width: width,
// isPassword: true,
// containerText: 'passwsdasdasdasdord',
// widgetIcon: const Icon(
// Icons.lock,
// color: Color(0xff000033),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 30),
// child: MainButton(
// onpressed: () {
// AuthHelper.authHelper.logout();
// Navigator.pushReplacement(context,
// MaterialPageRoute(builder: (_) {
// return LoginScreen();
// }));
// },
// width: width - 50,
// buttonText: 'Back To Login ',
// ),
// )
// ],
// ),
// ),
// ),
// ],
// ),
// )
