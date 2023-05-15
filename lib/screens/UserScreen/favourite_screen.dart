import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/components/NetworkError.dart';
import 'package:nudilk/constants.dart';
import 'package:nudilk/model/Chalets.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/screens/UserScreen/chalet_Screen.dart';
import 'package:provider/provider.dart';

import '../../components/homeChaletPackagesWidget.dart';

class FavouriteScreen extends StatefulWidget {
  static const String id = "Favourite_screen";

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.email);
    Provider.of<ChaletsProvider>(context, listen: false).getFavChalets();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          centerTitle: true,
          title: Text('Favourite'),
          backgroundColor: kMainAppColor,
        ),
        body: user != null?
        Consumer<ChaletsProvider>(
          builder: (context, chaletProvider, _) => Container(
            width: double.infinity,
            child: chaletProvider.favChalets.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/star.png'),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Your Wish List is empty',
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
                : Container(
              height: height,
              child: ListView.builder(
                itemCount: chaletProvider.favChalets.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return ChaletScreen(
                              chalet: chaletProvider.favChalets[index],
                            );
                          },
                        ),
                      );
                    },
                    child: HomeChaletPackagesWidget(
                      imageURL: chaletProvider.favChalets[index].imageURL,
                      chaletLocation:
                      chaletProvider.favChalets[index].location,
                      chaletName: chaletProvider.favChalets[index].name,
                      price: chaletProvider.favChalets[index].price,
                      description: chaletProvider.favChalets[index].description,
                      isForAdmin: false,
                      onpressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return ChaletScreen();
                        }));
                      },
                      width: width,
                      height: height,
                    ),
                  );
                },
              ),
            ),
          ),
        )
            :
        NetworkError()
    );
  }
}
