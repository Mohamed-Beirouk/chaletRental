import 'package:flutter/material.dart';
import 'package:nudilk/components/BookingStatusWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:provider/provider.dart';

import '../../../provider/ChaletsProvider.dart';
import '../../../provider/UsersProvider.dart';
import '../../../services/auth_helper.dart';

class BookingStatusBooked extends StatefulWidget {
  static int? total;
  @override
  State<BookingStatusBooked> createState() => _BookingStatusBookedState();
}

class _BookingStatusBookedState extends State<BookingStatusBooked> {
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
                    .where((element) => element.bookingStatus == "Booked")
                    .length ==
                0
            ? SizedBox(
                width: double.infinity,
                child: Center(
                  child: Image.asset('assets/images/emptyBooking.png'),
                ),
              )
            : ListView.builder(
                itemCount: chaletsProvider.bookedForMyChalets
                    .where((element) => element.bookingStatus == "Booked")
                    .length,
                itemBuilder: (context, index) {
                  List<Booking> bookedList = chaletsProvider.bookedForMyChalets
                      .where((element) => element.bookingStatus == "Booked")
                      .toList();
                  BookingStatusBooked.total = 0;
                  for (var element in bookedList) {
                    int a = element.servicePrice!;
                    int b = element.dateCount!;
                    BookingStatusBooked.total =
                        BookingStatusBooked.total! + (a * b);
                  }
                  return BookingStatusWidget(
                    booking: chaletsProvider.bookedForMyChalets
                        .where((element) => element.bookingStatus == "Booked")
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
