import 'package:batting_app/screens/create_team.dart';
import 'package:batting_app/screens/ind_vs_sa_screen.dart';
import 'package:batting_app/screens/point_systum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../db/app_db.dart';
import '../model/PlayerModel.dart';
import '../widget/appbartext.dart';
import '../widget/notification_service.dart';
import '../widget/notificationprovider.dart';
import '../widget/small3.dart';
import 'content_inside screen.dart';
import 'contestScreenList.dart';
import 'myteam_details.dart';

class CreateTeamNext extends StatefulWidget {
  final List<Player> selectedPlayers;
  final List<SelectedPlayer> selectedPlayersWithTeams;
  final String? Id;
  final String? matchName;
  final int? point;
  final String? time;
  final String? team1;
  final bool isFromMyTeam;
  final bool isFromContestScreen;
  final bool isFromJoinContest;

  final String? team2;
  final String? amount;
  final String? firstMatch;
  final String? secMatch;
  final String? cId;
  final List<String>? currentuserteamids;

  const CreateTeamNext(
      {super.key,
      required this.selectedPlayers,
      this.isFromMyTeam = false,
      this.isFromContestScreen = false,
      this.isFromJoinContest = false,
      this.point,
      this.cId,
      this.amount,
      this.currentuserteamids,
      this.firstMatch,
      this.secMatch,
      required this.Id,
      this.matchName,
      required this.selectedPlayersWithTeams,
      this.time,
      this.team1,
      this.team2});

  @override
  State<CreateTeamNext> createState() => _CreateTeamNextState();
}

class _CreateTeamNextState extends State<CreateTeamNext> {
  Player? selectedCaptain;
  Player? selectedViceCaptain;
  SelectedPlayer? teamname;
  bool _isLoading = false;

  Future<void> saveTeam() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    String? token = await AppDB.appDB.getToken();
    debugPrint('Token: $token');

    if (selectedCaptain == null || selectedViceCaptain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Captain and Vice-Captain are not selected"),
        ),
      );
      setState(() {
        _isLoading = false; // Stop loading
      });
      return;
    }
    if (widget.selectedPlayers.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must select exactly 11 players"),
        ),
      );
      setState(() {
        _isLoading = false; // Stop loading
      });
      return;
    }
    const String url = 'https://batting-api-1.onrender.com/api/myTeam/my_team';
    final String matchId = widget.Id ?? '6666b2d58e0433350b4b28c8';
    final List<String?> playerIds =
        widget.selectedPlayers.map((player) => player.id).toList();
    final Map<String, dynamic> data = {
      'match_id': matchId,
      'players': playerIds,
      'captain': selectedCaptain!.id,
      'vicecaptain': selectedViceCaptain!.id,
      'date_time': DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
        body: jsonEncode(data),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text("Create Team Successfully")),
          ),
        );
        // Navigator.pushReplacement(context,MaterialPageRoute(
        //   builder: (context) =>  IndVsSaScreens(Id: widget.Id, matchName: widget.matchName),
        // ) );
        final notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);
        await notificationProvider.fetchNotifications();

        // Check if notifications are available
        if (notificationProvider.notifications.isNotEmpty) {
          final notification = notificationProvider.notifications.last;

          // Show notification using NotificationService
          NotificationService().showNotification(
            title: notification['title'] ?? 'No Title',
            body: notification['message'] ?? 'No Message',
          );
        } else {
          // Show fallback notification if no notifications are available
          NotificationService().showNotification(
            title: 'Team created',
            body: 'Team created successfully!',
          );
        }
        if (widget.isFromMyTeam) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ContestMatchList(
                iscreatematch: true,
                firstmatch: "${widget.firstMatch}",
                secMatch: "${widget.secMatch}",
                matchName: "${widget.matchName}",
                cId: "${widget.cId}",
                Id: "${widget.Id}",
                amount: "${widget.amount}",
                // currentUserTeamIds: displayedTeamIds.map((teamId) => teamId.split('(')[0]).toList(), // Extracting team ID before '('
                currentUserTeamIds: widget.currentuserteamids!
                    .map((teamId) => teamId.split('(')[0])
                    .toList(), // Extracting team ID before '('

                // currentUserTeamIds: displayedTeamIds.toList(),
              ),
            ),
            (route) => false, // Removes all previous routes.
          );
        } else if (widget.isFromJoinContest) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ContentInside(
                isCreateTeam: true,
                time: widget.time,
                CId: widget.cId,
                matchName: widget.matchName,
                Id: widget.Id,
              ),
            ),
            (route) => false, // Removes all previous routes.
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => IndVsSaScreens(
                  IsCreateTeamScreen: true,
                  Id: widget.Id,
                  matchName: widget.matchName),
            ),
            (route) => false, // Removes all previous routes.
          );
        }

        setState(() {
          _isLoading = false; // Stop loading
        });
      } else {
        debugPrint("Error: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Center(child: Text("Failed to Create team: ${response.body}")),
          ),
        );
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      debugPrint("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred"),
        ),
      );
      setState(() {
        _isLoading = false; // Stop loading
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  String getRoleAbbreviation(String? role) {
    switch (role) {
      case 'Wicket Keeper':
        return 'wk';
      case 'All Rounder':
        return 'ar';
      case 'Batsman':
        return 'bat';
      case 'Bowler':
        return 'bowl';
      default:
        return role ?? ''; // Return the original role if it doesn't match
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 280,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/log_pop.png',
                  height: 70,
                  color: const Color(0xff140B40),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Are You Want",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "To Discard The Team?",
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('open the pop up111111111111');
                          print('time:- ${widget.time}');
                          print('contestId:- ${widget.cId}');
                          print('match name is:- ${widget.matchName}');
                          print('id is:- ${widget.Id}');
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         ContentInside(
                          //           isCreateTeam: true,
                          //           time: widget.time,
                          //           CId: widget.cId,
                          //           matchName: widget.matchName,
                          //           Id: widget.Id,
                          //         ),
                          //         // IndVsSaScreens(
                          //         // IsCreateTeamScreen: true,
                          //         // Id: widget.Id,
                          //         // matchName: widget.matchName),
                          //   ),
                          //       (route) => false, // Removes all previous routes.
                          // );
                          if (widget.isFromMyTeam) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContestMatchList(
                                  iscreatematch: true,
                                  firstmatch: "${widget.firstMatch}",
                                  secMatch: "${widget.secMatch}",
                                  matchName: "${widget.matchName}",
                                  cId: "${widget.cId}",
                                  Id: "${widget.Id}",
                                  amount: "${widget.amount}",
                                  // currentUserTeamIds: displayedTeamIds.map((teamId) => teamId.split('(')[0]).toList(), // Extracting team ID before '('
                                  currentUserTeamIds: widget.currentuserteamids!
                                      .map((teamId) => teamId.split('(')[0])
                                      .toList(), // Extracting team ID before '('

                                  // currentUserTeamIds: displayedTeamIds.toList(),
                                ),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          } else if (widget.isFromJoinContest) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentInside(
                                  isCreateTeam: true,
                                  time: widget.time,
                                  CId: widget.cId,
                                  matchName: widget.matchName,
                                  Id: widget.Id,
                                ),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndVsSaScreens(
                                    IsCreateTeamScreen: true,
                                    Id: widget.Id,
                                    matchName: widget.matchName),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff010101).withOpacity(0.35),
                          ),
                          child: const Center(
                            child: Text(
                              "Discard",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('open the pop up 222222222222222');

                          Navigator.of(context).pop(false); // User pressed No
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff140B40),
                          ),
                          child: const Center(
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    debugPrint("Id: ${widget.Id}");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ClipRRect(
          child: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PointSystumScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 0.8, color: Colors.white),
                    ),
                    child: const Center(
                      child: Center(
                        child: Text(
                          "P",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            surfaceTintColor: const Color(0xff140B40),
            backgroundColor: const Color(0xff140B40),
            elevation: 0,
            leading: InkWell(
              onTap: () async {
                // await _showExitConfirmationDialog(context);
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xff140B40)),
              child: Column(
                children: [
                  const SizedBox(height: 42),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                AppBarText(
                                    color: Colors.white, text: "Create Team"),
                                Small3Text(
                                  color:
                                      const Color(0xffFFFFFF).withOpacity(0.6),
                                  text: widget.time!,
                                  // text: "4h 5m left"
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // body: Container(
      //   color: const Color(0xffF0F1F5),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Container(
      //         height: 50,
      //         width: MediaQuery.of(context).size.width / 1,
      //         padding: const EdgeInsets.only(left: 20, right: 15, top: 1),
      //         decoration: BoxDecoration(
      //           border: Border.all(width: 1, color: Colors.grey.shade300),
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Row(
      //               children: [
      //                 SizedBox(
      //                   height: 20,
      //                   width: MediaQuery.of(context).size.width / 5.5,
      //                   // width: 73,
      //                   child: const Row(
      //                     children: [
      //                       Text(
      //                         "TYPE",
      //                         style:
      //                             TextStyle(fontSize: 13, color: Colors.grey),
      //                       ),
      //                       SizedBox(width: 5),
      //                       Padding(
      //                         padding: EdgeInsets.only(top: 2),
      //                         child: Icon(
      //                           Icons.arrow_downward,
      //                           size: 13,
      //                           color: Colors.grey,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 20,
      //                   width: 53,
      //                   child: Text(
      //                     "POINTS",
      //                     style: TextStyle(fontSize: 13, color: Colors.grey),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const Align(
      //               alignment: Alignment.center,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   SizedBox(
      //                     height: 20,
      //                     width: 70,
      //                     child: Center(
      //                       child: Text(
      //                         "%C BY",
      //                         style:
      //                             TextStyle(fontSize: 13, color: Colors.grey),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 20,
      //                     width: 65,
      //                     child: Center(
      //                       child: Text(
      //                         "%VC BY",
      //                         style:
      //                             TextStyle(fontSize: 13, color: Colors.grey),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: widget.selectedPlayers.length,
      //           // shrinkWrap: true,
      //           itemBuilder: (context, index) {
      //             Player player = widget.selectedPlayers[index];
      //             // SelectedPlayer selectedPlayerWithTeam = widget.selectedPlayersWithTeams[0];
      //             bool isCaptain = selectedCaptain == player;
      //             bool isViceCaptain = selectedViceCaptain == player;
      //             final nameParts = player.playerName.split(' ');
      //             final shortName = nameParts.length > 1
      //                 ? '${nameParts[0][0]} ${nameParts[1]}'
      //                 : player.playerName;
      //
      //             return Align(
      //               alignment: Alignment.center,
      //               child: Container(
      //                 height: 70,
      //                 width: MediaQuery.of(context).size.width,
      //                 padding: const EdgeInsets.only(left: 20, right: 13),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     SizedBox(
      //                       height: 70,
      //                       width: MediaQuery.of(context).size.width / 1.87,
      //                       // width: 196,
      //                       child: Row(
      //                         children: [
      //                           SizedBox(
      //                             height: 54,
      //                             width: 44,
      //                             child: Column(
      //                               children: [
      //                                 SizedBox(
      //                                   height: 44,
      //                                   width: 44,
      //                                   child: Image.network(
      //                                       player.playerPhoto ?? '',
      //                                     errorBuilder: (context, error, stackTrace) {
      //                                       return Image.asset('assets/dummy_player.png');
      //                                     },),
      //                                   // child: Image.asset('assets/kohli.png',
      //                                   //     fit: BoxFit.cover),
      //                                 ),
      //                                 SizedBox(
      //                                   height: 10,
      //                                   width: 44,
      //                                   child: Row(
      //                                     children: [
      //                                       Container(
      //                                         height: 12,
      //                                         width: 22,
      //                                         color: const Color(0xff140B40),
      //                                         child: Center(
      //                                           child: Text(
      //                                             // selectedPlayerWithTeam.teamShortName,
      //                                             // teamname.toString(),
      //                                             player.teamShortName,
      //                                             // "RR",
      //                                             style: const TextStyle(
      //                                                 fontSize: 7,
      //                                                 fontWeight:
      //                                                     FontWeight.w500,
      //                                                 color: Colors.white),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       Container(
      //                                         height: 12,
      //                                         width: 22,
      //                                         color: const Color(0xffD4AF37),
      //                                         child: Center(
      //                                           child: Text(
      //                                             getRoleAbbreviation(
      //                                                 player.role),
      //                                             // Use the abbreviation here
      //
      //                                             // player.role!,
      //                                             // wk as String,
      //                                             // player.role ?? '',
      //
      //                                             // "BAT",
      //                                             style: const TextStyle(
      //                                                 fontSize: 7,
      //                                                 fontWeight:
      //                                                     FontWeight.w500,
      //                                                 color: Colors.white),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           const SizedBox(width: 16),
      //                           SizedBox(
      //                             height: 79,
      //                             width: 132,
      //                             child: Column(
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               mainAxisAlignment: MainAxisAlignment.center,
      //                               children: [
      //                                 Text(
      //                                   // player.playerName??"",
      //                                   shortName ?? '',
      //                                   style: const TextStyle(
      //                                       fontSize: 12,
      //                                       fontWeight: FontWeight.w500),
      //                                 ),
      //                                 Text(
      //                                   "Points : ${player.totalPoints.toString()}",
      //                                   style: const TextStyle(
      //                                       fontSize: 12,
      //                                       fontWeight: FontWeight.w400,
      //                                       color: Colors.grey),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 70,
      //                       width: MediaQuery.of(context).size.width / 2.8,
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.end,
      //                         children: [
      //                           GestureDetector(
      //                             onTap: () {
      //                               setState(() {
      //                                 if (isCaptain) {
      //                                   selectedCaptain = null;
      //                                 } else {
      //                                   selectedCaptain = player;
      //                                   if (selectedViceCaptain == player) {
      //                                     selectedViceCaptain = null;
      //                                   }
      //                                 }
      //                               });
      //                             },
      //                             child: Align(
      //                               alignment: Alignment.center,
      //                               child: SizedBox(
      //                                 height: 59,
      //                                 width: 80,
      //                                 child: Column(
      //                                   children: [
      //                                     Container(
      //                                       height: 36,
      //                                       width: 36,
      //                                       decoration: BoxDecoration(
      //                                         color: isCaptain
      //                                             ? const Color(0xff140B40)
      //                                             : Colors.transparent,
      //                                         borderRadius:
      //                                             BorderRadius.circular(18),
      //                                         border: isCaptain
      //                                             ? null
      //                                             : Border.all(
      //                                                 width: 1,
      //                                                 color: Colors.grey),
      //                                       ),
      //                                       child: Center(
      //                                         child: Text(
      //                                           "C",
      //                                           style: TextStyle(
      //                                             fontSize: 13,
      //                                             fontWeight: FontWeight.w400,
      //                                             color: isCaptain
      //                                                 ? Colors.white
      //                                                 : Colors.grey,
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     const SizedBox(height: 3),
      //                                     const Text(
      //                                       "2X",
      //                                       style: TextStyle(
      //                                           fontSize: 11,
      //                                           fontWeight: FontWeight.w400,
      //                                           color: Colors.grey),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                           GestureDetector(
      //                             onTap: () {
      //                               setState(() {
      //                                 if (isViceCaptain) {
      //                                   selectedViceCaptain = null;
      //                                 } else {
      //                                   selectedViceCaptain = player;
      //                                   if (selectedCaptain == player) {
      //                                     selectedCaptain = null;
      //                                   }
      //                                 }
      //                               });
      //                             },
      //                             child: Align(
      //                               alignment: Alignment.center,
      //                               child: SizedBox(
      //                                 height: 59,
      //                                 width: 48,
      //                                 child: Column(
      //                                   children: [
      //                                     Container(
      //                                       height: 36,
      //                                       width: 36,
      //                                       decoration: BoxDecoration(
      //                                         color: isViceCaptain
      //                                             ? const Color(0xff140B40)
      //                                             : Colors.transparent,
      //                                         borderRadius:
      //                                             BorderRadius.circular(18),
      //                                         border: isViceCaptain
      //                                             ? null
      //                                             : Border.all(
      //                                                 width: 1,
      //                                                 color: Colors.grey),
      //                                       ),
      //                                       child: Center(
      //                                         child: Text(
      //                                           "VC",
      //                                           style: TextStyle(
      //                                             fontSize: 13,
      //                                             fontWeight: FontWeight.w400,
      //                                             color: isViceCaptain
      //                                                 ? Colors.white
      //                                                 : Colors.grey,
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     const SizedBox(height: 3),
      //                                     const Text(
      //                                       "1.5X",
      //                                       style: TextStyle(
      //                                           fontSize: 11,
      //                                           fontWeight: FontWeight.w400,
      //                                           color: Colors.grey),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        color: const Color(0xffF0F1F5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity, // Take full width of the screen
              padding: const EdgeInsets.only(left: 20, right: 15, top: 1),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 5.5,
                        child: const Row(
                          children: [
                            Text(
                              "TYPE",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.arrow_downward,
                                size: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 53,
                        child: Text(
                          "POINTS",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 70,
                          child: Center(
                            child: Text(
                              "%C BY",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 65,
                          child: Center(
                            child: Text(
                              "%VC BY",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedPlayers.length,
                itemBuilder: (context, index) {
                  Player player = widget.selectedPlayers[index];
                  bool isCaptain = selectedCaptain == player;
                  bool isViceCaptain = selectedViceCaptain == player;
                  final nameParts = player.playerName.split(' ');
                  final shortName = nameParts.length > 1
                      ? '${nameParts[0][0]} ${nameParts[1]}'
                      : player.playerName;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Player Info Section
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 54,
                                width: 44,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: Image.network(
                                        player.playerPhoto ?? '',
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/dummy_player.png');
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      width: 44,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 22,
                                            color: const Color(0xff140B40),
                                            child: Center(
                                              child: Text(
                                                player.teamShortName,
                                                style: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 12,
                                            width: 22,
                                            color: const Color(0xffD4AF37),
                                            child: Center(
                                              child: Text(
                                                getRoleAbbreviation(
                                                    player.role),
                                                style: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    shortName ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Points : ${player.totalPoints.toString()}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Captain and Vice-Captain Selection Section
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isCaptain) {
                                      selectedCaptain = null;
                                    } else {
                                      selectedCaptain = player;
                                      if (selectedViceCaptain == player) {
                                        selectedViceCaptain = null;
                                      }
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: isCaptain
                                            ? const Color(0xff140B40)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                        border: isCaptain
                                            ? null
                                            : Border.all(
                                                width: 1, color: Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "C",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: isCaptain
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      "2X",
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isViceCaptain) {
                                      selectedViceCaptain = null;
                                    } else {
                                      selectedViceCaptain = player;
                                      if (selectedCaptain == player) {
                                        selectedCaptain = null;
                                      }
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: isViceCaptain
                                            ? const Color(0xff140B40)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                        border: isViceCaptain
                                            ? null
                                            : Border.all(
                                                width: 1, color: Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "VC",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: isViceCaptain
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      "1.5X",
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 68,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyTeamdetails(
                        selectedPlayers: widget.selectedPlayers,
                        // Pass selected players to the details screen
                        matchName: widget.matchName,
                        teamname1: widget.team1!,
                        teamname2: widget.team2!,
                      ),
                    ));
              },
              child: Container(
                height: 48,
                width: 166,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(width: 1, color: const Color(0xff140B40)),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    "Preview",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff140B40),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (selectedCaptain == null || selectedViceCaptain == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Captain and Vice-Captain are not selected"),
                    ),
                  );
                  return;
                }
                if (selectedCaptain == selectedViceCaptain) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Captain and Vice-Captain cannot be the same player"),
                    ),
                  );
                  return;
                }
                await saveTeam();
              },
              child: Container(
                height: 48,
                width: 166,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: const Color(0xff140B40),
                ),
                child: Center(
                  child: _isLoading // Show loader if loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
