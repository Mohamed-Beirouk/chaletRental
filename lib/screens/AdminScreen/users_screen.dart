import 'package:flutter/material.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Users.dart';
import 'package:provider/provider.dart';

import '../../provider/UsersProvider.dart';

class UsersScreen extends StatefulWidget {
  static const String id = "Users_screen";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<UsersProvider>(context, listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Users> usersList = Provider.of<UsersProvider>(context).users.toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kMainAppColor,
      ),
      body: usersList.isEmpty
          ? Container(
              width: double.infinity,
              child: Center(
                child: Image.asset('assets/images/emptyBooking.png'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Container(
                      height: 100,
                      width: width - 20,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Container(
                              height: 70,
                              width: 120,
                              child: usersList[index].imageURL == null
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/User.png',
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        usersList[index].imageURL!,
                                      ),
                                    ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              usersList[index].name == null
                                  ? Text(
                                      'Users Named',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      usersList[index].name!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              usersList[index].email == null
                                  ? Text(
                                      'Email or Phone number ',
                                      style:
                                          TextStyle(color: Color(0xff2C66A3)),
                                    )
                                  : Text(
                                      usersList[index].email!,
                                      style:
                                          TextStyle(color: Color(0xff2C66A3)),
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
