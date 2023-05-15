import 'package:flutter/material.dart';
import 'package:nudilk/components/messegeWidget.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';

import 'package:nudilk/screens/UserScreen/profile_screen.dart';
import 'package:nudilk/screens/owner/addChalet_screen.dart';
import 'package:nudilk/screens/owner/bookingStatus_screen.dart';
import 'package:nudilk/screens/owner/chaletsListScreen.dart';
import 'package:nudilk/screens/owner/ownerPanel_screen.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:provider/provider.dart';

class OwnerHomeScreen extends StatefulWidget {
  static const String id = "OwnerHome_screen";

  @override
  State<OwnerHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<OwnerHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
  }

  int currentIndex = 0;
  bool isEmptyChalets = true;
  @override
  Widget build(BuildContext context) {
    List<Chalets> chaletsList = Provider.of<ChaletsProvider>(context).chalet;
    final Screens = [
      chaletsList
                  .where((element) =>
                      element.OwnerId ==
                          AuthHelper.authHelper.auth.currentUser!.uid &&
                      element.chaletsStatus == true)
                  .length ==
              0
          ? MessageWidget(
              buttonText: 'add Chalets',
              isSuccess: false,
              nameOfAppbar: 'please add a chalets',
              message:
                  'you don\'t have any chalets pleas add one  if you add one please wait till the admin approve it ',
              onpressed: () {
                Navigator.pushNamed(context, AddChaletScreen.id);
              },
            )
          : OwnerPanelScreen(),
      BookingStatusScreen(),
      ProfileScreen(),
      ChaletsListScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xff1F4772),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'Book now',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'profile'),
          BottomNavigationBarItem(
              icon: Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              label: 'Chalets'),
        ],
      ),
      body: Screens[currentIndex],
    );
  }
}
