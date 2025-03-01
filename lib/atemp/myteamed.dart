// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
//
// import '../db/app_db.dart';
// import '../model/TeamEditModel.dart';
// import '../widget/appbartext.dart';
// import '../widget/normaltext.dart';
//
// class MyTeamEdit extends StatefulWidget {
//   final String? MatchId;
//   final String? appId;
//
//   const MyTeamEdit({Key? key, this.MatchId, this.appId}) : super(key: key);
//
//   @override
//   State<MyTeamEdit> createState() => _MyTeamEditState();
// }
//
// class _MyTeamEditState extends State<MyTeamEdit> {
//   late Future<EditTeamModel?> _futureTeamData;
//   late List<Player> players = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _futureTeamData = contestDisplay();
//   }
//
//   Future<EditTeamModel?> contestDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       // Ensure MatchId is not null before using it in the URL
//       if (widget.MatchId == null) {
//         debugPrint('MatchId is null');
//         return null;
//       }
//
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/myTeam/displayDetails?myTeamId=${widget.MatchId!}'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = EditTeamModel.fromJson(jsonDecode(response.body));
//         debugPrint('Data: ${data.message}');
//         setState(() {
//           players = data.data.players;
//         });
//         return data;
//       } else {
//         debugPrint('Failed to fetch contest data: ${response.statusCode}');
//         debugPrint('Response body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching contest data: $e');
//       return null;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/groundmain.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: FutureBuilder<EditTeamModel?>(
//               future: _futureTeamData,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return const Center(
//                       child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData ||
//                     snapshot.data == null) {
//                   return const Center(child: Text('No data found'));
//                 } else {
//                   return _buildTeamDetails(snapshot.data!);
//                 }
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             child: Container(
//               height: 44,
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     height: 34,
//                     width: 93,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 5,
//                           width: 5,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(3),
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         NormalText(
//                             color: Colors.white, text: "IND"),
//                         SizedBox(width: 5),
//                         Container(
//                           height: 5,
//                           width: 5,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(3),
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         NormalText(
//                             color: Colors.white, text: "NZ"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamDetails(EditTeamModel teamData) {
//     final players = teamData.data.players;
//
//     return Column(
//       children: [
//         _buildPlayerGroup(players.where((player) => player.position == 'Wicket Keeper').toList()),
//         _buildPlayerGroup(players.where((player) => player.position == 'Batsman').toList()),
//         _buildPlayerGroup(players.where((player) => player.position == 'All Rounder').toList()),
//         _buildPlayerGroup(players.where((player) => player.position == 'Bowler').toList()),
//       ],
//     );
//   }
//
//   Widget _buildPlayerGroup(List<Player> players) {
//     return GridView.builder(
//       shrinkWrap: true,
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 15,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: players.length,
//       itemBuilder: (context, index) {
//         return _buildPlayerCard(players[index]);
//       },
//     );
//   }
//
//   Widget _buildPlayerCard(Player player) {
//     return Container(
//       margin: const EdgeInsets.all(15),
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: [
//           SizedBox(
//             height: 74,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 43,
//                   width: 43,
//                   child: Image.asset(
//                     player.playerPhoto,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   height: 16,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                   child: Center(
//                     child: Text(
//                       player.playerName,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (player.isCaptain)
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                       color: Colors.green,
//                       child: Text(
//                         'C',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 if (player.isViceCaptain)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                       color: Colors.blue,
//                       child: Text(
//                         'VC',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// A