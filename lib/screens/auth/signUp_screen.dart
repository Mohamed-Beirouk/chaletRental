import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:nudilk/services/auth_helper.dart';
import '../../services/fireStorge_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "SignUp_screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String dropDownValue = 'User of the chalet';
  TextEditingController? emailInputController;
  TextEditingController? nameInputController;
  TextEditingController? phonenumberInputController;
  TextEditingController? pwdInputController;
  File? imagePath = File(
      "/Users/ibrahim/AndroidStudioProjects/nadilk/assets/images/User.png");

  Future imagePicker(source) async {
    final _picker = await ImagePicker().pickImage(source: source);
    if (_picker == null) {
      print('image is null');
    } else {
      setState(() {
        imagePath = File(_picker.path);
      });
    }
  }

  @override
  void initState() {
    emailInputController = TextEditingController();
    nameInputController = TextEditingController();
    phonenumberInputController = TextEditingController();
    pwdInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailInputController = TextEditingController();
    nameInputController = TextEditingController();
    phonenumberInputController = TextEditingController();
    pwdInputController = TextEditingController();
  }

  // List of items in our dropdown menu
  var items = [
    'User of the chalet',
    'owner of the chalet',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sign Up ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _signUpFormKey,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imagePath == null
                    ? Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: InkWell(
                    onTap: () {
                      imagePicker(ImageSource.gallery);
                    },
                    child: Image.asset('assets/images/User.png'),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: InkWell(
                    onTap: () {
                      imagePicker(ImageSource.gallery);
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: FileImage(
                        imagePath!,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your name ';
                          } else if (value.length < 6) {
                            return 'Name must be longer than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: nameInputController,
                        topPadding: 55,
                        hintText: 'Enter your Name',
                        labelText: "Name",
                        widgetIcon: const Icon(
                          Icons.person,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your phone number ';
                          } else if (value.length < 8) {
                            return 'phone number must be longer than 8 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: phonenumberInputController,
                        topPadding: 55,
                        hintText: 'Enter your phone number',
                        labelText: "phone number",
                        widgetIcon: const Icon(
                          Icons.phone,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
                        secure: false,
                        inputType: TextInputType.phone,
                      ),
                      MyTextFormField(
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
                        topPadding: 10,
                        controller: emailInputController,
                        hintText: 'Enter your Email',
                        labelText: "Email",
                        widgetIcon: const Icon(
                          Icons.email,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 30),
                            fillColor: Color(0xFFF1F1F1),
                            prefixIcon: Icon(
                              Icons.location_city,
                              size: 18,
                              color: Color(0xFF000033),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                          ),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue = newValue!;
                            });
                          },
                        ),
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your password ';
                          } else if (value.length < 8) {
                            return 'Password must be longer than 8 characters';
                          } else {
                            return null;
                          }
                        },
                        topPadding: 10,
                        controller: pwdInputController,
                        widgetIcon: const Icon(
                          Icons.lock,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
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
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your password ';
                          } else if (value.length < 8) {
                            return 'Password must be longer than 8 characters';
                          } else if (value != pwdInputController!.text) {
                            return 'Password must be the same Rewrite password';
                          } else {
                            return null;
                          }
                        },
                        topPadding: 10,
                        widgetIcon: const Icon(
                          Icons.lock,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
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
                        hintText: 'confirm Password',
                        labelText: "confirm Password",
                        secure: !_passwordVisible,
                        inputType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: MainButton(
                          onpressed: () async {
                            if (imagePath == null) {
                              Fluttertoast.showToast(
                                  msg: "please choose a pic",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            if (_signUpFormKey.currentState!.validate() &&
                                imagePath != null) {
                              String uid = await AuthHelper.authHelper.register(
                                Users(
                                  name: nameInputController!.text,
                                  phone: phonenumberInputController!.text,
                                  email: emailInputController!.text,
                                  password: pwdInputController!.text,
                                  file: imagePath,
                                  type: dropDownValue,
                                ),
                              );
                              UserFirebaseHelper.helper.addUser(
                                Users(
                                  name: nameInputController!.text,
                                  phone: phonenumberInputController!.text,
                                  email: emailInputController!.text,
                                  password: pwdInputController!.text,
                                  file: imagePath,
                                  type: dropDownValue,
                                ),
                              );

                              if (uid == null) {
                                Fluttertoast.showToast(
                                    msg: "try to sign up again ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                                Fluttertoast.showToast(
                                    msg: "Sign up successful",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                          buttonText: 'Sign Up',
                          width: double.infinity,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(LoginScreen.id);
                          },
                          child: const Text(
                            'Already Have Account ?',
                            style: TextStyle(
                                fontSize: 14,
                                color: kMainAppColor,
                                fontWeight: FontWeight.bold),
                          )),
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
