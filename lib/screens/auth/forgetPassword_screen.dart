import 'package:flutter/material.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/services/auth_helper.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String id = "ForgetPassword_screen";
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _ForgetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController? emailInputController;
  @override
  void initState() {
    emailInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Forget Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _ForgetPasswordFormKey,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Image.asset('assets/images/forgetPassword.png'),
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
                        topPadding: 55,
                        controller: emailInputController,
                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (value!.isEmpty) {
                            return 'please enter your email ';
                          } else if (!regex.hasMatch(value)) {
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Material(
                          color: kSecondaryAppColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30.0)),
                          //  elevation: 5.0,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () async {
                              if (_ForgetPasswordFormKey.currentState!
                                  .validate()) {
                                AuthHelper.authHelper
                                    .resetPassword(emailInputController!.text);
                              }
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'PlayfairDisplay',
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
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
