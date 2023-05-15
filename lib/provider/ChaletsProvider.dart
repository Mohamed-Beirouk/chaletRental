import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/model/Comment.dart';
import 'package:nudilk/services/auth_helper.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import '../screens/UserScreen/chalet_Screen.dart';
import 'package:intl/intl.dart';

class ChaletsProvider extends ChangeNotifier {
  List<Chalets> chalet = [];
  List<Comment> comments = [];
  List<Comment> chaletscomments = [];
  List<Chalets> searchChalet = [];
  List<Chalets> favChalets = [];
  List<Booking> bookedChalets = [];
  List<Chalets> myBookedChalets = [];
  List<Booking> bookedForMyChalets = [];
  List<Chalets> myChalets = [];
  Set<Marker> markers = Set<Marker>();
  Chalets? chaletid;
  Position? currentPosition;
  BuildContext? context;
  bool isFavoritedd = false;
  bool didUserHaveBookedChalet = false;

  List<String> unavailableDates = [];
  static DateTime initialDate = DateTime.now();
  static DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  String formattedDate = dateFormat.format(initialDate);

  addBookedDatesToList() async {
    for (var element in bookedForMyChalets) {
      DateTime initialDate =
          DateTime.parse(element.dateRange!.split(" - ")[0].toString());
      DateTime endDate =
          DateTime.parse(element.dateRange!.split(" - ")[1].toString());

      for (var d = initialDate;
          d.isBefore(endDate) || d.isAtSameMomentAs(endDate);
          d = d.add(Duration(days: 1))) {
        DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
        String formattedDate = dateFormat.format(d);
        unavailableDates.add(formattedDate);
        print(formattedDate);
      }
      unavailableDates.add(element.dateRange!.split(" - ")[0].toString());
      unavailableDates.add(element.dateRange!.split(" - ")[1].toString());
    }

    unavailableDates.sort(((a, b) => a.compareTo(b)));
    notifyListeners();
  }

  bool setDayPredicate(DateTime val) {
    // Provider.of<ChaletsProvider>(context, listen: false).getBookingInfo(widget.chalets!.id!.toString());
    String Dates = dateFormat.format(val);
    return !unavailableDates.contains(Dates);
  }

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(25.272244, 51.509645), zoom: 10, tilt: 0, bearing: 0);

  getChalets() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/logo.png",
    );
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getAllChalets();

    chalet.clear();
    markers.clear();
    for (var element in snapshot.docs) {
      chalet.add(Chalets.fromJson(element.data()));
    }

    for (Chalets c in chalet) {
      print(c.lat.toString() + "lon lat" + c.lat.toString());

      if (c.chaletsStatus!.toString().startsWith("t")) {
        markers.add(Marker(
            markerId: MarkerId(c.id.toString()),
            position: LatLng(c.lon!, c.lat!),
            infoWindow: InfoWindow(title: c.name),
            icon: markerbitmap,
            onTap: () {
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                      builder: (context) => ChaletScreen(chalet: c)));
            }));
      }
    }
    searchChalet.clear();
    for (var element in snapshot.docs) {
      searchChalet.add(Chalets.fromJson(element.data()));
    }

    notifyListeners();
  }

  getComments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getAllComments();

    comments.clear();

    for (var element in snapshot.docs) {
      print(element.data());
      comments.add(Comment.fromJson(element.data()));
    }

    notifyListeners();
  }

  getMyChalets() async {
    await getChalets();

    myChalets = chalet
        .where((element) =>
            element.OwnerId == AuthHelper.authHelper.auth.currentUser!.uid)
        .toList();
    notifyListeners();
  }

  getAllChalets() async {
    await getChalets();
    unavailableDates.clear();
    myChalets = chalet.toList();
    notifyListeners();
  }

  getChaletsComments(String chaletID) async {
    print(chaletID);
    await getComments();
    chaletscomments.clear();
    chaletscomments = comments
        .where((element) => element.chaletId.toString() == chaletID.toString())
        .toList();
    print(chaletscomments.length.toString());
    notifyListeners();
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return true;
  }

  getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      initialPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 10,
      );
    }).catchError((e) {
      debugPrint(e);
    });
    notifyListeners();
  }

  getBookedForMyChalets() async {
    await getMyChalets();
    bookedForMyChalets.clear();
    for (var element in myChalets) {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FireStoreHelper.fireStoreHelper.getBookedForMyChalets(element);
      for (var element in snapshot.docs) {
        bookedForMyChalets.add(Booking.fromJson(element.data()));
      }
    }
    notifyListeners();
  }

  getBookingInfo(String id) async {
    await getAllChalets();
    bookedForMyChalets.clear();
    for (var element in myChalets) {
      if (element.id.toString() == id) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FireStoreHelper
            .fireStoreHelper
            .getBookedForMyChalets(element);
        for (var element in snapshot.docs) {
          if (Booking.fromJson(element.data()).bookingStatus.toString() !=
              "Canceled By Owner") {
            bookedForMyChalets.add(Booking.fromJson(element.data()));
          }
        }
      }
    }

    await addBookedDatesToList();
    notifyListeners();
  }

  isFavorited() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }
    notifyListeners();
  }

  callFavorited(Chalets? chalets) async {
    final snapshot =
        await FireStoreHelper.fireStoreHelper.getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }
    List contain =
        favChalets.where((element) => element.id == chalets?.id).toList();
    if (contain.isEmpty) {
      isFavoritedd = false;
    } else {
      isFavoritedd = true;
    }
    notifyListeners();
  }

  getFavChalets() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }
    notifyListeners();
  }

  getBookedChalets() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getBookedChalets();
    bookedChalets.clear();
    for (var element in snapshot.docs) {
      bookedChalets.add(Booking.fromJson(element.data()));
    }
    // for (var element in bookedChalets) {
    //   myBookedChalets.add(getChaletByID(element.placeId));
    // }
    notifyListeners();
  }

  didUserHaveBookedChalets(String? chaletID) async {
    didUserHaveBookedChalet = false;
    await getBookedChalets();
    //bookedChalets
    for (var element in bookedChalets) {
      if (element.placeId == chaletID) {
        didUserHaveBookedChalet = true;
        break;
      }
    }
    notifyListeners();
  }

  // getBookedChaletschalets(id) async {
  //  myBookedChalets.clear();
  //  for(var element in chalet ){
  //    myBookedChalets = chalet.w
  //  }
  //  notifyListeners();
  // }

  deleteBookedChalets(booking) async {
    await FireStoreHelper.fireStoreHelper
        .deleteBookingToChaletsAndUser(booking);

    notifyListeners();
  }

  Future<Chalets> getChaletByID(uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getChalet(uid);
    Chalets chaletss = Chalets.fromJson(snapshot.data()!);
    chaletid = chaletss;
    return chaletss;

    //  notifyListeners();
  }
}
