import 'package:flutter/material.dart';
import 'package:nudilk/components/BookingStatusWidget.dart';

import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/owner/bookingStatus/bookingStatusAll_screen.dart';
import 'package:nudilk/screens/owner/bookingStatus/bookingStatusBlocked_screen.dart';
import 'package:nudilk/screens/owner/bookingStatus/bookingStatusBooked_screen.dart';
import 'package:nudilk/screens/owner/bookingStatus/bookingStautsNotContact_screen.dart';

import 'bookingStatus/bookingStatusCanceledByUser.dart';

class BookingStatusScreen extends StatefulWidget {
  static const String id = "BookingStatus_screen";

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  bool isEmpty = false;

  TabBar get _tabBar => const TabBar(
        isScrollable: true,
        labelColor: kMainAppColor,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            text: 'ALL',
          ),
          Tab(
            text: 'Booked',
          ),
          Tab(
            text: 'New ',
          ),
          Tab(
            text: 'canceled ',
          ),

        ],
      );

  final Screens = [
    BookingStatusAll(),
    BookingStatusBooked(),
    BookingStatusNotContact(),
    BookingStatusBlocked(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            leading: SizedBox.shrink(),
            centerTitle: true,
            title: const Text('Booking Status'),
            backgroundColor: kMainAppColor,
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.white,
                child: _tabBar,
              ),
            ),
          ),
          body: isEmpty
              ? SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Image.asset('assets/images/emptyBooking.png'),
                  ),
                )
              : TabBarView(children: [
                  BookingStatusAll(),
                  BookingStatusBooked(),
                  BookingStatusNotContact(),
                  BookingStatusCanceldByUserBooked(),
                  BookingStatusBlocked(),
                ])),
    );
  }
}
