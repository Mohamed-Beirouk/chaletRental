import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/services/fireStore_helper.dart';

class AuthHelper {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String usersCollectionName = 'Users';

  register(Users users) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: users.email!,
        password: users.password!,
      );
      String id = userCredential.user!.uid;
      users.id = id;
      FireStoreHelper.fireStoreHelper.saveUserInFirestore(users, id);
      return id;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: 'The password provided is too weak.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      String id = userCredential.user!.uid;

      return id;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'No user found for that email.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Wrong password provided for that user.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
            msg: 'invalid-email',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'user-disabled') {
        Fluttertoast.showToast(
            msg: 'user-disabled',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  // changePassword(password) async {
  //   try {
  //     await auth.currentUser!.updatePassword(password);
  //     Fluttertoast.showToast(
  //         msg: 'password  updated',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //         msg: 'password doesnt updated',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  logout() async {
    auth.signOut();
    FirebaseAuth.instance.signOut().then((value) {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      print("The current used is null because you logged out " +
          FirebaseAuth.instance.currentUser.toString());
    });
  }

  sendVerificationEmail() async {
    await auth.currentUser!.sendEmailVerification();
  }

  resetPassword(String email) async {
    // try {
    await auth.sendPasswordResetEmail(email: email);
  }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-email') {
  //       print('invalid-email');
  //     } else if (e.code == 'user-not-found') {
  //       print('user-not-found.');
  //     }
  //   }
  // }

}
