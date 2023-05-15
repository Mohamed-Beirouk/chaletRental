import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final double width;
  double? height;
  Widget? widgetIcon;
  bool? isPassword;
  String? containerText;
  ProfileWidget(
      {required this.width,
      this.height = 45,
      this.widgetIcon,
      this.containerText,
      this.isPassword = false});

  passwordPrinting(containerText) {
    String y = '';
    for (int x = 0; x < containerText!.length; x++) {
      y += '*';
      x++;
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: height ?? 45,
      width: width - 50,
      decoration: BoxDecoration(
        color: const Color(0xffF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          widgetIcon!,
          SizedBox(
            width: 10,
          ),
          isPassword!
              ? Text(
                  "${passwordPrinting(containerText)}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              : Text(
                  "$containerText",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  maxLines: 5,
                )
        ],
      ),
    );
  }
}
