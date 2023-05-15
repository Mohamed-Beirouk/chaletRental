import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/MyTextFormField.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/screens/UserScreen/chalet_Screen.dart';
import '../../services/fireStorge_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewsScreen extends StatefulWidget {
  const AddReviewsScreen({Key? key, required this.chaletID}) : super(key: key);
  final Chalets? chaletID;
  @override
  _AddReviewsScreen createState() => _AddReviewsScreen();
}

class _AddReviewsScreen extends State<AddReviewsScreen> {
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  TextEditingController? rateInputController;
  TextEditingController? commentInputController;

  @override
  void initState() {
    rateInputController = TextEditingController();
    commentInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rateInputController = TextEditingController();
    commentInputController = TextEditingController();
  }
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Reviews screen',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
                SizedBox(height: 8.0),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rating:', style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 8.0),
                      RatingBar(
                        initialRating: _rating,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 40.0,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: Colors.yellow),
                          empty: Icon(Icons.star_border, color: Colors.grey),
                          half: Icon(Icons.star, color: Colors.yellow),
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      MyTextFormField(
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'comment ';
                        //   } else if (value.length < 8) {
                        //     return 'comment must be longer than 8 characters';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        controller: commentInputController,
                        topPadding: 10,
                        hintText: 'Enter comment here ',
                        //  labelText: "Email or phone ",
                        widgetIcon: Icon(
                          Icons.comment,
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

                            if (_FormKey.currentState!.validate()) {
                              Fluttertoast.showToast(
                                  msg: 'feedback Added  ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Future.delayed(Duration(milliseconds: 500))
                                  .then((value) {
                                ChaletsFirebaseHelper.helper
                                    .addReview(widget.chaletID!.id.toString(), int.parse(_rating.toString().split(".")[0]), commentInputController!.text.toString());
                              }).then((value) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return ChaletScreen(
                                        isGuest: false,
                                        chalet: widget.chaletID,
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
