import 'package:flutter/material.dart';
import 'package:nudilk/constants.dart';

class SecondButton extends StatelessWidget {
  final VoidCallback? onpressed;
  String? buttonText;
  double? width;
  double? height;
  bool? isMainColor = true;
  double? fontSized;
  double? borderRadius;
  SecondButton(
      {this.buttonText,
      required this.onpressed,
      this.isMainColor,
      this.borderRadius,
      this.width,
      this.height = 50,
      this.fontSized});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isMainColor! ? Colors.white : kMainAppColor,
          border:
              Border.all(color: isMainColor! ? kMainAppColor : Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30.0)),
        ),

        //  elevation: 5.0,
        child: Center(
          child: Text(
            '${buttonText!}',
            style: TextStyle(
              fontSize: fontSized ?? 20,
              fontFamily: 'PlayfairDisplay',
              color: isMainColor! ? kMainAppColor : Colors.white,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
