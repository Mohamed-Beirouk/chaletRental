import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/model/Booking.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/screens/UserScreen/home_screen.dart';
import 'package:nudilk/services/fireStorge_helper.dart';

import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String usersCollectionName = 'Users';
  final String chaletsCollectionName = 'Chalets';
  final String favouriteCollectionName = 'Favourite';
  final String bookingCollectionName = 'Booking';
  List<Chalets> chalets = [];
  List<Booking> booking = [];
  List<Chalets> favChalets = [];
  bool isFavorited = false;

  //=============================================================
  saveUserInFirestore(Users users, String uid) async {
    try {
      firestore.collection(usersCollectionName).doc(uid).set({
        "uid": users.id,
        "name": users.name,
        "phone": users.phone,
        "email": users.email,
        "type": users.type,
      });
      UserFirebaseHelper.helper.addUser(users);
    } on Exception catch (e) {
      print('error is $e');
    }
  }

  getId() async {
    String id = AuthHelper.authHelper.auth.currentUser!.uid;
    return id;
  }

  Future getUserData() async {
    return await getUser(getId()).then((snapshot) => snapshot.data());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String id) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await firestore.collection(usersCollectionName).doc(id).get();

    return user;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChalet(String id) async {
    DocumentSnapshot<Map<String, dynamic>> chalet =
        await firestore.collection(chaletsCollectionName).doc(id).get();

    return chalet;
  }

  Future<Users> getUserByID(uid) async {
    // String uid = AuthHelper.authHelper.auth.currentUser.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getUser(uid);
    Users user = Users.fromJson(snapshot.data()!);
    return user;

    //  notifyListeners();
  }

  Future<String?> getUsertype(uid) async {
    // String uid = AuthHelper.authHelper.auth.currentUser.uid;
    if (uid == null) {
    } else {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FireStoreHelper.fireStoreHelper.getUser(uid);
      Users user = Users.fromJson(snapshot.data()!);

      return user.type;
    }
    //  notifyListeners();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(usersCollectionName).get();

    return snapshot;
  }

  //==============================================
  Future<QuerySnapshot<Map<String, dynamic>>> getAllChalets() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(chaletsCollectionName).get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllComments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('Reviews').get();
    return snapshot;
  }

  getOwnerChalets() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await getAllChalets();
    //String OwnerChalets = AuthHelper.authHelper.auth.currentUser!.uid;
    chalets.clear();

    for (var element in snapshot.docs) {
      chalets.add(Chalets.fromJson(element.data()));
    }
  }

  updateChaletsStatus(Chalets chalets, bool chaletsStatus) async {
    try {
      await firestore.collection(chaletsCollectionName).doc(chalets.id).update({
        "chaletsStatus": chaletsStatus,
      });
      Fluttertoast.showToast(
          msg: 'updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error on Update',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateUserProfile(Users users) async {
    String uid = AuthHelper.authHelper.auth.currentUser!.uid;
    try {
      await firestore
          .collection(usersCollectionName)
          .doc(uid)
          .update({"email": users.email, "name": users.name});
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error user not Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateChalets(Chalets chalets) async {
    try {
      await firestore.collection(chaletsCollectionName).doc(chalets.id).update({
        "location": chalets.location,
        "name": chalets.name,
        "description": chalets.description,
        "offer": chalets.offer,
        "lat": chalets.lat,
        "lon": chalets.lon,
        "price": chalets.price,
        "iconServicesName": chalets.iconServicesName
      });
      Fluttertoast.showToast(
          msg: 'update Chalets Success ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error Chalets not Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFavouriteChalets() async {
    String uid = AuthHelper.authHelper.auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> allFavChalets = await firestore
        .collection(usersCollectionName)
        .doc(uid)
        .collection(favouriteCollectionName)
        .get();
    return allFavChalets;
  }

  // Future getAllFav(Chalets chalets) async {
  //   String uid = AuthHelper.authHelper.auth.currentUser!.uid;
  //   return firestore
  //     ..collection(usersCollectionName)
  //         .doc(uid)
  //         .collection(favouriteCollectionName)
  //         .get();
  // }
  Future checkIfFavouriteChaletsExists(Chalets chalets) async {
    final snapshot = await getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }

    List contain =
    favChalets.where((element) => element.id == chalets.id).toList();
    if (contain.isEmpty) {
      addFavouriteChaletsToUser(chalets);
      return false;
    } else {
      removeFavouriteChaletsToUser(chalets);
      return true;
      // Fluttertoast.showToast(
      //     msg: 'Favourite chalets is existed',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

   checkIfFavouriteChaletsExistsBegin(Chalets? chalets) async {
    final snapshot = await getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }
    List contain =
        favChalets.where((element) => element.id == chalets?.id).toList();
    if (contain.isEmpty) {
      isFavorited=false;
    } else {
      isFavorited=true;
    }
  }

  Future<bool> checkIconIfFavouriteChaletsExists(Chalets chalets) async {
    final snapshot = await getFavouriteChalets();
    favChalets.clear();
    for (var element in snapshot.docs) {
      favChalets.add(Chalets.fromJson(element.data()));
    }

    List contain =
        favChalets.where((element) => element.id == chalets.id).toList();
    if (contain.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  addFavouriteChaletsToUser(Chalets chalets) async {
    try {
      String uid = AuthHelper.authHelper.auth.currentUser!.uid;
      await firestore
          .collection(usersCollectionName)
          .doc(uid)
          .collection(favouriteCollectionName)
          .doc(chalets.id)
          .set(chalets.toJson());

      Fluttertoast.showToast(
          msg: 'chalet Added to your favourite ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error adding Favourite chalets',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  removeFavouriteChaletsToUser(Chalets chalets) async {
    try {
      String uid = AuthHelper.authHelper.auth.currentUser!.uid;
      await firestore
          .collection(usersCollectionName)
          .doc(uid)
          .collection(favouriteCollectionName)
          .doc(chalets.id)
          .delete();

      Fluttertoast.showToast(
          msg: 'chalet removed to your favourite ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error removed Favourite chalets',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  addBookingToChaletsAndUser(Chalets chalets, Booking booking) async {
    String uid = AuthHelper.authHelper.auth.currentUser!.uid;

    await firestore
        .collection(usersCollectionName)
        .doc(uid)
        .collection(bookingCollectionName)
        .add(booking.toJson())
        .then((value) {
      String id = value.id;
      return firestore
          .collection(chaletsCollectionName)
          .doc(chalets.id)
          .collection(bookingCollectionName)
          .doc(value.id)
          .set(
        {
          "id": value.id,
          "userId": booking.userId,
          'userName': booking.userName,
          'userEmail': booking.userEmail,
          'userPhone': booking.userPhone,
          'placeId': booking.placeId,
          'placeName': booking.placeName,
          'imageURL': booking.imageURL,
          'placeLocation': booking.placeLocation,
          'description': booking.description,
          'dateRange': booking.dateRange,
          'bookingStatus': booking.bookingStatus,
          'servicePrice': booking.servicePrice,
          'price': booking.price,
          'childrenNumber': booking.childrenNumber,
          'adultsNumber': booking.adultsNumber,
          "dateCount": booking.dateCount
        },
      ).then(
        (value) => firestore
            .collection(usersCollectionName)
            .doc(uid)
            .collection(bookingCollectionName)
            .doc(id)
            .update(
          {'id': id},
        ),
      );
    });
  }

  deleteBookingToChaletsAndUser(Booking booking) async {
    try {
      String uid = AuthHelper.authHelper.auth.currentUser!.uid;

      await firestore
          .collection(chaletsCollectionName)
          .doc(booking.placeId)
          .collection(bookingCollectionName)
          .doc(booking.id)
          .delete()
          .then((value) {
        firestore
            .collection(usersCollectionName)
            .doc(uid)
            .collection(bookingCollectionName)
            .doc(booking.id)
            .delete();
      });
      Fluttertoast.showToast(
          msg: 'booking deleted success ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'delete booking error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  cancelledBookingToChaletsAndUser(Booking booking, BuildContext context) async {
    try {
      String uid = AuthHelper.authHelper.auth.currentUser!.uid;

      await firestore
          .collection(chaletsCollectionName)
          .doc(booking.placeId)
          .collection(bookingCollectionName)
          .doc(booking.id)
          .update({"bookingStatus": "Canceled By User"}).then((value) {
        firestore
            .collection(usersCollectionName)
            .doc(uid)
            .collection(bookingCollectionName)
            .doc(booking.id)
            .delete();
      });
      Fluttertoast.showToast(
          msg: 'booking deleted success ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return HomeScreen();
        }));
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'delete booking error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBookedChalets() async {
    String uid = AuthHelper.authHelper.auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> allBookedChalets = await firestore
        .collection(usersCollectionName)
        .doc(uid)
        .collection(bookingCollectionName)
        .get();
    return allBookedChalets;
  }

  getChaletsById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> allBookedChalets =
        await firestore.collection(chaletsCollectionName).doc(id).get();
    return allBookedChalets;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBookedForMyChalets(
      Chalets chalets) async {
    QuerySnapshot<Map<String, dynamic>> allBookedForAChalets = await firestore
        .collection(chaletsCollectionName)
        .doc(chalets.id)
        .collection(bookingCollectionName)
        .get();
    return allBookedForAChalets;
  }

  Future editBookingStatus(Booking booking, String status) async {
    try {
      await firestore
          .collection(chaletsCollectionName)
          .doc(booking.placeId)
          .collection(bookingCollectionName)
          .doc(booking.id)
          .update({'bookingStatus': status});
      Fluttertoast.showToast(
          msg: 'bookingStatus updating  for $status',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error updating status',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  Future editBookingStatusForUser(Booking booking, String status) async {
    try {
      await firestore
          .collection(usersCollectionName)
          .doc(booking.userId)
          .collection(bookingCollectionName)
          .doc(booking.id)
          .update({
        'id': booking.id,
        'bookingStatus': status,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error updating status for User',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllBookingForChalets(
      Chalets chalets) async {
    QuerySnapshot<Map<String, dynamic>> allBooking = await firestore
        .collection(chaletsCollectionName)
        .doc(chalets.id)
        .collection(bookingCollectionName)
        .get();

    return allBooking;
  }

  Future addAllBookingForChaletsToList(Chalets chalets) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getAllBookingForChalets(chalets);
    booking.clear();

    for (var element in snapshot.docs) {
      booking.add(Booking.fromJson(element.data()));
    }
    return booking;
  }

  Future deleteBookingForTheUser(Chalets chalets) async {
    try {
      List<Booking> bookings = await FireStoreHelper.fireStoreHelper
          .addAllBookingForChaletsToList(chalets);
      for (var element in bookings) {
        await firestore
            .collection(usersCollectionName)
            .doc(element.userId)
            .collection(bookingCollectionName)
            .doc(element.id)
            .delete();
        await firestore
            .collection(chaletsCollectionName)
            .doc(element.placeId)
            .collection(bookingCollectionName)
            .doc(element.id)
            .delete();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'error while deleting booking to user on Delete Chalets Process ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future deleteChaletsAfterDeletingBookings(Chalets chalets) async {
    try {
      await firestore
          .collection(chaletsCollectionName)
          .doc(chalets.id)
          .delete();
      Fluttertoast.showToast(
          msg: '  Chalets Delete Process  successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error while Delete Chalets Process ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
//
//   Future<LoginUser> getUserData() async {
//     String uid = AuthHelper.authHelper.auth.currentUser.uid;
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FireStoreHelper.fireStoreHelper.getUser(uid);
//     LoginUser user = LoginUser.fromJson(snapshot.data());
//     return user;
//
//     //  notifyListeners();
//   }
//
//   Future<String> getUserType(uid) async {
//     // String uid = AuthHelper.authHelper.auth.currentUser.uid;
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FireStoreHelper.fireStoreHelper.getUser(uid);
//     LoginUser user = LoginUser.fromJson(snapshot.data());
//     return user.type;
//
//     //  notifyListeners();
//   }
//

//
//   Future<Qu  Future<LoginUser> getUserByID(uid) async {
//     // String uid = AuthHelper.authHelper.auth.currentUser.uid;
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FireStoreHelper.fireStoreHelper.getUser(uid);
//     LoginUser user = LoginUser.fromJson(snapshot.data());
//     print(user.name);
//     return user;
//
//     //  notifyListeners();
//   }erySnapshot<Map<String, dynamic>>> getUsers() async {
//     QuerySnapshot<Map<String, dynamic>> allUsers =
//         await firestore.collection(usersCollectionName).get();
//
//     return allUsers;
//   }
//
//   Future<QuerySnapshot<Map<String, dynamic>>> getAllOrders() async {
//     QuerySnapshot<Map<String, dynamic>> allOrder =
//         await firestore.collection(ordersCollectionName).get();
//     return allOrder;
//
//     // List<QueryDocumentSnapshot<Map<String, dynamic>>> OrderList = allOrder.docs;
//     // OrderList.map((e) => Order.fromJson(json: e)).toList();
//   }
//
// // step two get data from fireStore ...............................................
//   Future<QuerySnapshot<Map<String, dynamic>>> getMassages() async {
//     QuerySnapshot<Map<String, dynamic>> allMessages =
//         await firestore.collection(messagesCollectionName).get();
//     return allMessages;
//   }
//

//
//   Future<DocumentSnapshot<Map<String, dynamic>>> getOneOffer(String id) async {
//     DocumentSnapshot<Map<String, dynamic>> allAddedOffer =
//         await firestore.collection(offersCollectionName).doc(id).get();
//
//     return allAddedOffer;
//   }
//
//   // Future<DocumentSnapshot<Map<String, dynamic>>> getOneOrder(String id) async {
//   //   DocumentSnapshot<Map<String, dynamic>> allFavRecipe =
//   //       await firestore.collection(ordersCollectionName).doc(id).get();
//   //
//   //   return allFavRecipe;
//   // }
//   //
//   // oneOrderDelete(String id) async {
//   //   // String uid = AuthHelper.authHelper.auth.currentUser.uid;
//   //   await firestore.collection(ordersCollectionName).doc(id).delete();
//   // }
//
//   Future<String> updateisAccepted(Order order, String orderId) async {
//     await firestore.collection(ordersCollectionName).doc(orderId).update({
//       "isAccepted": order.isAccepted,
//     });
//   }
//
//   addRecipe(DocumentSnapshot<Map<String, dynamic>> doc) {
// //    print(doc.data());
//     orders.add(Order.fromJson(doc.data(), doc.id));
//     //  print(recipes.length);
//   }
//
//   Future<QuerySnapshot<Map<String, dynamic>>> getOrders() async {
//     QuerySnapshot<Map<String, dynamic>> allOrders =
//         await firestore.collection(ordersCollectionName).get();
//
//     return allOrders;
//   }
//

//   Future<String> addOffers(String orderId, Offer offer) async {
//     firestore.collection(offersCollectionName).add(offer.toJson()).then(
//           (value) => firestore
//               .collection(ordersCollectionName)
//               .doc(orderId)
//               .collection(offersCollectionName)
//               .doc(value.id)
//               .set(
//             {"id": value.id},
//           ),
//         );
//   }
//
//   // addOneOffer(String orderId, String offerId) async {
//   //   await firestore
//   //       .collection(ordersCollectionName)
//   //       .doc(orderId)
//   //       .collection(offersCollectionName)
//   //       .doc(offerId)
//   //       .set({
//   //     "id": offerId,
//   //   });
//   // }
//
//   Future<QuerySnapshot<Map<String, dynamic>>> getOfferss() async {
//     QuerySnapshot<Map<String, dynamic>> allOffers =
//         await firestore.collection(offersCollectionName).get();
//
//     return allOffers;
//   }
//
//   setNewOrder(Order order) async {
//     String uid = AuthHelper.authHelper.auth.currentUser.uid;
//
//     firestore.collection(ordersCollectionName).doc(uid).set({
//       'orderName': order.orderName,
//       'imageUrl': order.imageUrl,
//       'author': uid,
//       'id': order.id,
//     });
//   }

//=============================================================
//   getChat({
//     @required String userId,
//     @required String myId,
//   }) {
//     String chatId = generateChatId(username1: userId, username2: myId);
//     return firestore
//         .collection('chatsCollectionName')
//         .doc(chatId)
//         .collection('messagesCollectionName')
//         .orderBy('time', descending: true)
//         .snapshots();
//   }
//
//   setNewChat({
//     @required String userId,
//     @required String myId,
//   }) async {
//     String chatId = generateChatId(username1: userId, username2: myId);
//     List<String> members = [userId, myId];
//     firestore.collection(chatsCollectionName).doc(chatId).set(
//       {'receiver': userId, 'sender': myId, 'members': members},
//     );
//   }
//
//   generateChatId({@required String username1, @required String username2}) {
//     return username1.toString().compareTo(username2.toString()) < 0
//         ? username1.toString() + '-' + username2.toString()
//         : username2.toString() + '-' + username1.toString();
//   }
//
//   Future<bool> checkChatExistsOrNot(
//       {@required String username1, @required String username2}) async {
//     String chatId = generateChatId(username1: username1, username2: username2);
//     DocumentSnapshot doc =
//         await firestore.collection('Chats').doc(chatId).get();
//     return doc.exists;
//   }
//
//   getChats({@required String userId}) {
//     return firestore
//         .collection('Chats')
//         .where('members', arrayContains: userId)
//         .snapshots();
//   }
//
//   getUserByUsername({@required String username}) async {
//     return await firestore.collection('Users').doc(username).get();
//   }
// }
