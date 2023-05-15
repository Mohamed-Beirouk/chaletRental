import 'package:flutter/material.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/profileWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/UserScreen/updateProfile_screen.dart';

class MessageWidget extends StatelessWidget {
  bool? isSuccess;
  String? nameOfAppbar;
  String? message;
  String? buttonText;
  final VoidCallback? onpressed;
  MessageWidget(
      {this.isSuccess,
      this.nameOfAppbar,
      this.message,
      this.onpressed,
      this.buttonText});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        elevation: 0,
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: Text(
          '${nameOfAppbar}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
                child: Container(
              height: height,
              width: width,
              color: Colors.white,
            )),
            Positioned(
                child: Container(
              height: 87,
              width: width,
              color: kMainAppColor,
            )),
            Positioned(
              left: 24,
              top: MediaQuery.of(context).size.width / 12,
              right: 24,
              child: Container(
                height: 327,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    isSuccess == true
                        ? Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              "Request Success",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFA8B2C8)),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFA8B2C8)),
                            ),
                          ),
                    isSuccess == true
                        ? Padding(
                            padding: const EdgeInsets.all(35.0),
                            child:
                                Image.asset('assets/images/confirmation.png'),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              child: Image.asset('assets/images/email.png'),
                            ),
                          ),
                    isSuccess == true
                        ? Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Text(
                              'Your Request to add a chalet is success. We will notify you when it have update. Thank you!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFA8B2C8),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Text(
                              "${message}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFA8B2C8),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: height / 5,
                left: width / 4,
                child: MainButton(
                  width: width / 2,
                  onpressed: onpressed!,
                  buttonText: buttonText == null ? 'Done' : buttonText!,
                )),
          ],
        ),
      ),
    );
  }
}
