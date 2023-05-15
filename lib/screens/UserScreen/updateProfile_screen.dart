import 'package:flutter/material.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

import '../../provider/UsersProvider.dart';
import '../../services/auth_helper.dart';

class UpDateProfileScreen extends StatefulWidget {
  static const String id = "UpdateProfile_screen";
  Users? users;
  UpDateProfileScreen({this.users});
  @override
  State<UpDateProfileScreen> createState() => _UpDateProfileScreenState();
}

class _UpDateProfileScreenState extends State<UpDateProfileScreen> {
  TextEditingController? emailInputController = TextEditingController();
  TextEditingController? nameInputController = TextEditingController();
  TextEditingController? pwdInputController;
  @override
  void initState() {
    // TODO: implement initState
    emailInputController!.text = '${widget.users!.email}';
    nameInputController!.text = '${widget.users!.name}';
    pwdInputController = TextEditingController();
    super.initState();
    Provider.of<UsersProvider>(context, listen: false)
        .getUserByID(AuthHelper.authHelper.auth.currentUser!.uid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailInputController = TextEditingController();
    nameInputController = TextEditingController();
    pwdInputController = TextEditingController();
  }

  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: const Text('Update Profile'),
      ),
      body: Form(
        key: _globalKey,
        child: Consumer<UsersProvider>(
            builder: (context, userProvider, _) => Container(
                  child: Stack(
                    children: [
                      Positioned(
                          child: Container(
                        height: height,
                        width: width,
                        color: Colors.white,
                      )),
                      Positioned(
                          child: Container(
                        height: 87,
                        width: width,
                        color: kMainAppColor,
                      )),
                      Positioned(
                          child: Container(
                        height: 87,
                        width: width,
                        color: kMainAppColor,
                      )),
                      Positioned(
                        left: 140,
                        top: 30,
                        child: Container(
                          child: userProvider.userid == null
                              ? Image.asset('assets/images/User.png')
                              : CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(
                                      '${userProvider.userid!.imageURL}'),
                                ),
                        ),
                      ),
                      // Positioned(
                      //   left: 150,
                      //   top: 115,
                      //   child: Image.asset('assets/images/editImageUser.png'),
                      // ),
                      Positioned(
                        left: 150,
                        top: 168,
                        child: Text(
                          userProvider.userid == null
                              ? 'User Name'
                              : "${userProvider.userid!.name}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Positioned(
                        top: 200,
                        child: Container(
                          width: width,
                          margin: const EdgeInsets.only(
                            left: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'my info',
                                    style: TextStyle(
                                        fontSize: 22, color: kMainAppColor),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/images/editImageUser.png')),
                                ],
                              ),
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
                                topPadding: 10,
                                widgetIcon: const Icon(
                                  Icons.person,
                                  color: Color(0xff000033),
                                ),
                                width: width - 50,
                                hintText: 'update your Name',
                                labelText: "Name",
                                secure: false,
                                inputType: TextInputType.emailAddress,
                              ),
                              MyTextFormField(
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
                                topPadding: 10,
                                widgetIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xff000033),
                                ),
                                width: width - 50,
                                hintText: 'Update your Email',
                                labelText: "Email",
                                secure: false,
                                inputType: TextInputType.emailAddress,
                              ),
                              // MyTextFormField(
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'please enter your password ';
                              //     } else if (value.length < 8) {
                              //       return 'Password must be longer than 8 characters';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   controller: pwdInputController,
                              //   topPadding: 10,
                              //   widgetIcon: const Icon(
                              //     Icons.lock,
                              //     color: Color(0xff000033),
                              //   ),
                              //   width: width - 50,
                              //   hintText: 'Enter your Password',
                              //   labelText: "Password",
                              //   secure: true,
                              //   inputType: TextInputType.emailAddress,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: MainButton(
                                  onpressed: () {
                                    if (_globalKey.currentState!.validate()) {
                                      FireStoreHelper.fireStoreHelper
                                          .updateUserProfile(
                                        Users(
                                          id: userProvider.userid!.id,
                                          name: nameInputController!.text,
                                          email: emailInputController!.text,
                                        ),
                                        // pwdInputController!.text
                                      );
                                    }
                                  },
                                  width: width - 50,
                                  buttonText: 'Update',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
