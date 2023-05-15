import 'package:flutter/material.dart';

import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:nudilk/screens/AdminScreen/allChalets_screen.dart';
import 'package:provider/provider.dart';

import '../../components/OwnerBookingWidget.dart';
import '../../model/Chalets.dart';
import '../../provider/ChaletsProvider.dart';
import '../../provider/UsersProvider.dart';
import '../../services/auth_helper.dart';
import 'bookingStatus/bookingStatusBooked_screen.dart';

class OwnerPanelScreen extends StatefulWidget {
  static const String id = "OwnerPanel_screen";

  @override
  State<OwnerPanelScreen> createState() => _OwnerPanelScreenState();
}

class _OwnerPanelScreenState extends State<OwnerPanelScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UsersProvider>(context, listen: false)
        .getUserByID(AuthHelper.authHelper.auth.currentUser!.uid);

    Provider.of<ChaletsProvider>(context, listen: false)
        .getBookedForMyChalets();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Booking> bookingList =
        Provider.of<ChaletsProvider>(context).bookedForMyChalets;
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)), // Delay the future by 2 seconds
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: SizedBox.shrink(),
              elevation: 0,
              backgroundColor: kMainAppColor,
              centerTitle: true,
              title: const Text(
                'Welcome to Chalets Owner Panel',
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
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: kMainAppColor,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Container(
                          child: ListTile(
                            title: Text(
                              BookingStatusBooked.total == null
                                  ? "loading"
                                  : '${BookingStatusBooked.total}',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'Income for this year',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            // trailing: Container(
                            //   height: 57,
                            //   width: 75,
                            //   padding: const EdgeInsets.only(left: 10),
                            //   decoration: BoxDecoration(
                            //     color: const Color(0xFF204A76),
                            //     borderRadius: BorderRadius.circular(7),
                            //   ),
                            //   // child: const Center(
                            //   //   child: Text(
                            //   //     'View all Chalets',
                            //   //     style: TextStyle(
                            //   //         fontSize: 15,
                            //   //         color: Colors.white,
                            //   //         fontWeight: FontWeight.normal),
                            //   //   ),
                            //   // ),
                            // ),
                          ),
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
                              Text(
                                  bookingList.length == 0
                                      ? "0"
                                      : '${bookingList.length}',
                                  style: TextStyle(
                                      color: Color(0xFF8492A7),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(context, UsersScreen.id);
                                },
                                child: const Text("Bookings",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  bookingList
                                      .where((element) =>
                                  element.bookingStatus ==
                                      "Not Contact")
                                      .length ==
                                      0
                                      ? "0"
                                      : "${bookingList.where((element) => element.bookingStatus == "Not Contact").length}",
                                  style: TextStyle(
                                      color: Color(0xFF8492A7),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 8,
                              ),
                              Text("New",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  bookingList
                                      .where((element) =>
                                  element.bookingStatus == "Booked")
                                      .length ==
                                      0
                                      ? "0"
                                      : "${bookingList.where((element) => element.bookingStatus == "Booked").length}",
                                  style: TextStyle(
                                      color: Color(0xFF8492A7),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Booked",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "New Bookings",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, AdminChaletsScreen.id);
                          //   },
                          //   child: const Text(
                          //     "View All",
                          //     style: TextStyle(
                          //         color: kMainAppColor,
                          //         fontSize: 12,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Consumer<ChaletsProvider>(
                        builder: (context, chaletsProvider, _) => chaletsProvider
                            .bookedForMyChalets
                            .where((element) =>
                        element.bookingStatus == "Not Contact")
                            .length ==
                            0
                            ? Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: Image.asset(
                                      'assets/images/emptyBooking.png'),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "No new bookings ",
                                style:
                                TextStyle(color: Colors.grey, fontSize: 20),
                              )
                            ],
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: height,
                            child: ListView.builder(
                              itemCount: chaletsProvider.bookedForMyChalets
                                  .where((element) =>
                              element.bookingStatus == "Not Contact")
                                  .length,
                              itemBuilder: (context, index) {
                                return OwnerBookingWidget(
                                  width: width,
                                  booking: chaletsProvider.bookedForMyChalets
                                      .where((element) =>
                                  element.bookingStatus ==
                                      "Not Contact")
                                      .toList()[index],
                                );
                              },
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: SizedBox.shrink(),
              elevation: 0,
              backgroundColor: kMainAppColor,
              centerTitle: true,
              title: const Text(
                'Welcome to Chalets Owner Panel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );

  }
}
