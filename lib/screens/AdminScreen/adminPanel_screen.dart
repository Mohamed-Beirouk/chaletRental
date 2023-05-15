import 'package:flutter/material.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/provider/UsersProvider.dart';
import 'package:nudilk/screens/AdminScreen/allChalets_screen.dart';
import 'package:nudilk/screens/AdminScreen/chaletsReqest_screen.dart';
import 'package:nudilk/screens/AdminScreen/users_screen.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';
import '../../components/secondButton.dart';
import 'AllRequestChalets_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  static const String id = "AdminPanel_screen";

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();

    Provider.of<UsersProvider>(context, listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Chalets> chaletsList = Provider.of<ChaletsProvider>(context).chalet;
    List<Users> usersList = Provider.of<UsersProvider>(context).users;

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                AuthHelper.authHelper.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                      return LoginScreen();
                    }));
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: const Text(
          'Name of the Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                height: height * 0.176,
                width: width * 0.9,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/loginScreen.png',
                      ),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.darken),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                      ),
                      // SecondButton(
                      //   height: 30,
                      //   isMainColor: true,
                      //   borderRadius: 8,
                      //   onpressed: () {
                      //     Navigator.pushNamed(context, AdminChaletsScreen.id);
                      //   },
                      //   fontSized: 13,
                      //   width: width / 2.3 - 50,
                      //   buttonText: 'view All chalets',
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("${usersList.length}",
                            style: TextStyle(
                                color: Color(0xFF8492A7),
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, UsersScreen.id);
                          },
                          child: Text("Users",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("${chaletsList.length}",
                            style: TextStyle(
                                color: Color(0xFF8492A7),
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),

                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AdminChaletsScreen.id);
                          },
                          child: Text("Chalets",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        )

                      ],

                    ),
                    // Column(
                    //   children: [
                    //     Text("5",
                    //         style: TextStyle(
                    //             color: Color(0xFF8492A7),
                    //             fontSize: 30,
                    //             fontWeight: FontWeight.bold)),
                    //     SizedBox(
                    //       height: 8,
                    //     ),
                    //     Text("Guest",
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold)),
                    //   ],
                    //     ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Requests",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AllRequestAdminChaletsScreen.id);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: kMainAppColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Consumer<ChaletsProvider>(
              //     builder: (context, chaletsProvider, _) =>
              //     chaletsProvider.bookedForMyChalets.isEmpty
              chaletsList
                  .where((element) => element.chaletsStatus == false)
                  .length ==
                  0
                  ? Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset('assets/images/emptyBooking.png'),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: height,
                  child: ListView.builder(
                    itemCount: chaletsList
                        .where(
                            (element) => element.chaletsStatus == false)
                        .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                                return ChaletsRequestScreen(
                                  imageList:
                                  chaletsList[index].arrayImagesURL,
                                  chaletEmail: chaletsList[index].email,
                                  chaletDescription:
                                  chaletsList[index].description,
                                  imageURL: chaletsList[index].imageURL,
                                  chaletLocation: chaletsList[index].location,
                                  chaletName: chaletsList[index].name,
                                  onpressedB1: () {
                                    FireStoreHelper.fireStoreHelper
                                        .updateChaletsStatus(
                                        chaletsList[index], true);
                                  },
                                  onpressedB2: () {
                                    FireStoreHelper.fireStoreHelper
                                        .updateChaletsStatus(
                                        chaletsList[index], false);
                                  },
                                );
                              }));
                        },
                        child: HomeChaletPackagesWidget(
                          price: chaletsList[index].price,
                          imageURL: chaletsList[index].imageURL,
                          chaletLocation: chaletsList[index].location,
                          chaletName: chaletsList[index].name,
                          onpressedB1: () {
                            FireStoreHelper.fireStoreHelper
                                .updateChaletsStatus(
                                chaletsList[index], true);
                          },
                          onpressedB2: () {
                            FireStoreHelper.fireStoreHelper
                                .updateChaletsStatus(
                                chaletsList[index], false);
                          },
                          isForBooking: false,
                          onpressed: () {},
                          width: width,
                          height: height,
                          fontSize: 10,
                          buttonString: "Delete Booking",
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Consumer<ChaletsProvider,>(
// builder: (context, chalets, chaletsList, __) {
// return
