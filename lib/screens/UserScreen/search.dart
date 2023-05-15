import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/popularChaletWidget.dart';
import '../../provider/ChaletsProvider.dart';
import 'chalet_Screen.dart';

class Search extends StatefulWidget {
  static const String id = "Search_screen";
  String? text;
  Search({this.text = ''});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    Provider.of<ChaletsProvider>(context, listen: false).getChalets();
    _textEditingController.text = widget.text!;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(title: Text('search')),
        body: Container(
          width: double.infinity,
          child: Consumer<ChaletsProvider>(
            builder: (context, chaletProvider, _) => chaletProvider
                .chalet.isEmpty
                ? Container(
              width: double.infinity,
              child: Center(
                child: Image.asset('assets/images/emptyBooking.png'),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            chaletProvider.searchChalet = chaletProvider
                                .chalet
                                .where((element) =>
                                element.name!.contains(value))
                                .toList();
                          });
                        },
                        obscureText: false,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Search chalets, Area etc..',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF000000),
                          ),
                          filled: true,
                          contentPadding:
                          EdgeInsets.only(left: 30, top: 30),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Search results"),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _textEditingController.text.isNotEmpty
                            ? chaletProvider.searchChalet.length
                            : chaletProvider.chalet.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return ChaletScreen(
                                      chalet: _textEditingController
                                          .text.isNotEmpty
                                          ? chaletProvider
                                          .searchChalet[index]
                                          : chaletProvider.chalet[index],
                                    );
                                  },
                                ),
                              );
                            },
                            child: PopularChaletWidget(
                              height: height,
                              imageURL: _textEditingController
                                  .text.isNotEmpty
                                  ? chaletProvider
                                  .searchChalet[index].imageURL
                                  : chaletProvider.chalet[index].imageURL,
                              chaletLocation: _textEditingController
                                  .text.isNotEmpty
                                  ? chaletProvider
                                  .searchChalet[index].location
                                  : chaletProvider.chalet[index].location,
                              chaletName:
                              _textEditingController.text.isNotEmpty
                                  ? chaletProvider
                                  .searchChalet[index].name
                                  : chaletProvider.chalet[index].name,
                              price:
                              _textEditingController.text.isNotEmpty
                                  ? chaletProvider
                                  .searchChalet[index].price
                                  : chaletProvider.chalet[index].price,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
