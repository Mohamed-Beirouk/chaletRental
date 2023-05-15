import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/screens/UserScreen/bookingConfirmation_screen.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../model/Users.dart';
import '../../provider/ChaletsProvider.dart';

class BookingNowScreen extends StatefulWidget {
  static const String id = "BookingNow_screen";
  Chalets? chalets;
  BookingNowScreen({this.chalets});

  @override
  State<BookingNowScreen> createState() => _BookingNowScreenState();
}

class _BookingNowScreenState extends State<BookingNowScreen> {
  String _selectedDate = '';
  String _dateCount = '';
  String? _range;
  String _rangeCount = '';
  String? formattedDateRange;
  int? daysDiff;
  var price;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat("yyyy-MM-dd").format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat("yyyy-MM-dd").format(args.value.endDate ?? args.value.startDate)}';
        formattedDateRange = formatDateRange(_range!);
        daysDiff = calculateDaysDiff(formattedDateRange!) + 1;
        price = (daysDiff! * widget.chalets!.price!);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
        price = (daysDiff! * widget.chalets!.price!);
      } else {
        _rangeCount = args.value.length.toString();
        price = (daysDiff! * widget.chalets!.price!);
      }
    });
  }

  String formatDateRange(String dateRange) {
    List<String> dates = dateRange.split(" - ");
    DateTime startDate = DateTime.parse(dateToISO(dates[0]));
    DateTime endDate = DateTime.parse(dateToISO(dates[1]));
    String formattedStartDate = formatDate(startDate);
    String formattedEndDate = formatDate(endDate);
    return "$formattedStartDate - $formattedEndDate";
  }

  String formatDate(DateTime date) {
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String dateToISO(String dateStr) {
    List<String> dateParts = dateStr.split("-");
    return "${dateParts[0]}-${dateParts[1]}-${dateParts[2]}";
  }

  int calculateDaysDiff(String dateRange) {
    List<String> dates = dateRange.split(" - ");
    DateTime startDate = DateTime.parse(dateToISO(dates[0]));
    DateTime endDate = DateTime.parse(dateToISO(dates[1]));
    int daysDiff = endDate.difference(startDate).inDays;
    return daysDiff;
  }

  // List of items in our dropdown menu
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  @override
  void initState() {
    Provider.of<ChaletsProvider>(context, listen: false)
        .getBookingInfo(widget.chalets!.id!.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(Provider.of<ChaletsProvider>(context, listen: false)
        .unavailableDates
        .length);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: const Text('BookingNow'),
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  height: height,
                  width: width,
                  color: Colors.white,
                )),
            Positioned(
                child: Container(
                  height: 87,
                  width: width,
                  color: kMainAppColor,
                )),
            Positioned(
              left: 24,
              top: MediaQuery.of(context).size.width / 12,
              right: 24,
              child: Container(
                height: 250,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  enablePastDates: false,
                  selectableDayPredicate:
                  Provider.of<ChaletsProvider>(context, listen: false)
                      .setDayPredicate,
                  // initialSelectedRange: PickerDateRange(
                  //     DateTime.now().subtract(const Duration(days: 4)),
                  //     DateTime.now().add(const Duration(days: 3)
                  //     )
                  // ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: MediaQuery.of(context).size.width / 3,
              right: 24,
              child: Container(
                height: 170,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'From: $_range',
                          style: TextStyle(color: Color(0xffA8B2C8)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'days: $daysDiff',
                          style: TextStyle(color: Color(0xffA8B2C8)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'price: $price',
                          style: TextStyle(color: Color(0xffA8B2C8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FirebaseAuth.instance.currentUser!.uid != null
                ? Positioned(
                bottom: height / 28,
                left: width / 4,
                child: MainButton(
                  width: width / 2,
                  onpressed: () async {
                    if (_range == null) {
                      Fluttertoast.showToast(
                          msg: 'select a date',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      try {
                        String id = await AuthHelper
                            .authHelper.auth.currentUser!.uid;
                        Users user = await FireStoreHelper.fireStoreHelper
                            .getUserByID(id);
                        Booking booking = Booking(
                            dateCount: daysDiff,
                            imageURL: widget.chalets!.imageURL,
                            placeName: widget.chalets!.name,
                            // childrenNumber: childrenDropDownValue,
                            // adultsNumber: adultsDropDownValue,
                            userId: id,
                            userName: user.name,
                            userEmail: user.email,
                            userPhone: user.phone,
                            bookingStatus: "Booked",
                            placeId: widget.chalets!.id,
                            placeLocation: widget.chalets!.location,
                            description: widget.chalets!.description,
                            dateRange: _range,
                            price: widget.chalets!.price,
                            servicePrice: price );
                        FireStoreHelper.fireStoreHelper
                            .addBookingToChaletsAndUser(
                            widget.chalets!, booking);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return BookingConfirmationScreen(
                                chaletsName: widget.chalets!.name,
                              );
                            },
                          ),
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'error booking the chalets',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }
                  },
                  buttonText: 'Book it',
                ))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
