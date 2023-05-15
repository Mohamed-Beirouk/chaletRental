import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/components/MainButton.dart';
import 'package:nudilk/components/profileWidget.dart';
import 'package:nudilk/constants.dart';

import '../../components/secondButton.dart';

class ChaletsRequestScreen extends StatelessWidget {
  static const String id = "ChaletsRequestScreen_screen";
  final String? imageURL;
  final String? chaletName;
  final String? chaletEmail;
  final String? chaletLocation;
  final String? chaletDescription;
  final VoidCallback? onpressedB1;
  final VoidCallback? onpressedB2;
  final List? imageList;
  ChaletsRequestScreen(
      {this.chaletName,
      this.chaletLocation,
      this.chaletEmail,
      this.chaletDescription,
      this.imageURL,
      this.onpressedB1,
      this.onpressedB2,
      this.imageList});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainAppColor,
        centerTitle: true,
        title: chaletName == null
            ? Text(
                'Name of the Chalets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                chaletName!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
              left: 30,
              top: 30,
              right: 30,
              child: Container(
                  height: height * 0.176,
                  width: width * 0.7,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: imageList!.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.amber),
                              child: Container(
                                child: Image.network(
                                  i,
                                  fit: BoxFit.cover,
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  )),
            ),
            Positioned(
              top: 200,
              child: Container(
                width: width,
                margin: const EdgeInsets.only(
                  left: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileWidget(
                      width: width,
                      containerText:
                          chaletName == null ? "UserName" : chaletName!,
                      widgetIcon: Icon(
                        Icons.location_city,
                        color: Color(0xff000033),
                      ),
                    ),
                    ProfileWidget(
                      width: width,
                      containerText: chaletEmail == null
                          ? "Email must be here"
                          : chaletEmail!,
                      widgetIcon: Icon(
                        Icons.person,
                        color: Color(0xff000033),
                      ),
                    ),
                    ProfileWidget(
                      width: width,
                      isPassword: false,
                      containerText: chaletLocation == null
                          ? 'Location of the chalets'
                          : chaletLocation!,
                      widgetIcon: Icon(
                        Icons.location_on_outlined,
                        color: Color(0xff000033),
                      ),
                    ),
                    Container(
                      width: width - 50,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.info,
                            color: Color(0xff000033),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                chaletDescription == null
                                    ? 'This upscale, contemporary chalets is 2km from Hazrat Shahjalal Airport and 11 fromJatiyo Bhaban,the Bangla deshParliamentcomplex.'
                                    : chaletDescription!,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                maxLines: 5,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: MainButton(
                            borderRadius: 11,
                            onpressed: onpressedB1!,
                            width: width / 2 - 50,
                            buttonText: 'Accept',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 30),
                          child: SecondButton(
                            isMainColor: true,
                            borderRadius: 11,
                            onpressed: onpressedB2!,
                            width: width / 2 - 50,
                            buttonText: 'Reject',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
