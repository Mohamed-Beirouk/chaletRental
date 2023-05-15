import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/secondButton.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:nudilk/model/Chalets.dart';

import 'package:nudilk/screens/UserScreen/bookingNow_screen.dart';
import 'package:nudilk/screens/UserScreen/commentsAndFeedbackScreen.dart';
import 'package:nudilk/screens/UserScreen/home_screen.dart';

import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

import '../../provider/ChaletsProvider.dart';
import '../../services/auth_helper.dart';
import 'addReviews.dart';

class ChaletScreen extends StatefulWidget {
  // final String? imageURL;
  // final String? chaletName;
  // final String? chaletEmail;
  // final String? chaletLocation;
  // final String? chaletDescription;
  final Chalets? chalet;
  final Booking? bookedIndex;
  bool? isGuest = false;
  bool? isBooked = false;

  ChaletScreen(
      {this.chalet,
      this.isGuest = false,
      this.isBooked = false,
      this.bookedIndex});
  @override
  State<ChaletScreen> createState() => _ChaletScreenState();
}

class _ChaletScreenState extends State<ChaletScreen> {
  bool _favVisible = false;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ChaletsProvider>(context, listen: false)
        .callFavorited(widget.chalet);
    Provider.of<ChaletsProvider>(context, listen: false)
        .getChaletsComments(widget.chalet!.id.toString());
    Provider.of<ChaletsProvider>(context, listen: false)
        .didUserHaveBookedChalets(widget.chalet!.id.toString());
    Provider.of<ChaletsProvider>(context, listen: false)
        .getBookingInfo(widget.chalet!.id!.toString());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: Provider.of<ChaletsProvider>(context, listen: false)
          .callFavorited(widget.chalet),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: widget.isBooked == true
                      ? MainButton(
                          width: 0,
                          onpressed: () {
                            if (widget.isGuest!) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Please first login to update the profile ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
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
                                            Navigator.of(context).pop(false);
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
                                            FireStoreHelper.fireStoreHelper
                                                .cancelledBookingToChaletsAndUser(
                                                    widget.bookedIndex!,
                                                    context);
                                          },
                                          width: 80,
                                          buttonText: "Yes",
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          fontSized: 20,
                          buttonText: "Cancel the booking  ",
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: widget.chalet == null
                                    ? const SizedBox.shrink()
                                    : Consumer<ChaletsProvider>(
                                        builder:
                                            (context, chaletsProvider, child) {
                                          final user = AuthHelper
                                              .authHelper.auth.currentUser;
                                          return IconButton(
                                            onPressed: () async {
                                              final user = AuthHelper
                                                  .authHelper.auth.currentUser;
                                              if (user == null) {
                                                Fluttertoast.showToast(
                                                    msg: 'Please first login  ',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                bool fav = await FireStoreHelper
                                                    .fireStoreHelper
                                                    .checkIfFavouriteChaletsExists(
                                                        widget.chalet!);
                                                _favVisible = fav;
                                                setState(() {
                                                  _favVisible = !_favVisible;
                                                });
                                              }
                                              ;
                                            },
                                            icon: Icon(
                                              Provider.of<ChaletsProvider>(
                                                          context,
                                                          listen: false)
                                                      .isFavoritedd
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            MainButton(
                              width: 0,
                              onpressed: () {
                                final user =
                                    AuthHelper.authHelper.auth.currentUser;
                                if (user == null) {
                                  // User is authenticated, do something
                                  Fluttertoast.showToast(
                                      msg: 'Please first login  ',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return BookingNowScreen(
                                      chalets: widget.chalet,
                                    );
                                  }));
                                }
                              },
                              fontSized: 24,
                              buttonText: "Book now",
                            )
                          ],
                        ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (Provider.of<ChaletsProvider>(context, listen: false)
                          .didUserHaveBookedChalet) {
                        print(
                            Provider.of<ChaletsProvider>(context, listen: false)
                                .didUserHaveBookedChalet);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return AddReviewsScreen(chaletID: widget.chalet);
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'You have to book the chalet first, before you give your feedback',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  widget.chalet!.arrayImagesURL == null
                      ? Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/defaultChaletImage.png"))),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 50,
                                left: 20,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 350,
                          child: PageView.builder(
                              itemCount: widget.chalet!.arrayImagesURL!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 350,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${widget.chalet!.arrayImagesURL![index]}'),
                                          fit: BoxFit.cover)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 50,
                                        left: 20,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Colors.black,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 35.0, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                        ),
                        Text(
                          widget.chalet == null
                              ? "Name of the Chalets"
                              : '${widget.chalet!.name}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.chalet == null
                                  ? "Location of the Chalets"
                                  : '${widget.chalet!.location}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                MapsLauncher.launchCoordinates(
                                    widget.chalet!.lon!, widget.chalet!.lat!);
                              },
                              child: const Text(
                                "show in map",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Wrap(
                            children: [
                              Text(
                                widget.chalet!.description == null
                                    ? "This upscale, contemporary hotel is 2 km fromHazrat,dsd Shahjalal Airport and 11 km from Jatiyo Bhaban, the Bangla deshParliament complex"
                                    : widget.chalet!.description!,
                                style: TextStyle(
                                    color: Color(0xFF8492A7), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text("Price",
                                    style: TextStyle(
                                        color: Color(0xFF8492A7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 8,
                                ),
                                widget.chalet!.price == null
                                    ? Text("\$180",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                    : widget.chalet!.offer != null &&
                                            widget.chalet!.offer! > 0
                                        ? Row(
                                            children: [
                                              Text("\$${widget.chalet!.price}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "\$" +
                                                      (widget.chalet!.price! -
                                                              widget.chalet!
                                                                  .offer!)
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )
                                        : Text("\$${widget.chalet!.price}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Phone number",
                                    style: TextStyle(
                                        color: Color(0xFF8492A7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${widget.chalet!.phone}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Consumer<ChaletsProvider>(
                          builder: (context, chaletsProvider, _) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: height,
                              child: ListView.builder(
                                itemCount:
                                    chaletsProvider.chaletscomments.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xfff1f3f6),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: MaterialButton(
                                              onPressed: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(id:id),));
                                              },
                                              child: Container(
                                                // height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    'assets/images/reviews.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(height: 15,),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Provider.of<ChaletsProvider>(context)
                                                              .chaletscomments[
                                                                  index]
                                                              .name ==
                                                          null
                                                      ? Text(
                                                          "Name : " + "Client ",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15))
                                                      : Text("Name : " + Provider.of<ChaletsProvider>(context).chaletscomments[index].name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                ),
                                                SizedBox(height: 10),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                      "Comment : " +
                                                          Provider.of<ChaletsProvider>(
                                                                  context)
                                                              .chaletscomments[
                                                                  index]
                                                              .comment!,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(height: 10),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    "rating : " +
                                                        Provider.of<ChaletsProvider>(
                                                                context)
                                                            .chaletscomments[
                                                                index]
                                                            .rating
                                                            .toString() +
                                                        " ★",
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      print("tapped on container");

                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetail(t: user, couleur: couleur, pic: pic, date: date, message: message, put: put, detailTransaction: detailTransaction,)));
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Getting chalets details ...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
