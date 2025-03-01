import 'dart:async';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../db/app_db.dart';
import '../../model/UserMyMatchesModel.dart';
import '../../model/imp_model.dart';
import '../../widget/appbar_for_setting.dart';

class UpComingMyMaychesViewAll extends StatefulWidget {
  const UpComingMyMaychesViewAll({super.key});

  @override
  State<UpComingMyMaychesViewAll> createState() =>
      _UpComingMyMaychesViewAllState();
}

class _UpComingMyMaychesViewAllState extends State<UpComingMyMaychesViewAll> {
  late Future<UserMyMatchesModel?> _futureData;
  List<Matches> UpcomingMatch = [];
  List<IplTeam> teams = [];

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
  void initState() {
    super.initState();
    _futureData = fetchMatches();
    //startTimer();
  }

  // late Future<MatchScoreTestModel?> _FutureData;
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
        final jsonData = json.decode(response.body);
        return UserMyMatchesModel.fromJson(jsonData);
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      //                 AppBarText(color: Colors.white, text: "Upcoming Match"),
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
      //               AppBarText(color: Colors.white, text: ""),
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
        title: "Upcoming Match",
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
            // UpcomingMatch =
            //     data.data?[1].upcomingMatches?.matches?.cast<Matches>() ?? [];
            // print('date is :- ${UpcomingMatch[2].date}');
            UpcomingMatch =
                data.data?[1].upcomingMatches?.matches?.cast<Matches>() ?? [];

            if (UpcomingMatch.isEmpty) {
              return const Center(child: Text('No matches found'));
            }
          }
          // DateTime? matchDate;
          // try {
          //   matchDate = DateTime.parse(UpcomingMatch[0].date ?? ''  '');
          // } catch (e) {
          //   matchDate = null;
          // }
          // final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
          // String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
          return InkWell(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 10),
              color: const Color(0xffF0F1F5),
              child: ListView.builder(
                itemCount: UpcomingMatch.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final upcoming = UpcomingMatch[index];
                  DateTime? matchDate;
                  try {
                    matchDate =
                        DateTime.parse(UpcomingMatch[index].date ?? '' '');
                  } catch (e) {
                    matchDate = null;
                  }
                  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
                  String formattedDate =
                      matchDate != null ? dateFormatter.format(matchDate) : '';
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            height: 185, // Responsive height
                            width: 420.h, // Responsive width
                            // margin: EdgeInsets.only(right: 0), // Responsive margin
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/card_bg_prev_ui.png"),
                                  fit: BoxFit.cover),
                              gradient: LinearGradient(colors: [
                                _hexToColor(upcoming.team1Details!.colorCode),
                                _hexToColor(upcoming.team2Details!.colorCode),
                              ]),
                              borderRadius: BorderRadius.circular(
                                  12), // Responsive border radius
                              color: Colors.red,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                    height: 10), // Responsive spacing
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${upcoming.team1Details!.shortName}',
                                      style: const TextStyle(
                                        fontSize: 14, // Responsive text size
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 7), // Responsive spacing
                                    Image.asset('assets/vs.png', height: 40),
                                    const SizedBox(
                                        width: 7), // Responsive spacing
                                    Text(
                                      '${upcoming.team2Details!.shortName}',
                                      style: const TextStyle(
                                        fontSize: 14, // Responsive text size
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 110, // Responsive height
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Responsive border radius
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15), // Responsive padding
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${upcoming.team1Details!.teamName}',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize:
                                                      14, // Responsive text size
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 8), // Responsive spacing
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    // '${upcoming.date}',
                                                    formattedDate,
                                                    // '- ${UpcomingMatch.isNotEmpty ? data.data![1].upcomingMatches!.matches![0].date ?? '' : '' }',
                                                    style: const TextStyle(
                                                      fontSize:
                                                          14, // Responsive text size
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xffDC0000),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${upcoming.time}',
                                                    style: const TextStyle(
                                                      fontSize:
                                                          14, // Responsive text size
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 8), // Responsive spacing
                                            Expanded(
                                              child: Text(
                                                '${upcoming.team2Details!.teamName}',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize:
                                                      14, // Responsive text size
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height: 15), // Responsive spacing
                                        // Responsive spacing

                                        const SizedBox(
                                            height: 8), // Responsive spacing
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 45, // Responsive position
                          left: 55, // Responsive position
                          child: Image.network(
                            '${upcoming.team1Details!.logo}',

                            height: 65, // Responsive height
                          ),
                        ),
                        Positioned(
                          top: 45, // Responsive position
                          right: 55, // Responsive position
                          child: Image.network(
                            '${upcoming.team2Details!.logo}',

                            height: 62, // Responsive height
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
