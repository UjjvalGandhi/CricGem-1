import 'dart:convert';
import 'package:batting_app/screens/scorecardscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../db/app_db.dart';
import '../model/ContentInsideModel.dart';
import '../model/MatchScoreTestModel.dart';
import '../model/UserMyMatchesModel.dart';
import '../widget/normaltext.dart';
import '../widget/smalltext.dart';
import 'bnb.dart';
import 'complate_match_viewall.dart';
import 'live_matches_viewall.dart';
import 'myMatchesScreen/upcomingviewall_my_matches.dart';
import 'package:http/http.dart' as http;

import 'myteamlist.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    super.key,
  });

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  Future<UserMyMatchesModel?>? _futureData;
  List<Match> LiveMatch = [];
  List<Match> UpcomingMatch = [];
  List<Match> ComplatedMatch = [];
  int _selectedIndex = 0;
  var matchId;
  final _contests = [];
  var currentUserId;
  var contestId;
  Leaderboard? currentUser;
  late Duration remainingTime = Duration.zero;
  late DateTime matchDateTime;

  String adjustMatchTime(String? originalTime) {
    if (originalTime == null || originalTime.isEmpty) {
      return "";
    }
    try {
      List<String> parts = originalTime.split(":");
      int matchHour = int.parse(parts[0]);
      int matchMinute = int.parse(parts[1]);
      DateTime now = DateTime.now();
      int currentHour = now.hour;
      int currentMinute = now.minute;
      int differenceMinutes =
          (matchHour - currentHour) * 60 + (matchMinute - currentMinute);
      int hours = differenceMinutes ~/ 60; // integer division
      int minutes = differenceMinutes % 60;
      String timeStatus = differenceMinutes >= 0 ? "ahead" : "ago";
      return "${hours.abs()}h ${minutes.abs()}m";
    } catch (e) {
      print("Error parsing or adjusting time: $e");
      return "";
    }
  }

  // String formatMegaPrice(int price) {
  //   if (price >= 10000000) {
  //     // 1 crore = 10,000,000
  //     return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
  //   } else if (price >= 100000) {
  //     // 1 lakh = 100,000
  //     return "${(price / 100000).toStringAsFixed(0)} lakh"; // Format to whole number
  //   } else {
  //     return "₹${price.toString()}"; // For values less than 1 lakh
  //   }
  // }
  // String formatMegaPrice(int price) {
  //   if (price >= 10000000) {
  //     // 1 crore = 10,000,000
  //     return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
  //   } else if (price >= 100000) {
  //     // 1 lakh = 100,000
  //     return "${(price / 100000).toStringAsFixed(1)} lakh"; // Format to 1 decimal place
  //   } else {
  //     return "₹${price.toString()}"; // For values less than 1 lakh
  //   }
  // }
  String formatMegaPrice(int price) {
    if (price >= 10000000) {
      // 1 crore = 10,000,000
      double croreValue = price / 10000000;
      return croreValue % 1 == 0
          ? "${croreValue.toStringAsFixed(0)} cr"
          : "${croreValue.toStringAsFixed(1)} cr";
    } else if (price >= 100000) {
      // 1 lakh = 100,000
      double lakhValue = price / 100000;
      return lakhValue % 1 == 0
          ? "${lakhValue.toStringAsFixed(0)} lakh"
          : "${lakhValue.toStringAsFixed(1)} lakh";
    } else {
      return "₹${price.toString()}"; // For values less than 1 lakh
    }
  }

  Color _hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent; // or any default color you prefer
    }

    // Remove the leading '#', if it exists
    hexColor = hexColor.replaceAll('#', '');
    // Parse the string as a hex integer and convert to Color
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  late Future<MatchScoreTestModel?> _FutureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchMatches(); // Initialize _futureData here
  }

  Future<UserMyMatchesModel?> fetchMatches() async {
    print('fetch matches.............');
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/userMatches'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        UserMyMatchesModel matchesModel = UserMyMatchesModel.fromJson(jsonData);

        if (matchesModel.data != null) {
          for (var matchData in matchesModel.data!) {
            if (matchData.completedMatches != null) {
              for (var match in matchData.completedMatches!.matches!) {
                contestId = match.contestId; // Ensure contestId is set
                debugPrint('Contest ID: $contestId');
              }
            }
          }
        }
        return matchesModel;
      } else {
        throw Exception('Failed to load my matches');
      }
    } catch (e) {
      debugPrint('Error fetching My Matches data: $e');
      return null;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureData = fetchMatches(); // Refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Navigate to HomeScreens when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
        return; // Prevent the default back navigation
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffF0F1F5),
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!;
              final liveMatchesData =
                  data.data?[0].liveMatches?.matches?.cast<Match>() ?? [];
              // final scoredata = data.data?[0].liveMatches?.matches?.cast<Match>() ?? [];
              final upcomingMatchesData =
                  data.data?[1].upcomingMatches?.matches?.cast<Match>() ?? [];
              final completedMatchesData =
                  data.data?[2].completedMatches?.matches?.cast<Match>() ?? [];
              LiveMatch = liveMatchesData.isNotEmpty ? liveMatchesData : [];
              // matchId = data.data?[0].liveMatches?.matches![0].id
              UpcomingMatch =
                  upcomingMatchesData.isNotEmpty ? upcomingMatchesData : [];
              ComplatedMatch =
                  completedMatchesData.isNotEmpty ? completedMatchesData : [];

              // DateTime? matchDate;
              // try {
              //   matchDate = DateTime.parse(UpcomingMatch.isNotEmpty
              //       ? data.data![1].upcomingMatches!.matches![0].date ?? ''
              //       : '');
              // } catch (e) {
              //   matchDate = null;
              // }
              // final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
              // String formattedDate =
              //     matchDate != null ? dateFormatter.format(matchDate) : '';
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: LiveMatch.isEmpty &&
                          UpcomingMatch.isEmpty &&
                          ComplatedMatch.isEmpty
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xffF0F1F5),
                    child: SingleChildScrollView(
                      physics: LiveMatch.isEmpty &&
                              UpcomingMatch.isEmpty &&
                              ComplatedMatch.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (LiveMatch.isEmpty &&
                                UpcomingMatch.isEmpty &&
                                ComplatedMatch.isEmpty) ...[
                              const Center(
                                child: Text(
                                  "You Have No Match For Display",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ] else ...[
                              // Live Matches Section
                              // if (LiveMatch.isNotEmpty) ...[
                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       NormalText(color: Colors.black, text: "Live"),
                              //       Row(
                              //         children: [
                              //           InkWell(
                              //             onTap: () {
                              //               Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         const LiveMatchesViewAll()),
                              //               );
                              //             },
                              //             child: SmallText(
                              //                 color: Colors.grey, text: "View All"),
                              //           ),
                              //           const Icon(Icons.arrow_forward_ios,
                              //               size: 18, color: Colors.grey),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              //   const SizedBox(height: 10),
                              //   Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 15, vertical: 15),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20),
                              //       color: Colors.white,
                              //     ),
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           children: [
                              //             SizedBox(
                              //               width: 30,
                              //               height: 30,
                              //               child: Image.network(
                              //                 LiveMatch.isNotEmpty
                              //                     ? data
                              //                             .data![0]
                              //                             .liveMatches!
                              //                             .matches![0]
                              //                             .team1Details
                              //                             ?.logo ??
                              //                         ''
                              //                     : '',
                              //                 height: 100.h,
                              //               ),
                              //             ),
                              //             const SizedBox(width: 8),
                              //             Text(
                              //               LiveMatch.isNotEmpty
                              //                   ? data
                              //                           .data![0]
                              //                           .liveMatches!
                              //                           .matches![0]
                              //                           .team1Details!
                              //                           .shortName ??
                              //                       ''
                              //                   : '',
                              //               style: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //             const Spacer(),
                              //             Text(
                              //               // "210/1 (40)",
                              //               data.data![0].liveMatches!.matches![0].teamScore?.team1?.score ?? '0/0 ( 0 )',
                              //
                              //               style: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         const SizedBox(height: 8),
                              //         Row(
                              //           children: [
                              //             SizedBox(
                              //               width: 30,
                              //               height: 30,
                              //               child: Image.network(
                              //                 LiveMatch.isNotEmpty
                              //                     ? data
                              //                             .data![0]
                              //                             .liveMatches!
                              //                             .matches![0]
                              //                             .team2Details
                              //                             ?.logo ??
                              //                         ''
                              //                     : '',
                              //                 height: 100.h,
                              //               ),
                              //             ),
                              //             const SizedBox(width: 8),
                              //             Text(
                              //               LiveMatch.isNotEmpty
                              //                   ? data
                              //                           .data![0]
                              //                           .liveMatches!
                              //                           .matches![0]
                              //                           .team2Details!
                              //                           .shortName ??
                              //                       ''
                              //                   : '',
                              //               style: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //             const Spacer(),
                              //             //   Small2Text(color: Colors.grey, text: "Yet to Bet"),
                              //             Text(
                              //               // "210/1 (40)",
                              //               data.data![0].liveMatches!.matches![0].teamScore?.team2?.score ?? '0/0 ( 0 )',
                              //               style: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         const SizedBox(height: 15.5),
                              //         Container(
                              //           height: 0.8,
                              //           width: MediaQuery.of(context).size.width,
                              //           color: Colors.grey.shade300,
                              //         ),
                              //         const SizedBox(height: 15.5),
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Expanded(
                              //               child: InkWell(
                              //                 onTap: () {
                              //                   Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                           builder: (context) =>
                              //                               ScoreCardScreen(
                              //                                   ContestId: data.data![0].liveMatches!.matches![0].contestId,
                              //                                 Team1Sortname: data
                              //                                     .data![0]
                              //                                     .liveMatches!
                              //                                     .matches![0]
                              //                                     .team1Details!
                              //                                     .shortName
                              //                                     .toString(),
                              //                                 Team2Sortname: data
                              //                                     .data![0]
                              //                                     .liveMatches!
                              //                                     .matches![0]
                              //                                     .team2Details!
                              //                                     .shortName
                              //                                     .toString(),
                              //                                 matchid: data
                              //                                     .data![0]
                              //                                     .liveMatches!
                              //                                     .matches![0]
                              //                                     .id
                              //                                     .toString(),
                              //                                 Team1logo: data
                              //                                     .data![0]
                              //                                     .liveMatches!
                              //                                     .matches![0]
                              //                                     .team1Details!
                              //                                     .logo
                              //                                     .toString(),
                              //                                 Team2logo: data
                              //                                     .data![0]
                              //                                     .liveMatches!
                              //                                     .matches![0]
                              //                                     .team2Details!
                              //                                     .logo
                              //                                     .toString(),
                              //                               )));
                              //                 },
                              //                 child: Container(
                              //                   height: 40,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(10),
                              //                     color: const Color(0xff140B40)
                              //                         .withOpacity(0.05),
                              //                   ),
                              //                   child: const Center(
                              //                     child: Text(
                              //                       "View Stats",
                              //                       style: TextStyle(
                              //                         fontSize: 13,
                              //                         color: Color(0xff140B40),
                              //                         fontWeight: FontWeight.w500,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             const SizedBox(width: 15),
                              //             Expanded(
                              //               child: GestureDetector(
                              //                 onTap: (){
                              //                   String matchName = '${data.data![0].liveMatches!.matches![0].team1Details!.shortName} vs ${data.data![0].liveMatches!.matches![0].team2Details!.shortName}';
                              //                   Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                         builder: (context) => Myteamlist(
                              //                           ismyMatches: true,
                              //                           MatchID: data
                              //                               .data![0]
                              //                               .liveMatches!
                              //                               .matches![0]
                              //                               .id
                              //                               .toString(),
                              //                           matchName: matchName,
                              //                         ),
                              //                       ));
                              //                 },
                              //                 child: Container(
                              //                   height: 40,
                              //                   width: 170,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(10),
                              //                     color: const Color(0xff140B40)
                              //                         .withOpacity(0.05),
                              //                   ),
                              //                   child: const Center(
                              //                     child: Text(
                              //                       "My Team",
                              //                       style: TextStyle(
                              //                         fontSize: 13,
                              //                         color: Color(0xff140B40),
                              //                         fontWeight: FontWeight.w500,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //   const SizedBox(height: 20),
                              // ],
                              if (LiveMatch.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // NormalText(color: Colors.black, text: "Live"),
                                    NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: "Live",
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LiveMatchesViewAll(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SmallText(
                                              color: Colors.grey,
                                              text: "View All"),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 18, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 170.h,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width, // Allow the container to take the full available width
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: LiveMatch.length > 3
                                        ? 3
                                        : LiveMatch
                                            .length, // Limit to 3 matches
                                    itemBuilder: (context, index) {
                                      final match = data.data![0].liveMatches!
                                          .matches![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                15), // Add spacing between items
                                        child: Container(
                                          height: 180,
                                          width: 300,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                // mainAxisSize: MainAxisSize.min,  // Prevent the row from expanding
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: Image.network(
                                                      match.team1Details
                                                              ?.logo ??
                                                          '',
                                                      height: 100.h,
                                                      fit: BoxFit
                                                          .cover, // Ensure the image fits properly
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    match.team1Details
                                                            ?.shortName ??
                                                        '',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    match.teamScore?.team1
                                                            ?.score ??
                                                        '0/0 (0)',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                // mainAxisSize: MainAxisSize.min,  // Prevent the row from expanding
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: Image.network(
                                                      match.team2Details
                                                              ?.logo ??
                                                          '',
                                                      height: 100.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    match.team2Details
                                                            ?.shortName ??
                                                        '',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    match.teamScore?.team2
                                                            ?.score ??
                                                        '0/0 (0)',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15.5),
                                              Container(
                                                height: 0.8,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.grey.shade300,
                                              ),
                                              const SizedBox(height: 15.5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ScoreCardScreen(
                                                                          ContestId: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .contestId,
                                                                          Team1Sortname: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .team1Details!
                                                                              .shortName
                                                                              .toString(),
                                                                          Team2Sortname: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .team2Details!
                                                                              .shortName
                                                                              .toString(),
                                                                          matchid: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .id
                                                                              .toString(),
                                                                          Team1logo: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .team1Details!
                                                                              .logo
                                                                              .toString(),
                                                                          Team2logo: data
                                                                              .data![0]
                                                                              .liveMatches!
                                                                              .matches![0]
                                                                              .team2Details!
                                                                              .logo
                                                                              .toString(),
                                                                        )));
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color(
                                                                  0xff140B40)
                                                              .withOpacity(
                                                                  0.05),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            "View Stats",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff140B40),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        String matchName =
                                                            '${data.data![0].liveMatches!.matches![0].team1Details!.shortName} vs ${data.data![0].liveMatches!.matches![0].team2Details!.shortName}';
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Myteamlist(
                                                                ismyMatches:
                                                                    true,
                                                                MatchID: data
                                                                    .data![0]
                                                                    .liveMatches!
                                                                    .matches![0]
                                                                    .id
                                                                    .toString(),
                                                                matchName:
                                                                    matchName,
                                                              ),
                                                            ));
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 170,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color(
                                                                  0xff140B40)
                                                              .withOpacity(
                                                                  0.05),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            "My Team",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff140B40),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // Upcoming Matches Section
                              //                   if (UpcomingMatch.isNotEmpty) ...[
                              //                     Row(
                              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                       children: [
                              //                         NormalText(color: Colors.black, text: "Upcoming"),
                              //                         InkWell(
                              //                           onTap: () {
                              //                             Navigator.push(
                              //                               context,
                              //                               MaterialPageRoute(
                              //                                   builder: (context) =>
                              //                                       const UpComingMyMaychesViewAll()),
                              //                             );
                              //                           },
                              //                           child: Row(
                              //                             children: [
                              //                               SmallText(
                              //                                   color: Colors.grey, text: "View All"),
                              //                               const Icon(Icons.arrow_forward_ios,
                              //                                   size: 18, color: Colors.grey),
                              //                             ],
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     const SizedBox(height: 10),
                              //                     InkWell(
                              //                       // onTap: () {
                              //                       //   if (UpcomingMatch.isNotEmpty) {
                              //                       //     Navigator.push(context, MaterialPageRoute(builder: (context) => IndVsSaScreens()));
                              //                       //   }
                              //                       // },
                              //                       child: Stack(
                              //                         children: [
                              //                           Container(
                              //                             // height: 185,
                              //                             // // Responsive height
                              //                             // width: 380,
                              //                             height: 184,
                              //                             width: 300,
                              //                             // Responsive width
                              //                             margin: const EdgeInsets.only(right: 0),
                              //                             // Responsive margin
                              //                             decoration: BoxDecoration(
                              //                               image: const DecorationImage(
                              //                                   image: AssetImage(
                              //                                       "assets/card_bg_prev_ui.png"),
                              //                                   fit: BoxFit.cover),
                              //                               gradient: LinearGradient(colors: [
                              //                                 _hexToColor(data.data![1].upcomingMatches!
                              //                                     .matches![0].team1Details?.colorCode?? "#FFFFFF"),
                              //                                 _hexToColor(data.data![1].upcomingMatches!
                              //                                     .matches![0].team2Details?.colorCode?? "#FFFFFF"),
                              //                               ]),
                              //                               borderRadius: BorderRadius.circular(12),
                              //                               // Responsive border radius
                              //                               color: Colors.red,
                              //                             ),
                              //                             child: Padding(
                              //                               padding: const EdgeInsets.only(top: 5),
                              //                               // Responsive padding
                              //                               child: Column(
                              //                                 crossAxisAlignment:
                              //                                     CrossAxisAlignment.center,
                              //                                 mainAxisAlignment: MainAxisAlignment.end,
                              //                                 children: [
                              //                                   const SizedBox(height: 10),
                              //                                   // Responsive spacing
                              //                                   Row(
                              //                                     mainAxisAlignment:
                              //                                         MainAxisAlignment.center,
                              //                                     children: [
                              //                                       Text(
                              //                                         // UpcomingMatch.isNotEmpty
                              //                                         //     ? data
                              //                                         //             .data![1]
                              //                                         //             .upcomingMatches!
                              //                                         //             .matches![0]
                              //                                         //             .team1Details!
                              //                                         //             .shortName ??
                              //                                         //         ''
                              //                                         //     : '',
                              // (data?.data?.isNotEmpty == true &&
                              // data!.data![1].upcomingMatches?.matches?.isNotEmpty == true)
                              // ? data.data![1].upcomingMatches!.matches![0]?.team1Details?.shortName ?? ''
                              //     : '',
                              //                                         style: const TextStyle(
                              //                                           fontSize: 14,
                              //                                           // Responsive text size
                              //                                           fontWeight: FontWeight.w700,
                              //                                           color: Colors.white,
                              //                                         ),
                              //                                       ),
                              //                                       const SizedBox(width: 7),
                              //                                       // Responsive spacing
                              //                                       Image.asset('assets/vs.png',
                              //                                           height: 40),
                              //                                       const SizedBox(width: 7),
                              //                                       // Responsive spacing
                              //                                       Text(
                              //                                         UpcomingMatch.isNotEmpty
                              //                                             ? data
                              //                                                     .data![1]
                              //                                                     .upcomingMatches!
                              //                                                     .matches![0]
                              //                                                     .team2Details!
                              //                                                     .shortName ??
                              //                                                 ''
                              //                                             : '',
                              //                                         style: const TextStyle(
                              //                                           fontSize: 14,
                              //                                           // Responsive text size
                              //                                           fontWeight: FontWeight.w700,
                              //                                           color: Colors.white,
                              //                                         ),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                   const Spacer(),
                              //                                   Container(
                              //                                     height: 110, // Responsive height
                              //                                     width: double.infinity,
                              //                                     decoration: BoxDecoration(
                              //                                       borderRadius:
                              //                                           BorderRadius.circular(10),
                              //                                       // Responsive border radius
                              //                                       color: Colors.white,
                              //                                     ),
                              //                                     child: Padding(
                              //                                       padding: const EdgeInsets.symmetric(
                              //                                           horizontal: 15),
                              //                                       // Responsive padding
                              //                                       child: Column(
                              //                                         mainAxisAlignment:
                              //                                             MainAxisAlignment.end,
                              //                                         crossAxisAlignment:
                              //                                             CrossAxisAlignment.start,
                              //                                         children: [
                              //                                           Row(
                              //                                             mainAxisAlignment:
                              //                                                 MainAxisAlignment
                              //                                                     .spaceBetween,
                              //                                             crossAxisAlignment:
                              //                                                 CrossAxisAlignment.start,
                              //                                             children: [
                              //                                               Expanded(
                              //                                                 child: Text(
                              //                                                   UpcomingMatch.isNotEmpty
                              //                                                       ? data
                              //                                                               .data![1]
                              //                                                               .upcomingMatches!
                              //                                                               .matches![0]
                              //                                                               .team1Details!
                              //                                                               .teamName ??
                              //                                                           ''
                              //                                                       : '',
                              //                                                   textAlign:
                              //                                                       TextAlign.center,
                              //                                                   maxLines: 2,
                              //                                                   softWrap: true,
                              //                                                   overflow: TextOverflow
                              //                                                       .ellipsis,
                              //                                                   style: const TextStyle(
                              //                                                     fontSize: 14,
                              //                                                     // Responsive text size
                              //                                                     fontWeight:
                              //                                                         FontWeight.w600,
                              //                                                     color: Colors.black,
                              //                                                   ),
                              //                                                 ),
                              //                                               ),
                              //                                               const SizedBox(width: 8),
                              //                                               // Responsive spacing
                              //                                               Expanded(
                              //                                                 child: Column(
                              //                                                   mainAxisAlignment:
                              //                                                       MainAxisAlignment
                              //                                                           .center,
                              //                                                   children: [
                              //                                                     Text(
                              //                                                       formattedDate,
                              //                                                       // '- ${UpcomingMatch.isNotEmpty ? data.data![1].upcomingMatches!.matches![0].date ?? '' : '' }',
                              //                                                       style: const TextStyle(
                              //                                                         fontSize: 14,
                              //                                                         // Responsive text size
                              //                                                         fontWeight:
                              //                                                             FontWeight
                              //                                                                 .w500,
                              //                                                         color: Color(
                              //                                                             0xffDC0000),
                              //                                                       ),
                              //                                                     ),
                              //                                                     Text(
                              //                                                       UpcomingMatch.isNotEmpty ? data.data![1].upcomingMatches!.matches![0].time ?? '' : '',
                              //                                                       style: const TextStyle(
                              //                                                         fontSize: 14,
                              //                                                         // Responsive text size
                              //                                                         fontWeight:
                              //                                                             FontWeight
                              //                                                                 .w500,
                              //                                                         color:
                              //                                                             Colors.black,
                              //                                                       ),
                              //                                                     ),
                              //                                                     SizedBox(height: 10),
                              //                                                   ],
                              //                                                 ),
                              //                                               ),
                              //                                               const SizedBox(width: 8),
                              //                                               // Responsive spacing
                              //                                               Expanded(
                              //                                                 child: Text(
                              //                                                   UpcomingMatch.isNotEmpty
                              //                                                       ? data
                              //                                                               .data![1]
                              //                                                               .upcomingMatches!
                              //                                                               .matches![0]
                              //                                                               .team2Details!
                              //                                                               .teamName ??
                              //                                                           ''
                              //                                                       : '',
                              //                                                   textAlign:
                              //                                                       TextAlign.center,
                              //                                                   maxLines: 2,
                              //                                                   softWrap: true,
                              //                                                   overflow: TextOverflow
                              //                                                       .ellipsis,
                              //                                                   style: const TextStyle(
                              //                                                     fontSize: 14,
                              //                                                     // Responsive text size
                              //                                                     fontWeight:
                              //                                                         FontWeight.w600,
                              //                                                     color: Colors.black,
                              //                                                   ),
                              //                                                 ),
                              //                                               ),
                              //                                             ],
                              //                                           ),
                              //                                           const SizedBox(height: 10),
                              //                                           // Responsive spacing
                              //                                           // Responsive spacing
                              //
                              //                                           const SizedBox(height: 8),
                              //                                           // Responsive spacing
                              //                                         ],
                              //                                       ),
                              //                                     ),
                              //                                   ),
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           Positioned(
                              //                             top: 35, // Responsive position
                              //                             left: 40, // Responsive position
                              //                             child: Image.network(
                              //                               UpcomingMatch.isNotEmpty
                              //                                   ? data
                              //                                           .data![1]
                              //                                           .upcomingMatches!
                              //                                           .matches![0]
                              //                                           .team1Details
                              //                                           ?.logo ??
                              //                                       ''
                              //                                   : '',
                              //
                              //                               height: 65, // Responsive height
                              //                             ),
                              //                           ),
                              //                           Positioned(
                              //                             top: 40, // Responsive position
                              //                             right: 40, // Responsive position
                              //                             child: Image.network(
                              //                               UpcomingMatch.isNotEmpty
                              //                                   ? data
                              //                                           .data![1]
                              //                                           .upcomingMatches!
                              //                                           .matches![0]
                              //                                           .team2Details
                              //                                           ?.logo ??
                              //                                       ''
                              //                                   : '',
                              //
                              //                               height: 62, // Responsive height
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                     const SizedBox(height: 20),
                              //                   ],
                              if (UpcomingMatch.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // NormalText(color: Colors.black, text: "Upcoming"),
                                    NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: "Upcoming",
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const UpComingMyMaychesViewAll(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SmallText(
                                              color: Colors.grey,
                                              text: "View All"),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 18, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 200, // Adjust height as needed
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: UpcomingMatch.length > 3
                                        ? 3
                                        : UpcomingMatch.length,
                                    itemBuilder: (context, index) {
                                      final match = data.data![1]
                                          .upcomingMatches!.matches![index];
                                      DateTime? matchDate;
                                      try {
                                        matchDate = DateTime.parse(
                                            UpcomingMatch.isNotEmpty
                                                ? data.data![1].upcomingMatches!
                                                        .matches![index].date ??
                                                    ''
                                                : '');
                                      } catch (e) {
                                        matchDate = null;
                                      }
                                      final DateFormat dateFormatter =
                                          DateFormat('dd-MM-yyyy');
                                      String formattedDate = matchDate != null
                                          ? dateFormatter.format(matchDate)
                                          : '';
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20), // Spacing between items
                                        child: InkWell(
                                          // Add onTap functionality if needed
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 184,
                                                width: 300,
                                                margin: const EdgeInsets.only(
                                                    right: 0),
                                                decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/card_bg_prev_ui.png"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      _hexToColor(match
                                                              .team1Details
                                                              ?.colorCode ??
                                                          "#FFFFFF"),
                                                      _hexToColor(match
                                                              .team2Details
                                                              ?.colorCode ??
                                                          "#FFFFFF"),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.red,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            match.team1Details
                                                                    ?.shortName ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 7),
                                                          Image.asset(
                                                              'assets/vs.png',
                                                              height: 40),
                                                          const SizedBox(
                                                              width: 7),
                                                          Text(
                                                            match.team2Details
                                                                    ?.shortName ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        height: 110,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      match.team1Details
                                                                              ?.teamName ??
                                                                          '',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          formattedDate,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Color(0xffDC0000),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          match.time ??
                                                                              '',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child: Text(
                                                                      match.team2Details
                                                                              ?.teamName ??
                                                                          '',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 35,
                                                left: 40,
                                                child: Image.network(
                                                  match.team1Details?.logo ??
                                                      '',
                                                  height: 65,
                                                ),
                                              ),
                                              Positioned(
                                                top: 40,
                                                right: 40,
                                                child: Image.network(
                                                  match.team2Details?.logo ??
                                                      '',
                                                  height: 62,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // const SizedBox(height: 20),
                              ],

                              // Completed Matches Section
                              // if (ComplatedMatch.isNotEmpty) ...[
                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       NormalText(
                              //           color: Colors.black, text: "Completed"),
                              //       InkWell(
                              //         onTap: () {
                              //           Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const ComplateMatchesViewAll()),
                              //           );
                              //         },
                              //         child: Row(
                              //           children: [
                              //             SmallText(
                              //                 color: Colors.grey, text: "View All"),
                              //             const Icon(Icons.arrow_forward_ios,
                              //                 size: 18, color: Colors.grey),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   const SizedBox(height: 10),
                              //   InkWell(
                              //     // onTap: () {
                              //     // if (ComplatedMatch.isNotEmpty) {
                              //     // Navigator.push(context, MaterialPageRoute(
                              //     // builder: (context) => ComplateMatchesViewAll()));
                              //     // }
                              //     // },
                              //     child: Container(
                              //       padding: const EdgeInsets.all(15),
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(20),
                              //         color: Colors.white,
                              //       ),
                              //       child: Column(
                              //         children: [
                              //           const SizedBox(height: 10),
                              //           Row(
                              //             children: [
                              //               SizedBox(
                              //                 width: 30,
                              //                 height: 30,
                              //                 child: Image.network(
                              //                   ComplatedMatch.isNotEmpty
                              //                       ? data
                              //                               .data![2]
                              //                               .completedMatches!
                              //                               .matches![0]
                              //                               .team1Details
                              //                               ?.logo ??
                              //                           ''
                              //                       : '',
                              //                   height: 100.h,
                              //                 ),
                              //               ),
                              //               const SizedBox(width: 8),
                              //               Text(
                              //                 ComplatedMatch.isNotEmpty
                              //                     ? data
                              //                             .data![2]
                              //                             .completedMatches!
                              //                             .matches![0]
                              //                             .team1Details!
                              //                             .shortName ??
                              //                         ''
                              //                     : '',
                              //                 style: const TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //               const Spacer(),
                              //               Text(
                              //                 // "210/1 (40)",
                              //                 data.data![2].completedMatches!.matches![0].teamScore?.team1?.score ?? '0/0 ( 0 )',
                              //
                              //                 style: const TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           const SizedBox(height: 6),
                              //           Row(
                              //             children: [
                              //               SizedBox(
                              //                 width: 30,
                              //                 height: 30,
                              //                 child: Image.network(
                              //                   ComplatedMatch.isNotEmpty
                              //                       ? data
                              //                               .data![2]
                              //                               .completedMatches!
                              //                               .matches![0]
                              //                               .team2Details
                              //                               ?.logo ??
                              //                           ''
                              //                       : '',
                              //                   height: 100.h,
                              //                 ),
                              //               ),
                              //               const SizedBox(width: 8),
                              //               Text(
                              //                 ComplatedMatch.isNotEmpty
                              //                     ? data
                              //                             .data![2]
                              //                             .completedMatches!
                              //                             .matches![0]
                              //                             .team2Details!
                              //                             .shortName ??
                              //                         ''
                              //                     : '',
                              //                 style: const TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //               const Spacer(),
                              //               Text(
                              //                 // "210/1 (40)",
                              //                 data.data![2].completedMatches!.matches![0].teamScore?.team2?.score ?? '0/0 ( 0 )',
                              //
                              //                 style: const TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           const SizedBox(
                              //             height: 15,
                              //           ),
                              //           Container(
                              //             height: 0.8,
                              //             width: MediaQuery.of(context).size.width,
                              //             color: Colors.grey.shade300,
                              //           ),
                              //           const SizedBox(height: 12),
                              //           if (ComplatedMatch.isNotEmpty)
                              //             Container(
                              //               height: 40,
                              //               width: MediaQuery.of(context).size.width,
                              //               decoration: BoxDecoration(
                              //                   borderRadius:
                              //                       BorderRadius.circular(10),
                              //                   color: Colors.green.withOpacity(0.1)),
                              //               child: Center(
                              //                   child: Text(
                              //                     'You Won ${formatMegaPrice(int.parse(data.data![2].completedMatches!.matches![0].winningAmount!))}',
                              //                     // "₹ ${currentUser?.winningAmount ?? '0' }",
                              //                     // "You won ₹58",
                              //                 style: const TextStyle(
                              //                     fontSize: 13,
                              //                     color: Colors.green,
                              //                     fontWeight: FontWeight.w500),
                              //               )),
                              //             )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ],
                              if (ComplatedMatch.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // NormalText(color: Colors.black, text: "Completed"),
                                    NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: "Completed",
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ComplateMatchesViewAll(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SmallText(
                                              color: Colors.grey,
                                              text: "View All"),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 18, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 150,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width, // Set a fixed height for the ListView
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ComplatedMatch.length > 3
                                        ? 3
                                        : ComplatedMatch.length,
                                    itemBuilder: (context, index) {
                                      final match = data.data![2]
                                          .completedMatches!.matches![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                10), // Add space between cards
                                        child: InkWell(
                                          child: Container(
                                            // height: 180,
                                            width:
                                                300, // Set a fixed width for each card
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: Image.network(
                                                        match.team1Details
                                                                ?.logo ??
                                                            '',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      match.team1Details
                                                              ?.shortName ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      match.teamScore?.team1
                                                              ?.score ??
                                                          '0/0 (0)',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: Image.network(
                                                        match.team2Details
                                                                ?.logo ??
                                                            '',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      match.team2Details
                                                              ?.shortName ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      match.teamScore?.team2
                                                              ?.score ??
                                                          '0/0 (0)',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.green
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'You Won ${formatMegaPrice(int.parse(match.winningAmount!))}',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ]
                          ]),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        height: 32,
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: _selectedIndex == index ? Colors.white : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _selectedIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}




// Future<UserMyMatchesModel?> fetchMatches() async {
//   print('fetch matches.............');
//   try {
//     print('fetch matches 222222222222222222222 .............');
//
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/user/userMatches'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     if (response.statusCode == 200) {
//       print('fetch matches 3333333333333333333333 .............');
//
//       final jsonData = json.decode(response.body);
//       UserMyMatchesModel matchesModel = UserMyMatchesModel.fromJson(jsonData);
//
//       setState(() {
//         if (matchesModel.data != null) {
//           for (var matchData in matchesModel.data!) {
//             // Check for completed matches
//             if (matchData.completedMatches != null) {
//               for (var match in matchData.completedMatches!.matches!) {
//                 // Store the contest_id from completed matches
//                 contestId = match.contestId; // Use match.contestId if it's contest_id in the model
//                 debugPrint('Contest ID: $contestId');
//                 print('Contest id is....................:- $contestId');
//               }
//             }
//             // Optionally, handle liveMatches and upcomingMatches if needed
//           }
//         }
//         print('Contest id is....................:- $contestId');
//       });
//       return matchesModel;
//       // return UserMyMatchesModel.fromJson(jsonData);
//     } else {
//       print('fetch matches 4444444444444444444444444 .............');
//
//       throw Exception('Failed to load  my matches');
//     }
//   } catch (e, stackTrace) {
//     print('fetch matches 555555555555555555 .............');
//
//     debugPrint('Error fetching My Matches data: $e');
//     debugPrint('Stack trace: $stackTrace');
//     return null;
//   }
// }

// @override
// void initState() {
//   super.initState();
//   // fetchProfileData();
//   // contestDisplay();
//   _futureData = fetchMatches();
//   fetchProfileData().then((_) {
//     // Once profile data is fetched, fetch contest data
//     contestDisplay();
//   }).catchError((error) {
//     debugPrint("Error fetching profile data: $error");
//   });
//   currentUser;
//   // print('current user winning amount:-${currentUser!.winningAmount}');
//   //startTimer();
// }
// _futureData!.then((matchesModel) {
//   fetchProfileData().then((_) {
//     contestDisplay(); // Call contestDisplay after both fetches
//   }).catchError((error) {
//     debugPrint("Error fetching profile data: $error");
//   });
// }).catchError((error) {
//   debugPrint("Error fetching matches data: $error");
// });


// Future<void> fetchProfileData() async {
//   print('the currentuser is1111111111111111');
//   try {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     print('the currentuser is 2222222222222222222222');
//
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       print('the currentuser is 33333333333333333333333');
//
//       final data = ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
//       debugPrint('data ${data.message}'); // Ensure to parse the correct field
//       setState(() {
//         currentUserId = "${data.data!.id}";
//         print('the currentuser is :- $currentUserId');
//       });
//     } else {
//       debugPrint('Failed to fetch profile data: ${response.statusCode}');
//       print('the currentuser is 55555555555555555555555555');
//
//     }
//   } catch (e) {
//     debugPrint('Error fetching profile data: $e');
//     print('the currentuser is 66666666666666666666666666666');
//   }
// }
// Future<void> fetchProfileData() async {
//   print('the currentuser is1111111111111111');
//   try {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     print('the currentuser is 2222222222222222222222');
//
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       print('the currentuser is 33333333333333333333333');
//
//       final data = ProfileDisplay.fromJson(jsonDecode(response.body));
//
//       // Check if data and data.data are not null
//       if (data.data != null) {
//         debugPrint('data ${data.message}');
//         setState(() {
//           currentUserId = "${data.data!.id}";
//           print('the currentuser is :- $currentUserId');
//         });
//       } else {
//         debugPrint('No user data found in the response.');
//       }
//     } else {
//       debugPrint('Failed to fetch profile data: ${response.statusCode}');
//       print('the currentuser is 55555555555555555555555555');
//     }
//   } catch (e) {
//     debugPrint('Error fetching profile data: $e');
//     print('the currentuser is 66666666666666666666666666666');
//   }
// }
//
// Future<ContestInsideModel?> contestDisplay() async {
//   print('contest displayy 111111111111111111');
//   try {
//     print('contest displayy 2222222222222222222222');
//
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final response = await http.get(
//       Uri.parse(
//           'https://batting-api-1.onrender.com/api/contest/display?contestId=${contestId!}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       print('contest displayy 3333333333333333333333333');
//
//       final data = ContestInsideModel.fromJson(jsonDecode(response.body));
//       debugPrint('Data: ${data.message}');
//       print('iddd${data.data.contestDetails.id}');
//       debugPrint("debugPrint from if part ${response.body}");
//       debugPrint('Leaderboard of the contest: ${data.data.leaderboard}');
//
//       // Parse the match date and time
//       matchDateTime = DateTime.parse(data.data.contestDetails.matchDate.toString()).add(
//           Duration(
//               hours: int.parse(data.data.contestDetails.matchTime.split(':')[0]),
//               minutes: int.parse(data.data.contestDetails.matchTime.split(':')[1])));
//
//       // Calculate remaining time
//       setState(() {
//         _contests = data.data.leaderboard;
//         remainingTime = matchDateTime.difference(DateTime.now());
//         print("remaining time is : -----$remainingTime");
//         print("remaining time is : -----$matchDateTime");
//
//         // Update currentUser  based on leaderboard
//         var storedata = data.data.leaderboard.first.winningAmount;
//         var storeid = data.data.leaderboard.first.id;
//         print('store data:- ${storedata}');
//         print('store data:- ${storeid}');
//
//         for (var entry in data.data.leaderboard) {
//           debugPrint('User  ID check: ${entry.userId}, Winning Amount: ${entry.winningAmount}, Rank: ${entry.rank}');
//           if (entry.userId == currentUserId) {
//             currentUser = entry; // Store the current user's leaderboard data
//             print("current user all leaderboard entry:- ${currentUser!.userDetails}");
//             print('Current User Found: ${currentUser!.winningAmount}');
//             break; // Exit the loop once found
//           }
//         }
//
//         if (currentUser != null) {
//           print('Current user winning amount: ${currentUser!.winningAmount}');
//         } else {
//           print('Current user not found in leaderboard.');
//         }
//       });
//
//       return data;
//     } else {
//       debugPrint('Failed to fetch contest message: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching contest data: $e');
//     return null;
//   }
// }
// Future<ContestInsideModel?> contestDisplay() async {
//   print('contest displayy 111111111111111111');
//   try {
//     print('contest displayy 2222222222222222222222');
//
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final response = await http.get(
//       Uri.parse(
//           'https://batting-api-1.onrender.com/api/contest/display?contestId=${contestId!}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     if (response.statusCode == 200) {
//       print('contest displayy 3333333333333333333333333');
//
//       final data = ContestInsideModel.fromJson(jsonDecode(response.body));
//       debugPrint('Data: ${data.message}');
//       print('iddd${data.data.contestDetails.id}');
//       debugPrint("debugPrint from if part ${response.body}");
//
//       // Parse the match date and time
//       matchDateTime =
//           DateTime.parse(data.data.contestDetails.match_date.toString()).add(
//               Duration(
//                   hours: int.parse(
//                       data.data.contestDetails.match_time.split(':')[0]),
//                   minutes: int.parse(
//                       data.data.contestDetails.match_time.split(':')[1])));
//
//       // Calculate remaining time
//       setState(() {
//         _contests = data.data.leaderboard;
//         remainingTime = matchDateTime.difference(DateTime.now());
//         print("remaining time is : -----$remainingTime");
//         print("remaining time is : -----$matchDateTime");
//         for (var entry in data.data.leaderboard) {
//           if (entry.userId == currentUserId) {
//             currentUser = entry; // Store the current user's leaderboard data
//             // var teamId = currentUser!.myTeamId.first; // Assuming teamId is part of currentUser
//             // teamNumber = teamId.contains('T')
//             //     ? teamId.split('T').last.split(')')[0]
//             //     : '';
//
//             // You can now use teamNumber as needed
//             // debugPrint("Current User's Team Number: $teamNumber");
//             break; // Exit the loop once found
//           }
//         }
//         if(currentUser != null){
//           print('current user winning amount:- ${currentUser!.winningAmount}');
//         }
//         else {
//           print('Current user not found in leaderboard.');
//         }
//         currentUser;
//       });
//
//       return data;
//     } else {
//       print('current user winning amount11111111111111:- ${currentUser!.winningAmount}');
//       debugPrint("this is else response::${response.body}");
//       debugPrint('Failed to fetch contest data: ${response.statusCode}');
//       print('contest displayy 444444444444444444444444444');
//       return null;
//     }
//   } catch (e) {
//     print('current user winning amount2222222222222222:- ${currentUser!.winningAmount}');
//     debugPrint('Error fetching contest data: $e');
//     print('contest displayy 55555555555555555555555');
//     return null;
//   }
// }