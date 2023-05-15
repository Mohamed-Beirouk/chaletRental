import 'package:flutter/material.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/secondButton.dart';
import 'package:nudilk/constants.dart';

class HomeChaletPackagesWidget extends StatelessWidget {
  HomeChaletPackagesWidget({
    Key? key,
    required this.width,
    required this.height,
    this.fontSize,
    this.chaletName,
    this.daycount,
    this.daterange,
    this.chaletLocation,
    this.bookingStatus,
    this.servicePrice,
    this.chaletsStatus,
    this.isForBooking = true,
    this.isForAdmin = true,
    this.buttonOne = 'Accept',
    this.buttonTwo = 'Reject',
    this.imageURL,
    this.date,
    this.price,
    this.offer,
    this.description,
    this.dateRange,

    // this.iconServices,
    required this.onpressed,
    this.onpressedB1,
    this.onpressedB2,
    this.buttonString = 'Book Now',
  }) : super(key: key);

  final String? dateRange;
  final double width;
  final double height;
  final String? buttonOne;
  final String? buttonTwo;
  bool? isForBooking;
  bool? isForAdmin;
  final VoidCallback onpressed;
  final VoidCallback? onpressedB1;
  final VoidCallback? onpressedB2;
  double? fontSize;
 // List<dynamic>? iconServices;
  String buttonString;
  final String? imageURL;
  final String? date;
  final int? price;
  final int? offer;
  final String? chaletName;
  final String? daterange;
  final String? daycount;
  final String? servicePrice;
  final String? chaletLocation;
  final String? bookingStatus;
  final String? description;
  final bool? chaletsStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            width: width,
            height: (isForBooking == true && date == null) ? 150 : 200,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    imageURL == null
                        ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.cyan,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/loginScreen.png')),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  bottomLeft: Radius.circular(11)),
                            ),
                            height: height,
                            width: 98,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              image: DecorationImage(
                                  image: NetworkImage(imageURL!),
                                  fit: BoxFit.cover),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  bottomLeft: Radius.circular(11)),
                            ),
                            height: height,
                            width: 70,
                          ),
                    Container(
                      color: Colors.white,
                      width: isForAdmin == true ? 210 : 185,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 11),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            chaletName == null
                                ? const Text(
                                    "Name of the chalet",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  )
                                : Text(
                                    chaletName!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xffC1C1C1),
                                  size: 15,
                                ),
                                chaletLocation == null
                                    ? const Text(
                                        "Name of the chalet",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xffC1C1C1)),
                                      )
                                    : Text(
                                        chaletLocation!,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xffC1C1C1)),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            (isForBooking == true || date == null)
                                ? const SizedBox.shrink()
                                : Text(
                                    date!,
                                    style: const TextStyle(
                                        fontSize: 13, color: Color(0xffC1C1C1)),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                price == null
                                    ? const Text(
                                        '\$180/night',
                                        style: TextStyle(
                                            fontSize: 12, color: kMainAppColor),
                                      )
                                    : offer != null && offer == 0
                                        ? Text(
                                            '\$${price.toString()}/night',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: kMainAppColor),
                                          )
                                        : Row(
                                            children: [
                                              Text("\$${price}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: kMainAppColor)),
                                              offer == null
                                                  ? SizedBox(
                                                      width: 5,
                                                    )
                                                  : Text(
                                                      "\$" +
                                                          (price! - offer!)
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                chaletsStatus == null
                                    ? const SizedBox.shrink()
                                    : chaletsStatus == true
                                        ? const Text(
                                            ' active ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green),
                                          )
                                        : const Text(
                                            ' not active ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red),
                                          ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            daterange == null
                                ? SizedBox()
                                : Text(
                              "daterange: ${ daterange}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                            const SizedBox(
                              height: 3,
                            ),
                            daycount == null
                                ? SizedBox()
                                : Text(
                              "the number of days : ${ daycount}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                            const SizedBox(
                              height: 3,
                            ),
                            servicePrice == null
                                ? SizedBox()
                                : Text(
                              "the total price : ${servicePrice}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            bookingStatus == null
                                ? const SizedBox.shrink()
                                : Text(
                                    bookingStatus!,
                                    style: const TextStyle(
                                        fontSize: 12, color: kMainAppColor),
                                  ),
                            isForAdmin == true
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SecondButton(
                                          height: 40,
                                          isMainColor: false,
                                          borderRadius: 11,
                                          onpressed: onpressedB1,
                                          width: 80,
                                          buttonText: buttonOne,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SecondButton(
                                          height: 40,
                                          isMainColor: true,
                                          borderRadius: 11,
                                          onpressed: onpressedB2,
                                          width: 80,
                                          buttonText: buttonTwo,
                                        ),

                                      ],
                                    ),
                                  )
                                :  description == null
                                ? const Text(
                              "description of the chalet",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )
                                : Text(
                              description!,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(
                              height: 5,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                isForBooking == true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 5),
                        child: RotatedBox(
                          quarterTurns: -45,
                          child: MainButton(
                            onpressed: onpressed,
                            fontSized: fontSize ?? 14,
                            borderRadius: 11,
                            width: height,
                            buttonText: '$buttonString',
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
