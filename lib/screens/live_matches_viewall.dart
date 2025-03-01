import 'dart:async';
import 'dart:convert';

import 'package:batting_app/screens/scorecardscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';
import '../model/MatchScoreTestModel.dart';
import '../model/UserMyMatchesModel.dart';
import '../model/imp_model.dart';
import '../widget/appbar_for_setting.dart';

class LiveMatchesViewAll extends StatefulWidget {
  const LiveMatchesViewAll({super.key});

  @override
  State<LiveMatchesViewAll> createState() => _LiveMatchesViewAllState();
}

class _LiveMatchesViewAllState extends State<LiveMatchesViewAll> {
  late Future<UserMyMatchesModel?> _futureData;
  List<Matches> LiveMatch = [];
  List<IplTeam> teams = [];

  late Future<MatchScoreTestModel?> _FutureData;
  Future<MatchScoreTestModel?> matchscore() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/scoreboard/userScore/669f85c18e3e0c2c56263367'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MatchScoreTestModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load  my matches');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching My Matches data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchMatches();
    _FutureData = matchscore();
    //startTimer();
  }

  Future<UserMyMatchesModel?> fetchMatches() async {
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
        // If the server returns a successful response, parse the JSON
        final jsonData = json.decode(response.body);
        return UserMyMatchesModel.fromJson(jsonData);
      } else {
        // If the server returns an error, throw an exception
        throw Exception('Failed to load  my matches');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching My Matches data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  Color _hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent; // or any default color you prefer
    }

    hexColor = hexColor.replaceAll('#', '');

    return Color(int.parse('FF$hexColor', radix: 16));
  }

  Timer? _timer;
  String adjustedTime = '';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<HomeLeagModel?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/user/desbord_details'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = HomeLeagModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print(response.statusCode);
        // print('mymatches ${myMatch}');
        print("print from if part ${response.body}");

        return data;
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching profile data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  String adjustMatchTime(String? originalTime) {
    if (originalTime == null || originalTime.isEmpty) {
      return ""; // Handle case where time is null or empty
    }

    try {
      // Parse the original time assuming it's in "HH:mm" format
      List<String> parts = originalTime.split(":");
      int matchHour = int.parse(parts[0]);
      int matchMinute = int.parse(parts[1]);

      // Get the current time
      DateTime now = DateTime.now();
      int currentHour = now.hour;
      int currentMinute = now.minute;

      // Calculate the time difference in minutes
      int differenceMinutes =
          (matchHour - currentHour) * 60 + (matchMinute - currentMinute);
      // Convert minutes difference to hours and minutes
      int hours = differenceMinutes ~/ 60; // integer division
      int minutes = differenceMinutes % 60;

      // Determine if the match is ahead or ago
      String timeStatus = differenceMinutes >= 0 ? "ahead" : "ago";

      // Format the adjusted time difference
      return "${hours.abs()}h ${minutes.abs()}m";
    } catch (e) {
      print("Error parsing or adjusting time: $e");
      return ""; // Handle any errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(50.0.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       leading: Container(),
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       // Custom background color
      //       elevation: 0,
      //       // Remove shadow
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //         height: 100,
      //         width: MediaQuery
      //             .of(context)
      //             .size
      //             .width,
      //         decoration: const BoxDecoration(
      //             gradient: LinearGradient(
      //                 begin: Alignment.topCenter,
      //                 end: Alignment.bottomCenter,
      //                 colors: [
      //                   Color(0xff1D1459), Color(0xff140B40)
      //                 ])
      //         ),
      //         child: Column(
      //           children: [
      //             const SizedBox(height: 50),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                     onTap: () {
      //                       Navigator.pop(context);
      //                     },
      //                     child: const Icon(
      //                       Icons.arrow_back, color: Colors.white,)),
      //                 AppBarText(color: Colors.white, text: "Live Match"),
      //                 Container(width: 20,)
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // appBar:  PreferredSize(
      //   preferredSize: Size.fromHeight(67.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       automaticallyImplyLeading: false,
      //
      //       flexibleSpace: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w),
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Padding(
      //           padding: EdgeInsets.only(top: 30.h),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               InkWell(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: const Icon(
      //                   Icons.arrow_back,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               AppBarText(color: Colors.white, text: "Live Match"),
      //
      //               // AppBarText(color: Colors.white, text: "Winner"),
      //               Container(
      //                 width: 20,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(
        title: "Live Match",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffF0F1F5),
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            LiveMatch =
                data.data?[0].liveMatches?.matches?.cast<Matches>() ?? [];
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: InkWell(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 15),
                color: const Color(0xffF0F1F5),
                child: ListView.builder(
                  itemCount: LiveMatch.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final upcoming = LiveMatch[index];
                    return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => IndVsSaScreens(
                        //         firstMatch: upcoming.matchDetails!.team1Details!.shortName,
                        //         secMatch: upcoming.matchDetails!.team2Details!.shortName,
                        //         matchName: upcoming.matchDetails!.matchName,
                        //         Id: upcoming.matchDetails!.id
                        //     ),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),

                          //width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.network(
                                      LiveMatch.isNotEmpty
                                          ? LiveMatch[index]
                                                  .team1Details!
                                                  .logo ??
                                              ''
                                          : '',
                                      height: 100.h,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    LiveMatch.isNotEmpty
                                        ? LiveMatch[index]
                                                .team1Details
                                                ?.shortName ??
                                            'N/A'
                                        : 'No Live Match',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    // "210/1 (40)",
                                    LiveMatch.isNotEmpty
                                        ? LiveMatch[index]
                                                .teamScore!
                                                .team1!
                                                .score ??
                                            '0/0 ( 0 )'
                                        : '',

                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.network(
                                      LiveMatch.isNotEmpty
                                          ? LiveMatch[index]
                                                  .team2Details!
                                                  .logo ??
                                              ''
                                          : '',
                                      height: 100.h,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    LiveMatch.isNotEmpty
                                        ? LiveMatch[index]
                                                .team2Details
                                                ?.shortName ??
                                            'N/A'
                                        : 'No Live Match',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    // "210/1 (40)",
                                    LiveMatch.isNotEmpty
                                        ? LiveMatch[index]
                                                .teamScore!
                                                .team2!
                                                .score ??
                                            '0/0 ( 0 )'
                                        : "",

                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15.5,
                              ),
                              Container(
                                height: 0.8,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(
                                height: 15.5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScoreCardScreen(
                                                      matchid: LiveMatch[index]
                                                          .id
                                                          .toString(),
                                                      Team1Sortname:
                                                          LiveMatch[index]
                                                              .team1Details!
                                                              .shortName
                                                              .toString(),
                                                      Team2Sortname:
                                                          LiveMatch[index]
                                                              .team2Details!
                                                              .shortName
                                                              .toString(),
                                                      Team1logo:
                                                          LiveMatch[index]
                                                              .team1Details!
                                                              .logo
                                                              .toString(),
                                                      Team2logo:
                                                          LiveMatch[index]
                                                              .team2Details!
                                                              .logo
                                                              .toString(),
                                                    )));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xff140B40)
                                                .withOpacity(0.05)),
                                        child: const Center(
                                            child: Text(
                                          "View Stats",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xff140B40),
                                              fontWeight: FontWeight.w500),
                                        )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xff140B40)
                                              .withOpacity(0.05)),
                                      child: const Center(
                                          child: Text(
                                        "My Team",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff140B40),
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
