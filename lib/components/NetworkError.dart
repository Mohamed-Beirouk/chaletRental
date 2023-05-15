import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:nudilk/screens/auth/signUp_screen.dart';
import 'package:nudilk/constants.dart';

import 'package:nudilk/components/MainButton.dart';


class NetworkError extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Profile',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
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
          // children: [
          //
          //   // Center(
          //   //   child: Image.asset(
          //   //     'assets/images/login.png',
          //   //     height: 220,
          //   //     width: 220,
          //   //   ),
          //   // ),
          //   // Padding(
          //   //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          //   // ),
          //   // Center(
          //   //   child: Text(
          //   //     "You have to login before.",
          //   //     style: TextStyle(
          //   //       fontWeight: FontWeight.w700,
          //   //       color:Colors.redAccent,
          //   //     ),
          //   //   ),
          //   // ),
          //   // Padding(
          //   //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          //   // ),
          //   // Center(
          //   //   child: Text(
          //   //     "bla bla bla",
          //   //   ),
          //   // ),
          //   // Padding(
          //   //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          //   // ),
          //   // Center(
          //   //   child: Text(
          //   //     "Second bla bla",
          //   //   ),
          //   // ),
          //   // Padding(
          //   //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          //   // ),
          //   // Padding(
          //   //   padding: const EdgeInsets.only(top: 20.0),
          //   //   child: MainButton(
          //   //     onpressed: () async {
          //   //
          //   //     },
          //   //     buttonText: 'Login',
          //   //     width: double.infinity,
          //   //   ),
          //   // ),
          // ],
        ),
      ),
    );
  }

}