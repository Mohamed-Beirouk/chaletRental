import 'package:flutter/material.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

class AllRequestAdminChaletsScreen extends StatefulWidget {
  static const String id = "AllRequestAdminChalets_screen";

  @override
  State<AllRequestAdminChaletsScreen> createState() =>
      _AdminChaletsScreenState();
}

class _AdminChaletsScreenState extends State<AllRequestAdminChaletsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Chalets> chaletsList =
        Provider.of<ChaletsProvider>(context).chalet.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('All  New request Chalets'),
        backgroundColor: kMainAppColor,
      ),
      body: chaletsList
                  .where((element) => element.chaletsStatus == false)
                  .length ==
              0
          ? Container(
              width: double.infinity,
              child: Center(
                child: Image.asset('assets/images/emptyBooking.png'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: chaletsList
                    .where((element) => element.chaletsStatus == false)
                    .length,
                itemBuilder: (context, index) {
                  return HomeChaletPackagesWidget(
                    price: chaletsList
                        .where((element) => element.chaletsStatus == false)
                        .toList()[index]
                        .price,
                    description: chaletsList
                        .where((element) => element.chaletsStatus == false)
                        .toList()[index]
                        .description,
                    imageURL: chaletsList
                        .where((element) => element.chaletsStatus == false)
                        .toList()[index]
                        .imageURL,
                    chaletLocation: chaletsList
                        .where((element) => element.chaletsStatus == false)
                        .toList()[index]
                        .location,
                    chaletName: chaletsList
                        .where((element) => element.chaletsStatus == false)
                        .toList()[index]
                        .name,
                    onpressedB1: () {
                      FireStoreHelper.fireStoreHelper
                          .updateChaletsStatus(chaletsList[index], true);
                    },
                    onpressedB2: () {
                      FireStoreHelper.fireStoreHelper
                          .updateChaletsStatus(chaletsList[index], false);
                    },
                    isForBooking: false,
                    isForAdmin: true,
                    onpressed: () {},
                    width: width,
                    height: height,
                    fontSize: 10,
                    buttonString: "Delete Booking",
                  );
                },
              ),
            ),
    );
  }
}
