// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nudilk/components/homeChaletPackagesWidget.dart';
// import 'package:nudilk/constants.dart';
// import 'package:nudilk/screens/UserScreen/addReviews.dart';
// import 'package:nudilk/screens/owner/addChalet_screen.dart';
// import 'package:nudilk/screens/owner/updateChalet_Screen.dart';
// import 'package:nudilk/services/fireStore_helper.dart';
// import 'package:provider/provider.dart';
//
// import '../../provider/ChaletsProvider.dart';
// import '../UserScreen/chalet_Screen.dart';
//
// class CommentsAndFeeedback extends StatefulWidget {
//   const CommentsAndFeeedback({Key? key, required this.chaletID}) : super(key: key);
//   final String chaletID;
//
//   @override
//   State<CommentsAndFeeedback> createState() => _CommentsAndFeeedback();
// }
//
// class _CommentsAndFeeedback extends State<CommentsAndFeeedback> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     Provider.of<ChaletsProvider>(context, listen: false).getChaletsComments(widget.chaletID);
//     Provider.of<ChaletsProvider>(context, listen: false).didUserHaveBookedChalets(widget.chaletID);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//
//         appBar: AppBar(
//           leading: SizedBox.shrink(),
//           centerTitle: true,
//           title: const Text('Comments and feedback'),
//           backgroundColor: kMainAppColor,
//         ),
//         floatingActionButton: Container(
//           height: 55,
//           width: 55,
//           decoration: BoxDecoration(
//             color: const Color(0xFF204A76),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: IconButton(
//             onPressed: () {
//               if(Provider.of<ChaletsProvider>(context, listen: false).didUserHaveBookedChalet){
//                 print(Provider.of<ChaletsProvider>(context, listen: false).didUserHaveBookedChalet);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) {
//                       return AddReviewsScreen(chaletID: widget.chaletID);
//                     },
//                   ),
//                 );
//               }
//               else{
//                 Fluttertoast.showToast(
//                     msg: 'You have to book the chalet first, before you give your feedback',
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.CENTER,
//                     timeInSecForIosWeb: 1,
//                     backgroundColor: Colors.green,
//                     textColor: Colors.white,
//                     fontSize: 16.0
//                 );
//               }
//             },
//             icon: const Icon(
//               Icons.add,
//               size: 30,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Consumer<ChaletsProvider>(
//           builder: (context, chaletsProvider, _) =>
//               Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: SizedBox(
//               height: height,
//               child: ListView.builder(
//                 itemCount: chaletsProvider.chaletscomments.length,
//                 itemBuilder: (context, index) {
//                   return  InkWell(
//                     child: Container(
//
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         color: Color(0xfff1f3f6),
//                       ),
//
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.3,
//                             child: MaterialButton(
//                               onPressed: () {
//                                 // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(id:id),));
//                               },
//                               child: Container(
//                                   // height: 50,
//                                   width: MediaQuery.of(context).size.width * 0.3,
//                                   child: const CircleAvatar(
//                                     backgroundImage: AssetImage(
//                                       'assets/images/reviews.png',
//                                     ),
//                               ),
//                             ),
//                            ),
//                           ),
//                           // SizedBox(height: 15,),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child:
//                                   Provider.of<ChaletsProvider>(context).chaletscomments[index].name==null?
//                                   Text(
//                                       "Name : "+"Client ",
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.center,
//                                       maxLines: 1,
//                                       softWrap: false,
//                                       style:
//                                       TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20)
//                                   ):
//                                   Text(
//                                       "Name : "+Provider.of<ChaletsProvider>(context).chaletscomments[index].name!,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.center,
//                                       maxLines: 1,
//                                       softWrap: false,
//                                       style:
//                                       TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20)
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Text("Comment : "+Provider.of<ChaletsProvider>(context).chaletscomments[index].comment!,
//                                       maxLines: 1,
//                                       softWrap: false,
//                                       overflow: TextOverflow.ellipsis,
//                                       style:TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15)
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Text("rating : "+Provider.of<ChaletsProvider>(context).chaletscomments[index].rating.toString()+" ★",
//                                     maxLines: 1,
//                                     softWrap: false,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                         ],
//                       ),
//                     ),
//                     onTap: () {
//                       print("tapped on container");
//
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetail(t: user, couleur: couleur, pic: pic, date: date, message: message, put: put, detailTransaction: detailTransaction,)));
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         )
//     );
//   }
// }
