import 'package:flutter/material.dart';
import 'package:nudilk/model/Booking.dart';

class OwnerBookingWidget extends StatelessWidget {
  OwnerBookingWidget({Key? key, required this.width, this.booking})
      : super(key: key);

  final double width;
  Booking? booking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: Container(
        height: 120,
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
                  booking == null ? 'Users Named' : booking!.userName!,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  booking == null ? '23 January 2022' : booking!.dateRange!,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
                const Text(
                  '0:01 AM - 11:59 AM',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  booking == null
                      ? 'Email or Phone number '
                      : booking!.dateRange!,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff2C66A3)),
                ),
                Text(
                  booking == null ? 'Chalets Name' : booking!.placeName!,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff2C66A3)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
