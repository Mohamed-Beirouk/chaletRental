import 'package:flutter/material.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/AdminScreen/adminPanel_screen.dart';
import 'package:nudilk/screens/UserScreen/home_screen.dart';
import 'package:nudilk/screens/auth/forgetPassword_screen.dart';
import 'package:nudilk/screens/auth/signUp_screen.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:nudilk/services/fireStore_helper.dart';

import '../owner/OwnerHomeScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool isLoaded = false;

  TextEditingController? emailInputController;
  TextEditingController? pwdInputController;

  @override
  void initState() {
    emailInputController = TextEditingController();
    pwdInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailInputController = TextEditingController();

    pwdInputController = TextEditingController();
  }

  String? id;
  String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Image.asset('assets/images/loginScreen.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MyTextFormField(
                        controller: emailInputController,
                        topPadding: 55,
                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (value!.isEmpty) {
                            setState(() {
                              isLoaded=false;
                            });
                            return 'please enter your email ';
                          } else if (!regex.hasMatch(value)) {
                            setState(() {
                              isLoaded=false;
                            });
                            return 'Email format is invalid';
                          } else {

                            return null;
                          }
                        },
                        hintText: 'Enter your Email',
                        labelText: "Email",
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        controller: pwdInputController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              isLoaded=false;
                            });
                            return 'please enter your password ';
                          } else if (value.length < 8) {
                            setState(() {
                              isLoaded=false;
                            });
                            return 'Password must be longer than 8 characters';
                          } else if (value != pwdInputController!.text) {
                            setState(() {
                              isLoaded=false;
                            });
                            return 'Password must be the same Rewrite password';
                          } else {
                            return null;
                          }
                        },
                        topPadding: 10,
                        widgetIcon2: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter your Password',
                        labelText: "Password",
                        secure: !_passwordVisible,
                        inputType: TextInputType.emailAddress,
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.of(context)
                      //           .pushNamed(ForgetPasswordScreen.id);
                      //     },
                      //     child: const Text(
                      //       'Forget Password?',
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           color: kMainAppColor,
                      //           fontWeight: FontWeight.bold),
                      //     )),
                      Material(
                        color: kSecondaryAppColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30.0)),
                        //  elevation: 5.0,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            setState(() {
                              isLoaded=true;
                            });

                            if (_loginFormKey.currentState!.validate()) {
                              final uid = await AuthHelper.authHelper.login(
                                  emailInputController!.text,
                                  pwdInputController!.text);

                              final user = await FireStoreHelper.fireStoreHelper
                                  .getUsertype(uid);
                              if (uid != null && user == 'User of the chalet') {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                      return HomeScreen();
                                    }));
                              } else if (uid != null &&
                                  user == 'owner of the chalet') {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                      return OwnerHomeScreen();
                                    }));
                              } else if (uid != null && user == 'Admin') {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                      return AdminPanelScreen();
                                    }

                                    ));
                              }
                              else{
                                setState(() {
                                  isLoaded=false;
                                });
                              }
                            }
                          },
                          child:
                          isLoaded?
                          CircularProgressIndicator(
                            color: Colors.black,
                          )
                              :
                          Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'PlayfairDisplay',
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Color(0xFFF1F1F1),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(30.0)),
                              //  elevation: 5.0,
                              child: MaterialButton(
                                minWidth:
                                MediaQuery.of(context).size.width / 2.5,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SignUpScreen.id);
                                },
                                child: const Text(
                                  'sign up',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'PlayfairDisplay',
                                    color: kMainAppColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(width: 3, color: kMainAppColor),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              child: Material(
                                color: Colors.white10,

                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0)),

                                //  elevation: 5.0,
                                child: MaterialButton(
                                  minWidth:
                                  MediaQuery.of(context).size.width / 2.5,
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return HomeScreen(
                                            isGuest: true,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'guest',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'PlayfairDisplay',
                                      color: kMainAppColor,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
