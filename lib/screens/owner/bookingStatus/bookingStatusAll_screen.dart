import 'package:flutter/material.dart';
import 'package:nudilk/components/BookingStatusWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:provider/provider.dart';

import '../../../provider/ChaletsProvider.dart';
import '../../../provider/UsersProvider.dart';
import '../../../services/auth_helper.dart';

class BookingStatusAll extends StatefulWidget {
  @override
  State<BookingStatusAll> createState() => _BookingStatusAllState();
}

class _BookingStatusAllState extends State<BookingStatusAll> {
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
        builder: (context, chaletsProvider, _) =>
        chaletsProvider.bookedForMyChalets.isEmpty
            ? Container(
          width: double.infinity,
          child: Center(
            child: Image.asset('assets/images/emptyBooking.png'),
          ),
        )
            : ListView.builder(
          itemCount: chaletsProvider.bookedForMyChalets.length,
          itemBuilder: (context, index) {
            return BookingStatusWidget(
              booking: chaletsProvider.bookedForMyChalets[index],
              height: height,
              width: width,
            );
          },
        ),
      ),
    );
  }
}

//
