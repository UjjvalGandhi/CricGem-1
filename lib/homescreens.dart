import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:batting_app/screens/viewstate.dart';
import 'package:batting_app/widget/leaugeprovider.dart';
import 'package:batting_app/widget/priceformatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:batting_app/MY_Screen/ipl_all_match.dart';
import 'package:batting_app/screens/country/worldcupmatch.dart';
import 'package:batting_app/screens/ind_vs_sa_screen.dart';
import 'package:batting_app/screens/upcominglistscreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'db/app_db.dart';
import 'model/Homeleagmodel.dart';
import 'model/imp_model.dart';
import 'widget/normaltext.dart';
import 'widget/smalltext.dart';

class HomeScreens extends StatefulWidget {
  final String matchName;
  final String matchID;

  const HomeScreens(
      {super.key, required this.matchName, required this.matchID});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  late Future<IplModel> futureIplModel;
  late Future<HomeLeagModel?> _futureData;
  List<Match> primerMatch = [];
  List<Match> ipl24Match = [];

  // List<Match> wordCupMatch = [];
  List<UpcomingMatchesMatch> upcomingMatch = [];
  List<UserMatchesMatch> myMatch = [];
  String? worldcuptitle;

  List<IplTeam> teams = [];

  late final String matchID;
  late final String matchName;

  late DateTime matchDateTime;
  late Duration remainingTime;

  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m left";
  }

  String _formatMatchDate(DateTime? date) {
    if (date == null) return ""; // Handle null date case

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    // Check if the date is today or tomorrow
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Today";
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return "Tomorrow";
    } else {
      // Format the date as dd-MM-yyyy
      return DateFormat('dd-MM-yyyy').format(date);
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

  Timer? _timer;
  String adjustedTime = '';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<LeagueProvider>(context, listen: false).fetchLeagueData();
    // });
    Provider.of<LeagueProvider>(context, listen: false).fetchLeagueData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String adjustMatchTime(String? originalTime, String? originalDate) {
    if (originalTime == null ||
        originalTime.isEmpty ||
        originalDate == null ||
        originalDate.isEmpty) {
      return ""; // Handle case where time or date is null/empty
    }

    try {
      // Parse the original time (HH:mm) and date (ISO 8601)
      List<String> timeParts = originalTime.split(":");
      int matchHour = int.parse(timeParts[0]);
      int matchMinute = int.parse(timeParts[1]);

      // Parse date as local time, ensuring time zone is respected
      DateTime apiDate = DateTime.parse(originalDate);

      // Combine parsed date and time
      DateTime matchDateTime = DateTime(
        apiDate.year,
        apiDate.month,
        apiDate.day,
        matchHour,
        matchMinute,
      );

      // Get the current local time
      DateTime now = DateTime.now();

      // Calculate the time difference
      Duration difference = matchDateTime.difference(now);

      // Convert difference to hours and minutes
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      print('date and time is :-${hours.abs()}h ${minutes.abs()}m');
      // Format the adjusted time difference
      return "${hours.abs()}h ${minutes.abs()}m";
    } catch (e) {
      print("Error parsing or adjusting time: $e");
      return ""; // Handle any errors gracefully
    }
  }

  Widget _buildLeaugeMatchCard(
      Match match, String team1LogoUrl, String team2LogoUrl) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndVsSaScreens(
              firstMatch: match.team1Details!.shortName,
              secMatch: match.team2Details!.shortName,
              matchName: match.matchName,
              Id: match.id,
            ),
          ),
        );
        // Navigate to Upcoming match details
      },
      child: Stack(children: [
        Container(
          height: 184,
          width: 300,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/card_bg_prev_ui.png"),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(colors: [
              _hexToColor(match.team1Details?.colorCode ?? "#000000"),
              _hexToColor(match.team2Details?.colorCode ?? "#000000"),
            ]),
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      match.team1Details!.shortName.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Image.asset('assets/vs.png', height: 40),
                    const SizedBox(width: 7),
                    Text(
                      match.team2Details!.shortName.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Expanded(
                            //   child: Text(
                            //     match.team1Details?.teamName ?? "",
                            //     textAlign: TextAlign.center,
                            //     maxLines: 2,
                            //     softWrap: true,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: const TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w600,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Text(
                                match.team1Details?.teamName ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    adjustMatchTime(
                                        match.time, match.date.toString()),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffDC0000),
                                    ),
                                  ),
                                  Text(
                                    match.time ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                match.team2Details?.teamName ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Mega contest ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffD4AF37),
                              ),
                            ),
                            PriceDisplay(price: match.megaprice!.toInt()),
                            // Assuming match.megaprice is an int
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 35.h, // Responsive position
          left: 27.w, // Responsive position
          child: Image.network(
            team1LogoUrl,
            height: 55, // Responsive height
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/default_team_image.png', // Fallback image
                height: 63, // Fallback image height
              );
            },
          ),
        ),
        // Positioned(
        //   top: 38.h, // Responsive position
        //   right: 40, // Responsive position
        //   child: Image.network(
        //     team2LogoUrl,
        //     height: 55, // Responsive height
        //     errorBuilder: (context, error, stackTrace) {
        //       return Image.asset(
        //         'assets/default_team_image.png', // Fallback image
        //         height: 63, // Fallback image height
        //       );
        //     },
        //   ),
        // )
        Positioned(
          top: 35.h, // Responsive position
          right: 36.w, // Responsive position
          child: Image.network(
            team2LogoUrl,
            height: 55, // Responsive height
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/default_team_image.png', // Fallback image
                height: 63, // Fallback image height
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildWorldCupMatchCard(Match worldCup) {
    // Match worldCup, String team1LogoUrl, String team2LogoUrl){
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      height: 180,
      // Adjusted height for responsiveness

      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        // Adjusted border radius for responsiveness
        image: const DecorationImage(
          image: AssetImage('assets/card_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Display the main image
                      Image.network(
                        worldCup.team1Details!.captain_photo ?? '',
                        height: MediaQuery.of(context).size.height * 0.15,
                        // width: 133.w,
                        fit: BoxFit.cover,
                      ),
                      // Blurred text area at the bottom
                      Positioned(
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(2),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
                            // Adjust blur intensity as needed
                            child: Container(
                              width: 133.w,
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              // Adjust height for the blurred section
                              color: Colors.black.withOpacity(0.3),
                              // Transparent background to show the blur effect
                              child: Center(
                                child: Text(
                                  worldCup.team1Details!.shortName.toString(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                worldCup.matchName.toString(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff140B40),
                ),
              ),
              const Text(
                "Starts at",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff140B40),
                ),
              ),
              Text(
                "${worldCup.time} PM IST",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff140B40),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                height: 24.h,
                // Adjusted height for responsiveness
                width: 62.w,
                // Adjusted width for responsiveness
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: const Color(0xff140B40),
                ),
                child: const Center(
                  child: Text(
                    "JOIN NOW",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 8.4,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.1),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Display the main image
                    Image.network(
                      worldCup.team2Details!.captain_photo ?? '',
                      height: MediaQuery.of(context).size.height * 0.15,
                      // width: 133.w,
                      fit: BoxFit.cover,
                    ),
                    // Blurred text area at the bottom
                    Positioned(
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          // topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(1),
                          bottomRight: Radius.circular(1),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
                          // Adjust blur intensity as needed
                          child: Container(
                            width: 137.w,
                            height: MediaQuery.of(context).size.height * 0.025,
                            // Adjust height for the blurred section
                            color: Colors.black.withOpacity(0.3),
                            // Transparent background to show the blur effect
                            child: Center(
                              child: Text(
                                worldCup.team2Details!.shortName.toString(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    bool shouldExit = await _showExitConfirmationDialog(context);
    return shouldExit; // Return the boolean result to indicate whether to exit
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 290,
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
                  "Are you sure you want",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "to Exit?",
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
                          // SystemNavigator.pop(); // Close the app if the user confirms exit
                          Navigator.of(context).pop(true); // User pressed Yes
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff010101).withOpacity(0.35),
                          ),
                          child: const Center(
                            child: Text(
                              "Yes",
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

  Future<void> _refreshData() async {
    setState(() {
      // _futureData = profileDisplay(); // Refresh the data
      Provider.of<LeagueProvider>(context, listen: false).fetchLeagueData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leagueProvider = Provider.of<LeagueProvider>(context);
    ScreenUtil.init(context);

    return PopScope(
      canPop: false, // Prevent the default back action
      onPopInvokedWithResult: (didPop, result) async {
        bool shouldExit =
            await _onWillPop(); // Wait for the result from the custom back handler
        if (shouldExit) {
          SystemNavigator.pop(); // Close the app if the user confirms exit
        } else {
          // User pressed "No" - Prevent the back navigation (don't pop the current screen)
          return Future
              .value(); // Prevent popping the current screen and show the dialog again
        }
        // await _showExitConfirmationDialog(context);
      },

      child: Scaffold(
        backgroundColor: const Color(0xffF0F1F5),
        // appBar: Appbarscreen(), // Using your custom app bar here
        body: RefreshIndicator(
            onRefresh: _refreshData,
            child:
                // FutureBuilder(
                //   future: _futureData,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Container(
                //           height: MediaQuery.of(context).size.height,
                //           width: MediaQuery.of(context).size.width,
                //           color: const Color(0xffF0F1F5),
                //           child: const Center(child: CircularProgressIndicator()));
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //     } else if (!snapshot.hasData || snapshot.data == null) {
                //       return const Center(child: Text('No data available'));
                //     } else {
                //       final data = snapshot.data!;
                //       List<List<Match>> leagueMatches = []; // List to hold matches for each league
                //       List<List<Match>> worldcupallmatces = []; // List to hold matches for each league
                //
                //       for (var i = 0; i < data.data!.length; i++) {
                //         var leagueDetails = data.data![i].leagueDetails;
                //         if (leagueDetails != null) {
                //           // leagueMatches.add(leagueDetails.matches?.cast<Match>() ?? []);
                //           // wordCupMatch =
                //           //     data.data?[i].leagueDetails?.matches?.cast<Match>() ?? [];
                //           if (leagueDetails.design == "Design 1" || leagueDetails.design == "Default Design") {
                //             // If design is "Design 1", add matches to leagueMatches
                //             leagueMatches.add(leagueDetails.matches?.cast<Match>() ?? []);
                //           } else if (leagueDetails.design == "Design 2") {
                //             // If design is "Design 2", set wordCupMatch
                //             worldcupallmatces.add(leagueDetails.matches?.cast<Match>() ?? []);
                //             worldcuptitle = leagueDetails.leaguaName;
                //
                //             // wordCupMatch = leagueDetails.matches?.cast<Match>() ?? [];
                //           }
                //         }
                //         // Check for upcoming matches
                //         if (data.data![i].userMatches != null) {
                //           myMatch = data.data?[i].userMatches?.matches
                //               ?.cast<UserMatchesMatch>() ??
                //               [];
                //           print('usermatches is done:-${myMatch.length}');
                //         }
                //
                //         if (data.data![i].upcomingMatches != null) {
                //             upcomingMatch = data.data?[i].upcomingMatches?.matches
                //               ?.cast<UpcomingMatchesMatch>() ??
                //               [];
                //           print('upcoming is done');
                //         }
                //
                //         // Check for user matches
                //
                //       }
                //       print('leauge match with last match :- $leagueMatches');
                //       var withoutLastMatch = leagueMatches.sublist(0, leagueMatches.length - 1);
                //       print('League matches without last match: $withoutLastMatch');
                //       print('leauge match with last match123213 :- $leagueMatches');
                //       print('worldcupmatches are :-${worldcupallmatces.length}');
                //       print('upcoming are :-${upcomingMatch.length}');
                //       print('my matches are :-${myMatch.length}');
                //       print('all matches without last:-${withoutLastMatch.length}');
                //
                //       return SingleChildScrollView(
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           color: const Color(0xffF0F1F5),
                //           child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 const SizedBox(
                //                   height: 15,
                //                 ),
                //                 for (int i = 0; i < leagueMatches.length ; i++) ...[
                //                   if (leagueMatches[i].isNotEmpty) ...[
                //                     InkWell(
                //                       onTap: () {
                //                         Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder: (context) => IplAllMatch(
                //                               leagueId: leagueMatches[i].first.leagueId,
                //                               leagueName: data.data![i].leagueDetails!.leaguaName.toString(), // Update this line
                //                             ),
                //                           ),
                //                         );
                //                       },
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           NormalText(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.black,
                //                             text: data
                //                                 .data![i].leagueDetails!.leaguaName
                //                                 .toString(),
                //                           ),
                //                           Row(
                //                             children: [
                //                               SmallText(
                //                                   color: Colors.grey, text: "View All"),
                //                               Icon(Icons.arrow_forward_ios,
                //                                   size: 18.sp, color: Colors.grey),
                //                             ],
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     const SizedBox(height: 10),
                //                     SizedBox(
                //                       height: 186, // Responsive height
                //                       width: MediaQuery.of(context).size.width,
                //                       child: ListView.builder(
                //                         shrinkWrap: true,
                //                         scrollDirection: Axis.horizontal,
                //                         itemCount: leagueMatches[i].length,
                //                         itemBuilder: (context, index) {
                //                           final match = leagueMatches[i][index];
                //                           DateTime? matchDate = match.date;
                //                           final DateFormat dateFormatter =
                //                               DateFormat('yyyy-MM-dd');
                //                           String formattedDate = matchDate != null
                //                               ? dateFormatter.format(matchDate)
                //                               : '';
                //                           final team1LogoUrl =
                //                               match.team1Details?.logo ?? '';
                //                           final team2LogoUrl =
                //                               match.team2Details?.logo ?? '';
                //
                //                           // Check the league type and render accordingly
                //                           print('how many team is there :-${withoutLastMatch.length} , $i');
                //                           return _buildLeaugeMatchCard(
                //                               match, team1LogoUrl, team2LogoUrl);
                //                         },
                //                       ),
                //                     ),
                //                     const SizedBox(height: 15),
                //                   ],
                //                   ],
                //                 for (int i = 0; i < worldcupallmatces.length ; i++) ...[
                //
                //                   if (worldcupallmatces.isNotEmpty) ...[
                //                   InkWell(
                //                     onTap: () {
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder: (context) => WorldcupMatch(
                //                               leagueId: worldcupallmatces[i].first.leagueId,
                //                                 leagueName : worldcuptitle!,
                //                             ),
                //                           ));
                //                     },
                //                     child: Row(
                //                       mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         NormalText(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.black,
                //                             text:
                //                              // worldcupallmatces[i].first.
                //                             worldcupallmatces[i].first.matchName! ?? ''
                //                         ),
                //                         Row(
                //
                //                           children: [
                //
                //                             SmallText(
                //                                 color: Colors.grey, text: "View All"),
                //                             const Icon(
                //                               Icons.arrow_forward_ios,
                //                               size: 18,
                //                               color: Colors.grey,
                //                             )
                //                           ],
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //
                //                 const SizedBox(
                //                   height: 10,
                //                 ),
                //                 SizedBox(
                //                   // height: MediaQuery.of(context).size.height *0.3,
                //                   height: worldcupallmatces.isNotEmpty ? 180 : 0,
                //                   width: MediaQuery.of(context).size.width *
                //                       12, // Full width of the container
                //                   child: worldcupallmatces
                //                       .isNotEmpty // Check if myMatch is not empty
                //                       ? ListView.builder(
                //                     itemCount: worldcupallmatces.length,
                //                     // scrollDirection: Axis.horizontal,
                //
                //                     shrinkWrap: true,
                //                     physics:
                //                     const NeverScrollableScrollPhysics(),
                //                     // scrollDirection: Axis.horizontal,
                //                     itemBuilder: (context, index) {
                //                       final worldCup = worldcupallmatces[i][index];
                //                       return InkWell(
                //                         onTap: () {
                //                           Navigator.push(
                //                             context,
                //                             MaterialPageRoute(
                //                               builder: (context) =>
                //                                   IndVsSaScreens(
                //                                     firstMatch: worldCup
                //                                         .team1Details!.shortName,
                //                                     secMatch: worldCup
                //                                         .team2Details!.shortName,
                //                                     matchName: worldCup.matchName,
                //                                     Id: worldCup.id,
                //                                   ),
                //                             ),
                //                           );
                //                         },
                //                         child:
                //                         _buildWorldCupMatchCard(worldCup),
                //                       );
                //                     },
                //                   )
                //                       : const SizedBox(),
                //                 ),
                //                 SizedBox(
                //                   height: 15.h,
                //                 ),
                //                 ],
                //                 if (upcomingMatch.isNotEmpty) ...[
                //                   InkWell(
                //                     onTap: () {
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder: (context) =>
                //                             const Upcominglistscreen(),
                //                           ));
                //                     },
                //                     child: Row(
                //                       mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         NormalText(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.black,
                //                             text: "Upcoming Matches"),
                //                         Row(
                //                           children: [
                //                             SmallText(
                //                                 color: Colors.grey,
                //                                 text: "View All"),
                //                             Icon(
                //                               Icons.arrow_forward_ios,
                //                               size: 18.sp,
                //                               color: Colors.grey,
                //                             )
                //                           ],
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ] else ...[
                //                   const SizedBox(),
                //                 ],
                //                 SizedBox(
                //                   height: 10.h,
                //                 ),
                //                 InkWell(
                //                   onTap: () {
                //                     // Navigator.push(context, MaterialPageRoute(builder: (context)=> Contestscrenn()));
                //                   },
                //                   child: SizedBox(
                //                     height: upcomingMatch.isNotEmpty ? 165.h : 0,
                //                     // Responsive height using ScreenUtil
                //                     child: upcomingMatch
                //                         .isNotEmpty // Check if myMatch is not empty
                //                         ? ListView.builder(
                //                       itemCount: upcomingMatch.length,
                //                       scrollDirection: Axis.horizontal,
                //                       itemBuilder: (context, index) {
                //                         final upcoming = upcomingMatch[index];
                //                         return InkWell(
                //                           onTap: () {
                //                             Navigator.push(
                //                               context,
                //                               MaterialPageRoute(
                //                                 builder: (context) =>
                //                                     IndVsSaScreens(
                //                                       firstMatch: upcoming
                //                                           .matchDetails!
                //                                           .team1Details!
                //                                           .shortName,
                //                                       secMatch: upcoming
                //                                           .matchDetails!
                //                                           .team2Details!
                //                                           .shortName,
                //                                       matchName: upcoming
                //                                           .matchDetails!
                //                                           .matchName,
                //                                       Id: upcoming
                //                                           .matchDetails!.id,
                //                                     ),
                //                               ),
                //                             );
                //                           },
                //                           child: Container(
                //                             height: 150.h,
                //                             // Responsive height using ScreenUtil
                //                             margin:
                //                             EdgeInsets.only(right: 15.r),
                //                             // Responsive margin
                //                             width: 291.w,
                //                             // Responsive width using ScreenUtil
                //                             decoration: BoxDecoration(
                //                               borderRadius:
                //                               BorderRadius.circular(12.r),
                //                               // Responsive border radius
                //                               color: Colors.white,
                //                             ),
                //                             child: Column(
                //                               mainAxisAlignment:
                //                               MainAxisAlignment
                //                                   .spaceBetween,
                //                               children: [
                //                                 Container(
                //                                   height: 30.h,
                //                                   // Responsive height using ScreenUtil
                //                                   width: double.infinity,
                //                                   padding: EdgeInsets.only(
                //                                       left: 15.r, top: 7.r),
                //                                   // Responsive padding
                //                                   decoration: BoxDecoration(
                //                                     color: Colors.black
                //                                         .withOpacity(0.1),
                //                                     borderRadius:
                //                                     BorderRadius.only(
                //                                       topLeft:
                //                                       Radius.circular(
                //                                           12.r),
                //                                       topRight:
                //                                       Radius.circular(
                //                                           12.r),
                //                                     ),
                //                                   ),
                //                                   child: Text(
                //                                     "Indian Premier League",
                //                                     style: TextStyle(
                //                                       fontSize: 12.sp,
                //                                       // Responsive font size
                //                                       fontWeight:
                //                                       FontWeight.w500,
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Padding(
                //                                   padding:
                //                                   EdgeInsets.symmetric(
                //                                       horizontal: 12.w),
                //                                   // Responsive padding
                //                                   child: Row(
                //                                     children: [
                //                                       Image.network(
                //                                         upcoming
                //                                             .matchDetails
                //                                             ?.team1Details!
                //                                             .logo ??
                //                                             'https://via.placeholder.com/150',
                //                                         height: 36.h,
                //                                         // Responsive image height
                //                                         errorBuilder:
                //                                             (context, error,
                //                                             stackTrace) {
                //                                           return Image.asset(
                //                                             'assets/default_team_image.png',
                //                                             height: 36
                //                                                 .h, // Fallback image height
                //                                           );
                //                                         },
                //                                       ),
                //                                       SizedBox(width: 7.w),
                //                                       // Responsive spacing
                //                                       Text(
                //                                         upcoming
                //                                             .matchDetails!
                //                                             .team1Details!
                //                                             .shortName ??
                //                                             "",
                //                                         style: TextStyle(
                //                                           fontSize: 14.sp,
                //                                           // Responsive font size
                //                                           fontWeight:
                //                                           FontWeight.w500,
                //                                         ),
                //                                       ),
                //                                       const Spacer(),
                //                                       Column(
                //                                         children: [
                //                                           Text(
                //                                             // upcoming!.matchDetails!.date!.toString() ?? "",
                //                                             _formatMatchDate(
                //                                                 upcoming
                //                                                     .matchDetails!
                //                                                     .date),
                //
                //                                             // "Today",
                //                                             style: TextStyle(
                //                                               fontWeight:
                //                                               FontWeight
                //                                                   .w400,
                //                                               fontSize: 12.sp,
                //                                               // Responsive font size
                //                                               color:
                //                                               Colors.grey,
                //                                             ),
                //                                           ),
                //                                           Text(
                //                                             upcoming.matchDetails!
                //                                                 .time ??
                //                                                 "",
                //                                             style: TextStyle(
                //                                               fontWeight:
                //                                               FontWeight
                //                                                   .w500,
                //                                               fontSize: 14.sp,
                //                                               // Responsive font size
                //                                               color:
                //                                               Colors.red,
                //                                             ),
                //                                           ),
                //                                         ],
                //                                       ),
                //                                       const Spacer(),
                //                                       Text(
                //                                         upcoming
                //                                             .matchDetails!
                //                                             .team2Details!
                //                                             .shortName ??
                //                                             "",
                //                                         style: TextStyle(
                //                                           fontSize: 14.sp,
                //                                           // Responsive font size
                //                                           fontWeight:
                //                                           FontWeight.w500,
                //                                         ),
                //                                       ),
                //                                       SizedBox(width: 7.w),
                //                                       // Responsive spacing
                //                                       Image.network(
                //                                         upcoming
                //                                             .matchDetails
                //                                             ?.team2Details!
                //                                             .logo ??
                //                                             'https://via.placeholder.com/150',
                //                                         height: 36.h,
                //                                         // Responsive image height
                //                                         errorBuilder:
                //                                             (context, error,
                //                                             stackTrace) {
                //                                           return Image.asset(
                //                                             'assets/default_team_image.png',
                //                                             height: 36.h, // Fallback image height
                //                                           );
                //                                         },
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                                 Divider(
                //                                   height: 1.h,
                //                                   // Responsive divider height
                //                                   color: Colors.grey.shade300,
                //                                 ),
                //                                 Padding(
                //                                   padding:
                //                                   EdgeInsets.symmetric(
                //                                       horizontal: 6.w),
                //                                   // Responsive padding
                //                                   child: Container(
                //                                     padding:
                //                                     EdgeInsets.symmetric(
                //                                         vertical: 12.h),
                //                                     // Responsive padding
                //                                     width: double.infinity,
                //                                     decoration: BoxDecoration(
                //                                       borderRadius:
                //                                       BorderRadius
                //                                           .circular(8.r),
                //                                       // Responsive border radius
                //                                       color: const Color(
                //                                           0xff140B40),
                //                                     ),
                //                                     child: Center(
                //                                       child: Text(
                //                                         "Join Now",
                //                                         style: TextStyle(
                //                                           fontSize: 12.sp,
                //                                           // Responsive font size
                //                                           fontWeight:
                //                                           FontWeight.w500,
                //                                           color: Colors.white,
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: 1.h),
                //                               ],
                //                             ),
                //                           ),
                //                         );
                //                       },
                //                     )
                //                         : const SizedBox(),
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   height: 15.h,
                //                 ),
                //                 if (myMatch.isNotEmpty) ...[
                //                   Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       NormalText(
                //                           fontWeight: FontWeight.w600,
                //                           color: Colors.black,
                //                           text: "My Matches"),
                //                       // InkWell(
                //                       //   onTap: () {
                //                       //     Navigator.push(
                //                       //         context,
                //                       //         MaterialPageRoute(
                //                       //             builder: (context) =>
                //                       //             const MyMatchesViewall()));
                //                       //   },
                //                       //   child: Row(
                //                       //     children: [
                //                       //       SmallText(
                //                       //           color: Colors.grey,
                //                       //           text: "View All"),
                //                       //       Icon(
                //                       //         Icons.arrow_forward_ios,
                //                       //         size: 18.sp,
                //                       //         color: Colors.grey,
                //                       //       )
                //                       //     ],
                //                       //   ),
                //                       // )
                //                     ],
                //                   ),
                //                 ] else ...[
                //                   const SizedBox(),
                //                 ],
                //                 SizedBox(
                //                   height: 10.h,
                //                 ),
                //                 SizedBox(
                //                   height: myMatch.isNotEmpty
                //                       ? 160 // Use ScreenUtil's height unit for responsive sizing
                //                       : 0, // Set height to 0 if myMatch is empty
                //                   child: myMatch.isNotEmpty // Check if myMatch is not empty
                //                       ? ListView.builder(
                //                     itemCount: myMatch.length,
                //                     scrollDirection: Axis.horizontal,
                //                     itemBuilder: (context, index) {
                //                       final userMatch = myMatch[index];
                //                       return Center(
                //                         child: Container(
                //                           margin: EdgeInsets.only(right: 15.r), // Use r for responsive margin
                //                           width: 295.w, // Use w for responsive width
                //                           decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(12.r),
                //                             color: Colors.white,
                //                           ),
                //                           child:
                //                           Column(
                //                             crossAxisAlignment: CrossAxisAlignment.center,
                //                             children: [
                //                               Container(
                //                                 height: 30.h,
                //                                 width: double.infinity,
                //                                 padding: EdgeInsets.symmetric(horizontal: 15.r),
                //                                 decoration: BoxDecoration(
                //                                   color: Colors.black.withOpacity(0.1),
                //                                   borderRadius: BorderRadius.only(
                //                                     topLeft: Radius.circular(12.r),
                //                                     topRight: Radius.circular(12.r),
                //                                   ),
                //                                 ),
                //                                 child: Row(
                //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                                   crossAxisAlignment: CrossAxisAlignment.center,
                //                                   children: [
                //                                     Text(
                //                                       "Indian Premier League",
                //                                       style: TextStyle(
                //                                         fontSize: 12.sp, // Use sp for responsive text size
                //                                         fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                               SizedBox(height: 12.h),
                //                               Padding(
                //                                 padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 2.r),
                //                                 child: Column(
                //                                   children: [
                //                                     Row(
                //                                       children: [
                //                                         SizedBox(width: 8.w), // Use w for responsive width
                //                                         Image.network(
                //                                           userMatch.userMatchDetails?.team1Details?.logo ??
                //                                               'https://via.placeholder.com/26',
                //                                           height: 36.h, // Use h for responsive height
                //                                           errorBuilder: (context, error, stackTrace) {
                //                                             return Image.asset(
                //                                               'assets/default_team_image.png',
                //                                               height: 26.h,
                //                                             );
                //                                           },
                //                                         ),
                //                                         SizedBox(width: 8.w),
                //                                         Text(
                //                                           userMatch.userMatchDetails?.team1Details?.shortName ?? "",
                //                                           style: TextStyle(
                //                                             fontSize: 14.sp, // Use sp for responsive text size
                //                                             fontWeight: FontWeight.w500,
                //                                           ),
                //                                         ),
                //                                         const Spacer(),
                //                                         Column(
                //                                           children: [
                //                                             Text(
                //                                               _formatMatchDate(userMatch.userMatchDetails!.date),
                //                                               style: TextStyle(
                //                                                 fontWeight: FontWeight.w400,
                //                                                 fontSize: 12.sp, // Use sp for responsive text size
                //                                                 color: Colors.grey,
                //                                               ),
                //                                             ),
                //                                             Text(
                //                                               userMatch.userMatchDetails?.time ?? "",
                //                                               style: TextStyle(
                //                                                 fontWeight: FontWeight.w400,
                //                                                 fontSize: 12.sp, // Use sp for responsive text size
                //                                                 color: Colors.red,
                //                                               ),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                         const Spacer(),
                //                                         Text(
                //                                           userMatch.userMatchDetails?.team2Details?.shortName ?? "",
                //                                           style: TextStyle(
                //                                             fontSize: 14.sp, // Use sp for responsive text size
                //                                             fontWeight: FontWeight.w500,
                //                                           ),
                //                                         ),
                //                                         SizedBox(width: 8.w),
                //                                         Image.network(
                //                                           userMatch.userMatchDetails?.team2Details?.logo ??
                //                                               'https://via.placeholder.com/26',
                //                                           height: 36.h, // Use h for responsive height
                //                                           errorBuilder: (context, error, stackTrace) {
                //                                             return Image.asset(
                //                                               'assets/default_team_image.png',
                //                                               height: 26.h,
                //                                             );
                //                                           },
                //                                         ),
                //                                       ],
                //                                     ),
                //                                     SizedBox(height: 12.h),
                //                                     Divider(
                //                                       height: 1.h, // Use h for responsive height
                //                                       color: Colors.grey.shade300,
                //                                     ),
                //                                     SizedBox(height: 12.h),
                //                                     Row(
                //                                       children: [
                //                                         Expanded(
                //                                           child: Container(
                //                                             padding: const EdgeInsets.all(10),
                //                                             decoration: BoxDecoration(
                //                                               borderRadius: BorderRadius.circular(5.r),
                //                                               color: const Color(0xff140B40).withOpacity(0.1),
                //                                             ),
                //                                             child: InkWell(
                //                                               onTap: () {
                //                                                 Navigator.push(
                //                                                   context,
                //                                                   MaterialPageRoute(
                //                                                     builder: (context) => ViewState(
                //                                                       matchId: userMatch.userMatchDetails!.id,
                //                                                     ),
                //                                                   ),
                //                                                 );
                //                                               },
                //                                               child: Center(
                //                                                 child: Text(
                //                                                   "View Stats",
                //                                                   style: TextStyle(
                //                                                     fontSize: 12.sp, // Use sp for responsive text size
                //                                                     fontWeight: FontWeight.w500,
                //                                                     color: const Color(0xff140B40),
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                           ),
                //                                         ),
                //                                         SizedBox(width: 10.w),
                //                                         Expanded(
                //                                           child: InkWell(
                //                                             onTap: () {
                //                                               Navigator.push(
                //                                                 context,
                //                                                 MaterialPageRoute(
                //                                                   builder: (context) => IndVsSaScreens(
                //                                                     Id: userMatch.userMatchDetails!.id.toString(),
                //                                                     matchName: userMatch.userMatchDetails!.matchName.toString(),
                //                                                     defaultTabIndex: 2,
                //                                                   ),
                //                                                 ),
                //                                               );
                //                                             },
                //                                             child: Container(
                //                                               padding: const EdgeInsets.all(10),
                //                                               decoration: BoxDecoration(
                //                                                 borderRadius: BorderRadius.circular(5.r),
                //                                                 color: const Color(0xff140B40),
                //                                               ),
                //                                               child: Center(
                //                                                 child: Text(
                //                                                   "My Team",
                //                                                   style: TextStyle(
                //                                                     fontSize: 12.sp, // Use sp for responsive text size
                //                                                     fontWeight: FontWeight.w500,
                //                                                     color: Colors.white,
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       );
                //                     },
                //                   )
                //                       : const SizedBox(), // Return an empty SizedBox if myMatch is empty
                //                 ),
                //
                //                 SizedBox(
                //                   height: 20.h,
                //                 )
                //                 ]
                //               // ]
                //           ),
                //         ),
                //       );
                //     }
                //   },
                // ),
                Consumer<LeagueProvider>(
              builder: (context, leagueProvider, child) {
                if (leagueProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (leagueProvider.errorMessage != null) {
                  return Center(
                      child: Text('Error: ${leagueProvider.errorMessage}'));
                } else if (leagueProvider.data == null) {
                  return const Center(child: Text('No data available'));
                } else {
                  final data = leagueProvider.data!;
                  List<List<Match>> leagueMatches = [];
                  List<List<Match>> worldcupallmatces = [];

                  for (var i = 0; i < data.data!.length; i++) {
                    var leagueDetails = data.data![i].leagueDetails;
                    if (leagueDetails != null) {
                      if (leagueDetails.design == "Design 1" ||
                          leagueDetails.design == "Default Design") {
                        leagueMatches
                            .add(leagueDetails.matches?.cast<Match>() ?? []);
                      } else if (leagueDetails.design == "Design 2") {
                        worldcupallmatces
                            .add(leagueDetails.matches?.cast<Match>() ?? []);
                        worldcuptitle = leagueDetails.leaguaName;
                      }
                    }

                    if (data.data![i].userMatches != null) {
                      myMatch = data.data?[i].userMatches?.matches
                              ?.cast<UserMatchesMatch>() ??
                          [];
                      print('usermatches is done:-${myMatch.length}');
                    }

                    if (data.data![i].upcomingMatches != null) {
                      upcomingMatch = data.data?[i].upcomingMatches?.matches
                              ?.cast<UpcomingMatchesMatch>() ??
                          [];
                      print('upcoming is done');
                    }
                  }
                  if (leagueMatches.isEmpty && worldcupallmatces.isEmpty && upcomingMatch.isEmpty && myMatch.isEmpty) {
                    return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No Matches Available..☺️"),
                            SizedBox(height: 5,),
                            Text("We Update You Soon!!!!")
                          ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: const Color(0xffF0F1F5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          for (int i = 0; i < leagueMatches.length; i++) ...[
                            if (leagueMatches[i].isNotEmpty) ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IplAllMatch(
                                        leagueId:
                                            leagueMatches[i].first.leagueId,
                                        leagueName: data
                                            .data![i].leagueDetails!.leaguaName
                                            .toString(), // Update this line
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: data
                                          .data![i].leagueDetails!.leaguaName
                                          .toString(),
                                    ),
                                    Row(
                                      children: [
                                        SmallText(
                                            color: Colors.grey,
                                            text: "View All"),
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 18, color: Colors.grey),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 186,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: leagueMatches[i].length,
                                  itemBuilder: (context, index) {
                                    final match = leagueMatches[i][index];
                                    final team1LogoUrl =
                                        match.team1Details?.logo ?? '';
                                    final team2LogoUrl =
                                        match.team2Details?.logo ?? '';
                                    return _buildLeaugeMatchCard(
                                        match, team1LogoUrl, team2LogoUrl);
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
                          for (int i = 0;
                              i < worldcupallmatces.length;
                              i++) ...[
                            if (worldcupallmatces.isNotEmpty) ...[
                              InkWell(
                                onTap: () {
                                  // Navigate to World Cup match details
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorldcupMatch(
                                          leagueId: worldcupallmatces[i]
                                              .first
                                              .leagueId,
                                          leagueName: worldcuptitle!,
                                        ),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: worldcupallmatces[i]
                                              .first
                                              .matchName ??
                                          '',
                                    ),
                                    Row(
                                      children: [
                                        SmallText(
                                            color: Colors.grey,
                                            text: "View All"),
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 18, color: Colors.grey),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: worldcupallmatces[i].length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final worldCup =
                                        worldcupallmatces[i][index];
                                    return InkWell(
                                      onTap: () {
                                        // Navigate to World Cup match details
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                IndVsSaScreens(
                                              firstMatch: worldCup
                                                  .team1Details!.shortName,
                                              secMatch: worldCup
                                                  .team2Details!.shortName,
                                              matchName: worldCup.matchName,
                                              Id: worldCup.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: _buildWorldCupMatchCard(worldCup),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
                          if (upcomingMatch.isNotEmpty) ...[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Upcominglistscreen(),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  NormalText(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      text: "Upcoming Matches"),
                                  Row(
                                    children: [
                                      SmallText(
                                          color: Colors.grey, text: "View All"),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18.sp,
                                        color: Colors.grey,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ] else ...[
                            const SizedBox(),
                          ],
                          SizedBox(
                            height: 10.h,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> Contestscrenn()));
                            },
                            child: SizedBox(
                              height: upcomingMatch.isNotEmpty ? 165.h : 0,
                              // Responsive height using ScreenUtil
                              child: upcomingMatch
                                      .isNotEmpty // Check if myMatch is not empty
                                  ? ListView.builder(
                                      itemCount: upcomingMatch.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final upcoming = upcomingMatch[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IndVsSaScreens(
                                                  firstMatch: upcoming
                                                      .matchDetails!
                                                      .team1Details!
                                                      .shortName,
                                                  secMatch: upcoming
                                                      .matchDetails!
                                                      .team2Details!
                                                      .shortName,
                                                  matchName: upcoming
                                                      .matchDetails!.matchName,
                                                  Id: upcoming.matchDetails!.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 150.h,
                                            // Responsive height using ScreenUtil
                                            margin:
                                                EdgeInsets.only(right: 15.r),
                                            // Responsive margin
                                            width: 291.w,
                                            // Responsive width using ScreenUtil
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              // Responsive border radius
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 30.h,
                                                  // Responsive height using ScreenUtil
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                      left: 15.r, top: 7.r),
                                                  // Responsive padding
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12.r),
                                                      topRight:
                                                          Radius.circular(12.r),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    upcoming.matchDetails!.matchName! ?? '',
                                                    // "Indian Premier League",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      // Responsive font size
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w),
                                                  // Responsive padding
                                                  child: Row(
                                                    children: [
                                                      Image.network(
                                                        upcoming
                                                                .matchDetails
                                                                ?.team1Details!
                                                                .logo ??
                                                            'https://via.placeholder.com/150',
                                                        height: 36.h,
                                                        // Responsive image height
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/default_team_image.png',
                                                            height: 36
                                                                .h, // Fallback image height
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(width: 7.w),
                                                      // Responsive spacing
                                                      Text(
                                                        upcoming
                                                                .matchDetails!
                                                                .team1Details!
                                                                .shortName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          // Responsive font size
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            // upcoming!.matchDetails!.date!.toString() ?? "",
                                                            _formatMatchDate(
                                                                upcoming
                                                                    .matchDetails!
                                                                    .date),

                                                            // "Today",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12.sp,
                                                              // Responsive font size
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            upcoming.matchDetails!
                                                                    .time ??
                                                                "",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14.sp,
                                                              // Responsive font size
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        upcoming
                                                                .matchDetails!
                                                                .team2Details!
                                                                .shortName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          // Responsive font size
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: 7.w),
                                                      // Responsive spacing
                                                      Image.network(
                                                        upcoming
                                                                .matchDetails
                                                                ?.team2Details!
                                                                .logo ??
                                                            'https://via.placeholder.com/150',
                                                        height: 36.h,
                                                        // Responsive image height
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/default_team_image.png',
                                                            height: 36
                                                                .h, // Fallback image height
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1.h,
                                                  // Responsive divider height
                                                  color: Colors.grey.shade300,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.w),
                                                  // Responsive padding
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    // Responsive padding
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      // Responsive border radius
                                                      color: const Color(
                                                          0xff140B40),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Join Now",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          // Responsive font size
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          if (myMatch.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NormalText(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    text: "My Matches"),
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //             const MyMatchesViewall()));
                                //   },
                                //   child: Row(
                                //     children: [
                                //       SmallText(
                                //           color: Colors.grey,
                                //           text: "View All"),
                                //       Icon(
                                //         Icons.arrow_forward_ios,
                                //         size: 18.sp,
                                //         color: Colors.grey,
                                //       )
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ] else ...[
                            const SizedBox(),
                          ],
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: myMatch.isNotEmpty
                                ? 155
                                    .h // Use ScreenUtil's height unit for responsive sizing
                                : 0, // Set height to 0 if myMatch is empty
                            child: myMatch
                                    .isNotEmpty // Check if myMatch is not empty
                                ? ListView.builder(
                                    itemCount: myMatch.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final userMatch = myMatch[index];
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 15.r),
                                          // Use r for responsive margin
                                          width: 295.w,
                                          // Use w for responsive width
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 30.h,
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.r),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12.r),
                                                    topRight:
                                                        Radius.circular(12.r),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Indian Premier League",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        // Use sp for responsive text size
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 12.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.r,
                                                    vertical: 2.r),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 8.w),
                                                        // Use w for responsive width
                                                        Image.network(
                                                          userMatch
                                                                  .userMatchDetails
                                                                  ?.team1Details
                                                                  ?.logo ??
                                                              'https://via.placeholder.com/26',
                                                          height: 36.h,
                                                          // Use h for responsive height
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/default_team_image.png',
                                                              height: 26.h,
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        Text(
                                                          userMatch
                                                                  .userMatchDetails
                                                                  ?.team1Details
                                                                  ?.shortName ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            // Use sp for responsive text size
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              _formatMatchDate(
                                                                  userMatch
                                                                      .userMatchDetails!
                                                                      .date),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.sp,
                                                                // Use sp for responsive text size
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Text(
                                                              userMatch
                                                                      .userMatchDetails
                                                                      ?.time ??
                                                                  "",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.sp,
                                                                // Use sp for responsive text size
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          userMatch
                                                                  .userMatchDetails
                                                                  ?.team2Details
                                                                  ?.shortName ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            // Use sp for responsive text size
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        Image.network(
                                                          userMatch
                                                                  .userMatchDetails
                                                                  ?.team2Details
                                                                  ?.logo ??
                                                              'https://via.placeholder.com/26',
                                                          height: 36.h,
                                                          // Use h for responsive height
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/default_team_image.png',
                                                              height: 26.h,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    Divider(
                                                      height: 1.h,
                                                      // Use h for responsive height
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                              color: const Color(
                                                                      0xff140B40)
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewState(
                                                                      matchId: userMatch
                                                                          .userMatchDetails!
                                                                          .id,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  "View Stats",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    // Use sp for responsive text size
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                        0xff140B40),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          IndVsSaScreens(
                                                                    Id: userMatch
                                                                        .userMatchDetails!
                                                                        .id
                                                                        .toString(),
                                                                    matchName: userMatch
                                                                        .userMatchDetails!
                                                                        .matchName
                                                                        .toString(),
                                                                    defaultTabIndex:
                                                                        2,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.r),
                                                                color: const Color(
                                                                    0xff140B40),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "My Team",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    // Use sp for responsive text size
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white,
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
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(), // Return an empty SizedBox if myMatch is empty
                          ),

                          SizedBox(
                            height: 20.h,
                          )
                          // Additional sections for upcoming matches and user matches can be added here
                        ],
                      ),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}

// String adjustMatchTime(String? originalTime) {
//   if (originalTime == null || originalTime.isEmpty) {
//     return ""; // Handle case where time is null or empty
//   }
//
//   try {
//     // Parse the original time assuming it's in "HH:mm" format
//     List<String> parts = originalTime.split(":");
//     int matchHour = int.parse(parts[0]);
//     int matchMinute = int.parse(parts[1]);
//
//     // Get the current time
//     DateTime now = DateTime.now();
//     int currentHour = now.hour;
//     int currentMinute = now.minute;
//
//     // Calculate the time difference in minutes
//     int differenceMinutes =
//         (matchHour - currentHour) * 60 + (matchMinute - currentMinute);
//     // Convert minutes difference to hours and minutes
//     int hours = differenceMinutes ~/ 60; // integer division
//     int minutes = differenceMinutes % 60;
//
//     // Determine if the match is ahead or ago
//     String timeStatus = differenceMinutes >= 0 ? "ahead" : "ago";
//     print('Time status:-$timeStatus');
//     print('time started:-${hours.abs()}h ${minutes.abs()}m');
//     // Format the adjusted time difference
//     return "${hours.abs()}h ${minutes.abs()}m";
//   } catch (e) {
//     print("Error parsing or adjusting time: $e");
//     return ""; // Handle any errors gracefully
//   }
// }
// Positioned(
//   top: 35, // Responsive position
//   left: 20, // Responsive position
//   child: Image.network(
//     team1LogoUrl,
//     height: 55, // Responsive height
//   ),
// ),
// Positioned(
//   top: 40, // Responsive position
//   right: 27, // Responsive position
//   child: Image.network(
//     team2LogoUrl,
//     height: 50, // Responsive height
//   )
// ),
// primerMatch =
//     data.data?[0].leagueDetails?.matches?.cast<Match>() ?? [];
// ipl24Match =
//     data.data?[1].leagueDetails?.matches?.cast<Match>() ?? [];

// upcomingMatch = data.data?[3].upcomingMatches?.matches
//         ?.cast<UpcomingMatchesMatch>() ??
//     [];
// myMatch = data.data?[4].userMatches?.matches
//         ?.cast<UserMatchesMatch>() ??
//     [];
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => IplAllMatch(
//         leagueId:
//             leagueMatches[i].first.leagueId),
//     leagueName: data
//         .data![i].leagueDetails!.leaguaName
//         .toString(),
//   ),
// );
// Check if leagueMatches length exceeds i before showing wordCupMatch
// if (i == withoutLastMatch.length &&
//     wordCupMatch.isNotEmpty) ...[

// else ...[
//   const SizedBox(),
// ],
// if (i == leagueMatches.length - 1) ...[
//for (int i = 0; i < leagueMatches.length; i++) ...[
//                           if (leagueMatches[i].isNotEmpty) ...[
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => IplAllMatch(
//                                         leagueId:
//                                             leagueMatches[i].first.leagueId),
//                                   ),
//                                 );
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   NormalText(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                     text: data
//                                         .data![i].leagueDetails!.leaguaName
//                                         .toString(),
//                                   ),
//                                   Row(
//                                     children: [
//                                       SmallText(
//                                           color: Colors.grey, text: "View All"),
//                                       Icon(Icons.arrow_forward_ios,
//                                           size: 18.sp, color: Colors.grey),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             SizedBox(
//                               height: 186, // Responsive height
//                               width: MediaQuery.of(context).size.width,
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: leagueMatches[i].length,
//                                 itemBuilder: (context, index) {
//                                   final match = leagueMatches[i][index];
//                                   DateTime? matchDate = match.date;
//                                   final DateFormat dateFormatter =
//                                       DateFormat('yyyy-MM-dd');
//                                   String formattedDate = matchDate != null
//                                       ? dateFormatter.format(matchDate)
//                                       : '';
//                                   final team1LogoUrl =
//                                       match.team1Details?.logo ?? '';
//                                   final team2LogoUrl =
//                                       match.team2Details?.logo ?? '';
//
//                                   // Check the league type and render accordingly
//
//                                   return _buildUpcomingMatchCard(
//                                       match, team1LogoUrl, team2LogoUrl);
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                           ],
//
//                           // Check if leagueMatches length exceeds i before showing wordCupMatch
//                           if (i == leagueMatches.length - 1 &&
//                               wordCupMatch.isNotEmpty) ...[
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => WorldcupMatch(
//                                         leagueId: wordCupMatch.first.leagueId,
//                                       ),
//                                     ));
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   NormalText(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                       text: data.data?[2].leagueDetails
//                                               ?.leaguaName ??
//                                           ""),
//                                   Row(
//                                     children: [
//                                       SmallText(
//                                           color: Colors.grey, text: "View All"),
//                                       const Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 18,
//                                         color: Colors.grey,
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ] else ...[
//                             const SizedBox(),
//                           ],
//                           if (i == leagueMatches.length - 1) ...[
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             SizedBox(
//                               // height: MediaQuery.of(context).size.height *0.3,
//                               height: wordCupMatch.isNotEmpty ? 180 : 0,
//                               width: MediaQuery.of(context).size.width *
//                                   12, // Full width of the container
//                               child: wordCupMatch
//                                       .isNotEmpty // Check if myMatch is not empty
//                                   ? ListView.builder(
//                                       itemCount: wordCupMatch.length,
//                                       // scrollDirection: Axis.horizontal,
//
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       // scrollDirection: Axis.horizontal,
//                                       itemBuilder: (context, index) {
//                                         final worldCup = wordCupMatch[index];
//                                         return InkWell(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     IndVsSaScreens(
//                                                   firstMatch: worldCup
//                                                       .team1Details!.shortName,
//                                                   secMatch: worldCup
//                                                       .team2Details!.shortName,
//                                                   matchName: worldCup.matchName,
//                                                   Id: worldCup.id,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
//                                             height: 180,
//                                             // Adjusted height for responsiveness
//
//                                             // width: double.infinity,
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(10.r),
//                                               // Adjusted border radius for responsiveness
//                                               image: const DecorationImage(
//                                                 image: AssetImage(
//                                                     'assets/card_bg.png'),
//                                                 fit: BoxFit.cover,
//                                                 opacity: 0.1,
//                                               ),
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               children: [
//                                                 Expanded(
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal:
//                                                                     0.5),
//                                                         child: Stack(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           children: [
//                                                             // Display the main image
//                                                             Image.network(
//                                                               worldCup.team1Details!
//                                                                       .captain_photo ??
//                                                                   '',
//                                                               height: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .height *
//                                                                   0.15,
//                                                               // width: 133.w,
//                                                               fit: BoxFit.cover,
//                                                             ),
//                                                             // Blurred text area at the bottom
//                                                             Positioned(
//                                                               bottom: 0,
//                                                               child: ClipRRect(
//                                                                 borderRadius:
//                                                                     const BorderRadius
//                                                                         .only(
//                                                                   topRight: Radius
//                                                                       .circular(
//                                                                           30),
//                                                                   bottomLeft: Radius
//                                                                       .circular(
//                                                                           8),
//                                                                   bottomRight: Radius
//                                                                       .circular(
//                                                                           2),
//                                                                 ),
//                                                                 child:
//                                                                     BackdropFilter(
//                                                                   filter: ImageFilter
//                                                                       .blur(
//                                                                           sigmaX:
//                                                                               10,
//                                                                           sigmaY:
//                                                                               5),
//                                                                   // Adjust blur intensity as needed
//                                                                   child:
//                                                                       Container(
//                                                                     width:
//                                                                         133.w,
//                                                                     height: MediaQuery.of(context)
//                                                                             .size
//                                                                             .height *
//                                                                         0.025,
//                                                                     // Adjust height for the blurred section
//                                                                     color: Colors
//                                                                         .black
//                                                                         .withOpacity(
//                                                                             0.3),
//                                                                     // Transparent background to show the blur effect
//                                                                     child:
//                                                                         Center(
//                                                                       child:
//                                                                           Text(
//                                                                         worldCup
//                                                                             .team1Details!
//                                                                             .shortName
//                                                                             .toString(),
//                                                                         style:
//                                                                             TextStyle(
//                                                                           fontSize:
//                                                                               13.sp,
//                                                                           fontWeight:
//                                                                               FontWeight.w500,
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       worldCup.matchName
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         fontSize: 15.sp,
//                                                         fontWeight:
//                                                             FontWeight.w800,
//                                                         color: const Color(
//                                                             0xff140B40),
//                                                       ),
//                                                     ),
//                                                     const Text(
//                                                       "Starts at",
//                                                       style: TextStyle(
//                                                         fontSize: 11,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color:
//                                                             Color(0xff140B40),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "${worldCup.time} PM IST",
//                                                       style: TextStyle(
//                                                         fontSize: 13.sp,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: const Color(
//                                                             0xff140B40),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 15.h),
//                                                     Container(
//                                                       height: 24.h,
//                                                       // Adjusted height for responsiveness
//                                                       width: 62.w,
//                                                       // Adjusted width for responsiveness
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(3.r),
//                                                         color: const Color(
//                                                             0xff140B40),
//                                                       ),
//                                                       child: const Center(
//                                                         child: Text(
//                                                           "JOIN NOW",
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             fontSize: 8.4,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.end,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 0.1),
//                                                       child: Stack(
//                                                         alignment: Alignment
//                                                             .bottomCenter,
//                                                         children: [
//                                                           // Display the main image
//                                                           Image.network(
//                                                             worldCup.team2Details!
//                                                                     .captain_photo ??
//                                                                 '',
//                                                             height: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .height *
//                                                                 0.15,
//                                                             // width: 133.w,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                           // Blurred text area at the bottom
//                                                           Positioned(
//                                                             bottom: 0,
//                                                             child: ClipRRect(
//                                                               borderRadius:
//                                                                   const BorderRadius
//                                                                       .only(
//                                                                 topLeft: Radius
//                                                                     .circular(
//                                                                         15),
//                                                                 // topRight: Radius.circular(15),
//                                                                 bottomLeft: Radius
//                                                                     .circular(
//                                                                         1),
//                                                                 bottomRight:
//                                                                     Radius
//                                                                         .circular(
//                                                                             1),
//                                                               ),
//                                                               child:
//                                                                   BackdropFilter(
//                                                                 filter: ImageFilter
//                                                                     .blur(
//                                                                         sigmaX:
//                                                                             10,
//                                                                         sigmaY:
//                                                                             5),
//                                                                 // Adjust blur intensity as needed
//                                                                 child:
//                                                                     Container(
//                                                                   width: 137.w,
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height *
//                                                                       0.025,
//                                                                   // Adjust height for the blurred section
//                                                                   color: Colors
//                                                                       .black
//                                                                       .withOpacity(
//                                                                           0.3),
//                                                                   // Transparent background to show the blur effect
//                                                                   child: Center(
//                                                                     child: Text(
//                                                                       worldCup
//                                                                           .team2Details!
//                                                                           .shortName
//                                                                           .toString(),
//                                                                       style:
//                                                                           TextStyle(
//                                                                         fontSize:
//                                                                             13.sp,
//                                                                         fontWeight:
//                                                                             FontWeight.w500,
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   : const SizedBox(),
//                             ),
//                             SizedBox(
//                               height: 15.h,
//                             ),
//                             if (upcomingMatch.isNotEmpty) ...[
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const Upcominglistscreen(),
//                                       ));
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     NormalText(
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black,
//                                         text: "Upcoming Matches"),
//                                     Row(
//                                       children: [
//                                         SmallText(
//                                             color: Colors.grey,
//                                             text: "View All"),
//                                         Icon(
//                                           Icons.arrow_forward_ios,
//                                           size: 18.sp,
//                                           color: Colors.grey,
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ] else ...[
//                               const SizedBox(),
//                             ],
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 // Navigator.push(context, MaterialPageRoute(builder: (context)=> Contestscrenn()));
//                               },
//                               child: SizedBox(
//                                 height: upcomingMatch.isNotEmpty ? 165.h : 0,
//                                 // Responsive height using ScreenUtil
//                                 child: upcomingMatch
//                                         .isNotEmpty // Check if myMatch is not empty
//                                     ? ListView.builder(
//                                         itemCount: upcomingMatch.length,
//                                         scrollDirection: Axis.horizontal,
//                                         itemBuilder: (context, index) {
//                                           final upcoming = upcomingMatch[index];
//                                           return InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       IndVsSaScreens(
//                                                     firstMatch: upcoming
//                                                         .matchDetails!
//                                                         .team1Details!
//                                                         .shortName,
//                                                     secMatch: upcoming
//                                                         .matchDetails!
//                                                         .team2Details!
//                                                         .shortName,
//                                                     matchName: upcoming
//                                                         .matchDetails!
//                                                         .matchName,
//                                                     Id: upcoming
//                                                         .matchDetails!.id,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               height: 150.h,
//                                               // Responsive height using ScreenUtil
//                                               margin:
//                                                   EdgeInsets.only(right: 15.r),
//                                               // Responsive margin
//                                               width: 291.w,
//                                               // Responsive width using ScreenUtil
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12.r),
//                                                 // Responsive border radius
//                                                 color: Colors.white,
//                                               ),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Container(
//                                                     height: 30.h,
//                                                     // Responsive height using ScreenUtil
//                                                     width: double.infinity,
//                                                     padding: EdgeInsets.only(
//                                                         left: 15.r, top: 7.r),
//                                                     // Responsive padding
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.black
//                                                           .withOpacity(0.1),
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         topLeft:
//                                                             Radius.circular(
//                                                                 12.r),
//                                                         topRight:
//                                                             Radius.circular(
//                                                                 12.r),
//                                                       ),
//                                                     ),
//                                                     child: Text(
//                                                       "Indian Premier League",
//                                                       style: TextStyle(
//                                                         fontSize: 12.sp,
//                                                         // Responsive font size
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 12.w),
//                                                     // Responsive padding
//                                                     child: Row(
//                                                       children: [
//                                                         Image.network(
//                                                           upcoming
//                                                                   .matchDetails
//                                                                   ?.team1Details!
//                                                                   .logo ??
//                                                               'https://via.placeholder.com/150',
//                                                           height: 63.h,
//                                                           // Responsive image height
//                                                           errorBuilder:
//                                                               (context, error,
//                                                                   stackTrace) {
//                                                             return Image.asset(
//                                                               'assets/default_image.png',
//                                                               height: 63
//                                                                   .h, // Fallback image height
//                                                             );
//                                                           },
//                                                         ),
//                                                         SizedBox(width: 8.w),
//                                                         // Responsive spacing
//                                                         Text(
//                                                           upcoming
//                                                                   .matchDetails!
//                                                                   .team1Details!
//                                                                   .shortName ??
//                                                               "",
//                                                           style: TextStyle(
//                                                             fontSize: 14.sp,
//                                                             // Responsive font size
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                         const Spacer(),
//                                                         Column(
//                                                           children: [
//                                                             Text(
//                                                               // upcoming!.matchDetails!.date!.toString() ?? "",
//                                                               _formatMatchDate(
//                                                                   upcoming
//                                                                       .matchDetails!
//                                                                       .date),
//
//                                                               // "Today",
//                                                               style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400,
//                                                                 fontSize: 12.sp,
//                                                                 // Responsive font size
//                                                                 color:
//                                                                     Colors.grey,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               upcoming.matchDetails!
//                                                                       .time ??
//                                                                   "",
//                                                               style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 fontSize: 14.sp,
//                                                                 // Responsive font size
//                                                                 color:
//                                                                     Colors.red,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const Spacer(),
//                                                         Text(
//                                                           upcoming
//                                                                   .matchDetails!
//                                                                   .team2Details!
//                                                                   .shortName ??
//                                                               "",
//                                                           style: TextStyle(
//                                                             fontSize: 14.sp,
//                                                             // Responsive font size
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: 8.w),
//                                                         // Responsive spacing
//                                                         Image.network(
//                                                           upcoming
//                                                                   .matchDetails
//                                                                   ?.team2Details!
//                                                                   .logo ??
//                                                               'https://via.placeholder.com/150',
//                                                           height: 63.h,
//                                                           // Responsive image height
//                                                           errorBuilder:
//                                                               (context, error,
//                                                                   stackTrace) {
//                                                             return Image.asset(
//                                                               'assets/default_image.png',
//                                                               height: 63
//                                                                   .h, // Fallback image height
//                                                             );
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Divider(
//                                                     height: 1.h,
//                                                     // Responsive divider height
//                                                     color: Colors.grey.shade300,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 6.w),
//                                                     // Responsive padding
//                                                     child: Container(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 12.h),
//                                                       // Responsive padding
//                                                       width: double.infinity,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8.r),
//                                                         // Responsive border radius
//                                                         color: const Color(
//                                                             0xff140B40),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           "Join Now",
//                                                           style: TextStyle(
//                                                             fontSize: 12.sp,
//                                                             // Responsive font size
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 1.h),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       )
//                                     : const SizedBox(),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15.h,
//                             ),
//                             if (myMatch.isNotEmpty) ...[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   NormalText(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                       text: "My Matches"),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const MyMatchesViewall()));
//                                     },
//                                     child: Row(
//                                       children: [
//                                         SmallText(
//                                             color: Colors.grey,
//                                             text: "View All"),
//                                         Icon(
//                                           Icons.arrow_forward_ios,
//                                           size: 18.sp,
//                                           color: Colors.grey,
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ] else ...[
//                               const SizedBox(),
//                             ],
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             SizedBox(
//                               height: myMatch.isNotEmpty
//                                   ? 155.h
//                                   // MediaQuery
//                                   //     .of(context)
//                                   //     .size
//                                   //     .height /5.5
//                                   : 0, // Set height to 0 if myMatch is empty
//                               child: myMatch
//                                       .isNotEmpty // Check if myMatch is not empty
//                                   ? ListView.builder(
//                                       itemCount: myMatch.length,
//                                       scrollDirection: Axis.horizontal,
//                                       itemBuilder: (context, index) {
//                                         final userMatch = myMatch[index];
//                                         return Center(
//                                           child: Container(
//                                             margin:
//                                                 EdgeInsets.only(right: 15.r),
//                                             width: 295.w,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12.r),
//                                               color: Colors.white,
//                                             ),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Container(
//                                                   height: 30.h,
//                                                   width: double.infinity,
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 15.r),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft:
//                                                           Radius.circular(12.r),
//                                                       topRight:
//                                                           Radius.circular(12.r),
//                                                     ),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Text(
//                                                         "Indian Premier League",
//                                                         style: TextStyle(
//                                                           fontSize: 12.sp,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Container(
//                                                             height: 5.h,
//                                                             width: 5.w,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           5.r),
//                                                               color: Colors.red,
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 5.w),
//                                                           Text(
//                                                             "Live",
//                                                             style: TextStyle(
//                                                               fontSize: 12.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 12.h),
//                                                 Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 15.r,
//                                                       vertical: 2.r),
//                                                   child: Column(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           SizedBox(width: 8.w),
//                                                           Image.network(
//                                                             userMatch
//                                                                     .userMatchDetails
//                                                                     ?.team1Details
//                                                                     ?.logo ??
//                                                                 'https://via.placeholder.com/26',
//                                                             height: 36.h,
//                                                             errorBuilder:
//                                                                 (context, error,
//                                                                     stackTrace) {
//                                                               return Image.asset(
//                                                                   'assets/default_team_image.png',
//                                                                   height: 26.h);
//                                                             },
//                                                           ),
//                                                           SizedBox(width: 8.w),
//                                                           Text(
//                                                             userMatch
//                                                                     .userMatchDetails
//                                                                     ?.team1Details
//                                                                     ?.shortName ??
//                                                                 "",
//                                                             style: TextStyle(
//                                                               fontSize: 14.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                             ),
//                                                           ),
//                                                           const Spacer(),
//                                                           Column(
//                                                             children: [
//                                                               Text(
//                                                                 _formatMatchDate(
//                                                                     userMatch
//                                                                         .userMatchDetails!
//                                                                         .date),
//
//                                                                 // "Today",
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   fontSize:
//                                                                       12.sp,
//                                                                   color: Colors
//                                                                       .grey,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 // userMatch.userMatchDetails!.city ?? "",
//                                                                 userMatch
//                                                                         .userMatchDetails!
//                                                                         .time ??
//                                                                     "",
//                                                                 // "selected bat",
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   fontSize:
//                                                                       12.sp,
//                                                                   color: Colors
//                                                                       .red,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           const Spacer(),
//                                                           Text(
//                                                             userMatch
//                                                                     .userMatchDetails
//                                                                     ?.team2Details
//                                                                     ?.shortName ??
//                                                                 "",
//                                                             style: TextStyle(
//                                                               fontSize: 14.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 8.w),
//                                                           Image.network(
//                                                             userMatch
//                                                                     .userMatchDetails
//                                                                     ?.team2Details
//                                                                     ?.logo ??
//                                                                 'https://via.placeholder.com/26',
//                                                             height: 36.h,
//                                                             errorBuilder:
//                                                                 (context, error,
//                                                                     stackTrace) {
//                                                               return Image.asset(
//                                                                   'assets/default_team_image.png',
//                                                                   height: 26.h);
//                                                             },
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: 12.h),
//                                                       Divider(
//                                                         height: 1.h,
//                                                         color: Colors
//                                                             .grey.shade300,
//                                                       ),
//                                                       SizedBox(height: 12.h),
//                                                       Row(
//                                                         children: [
//                                                           Expanded(
//                                                             child: Container(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(10),
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5.r),
//                                                                 color: const Color(
//                                                                         0xff140B40)
//                                                                     .withOpacity(
//                                                                         0.1),
//                                                               ),
//                                                               child: InkWell(
//                                                                 onTap: () {
//                                                                   Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                       builder:
//                                                                           (context) =>
//                                                                               ViewState(
//                                                                         matchId: userMatch
//                                                                             .userMatchDetails!
//                                                                             .id,
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     "View Stats",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           12.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       color: const Color(
//                                                                           0xff140B40),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 10.w),
//                                                           Expanded(
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             IndVsSaScreens(
//                                                                       Id: userMatch
//                                                                           .userMatchDetails!
//                                                                           .id
//                                                                           .toString(),
//                                                                       matchName: userMatch
//                                                                           .userMatchDetails!
//                                                                           .matchName
//                                                                           .toString(),
//                                                                       defaultTabIndex:
//                                                                           2,
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                               child: Container(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .all(
//                                                                         10),
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5.r),
//                                                                   color: const Color(
//                                                                       0xff140B40),
//                                                                 ),
//                                                                 child: Center(
//                                                                   child:
//                                                                       AutoSizeText(
//                                                                     "My Team",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           12.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   : const SizedBox(), // Return an empty SizedBox if myMatch is empty
//                             ),
//                             SizedBox(
//                               height: 20.h,
//                             )
//                           ],
//                         ]
// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:batting_app/screens/Auth/login.dart';
// import 'package:batting_app/screens/viewstate.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:batting_app/MY_Screen/ipl_all_match.dart';
// import 'package:batting_app/screens/country/worldcupmatch.dart';
// import 'package:batting_app/screens/ind_vs_sa_screen.dart';
// import 'package:batting_app/screens/my_matches_viewall.dart';
// import 'package:batting_app/screens/upcominglistscreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'db/app_db.dart';
// import 'model/Homeleagmodel.dart';
// import 'model/imp_model.dart';
// import 'widget/normaltext.dart';
// import 'widget/smalltext.dart';
//
// class HomeScreens extends StatefulWidget {
//   final String matchName;
//   final String matchID;
//   const HomeScreens({super.key, required this.matchName, required this.matchID});
//
//   @override
//   State<HomeScreens> createState() => _HomeScreensState();
// }
//
// class _HomeScreensState extends State<HomeScreens> {
//   late Future<IplModel> futureIplModel;
//   late Future<HomeLeagModel?> _futureData;
//   List<Match> primerMatch = [];
//   List<Match> ipl24Match = [];
//   List<Match> wordCupMatch = [];
//   List<UpcomingMatchesMatch> upcomingMatch = [];
//   List<UserMatchesMatch> myMatch = [];
//
//   List<IplTeam> teams = [];
//
//
//   late final String matchID;
//   late final String matchName;
//
//   late DateTime matchDateTime;
//   late Duration remainingTime;
//
//   String formatRemainingTime(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes % 60;
//     return "${hours}h ${minutes}m left";
//   }
//
//   String _formatMatchDate(DateTime? date) {
//     if (date == null) return ""; // Handle null date case
//
//     final today = DateTime.now();
//     final tomorrow = today.add(const Duration(days: 1));
//
//     // Check if the date is today or tomorrow
//     if (date.year == today.year && date.month == today.month && date.day == today.day) {
//       return "Today";
//     } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
//       return "Tomorrow";
//     } else {
//       // Format the date as dd-MM-yyyy
//       return DateFormat('dd-MM-yyyy').format(date);
//     }
//   }
//   String formatMegaPrice(int price) {
//     if (price >= 10000000) {
//       // 1 crore = 10,000,000
//       return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
//     } else if (price >= 100000) {
//       // 1 lakh = 100,000
//       return "${(price / 100000).toStringAsFixed(0)} lakh"; // Format to whole number
//     } else {
//       return "₹${price.toString()}"; // For values less than 1 lakh
//     }
//   }
//
//
//
//   Widget _buildWorldCupMatchCard(Match match, String team1LogoUrl, String team2LogoUrl) {
//     return InkWell(
//       onTap: () {
//         // Navigate to World Cup match details
//       },
//       child: Container(
//         height: 184,
//         width: 300,
//         margin: const EdgeInsets.only(right: 15),
//         decoration: BoxDecoration(
//           image: const DecorationImage(
//             image: AssetImage("assets/card_bg.png"),
//             fit: BoxFit.cover,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.red,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     match.team1Details!.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Image.asset('assets/vs.png', height: 40),
//                   const SizedBox(width: 7),
//                   Text(
//                     match.team2Details!.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Container(
//                 height: 110,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               match.team1Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   adjustMatchTime(match.time),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xffDC0000),
//                                   ),
//                                 ),
//                                 Text(
//                                   match.time ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               match.team2Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 1,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         "Mega contest ${formatMegaPrice(match.megaprice!) ?? "0"}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xffD4AF37),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Method to build IPL match card
//   // Method to build IPL match card
//   Widget _buildIplMatchCard(Match match, String team1LogoUrl, String team2LogoUrl) {
//     return InkWell(
//       onTap: () {
//         // Navigate to IPL match details
//       },
//       child: Container(
//         height: 184, // Responsive height
//         width: 300, // Responsive width
//         margin: const EdgeInsets.only(right: 15), // Responsive margin
//         decoration: BoxDecoration(
//           image: const DecorationImage(
//             image: AssetImage("assets/card_bg_prev_ui.png"),
//             fit: BoxFit.cover,
//           ),
//           gradient: LinearGradient(colors: [
//             _hexToColor(match.team1Details?.colorCode ?? "#000000"),
//             _hexToColor(match.team2Details?.colorCode ?? "#000000"),
//           ]),
//           borderRadius: BorderRadius.circular(12), // Responsive border radius
//           color: Colors.red,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     match.team1Details!.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Image.asset('assets/vs.png', height: 40),
//                   const SizedBox(width: 7),
//                   Text(
//                     match.team2Details!.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Container(
//                 height: 110,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               match.team1Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   adjustMatchTime(match.time),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xffDC0000),
//                                   ),
//                                 ),
//                                 Text(
//                                   match.time ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               match.team2Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 1,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         "Mega contest ${formatMegaPrice(match.megaprice!) ?? "0"}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xffD4AF37),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Method to build Upcoming match card
//   Widget _buildUpcomingMatchCard(Match match, String team1LogoUrl, String team2LogoUrl) {
//     return InkWell(
//       onTap: () {
//         // Navigate to Upcoming match details
//       },
//       child: Container(
//         height: 184,
//         width: 300,
//         margin: const EdgeInsets.only(right: 15),
//         decoration: BoxDecoration(
//           image: const DecorationImage(
//             image: AssetImage("assets/upcoming_card_bg.png"),
//             fit: BoxFit.cover,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.blue,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     match.team1Details!.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Image.asset('assets/vs.png', height: 40),
//                   const SizedBox(width: 7),
//                   Text(
//                     match.team2Details !.shortName.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Container(
//                 height: 110,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               match.team1Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   adjustMatchTime(match.time),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xffDC0000),
//                                   ),
//                                 ),
//                                 Text(
//                                   match.time ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               match.team2Details?.teamName ?? "",
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 1,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         "Mega contest ${formatMegaPrice(match.megaprice!) ?? "0"}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xffD4AF37),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Color _hexToColor(String? hexColor) {
//     if (hexColor == null || hexColor.isEmpty) {
//       return Colors.transparent; // or any default color you prefer
//     }
//
//     // Remove the leading '#', if it exists
//     hexColor = hexColor.replaceAll('#', '');
//     // Parse the string as a hex integer and convert to Color
//     return Color(int.parse('FF$hexColor', radix: 16));
//   }
//
//   Timer? _timer;
//   String adjustedTime = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _futureData = profileDisplay();
//     //startTimer();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Future<HomeLeagModel?> profileDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/user/desbord_details'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       print(response.body);
//       if (response.statusCode == 200) {
//         final data = HomeLeagModel.fromJson(jsonDecode(response.body));
//         debugPrint('Data: ${data.message}');
//         print(response.statusCode);
//         print('primMatch$primerMatch');
//         print('mymatches $myMatch');
//         print("print from if part ${response.body}");
//         // upcomingMatch = data.data?[3].upcomingMatches?.matches?.cast<UpcomingMatchesMatch>() ?? [];
//         // myMatch = data.data?[4].userMatches?.matches?.cast<UserMatchesMatch>() ?? [];
//
//         return data;
//       } else {
//         debugPrint('Failed to fetch profile data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error fetching profile data: $e');
//       debugPrint('Stack trace: $stackTrace');
//       return null;
//     }
//   }
//
//   String adjustMatchTime(String? originalTime) {
//     if (originalTime == null || originalTime.isEmpty) {
//       return ""; // Handle case where time is null or empty
//     }
//
//     try {
//       // Parse the original time assuming it's in "HH:mm" format
//       List<String> parts = originalTime.split(":");
//       int matchHour = int.parse(parts[0]);
//       int matchMinute = int.parse(parts[1]);
//
//       // Get the current time
//       DateTime now = DateTime.now();
//       int currentHour = now.hour;
//       int currentMinute = now.minute;
//
//       // Calculate the time difference in minutes
//       int differenceMinutes =
//           (matchHour - currentHour) * 60 + (matchMinute - currentMinute);
//       // Convert minutes difference to hours and minutes
//       int hours = differenceMinutes ~/ 60; // integer division
//       int minutes = differenceMinutes % 60;
//
//       // Determine if the match is ahead or ago
//       String timeStatus = differenceMinutes >= 0 ? "ahead" : "ago";
//       print('Time status:-$timeStatus');
// print('time started:-${hours.abs()}h ${minutes.abs()}m');
//       // Format the adjusted time difference
//       return "${hours.abs()}h ${minutes.abs()}m";
//     } catch (e) {
//       print("Error parsing or adjusting time: $e");
//       return ""; // Handle any errors gracefully
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     bool shouldExit = await _showExitConfirmationDialog(context);
//     return shouldExit; // Return the boolean result to indicate whether to exit
//   }
//
//   Future<bool> _showExitConfirmationDialog(BuildContext context) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             height: 280,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 15),
//                 Image.asset(
//                   'assets/log_pop.png',
//                   height: 70,
//                   color: const Color(0xff140B40),
//                 ),
//                 const SizedBox(height: 15),
//                 const Text(
//                   "Are you sure you want",
//                   style: TextStyle(
//                     fontSize: 20,
//                     letterSpacing: 0.8,
//                     color: Color(0xff140B40),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Text(
//                   "to Exit?",
//                   style: TextStyle(
//                     fontSize: 22,
//                     letterSpacing: 0.8,
//                     color: Color(0xff140B40),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop(true); // User pressed Yes
//                         },
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: const Color(0xff010101).withOpacity(0.35),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Yes",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 13),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop(false); // User pressed No
//                         },
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: const Color(0xff140B40),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "No",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ).then((value) => value ?? false); // Return false if dialog is dismissed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       // WillPopScope(
//       // onWillPop: () async {
//       //   print('willpopscope in use');
//       //   // Show the confirmation dialog
//       //   bool shouldExit = await _showExitConfirmationDialog(context);
//       //   return shouldExit; // Return true to exit, false to stay
//       // },
//       PopScope(
//         canPop: false,  // Prevent the default back action
//         onPopInvokedWithResult: (didPop, result) async {
//           bool shouldExit = await _onWillPop(); // Wait for the result from the custom back handler
//           if (shouldExit) {
//             SystemNavigator.pop(); // Close the app if the user confirms exit
//           } else {
//             // User pressed "No" - Prevent the back navigation (don't pop the current screen)
//             return Future.value(); // Prevent popping the current screen and show the dialog again
//           }
//         },
//
//         // PopScope(
//       //   // Allow popping
//       //   canPop: false,
//       //   onPopInvokedWithResult: (didPop, result) async {
//       //     // Show the confirmation dialog
//       //     bool shouldExit = await _showExitConfirmationDialog(context);
//       //
//       //     if (shouldExit) {
//       //       // Close the app
//       //       SystemNavigator.pop();
//       //     }
//       //     return; // Simply return without a value
//       //   },
//       // PopScope(
//       // canPop: false, // Allow popping
//       // onPopInvokedWithResult: (didPop, result) async {
//       //   // Show the confirmation dialog
//       //   bool shouldExit = await _showExitConfirmationDialog(context);
//       //   if (shouldExit) {
//       //     // Close the app
//       //     SystemNavigator.pop(); // This will close the app
//       //   }
//       //   // return shouldExit;
//       //   // Return `true` if you want to indicate that the pop was handled manually.
//       //   // return true; // Prevent the default back navigation behavior
//       // },
//       child: Scaffold(
//         // appBar: Appbarscreen(), // Using your custom app bar here
//         body: FutureBuilder(
//           future: _futureData,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Container(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width,
//                   color: const Color(0xffF0F1F5),
//                   child: const Center(child: CircularProgressIndicator()));
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('No data available'));
//             } else {
//               final data = snapshot.data!;
//               List<List<Match>> leagueMatches = []; // List to hold matches for each league
//               for (var i = 0; i < data.data!.length; i++) {
//                 var leagueDetails = data.data![i].leagueDetails;
//                 var upcomingmatch = data.data![1].upcomingMatches;
//                 var myMatches = data.data![i].userMatches;
//                 if (leagueDetails != null) {
//                   leagueMatches.add(leagueDetails.matches?.cast<Match>() ?? []);
//                 }
//               }
//
//               primerMatch =
//                   data.data?[0].leagueDetails?.matches?.cast<Match>() ?? [];
//               ipl24Match = data.data?[1].leagueDetails?.matches?.cast<Match>() ?? [];
//               wordCupMatch =
//                   data.data?[2].leagueDetails?.matches?.cast<Match>() ?? [];
//               upcomingMatch = data.data?[3].upcomingMatches?.matches
//                   ?.cast<UpcomingMatchesMatch>() ??
//                   [];
//               myMatch =
//                   data.data?[4].userMatches?.matches?.cast<UserMatchesMatch>() ??
//                       [];
//               return SingleChildScrollView(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   color: const Color(0xffF0F1F5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 15),
//                       for (int i = 0; i < leagueMatches.length; i++) ...[
//                         if (leagueMatches[i].isNotEmpty) ...[
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => IplAllMatch(leagueId: leagueMatches[i].first.leagueId),
//                                 ),
//                               );
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 NormalText(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                   text: data.data![i].leagueDetails!.leaguaName.toString(),
//                                 ),
//                                 Row(
//                                   children: [
//                                     SmallText(color: Colors.grey, text: "View All"),
//                                     Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             height: 186, // Responsive height
//                             width: MediaQuery.of(context).size.width,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemCount: leagueMatches[i].length,
//                               itemBuilder: (context, index) {
//                                 final match = leagueMatches[i][index];
//                                 DateTime? matchDate = match.date;
//                                 final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
//                                 String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
//                                 final team1LogoUrl = match.team1Details?.logo ?? '';
//                                 final team2LogoUrl = match.team2Details?.logo ?? '';
//
//                                 // Check the league type and render accordingly
//                                 if (data.data![i].leagueDetails!.leaguaName?.toLowerCase() == "world cup") {
//                                   return _buildWorldCupMatchCard(match, team1LogoUrl, team2LogoUrl);
//                                 } else if (data.data![i].leagueDetails!.leaguaName?.toLowerCase() == "ipl") {
//                                   return _buildIplMatchCard(match, team1LogoUrl, team2LogoUrl);
//                                 } else {
//                                   return _buildUpcomingMatchCard(match, team1LogoUrl, team2LogoUrl);
//                                 }
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                         ],
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//       );
//   }
// }
//             //   return SingleChildScrollView(
//             //     child: Container(
//             //       padding: const EdgeInsets.symmetric(horizontal: 20),
//             //       color: const Color(0xffF0F1F5),
//             //       child: Column(
//             //         crossAxisAlignment: CrossAxisAlignment.start,
//             //         children: [
//             //
//             //           const SizedBox(
//             //             height: 15,
//             //           ),
//             //           if(primerMatch.isNotEmpty)...[
//             //           InkWell(
//             //             onTap: () {
//             //
//             //               Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                     builder: (context) =>  IplAllMatch(leagueId:primerMatch.first.leagueId,),
//             //
//             //                   ));
//             //               //print('object${primerMatch.first.leagueId}');
//             //             },
//             //             child: Row(
//             //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //               children: [
//             //                 NormalText(
//             //                   fontWeight: FontWeight.w600,
//             //                   color: Colors.black,
//             //                   text: data.data![0].leagueDetails!.leaguaName
//             //                       .toString(),
//             //                   //textStyle: AppStyles.text16s500wStyle,
//             //                 ),
//             //                 Row(
//             //                   children: [
//             //                     SmallText(color: Colors.grey, text: "View All"),
//             //                     Icon(
//             //                       Icons.arrow_forward_ios,
//             //                       size: 18.sp,
//             //                       color: Colors.grey,
//             //                     )
//             //                   ],
//             //                 )
//             //               ],
//             //             ),
//             //           ),]else...[
//             //           const SizedBox(),
//             //       ],
//             //           const SizedBox(
//             //             height: 10,
//             //           ),
//             //           SizedBox(
//             //             height: primerMatch.isNotEmpty? 186 : 0, // Responsive height
//             //             width: MediaQuery.of(context).size.width,
//             //             child: primerMatch.isNotEmpty // Check if myMatch is not empty
//             //                 ?ListView.builder(
//             //               shrinkWrap: true,
//             //               scrollDirection: Axis.horizontal,
//             //               itemCount: primerMatch.length,
//             //               itemBuilder: (context, index) {
//             //                 final match = primerMatch[index];
//             //                 DateTime? matchDate = match.date;
//             //                 final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
//             //                 String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
//             //                 final team1LogoUrl = match.team1Details?.logo ?? '';
//             //                 final team2LogoUrl = match.team2Details?.logo ?? '';
//             //
//             //                 return InkWell(
//             //                   onTap: () {
//             //                     Navigator.push(
//             //                       context,
//             //                       MaterialPageRoute(
//             //                         builder: (context) => IndVsSaScreens(
//             //                           firstMatch: match.team1Details!.shortName,
//             //                           secMatch: match.team2Details!.shortName,
//             //                           matchName: match.matchName,
//             //                           Id: match.id,
//             //                         ),
//             //                       ),
//             //                     );
//             //                   },
//             //                   child: Stack(
//             //                     children: [
//             //                       Container(
//             //                         height: 184, // Responsive height
//             //                         width: 300, // Responsive width
//             //                         margin: const EdgeInsets.only(right: 15), // Responsive margin
//             //                         decoration: BoxDecoration(
//             //                           image: const DecorationImage(
//             //                               image: AssetImage("assets/card_bg_prev_ui.png"),
//             //                               fit: BoxFit.cover),
//             //                           gradient: LinearGradient(colors: [
//             //                             _hexToColor(match.team1Details?.colorCode ?? "#000000"),
//             //                             _hexToColor(match.team2Details?.colorCode ?? "#000000"),
//             //                           ]),
//             //                           borderRadius: BorderRadius.circular(12), // Responsive border radius
//             //                           color: Colors.red,
//             //                         ),
//             //                         child: Padding(
//             //                           padding: const EdgeInsets.only(top: 5), // Responsive padding
//             //                           child: Column(
//             //                             crossAxisAlignment: CrossAxisAlignment.center,
//             //                             mainAxisAlignment: MainAxisAlignment.end,
//             //                             children: [
//             //                               const SizedBox(height: 10), // Responsive spacing
//             //                               Row(
//             //                                 mainAxisAlignment: MainAxisAlignment.center,
//             //                                 children: [
//             //                                   Text(
//             //                                     match.team1Details!.shortName.toString(),
//             //                                     style: const TextStyle(
//             //                                       fontSize: 14, // Responsive text size
//             //                                       fontWeight: FontWeight.w700,
//             //                                       color: Colors.white,
//             //                                     ),
//             //                                   ),
//             //                                   const SizedBox(width: 7), // Responsive spacing
//             //                                   Image.asset('assets/vs.png', height: 40),
//             //                                   const SizedBox(width: 7), // Responsive spacing
//             //                                   Text(
//             //                                     match.team2Details!.shortName.toString(),
//             //                                     style: const TextStyle(
//             //                                       fontSize: 14, // Responsive text size
//             //                                       fontWeight: FontWeight.w700,
//             //                                       color: Colors.white,
//             //                                     ),
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                               const Spacer(),
//             //                               Container(
//             //                                 height: 110, // Responsive height
//             //                                 width: double.infinity,
//             //                                 decoration: BoxDecoration(
//             //                                   borderRadius: BorderRadius.circular(10), // Responsive border radius
//             //                                   color: Colors.white,
//             //                                 ),
//             //                                 child: Padding(
//             //                                   padding: const EdgeInsets.symmetric(horizontal: 15), // Responsive padding
//             //                                   child: Column(
//             //                                     mainAxisAlignment: MainAxisAlignment.end,
//             //                                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                                     children: [
//             //                                       Row(
//             //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                                         crossAxisAlignment: CrossAxisAlignment.start,
//             //                                         children: [
//             //                                           Expanded(
//             //                                             child: Text(
//             //                                               match.team1Details?.teamName ?? "",
//             //                                               textAlign: TextAlign.center,
//             //                                               maxLines: 2,
//             //                                               softWrap: true,
//             //                                               overflow: TextOverflow.ellipsis,
//             //                                               style: const TextStyle(
//             //                                                 fontSize: 14, // Responsive text size
//             //                                                 fontWeight: FontWeight.w600,
//             //                                                 color: Colors.black,
//             //                                               ),
//             //                                             ),
//             //                                           ),
//             //                                           const SizedBox(width: 8), // Responsive spacing
//             //                                           Expanded(
//             //                                             child: Column(
//             //                                               mainAxisAlignment: MainAxisAlignment.center,
//             //                                               children: [
//             //                                                 Text(
//             //                                                   adjustMatchTime(match.time),
//             //                                                   style: const TextStyle(
//             //                                                     fontSize: 14, // Responsive text size
//             //                                                     fontWeight: FontWeight.w500,
//             //                                                     color: Color(0xffDC0000),
//             //                                                   ),
//             //                                                 ),
//             //                                                 Text(
//             //                                                   match.time ?? "",
//             //                                                   style: const TextStyle(
//             //                                                     fontSize: 14, // Responsive text size
//             //                                                     fontWeight: FontWeight.w500,
//             //                                                     color: Colors.black,
//             //                                                   ),
//             //                                                 ),
//             //                                               ],
//             //                                             ),
//             //                                           ),
//             //                                           const SizedBox(width: 8), // Responsive spacing
//             //                                           Expanded(
//             //                                             child: Text(
//             //                                               match.team2Details?.teamName ?? "",
//             //                                               textAlign: TextAlign.center,
//             //                                               maxLines: 2,
//             //                                               softWrap: true,
//             //                                               overflow: TextOverflow.ellipsis,
//             //                                               style: const TextStyle(
//             //                                                 fontSize: 14, // Responsive text size
//             //                                                 fontWeight: FontWeight.w600,
//             //                                                 color: Colors.black,
//             //                                               ),
//             //                                             ),
//             //                                           ),
//             //                                         ],
//             //                                       ),
//             //                                       const SizedBox(height: 10), // Responsive spacing
//             //                                       Container(
//             //                                         height: 1, // Responsive divider height
//             //                                         width: MediaQuery.of(context).size.width,
//             //                                         color: Colors.grey.shade300,
//             //                                       ),
//             //                                       const SizedBox(height: 5), // Responsive spacing
//             //                                        Text(
//             //                                          "Mega contest ${formatMegaPrice(match.megaprice!) ?? "0"}",
//             //
//             //                                          // "Mega contest ${match.megaprice.toString()}",
//             //                                         // "Mega Content ₹70 Crores",
//             //                                         style: const TextStyle(
//             //                                           fontSize: 12, // Responsive text size
//             //                                           fontWeight: FontWeight.w500,
//             //                                           color: Color(0xffD4AF37),
//             //                                         ),
//             //                                       ),
//             //                                       const SizedBox(height: 8), // Responsive spacing
//             //                                     ],
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ),
//             //                       Positioned(
//             //                         top: 35, // Responsive position
//             //                         left: 20, // Responsive position
//             //                         child: Image.network(
//             //                           team1LogoUrl,
//             //                           height: 55, // Responsive height
//             //                         ),
//             //                       ),
//             //                       Positioned(
//             //                         top: 40, // Responsive position
//             //                         right: 27, // Responsive position
//             //                         child: Image.network(
//             //                           team2LogoUrl,
//             //                           height: 50, // Responsive height
//             //                         ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 );
//             //               },
//             //             )  : const SizedBox(),
//             //           ),
//             //
//             //           const SizedBox(
//             //             height: 15,
//             //           ),
//             //           if(ipl24Match.isNotEmpty)...[
//             //             InkWell(
//             //               onTap: () {
//             //
//             //                 Navigator.push(
//             //                     context,
//             //                     MaterialPageRoute(
//             //                       builder: (context) =>  IplAllMatch(leagueId:ipl24Match.first.leagueId,),
//             //
//             //                     ));
//             //                 //print('object${primerMatch.first.leagueId}');
//             //               },
//             //               child: Row(
//             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                 children: [
//             //                   NormalText(
//             //                     fontWeight: FontWeight.w600,
//             //                     color: Colors.black,
//             //                     text: data.data![1].leagueDetails!.leaguaName
//             //                         .toString(),
//             //                     //textStyle: AppStyles.text16s500wStyle,
//             //                   ),
//             //                   Row(
//             //                     children: [
//             //                       SmallText(color: Colors.grey, text: "View All"),
//             //                       Icon(
//             //                         Icons.arrow_forward_ios,
//             //                         size: 18.sp,
//             //                         color: Colors.grey,
//             //                       )
//             //                     ],
//             //                   )
//             //                 ],
//             //               ),
//             //             ),]else...[
//             //             const SizedBox(),
//             //           ],
//             //           const SizedBox(
//             //             height: 10,
//             //           ),
//             //           SizedBox(
//             //             height: ipl24Match.isNotEmpty? 186 : 0, // Responsive height
//             //             width: MediaQuery.of(context).size.width,
//             //             child: ipl24Match.isNotEmpty // Check if myMatch is not empty
//             //                 ?ListView.builder(
//             //               shrinkWrap: true,
//             //               scrollDirection: Axis.horizontal,
//             //               itemCount: ipl24Match.length,
//             //               itemBuilder: (context, index) {
//             //                 final match = ipl24Match[index];
//             //                 DateTime? matchDate = match.date;
//             //                 final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
//             //                 String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
//             //                 final team1LogoUrl = match.team1Details?.logo ?? '';
//             //                 final team2LogoUrl = match.team2Details?.logo ?? '';
//             //
//             //                 return InkWell(
//             //                   onTap: () {
//             //                     Navigator.push(
//             //                       context,
//             //                       MaterialPageRoute(
//             //                         builder: (context) => IndVsSaScreens(
//             //                           firstMatch: match.team1Details!.shortName,
//             //                           secMatch: match.team2Details!.shortName,
//             //                           matchName: match.matchName,
//             //                           Id: match.id,
//             //                         ),
//             //                       ),
//             //                     );
//             //                   },
//             //                   child: Stack(
//             //                     children: [
//             //                       Container(
//             //                         height: 184, // Responsive height
//             //                         width: 300, // Responsive width
//             //                         margin: const EdgeInsets.only(right: 15), // Responsive margin
//             //                         decoration: BoxDecoration(
//             //                           image: const DecorationImage(
//             //                               image: AssetImage("assets/card_bg_prev_ui.png"),
//             //                               fit: BoxFit.cover),
//             //                           gradient: LinearGradient(colors: [
//             //                             _hexToColor(match.team1Details?.colorCode ?? "#000000"),
//             //                             _hexToColor(match.team2Details?.colorCode ?? "#000000"),
//             //                           ]),
//             //                           borderRadius: BorderRadius.circular(12), // Responsive border radius
//             //                           color: Colors.red,
//             //                         ),
//             //                         child: Padding(
//             //                           padding: const EdgeInsets.only(top: 5), // Responsive padding
//             //                           child: Column(
//             //                             crossAxisAlignment: CrossAxisAlignment.center,
//             //                             mainAxisAlignment: MainAxisAlignment.end,
//             //                             children: [
//             //                               const SizedBox(height: 10), // Responsive spacing
//             //                               Row(
//             //                                 mainAxisAlignment: MainAxisAlignment.center,
//             //                                 children: [
//             //                                   Text(
//             //                                     match.team1Details!.shortName.toString(),
//             //                                     style: const TextStyle(
//             //                                       fontSize: 14, // Responsive text size
//             //                                       fontWeight: FontWeight.w700,
//             //                                       color: Colors.white,
//             //                                     ),
//             //                                   ),
//             //                                   const SizedBox(width: 7), // Responsive spacing
//             //                                   Image.asset('assets/vs.png', height: 40),
//             //                                   const SizedBox(width: 7), // Responsive spacing
//             //                                   Text(
//             //                                     match.team2Details!.shortName.toString(),
//             //                                     style: const TextStyle(
//             //                                       fontSize: 14, // Responsive text size
//             //                                       fontWeight: FontWeight.w700,
//             //                                       color: Colors.white,
//             //                                     ),
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                               const Spacer(),
//             //                               Container(
//             //                                 height: 110, // Responsive height
//             //                                 width: double.infinity,
//             //                                 decoration: BoxDecoration(
//             //                                   borderRadius: BorderRadius.circular(10), // Responsive border radius
//             //                                   color: Colors.white,
//             //                                 ),
//             //                                 child: Padding(
//             //                                   padding: const EdgeInsets.symmetric(horizontal: 15), // Responsive padding
//             //                                   child: Column(
//             //                                     mainAxisAlignment: MainAxisAlignment.end,
//             //                                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                                     children: [
//             //                                       Row(
//             //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                                         crossAxisAlignment: CrossAxisAlignment.start,
//             //                                         children: [
//             //                                           Expanded(
//             //                                             child: Text(
//             //                                               match.team1Details?.teamName ?? "",
//             //                                               textAlign: TextAlign.center,
//             //                                               maxLines: 2,
//             //                                               softWrap: true,
//             //                                               overflow: TextOverflow.ellipsis,
//             //                                               style: const TextStyle(
//             //                                                 fontSize: 14, // Responsive text size
//             //                                                 fontWeight: FontWeight.w600,
//             //                                                 color: Colors.black,
//             //                                               ),
//             //                                             ),
//             //                                           ),
//             //                                           const SizedBox(width: 8), // Responsive spacing
//             //                                           Expanded(
//             //                                             child: Column(
//             //                                               mainAxisAlignment: MainAxisAlignment.center,
//             //                                               children: [
//             //                                                 Text(
//             //                                                   adjustMatchTime(match.time),
//             //                                                   style: const TextStyle(
//             //                                                     fontSize: 14, // Responsive text size
//             //                                                     fontWeight: FontWeight.w500,
//             //                                                     color: Color(0xffDC0000),
//             //                                                   ),
//             //                                                 ),
//             //                                                 Text(
//             //                                                   match.time ?? "",
//             //                                                   style: const TextStyle(
//             //                                                     fontSize: 14, // Responsive text size
//             //                                                     fontWeight: FontWeight.w500,
//             //                                                     color: Colors.black,
//             //                                                   ),
//             //                                                 ),
//             //                                               ],
//             //                                             ),
//             //                                           ),
//             //                                           const SizedBox(width: 8), // Responsive spacing
//             //                                           Expanded(
//             //                                             child: Text(
//             //                                               match.team2Details?.teamName ?? "",
//             //                                               textAlign: TextAlign.center,
//             //                                               maxLines: 2,
//             //                                               softWrap: true,
//             //                                               overflow: TextOverflow.ellipsis,
//             //                                               style: const TextStyle(
//             //                                                 fontSize: 14, // Responsive text size
//             //                                                 fontWeight: FontWeight.w600,
//             //                                                 color: Colors.black,
//             //                                               ),
//             //                                             ),
//             //                                           ),
//             //                                         ],
//             //                                       ),
//             //                                       const SizedBox(height: 10), // Responsive spacing
//             //                                       Container(
//             //                                         height: 1, // Responsive divider height
//             //                                         width: MediaQuery.of(context).size.width,
//             //                                         color: Colors.grey.shade300,
//             //                                       ),
//             //                                       const SizedBox(height: 5), // Responsive spacing
//             //                                       Text(
//             //                                         "Mega contest ${formatMegaPrice(match.megaprice!) ?? "0"}",
//             //
//             //                                         // "Mega contest ${match.megaprice.toString()}",
//             //                                         // "Mega Content ₹70 Crores",
//             //                                         style: const TextStyle(
//             //                                           fontSize: 12, // Responsive text size
//             //                                           fontWeight: FontWeight.w500,
//             //                                           color: Color(0xffD4AF37),
//             //                                         ),
//             //                                       ),
//             //                                       const SizedBox(height: 8), // Responsive spacing
//             //                                     ],
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ),
//             //                       Positioned(
//             //                         top: 35, // Responsive position
//             //                         left: 20, // Responsive position
//             //                         child: Image.network(
//             //                           team1LogoUrl,
//             //                           height: 55, // Responsive height
//             //                         ),
//             //                       ),
//             //                       Positioned(
//             //                         top: 40, // Responsive position
//             //                         right: 27, // Responsive position
//             //                         child: Image.network(
//             //                           team2LogoUrl,
//             //                           height: 50, // Responsive height
//             //                         ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 );
//             //               },
//             //             )  : const SizedBox(),
//             //           ),
//             //
//             //           const SizedBox(
//             //             height: 15,
//             //           ),
//             //           if(wordCupMatch.isNotEmpty)...[
//             //           InkWell(
//             //             onTap: (){
//             //               Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                     builder: (context) =>  WorldcupMatch(leagueId:wordCupMatch.first.leagueId,),
//             //                   ));
//             //             },
//             //             child: Row(
//             //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //               children: [
//             //                 NormalText(
//             //                     fontWeight: FontWeight.w600,
//             //                     color: Colors.black,
//             //                     text:
//             //                     data.data?[2].leagueDetails?.leaguaName ?? ""),
//             //                 Row(
//             //                   children: [
//             //                     SmallText(color: Colors.grey, text: "View All"),
//             //                     const Icon(
//             //                       Icons.arrow_forward_ios,
//             //                       size: 18,
//             //                       color: Colors.grey,
//             //                     )
//             //                   ],
//             //                 )
//             //               ],
//             //             ),
//             //           ),]else...[
//             //           const SizedBox(),
//             //       ],
//             //           const SizedBox(
//             //             height: 10,
//             //           ),
//             //           SizedBox(
//             //             // height: MediaQuery.of(context).size.height *0.3,
//             //             height: wordCupMatch.isNotEmpty ? 180 : 0,
//             //             width: MediaQuery.of(context).size.width * 12, // Full width of the container
//             //             child: wordCupMatch.isNotEmpty // Check if myMatch is not empty
//             //                 ?ListView.builder(
//             //               itemCount: wordCupMatch.length,
//             //               // scrollDirection: Axis.horizontal,
//             //
//             //               shrinkWrap: true,
//             //                 physics: const NeverScrollableScrollPhysics(),
//             //                 // scrollDirection: Axis.horizontal,
//             //               itemBuilder: (context, index) {
//             //                 final worldCup = wordCupMatch[index];
//             //                 return InkWell(
//             //                   onTap: () {
//             //                     Navigator.push(
//             //                       context,
//             //                       MaterialPageRoute(
//             //                         builder: (context) => IndVsSaScreens(
//             //                           firstMatch: worldCup.team1Details!.shortName,
//             //                           secMatch: worldCup.team2Details!.shortName,
//             //                           matchName: worldCup.matchName,
//             //                           Id: worldCup.id,
//             //                         ),
//             //                       ),
//             //                     );
//             //                   },
//             //                   child: Container(
//             //                     // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
//             //                     height: 180, // Adjusted height for responsiveness
//             //
//             //                     // width: double.infinity,
//             //                     width: MediaQuery.of(context).size.width,
//             //                     decoration: BoxDecoration(
//             //                       color: Colors.white,
//             //                       borderRadius: BorderRadius.circular(10.r), // Adjusted border radius for responsiveness
//             //                       image: const DecorationImage(
//             //                         image: AssetImage('assets/card_bg.png'),
//             //                         fit: BoxFit.cover,
//             //                         opacity: 0.1,
//             //                       ),
//             //                     ),
//             //                     child: Row(
//             //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                       crossAxisAlignment: CrossAxisAlignment.end,
//             //                       children: [
//             //                       Expanded(
//             //                         child: Column(
//             //                         mainAxisAlignment: MainAxisAlignment.end,
//             //                         crossAxisAlignment: CrossAxisAlignment.center,
//             //                         children: [
//             //                           Padding(
//             //                             padding: const EdgeInsets.symmetric(horizontal: 0.5),
//             //                             child: Stack(
//             //                               alignment: Alignment.bottomCenter,
//             //                               children: [
//             //                                 // Display the main image
//             //                                 Image.network(
//             //                                   worldCup.team1Details!.captain_photo ?? '',
//             //                                   height: MediaQuery.of(context).size.height * 0.15,
//             //                                   // width: 133.w,
//             //                                   fit: BoxFit.cover,
//             //                                 ),
//             //                                 // Blurred text area at the bottom
//             //                                 Positioned(
//             //                                   bottom: 0,
//             //                                   child: ClipRRect(
//             //                                     borderRadius: const BorderRadius.only(
//             //                                       topRight: Radius.circular(30),
//             //                                       bottomLeft: Radius.circular(8),
//             //                                       bottomRight: Radius.circular(2),
//             //                                     ),
//             //                                     child: BackdropFilter(
//             //                                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5), // Adjust blur intensity as needed
//             //                                       child: Container(
//             //                                         width: 133.w,
//             //                                         height: MediaQuery.of(context).size.height * 0.025, // Adjust height for the blurred section
//             //                                         color: Colors.black.withOpacity(0.3), // Transparent background to show the blur effect
//             //                                         child: Center(
//             //                                           child: Text(
//             //                                             worldCup.team1Details!.shortName.toString(),
//             //                                             style: TextStyle(
//             //                                               fontSize: 13.sp,
//             //                                               fontWeight: FontWeight.w500,
//             //                                               color: Colors.white,
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ),
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                         ],
//             //                                                       ),
//             //                       ),
//             //                         // Column(
//             //                         //   mainAxisAlignment: MainAxisAlignment.end,
//             //                         //   crossAxisAlignment: CrossAxisAlignment.center,
//             //                         //   children: [
//             //                         //     Padding(
//             //                         //       padding: EdgeInsets.symmetric(horizontal: 7.w),
//             //                         //       child: Image.network(
//             //                         //         worldCup.team1Details!.captain_photo ?? '',
//             //                         //         height: MediaQuery.of(context).size.height * 0.12,
//             //                         //       ),
//             //                         //     ),
//             //                         //     Container(
//             //                         //       height: 21.7.h, // Adjusted height for responsiveness
//             //                         //       width: 133.w, // Adjusted width for responsiveness
//             //                         //       decoration: BoxDecoration(
//             //                         //         borderRadius: BorderRadius.only(
//             //                         //           bottomLeft: Radius.circular(10.r),
//             //                         //         ),
//             //                         //         image: const DecorationImage(
//             //                         //           image: AssetImage('assets/blur.png'),
//             //                         //           fit: BoxFit.cover,
//             //                         //         ),
//             //                         //       ),
//             //                         //       child: Center(
//             //                         //         child: Text(
//             //                         //           worldCup.team1Details!.shortName.toString(),
//             //                         //           style: TextStyle(
//             //                         //             fontSize: 13.sp,
//             //                         //             fontWeight: FontWeight.w500,
//             //                         //             color: Colors.white,
//             //                         //           ),
//             //                         //         ),
//             //                         //       ),
//             //                         //     ),
//             //                         //   ],
//             //                         // ),
//             //                         Column(
//             //                           mainAxisAlignment: MainAxisAlignment.center,
//             //                           children: [
//             //                             Text(
//             //                               worldCup.matchName.toString(),
//             //                               style: TextStyle(
//             //                                 fontSize: 15.sp,
//             //                                 fontWeight: FontWeight.w800,
//             //                                 color: const Color(0xff140B40),
//             //                               ),
//             //                             ),
//             //                             // SizedBox(height: 15.h),
//             //                             //  Text(
//             //                             //   // worldCup.matchName.toString(),
//             //                             //
//             //                             //   "Semi Finals",
//             //                             //   style: TextStyle(
//             //                             //     fontSize: 12,
//             //                             //     fontWeight: FontWeight.w600,
//             //                             //     color: Colors.red,
//             //                             //   ),
//             //                             // ),
//             //                             // SizedBox(height: 15.h),
//             //                             const Text(
//             //                               "Starts at",
//             //                               style: TextStyle(
//             //                                 fontSize: 11,
//             //                                 fontWeight: FontWeight.w600,
//             //                                 color: Color(0xff140B40),
//             //                               ),
//             //                             ),
//             //                             Text(
//             //                               "${worldCup.time} PM IST",
//             //                               style: TextStyle(
//             //                                 fontSize: 13.sp,
//             //                                 fontWeight: FontWeight.w600,
//             //                                 color: const Color(0xff140B40),
//             //                               ),
//             //                             ),
//             //                             SizedBox(height: 15.h),
//             //                             Container(
//             //                               height: 24.h, // Adjusted height for responsiveness
//             //                               width: 62.w, // Adjusted width for responsiveness
//             //                               decoration: BoxDecoration(
//             //                                 borderRadius: BorderRadius.circular(3.r),
//             //                                 color: const Color(0xff140B40),
//             //                               ),
//             //                               child: const Center(
//             //                                 child: Text(
//             //                                   "JOIN NOW",
//             //                                   style: TextStyle(
//             //                                     fontWeight: FontWeight.w500,
//             //                                     fontSize: 8.4,
//             //                                     color: Colors.white,
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                             ),
//             //                           ],
//             //                         ),
//             //                         Column(
//             //                           mainAxisAlignment: MainAxisAlignment.end,
//             //                           crossAxisAlignment: CrossAxisAlignment.center,
//             //                           children: [
//             //                             Padding(
//             //                               padding: const EdgeInsets.symmetric(horizontal: 0.1),
//             //                               child: Stack(
//             //                                 alignment: Alignment.bottomCenter,
//             //                                 children: [
//             //                                   // Display the main image
//             //                                   Image.network(
//             //                                     worldCup.team2Details!.captain_photo ?? '',
//             //                                     height: MediaQuery.of(context).size.height * 0.15,
//             //                                     // width: 133.w,
//             //                                     fit: BoxFit.cover,
//             //                                   ),
//             //                                   // Blurred text area at the bottom
//             //                                   Positioned(
//             //                                     bottom: 0,
//             //                                     child: ClipRRect(
//             //                                       borderRadius: const BorderRadius.only(
//             //                                         topLeft: Radius.circular(15),
//             //                                         // topRight: Radius.circular(15),
//             //                                         bottomLeft: Radius.circular(1),
//             //                                         bottomRight: Radius.circular(1),
//             //                                       ),
//             //                                       child: BackdropFilter(
//             //                                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5), // Adjust blur intensity as needed
//             //                                         child: Container(
//             //                                           width: 137.w,
//             //                                           height: MediaQuery.of(context).size.height * 0.025, // Adjust height for the blurred section
//             //                                           color: Colors.black.withOpacity(0.3), // Transparent background to show the blur effect
//             //                                           child: Center(
//             //                                             child: Text(
//             //                                               worldCup.team2Details!.shortName.toString(),
//             //                                               style: TextStyle(
//             //                                                 fontSize: 13.sp,
//             //                                                 fontWeight: FontWeight.w500,
//             //                                                 color: Colors.white,
//             //                                               ),
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ),
//             //                                     ),
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                             ),
//             //                           ],
//             //                         ),
//             //                         // Column(
//             //                         //   mainAxisAlignment: MainAxisAlignment.end,
//             //                         //   crossAxisAlignment: CrossAxisAlignment.center,
//             //                         //   children: [
//             //                         //     Padding(
//             //                         //       padding: EdgeInsets.only(left: 7.w),
//             //                         //       child: Image.network(
//             //                         //         worldCup.team2Details!.captain_photo ?? '',
//             //                         //         height: 100.h,
//             //                         //       ),
//             //                         //     ),
//             //                         //     Container(
//             //                         //       height: 21.7.h, // Adjusted height for responsiveness
//             //                         //       width: 133.w, // Adjusted width for responsiveness
//             //                         //       decoration: BoxDecoration(
//             //                         //         borderRadius: BorderRadius.only(
//             //                         //           bottomRight: Radius.circular(10.r),
//             //                         //         ),
//             //                         //         image: const DecorationImage(
//             //                         //           image: AssetImage('assets/nz_blur.png'),
//             //                         //           fit: BoxFit.cover,
//             //                         //         ),
//             //                         //       ),
//             //                         //       child: Center(
//             //                         //         child: Text(
//             //                         //           worldCup.team2Details!.shortName.toString(),
//             //                         //           style: TextStyle(
//             //                         //             fontSize: 13.sp,
//             //                         //             fontWeight: FontWeight.w500,
//             //                         //             color: Colors.white,
//             //                         //           ),
//             //                         //         ),
//             //                         //       ),
//             //                         //     ),
//             //                         //   ],
//             //                         // ),
//             //                       ],
//             //                     ),
//             //                   ),
//             //                 );
//             //               },
//             //             )  : const SizedBox(),
//             //           ),
//             //           SizedBox(
//             //             height: 15.h,
//             //           ),
//             //         if(upcomingMatch.isNotEmpty)...[
//             //           InkWell(
//             //             onTap: () {
//             //               Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                     builder: (context) => const Upcominglistscreen(),
//             //                   ));
//             //             },
//             //             child: Row(
//             //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //               children: [
//             //                 NormalText(
//             //                     fontWeight: FontWeight.w600,
//             //                     color: Colors.black,
//             //                     text: "Upcoming Matches"),
//             //                 Row(
//             //                   children: [
//             //                     SmallText(color: Colors.grey, text: "View All"),
//             //                     Icon(
//             //                       Icons.arrow_forward_ios,
//             //                       size: 18.sp,
//             //                       color: Colors.grey,
//             //                     )
//             //                   ],
//             //                 )
//             //               ],
//             //             ),
//             //           ),]else...[
//             //           const SizedBox(),
//             //         ],
//             //           SizedBox(
//             //             height: 10.h,
//             //           ),
//             //           InkWell(
//             //             onTap: (){
//             //               // Navigator.push(context, MaterialPageRoute(builder: (context)=> Contestscrenn()));
//             //             },
//             //             child: SizedBox(
//             //               height: upcomingMatch.isNotEmpty ? 165.h : 0, // Responsive height using ScreenUtil
//             //               child: upcomingMatch.isNotEmpty // Check if myMatch is not empty
//             // ?ListView.builder(
//             //                 itemCount: upcomingMatch.length,
//             //                 scrollDirection: Axis.horizontal,
//             //                 itemBuilder: (context, index) {
//             //                   final upcoming = upcomingMatch[index];
//             //                   return InkWell(
//             //                     onTap: () {
//             //                       Navigator.push(
//             //                         context,
//             //                         MaterialPageRoute(
//             //                           builder: (context) => IndVsSaScreens(
//             //                             firstMatch: upcoming.matchDetails!.team1Details!.shortName,
//             //                             secMatch: upcoming.matchDetails!.team2Details!.shortName,
//             //                             matchName: upcoming.matchDetails!.matchName,
//             //                             Id: upcoming.matchDetails!.id,
//             //                           ),
//             //                         ),
//             //                       );
//             //                     },
//             //                     child: Container(
//             //                       height: 150.h, // Responsive height using ScreenUtil
//             //                       margin: EdgeInsets.only(right: 15.r), // Responsive margin
//             //                       width: 291.w, // Responsive width using ScreenUtil
//             //                       decoration: BoxDecoration(
//             //                         borderRadius: BorderRadius.circular(12.r), // Responsive border radius
//             //                         color: Colors.white,
//             //                       ),
//             //                       child: Column(
//             //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                         children: [
//             //
//             //                           Container(
//             //                             height: 30.h, // Responsive height using ScreenUtil
//             //                             width: double.infinity,
//             //                             padding: EdgeInsets.only(left: 15.r, top: 7.r), // Responsive padding
//             //                             decoration: BoxDecoration(
//             //                               color: Colors.black.withOpacity(0.1),
//             //                               borderRadius: BorderRadius.only(
//             //                                 topLeft: Radius.circular(12.r),
//             //                                 topRight: Radius.circular(12.r),
//             //                               ),
//             //                             ),
//             //                             child: Text(
//             //                               "Indian Premier League",
//             //                               style: TextStyle(
//             //                                 fontSize: 12.sp, // Responsive font size
//             //                                 fontWeight: FontWeight.w500,
//             //                               ),
//             //                             ),
//             //                           ),
//             //                           Padding(
//             //                             padding: EdgeInsets.symmetric(horizontal: 12.w), // Responsive padding
//             //                             child: Row(
//             //                               children: [
//             //                                 Image.network(
//             //                                   upcoming.matchDetails?.team1Details!.logo ?? 'https://via.placeholder.com/150',
//             //                                   height: 63.h, // Responsive image height
//             //                                   errorBuilder: (context, error, stackTrace) {
//             //                                     return Image.asset(
//             //                                       'assets/default_image.png',
//             //                                       height: 63.h, // Fallback image height
//             //                                     );
//             //                                   },
//             //                                 ),
//             //                                 SizedBox(width: 8.w), // Responsive spacing
//             //                                 Text(
//             //                                   upcoming.matchDetails!.team1Details!.shortName ?? "",
//             //                                   style: TextStyle(
//             //                                     fontSize: 14.sp, // Responsive font size
//             //                                     fontWeight: FontWeight.w500,
//             //                                   ),
//             //                                 ),
//             //                                 const Spacer(),
//             //                                 Column(
//             //                                   children: [
//             //                                     Text(
//             //                                       // upcoming!.matchDetails!.date!.toString() ?? "",
//             //                                       _formatMatchDate(upcoming.matchDetails!.date),
//             //
//             //                                       // "Today",
//             //                                       style: TextStyle(
//             //                                         fontWeight: FontWeight.w400,
//             //                                         fontSize: 12.sp, // Responsive font size
//             //                                         color: Colors.grey,
//             //                                       ),
//             //                                     ),
//             //                                     Text(
//             //                                       upcoming.matchDetails!.time ?? "",
//             //                                       style: TextStyle(
//             //                                         fontWeight: FontWeight.w500,
//             //                                         fontSize: 14.sp, // Responsive font size
//             //                                         color: Colors.red,
//             //                                       ),
//             //                                     ),
//             //                                   ],
//             //                                 ),
//             //                                 const Spacer(),
//             //                                 Text(
//             //                                   upcoming.matchDetails!.team2Details!.shortName ?? "",
//             //                                   style: TextStyle(
//             //                                     fontSize: 14.sp, // Responsive font size
//             //                                     fontWeight: FontWeight.w500,
//             //                                   ),
//             //                                 ),
//             //                                 SizedBox(width: 8.w), // Responsive spacing
//             //                                 Image.network(
//             //                                   upcoming.matchDetails?.team2Details!.logo ?? 'https://via.placeholder.com/150',
//             //                                   height: 63.h, // Responsive image height
//             //                                   errorBuilder: (context, error, stackTrace) {
//             //                                     return Image.asset(
//             //                                       'assets/default_image.png',
//             //                                       height: 63.h, // Fallback image height
//             //                                     );
//             //                                   },
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                           Divider(
//             //                             height: 1.h, // Responsive divider height
//             //                             color: Colors.grey.shade300,
//             //                           ),
//             //                           Padding(
//             //                             padding: EdgeInsets.symmetric(horizontal: 6.w), // Responsive padding
//             //                             child: Container(
//             //                               padding: EdgeInsets.symmetric(vertical: 12.h), // Responsive padding
//             //                               width: double.infinity,
//             //                               decoration: BoxDecoration(
//             //                                 borderRadius: BorderRadius.circular(8.r), // Responsive border radius
//             //                                 color: const Color(0xff140B40),
//             //                               ),
//             //                               child: Center(
//             //                                 child: Text(
//             //                                   "Join Now",
//             //                                   style: TextStyle(
//             //                                     fontSize: 12.sp, // Responsive font size
//             //                                     fontWeight: FontWeight.w500,
//             //                                     color: Colors.white,
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                             ),
//             //                           ),
//             //                           SizedBox(height: 1.h),
//             //                         ],
//             //                       ),
//             //                     ),
//             //                   );
//             //                 },
//             //               )  : const SizedBox(),
//             //             ),
//             //
//             //           ),
//             //           SizedBox(
//             //             height: 15.h,
//             //           ),
//             //           if(myMatch.isNotEmpty)...[
//             //           Row(
//             //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //             children: [
//             //               NormalText(
//             //                   fontWeight: FontWeight.w600,
//             //                   color: Colors.black,
//             //                   text: "My Matches"),
//             //               InkWell(
//             //                 onTap: (){
//             //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>  const MyMatchesViewall(
//             //                   )));
//             //                 },
//             //                 child: Row(
//             //                   children: [
//             //                     SmallText(color: Colors.grey, text: "View All"),
//             //                     Icon(
//             //                       Icons.arrow_forward_ios,
//             //                       size: 18.sp,
//             //                       color: Colors.grey,
//             //                     )
//             //                   ],
//             //                 ),
//             //               )
//             //             ],
//             //           ),]else...[
//             //             const SizedBox(),
//             //           ],
//             //           SizedBox(
//             //             height: 10.h,
//             //           ),
//             //           SizedBox(
//             //             height: myMatch.isNotEmpty ?
//             //                 155.h
//             //             // MediaQuery
//             //             //     .of(context)
//             //             //     .size
//             //             //     .height /5.5
//             //                 : 0, // Set height to 0 if myMatch is empty
//             //             child: myMatch.isNotEmpty // Check if myMatch is not empty
//             //                 ? ListView.builder(
//             //               itemCount: myMatch.length,
//             //               scrollDirection: Axis.horizontal,
//             //               itemBuilder: (context, index) {
//             //                 final userMatch = myMatch[index];
//             //                 return Center(
//             //                   child: Container(
//             //                     margin: EdgeInsets.only(right: 15.r),
//             //                     width: 295.w,
//             //                     decoration: BoxDecoration(
//             //                       borderRadius: BorderRadius.circular(12.r),
//             //                       color: Colors.white,
//             //                     ),
//             //                     child: Column(
//             //                       crossAxisAlignment: CrossAxisAlignment.center,
//             //                       children: [
//             //                         Container(
//             //                           height: 30.h,
//             //                           width: double.infinity,
//             //                           padding: EdgeInsets.symmetric(horizontal: 15.r),
//             //                           decoration: BoxDecoration(
//             //                             color: Colors.black.withOpacity(0.1),
//             //                             borderRadius: BorderRadius.only(
//             //                               topLeft: Radius.circular(12.r),
//             //                               topRight: Radius.circular(12.r),
//             //                             ),
//             //                           ),
//             //                           child: Row(
//             //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                             crossAxisAlignment: CrossAxisAlignment.center,
//             //                             children: [
//             //                               Text(
//             //                                 "Indian Premier League",
//             //                                 style: TextStyle(
//             //                                   fontSize: 12.sp,
//             //                                   fontWeight: FontWeight.w500,
//             //                                 ),
//             //                               ),
//             //                               Row(
//             //                                 children: [
//             //                                   Container(
//             //                                     height: 5.h,
//             //                                     width: 5.w,
//             //                                     decoration: BoxDecoration(
//             //                                       borderRadius: BorderRadius.circular(5.r),
//             //                                       color: Colors.red,
//             //                                     ),
//             //                                   ),
//             //                                   SizedBox(width: 5.w),
//             //                                   Text(
//             //                                     "Live",
//             //                                     style: TextStyle(
//             //                                       fontSize: 12.sp,
//             //                                       fontWeight: FontWeight.w400,
//             //                                     ),
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 12.h),
//             //                         Padding(
//             //                           padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 2.r),
//             //                           child: Column(
//             //                             children: [
//             //                               Row(
//             //                                 children: [
//             //                                   SizedBox(width: 8.w),
//             //                                   Image.network(
//             //                                     userMatch.userMatchDetails?.team1Details?.logo ?? 'https://via.placeholder.com/26',
//             //                                     height: 36.h,
//             //                                     errorBuilder: (context, error, stackTrace) {
//             //                                       return Image.asset('assets/default_team_image.png', height: 26.h);
//             //                                     },
//             //                                   ),
//             //                                   SizedBox(width: 8.w),
//             //                                   Text(
//             //                                     userMatch.userMatchDetails?.team1Details?.shortName ?? "",
//             //                                     style: TextStyle(
//             //                                       fontSize: 14.sp,
//             //                                       fontWeight: FontWeight.w500,
//             //                                     ),
//             //                                   ),
//             //                                   const Spacer(),
//             //                                   Column(
//             //                                     children: [
//             //                                       Text(
//             //                                         _formatMatchDate(userMatch.userMatchDetails!.date),
//             //
//             //                                         // "Today",
//             //                                         style: TextStyle(
//             //                                           fontWeight: FontWeight.w400,
//             //                                           fontSize: 12.sp,
//             //                                           color: Colors.grey,
//             //                                         ),
//             //                                       ),
//             //                                       Text(
//             //                                         // userMatch.userMatchDetails!.city ?? "",
//             //                                         userMatch.userMatchDetails!.time ?? "",
//             //                                         // "selected bat",
//             //                                         style: TextStyle(
//             //                                           fontWeight: FontWeight.w400,
//             //                                           fontSize: 12.sp,
//             //                                           color: Colors.red,
//             //                                         ),
//             //                                       ),
//             //                                     ],
//             //                                   ),
//             //                                   const Spacer(),
//             //                                   Text(
//             //                                     userMatch.userMatchDetails?.team2Details?.shortName ?? "",
//             //                                     style: TextStyle(
//             //                                       fontSize: 14.sp,
//             //                                       fontWeight: FontWeight.w500,
//             //                                     ),
//             //                                   ),
//             //                                   SizedBox(width: 8.w),
//             //                                   Image.network(
//             //                                     userMatch.userMatchDetails?.team2Details?.logo ?? 'https://via.placeholder.com/26',
//             //                                     height: 36.h,
//             //                                     errorBuilder: (context, error, stackTrace) {
//             //                                       return Image.asset('assets/default_team_image.png', height: 26.h);
//             //                                     },
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                               // Row(
//             //                               //   children: [
//             //                               //     Text(
//             //                               //       "280/6",
//             //                               //       style: TextStyle(
//             //                               //         fontSize: 14.sp,
//             //                               //         color: Colors.black,
//             //                               //       ),
//             //                               //     ),
//             //                               //     SizedBox(width: 3.w),
//             //                               //     Text(
//             //                               //       "(50)",
//             //                               //       style: TextStyle(
//             //                               //         fontSize: 10.sp,
//             //                               //         color: Colors.black,
//             //                               //       ),
//             //                               //     ),
//             //                               //     const Spacer(),
//             //                               //     Text(
//             //                               //       "221/10",
//             //                               //       style: TextStyle(
//             //                               //         fontSize: 14.sp,
//             //                               //         color: Colors.black,
//             //                               //       ),
//             //                               //     ),
//             //                               //     SizedBox(width: 3.w),
//             //                               //     Text(
//             //                               //       "(40.3 )",
//             //                               //       style: TextStyle(
//             //                               //         fontSize: 10.sp,
//             //                               //         color: Colors.black,
//             //                               //       ),
//             //                               //     ),
//             //                               //   ],
//             //                               // ),
//             //                               SizedBox(height: 12.h),
//             //                               Divider(
//             //                                 height: 1.h,
//             //                                 color: Colors.grey.shade300,
//             //                               ),
//             //                               SizedBox(height: 12.h),
//             //                               Row(
//             //                                 children: [
//             //                                   Expanded(
//             //                                     child: Container(
//             //                                       padding: const EdgeInsets.all(10),
//             //                                       decoration: BoxDecoration(
//             //                                         borderRadius: BorderRadius.circular(5.r),
//             //                                         color: const Color(0xff140B40).withOpacity(0.1),
//             //                                       ),
//             //                                       child: InkWell(
//             //                                         onTap: () {
//             //                                           Navigator.push(
//             //                                             context,
//             //                                             MaterialPageRoute(
//             //                                               builder: (context) => ViewState(
//             //                                                 matchId: userMatch.userMatchDetails!.id,
//             //                                               ),
//             //                                             ),
//             //                                           );
//             //                                         },
//             //                                         child: Center(
//             //                                           child: Text(
//             //                                             "View Stats",
//             //                                             style: TextStyle(
//             //                                               fontSize: 12.sp,
//             //                                               fontWeight: FontWeight.w500,
//             //                                               color: const Color(0xff140B40),
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ),
//             //                                     ),
//             //                                   ),
//             //                                   SizedBox(width: 10.w),
//             //                                   Expanded(
//             //                                     child: InkWell(
//             //                                       onTap: () {
//             //                                         Navigator.push(
//             //                                           context,
//             //                                           MaterialPageRoute(
//             //                                             builder: (context) => IndVsSaScreens(
//             //                                               Id: userMatch.userMatchDetails!.id.toString(),
//             //                                               matchName: userMatch.userMatchDetails!.matchName.toString(),
//             //                                               defaultTabIndex: 2,
//             //                                             ),
//             //                                           ),
//             //                                         );
//             //                                       },
//             //                                       child: Container(
//             //                                         padding: const EdgeInsets.all(10),
//             //                                         decoration: BoxDecoration(
//             //                                           borderRadius: BorderRadius.circular(5.r),
//             //                                           color: const Color(0xff140B40),
//             //                                         ),
//             //                                         child: Center(
//             //                                           child: AutoSizeText(
//             //                                             "My Team",
//             //                                             style: TextStyle(
//             //                                               fontSize: 12.sp,
//             //                                               fontWeight: FontWeight.w500,
//             //                                               color: Colors.white,
//             //                                             ),
//             //                                           ),
//             //                                         ),
//             //                                       ),
//             //                                     ),
//             //                                   ),
//             //                                 ],
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ],
//             //                     ),
//             //                   ),
//             //                 );
//             //               },
//             //             )
//             //                 : const SizedBox(), // Return an empty SizedBox if myMatch is empty
//             //           ),
//             //           SizedBox(
//             //             height: 20.h,
//             //           )
//             //         ],
//             //       ),
//             //     ),
//             //   );
//
//
// // SizedBox(
// //
// //   height: 185.h, // Adjusted height for better responsiveness
// //   child: ListView.builder(
// //     itemCount: myMatch.length,
// //     scrollDirection: Axis.horizontal,
// //     itemBuilder: (context, index) {
// //       final userMatch = myMatch[index];
// //       return Center(
// //         child: Container(
// //           // height: 185.h,
// //           margin: EdgeInsets.only(right: 15.r),
// //           width: 295.w,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12.r),
// //             color: Colors.white,
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Container(
// //                 height: 30.h,
// //                 width: double.infinity,
// //                 padding: EdgeInsets.symmetric(horizontal: 15.r),
// //                 decoration: BoxDecoration(
// //                   color: Colors.black.withOpacity(0.1),
// //                   borderRadius: BorderRadius.only(
// //                     topLeft: Radius.circular(12.r),
// //                     topRight: Radius.circular(12.r),
// //                   ),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       "Indian Premier League",
// //                       style: TextStyle(
// //                         fontSize: 12.sp,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                     Row(
// //                       children: [
// //                         Container(
// //                           height: 5.h,
// //                           width: 5.w,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(5.r),
// //                             color: Colors.red,
// //                           ),
// //                         ),
// //                         SizedBox(width: 5.w),
// //                         Text(
// //                           "Live",
// //                           style: TextStyle(
// //                             fontSize: 12.sp,
// //                             fontWeight: FontWeight.w400,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 12.h),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 2.r),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         SizedBox(width: 8.w),
// //                         Image.network(
// //                           userMatch.userMatchDetails?.team1Details?.logo ?? 'https://via.placeholder.com/26',
// //                           height: 36.h,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             return Image.asset('assets/default_team_image.png', height: 26.h);
// //                           },
// //                         ),
// //                         SizedBox(width: 8.w),
// //                         Text(
// //                           userMatch.userMatchDetails?.team1Details?.shortName ?? "",
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         const Spacer(),
// //                         Column(
// //                           children: [
// //                             Text(
// //                               "Today",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w400,
// //                                 fontSize: 12.sp,
// //                                 color: Colors.grey,
// //                               ),
// //                             ),
// //                             Text(
// //                               "elected bat",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w400,
// //                                 fontSize: 12.sp,
// //                                 color: Colors.grey,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const Spacer(),
// //                         Text(
// //                           userMatch.userMatchDetails?.team2Details?.shortName ?? "",
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         SizedBox(width: 8.w),
// //                         Image.network(
// //                           userMatch.userMatchDetails?.team2Details?.logo ?? 'https://via.placeholder.com/26',
// //                           height: 36.h,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             return Image.asset('assets/default_team_image.png', height: 26.h);
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         Text(
// //                           "280/6",
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                         SizedBox(width: 3.w),
// //                         Text(
// //                           "(50)",
// //                           style: TextStyle(
// //                             fontSize: 10.sp,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                         const Spacer(),
// //                         Text(
// //                           "221/10",
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                         SizedBox(width: 3.w),
// //                         Text(
// //                           "(40.3)",
// //                           style: TextStyle(
// //                             fontSize: 10.sp,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     Divider(
// //                       height: 1.h,
// //                       color: Colors.grey.shade300,
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: Container(
// //                             padding: const EdgeInsets.all(10),
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(5.r),
// //                               color: const Color(0xff140B40).withOpacity(0.1),
// //                             ),
// //                             child: InkWell(
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => ViewState(
// //                                       matchId: userMatch.userMatchDetails!.id,
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                               child: Center(
// //                                 child: Text(
// //                                   "View Stats",
// //                                   style: TextStyle(
// //                                     fontSize: 12.sp,
// //                                     fontWeight: FontWeight.w500,
// //                                     color: const Color(0xff140B40),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 10.w),
// //                         Expanded(
// //                           child: InkWell(
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => IndVsSaScreens(
// //                                     Id: userMatch!.userMatchDetails!.id.toString(),
// //                                     matchName: userMatch!.userMatchDetails!.matchName.toString(),
// //                                     defaultTabIndex: 2,
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                             child: Container(
// //                               padding: const EdgeInsets.all(10),
// //                               decoration: BoxDecoration(
// //                                 borderRadius: BorderRadius.circular(5.r),
// //                                 color: const Color(0xff140B40),
// //                               ),
// //                               child: Center(
// //                                 child: AutoSizeText(
// //                                   "My Team",
// //                                   style: TextStyle(
// //                                     fontSize: 12.sp,
// //                                     fontWeight: FontWeight.w500,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   ),
// // ),
//
//
//
//
// // void startTimer(String? matchTime) {
// //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
// //     setState(() {
// //       adjustedTime = adjustMatchTime(matchTime);
// //     });
// //   });
// // }
//
// // Future<bool> _showExitConfirmationDialog(BuildContext context) async {
// //   return showDialog<bool>(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text('Exit Confirmation'),
// //         content: Text('Are you sure you want to exit?'),
// //         actions: <Widget>[
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop(false); // User pressed No
// //             },
// //             child: Text('No'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop(true); // User pressed Yes
// //             },
// //             child: Text('Yes'),
// //           ),
// //         ],
// //       );
// //     },
// //   ).then((value) => value ?? false); // Return false if dialog is dismissed
// // }
// // Future<bool> _showExitConfirmationDialog(BuildContext context) async {
// //   return showDialog<bool>(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return Dialog(
// //         child: Container(
// //           padding: const EdgeInsets.all(20),
// //           height: 280,
// //           width: MediaQuery.of(context).size.width,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(20),
// //             color: Colors.white,
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               SizedBox(height: 15),
// //               Image.asset(
// //                 'assets/log_pop.png',
// //                 height: 70,
// //                 color: Color(0xff140B40),
// //               ),
// //               SizedBox(height: 15),
// //               Text(
// //                 "Are you sure you want",
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   letterSpacing: 0.8,
// //                   color: const Color(0xff140B40),
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               Text(
// //                 "to Exit?",
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   letterSpacing: 0.8,
// //                   color: const Color(0xff140B40),
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               SizedBox(height: 30),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: InkWell(
// //                       onTap: () {
// //                         Navigator.of(context).pop(true); // User pressed Yes
// //                       },
// //                       child: Container(
// //                         height: 50,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(9),
// //                           color: const Color(0xff010101).withOpacity(0.35),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             "Yes",
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               color: Colors.black,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(width: 13),
// //                   Expanded(
// //                     child: InkWell(
// //                       onTap: () {
// //                         Navigator.of(context).pop(false); // User pressed No
// //                       },
// //                       child: Container(
// //                         height: 50,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(9),
// //                           color: const Color(0xff140B40),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             "No",
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   ).then((value) => value ?? false); // Return false if dialog is dismissed
// // }
// // Future<bool> _onWillPop() async {
// //   bool shouldExit = await _showExitConfirmationDialog(context);
// //   return shouldExit; // Return the boolean result
// // }

//         for (int i = 0; i < leagueMatches.length-1; i++) ...[
//           if (leagueMatches[i].isNotEmpty) ...[
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => IplAllMatch(leagueId: leagueMatches[i].first.leagueId),
//                   ),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   NormalText(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     text: data.data![i].leagueDetails!.leaguaName.toString(),
//                   ),
//                   Row(
//                     children: [
//                       SmallText(color: Colors.grey, text: "View All"),
//                       Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 186, // Responsive height
//               width: MediaQuery.of(context).size.width,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: leagueMatches[i].length,
//                 itemBuilder: (context, index) {
//                   final match = leagueMatches[i][index];
//                   DateTime? matchDate = match.date;
//                   final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
//                   String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
//                   final team1LogoUrl = match.team1Details?.logo ?? '';
//                   final team2LogoUrl = match.team2Details?.logo ?? '';
//
//                   // Check the league type and render accordingly
//
//                     return _buildUpcomingMatchCard(match, team1LogoUrl, team2LogoUrl);
//
//                 },
//               ),
//             ),
//             const SizedBox(height: 15),
//           if(wordCupMatch.isNotEmpty)...[
//             InkWell(
//               onTap: (){
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>  WorldcupMatch(leagueId:wordCupMatch.first.leagueId,),
//                     ));
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   NormalText(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                       text:
//                       data.data?[2].leagueDetails?.leaguaName ?? ""),
//                   Row(
//                     children: [
//                       SmallText(color: Colors.grey, text: "View All"),
//                       const Icon(
//                         Icons.arrow_forward_ios,
//                         size: 18,
//                         color: Colors.grey,
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),]else...[
//             const SizedBox(),
//           ],
//           const SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             // height: MediaQuery.of(context).size.height *0.3,
//             height: wordCupMatch.isNotEmpty ? 180 : 0,
//             width: MediaQuery.of(context).size.width * 12, // Full width of the container
//             child: wordCupMatch.isNotEmpty // Check if myMatch is not empty
//                 ?ListView.builder(
//               itemCount: wordCupMatch.length,
//               // scrollDirection: Axis.horizontal,
//
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               // scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 final worldCup = wordCupMatch[index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => IndVsSaScreens(
//                           firstMatch: worldCup.team1Details!.shortName,
//                           secMatch: worldCup.team2Details!.shortName,
//                           matchName: worldCup.matchName,
//                           Id: worldCup.id,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
//                     height: 180, // Adjusted height for responsiveness
//
//                     // width: double.infinity,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.r), // Adjusted border radius for responsiveness
//                       image: const DecorationImage(
//                         image: AssetImage('assets/card_bg.png'),
//                         fit: BoxFit.cover,
//                         opacity: 0.1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 0.5),
//                                 child: Stack(
//                                   alignment: Alignment.bottomCenter,
//                                   children: [
//                                     // Display the main image
//                                     Image.network(
//                                       worldCup.team1Details!.captain_photo ?? '',
//                                       height: MediaQuery.of(context).size.height * 0.15,
//                                       // width: 133.w,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     // Blurred text area at the bottom
//                                     Positioned(
//                                       bottom: 0,
//                                       child: ClipRRect(
//                                         borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(30),
//                                           bottomLeft: Radius.circular(8),
//                                           bottomRight: Radius.circular(2),
//                                         ),
//                                         child: BackdropFilter(
//                                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5), // Adjust blur intensity as needed
//                                           child: Container(
//                                             width: 133.w,
//                                             height: MediaQuery.of(context).size.height * 0.025, // Adjust height for the blurred section
//                                             color: Colors.black.withOpacity(0.3), // Transparent background to show the blur effect
//                                             child: Center(
//                                               child: Text(
//                                                 worldCup.team1Details!.shortName.toString(),
//                                                 style: TextStyle(
//                                                   fontSize: 13.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               worldCup.matchName.toString(),
//                               style: TextStyle(
//                                 fontSize: 15.sp,
//                                 fontWeight: FontWeight.w800,
//                                 color: const Color(0xff140B40),
//                               ),
//                             ),
//
//                             const Text(
//                               "Starts at",
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xff140B40),
//                               ),
//                             ),
//                             Text(
//                               "${worldCup.time} PM IST",
//                               style: TextStyle(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xff140B40),
//                               ),
//                             ),
//                             SizedBox(height: 15.h),
//                             Container(
//                               height: 24.h, // Adjusted height for responsiveness
//                               width: 62.w, // Adjusted width for responsiveness
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(3.r),
//                                 color: const Color(0xff140B40),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "JOIN NOW",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 8.4,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 0.1),
//                               child: Stack(
//                                 alignment: Alignment.bottomCenter,
//                                 children: [
//                                   // Display the main image
//                                   Image.network(
//                                     worldCup.team2Details!.captain_photo ?? '',
//                                     height: MediaQuery.of(context).size.height * 0.15,
//                                     // width: 133.w,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   // Blurred text area at the bottom
//                                   Positioned(
//                                     bottom: 0,
//                                     child: ClipRRect(
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(15),
//                                         // topRight: Radius.circular(15),
//                                         bottomLeft: Radius.circular(1),
//                                         bottomRight: Radius.circular(1),
//                                       ),
//                                       child: BackdropFilter(
//                                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5), // Adjust blur intensity as needed
//                                         child: Container(
//                                           width: 137.w,
//                                           height: MediaQuery.of(context).size.height * 0.025, // Adjust height for the blurred section
//                                           color: Colors.black.withOpacity(0.3), // Transparent background to show the blur effect
//                                           child: Center(
//                                             child: Text(
//                                               worldCup.team2Details!.shortName.toString(),
//                                               style: TextStyle(
//                                                 fontSize: 13.sp,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )  : const SizedBox(),
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           if(upcomingMatch.isNotEmpty)...[
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Upcominglistscreen(),
//                     ));
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   NormalText(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                       text: "Upcoming Matches"),
//                   Row(
//                     children: [
//                       SmallText(color: Colors.grey, text: "View All"),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 18.sp,
//                         color: Colors.grey,
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),]else...[
//             const SizedBox(),
//           ],
//           SizedBox(
//             height: 10.h,
//           ),
//           InkWell(
//             onTap: (){
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=> Contestscrenn()));
//             },
//             child: SizedBox(
//               height: upcomingMatch.isNotEmpty ? 165.h : 0, // Responsive height using ScreenUtil
//               child: upcomingMatch.isNotEmpty // Check if myMatch is not empty
//                   ?ListView.builder(
//                 itemCount: upcomingMatch.length,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   final upcoming = upcomingMatch[index];
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => IndVsSaScreens(
//                             firstMatch: upcoming.matchDetails!.team1Details!.shortName,
//                             secMatch: upcoming.matchDetails!.team2Details!.shortName,
//                             matchName: upcoming.matchDetails!.matchName,
//                             Id: upcoming.matchDetails!.id,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 150.h, // Responsive height using ScreenUtil
//                       margin: EdgeInsets.only(right: 15.r), // Responsive margin
//                       width: 291.w, // Responsive width using ScreenUtil
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.r), // Responsive border radius
//                         color: Colors.white,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//
//                           Container(
//                             height: 30.h, // Responsive height using ScreenUtil
//                             width: double.infinity,
//                             padding: EdgeInsets.only(left: 15.r, top: 7.r), // Responsive padding
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.1),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(12.r),
//                                 topRight: Radius.circular(12.r),
//                               ),
//                             ),
//                             child: Text(
//                               "Indian Premier League",
//                               style: TextStyle(
//                                 fontSize: 12.sp, // Responsive font size
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12.w), // Responsive padding
//                             child: Row(
//                               children: [
//                                 Image.network(
//                                   upcoming.matchDetails?.team1Details!.logo ?? 'https://via.placeholder.com/150',
//                                   height: 63.h, // Responsive image height
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.asset(
//                                       'assets/default_image.png',
//                                       height: 63.h, // Fallback image height
//                                     );
//                                   },
//                                 ),
//                                 SizedBox(width: 8.w), // Responsive spacing
//                                 Text(
//                                   upcoming.matchDetails!.team1Details!.shortName ?? "",
//                                   style: TextStyle(
//                                     fontSize: 14.sp, // Responsive font size
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       // upcoming!.matchDetails!.date!.toString() ?? "",
//                                       _formatMatchDate(upcoming.matchDetails!.date),
//
//                                       // "Today",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 12.sp, // Responsive font size
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       upcoming.matchDetails!.time ?? "",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14.sp, // Responsive font size
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   upcoming.matchDetails!.team2Details!.shortName ?? "",
//                                   style: TextStyle(
//                                     fontSize: 14.sp, // Responsive font size
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(width: 8.w), // Responsive spacing
//                                 Image.network(
//                                   upcoming.matchDetails?.team2Details!.logo ?? 'https://via.placeholder.com/150',
//                                   height: 63.h, // Responsive image height
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.asset(
//                                       'assets/default_image.png',
//                                       height: 63.h, // Fallback image height
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             height: 1.h, // Responsive divider height
//                             color: Colors.grey.shade300,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 6.w), // Responsive padding
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 12.h), // Responsive padding
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.r), // Responsive border radius
//                                 color: const Color(0xff140B40),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Join Now",
//                                   style: TextStyle(
//                                     fontSize: 12.sp, // Responsive font size
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )  : const SizedBox(),
//             ),
//
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           if(myMatch.isNotEmpty)...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 NormalText(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     text: "My Matches"),
//                 InkWell(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>  const MyMatchesViewall(
//                     )));
//                   },
//                   child: Row(
//                     children: [
//                       SmallText(color: Colors.grey, text: "View All"),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 18.sp,
//                         color: Colors.grey,
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),]else...[
//             const SizedBox(),
//           ],
//           SizedBox(
//             height: 10.h,
//           ),
//           SizedBox(
//             height: myMatch.isNotEmpty ?
//             155.h
//             // MediaQuery
//             //     .of(context)
//             //     .size
//             //     .height /5.5
//                 : 0, // Set height to 0 if myMatch is empty
//             child: myMatch.isNotEmpty // Check if myMatch is not empty
//                 ? ListView.builder(
//               itemCount: myMatch.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 final userMatch = myMatch[index];
//                 return Center(
//                   child: Container(
//                     margin: EdgeInsets.only(right: 15.r),
//                     width: 295.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: Colors.white,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 30.h,
//                           width: double.infinity,
//                           padding: EdgeInsets.symmetric(horizontal: 15.r),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.1),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(12.r),
//                               topRight: Radius.circular(12.r),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Indian Premier League",
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 5.h,
//                                     width: 5.w,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5.r),
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   SizedBox(width: 5.w),
//                                   Text(
//                                     "Live",
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 12.h),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 2.r),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   SizedBox(width: 8.w),
//                                   Image.network(
//                                     userMatch.userMatchDetails?.team1Details?.logo ?? 'https://via.placeholder.com/26',
//                                     height: 36.h,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Image.asset('assets/default_team_image.png', height: 26.h);
//                                     },
//                                   ),
//                                   SizedBox(width: 8.w),
//                                   Text(
//                                     userMatch.userMatchDetails?.team1Details?.shortName ?? "",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   Column(
//                                     children: [
//                                       Text(
//                                         _formatMatchDate(userMatch.userMatchDetails!.date),
//
//                                         // "Today",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 12.sp,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text(
//                                         // userMatch.userMatchDetails!.city ?? "",
//                                         userMatch.userMatchDetails!.time ?? "",
//                                         // "selected bat",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 12.sp,
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   Text(
//                                     userMatch.userMatchDetails?.team2Details?.shortName ?? "",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   SizedBox(width: 8.w),
//                                   Image.network(
//                                     userMatch.userMatchDetails?.team2Details?.logo ?? 'https://via.placeholder.com/26',
//                                     height: 36.h,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Image.asset('assets/default_team_image.png', height: 26.h);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                                SizedBox(height: 12.h),
//                               Divider(
//                                 height: 1.h,
//                                 color: Colors.grey.shade300,
//                               ),
//                               SizedBox(height: 12.h),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5.r),
//                                         color: const Color(0xff140B40).withOpacity(0.1),
//                                       ),
//                                       child: InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => ViewState(
//                                                 matchId: userMatch.userMatchDetails!.id,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: Center(
//                                           child: Text(
//                                             "View Stats",
//                                             style: TextStyle(
//                                               fontSize: 12.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: const Color(0xff140B40),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Expanded(
//                                     child: InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => IndVsSaScreens(
//                                               Id: userMatch.userMatchDetails!.id.toString(),
//                                               matchName: userMatch.userMatchDetails!.matchName.toString(),
//                                               defaultTabIndex: 2,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(5.r),
//                                           color: const Color(0xff140B40),
//                                         ),
//                                         child: Center(
//                                           child: AutoSizeText(
//                                             "My Team",
//                                             style: TextStyle(
//                                               fontSize: 12.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//                 : const SizedBox(), // Return an empty SizedBox if myMatch is empty
//           ),
//           SizedBox(
//             height: 20.h,
//           )
//         ],
// ]

// SizedBox(
//   height: myMatch.isNotEmpty
//       ? 155.h
//   // MediaQuery
//   //     .of(context)
//   //     .size
//   //     .height /5.5
//       : 0, // Set height to 0 if myMatch is empty
//   child: myMatch
//       .isNotEmpty // Check if myMatch is not empty
//       ? ListView.builder(
//     itemCount: myMatch.length,
//     scrollDirection: Axis.horizontal,
//     itemBuilder: (context, index) {
//       final userMatch = myMatch[index];
//       return Center(
//         child: Container(
//           margin:
//           EdgeInsets.only(right: 15.r),
//           width: 295.w,
//           decoration: BoxDecoration(
//             borderRadius:
//             BorderRadius.circular(12.r),
//             color: Colors.white,
//           ),
//           child: Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: 30.h,
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 15.r),
//                 decoration: BoxDecoration(
//                   color: Colors.black
//                       .withOpacity(0.1),
//                   borderRadius:
//                   BorderRadius.only(
//                     topLeft:
//                     Radius.circular(12.r),
//                     topRight:
//                     Radius.circular(12.r),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment
//                       .spaceBetween,
//                   crossAxisAlignment:
//                   CrossAxisAlignment
//                       .center,
//                   children: [
//                     Text(
//                       "Indian Premier League",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight:
//                         FontWeight.w500,
//                       ),
//                     ),
//                     // Row(
//                     //   children: [
//                     //     Container(
//                     //       height: 5.h,
//                     //       width: 5.w,
//                     //       decoration:
//                     //           BoxDecoration(
//                     //         borderRadius:
//                     //             BorderRadius
//                     //                 .circular(
//                     //                     5.r),
//                     //         color: Colors.red,
//                     //       ),
//                     //     ),
//                     //     SizedBox(width: 5.w),
//                     //     Text(
//                     //       "Live",
//                     //       style: TextStyle(
//                     //         fontSize: 12.sp,
//                     //         fontWeight:
//                     //             FontWeight
//                     //                 .w400,
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 15.r,
//                     vertical: 2.r),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(width: 8.w),
//                         Image.network(
//                           userMatch
//                               .userMatchDetails
//                               ?.team1Details
//                               ?.logo ??
//                               'https://via.placeholder.com/26',
//                           height: 36.h,
//                           errorBuilder:
//                               (context, error,
//                               stackTrace) {
//                             return Image.asset(
//                                 'assets/default_team_image.png',
//                                 height: 26.h);
//                           },
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           userMatch
//                               .userMatchDetails
//                               ?.team1Details
//                               ?.shortName ??
//                               "",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight:
//                             FontWeight
//                                 .w500,
//                           ),
//                         ),
//                         const Spacer(),
//                         Column(
//                           children: [
//                             Text(
//                               _formatMatchDate(
//                                   userMatch
//                                       .userMatchDetails!
//                                       .date),
//
//                               // "Today",
//                               style:
//                               TextStyle(
//                                 fontWeight:
//                                 FontWeight
//                                     .w400,
//                                 fontSize:
//                                 12.sp,
//                                 color: Colors
//                                     .grey,
//                               ),
//                             ),
//                             Text(
//                               // userMatch.userMatchDetails!.city ?? "",
//                               userMatch
//                                   .userMatchDetails!
//                                   .time ??
//                                   "",
//                               // "selected bat",
//                               style:
//                               TextStyle(
//                                 fontWeight:
//                                 FontWeight
//                                     .w400,
//                                 fontSize:
//                                 12.sp,
//                                 color: Colors
//                                     .red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         Text(
//                           userMatch
//                               .userMatchDetails
//                               ?.team2Details
//                               ?.shortName ??
//                               "",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight:
//                             FontWeight
//                                 .w500,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Image.network(
//                           userMatch
//                               .userMatchDetails
//                               ?.team2Details
//                               ?.logo ??
//                               'https://via.placeholder.com/26',
//                           height: 36.h,
//                           errorBuilder:
//                               (context, error,
//                               stackTrace) {
//                             return Image.asset(
//                                 'assets/default_team_image.png',
//                                 height: 26.h);
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     Divider(
//                       height: 1.h,
//                       color: Colors
//                           .grey.shade300,
//                     ),
//                     SizedBox(height: 12.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding:
//                             const EdgeInsets
//                                 .all(10),
//                             decoration:
//                             BoxDecoration(
//                               borderRadius:
//                               BorderRadius
//                                   .circular(
//                                   5.r),
//                               color: const Color(
//                                   0xff140B40)
//                                   .withOpacity(
//                                   0.1),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator
//                                     .push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) =>
//                                         ViewState(
//                                           matchId: userMatch
//                                               .userMatchDetails!
//                                               .id,
//                                         ),
//                                   ),
//                                 );
//                               },
//                               child: Center(
//                                 child: Text(
//                                   "View Stats",
//                                   style:
//                                   TextStyle(
//                                     fontSize:
//                                     12.sp,
//                                     fontWeight:
//                                     FontWeight
//                                         .w500,
//                                     color: const Color(
//                                         0xff140B40),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) =>
//                                       IndVsSaScreens(
//                                         Id: userMatch
//                                             .userMatchDetails!
//                                             .id
//                                             .toString(),
//                                         matchName: userMatch
//                                             .userMatchDetails!
//                                             .matchName
//                                             .toString(),
//                                         defaultTabIndex:
//                                         2,
//                                       ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               padding:
//                               const EdgeInsets
//                                   .all(
//                                   10),
//                               decoration:
//                               BoxDecoration(
//                                 borderRadius:
//                                 BorderRadius
//                                     .circular(
//                                     5.r),
//                                 color: const Color(
//                                     0xff140B40),
//                               ),
//                               child: Center(
//                                 child:
//                                 AutoSizeText(
//                                   "My Team",
//                                   style:
//                                   TextStyle(
//                                     fontSize:
//                                     12.sp,
//                                     fontWeight:
//                                     FontWeight
//                                         .w500,
//                                     color: Colors
//                                         .white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   )
//       : const SizedBox(), // Return an empty SizedBox if myMatch is empty
// ),
