import 'dart:async';
import 'dart:convert';
import 'package:batting_app/screens/viewstate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';
import '../model/imp_model.dart';
import '../widget/appbartext.dart';
import 'ind_vs_sa_screen.dart';


class MyMatchesViewall extends StatefulWidget {
  const MyMatchesViewall({super.key});

  @override
  State<MyMatchesViewall> createState() => _MyMatchesViewallState();
}

class _MyMatchesViewallState extends State<MyMatchesViewall> {

  late Future<IplModel> futureIplModel;
  late Future<HomeLeagModel?> _futureData;
  List<UserMatchesMatch> myMatch = [];

  List<IplTeam> teams = [];

  Color _hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent; // or any default color you prefer
    }

    // Remove the leading '#', if it exists
    hexColor = hexColor.replaceAll('#', '');
    // Parse the string as a hex integer and convert to Color
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  Timer? _timer;
  String adjustedTime = '';


  @override
  void initState() {
    super.initState();
    _futureData = profileDisplay();
    //startTimer();
  }

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
        print('mymatches $myMatch');
        print("print from if part ${response.body}");
        for (var i = 0; i < data.data!.length; i++) {
          // var leagueDetails = data.data![i].leagueDetails;
          // Check for upcoming matches
          if (data.data![i].userMatches != null) {
            myMatch = data.data?[i].userMatches?.matches
                ?.cast<UserMatchesMatch>() ??
                [];
            print('usermatches is done:-${myMatch.length}');
          }
        }
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
  String _formatMatchDate(DateTime? date) {
    if (date == null) return ""; // Handle null date case

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    // Check if the date is today or tomorrow
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return "Today";
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return "Tomorrow";
    } else {
      // Format the date as dd-MM-yyyy
      return DateFormat('dd-MM-yyyy').format(date);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            // Custom background color
            elevation: 0,
            // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff1D1459), Color(0xff140B40)
                      ])
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back, color: Colors.white,)),
                      AppBarText(color: Colors.white, text: "My Matches"),
                      Container(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

            return   SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 15),
                color: const Color(0xffF0F1F5),
                child: ListView.builder(
                  itemCount: myMatch.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final userMatch = myMatch[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 14),
                      child: Stack(children: [
                        Container(
                          height: 150,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Image.asset(
                                      //   'assets/india.png',
                                      //   height: 26,
                                      // ),

                                      Image.network(
                                        userMatch.userMatchDetails?.team1Details?.logo ?? 'https://via.placeholder.com/26', // Placeholder URL
                                        height: 36,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/default_team_image.png', height: 26); // Default image
                                        },
                                      ),

                                      const SizedBox(
                                        width: 8,
                                      ),

                                      // const Text(
                                      //   "IND",
                                      //   style: TextStyle(
                                      //       fontSize: 14, fontWeight: FontWeight.w500),
                                      // ),

                                      //
                                      Text(
                                        userMatch.userMatchDetails
                                            ?.team1Details?.shortName ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),


                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        _formatMatchDate(userMatch.userMatchDetails!.date),

                                        // "Today",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        userMatch.userMatchDetails!.time ?? "",
                                        // "08:30 PM",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [

                                      Text(
                                        userMatch.userMatchDetails
                                            ?.team2Details?.shortName ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),

                                      Image.network(
                                        userMatch.userMatchDetails?.team2Details?.logo ?? 'https://via.placeholder.com/26', // Placeholder URL
                                        height: 36,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/default_team_image.png', height: 26); // Default image
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewState(
                                              matchId: userMatch.userMatchDetails!.id,
                                            ),
                                          ),
                                        );

                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            color: const Color(0xff140B40)
                                                .withOpacity(0.1)),
                                        child: const Center(
                                            child: Text(
                                              "View Stats",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff140B40)),
                                            )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InkWell(

                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => IndVsSaScreens(
                                              Id: userMatch.userMatchDetails!.id.toString(),  // Pass the MatchID from the current widget
                                              matchName: userMatch.userMatchDetails!.matchName.toString(),  // Pass the matchName from the current widget
                                              defaultTabIndex: 2, // Index for "My Teams" tab
                                            ),
                                          ),
                                        );
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            color:
                                            const Color(0xff140B40)),
                                        child: const Center(
                                            child: Text(
                                              "My Team",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),

                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 7),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                          child: const Text(
                            "Indian Premier League",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        )
                      ]),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
