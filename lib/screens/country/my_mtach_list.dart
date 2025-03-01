// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import '../../db/app_db.dart';
// import '../../model/MyTeamListModel.dart';
// import '../../widget/normal2.0.dart';
//
// import '../myteam_edit.dart';
//
//
// class Myteamlist extends StatefulWidget {
//
//
//   const Myteamlist({Key? key})
//       : super(key: key);
//
//   @override
//   State<Myteamlist> createState() => _MyteamlistState();
// }
//
// class _MyteamlistState extends State<Myteamlist> {
//   late Future<MyTeamLIstModel?> _futureDataTeam;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureDataTeam = matchDisplay();
//   }
//
//   Future<MyTeamLIstModel?> matchDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.MatchID}'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         // print('my matchv : ${widget.MatchID}');
//         print("this is respons of My team List ::${response.body}");
//         return MyTeamLIstModel.fromJson(jsonDecode(response.body));
//       } else {
//         debugPrint('Failed to fetch team data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching team data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("thia id used in my teamlist::${widget.MatchID}");
//     return Scaffold(
//       body: FutureBuilder<MyTeamLIstModel?>(
//         future: _futureDataTeam,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: const Color(0xffF0F1F5),
//                 child: const Center(child: CircularProgressIndicator()));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data?.data.isEmpty == true) {
//             return Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Color(0xffF0F1F5),
//                 child: const Center(child: Text('No teams available')));
//           } else {
//             final myTeamData = snapshot.data!.data;
//             print("this is my team list data ::$myTeamData");
//             return Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               color: const Color(0xffF0F1F5),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Column(
//                       children: myTeamData.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         var team = entry.value;
//                         String lastFourDigits =
//                         team.id.substring(team.id.length - 4);
//                         String teamLabel = 'T${index + 1}';
//                         String appId = "BOSS $lastFourDigits ($teamLabel)";
//                         return Column(
//                           children: [
//                             SizedBox(height: 20),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MyTeamEdit(
//                                       matchId: team.id,
//                                       appId: appId,
//                                       matchName: "${widget.matchName}",
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 children: [
//                                   Stack(
//                                     alignment: Alignment.bottomCenter,
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 15),
//                                         padding: const EdgeInsets.all(15),
//                                         height: 167,
//                                         width:
//                                         MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           border: Border.all(
//                                               color: Colors.grey.shade300),
//                                           borderRadius:
//                                           BorderRadius.circular(20),
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   "BOSS $lastFourDigits ($teamLabel)",
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: (){
//
//                                                   },
//                                                   child: const Icon(Icons.share,
//                                                       size: 18),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 8),
//                                             Divider(
//                                                 height: 1,
//                                                 color: Colors.grey.shade300),
//                                             SizedBox(height: 12),
//                                             Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                               children: [
//                                                 Column(
//                                                   children: [
//                                                     Normal2Text(
//                                                         color: Colors.black,
//                                                         text: "Points"),
//                                                     const Text(
//                                                       "100",
//                                                       style: TextStyle(
//                                                         fontSize: 22,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                         FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Column(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 43,
//                                                       width: 43,
//                                                       child:  Image.network(
//                                                         team.captain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                                         height: 36,
//                                                         errorBuilder: (context, error, stackTrace) {
//                                                           return Image.asset('assets/default_team_image.png', height: 26); // Default image
//                                                         },
//                                                       ),
//                                                       // child: Image.asset(
//                                                       //   'assets/rohilleft.png',
//                                                       //   fit: BoxFit.fill,
//                                                       // ),
//                                                     ),
//                                                     Container(
//                                                       padding:
//                                                       EdgeInsets.symmetric(
//                                                           horizontal: 15,
//                                                           vertical: 2),
//                                                       decoration: BoxDecoration(
//                                                         color: const Color(
//                                                             0xffF0F1F5),
//                                                         borderRadius:
//                                                         BorderRadius
//                                                             .circular(2),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           overflow: TextOverflow.ellipsis,
//                                                           "${team.captain?.playerName ?? ''}",
//                                                           textAlign: TextAlign.center,
//                                                           style: TextStyle(
//                                                             fontSize: 9,
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                             FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Column(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 43,
//                                                       width: 43,
//                                                       child:  Image.network(
//                                                         team.vicecaptain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                                         height: 36,
//                                                         errorBuilder: (context, error, stackTrace) {
//                                                           return Image.asset('assets/default_team_image.png', height: 26); // Default image
//                                                         },
//                                                       ),
//                                                       // child: Image.asset(
//                                                       //   'assets/nzright.png',
//                                                       //   fit: BoxFit.fill,
//                                                       // ),
//                                                     ),
//                                                     Container(
//                                                       padding:
//                                                       EdgeInsets.symmetric(
//                                                           horizontal: 15,
//                                                           vertical: 2),
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         color: const Color(
//                                                             0xffF0F1F5),
//                                                         borderRadius:
//                                                         BorderRadius
//                                                             .circular(2),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           overflow: TextOverflow.ellipsis,
//                                                           team.vicecaptain?.playerName ?? '',
//                                                           style: TextStyle(
//                                                             fontSize: 9,
//                                                             color:
//                                                             Colors.black,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w400,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 15),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 15),
//                                         height: 34,
//                                         width:
//                                         MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xff010101)
//                                               .withOpacity(0.03),
//                                           borderRadius: BorderRadius.only(
//                                             bottomRight: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Normal2Text(
//                                               color: Colors.black,
//                                               text:
//                                               "WK ${team.wicketkeeper ?? ''}",
//                                             ),
//                                             Normal2Text(
//                                               color: Colors.black,
//                                               text: "BAT ${team.batsman ?? ''}",
//                                             ),
//                                             Normal2Text(
//                                               color: Colors.black,
//                                               text:
//                                               "AR ${team.allrounder ?? ''}",
//                                             ),
//                                             Normal2Text(
//                                               color: Colors.black,
//                                               text: "BOWL ${team.bowler ?? ''}",
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     )
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
