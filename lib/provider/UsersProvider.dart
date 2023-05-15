import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/services/fireStore_helper.dart';

class UsersProvider extends ChangeNotifier {
  List<Users> users = [];
  Users? userid;
  getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getAllUsers();
    users.clear();

    for (var element in snapshot.docs) {
      users.add(Users.fromJson(element.data()));
    }

    notifyListeners();
  }

  Future<Users> getUserByID(uid) async {
    // String uid = AuthHelper.authHelper.auth.currentUser.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FireStoreHelper.fireStoreHelper.getUser(uid);
    Users user = Users.fromJson(snapshot.data()!);
    userid = user;
    return user;

    //  notifyListeners();
  }
}
