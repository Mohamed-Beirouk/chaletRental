import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/components/popularChaletWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/screens/UserScreen/chalet_Screen.dart';
import 'package:nudilk/screens/UserScreen/search.dart';
import 'package:nudilk/services/auth_helper.dart';

import 'package:provider/provider.dart';
import '../../provider/ChaletsProvider.dart';
import '../../provider/UsersProvider.dart';

class LandingScreen extends StatefulWidget {
  static const String id = "Landing_screen";
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;

  var currentLocation;

  var clients = [];

  var currentClient;
  var currentBearing;

  GoogleMapController? mapController;


  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });
    Provider.of<UsersProvider>(context, listen: false)
        .getUserByID(AuthHelper.authHelper.auth.currentUser!.uid);
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
    Provider.of<ChaletsProvider>(context, listen: false).getCurrentPosition();
  }

  Widget clientCard(client) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: InkWell(
            onTap: () {
              setState(() {
                currentClient = client;
                currentBearing = 90.0;
              });
              zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 100.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Center(child: Text(client['clientName']))),
            )));
  }

  zoomInMarker(client) {
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            client['location'].latitude, client['location'].longitude),
        zoom: 17.0,
        bearing: 90.0,
        tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  resetCamera() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0))).then((
        val) {
      setState(() {
        resetToggle = false;
      });
    });
  }

  addBearing() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['location'].latitude,
                currentClient['location'].longitude
            ),
            bearing: currentBearing == 360.0 ? currentBearing : currentBearing +
                90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if (currentBearing == 360.0) {}
        else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

  removeBearing() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['location'].latitude,
                currentClient['location'].longitude
            ),
            bearing: currentBearing == 0.0 ? currentBearing : currentBearing -
                90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if (currentBearing == 0.0) {}
        else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }


  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    List<Chalets> chaletsList = Provider
        .of<ChaletsProvider>(context)
        .chalet;
    Provider.of<ChaletsProvider>(context, listen: false).context=context;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: width,
                child: Consumer<UsersProvider>(
                    builder: (context, userProvider, _) =>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProvider.userid == null
                                  ? "Hello User"
                                  : "Hello ${userProvider.userid!.name}",
                              style: const TextStyle(
                                  color: Color(0xffAAAEB4), fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Find your chalet ",
                                  style: TextStyle(fontSize: 22),
                                ),
                                userProvider.userid == null
                                    ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/User.png',
                                          ),
                                          fit: BoxFit.cover),
                                      color: Colors.cyan,
                                      borderRadius:
                                      BorderRadius.circular(15)),
                                )
                                    : Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            "${userProvider.userid!.imageURL}",
                                          ),
                                          fit: BoxFit.cover),
                                      color: Colors.cyan,
                                      borderRadius:
                                      BorderRadius.circular(15)),
                                ),
                              ],
                            ),
                          ],
                        )),
              ),
              Material(
                elevation: 5.0,
                shadowColor: Colors.black,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Search.id);
                  },
                  child: MyTextFormField(
                    controller: _textEditingController,
                    widgetIcon2: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return Search(
                                text: _textEditingController.text,
                              );
                            },
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_forward_outlined,
                        color: Color(0xFF000000),
                      ),
                    ),
                    widgetIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF000000),
                    ),
                    secure: false,
                    hintText: 'Search chalets, Area etc..',
                    contentColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              // const Text(
              //   "Popular chalets",
              //   style: TextStyle(fontSize: 18),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 15.0),
              //   child: SizedBox(
              //     height: 200,
              //     child: ListView.builder(
              //         scrollDirection: Axis.horizontal,
              //         itemCount: chaletsList
              //             .where((element) => element.chaletsStatus == true)
              //             .length,
              //         itemBuilder: (context, index) {
              //           return InkWell(
              //             onTap: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (_) {
              //                     return ChaletScreen(
              //                       chalet: chaletsList
              //                           .where((element) =>
              //                       element.chaletsStatus == true)
              //                           .toList()[index],
              //                     );
              //                   },
              //                 ),
              //               );
              //             },
              //             child: PopularChaletWidget(
              //               height: height,
              //               imageURL: chaletsList
              //                   .where(
              //                       (element) => element.chaletsStatus == true)
              //                   .toList()[index]
              //                   .imageURL,
              //               chaletLocation: chaletsList
              //                   .where(
              //                       (element) => element.chaletsStatus == true)
              //                   .toList()[index]
              //                   .location,
              //               chaletName: chaletsList
              //                   .where(
              //                       (element) => element.chaletsStatus == true)
              //                   .toList()[index]
              //                   .name,
              //               price: chaletsList
              //                   .where(
              //                       (element) => element.chaletsStatus == true)
              //                   .toList()[index]
              //                   .price,
              //             ),
              //           );
              //         }),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'chalet packages',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Text(
                  //   'View All',
                  //   style: TextStyle(fontSize: 14, color: kMainAppColor),
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: chaletsList
                      .where((element) => element.chaletsStatus == true)
                      .length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return ChaletScreen(
                                chalet: chaletsList
                                    .where((element) =>
                                element.chaletsStatus == true)
                                    .toList()[index],
                              );
                            },
                          ),
                        );
                      },
                      child: HomeChaletPackagesWidget(
                        imageURL: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .imageURL,
                        chaletLocation: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .location,
                        chaletName: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .name,
                        price: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .price,
                        offer: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .offer,
                        description: chaletsList
                            .where((element) => element.chaletsStatus == true)
                            .toList()[index]
                            .description,
                        isForAdmin: false,
                        onpressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return ChaletScreen(
                                  chalet: chaletsList
                                      .where((element) =>
                                  element.chaletsStatus == true)
                                      .toList()[index],
                                );
                              },
                            ),
                          );
                        },
                        width: width,
                        height: height,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}