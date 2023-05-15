import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nudilk/screens/GuestScreen/GuestLanding_Screen.dart';
import 'package:nudilk/screens/GuestScreen/GuestProfile_screen.dart';
import 'package:nudilk/screens/UserScreen/Landing_Screen.dart';
import 'package:nudilk/screens/UserScreen/booking_screen.dart';
import 'package:nudilk/screens/UserScreen/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/ChaletsProvider.dart';
import '../../provider/UsersProvider.dart';
import '../../services/auth_helper.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "Home_screen";
  bool? isGuest;
  HomeScreen({this.isGuest = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
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

    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
    Provider.of<ChaletsProvider>(context, listen: false).context = context;
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
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0)))
        .then((val) {
      setState(() {
        resetToggle = false;
      });
    });
  }

  addBearing() {
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentClient['location'].latitude,
                currentClient['location'].longitude),
            bearing: currentBearing == 360.0
                ? currentBearing
                : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 360.0) {
        } else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

  removeBearing() {
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentClient['location'].latitude,
                currentClient['location'].longitude),
            bearing:
                currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 0.0) {
        } else {
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

  @override
  Widget build(BuildContext context) {
    final Screens = [
      widget.isGuest! ? GuestLandingScreen() : LandingScreen(),
      BookingScreen(),
      FavouriteScreen(),
      widget.isGuest! ? GuestProfileScreen() : ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xff1F4772),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'Book now',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), label: 'favourite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'profile'),
        ],
      ),
      body: Screens[currentIndex],
      floatingActionButton: Visibility(
        visible: currentIndex == 0,
        child: FloatingActionButton(
            onPressed: () {},
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                                height:
                                    MediaQuery.of(context).size.height - 80.0,
                                width: double.infinity,
                                child: mapToggle
                                    ? GoogleMap(
                                        onMapCreated: onMapCreated,
                                        initialCameraPosition:
                                            Provider.of<ChaletsProvider>(
                                                    context)
                                                .initialPosition,
                                        markers: Provider.of<ChaletsProvider>(
                                                context)
                                            .markers,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                        mapToolbarEnabled: true,
                                      )
                                    : Center(
                                        child: Text(
                                        'Loading.. Please wait..',
                                        style: TextStyle(fontSize: 20.0),
                                      ))),
                            Positioned(
                                top: MediaQuery.of(context).size.height - 250.0,
                                left: 10.0,
                                child: Container(
                                    height: 125.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: clientsToggle
                                        ? ListView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.all(8.0),
                                            children: clients.map((element) {
                                              return clientCard(element);
                                            }).toList(),
                                          )
                                        : Container(height: 1.0, width: 1.0))),
                            resetToggle
                                ? Positioned(
                                    top: MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).size.height -
                                            50.0),
                                    right: 15.0,
                                    child: FloatingActionButton(
                                      onPressed: resetCamera,
                                      mini: true,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.refresh),
                                    ))
                                : Container(),
                            resetToggle
                                ? Positioned(
                                    top: MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).size.height -
                                            50.0),
                                    right: 60.0,
                                    child: FloatingActionButton(
                                        onPressed: addBearing,
                                        mini: true,
                                        backgroundColor: Colors.green,
                                        child: Icon(Icons.rotate_left)))
                                : Container(),
                            resetToggle
                                ? Positioned(
                                    top: MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).size.height -
                                            50.0),
                                    right: 110.0,
                                    child: FloatingActionButton(
                                        onPressed: removeBearing,
                                        mini: true,
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.rotate_right)))
                                : Container()
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.map),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
