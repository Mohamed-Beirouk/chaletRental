import 'package:flutter/material.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/profileWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/UserScreen/updateProfile_screen.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/UsersProvider.dart';
import '../../services/auth_helper.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UsersProvider>(context, listen: false)
        .getUserByID(AuthHelper.authHelper.auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        elevation: 0,
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Consumer<UsersProvider>(
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
                left: 140,
                top: 30,
                child: Container(
                  child: userProvider.userid!.imageURL == null
                      ? Image.asset('assets/images/User.png')
                      : CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              NetworkImage('${userProvider.userid!.imageURL}'),
                        ),
                ),
              ),
              // Positioned(
              //   left: 150,
              //   top: 115,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              //         return UpDateProfileScreen(
              //           users: userProvider.userid,
              //         );
              //       }));
              //     },
              //     child: Image.asset('assets/images/editImageUser.png'),
              //   ),
              // ),
              Positioned(
                left: 150,
                top: 168,
                child: Text(
                  userProvider.userid == null
                      ? 'User Name'
                      : "${userProvider.userid!.name}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                            style:
                                TextStyle(fontSize: 22, color: kMainAppColor),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return UpDateProfileScreen(
                                      users: userProvider.userid!);
                                }));
                              },
                              icon: Image.asset(
                                  'assets/images/editImageUser.png')),
                        ],
                      ),
                      ProfileWidget(
                        width: width,
                        containerText: userProvider.userid == null
                            ? "UserName"
                            : userProvider.userid!.name,
                        widgetIcon: const Icon(
                          Icons.person,
                          color: Color(0xff000033),
                        ),
                      ),
                      ProfileWidget(
                        width: width,
                        containerText: userProvider.userid == null
                            ? "Test@test.com"
                            : userProvider.userid!.email,
                        widgetIcon: const Icon(
                          Icons.email,
                          color: Color(0xff000033),
                        ),
                      ),
                      ProfileWidget(
                        width: width,
                        isPassword: true,
                        containerText: 'passwsdasdasdasdord',
                        widgetIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff000033),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: MainButton(
                          onpressed: () {
                            AuthHelper.authHelper.logout();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return LoginScreen();
                            }));
                          },
                          width: width - 50,
                          buttonText: 'Log Out',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
