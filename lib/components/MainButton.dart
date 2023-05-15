import 'package:flutter/material.dart';
import 'package:nudilk/constants.dart';

class MainButton extends StatelessWidget {
  final VoidCallback onpressed;
  String? buttonText;
  double? width;
  double? fontSized;
  double? borderRadius;
  MainButton(
      {this.buttonText,
      required this.onpressed,
      this.borderRadius,
      this.width,
      this.fontSized});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSecondaryAppColor,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30.0)),
      //  elevation: 5.0,
      child: MaterialButton(
        minWidth: width ?? double.infinity,
        onPressed: onpressed,
        child: Text(
          '${buttonText!}',
          style: TextStyle(
            fontSize: fontSized ?? 20,
            fontFamily: 'PlayfairDisplay',
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
