import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/screens/owner/OwnerHomeScreen.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:provider/provider.dart';

import '../../services/fireStorge_helper.dart';
import 'addChaletConfirmation_screen.dart';

class AddChaletScreen extends StatefulWidget {
  static const String id = "AddChaletScreen_screen";
  @override
  _AddChaletScreenState createState() => _AddChaletScreenState();
}

class _AddChaletScreenState extends State<AddChaletScreen> {
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  TextEditingController? phoneInputController;
  TextEditingController? nameInputController;
  TextEditingController? locationInputController;
  TextEditingController? descriptionInputController;
  List<XFile> selectedFile = [];
  List<String> arrayImagesURL = [];
  TextEditingController? priceInputController = TextEditingController();
  GoogleMapController? _mapController;

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  String locbuttontext = 'Choose chalet location';

  var currentLocation;
  double? lon;
  double? lat;
  var clients = [];

  var currentClient;
  var currentBearing;

  GoogleMapController? mapController;

  Future imageMultPicker() async {
    if (selectedFile != null) {
      selectedFile.clear();
    }
    try {
      final List<XFile> _picker = await ImagePicker().pickMultiImage();
      if (_picker.isNotEmpty) {
        selectedFile.addAll(_picker);
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {});
  }

  Future imagePicker(source) async {
    final _picker = await ImagePicker().pickImage(source: source);
    if (_picker == null) {
      print('image is null');
    } else {
      setState(() {
        selectedFile.add(_picker);
      });
    }
  }

  Future<List> uploadingFunction(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      var imageURl = await UploadFile(_images[i]);
      arrayImagesURL.add(imageURl.toString());
      Fluttertoast.showToast(
          msg: 'please wait till uploading images ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return arrayImagesURL;
  }

  Future<String> UploadFile(XFile _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference refrence = storage.ref().child("Chalets").child(_image.name);
    UploadTask uploadTask = refrence.putFile(File(_image.path));
    await uploadTask.whenComplete(() {});
    return refrence.getDownloadURL();
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

  @override
  void initState() {
    phoneInputController = TextEditingController();
    nameInputController = TextEditingController();
    locationInputController = TextEditingController();
    descriptionInputController = TextEditingController();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
    Provider.of<ChaletsProvider>(context, listen: false).getCurrentPosition();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneInputController = TextEditingController();
    nameInputController = TextEditingController();
    locationInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Request to add a chalet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(OwnerHomeScreen.id);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _FormKey,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // imagePath == null
                selectedFile.isEmpty
                    ? Container(
                        height: height * 0.176,
                        width: width * 0.85,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Image.asset('assets/images/loginScreen.png'))
                    : Container(
                        height: 250,
                        child: GridView.builder(
                            itemCount: selectedFile.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.file(
                                  File(selectedFile[index].path),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                      ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Name ';
                          } else if (value.length < 8) {
                            return 'Name of chalets must be longer than 8 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: nameInputController,
                        topPadding: 55,
                        hintText: 'Chalet Name',
                        //   labelText: "Name",
                        widgetIcon: Icon(
                          Icons.location_city,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Phone ';
                          } else if (value.length < 8) {
                            return 'Phone must be longer than 8 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: phoneInputController,
                        topPadding: 10,
                        hintText: 'Enter phone number ',
                        //  labelText: "Email or phone ",
                        widgetIcon: Icon(
                          Icons.phone,
                          size: 18,
                          color: Color(0xFF000033),
                        ),
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
                                      initialCameraPosition:
                                          Provider.of<ChaletsProvider>(context)
                                              .initialPosition,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: true,
                                      mapToolbarEnabled: true,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _mapController = controller;
                                      },
                                      onTap: (LatLng location) {
                                        print(location);
                                        setState(() {
                                          lon = location.latitude;
                                          lat = location.longitude;
                                          locbuttontext = lon.toString() +
                                              " " +
                                              lat.toString();
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

                      MyTextFormField(
                        controller: locationInputController,
                        topPadding: 10,
                        hintText: 'Enter chalet Location details',
                        //   labelText: "Location",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Location ';
                          } else if (value.length < 4) {
                            return 'must be real ';
                          } else {
                            return null;
                          }
                        },
                        widgetIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff000033),
                        ),
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      MyTextFormField(
                        controller: descriptionInputController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Description ';
                          } else if (value.length < 8) {
                            return 'Description must be longer than 8 characters';
                          } else {
                            return null;
                          }
                        },
                        maxLine: 5,
                        topPadding: 10,
                        hintText: 'Enter a description.',
                        //   labelText: "description.",
                        widgetIcon: Icon(
                          Icons.info,
                          color: Color(0xff000033),
                        ),
                        secure: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Chalet image ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                imageMultPicker();
                              },
                              child: Container(
                                height: 85,
                                width: 95,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                imagePicker(ImageSource.camera);
                              },
                              child: Container(
                                height: 85,
                                width: 95,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                              ),
                            ),
                            Container(
                              height: 85,
                              width: 95,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: MainButton(
                          onpressed: () async {
                            if (selectedFile == null) {
                              Fluttertoast.showToast(
                                  msg: 'please pic image',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            if (_FormKey.currentState!.validate() &&
                                selectedFile != null) {
                              List doneList =
                                  await uploadingFunction(selectedFile);
                              Chalets newChalets = Chalets(
                                  OwnerId: AuthHelper
                                      .authHelper.auth.currentUser!.uid,
                                  name: nameInputController!.text,
                                  phone: phoneInputController!.text,
                                  email: AuthHelper
                                      .authHelper.auth.currentUser!.uid,
                                  location: locationInputController!.text,
                                  chaletsStatus: false,
                                  lat: lat,
                                  lon: lon,
                                  offer: 0,
                                  price: int.parse(priceInputController!.text),
                                  description: descriptionInputController!.text,
                                  file: File(selectedFile.first.path),
                                  arrayImagesURL: doneList);
                              Fluttertoast.showToast(
                                  msg: 'chalet Added  ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Future.delayed(Duration(milliseconds: 500))
                                  .then((value) {
                                ChaletsFirebaseHelper.helper
                                    .addChalets(newChalets);
                              }).then((value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return AddChaletConfirmationScreen(
                                        isSuccess: true,
                                      );
                                    },
                                  ),
                                );
                              });
                            }
                          },
                          buttonText: 'Send',
                          width: double.infinity,
                        ),
                      ),
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
