import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/model/Users.dart';
import 'package:nudilk/services/auth_helper.dart';

class UserFirebaseHelper {
  UserFirebaseHelper._();
  static UserFirebaseHelper helper = UserFirebaseHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final String usersCollectionName = 'Users';

  //________________________________________________

  Future<String?> addUser(Users user) async {
    String uid = AuthHelper.authHelper.auth.currentUser!.uid;

    File file = user.file!;
    String uploadedImageUrl = await uploadUserImage(file);
    user.imageURL = uploadedImageUrl;
    firestore.collection(usersCollectionName).doc(uid).update({
      "imageURL": user.imageURL,
    });
  }

  Future<String> uploadUserImage(File file) async {
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String fullPath = 'Users/$fileName';

    Reference refrence = storage.ref(fullPath);
    TaskSnapshot task = await refrence.putFile(file);
    String imageUrl = await refrence.getDownloadURL();
    return imageUrl;
  }
  //------------------------------------------------------

}

class ChaletsFirebaseHelper {
  ChaletsFirebaseHelper._();
  static ChaletsFirebaseHelper helper = ChaletsFirebaseHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final String chaletsCollectionName = 'Chalets';

  //________________________________________________
  Future addReview(String chaletId, int rating, String comment) async {
    try {
      // firestore.collection('reviews').add({
      //   'chaletId': chaletId,
      //   'rating': rating,
      //   'comment': comment,
      //   'userId': AuthHelper.authHelper.auth.currentUser!.uid,
      // });
      firestore.collection('Reviews').add({
        'chaletId': chaletId,
        'rating': rating,
        'comment': comment,
        'userId': AuthHelper.authHelper.auth.currentUser!.uid,
        'name': AuthHelper.authHelper.auth.currentUser!.displayName,
      }).then(
            (value) => firestore
            .collection('Reviews')
            .doc(value.id)
            .update(
          {
            'id': value.id,
          },
        ),
      );
      Fluttertoast.showToast(
          msg: 'Review done',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }catch (e) {
      Fluttertoast.showToast(
          msg: 'error adding review',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String?> addChalets(Chalets chalets) async {
    try {
      String uid = AuthHelper.authHelper.auth.currentUser!.uid;

      File file = chalets.file!;
      String uploadedImageUrl = await uploadChaletImage(file);
      chalets.imageURL = uploadedImageUrl;
      firestore.collection(chaletsCollectionName).add(chalets.toJson()).then(
            (value) => firestore
                .collection(chaletsCollectionName)
                .doc(value.id)
                .update(
              {
                'id': value.id,
              },
            ),
          );
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'error $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String> uploadChaletImage(File file) async {
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String fullPath = 'Chalets/$fileName';
    Reference refrence = storage.ref(fullPath);
    TaskSnapshot task = await refrence.putFile(file);
    String imageUrl = await refrence.getDownloadURL();
    return imageUrl;
  }

  //------------------------------------------------------

}
