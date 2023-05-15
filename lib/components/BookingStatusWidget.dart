import 'package:flutter/material.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/services/fireStore_helper.dart';

import '../model/Booking.dart';

class BookingStatusWidget extends StatelessWidget {
  BookingStatusWidget(
      {Key? key,
      required this.height,
      required this.width,
      this.booking,
      this.text})
      : super(key: key);

  final double height;
  String? text;
  final double width;
  Booking? booking;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Container(
            height: 170,
            width: width - 20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                          height: 90,
                          width: 120,
                          child: booking == null
                              ? const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/User.png',
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    booking!.imageURL!,
                                  ),
                                ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            booking == null
                                ? 'Users Named'
                                : booking!.userName!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            booking == null
                                ? '23 January 2022'
                                : booking!.dateRange!,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          const Text(
                            '0 AM - 11 PM',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            booking == null
                                ? 'Email or Phone number '
                                : booking!.userEmail!,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xff2C66A3)),
                          ),
                          Text(
                            booking == null
                                ? ' Phone number '
                                : booking!.userPhone!,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xff2C66A3)),
                          ),
                          Text(
                            booking == null
                                ? 'Chalets Names '
                                : booking!.placeName!,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xff2C66A3)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(width: 1, color: Colors.grey))),
                        child: Center(
                          child: Text(
                            booking == null
                                ? "Not contact"
                                : booking!.bookingStatus!,
                            style: TextStyle(
                              color: booking!.bookingStatus! == "Booked"
                                  ? Colors.green
                                  : booking!.bookingStatus! == 'Not Contact'
                                      ? kMainAppColor
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Center(
                                      child: Text('Status change')),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Container(
                                        width: 345,
                                        height: 290,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18.0),
                                              child: ListTile(
                                                tileColor: null,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                title: const Text(
                                                    "Canceled By Owner"),
                                                onTap: () {
                                                  setState(() {
                                                    FireStoreHelper
                                                        .fireStoreHelper
                                                        .editBookingStatus(
                                                            booking!,
                                                            "Canceled By Owner");
                                                    FireStoreHelper
                                                        .fireStoreHelper
                                                        .editBookingStatusForUser(
                                                            booking!,
                                                            "Canceled By Owner");
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              });
                        },
                        child: const Text(
                          'Status change',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
