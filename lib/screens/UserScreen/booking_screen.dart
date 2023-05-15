import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/components/NetworkError.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/components/secondButton.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

import 'chalet_Screen.dart';

class BookingScreen extends StatefulWidget {
  static const String id = "Booking_screen";

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    Provider.of<ChaletsProvider>(context, listen: false).getBookedChalets();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          centerTitle: true,
          title: const Text('Booking Now'),
          backgroundColor: kMainAppColor,
        ),
        body: user != null
            ? Consumer<ChaletsProvider>(
                builder: (context, chaletProvider, _) => chaletProvider
                        .bookedChalets.isEmpty
                    ? Container(
                        width: double.infinity,
                        child: Center(
                          child: Image.asset('assets/images/emptyBooking.png'),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          itemCount: chaletProvider.bookedChalets.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                dynamic Chalets = await chaletProvider
                                    .getChaletByID(chaletProvider
                                        .bookedChalets[index].placeId);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return ChaletScreen(
                                        chalet: Chalets,
                                        bookedIndex:
                                            chaletProvider.bookedChalets[index],
                                        isBooked: true,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: HomeChaletPackagesWidget(
                                bookingStatus: chaletProvider
                                    .bookedChalets[index].bookingStatus,
                                imageURL: chaletProvider
                                    .bookedChalets[index].imageURL,
                                chaletLocation: chaletProvider
                                    .bookedChalets[index].placeLocation,
                                chaletName: chaletProvider
                                    .bookedChalets[index].placeName,
                                date: chaletProvider
                                    .bookedChalets[index].dateRange,
                                daterange: chaletProvider
                                    .bookedChalets[index].dateRange,
                                daycount: chaletProvider
                                    .bookedChalets[index].dateCount
                                    .toString(),
                                  price: chaletProvider
                                    .bookedChalets[index].price,
                                servicePrice: chaletProvider
                                    .bookedChalets[index].servicePrice.toString(),
                                description:
                                chaletProvider.bookedChalets[index].description,
                                isForAdmin: false,
                                isForBooking: true,
                                onpressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: new Text("Confirm deleting"),
                                          content: new Text(
                                              'Are you sur you want to delete your booking ?'),
                                          actions: <Widget>[
                                            SecondButton(
                                              height: 40,
                                              isMainColor: false,
                                              borderRadius: 11,
                                              onpressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              width: 80,
                                              buttonText: "No",
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SecondButton(
                                              height: 40,
                                              isMainColor: false,
                                              borderRadius: 11,
                                              onpressed: () async {
                                                await FireStoreHelper
                                                    .fireStoreHelper
                                                    .deleteBookingToChaletsAndUser(
                                                        chaletProvider
                                                                .bookedChalets[
                                                            index]);
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              width: 80,
                                              buttonText: "Yes",
                                            ),
                                          ],
                                        );
                                      });
                                },
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
            : NetworkError());
  }
}
