import 'package:flutter/material.dart';
import 'package:nudilk/constants.dart';

class PopularChaletWidget extends StatelessWidget {
  const PopularChaletWidget({
    Key? key,
    required this.height,
    this.imageURL,
    this.chaletName,
    this.price,
    this.offer,
    this.chaletLocation,
  }) : super(key: key);

  final double height;
  final String? imageURL;
  final String? chaletName;
  final String? chaletLocation;
  final int? price;
  final int? offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0, top: 3, bottom: 3),
      height: height,
      width: 135,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imageURL == null
              ? Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/loginScreen.png'),
                        fit: BoxFit.cover),
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("$imageURL"), fit: BoxFit.cover),
                    color: Colors.cyan,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chaletName == null ? 'Name of Chalet' : '$chaletName',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  chaletLocation == null
                      ? 'Location Of chalet'
                      : '$chaletLocation',
                  style: TextStyle(fontSize: 10, color: Color(0xffC1C1C1)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    price == null
                        ? Text(
                            '\$180/night',
                            style:
                                TextStyle(fontSize: 10, color: kMainAppColor),
                          )
                        : offer!=null&& offer!>0?
                    Text(
                            '\$${price.toString()}/night - \$${offer.toString()}',
                            style:
                                TextStyle(fontSize: 10, color: kMainAppColor),
                          ):
                    Text(
                      '\$${price.toString()}/night',
                      style:
                      TextStyle(fontSize: 10, color: kMainAppColor),
                    ),
                    Text(
                      'rate',
                      style: TextStyle(fontSize: 10, color: kMainAppColor),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
