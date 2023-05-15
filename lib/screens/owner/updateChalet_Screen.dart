import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

class UpdateChaletScreen extends StatefulWidget {
  final Chalets? chalet;

  UpdateChaletScreen({
    this.chalet,
  });
  @override
  State<UpdateChaletScreen> createState() => _UpdateChaletScreenState();
}

class _UpdateChaletScreenState extends State<UpdateChaletScreen> {
  TextEditingController? locationInputController = TextEditingController();
  TextEditingController? nameInputController = TextEditingController();
  TextEditingController? descriptionInputController = TextEditingController();
  TextEditingController? priceInputController = TextEditingController();
  TextEditingController? offerInputController = TextEditingController();
  TextEditingController? addInputController = TextEditingController();

  var currentClient;
  var currentBearing;

  GoogleMapController? mapController;
  GoogleMapController? _mapController;

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  String locbuttontext = 'Choose chalet location';

  var currentLocation;
  double? lon;
  double? lat;




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
        CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0))).then((val) {
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
            bearing: currentBearing == 360.0 ? currentBearing : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 360.0) {}
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
            bearing: currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 0.0) {}
        else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  @override
  void initState() {
    locationInputController!.text = '${widget.chalet!.location}';
    nameInputController!.text = '${widget.chalet!.name}';
    descriptionInputController!.text = '${widget.chalet!.description}';
    priceInputController!.text='${widget.chalet!.price}';
    offerInputController!.text = '${widget.chalet!.offer}';
    lon = widget.chalet!.lon;
    lat = widget.chalet!.lat;
    super.initState();

    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
    Provider.of<ChaletsProvider>(context, listen: false).getCurrentPosition();
    Provider.of<ChaletsProvider>(context, listen: false)
        .getChaletByID(widget.chalet!.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationInputController = TextEditingController();
    nameInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  final GlobalKey<FormState> _globalKey = GlobalKey();
  List<dynamic> iconServicesName = ['wifi'];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Consumer<ChaletsProvider>(
            builder: (context, chaletsProvider, _) => Column(
              children: [
                chaletsProvider.chaletid == null
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
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/defaultChaletImage.png"))),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 70,
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
                                  icon: const Icon(
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
                                image: NetworkImage(
                                    '${chaletsProvider.chaletid!.imageURL}'),
                                fit: BoxFit.cover)),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 70,
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
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 280,
                              left: 20,
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
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
                      Row(
                        children: [
                          const Text(
                            'my info',
                            style:
                                TextStyle(fontSize: 22, color: kMainAppColor),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                  'assets/images/editImageUser.png')),
                        ],
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Name of the Chalets ';
                          } else if (value.length < 6) {
                            return 'Name of the Chalets must be longer than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: nameInputController,
                        topPadding: 10,
                        widgetIcon: const Icon(
                          Icons.person,
                          color: Color(0xff000033),
                        ),
                        width: width - 50,
                        hintText: 'update your Name of the Chalets',
                        labelText: "Name of the Chalets",
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Name of the Location ';
                          } else if (value.length < 6) {
                            return 'Location  of the Chalets must be longer than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: locationInputController,
                        topPadding: 10,
                        widgetIcon: const Icon(
                          Icons.location_city,
                          color: Color(0xff000033),
                        ),
                        width: width - 50,
                        hintText: 'update your Location of the Chalets',
                        labelText: "Location of the Chalets",
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Description of the Chalets ';
                          } else if (value.length < 6) {
                            return 'Description of the Chalets must be longer than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: descriptionInputController,
                        topPadding: 10,
                        widgetIcon: const Icon(
                          Icons.info,
                          color: Color(0xff000033),
                        ),
                        width: width - 50,
                        hintText: 'update your Description of the Chalets',
                        labelText: "Description of the Chalets",
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: MainButton(
                          onpressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 300,
                                    child: GoogleMap(
                                      initialCameraPosition: Provider.of<ChaletsProvider>(context).initialPosition,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: true,
                                      mapToolbarEnabled:true,
                                      onMapCreated: (GoogleMapController controller) {
                                        _mapController = controller;
                                      },
                                      onTap: (LatLng location) {
                                        print(location);
                                        setState(() {
                                          lon = location.latitude;
                                          lat = location.longitude;
                                          locbuttontext = lon.toString()+ " "+lat.toString();
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          buttonText: locbuttontext,

                          width: double.infinity,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Text("Price",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                    color: Color(0xFF132D47),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    RegExp regex = RegExp(r'[0-9]');
                                    if (value!.isEmpty) {
                                      return 'please enter your price ';
                                    } else if (value.length > 5) {
                                      return 'price of the Chalets must be less than 5 characters';
                                    } else if (!regex.hasMatch(value)) {
                                      return 'only number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: priceInputController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Offer",
                                style: TextStyle(
                                    color: Color(0xFF132D47),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 30,
                                width: 100,
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    RegExp regex = RegExp(r'[0-9]');
                                    // if (value!.isEmpty) {
                                    //   return 'please enter your price ';
                                    // } else if (value.length > 3) {
                                    //   return 'price of the Chalets must be less than 5 characters';
                                    // } else
                                      if (!regex.hasMatch(value!) && value.isNotEmpty) {
                                      return 'only number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: offerInputController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    // suffixIcon: Center(
                                    //     child: Text(
                                    //   "\$",
                                    //   style: TextStyle(
                                    //     fontSize: 24,
                                    //   ),
                                    // )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainButton(
                        width: width / 3,
                        onpressed: () {
                          if (_globalKey.currentState!.validate()) {
                            FireStoreHelper.fireStoreHelper.updateChalets(
                              Chalets(
                                  id: chaletsProvider.chaletid!.id,
                                  location: locationInputController!.text,
                                  name: nameInputController!.text,
                                  description: descriptionInputController!.text,
                                  offer: int.parse(offerInputController!.text),
                                  price: int.parse(priceInputController!.text),
                                  lat: lat,
                                  lon: lon,
                                  iconServicesName: iconServicesName),
                            );
                          }
                        },
                        fontSized: 24,
                        buttonText: "Save",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
