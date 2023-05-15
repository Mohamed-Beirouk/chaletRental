import 'package:flutter/material.dart';
import 'package:nudilk/components/BookingStatusWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:provider/provider.dart';

import '../../../provider/ChaletsProvider.dart';
import '../../../provider/UsersProvider.dart';
import '../../../services/auth_helper.dart';

class BookingStatusNotContact extends StatefulWidget {
  @override
  State<BookingStatusNotContact> createState() =>
      _BookingStatusNotContactState();
}

class _BookingStatusNotContactState extends State<BookingStatusNotContact> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<UsersProvider>(context, listen: false)
        .getUserByID(AuthHelper.authHelper.auth.currentUser!.uid);

    Provider.of<ChaletsProvider>(context, listen: false)
        .getBookedForMyChalets();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<ChaletsProvider>(
        builder: (context, chaletsProvider, _) => chaletsProvider
                    .bookedForMyChalets
                    .where((element) => element.bookingStatus == "Not Contact")
                    .length ==
                0
            ? Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset('assets/images/emptyBooking.png'),
                ),
              )
            : ListView.builder(
                itemCount: chaletsProvider.bookedForMyChalets
                    .where((element) => element.bookingStatus == "Not Contact")
                    .length,
                itemBuilder: (context, index) {
                  return BookingStatusWidget(
                    booking: chaletsProvider.bookedForMyChalets
                        .where(
                            (element) => element.bookingStatus == "Not Contact")
                        .toList()[index],
                    height: height,
                    width: width,
                  );
                },
              ),
      ),
    );
  }
}
