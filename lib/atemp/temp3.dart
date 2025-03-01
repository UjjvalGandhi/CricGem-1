// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
//
// import '../db/app_db.dart';
// import '../model/PlayerModel.dart';
//
// class CreateTeamScreen extends StatefulWidget {
//   final String? Id;
//
//   const CreateTeamScreen({Key? key, required this.Id}) : super(key: key);
//
//   @override
//   _CreateTeamScreenState createState() => _CreateTeamScreenState();
// }
//
// class _CreateTeamScreenState extends State<CreateTeamScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late Future<PlayerModlel?> _futureData;
//   List<Player> selectedPlayers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _futureData = playerDisplay();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<PlayerModlel?> playerDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/player/getplayers?matchId=666aa645e8cc7f7616ea348e'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = PlayerModlel.fromJson(jsonDecode(response.body));
//         debugPrint('Data: ${data.message}');
//         return data;
//       } else {
//         debugPrint('Failed to fetch contest data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching contest data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<PlayerModlel?>(
//         future: _futureData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No data available'));
//           } else {
//             PlayerModlel? playerModel = snapshot.data;
//             return SingleChildScrollView(
//               physics: NeverScrollableScrollPhysics(),
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Color(0xffF0F1F5),
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           height: 155,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(color: Color(0xff140B40)),
//                           child: Column(
//                             children: [
//                               SizedBox(height: 10),
//                               Text(
//                                 "Maximum 10 players from one team",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Container(
//                                 height: 55,
//                                 width: 353,
//                                 decoration:
//                                 BoxDecoration(color: Color(0xff140B40)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     SizedBox(
//                                       height: 60,
//                                       width: 313,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                         children: List.generate(
//                                           11,
//                                               (index) => Container(
//                                             height: 20,
//                                             width: 20,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.circular(3),
//                                               color: selectedPlayers.length >
//                                                   index
//                                                   ? Colors.white
//                                                   : Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 20,
//                                           width: 20,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                             border:
//                                             Border.all(color: Colors.white),
//                                           ),
//                                           child: const Center(
//                                             child: Icon(
//                                               Icons.remove,
//                                               color: Colors.white,
//                                               size: 16,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 height: 60,
//                                 width: 353,
//                                 padding:
//                                 EdgeInsets.symmetric(horizontal: 15),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     SizedBox(
//                                       height: 50,
//                                       width: 71,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Credits Left",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                           Text(
//                                             "100",
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 44,
//                                       width: 1,
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     SizedBox(
//                                       height: 50,
//                                       width: 80,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 22,
//                                             width: 77,
//                                             child: buildNationalityCount(
//                                                 "India", playerModel),
//                                           ),
//                                           SizedBox(height: 3),
//                                           SizedBox(
//                                             height: 22,
//                                             width: 77,
//                                             child: buildNationalityCount(
//                                                 "South Africa", playerModel),
//                                           ),
//                                           // Add more nationalities as needed
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 44,
//                                       width: 1,
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     SizedBox(
//                                       height: 50,
//                                       width: 71,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Players",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                           Text(
//                                             "${selectedPlayers.length}/11",
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildNationalityCount(String nationality, PlayerModlel? playerModel) {
//     int selectedCount = selectedPlayers
//         .where((player) => player.nationality ==
//         nationality.toLowerCase())
//         .length;
//
//     return Row(
//       children: [
//         SizedBox(
//           width: 20,
//           height: 13,
//           child: Image.asset('assets/${nationality.toLowerCase()}.png'),
//         ),
//         SizedBox(width: 8),
//         Text(
//           nationality,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(width: 3),
//         Text(
//           "-",
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(width: 3),
//         Text(
//           "$selectedCount",
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
