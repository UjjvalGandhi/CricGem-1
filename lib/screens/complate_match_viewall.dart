import 'dart:async';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../db/app_db.dart';
import '../model/ContentInsideModel.dart';
import '../model/UserMyMatchesModel.dart';
import '../model/imp_model.dart';
import '../widget/appbar_for_setting.dart';

class ComplateMatchesViewAll extends StatefulWidget {
  const ComplateMatchesViewAll({super.key});

  @override
  State<ComplateMatchesViewAll> createState() => _ComplateMatchesViewAllState();
}

class _ComplateMatchesViewAllState extends State<ComplateMatchesViewAll> {
  late Future<UserMyMatchesModel?> _futureData;
  List<Matches> ComplatedMatch = [];
  List<Matches> LiveMatch = [];
  final _contests = [];
  var currentUserId;
  var contestId;
  Leaderboard? currentUser;
  late Duration remainingTime = Duration.zero;
  late DateTime matchDateTime;
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
    // _futureData!.then((matchesModel) {
    //   fetchProfileData().then((_) {
    //     contestDisplay(); // Call contestDisplay after both fetches
    //   }).catchError((error) {
    //     debugPrint("Error fetching profile data: $error");
    //   });
    // }).catchError((error) {
    //   debugPrint("Error fetching matches data: $error");
    // });
    //startTimer();
  }

  // late Future<UserMyMatchesModel?> _FutureData;
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

  // Future<UserMyMatchesModel?> fetchMatches() async {
  //   try {
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
  //       final jsonData = json.decode(response.body);
  //       return UserMyMatchesModel.fromJson(jsonData);
  //     } else {
  //       throw Exception('Failed to load  my matches');
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint('Error fetching My Matches data: $e');
  //     debugPrint('Stack trace: $stackTrace');
  //     return null;
  //   }
  // }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
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
  //         for (var entry in data.data.leaderboard) {
  //           if (entry.userId == currentUserId) {
  //             currentUser = entry; // Store the current user's leaderboard data
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
  //       if (currentUser != null) {
  //         print('Current user winning amount222222222222222222222: ${currentUser!.winningAmount}');
  //       } else {
  //         print('Current user not found in leaderboard222222222222222.');
  //       }
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
  //
  // Future<HomeLeagModel?> profileDisplay() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     debugPrint('Token $token');
  //
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/user/desbord_details'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       final data = HomeLeagModel.fromJson(jsonDecode(response.body));
  //       debugPrint('Data: ${data.message}');
  //       print(response.statusCode);
  //       // print('mymatches ${myMatch}');
  //       print("print from if part ${response.body}");
  //
  //       return data;
  //     } else {
  //       debugPrint('Failed to fetch profile data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint('Error fetching profile data: $e');
  //     debugPrint('Stack trace: $stackTrace');
  //     return null;
  //   }
  // }
  //
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
  //
  //     // Format the adjusted time difference
  //     return "${hours.abs()}h ${minutes.abs()}m";
  //   } catch (e) {
  //     print("Error parsing or adjusting time: $e");
  //     return ""; // Handle any errors gracefully
  //   }
  // }

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
      //                 AppBarText(color: Colors.white, text: "Complate Match"),
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
      //               AppBarText(color: Colors.white, text: "Complate Match"),
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
        title: "Complate Match",
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
            final completedMatchesData =
                data.data?[2].completedMatches?.matches?.cast<Matches>() ?? [];
            //  LiveMatch = liveMatchesData.isNotEmpty ? liveMatchesData : [];
            // matchId = data.data?[0].liveMatches?.matches![0].id
            //UpcomingMatch = upcomingMatchesData.isNotEmpty ? upcomingMatchesData : [];
            ComplatedMatch =
                completedMatchesData.isNotEmpty ? completedMatchesData : [];
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
                  itemCount: ComplatedMatch.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final upcoming = ComplatedMatch[index];
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

                          // height: 148,
                          // width: MediaQuery.of(context).size.width,
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
                                      ComplatedMatch.isNotEmpty
                                          ? ComplatedMatch[index]
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
                                    '${ComplatedMatch[index].team1Details!.shortName}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    // "210/1 (40)",
                                    '${ComplatedMatch[index].teamScore!.team1!.score}',

                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.network(
                                      ComplatedMatch.isNotEmpty
                                          ? ComplatedMatch[index]
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
                                    '${ComplatedMatch[index].team2Details!.shortName}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    // "210/1 (40)",
                                    '${ComplatedMatch[index].teamScore!.team2!.score}',

                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 0.8,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.withOpacity(0.1)),
                                child: Center(
                                    child: Text(
                                  'You Won ₹${ComplatedMatch[index].winningAmount}',

                                  // "₹ ${currentUser?.winningAmount ?? '0' }",
                                  // "You won ₹58",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                )),
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
