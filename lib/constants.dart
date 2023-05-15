import 'package:flutter/material.dart';

const kMainFont = 'Poppins';
const kMainAppColor = Color(0xff367ECA);


// AIzaSyDk1HsUGVqFMLJlKGfTz2GZ3qLQNSp83rE
// AIzaSyCT2ui6nl1J3Ry5GiHS4SIpHP8G70cS7Fs

const kSecondaryAppColor = Color(0xff357EC7);
const kMainGrayColor = Color(0xFFe0e0e0);
const kMainGray2Color = Color(0xFFc3c3c3);
const kLinearGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [
    0.3,
    0.6,
  ],
  colors: [
    Color(0xff82c98f),
    Color(0xff5bc1d5),
  ],
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

String? pwdValidator(String value) {
  if (value.isEmpty) {
    return 'please enter your password ';
  } else if (value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

String? nameValidator(String value) {
  if (value.isEmpty) {
    return 'please enter your name ';
  } else if (value.length < 6) {
    return 'Password must be longer than 6 characters';
  } else {
    return null;
  }
}

String? mobileValidate(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String? customValidator(String value) {
  if (value.isEmpty) {
    return 'please enter your address ';
  } else if (value.length < 6) {
    return 'Address must be longer than 6 characters';
  } else {
    return null;
  }
}

String? selectValidator(String value) {
  if (value.isEmpty) {
    return 'please select an option  ';
  } else {
    return null;
  }
}

String? emailValidator(String value) {
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    return 'please enter your email ';
  } else if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const KTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color.fromARGB(180, 255, 255, 255),
  hintText: "Enter a hint",
  hintStyle: TextStyle(
    // fontFamily: KFontFamily,
    color: kMainGrayColor,
    fontFamily: 'PlayfairDisplay',
    // fontWeight: FontWeight.bold,
    fontSize: 18.0,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kMainGrayColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kMainGrayColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const KProfileTextColor = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
