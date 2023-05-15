import 'package:flutter/material.dart';
import 'package:nudilk/components/homeChaletPackagesWidget.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/screens/owner/addChalet_screen.dart';
import 'package:nudilk/screens/owner/updateChalet_Screen.dart';
import 'package:nudilk/services/fireStore_helper.dart';
import 'package:provider/provider.dart';

import '../../provider/ChaletsProvider.dart';
import '../UserScreen/chalet_Screen.dart';

class ChaletsListScreen extends StatefulWidget {
  static const String id = "ChaletsList_screen";

  @override
  State<ChaletsListScreen> createState() => _ChaletsListScreenState();
}

class _ChaletsListScreenState extends State<ChaletsListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChaletsProvider>(context, listen: false).getMyChalets();
    //  getBookingInfo
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF204A76),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddChaletScreen.id);
            },
            icon: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          leading: SizedBox.shrink(),
          centerTitle: true,
          title: const Text('Chalets'),
          backgroundColor: kMainAppColor,
        ),
        body: Consumer<ChaletsProvider>(
          builder: (context, chaletsProvider, _) => chaletsProvider
                  .myChalets.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Image.asset('assets/images/emptyBooking.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("You dont have Chalets please add one")
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: height,
                    child: ListView.builder(
                      itemCount: chaletsProvider.myChalets.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return UpdateChaletScreen(
                                    chalet: chaletsProvider.myChalets[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: HomeChaletPackagesWidget(
                            price: chaletsProvider.myChalets[index].price,
                            offer: chaletsProvider.myChalets[index].offer,
                            chaletsStatus:
                            chaletsProvider.myChalets[index].chaletsStatus,
                            imageURL: chaletsProvider.myChalets[index].imageURL,
                            chaletLocation:
                            chaletsProvider.myChalets[index].location,
                            chaletName: chaletsProvider.myChalets[index].name,
                            description: chaletsProvider.myChalets[index].description,
                            dateRange: chaletsProvider.myChalets[index].dateRange,

                            isForBooking: false,
                            isForAdmin: true,
                            onpressed: () {},
                            date: chaletsProvider.myChalets[index].name,
                            width: width,
                            buttonOne: 'Update',
                            buttonTwo: 'Delete',
                            onpressedB1: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return UpdateChaletScreen(
                                      chalet: chaletsProvider.myChalets[index],
                                    );
                                  },
                                ),
                              );
                            },
                            onpressedB2: () async {
                              await FireStoreHelper.fireStoreHelper
                                  .deleteBookingForTheUser(
                                      chaletsProvider.myChalets[index])
                                  .then(
                                    (value) => FireStoreHelper.fireStoreHelper
                                        .deleteChaletsAfterDeletingBookings(
                                            chaletsProvider.myChalets[index]),
                                  )
                                  .then(
                                    (value) => Provider.of<ChaletsProvider>(
                                            context,
                                            listen: false)
                                        .getMyChalets(),
                                  );
                              print('delete');
                            },
                            height: height,
                            fontSize: 10,
                            buttonString: "Delete Booking",
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ));
  }
}
