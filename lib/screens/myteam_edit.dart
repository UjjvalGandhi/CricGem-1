import 'dart:convert';
import 'package:batting_app/screens/point_systum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/TeamEditModel.dart';
import '../model/totalplayerpointmodal.dart';
import '../widget/appbartext.dart';
import '../widget/normaltext.dart';

class MyTeamEdit extends StatefulWidget {
  final String? teamId;
  final bool? isScoreboardTeam;
  final bool? isJoinContest;
  final String? appId;
  final String matchName;
  final String? matchId;
  const MyTeamEdit({
    super.key,
    this.teamId,
    this.isScoreboardTeam = false,
    this.isJoinContest = false,
    this.appId,
    this.matchId,
    required this.matchName,
  });

  @override
  State<MyTeamEdit> createState() => _MyTeamEditState();
}

class _MyTeamEditState extends State<MyTeamEdit> {
  late Future<EditTeamModel?> _futureTeamData;
  List<Player> wicketKeepers = [];
  List<Player> batsmen = [];
  List<Player> allRounders = [];
  List<Player> bowlers = [];
  List<Player> players = [];
  var captainId;
  var vicecaptainId;
  String? userName;
  var playerpointsdetails;
  String? team1ShortName;
  String? team2ShortName;
  int team1PlayerCount = 0;
  int team2PlayerCount = 0;
  Map<String, int> playerPointsMap = {};
  Map<String, String?> playercaptainmap = {};
  String _getMatchNamePart(String matchName) {
    List<String> parts = matchName.split(' ');
    if (parts.length > 2) {
      return parts[2];
    } else {
      return "N/A"; // Or handle it appropriately
    }
  }

  @override
  void initState() {
    super.initState();
    _futureTeamData = _fetchData(); // Initialize here
  }

  Future<EditTeamModel?> _fetchData() async {
    final teamData = await contestDisplay(); // Fetch team data
    await playerTotalPoints(); // Fetch player points after team data is fetched
    return teamData; // Return the team data
  }

  Future<EditTeamModel?> contestDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      if (token == null) {
        debugPrint('Token is null');
        return null;
      }

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/myTeam/displayDetails?myTeamId=${widget.teamId}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('my team id ${widget.teamId}');
        if (jsonData['success'] != null && jsonData['success'] == true) {
          final data = EditTeamModel.fromJson(jsonData);
          setState(() {
            players = data.data.players;
            userName = data.data.userDetails.isNotEmpty
                ? data.data.userDetails[0].name
                : 'N/A';
            team1ShortName = data.data.team1.shortName;
            team2ShortName = data.data.team2.shortName;
            team1PlayerCount = data.data.team1PlayerCount;
            team2PlayerCount = data.data.team2PlayerCount;
            captainId =
                data.data.captain; // Assuming you have a variable to store this
            vicecaptainId = data.data.viceCaptain;
            wicketKeepers.clear();
            batsmen.clear();
            allRounders.clear();
            bowlers.clear();

            for (var player in players) {
              switch (player.role) {
                case 'Wicket Keeper':
                  wicketKeepers.add(player);
                  break;
                case 'Batsman':
                  batsmen.add(player);
                  break;
                case 'All Rounder':
                  allRounders.add(player);
                  break;
                case 'Bowler':
                  bowlers.add(player);
                  break;
                default:
                  break;
              }
            }
          });
          return data;
        } else {
          debugPrint('Failed to fetch contest data: ${response.body}');
          return null;
        }
      } else {
        debugPrint('Failed to fetch contest data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching contest data: $e');
      return null;
    }
  }

  Future<PointsResponse?> playerTotalPoints() async {
    try {
      String? token = await AppDB.appDB.getToken();
      print('Team id is :-        .............${widget.teamId}');
      final response = await http.get(
        // Uri.parse(
        //     "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.matchId}"),
        Uri.parse(
            "https://batting-api-1.onrender.com/api/playerpoints/playerPointByTeam?myteamId=${widget.teamId}"),

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        final data = PointsResponse.fromJson(jsonData);
        print('response body of points:- ${response.body}');
        for (var playerPointsData in data.data) {
          for (var playerPoint in playerPointsData.players) {
            playerPointsMap[playerPoint.playerId] = playerPoint.points.toInt();
          }
        }
        var playerpointsdetails = data;

        // Rebuild the UI after fetching player points
        setState(() {
          playerPointsMap;
          players;
          playerpointsdetails;
        });

        return data;
      } else {
        debugPrint('Failed to fetch team data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}'); // Log the response body
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching team data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("this is use in my team edit ::${widget.teamId}");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            104.0.h), // Adjustable height based on device screen
        child: ClipRRect(
          child: AppBar(
            surfaceTintColor: const Color(0xff140B40),
            backgroundColor: const Color(0xff140B40),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            // leading: InkWell(
            //   onTap: () {
            //     if (widget.isScoreboardTeam!) {
            //       Navigator.pop(context, 'ScoreCardScreen');
            //     } else {
            //       Navigator.pop(context);
            //     }
            //   },
            //   child: const Icon(Icons.keyboard_backspace, color: Colors.white),
            // ),
            flexibleSpace: Container(
              // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04), // Dynamic horizontal padding
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff140B40),
              ),
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.05), // Adjustable top spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.isScoreboardTeam!) {
                            Navigator.pop(context, 'ScoreCardScreen');
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(Icons.keyboard_backspace,
                            color: Colors.white),
                      ),
                      AppBarText(
                        color: Colors.white,
                        text: "${widget.appId}",
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PointSystumScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              width: MediaQuery.of(context).size.height * 0.025,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 0.5, color: Colors.white),
                              ),
                              child: const Center(
                                child: Text(
                                  "P",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Divider(height: 1, color: Colors.grey.shade300),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.05, // Adjustable height for the row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Players",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9,
                                  color: Color(0xff777777),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "11", // Example player count
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "/11",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                width:
                                    MediaQuery.of(context).size.height * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    team1ShortName ?? " ",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: Center(
                                  child: Text(
                                    '$team1PlayerCount',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                                width: 3,
                                child: Center(
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: Center(
                                  child: Text(
                                    '$team2PlayerCount',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                width:
                                    MediaQuery.of(context).size.height * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    team2ShortName ?? " ",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                "Credits Left",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9,
                                  color: Color(0xff777777),
                                ),
                              ),
                              Text(
                                "9.5",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            // height: 690,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/groundmain.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: FutureBuilder<EditTeamModel?>(
              future: _futureTeamData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No data found'));
                } else {
                  return Center(
                    child: Column(
                      children: [
                        if (wicketKeepers.isNotEmpty)
                          _buildPlayerGroup("Wicket Keepers", wicketKeepers),
                        if (batsmen.isNotEmpty)
                          _buildPlayerGroup("Batsmen", batsmen),
                        if (allRounders.isNotEmpty)
                          _buildPlayerGroup("All Rounder", allRounders),
                        if (bowlers.isNotEmpty)
                          _buildPlayerGroup("Bowlers", bowlers),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                NormalText(
                    color: Colors.white, text: widget.matchName.split(' ')[0]),
                const SizedBox(width: 5),
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                NormalText(
                    color: Colors.white,
                    text: _getMatchNamePart(widget.matchName)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerGroup(String title, List<Player> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize
          .min, // Prevents the column from taking more space than needed
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: _calculateHeight(players.length),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(players.length),
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: _calculateAspectRatio(players.length),
                  ),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return _buildPlayerCard(players[index]);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateHeight(int playerCount) {
    if (playerCount == 1) {
      return 90.0;
    } else if (playerCount <= 2) {
      return 99.0;
    } else if (playerCount <= 3) {
      return 100.0;
    } else if (playerCount <= 4) {
      return 125.0;
    } else {
      return 190.0;
    }
  }

  int _calculateCrossAxisCount(int playerCount) {
    return playerCount < 4 ? playerCount : 4;
  }

  double _calculateAspectRatio(int playerCount) {
    if (playerCount == 1) {
      return 3.5;
    } else if (playerCount == 2) {
      return 1.8;
    } else if (playerCount <= 4) {
      return 1;
    } else {
      return 0.9;
    }
  }

  Widget _buildPlayerCard(Player player) {
    final nameParts = player.playerName.split(' ');
    final shortName = nameParts.length > 1
        ? '${nameParts[0][0]} ${nameParts[1]}'
        : player.playerName;

    final points =
        playerPointsMap.containsKey(player.id) ? playerPointsMap[player.id] : 2;

    String captainIndicator = '';
    if (player.id == captainId) {
      captainIndicator = 'C';
    } else if (player.id == vicecaptainId) {
      captainIndicator = 'VC';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    player.playerPhoto ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/dummy_player.png',
                          fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
              if (captainIndicator.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      captainIndicator,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              shortName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.isJoinContest! || widget.isScoreboardTeam!)
            Expanded(
              child: Text(
                '$points Pts',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}



// Fill playerPointsMap
// for (var playerPointsData in data.data) {
//   for (var playerPoint in playerPointsData.players.first.points) {
//     playerPointsMap[playerPoint.playerId] = playerPoint.points.toInt();
//   }
// }

// Widget _buildPlayerGroup(String title, List<Player> players) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.center,
//     mainAxisSize: MainAxisSize.min, // Prevents the column from taking more space than needed
//     children: [
//       const SizedBox(height: 5),
//       Center(
//         child: Text(
//           title,
//           style: const TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       const SizedBox(
//         height: 3,
//       ),
//
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal:20),
//         child: Center(
//           child: Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               // height: 170.h,
//               height: players.length == 2 ? 125.h : (players.length > 4 ? 125.h : 100.h),
//               // height: players.length >= 4 ? 100 : 125,
//               // height: players.length < 3 ? 100 : 125, // Adjust height based on player count
//
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 // scrollDirection: Axis.vertical,
//                 physics: const NeverScrollableScrollPhysics( ),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   // crossAxisCount: 3,
//                   // crossAxisCount: (players.length < 3) ? players.length : 3, // Adjust based on player count
//                   // // crossAxisSpacing: 22,
//                   // // mainAxisSpacing: 25,
//                   // crossAxisSpacing: 1,
//                   // mainAxisSpacing: 1,
//                   // childAspectRatio: 1.90,
//                   crossAxisCount: (players.length < 4) ? players.length : 4, // Adjust based on player count
//                   crossAxisSpacing: 1,
//                   mainAxisSpacing: 1,
//                   // childAspectRatio: 1.40,
//                   childAspectRatio: players.length == 1 ? 2 : 1.00, // Set aspect ratio based on player count
//
//
//                 ),
//                 itemCount: players.length,
//                 itemBuilder: (context, index) {
//                   return _buildPlayerCard(players[index]);
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
// Widget _buildPlayerCard(Player player) {
//   final nameParts = player.playerName.split(' ');
//   final shortName = nameParts.length > 1
//       ? '${nameParts[0][0]} ${nameParts[1]}'
//       : player.playerName;
//
//   // final points = playerPointsMap[player.id] ?? 2; // Default to 0 if not found
//   final points = playerPointsMap.containsKey(player.id)
//       ? playerPointsMap[player.id]
//       : 2;
//
//   String captainIndicator = '';
//   if (player.id == captainId) {
//     captainIndicator = 'C'; // Captain
//   } else if (player.id == vicecaptainId) {
//     captainIndicator = 'VC'; // Vice-captain
//   }
//
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 1),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           alignment: Alignment.topLeft,
//           children: [
//             // Player image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: SizedBox(
//                 height: 45,
//                 width: 50,
//                 child: Image.network(
//                   player.playerPhoto ?? 'https://via.placeholder.com/150',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     // return Image.asset('assets/default_image.png', fit: BoxFit.cover);
//                     return Image.asset('assets/dummy_player.png', fit: BoxFit.cover);
//
//                   },
//                 ),
//               ),
//             ),
//             // Captain/Vice-captain indicator
//             if (captainIndicator.isNotEmpty)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Text(
//                     captainIndicator,
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               )
//           ],
//         ),
//         // const SizedBox(height: 5),
//         // Player name
//         Container(
//           width: 70,
//           padding: const EdgeInsets.symmetric(vertical: 2),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(2),
//           ),
//           child: Text(
//             shortName,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 10,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         // const SizedBox(height: 5),
//         // Points
//         if(widget.isJoinContest! || widget.isScoreboardTeam!)
//         Expanded(
//           child: Text(
//             '$points Pts',
//             style: const TextStyle(
//               fontSize: 10,
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// appBar: PreferredSize(
//   preferredSize:  Size.fromHeight(99.0.h),
//   child: ClipRRect(
//     child: AppBar(
//       surfaceTintColor: const Color(0xff140B40),
//       backgroundColor: const Color(0xff140B40),
//       // Custom background color
//       elevation: 0,
//       // Remove shadow
//       centerTitle: true,
//       leading: InkWell(
//         onTap: () {
//           if(widget.isScoreboardTeam!){
//             print('screen number:-${widget.isScoreboardTeam}');
//             Navigator.pop(context,'ScoreCardScreen');
//           }else{
//             Navigator.pop(context);
//           }
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const ()),
//           // );
//         },
//         child: const Icon(Icons.keyboard_backspace, color: Colors.white),
//       ),
//       flexibleSpace: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         //height: 164,
//         width: MediaQuery.of(context).size.width,
//         decoration: const BoxDecoration(
//           color: Color(0xff140B40),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 45,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 35, top: 5),
//                   child: AppBarText(
//                       color: Colors.white, text: "${widget.appId}"),
//                 ),
//                 Row(
//                   children: [
//
//                     const SizedBox(
//                       width: 10,
//                     ),
//
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   const PointSystumScreen(),
//                             ));
//                       },
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                                 width: 0.5, color: Colors.white)),
//                         child: const Center(
//                           child: Text(
//                             "P",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Divider(
//               height: 1,
//               color: Colors.grey.shade300,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 36,
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const SizedBox(
//                     height: 36,
//                     width: 52,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 1),
//                         Text(
//                           "Players",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 9,
//                               color: Color(0xff777777)),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "11",
//                               //"${players.length}",
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                             Text(
//                               "/11",
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.white),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 23,
//                     width: 123,
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 23,
//                           width: 35,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                   width: 1, color: Colors.white)),
//                       child: Center(
//                           child: Text(
//                             team1ShortName ?? " ",
//                             style: const TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.white),
//                           )),
//                         ),
//                         SizedBox(
//                           height: 19,
//                           width: 24,
//                           child: Center(
//                             child: Text(
//                               '$team1PlayerCount',
//                               style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                           width: 3,
//                           child: Center(
//                             child: Text(
//                               ":",
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 19,
//                           width: 19,
//                           child: Center(
//                             child: Text(
//                               '$team2PlayerCount ',
//                               style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 23,
//                           width: 35,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                   width: 1, color: Colors.white)),
//                           child: Center(
//                               child: Text(
//                                 team2ShortName ?? " ",
//                                 style: const TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.white),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 32,
//                     width: 60,
//                     child: Column(
//                       children: [
//                         Text(
//                           "Credits Left",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 9,
//                               color: Color(0xff777777)),
//                         ),
//                         Text(
//                           "9.5",
//                           style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ),
// ),

// PopScope(
// canPop: false,
// onPopInvokedWithResult: (didPop, result) async {
// // Navigate to the login page when the back button is pressed
// Navigator.of(context).pushAndRemoveUntil(
// MaterialPageRoute(builder: (context) => IndVsSaScreens()), // Replace with your actual login page
// (Route<dynamic> route) => false,
// );
//
// // Return `true` if you want to indicate that the pop was handled manually.
// // return true;
// },

// Future<EditTeamModel?> contestDisplay() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     if (token == null) {
//       debugPrint('Token is null');
//       return null;
//     }
//
//     // Validate teamId
//     if (widget.teamId == null || widget.teamId!.isEmpty) {
//       debugPrint('Team ID is null or empty');
//       return null;
//     }
//
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/myTeam/displayDetails?myTeamId=${widget.teamId}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": token,
//       },
//     );
//
//     debugPrint('Response status code: ${response.statusCode}');
//     debugPrint('Response body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final dynamic jsonData = jsonDecode(response.body);
//       if (jsonData['success'] != null && jsonData['success'] == true) {
//         final data = EditTeamModel.fromJson(jsonData);
//         setState(() {
//                     players = data.data.players;
//                     userName = data.data.userDetails.isNotEmpty ? data.data.userDetails[0].name : 'N/A';
//                     team1ShortName = data.data.team1.shortName;
//                     team2ShortName = data.data.team2.shortName;
//                     team1PlayerCount = data.data.team1PlayerCount;
//                     team2PlayerCount = data.data.team2PlayerCount;
//                     captainId = data.data.captain; // Assuming you have a variable to store this
//                     vicecaptainId = data.data.viceCaptain;
//                     wicketKeepers.clear();
//                     batsmen.clear();
//                     allRounders.clear();
//                     bowlers.clear();
//
//                     players.forEach((player) {
//                       switch (player.role) {
//                         case 'Wicket Keeper':
//                           wicketKeepers.add(player);
//                           break;
//                         case 'Batsman':
//                           batsmen.add(player);
//                           break;
//                         case 'All Rounder':
//                           allRounders.add(player);
//                           break;
//                         case 'Bowler':
//                           bowlers.add(player);
//                           break;
//                         default:
//                           break;
//                       }
//                     });
//                   });
//         // Handle data...
//         return data;
//       } else {
//         debugPrint('Failed to fetch contest data: ${jsonData['error'] ?? 'Unknown error'}');
//         return null;
//       }
//     } else {
//       debugPrint('Failed to fetch contest data: ${response.statusCode}');
//       debugPrint('Response body: ${response.body}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching contest data: $e');
//     return null;
//   }
// }
// Future<PointsResponse?> playerTotalPoints() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse(
//           "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.matchId}"),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final dynamic jsonData = jsonDecode(response.body);
//       final data = PointsResponse.fromJson(jsonData);
//
//       // Fill playerPointsMap
//       for (var playerPointsData in data.data) {
//         for (var playerPoint in playerPointsData.playerPoints) {
//           playerPointsMap[playerPoint.playerId] = playerPoint.points;
//           print("player point is added:- ${playerPoint.points}");
//         }
//       }
//
//
//       // Rebuild the UI after fetching player points
//       setState(() {playerPointsMap;});
//
//       return data;
//     } else {
//       debugPrint('Failed to fetch team data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching team data: $e');
//     return null;
//   }
// }

// _futureTeamData = contestDisplay();
// playerTotalPoints();
// _futureTeamData = contestDisplay().then((_) {
//   // Once team data is fetched, fetch player points
//   return playerTotalPoints();
// });
// Future<PointsResponse?> playerTotalPoints() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse(
//           "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.matchId}"),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // var data = response.body;
//       final dynamic jsonData = jsonDecode(response.body);
//       print('my matchv : ${widget.matchId}');
//       print("this is respons of My team List ::${response.body}");
//
//       final data = PointsResponse.fromJson(jsonData);
//       // totalpoints = data.data;
//
//       // setState(() {
//       //   if (data.data.isNotEmpty) {
//       //     // Assuming data.data is a List<PlayerPointsData>
//       //     totalpoints = data.data[0].totalPoints; // Get totalPoints from the first item
//       //   } else {
//       //     totalpoints = 0; // Default value if no data
//       //   }
//       //
//       //   pointsStorage.storePoints(totalpoints);
//       //   print('points are showing right or not:- ${totalpoints}');
//       //   totalpoints;
//       // });
//
//       // return PointsResponse.fromJson(jsonDecode(response.body));
//       return data;
//     } else {
//       debugPrint('Failed to fetch team data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching team data: $e');
//     return null;
//   }
// }

// Widget _buildPlayerCard(Player player) {
//   final nameParts = player.playerName.split(' ');
//   final shortName = nameParts.length > 1
//       ? '${nameParts[0][0]}.${nameParts[1]}'
//       : player.playerName;
//   final points = playerPointsMap[player.id] ?? 0; // Default to 0 if not found
//
//   String captainIndicator = '';
//   // String captainIndicator = '';
//   if (player.id == captainId) {
//     captainIndicator = 'C'; // Captain
//   } else if (player.id == vicecaptainId) {
//     captainIndicator = 'VC'; // Vice-captain
//   }
//   // if (player.captainViceCaptain == 'captain') {
//   //   captainIndicator = 'C'; // Captain
//   // } else if (player.captainViceCaptain == 'vicecaptain') {
//   //   captainIndicator = 'VC'; // Vice-captain
//   // }
//   return Center(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Stack to overlay captain/vice-captain indicator on the image
//         Stack(
//           alignment: Alignment.topLeft, // Align the indicator to the top left
//           children: [
//             SizedBox(
//               height: 43,
//               width: 43,
//               child: Image.network(
//                 player.playerPhoto ?? 'https://via.placeholder.com/150', // Use a placeholder image if URL is null
//                 height: 165,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Image.asset('assets/default_image.png', height: 43); // Use a default image if URL fails
//                 },
//               ),
//             ),
//             if (captainIndicator.isNotEmpty) ...[
//               // Show the captain/vice-captain indicator
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: Colors.black54, // Semi-transparent background
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Text(
//                   captainIndicator ?? "0",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.yellow, // Color for captain/vice-captain
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//         // Player short name
//         Container(
//           height: 15.h,
//           width: 70.h,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(2),
//           ),
//           child: Center(
//             child: Text(
//               overflow: TextOverflow.ellipsis,
//               shortName,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         // Show points only if not captain or vice-captain
//         if (captainIndicator.isEmpty) ...[
//           Expanded(
//             child: Text(
//               'Points: $points',
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ],
//     ),
//   );
//   // return Center(
//   //   child: Column(
//   //     crossAxisAlignment: CrossAxisAlignment.center,
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       if (captainIndicator.isNotEmpty) ...[
//   //         // SizedBox(width: 5), // Add space between points and indicator
//   //         Text(
//   //           captainIndicator,
//   //           style: TextStyle(
//   //             fontSize: 10,
//   //             color: Colors.yellow, // Color for captain/vice-captain
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //         ),
//   //       ],
//   //       SizedBox(
//   //           height: 43,
//   //           width: 43,
//   //       child:  Image.network(
//   //           player!.playerPhoto ?? 'https://via.placeholder.com/150', // Use a placeholder image if URL is null
//   //           height: 165,
//   //           errorBuilder: (context, error, stackTrace) {
//   //             return Image.asset('assets/default_image.png', height: 43); // Use a default image if URL fails
//   //           },
//   //         ),
//   //       ),
//   //       Container(
//   //         height: 15.h,
//   //         width: 70.h,
//   //         // width: double.infinity,
//   //         decoration: BoxDecoration(
//   //           color: Colors.white,
//   //           borderRadius: BorderRadius.circular(2),
//   //         ),
//   //         child: Center(
//   //           child: Text(
//   //             overflow: TextOverflow.ellipsis,
//   //             // player.playerName,
//   //             shortName,
//   //             textAlign: TextAlign.center,
//   //             style: TextStyle(
//   //               fontSize: 10,
//   //               color: Colors.black,
//   //               fontWeight: FontWeight.w600,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //       Expanded(
//   //         child: Text(
//   //           'Points: $points',
//   //           style: TextStyle(
//   //             fontSize: 10,
//   //             color: Colors.white,
//   //             fontWeight: FontWeight.w400,
//   //           ),
//   //         ),
//   //       ),
//   //       // Text();
//   //     ],
//   //   ),
//   // );
// }

// const Icon(
//   Icons.edit,
//   color: Colors.white,
//   size: 18,
// ),
// Image.asset(
//   'assets/share_app.png',
//   height: 18,
//   color: Colors.white,
// ),
// child: Image.asset(
//   "assets/kohli.png",
//   fit: BoxFit.cover,
// ) ,

// class _MyTeamEditState extends State<MyTeamEdit> {
//   late Future<EditTeamModel?> _futureTeamData;
//   List<Player> wicketKeepers = [];
//   List<Player> batsmen = [];
//   List<Player> allRounders = [];
//   List<Player> bowlers = [];
//   List<Player> players = [];
//
//   String _getMatchNamePart(String matchName) {
//     List<String> parts = matchName.split(' ');
//     if (parts.length > 2) {
//       return parts[2];
//     } else {
//       // Return a default value or handle the error case as needed
//       return "N/A"; // Or handle it appropriately
//     }
//   }