import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../db/app_db.dart';

import '../../model/t20_world_cup.dart';
import '../../model/worldcupModeltest.dart';
import '../../widget/appbar_for_setting.dart';
import '../../widget/appbartext.dart';
import '../../widget/priceformatter.dart';
import '../ind_vs_sa_screen.dart';

class WorldcupMatch extends StatefulWidget {
  String? leagueId;
  String? leagueName; // Change this line

  WorldcupMatch({super.key, this.leagueId, this.leagueName});

  @override
  State<WorldcupMatch> createState() => _IplAllMatchState();
}

class _IplAllMatchState extends State<WorldcupMatch> {
  List<Match> primerMatch = [];
  late Future<WorldcupModeltest?> _futureData;

  Color _hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent; // or any default color you prefer
    }

    // Remove the leading '#', if it exists
    hexColor = hexColor.replaceAll('#', '');
    // Parse the string as a hex integer and convert to Color
    return Color(int.parse('FF$hexColor', radix: 16));
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
  Timer? _timer;
  String adjustedTime = '';

  void startTimer(String? matchTime) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        adjustedTime = adjustMatchTime(matchTime);
      });
    });
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
      DateTime matchDateTime =
          DateTime(now.year, now.month, now.day, matchHour, matchMinute);

      if (now.isAfter(matchDateTime)) {
        matchDateTime = matchDateTime.add(const Duration(days: 1));
      }

      Duration difference = matchDateTime.difference(now);

      if (difference.inHours < 12) {
        // Format the adjusted time difference
        int hours = difference.inHours;
        int minutes = difference.inMinutes % 60;
        return "$hours h $minutes m";
      } else {
        // Show the number of days remaining
        int days = difference.inDays;
        return "$days days remaining";
      }
    } catch (e) {
      print("Error parsing or adjusting time: $e");
      return ""; // Handle any errors gracefully
    }
  }

  Future<WorldcupModeltest?> fetchIplMatchList() async {
    String? token = await AppDB.appDB.getToken();
    debugPrint('Token $token');
    print(widget.leagueId);
    final response = await http.get(
      Uri.parse(
          'https://batting-api-1.onrender.com/api/match/displayListByLeagueId?leagueId=${widget.leagueId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "$token", // Replace with your token
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return WorldcupModeltest.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load match list: ${response.body}');
      return null;
    }
  }

  String calculateDaysRemaining(DateTime matchDate) {
    DateTime now = DateTime.now();
    Duration difference = matchDate.difference(now);
    return "${difference.inDays} days";
  }

  @override
  void initState() {
    super.initState();

    _futureData = fetchIplMatchList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      // appBar: PreferredSize(
      //   preferredSize:  Size.fromHeight(60.0.h),
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
      //         padding:  EdgeInsets.symmetric(horizontal: 20.w),
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
      //                 AppBarText(color: Colors.white, text: widget.leagueName! ?? "Worldcup Match"),
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
      //       automaticallyImplyLeading: false,
      //
      //       centerTitle: true,
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
      //               AppBarText(color: Colors.white, text: ),
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
        title: widget.leagueName! ?? "Worldcup Match",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<WorldcupModeltest?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching match list'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No match data available'));
            }
            final primerMatch = snapshot.data!.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: primerMatch?.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final match = primerMatch?[index];
                // DateTime? matchDate = match.date;
                // final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
                // String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
                // String matchTime = adjustMatchTime(match.time.toString());
                // String daysRemaining = matchDate != null ? calculateDaysRemaining(matchDate) : '';
                DateTime? matchDate;
                try {
                  matchDate = DateTime.parse(match!.date ?? '');
                } catch (e) {
                  matchDate = null;
                }

// Define DateFormat
                final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

// If matchDate is successfully parsed, format it
                String formattedDate =
                    matchDate != null ? dateFormatter.format(matchDate) : '';

// Adjust match time
                String matchTime = adjustMatchTime(match?.time.toString());

// Calculate days remaining
                String daysRemaining =
                    matchDate != null ? calculateDaysRemaining(matchDate) : '';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndVsSaScreens(
                            firstMatch: match.team1Details?.first.shortName,
                            secMatch: match.team2Details?.last.shortName,
                            matchName: match.matchName,
                            Id: match.id,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 190,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.01,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: const DecorationImage(
                                image: AssetImage("assets/card_bg_prev_ui.png"),
                                fit: BoxFit.cover),
                            gradient: LinearGradient(colors: [
                              _hexToColor(match?.team1Details?.first.colorCode),
                              _hexToColor(match?.team2Details?.last.colorCode),
                            ]),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      match!.team1Details!.first.shortName
                                          .toString(),
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
                                      match.team2Details!.last.shortName
                                          .toString(),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                match.team1Details?.first
                                                        .teamName ??
                                                    "",
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
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   matchTime,
                                                  //   style: const TextStyle(
                                                  //     fontSize: 14,
                                                  //     fontWeight: FontWeight.w500,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ),
                                                  Text(
                                                    daysRemaining,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                match.team2Details?.last
                                                        .teamName ??
                                                    "",
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.grey.shade300,
                                        ),
                                        const SizedBox(height: 5),
                                        //  Text(
                                        //    "Mega contest ${formatMegaPrice(match.megaPrice!)}",
                                        //   // "Mega Content ₹70 Crores",
                                        //   style: const TextStyle(
                                        //     fontSize: 12,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Color(0xffD4AF37),
                                        //   ),
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Mega contest ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xffD4AF37),
                                              ),
                                            ),
                                            PriceDisplay(
                                                price: match
                                                    .megaPrice!), // Assuming match.megaprice is an int
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
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, right: 30, left: 10),
                            child: Row(
                              children: [
                                Image.network(match.team1Details!.first.logo!,
                                    height: 63),
                                // Image.asset('assets/csk.png', height: 63),
                                const Spacer(),
                                // Image.asset('assets/mubai.png', height: 47),
                                Image.network(match.team2Details!.last.logo!,
                                    height: 63)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
