import 'dart:convert';
import 'package:batting_app/widget/appbar_for_team.dart';
import 'package:batting_app/widget/contest_bar.dart';
import 'package:flutter/material.dart';
import '../db/app_db.dart';
import 'package:http/http.dart' as http;
import '../model/ContentInsideModel.dart';
import '../model/MyTeamListModel.dart';
import '../model/ProfileDisplay.dart';
import '../model/WalletModel.dart';
import '../model/totalplayerpointmodal.dart';
import '../widget/normal2.0.dart';
import '../widget/priceformatter.dart';
import 'contestScreenList.dart';
import 'create_team.dart';
import 'ind_vs_sa_screen.dart';
import 'myteam_edit.dart';

class ContentInside extends StatefulWidget {
  final String? CId;
  final String? Id;
  final String? matchName;
  final bool isCreateTeam;

  // final String? Id;
  final String? MatchName;
  final String? firstMatch;
  final String? secMatch;
  final DateTime? date;
  final String? time;

  const ContentInside({
    super.key,
    this.CId,
    this.isCreateTeam = false,
    this.matchName,
    this.Id,
    this.MatchName,
    this.firstMatch,
    this.secMatch,
    this.date,
    this.time,
  });

  @override
  State<ContentInside> createState() => _ContentInsideState();
}

class ContestCategory {
  final String name;
  final int count;

  ContestCategory({required this.name, required this.count});
}

List<ContestCategory> categories = [
  ContestCategory(name: 'Mega Contest', count: 1),
  ContestCategory(name: 'Trending Now', count: 8),
  ContestCategory(name: 'Only For Beginners', count: 1),
  ContestCategory(name: 'Multiplier Contests', count: 3),
];


class _ContentInsideState extends State<ContentInside>
    with SingleTickerProviderStateMixin {
  bool isvisible = false;
  Set<String> displayedTeamIds = {};
  List<String> passingTeamIds = [];
  late List<Leaderboard> leaderboardData;
  Map<String, Map<String, int>> userTeamNumbers = {};
  late TabController _tabController;
  late Future<ContestInsideModel?> _futureData;
  List paymentImage = ['assets/paybg.png', 'assets/gbg.png', 'assets/ppbg.png'];
  List paymentText = [
    "PhonePe UPI Lite",
    "Google Pay UPI",
    "Amazon Pay UPI",
  ];
  var currentUserId;
  var totalpoints;
  final int _currentPage = 1;
  final int _messagesPerPage = 2;

  String? appId;
  late DateTime matchDateTime;
  late Duration remainingTime = Duration.zero;
  String currentBalance = "0";
  String fundsUtilizedBalance = "0";

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    playerTotalPoints();
    matchDisplay();
    // _futureData = contestDisplay();
    _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging && _tabController.index == 2) {
    //           print('tab is switching........!');// Assuming index 2 is for the Leaderboard
    //           fetchProfileData();
    //           playerTotalPoints();
    //           matchDisplay();
    //     fetchData(); // Fetch leaderboard data again when the tab is selected
    //   }
    // });
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     if (_tabController.index == 2) {
    //       print('tab is switching........!');// Assuming index 2 is for the Leaderboard
    //       fetchData(); // Fetch leaderboard data again when the tab is selected
    //     }
    //   }
    // });
    fetchData();
  }

  void fetchData() {
    setState(() {
      _futureData = contestDisplay(); // Fetch contest data
    });
  }

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

  @override
  void dispose() {
    _tabController.dispose();
    print("timimg:-${widget.time}");
    super.dispose();
  }

  String getFormattedTotalPoints() {
    // Check if totalPoints is a whole number
    if (totalpoints % 1 == 0) {
      return totalpoints.toInt().toString(); // Return as integer
    } else {
      return totalpoints.toStringAsFixed(1); // Return with one decimal place
    }
  }

  Future<void> fetchProfileData() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        print('fetching data again........');
        final data =
            ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
        debugPrint('data ${data.message}'); // Ensure to parse the correct field
        setState(() {
          currentUserId = "${data.data!.id}";
        });
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
  }

  // Future<ContestInsideModel?> contestDisplay() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     debugPrint('Token $token');
  //     final response = await http.get(
  //       // Uri.parse(
  //       //     'https://batting-api-1.onrender.com/api/contest/display?contestId=${widget.CId}&page=$_currentPage&limit=$_messagesPerPage'),
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/contest/display?contestId=${widget.CId}'),
  //
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = ContestInsideModel.fromJson(jsonDecode(response.body));
  //       debugPrint('Data: ${data.message}');
  //       print('iddd${data.data!.contestDetails!.id}');
  //       debugPrint("debugPrint from if part ${response.body}");
  //
  //       // Parse the match date and time
  //       matchDateTime =
  //           DateTime.parse(data.data!.contestDetails!.matchDate.toString()).add(
  //               Duration(
  //                   hours: int.parse(
  //                       data.data!.contestDetails!.matchTime!.split(':')[0]),
  //                   minutes: int.parse(
  //                       data.data!.contestDetails!.matchTime!.split(':')[1])));
  //
  //       // Calculate remaining time
  //       setState(() {
  //         remainingTime = matchDateTime.difference(DateTime.now());
  //
  //         print("remaining time is : -----$remainingTime");
  //         print("remaining time is : -----$matchDateTime");
  //         for (var leaderboardEntry in data.data!.leaderboard!) {
  //           passingTeamIds.addAll(leaderboardEntry.myTeamId!);
  //         }
  //         leaderboardData = data.data!.leaderboard!; // Store leaderboard data
  //
  //       });
  //       // passingTeamIds = data.data.leaderboard[0].myTeamId;
  //       debugPrint('Passing Team IDs: $passingTeamIds');
  //       return data;
  //     } else {
  //       debugPrint("this is else response::${response.body}");
  //       debugPrint('Failed to fetch contest data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching contest data: $e');
  //     return null;
  //   }
  // }
  Future<ContestInsideModel?> contestDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/contest/display?contestId=${widget.CId}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final data = ContestInsideModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print('iddd${data.data!.contestDetails!.id}');
        debugPrint("debugPrint from if part ${response.body}");

        // Parse the match date and time (assume UTC from API)
        matchDateTime =
            DateTime.parse(data.data!.contestDetails!.matchDate.toString()).add(
          Duration(
            hours:
                int.parse(data.data!.contestDetails!.matchTime!.split(':')[0]),
            minutes:
                int.parse(data.data!.contestDetails!.matchTime!.split(':')[1]),
          ),
        );

        // If match time is in UTC, convert to the desired time zone (e.g., IST)
        // matchDateTime = matchDateTime.toUtc().add(Duration(hours: 5, minutes: 30)); // Convert to IST (UTC+5:30)

        // Debug log: check match time after conversion
        print("Match DateTime (IST): $matchDateTime");

        // Calculate remaining time
        setState(() {
          DateTime currentTimeIST = DateTime.now().toUtc().add(const Duration(
              hours: 5, minutes: 30)); // Convert current time to IST
          remainingTime = matchDateTime.difference(currentTimeIST);

          print("Remaining time is: -----$remainingTime");
          print("Match DateTime is1111111111111: -----$matchDateTime");

          // Process leaderboard data
          for (var leaderboardEntry in data.data!.leaderboard!) {
            passingTeamIds.addAll(leaderboardEntry.myTeamId!);
          }
          leaderboardData = data.data!.leaderboard!; // Store leaderboard data
        });

        debugPrint('Passing Team IDs: $passingTeamIds');
        return data;
      } else {
        debugPrint("this is else response::${response.body}");
        debugPrint('Failed to fetch contest data: ${response.statusCode}');
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
      print('matched id is :-        .............${widget.Id}');
      final response = await http.get(
        Uri.parse(
            "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.Id}"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        final data = PointsResponse.fromJson(jsonData);

        // Fill playerPointsMap
        // for (var playerPointsData in data.data) {
        //   for (var playerPoint in playerPointsData.playerPoints) {
        //     playerPointsMap[playerPoint.playerId] = playerPoint.points;
        //   }
        // }

        // Rebuild the UI after fetching player points
        setState(() {
          if (data.data.isNotEmpty) {
            // Assuming data.data is a List<PlayerPointsData>
            totalpoints =
                data.data[0].totalPoints; // Get totalPoints from the first item
          } else {
            totalpoints = 0; // Default value if no data
          }

          // pointsStorage.storePoints(totalpoints);
          print('points are showing right or not:- $totalpoints');
          totalpoints;
          // playerPointsMap;
        });

        return data;
      } else {
        debugPrint('Failed to fetch team data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}'); // Log the response body
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching team dataasdasfas: $e');
      return null;
    }
  }

  Future<String?> walletDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final wallet = WalletModel.fromJson(jsonDecode(response.body));
        return wallet.data.funds
            .toString(); // assuming `balance` is a `String` in `WalletModel`
      } else {
        debugPrint('Failed to fetch wallet data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching wallet data: $e');
      return null;
    }
  }

  Future<MyTeamLIstModel?> matchDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.Id}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        print('my matchv : ${widget.Id}');
        print("this is respons of My team List ::${response.body}");
        // return MyTeamLIstModel.fromJson(jsonDecode(response.body));
        MyTeamLIstModel teamListModel =
            MyTeamLIstModel.fromJson(jsonDecode(response.body));
        setState(() {
          for (int index = 0; index < teamListModel.data.length; index++) {
            var team = teamListModel.data[index];
            String lastFourDigits = team.id.substring(team.id.length - 4);
            String teamLabel = 'T${index + 1}';
            appId = "BOSS $lastFourDigits ($teamLabel)";

            // You can store this appId in the team object if needed
            // Assuming you have an appId property in your team model
          }
        });
        // Construct appId for each team

        return teamListModel;
      } else {
        debugPrint('Failed to fetch team data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching team data: $e');
      return null;
    }
  }

  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m left";
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureData = contestDisplay(); // Refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("this is from home screen::${widget.Id}");
    debugPrint("this is id from next screen22::${widget.CId}");
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Navigate to the login page when the back button is pressed
        // if(widget.isCreateTeam){
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => IndVsSaScreens(
        //           IsCreateTeamScreen: true,
        //           Id: widget.Id,
        //           matchName: widget.matchName),
        //     ),
        //         (route) => false, // Removes all previous routes.
        //   );
        // }
        // else{
        //   Navigator.pop(context);
        // }
        await Future.microtask(() {
          // Check if the navigator can pop before trying to pop
          // if(widget.isCreateTeam){
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
          // } else {
          //   if (Navigator.canPop(context)) {
          //     Navigator.pop(context);
          //   } else {
          //     print("No route to pop!");
          //   }
          // }
        });
        // Navigator.pop(context);

        // Return `true` if you want to indicate that the pop was handled manually.
        // return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(63.0),
          child: ClipRRect(
              child: CustomAppBar(
                  title: widget.matchName ?? '',
                  // subtitle: formatRemainingTime(remainingTime) ?? widget.time!,
                  subtitle: formatRemainingTime(remainingTime) != '0h 0m left'
                      ? formatRemainingTime(remainingTime)
                      : widget.time ?? 'No time available',
                  onBackPressed: () async {
                    await Future.microtask(() {
                      // Check if the navigator can pop before trying to pop
                      // if(widget.isCreateTeam){
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
                      // } else {
                      //   if (Navigator.canPop(context)) {
                      //     Navigator.pop(context);
                      //   } else {
                      //     print("No route to pop!");
                      //   }
                      // }
                    });
                  }
                  // } widget.isCreateTeam? Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => IndVsSaScreens(
                  //         IsCreateTeamScreen: true,
                  //         Id: widget.Id,
                  //         matchName: widget.matchName),
                  //   ),
                  //       (route) => false, // Removes all previous routes.
                  // ) :Navigator.pop(context),
                  // fetchWalletBalance: walletDisplay
                  )),
        ),
        body: FutureBuilder<ContestInsideModel?>(
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
            } else if (!snapshot.hasData) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: const Center(child: Text('No data available')));
            } else {
              var leaderboardata = snapshot.data!.data!.leaderboard!;
              debugPrint('data is herreafdsafdsafv');
              final contestData = snapshot.data;
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Prize Pool",
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          formatMegaPrice(contestData!.data!
                                              .contestDetails!.pricePool!),

                                          // "₹${contestData?.data?.contestDetails!.pricePool}",
                                          style: const TextStyle(
                                            color: Color(0xff140B40),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: [
                                        //     Text("Mega contest ", style: const TextStyle(
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w500,
                                        //       color: Color(0xffD4AF37),
                                        //     ),),
                                        //     PriceDisplay(price: contestData!.data!.contestDetails!.pricePool ?? 0), // Assuming match.megaprice is an int
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        // Check if `currWinnings` is not null and has at least one item
                                        if (contestData.data!.currWinnings !=
                                                null &&
                                            contestData
                                                .data!.currWinnings!.isNotEmpty)
                                          Normal2Text(
                                            color: Colors.black,
                                            text:
                                                "#1 - ₹${contestData.data!.currWinnings![0].prize}",
                                          ),
                                        // Check if `currWinnings` has more than one item
                                        if (contestData.data!.currWinnings !=
                                                null &&
                                            contestData.data!.currWinnings!
                                                    .length >
                                                1)
                                          Normal2Text(
                                            color: Colors.black,
                                            text:
                                                "#2 - ₹${contestData.data!.currWinnings![1].prize}",
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 2.5,
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      const Color(0xff777777).withOpacity(0.3),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 2.5,
                                        width: 100,
                                        color: const Color(0xff140B40),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${contestData.data!.remainingSpots} spots left",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff140B40)),
                                    ),
                                    Text(
                                      "${contestData.data!.contestDetails!.totalParticipant} spots",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContestMatchList(
                                            firstmatch: "${widget.firstMatch}",
                                            secMatch: "${widget.secMatch}",
                                            matchName: "${widget.matchName}",
                                            time: formatRemainingTime(
                                                remainingTime),
                                            cId: "${widget.CId}",
                                            Id: "${widget.Id}",
                                            amount:
                                                "${contestData.data!.contestDetails!.entryFees}",
                                            // currentUserTeamIds: displayedTeamIds.map((teamId) => teamId.split('(')[0]).toList(), // Extracting team ID before '('
                                            currentUserTeamIds: passingTeamIds
                                                .map((teamId) =>
                                                    teamId.split('(')[0])
                                                .toList(), // Extracting team ID before '('

                                            // currentUserTeamIds: displayedTeamIds.toList(),
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    height: 34,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: const Color(0xff140B40),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "₹${contestData.data!.contestDetails!.entryFees}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/fluent.png',
                                  width: 25,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "₹${contestData.data!.currWinnings!.first.prize}", // Get the prize for the top rank
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/cup.png',
                                  width: 25,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${contestData.data!.contestDetails!.profit}%",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/m.png',
                                  width: 25,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Upto ${contestData.data!.contestDetails!.maxTeamPerUser}",
                                  // Display max team per user
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/granted.png',
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Guaranteed",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          Container(
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              //borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: const Color(0xff140B40),
                              labelColor: const Color(0xff140B40),
                              unselectedLabelColor: Colors.grey,
                              tabs: const [
                                Tab(text: 'MaxWinning'),
                                Tab(text: 'CurrWinnings'),
                                Tab(text: 'Leaderboard')
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "RANK",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "WINNINGS",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: contestData
                                            .data!.maxWinning!.length,
                                        itemBuilder: (context, index) {
                                          final range = contestData.data!
                                                  .maxWinning![index].range ??
                                              [];
                                          final prize = contestData.data!
                                                  .maxWinning![index].prize ??
                                              "0";

                                          // Check if the range is not empty
                                          String rangeText = "";
                                          if (range.isNotEmpty) {
                                            final first = range.first;
                                            final last = range.last;
                                            if (first == last) {
                                              rangeText = '$first';
                                            } else {
                                              rangeText = "#$first - $last";
                                            }
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    rangeText,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "₹$prize",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "RANK",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Text(
                                            "WINNINGS",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: contestData
                                                .data!.currWinnings!.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final range = contestData.data!
                                                  .currWinnings![index].range ??
                                              [];
                                          final prize = contestData.data!
                                                  .currWinnings![index].prize ??
                                              "0";

                                          // Check if the range is not empty
                                          String rangeText = "";
                                          if (range.isNotEmpty) {
                                            final first = range.first;
                                            final last = range.last;
                                            rangeText = "#$first - $last";
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    rangeText,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "₹$prize",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                //working leaderboard

                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  'Teams (${contestData.data!.leaderboard!.length})',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              const SizedBox(width: 25),
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  'Points',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  'Rank',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RefreshIndicator(
                                          onRefresh: _refreshData,
                                          child: SingleChildScrollView(
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              // physics: const NeverScrollableScrollPhysics(), // Allow parent scroll
                                              // physics: AlwaysScrollableScrollPhysics(),
                                              itemCount: contestData
                                                  .data!.leaderboard!.length,
                                              // itemCount: leaderboardata!.length ?? 0,
                                              itemBuilder:
                                                  (context, leaderboardIndex) {
                                                // var leaderboardEntry = contestData.data.leaderboard[leaderboardIndex];
                                                var sortedLeaderboard =
                                                    contestData
                                                        .data!.leaderboard;
                                                // var sortedLeaderboard = leaderboardata!;
                                                print(
                                                    "Leaderboard Data ids 12121212............: ${leaderboardata.length}");

                                                print(
                                                    "Leaderboard Data ids mostasfdusufh............: ${contestData.data!.leaderboard!.length}");
                                                sortedLeaderboard!.sort((a, b) {
                                                  bool isCurrentUserA = a
                                                      .userDetails!
                                                      .any((user) =>
                                                          user.id ==
                                                          currentUserId);
                                                  bool isCurrentUserB = b
                                                      .userDetails!
                                                      .any((user) =>
                                                          user.id ==
                                                          currentUserId);
                                                  return isCurrentUserA &&
                                                          !isCurrentUserB
                                                      ? -1
                                                      : (isCurrentUserB &&
                                                              !isCurrentUserA
                                                          ? 1
                                                          : 0);
                                                });

                                                var leaderboardEntry =
                                                    sortedLeaderboard[
                                                        leaderboardIndex];
                                                print(
                                                    "Leaderboard Entry: ${leaderboardEntry.toString()}");

                                                if (leaderboardEntry.myTeamId ==
                                                        null ||
                                                    leaderboardEntry
                                                        .myTeamId!.isEmpty) {
                                                  debugPrint(
                                                      'No entries found for leaderboard at index $leaderboardIndex');
                                                  return const Text(
                                                      "No leaderboard data available.");
                                                }
                                                print(
                                                    "Leaderboard Entry22222222222222222222: ${leaderboardEntry.toString()}");

                                                return Column(
                                                  children: leaderboardEntry
                                                      .myTeamId!
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    int teamIndex = entry
                                                        .key; // Index of the teamId in myTeam_id
                                                    String teamId = entry
                                                        .value; // The actual teamId
                                                    print(
                                                        "Leaderboard Entry 33333333333333333333333333333: ${leaderboardEntry.toString()}");

                                                    // Check if this teamId is already displayed
                                                    // if (displayedTeamIds.contains(teamId)) {
                                                    //   return const SizedBox.shrink(); // Skip rendering this teamId
                                                    // }
                                                    // print("Leaderboard Entry 989898989898989: ${leaderboardEntry.toString()}");
                                                    //
                                                    // displayedTeamIds.add(teamId); // Mark this teamId as displayed
                                                    print(
                                                        "Leaderboard Entry 444444444444444444: ${leaderboardEntry.toString()}");
                                                    // Extract team number from teamId
                                                    // var teamNumber = teamId.contains('T')
                                                    //     ? teamId.split('T').last.split(')')[0]
                                                    //     : '';
                                                    // Find user details for the current user
                                                    var userDetail =
                                                        leaderboardEntry
                                                            .userDetails!.first;
                                                    if (!userTeamNumbers
                                                        .containsKey(
                                                            userDetail.id)) {
                                                      userTeamNumbers[
                                                          userDetail.id!] = {};
                                                    }
                                                    print(
                                                        "Leaderboard Entry 5555555555555555555555555: ${leaderboardEntry.toString()}");

                                                    // Assign a team number for the current teamId
                                                    // if (!userTeamNumbers[userDetail.id]!.containsKey(teamId)) {
                                                    //   userTeamNumbers[userDetail.id]![teamId] = userTeamNumbers[userDetail.id]!.length + 1; // Assign a new team number
                                                    // }
                                                    print(
                                                        "Leaderboard Entry 666666666666666666666666666666666666: ${leaderboardEntry.toString()}");

                                                    // var teamNumber = userTeamNumbers[userDetail.id]![teamId];
                                                    var teamNumber =
                                                        leaderboardEntry
                                                            .teamLabel;

                                                    bool isCurrentUser =
                                                        leaderboardEntry
                                                            .userDetails!
                                                            .any((user) =>
                                                                user.id ==
                                                                currentUserId);
                                                    print(
                                                        "Leaderboard Entry 777777777777777777777777777777777777: ${leaderboardEntry.toString()}");

                                                    return GestureDetector(
                                                      onTap: () {
                                                        String
                                                            teamIdWithoutSuffix =
                                                            teamId
                                                                .split('(')[0];
                                                        String lastFourDigits =
                                                            teamIdWithoutSuffix
                                                                        .length >=
                                                                    4
                                                                ? teamIdWithoutSuffix
                                                                    .substring(
                                                                        teamIdWithoutSuffix.length -
                                                                            4)
                                                                : teamIdWithoutSuffix;
                                                        var userappId =
                                                            "BOSS $lastFourDigits $teamNumber";

                                                        print(
                                                            'Clicked on Team ID: $teamId');
                                                        print(
                                                            'Team ID Without Suffix: $teamIdWithoutSuffix');
                                                        print(
                                                            'App ID: $userappId');
                                                        print(
                                                            'Match Name: ${widget.matchName}');
                                                        print(
                                                            'Match ID: ${widget.Id}');

                                                        // if (formatRemainingTime(remainingTime) == '0h 0m left' || formatRemainingTime(remainingTime).compareTo('0h 0m left') < 0) {
                                                        // if (isCurrentUser || formatRemainingTime(remainingTime) == '0h 0m left' || formatRemainingTime(remainingTime).compareTo('0h 0m left') < 0) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyTeamEdit(
                                                              teamId:
                                                                  teamIdWithoutSuffix,
                                                              appId: userappId,
                                                              matchName: widget
                                                                  .matchName!,
                                                              matchId:
                                                                  widget.Id,
                                                              isJoinContest:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                        // }
                                                        // else{
                                                        //   Fluttertoast.showToast(
                                                        //     msg: "Match is not live.",
                                                        //     toastLength: Toast.LENGTH_SHORT,
                                                        //     gravity: ToastGravity.BOTTOM,
                                                        //     timeInSecForIosWeb: 1,
                                                        //     backgroundColor: Colors.black54,
                                                        //     textColor: Colors.white,
                                                        //     fontSize: 14.0,
                                                        //   );
                                                        // }
                                                      },
                                                      child: Container(
                                                        color: isCurrentUser
                                                            ? Colors
                                                                .yellow.shade100
                                                            : Colors
                                                                .transparent,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 8),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 8,
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.grey,
                                                                            image:
                                                                                DecorationImage(
                                                                              image: NetworkImage(userDetail.profilePhoto!),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                5),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "${userDetail.name} ${leaderboardEntry.teamLabel}",

                                                                            // "${userDetail.name} $teamNumber",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      leaderboardEntry
                                                                          .totalPoints!
                                                                          .toStringAsFixed(
                                                                              0),
                                                                      // "${leaderboardEntry.totalPoints! % 1 == 0 ?leaderboardEntry.totalPoints!.toStringAsFixed(0) : leaderboardEntry.totalPoints!.toStringAsFixed(1)}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Flexible(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      "#${leaderboardEntry.rank}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //                 Padding(
                                //   padding: const EdgeInsets.all(10),
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         decoration:BoxDecoration(
                                //           color: Colors.grey[400],
                                //
                                //         ),
                                //         child:
                                //         Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                //           children: [
                                //             Flexible(
                                //               flex: 2,
                                //               child: Text(
                                //                 'Teams (${contestData!.data!.leaderboard!.length})',
                                //                 style: TextStyle(
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 14,
                                //                   color: Colors.grey[800],
                                //                 ),
                                //                 textAlign: TextAlign.left,
                                //               ),
                                //             ),
                                //             const SizedBox(width: 25),
                                //             Flexible(
                                //               flex: 1,
                                //               child: Text(
                                //                 'Points',
                                //                 style: TextStyle(
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 14,
                                //                   color: Colors.grey[800],
                                //                 ),
                                //                 textAlign: TextAlign.center,
                                //               ),
                                //             ),
                                //             Flexible(
                                //               flex: 1,
                                //               child: Text(
                                //                 'Rank',
                                //                 style: TextStyle(
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 14,
                                //                   color: Colors.grey[800],
                                //                 ),
                                //                 textAlign: TextAlign.right,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //
                                //       ListView.builder(
                                //         shrinkWrap: true,
                                //         itemCount: contestData.data!.leaderboard!.length,
                                //         itemBuilder: (context, index) {
                                //           // Sort leaderboard by current user ID first
                                //           // String currentUserId = "yourCurrentUserId"; // Replace with actual current user ID
                                //           var sortedLeaderboard = contestData.data!.leaderboard;
                                //           var displayentry;
                                //           // sortedLeaderboard.sort((a, b) {
                                //           //   bool isCurrentUserA = a.userDetails.any((user) => user.id == currentUserId);
                                //           //   bool isCurrentUserB = b.userDetails.any((user) => user.id == currentUserId);
                                //           //   return isCurrentUserB.compareTo(isCurrentUserA);
                                //           // });
                                //           sortedLeaderboard!.sort((a, b) {
                                //             bool isCurrentUserA = a.userDetails!.any((user) => user.id == currentUserId);
                                //             bool isCurrentUserB = b.userDetails!.any((user) => user.id == currentUserId);
                                //
                                //             // Sort current user entries to appear first
                                //             if (isCurrentUserA && !isCurrentUserB) {
                                //               return -1; // a comes before b
                                //             } else if (!isCurrentUserA && isCurrentUserB) {
                                //               return 1; // b comes before a
                                //             } else {
                                //               return 0; // no change
                                //             }
                                //           });
                                //           var leaderboardEntry = sortedLeaderboard[index];
                                //
                                //           if (displayedTeamIds.contains(leaderboardEntry.myTeamId!.first)) {
                                //             return SizedBox.shrink();
                                //           }
                                //           displayedTeamIds.add(leaderboardEntry.myTeamId!.first); // Mark as displayed
                                //
                                //
                                //
                                //           // Get the leaderboard entry for the current index after sorting
                                //
                                //           // print('total leaderboard entry ${leaderboardEntry}');
                                //
                                //           // Set<String> uniqueTeamIds = {};
                                //           // List<dynamic> displayEntries = [];
                                //           //
                                //           // for (var entry in sortedLeaderboard) {
                                //           //   for (var teamId in entry.myTeamId) {
                                //           //     // Check if the teamId is already in the set
                                //           //     if (!uniqueTeamIds.contains(teamId)) {
                                //           //       uniqueTeamIds.add(teamId);
                                //           //       displayEntries.add(entry); // Add the entry to the display list
                                //           //       break; // Break to avoid adding the same entry again
                                //           //     }
                                //           //   }
                                //           // }
                                //           //
                                //           // // Get the leaderboard entry for the current index
                                //           // var leaderboardEntry = displayEntries[index];
                                //
                                //
                                //           // Get the leaderboard entry for the current index
                                //
                                //           print("index is:-$index");
                                //           print('leaderboardEntry.myTeamId.length ${leaderboardEntry.myTeamId!.length}');
                                //           var totalindex = index - leaderboardEntry.myTeamId!.length;
                                //           print('total index is:- $totalindex');
                                //           return GestureDetector(
                                //             onTap: (){
                                //             //   int playerIndex = leaderboardEntry.userDetails.indexWhere((user) => user.id == leaderboardEntry.myTeamId[index]);
                                //             //   // String teamIdWithoutSuffix = leaderboardEntry.myTeamId.first.split('(')[0];
                                //             //   String teamIdWithoutSuffix = leaderboardEntry.myTeamId[index].split('(')[0];
                                //             //   print('team id is............${leaderboardEntry.myTeamId.first}');
                                //             //   print('team id issdasdsadaws............${leaderboardEntry.myTeamId[index]}');
                                //             //   print('team id is............${teamIdWithoutSuffix}');
                                //             //   print('appid is..............${appId}');
                                //             //   print('match name is:..............${widget.matchName}');
                                //             //   print('match id is.......................${widget.Id}');
                                //             //   Navigator.push(
                                //             //     context,
                                //             //     MaterialPageRoute(
                                //             //       builder: (context) => MyTeamEdit(
                                //             //         // teamId: leaderboardEntry.myTeamId.first, // Assuming you want the first teamId
                                //             //         teamId: teamIdWithoutSuffix,
                                //             //         appId: appId!, // Replace with actual appId if available
                                //             //         matchName: widget.matchName!, // Replace with actual match name
                                //             //         matchId: widget.Id, // Replace with actual match id
                                //             //       ),
                                //             //     ),
                                //             //   );
                                //             //   Fluttertoast.showToast(
                                //             //     msg: "Tap on entry",
                                //             //     toastLength: Toast.LENGTH_SHORT,
                                //             //     gravity: ToastGravity.BOTTOM,
                                //             //     timeInSecForIosWeb: 1,
                                //             //     backgroundColor: Colors.black54,
                                //             //     textColor: Colors.white,
                                //             //     fontSize: 14.0,
                                //             //   );
                                //             //   // print('Tap on entry ');
                                //             // },
                                //               if (index <= leaderboardEntry.myTeamId!.length+totalindex) {
                                //
                                //                 print('Index number is:- $index');
                                //                 var teamId = leaderboardEntry.myTeamId![index]; // Access the specific teamId by index
                                //                 int playerIndex = leaderboardEntry.userDetails!.indexWhere((user) => user.id == teamId);
                                //                 String teamIdWithoutSuffix = teamId.split('(')[0]; // Now teamId is a String, so split works
                                //
                                //                 // var teamId = leaderboardEntry.myTeamId;
                                //                 // int playerIndex = leaderboardEntry.userDetails.indexWhere((user) => user.id == teamId);
                                //                 // String teamIdWithoutSuffix = teamId.split('(')[0];
                                //                 String lastFourDigits = teamIdWithoutSuffix.length >= 4
                                //                     ? teamIdWithoutSuffix.substring(teamIdWithoutSuffix.length - 4)
                                //                     : teamIdWithoutSuffix;
                                //                 var teamNumber = teamId.contains('T')
                                //                     ? teamId.split('T').last.split(')')[0]
                                //                     : '';
                                //                 var userappId = "BOSS $lastFourDigits (T$teamNumber)";
                                //                 print('last four digits are :- $lastFourDigits');
                                //
                                //                 // print('team id is :-${teamId}');
                                //                 print('team id without suffix :-$teamIdWithoutSuffix ');
                                //                 print("user app id is :- $userappId");
                                //                 // print('app id is :-${appId}');
                                //                 print('match name is :-${widget.matchName}');
                                //                 print('match id is :-${widget.Id}');
                                //
                                //
                                //                 // Navigate to MyTeamEdit screen
                                //                 // if (formatRemainingTime(remainingTime) => '0h 0m left') {
                                //                 // if (formatRemainingTime(remainingTime) == '0h 0m left' || formatRemainingTime(remainingTime).compareTo('0h 0m left') < 0) {
                                //                   Navigator.push(
                                //                     context,
                                //                     MaterialPageRoute(
                                //                       builder: (context) =>
                                //                           MyTeamEdit(
                                //                             teamId: teamIdWithoutSuffix,
                                //                             // appId: appId!,
                                //                             appId: userappId,
                                //                             matchName: widget.matchName!,
                                //                             matchId: widget.Id,
                                //                           ),
                                //                     ),
                                //                   );
                                //                 // }else{
                                //                 //   Fluttertoast.showToast(
                                //                 //     msg: "Match is not live.",
                                //                 //     toastLength: Toast.LENGTH_SHORT,
                                //                 //     gravity: ToastGravity.BOTTOM,
                                //                 //     timeInSecForIosWeb: 1,
                                //                 //     backgroundColor: Colors.black54,
                                //                 //     textColor: Colors.white,
                                //                 //     fontSize: 14.0,
                                //                 //   );
                                //                 // }
                                //                 //
                                //                 // Fluttertoast.showToast(
                                //                 //   msg: "Tap on entry",
                                //                 //   toastLength: Toast.LENGTH_SHORT,
                                //                 //   gravity: ToastGravity.BOTTOM,
                                //                 //   timeInSecForIosWeb: 1,
                                //                 //   backgroundColor: Colors.black54,
                                //                 //   textColor: Colors.white,
                                //                 //   fontSize: 14.0,
                                //                 // );
                                //               } else {
                                //                 // Handle the case where index is out of bounds
                                //                 print('Index out of bounds for myTeamId: $index');
                                //               }
                                //             },
                                //             child: Column(
                                //               children: leaderboardEntry.myTeamId!.map((teamId) {
                                //                 // Extract team number from teamId
                                //                 var teamNumber = teamId.contains('T')
                                //                     ? teamId.split('T').last.split(')')[0]
                                //                     : '';
                                //
                                //                 // Find the user details for the current user
                                //                 var userDetail = leaderboardEntry.userDetails!.first;
                                //                 // var playerDetails = leaderboardEntry.userDetails[index];
                                //
                                //                 return Padding(
                                //                   // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                //                   padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                                //                   child: Column(
                                //                     children: [
                                //                       Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: [
                                //                       if (index == 0) ...[
                                //                           Flexible(
                                //                             flex: 8,
                                //                             child: Row(
                                //                               children: [
                                //                                 Container(
                                //                                   height: 40,
                                //                                   width: 40,
                                //                                   decoration: BoxDecoration(
                                //                                     shape: BoxShape.circle,
                                //                                     color: Colors.grey,
                                //                                     image: DecorationImage(
                                //                                       image: NetworkImage(userDetail!.profilePhoto!),
                                //                                       fit: BoxFit.cover,
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                                 const SizedBox(width: 5),
                                //                                 Text(
                                //                                   "${leaderboardEntry.userDetails![index].name} (T$teamNumber)",
                                //                                   style: const TextStyle(
                                //                                     fontSize: 13,
                                //                                     fontWeight: FontWeight.w500,
                                //                                     color: Colors.black,
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           ),
                                //                           Flexible(
                                //                             flex: 3,
                                //                             child: Text(
                                //                               "${leaderboardEntry.totalPoints}",
                                //                               style: const TextStyle(
                                //                                 fontSize: 13,
                                //                                 fontWeight: FontWeight.w500,
                                //                                 color: Colors.black,
                                //                               ),
                                //                               textAlign: TextAlign.center,
                                //                             ),
                                //                           ),
                                //                           const SizedBox(width: 10),
                                //                           Flexible(
                                //                             flex: 3,
                                //                             child: Text(
                                //                               "#${leaderboardEntry.rank}",
                                //                               style: const TextStyle(
                                //                                 fontSize: 13,
                                //                                 fontWeight: FontWeight.w500,
                                //                                 color: Colors.black,
                                //                               ),
                                //                               textAlign: TextAlign.right,
                                //                             ),
                                //                           ),
                                //                           const SizedBox(width: 6),
                                //                           ]
                                //                       else...[
                                //                         Flexible(
                                //                           flex: 8,
                                //                           child: Row(
                                //                             children: [
                                //                               Container(
                                //                                 height: 40,
                                //                                 width: 40,
                                //                                 decoration: BoxDecoration(
                                //                                   shape: BoxShape.circle,
                                //                                   color: Colors.grey,
                                //                                   image: DecorationImage(
                                //                                     image: NetworkImage(userDetail!.profilePhoto!),
                                //                                     fit: BoxFit.cover,
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                               const SizedBox(width: 5),
                                //                               Text(
                                //                                 "${leaderboardEntry.userDetails![0].name} (T$teamNumber)",
                                //                                 style: const TextStyle(
                                //                                   fontSize: 13,
                                //                                   fontWeight: FontWeight.w500,
                                //                                   color: Colors.black,
                                //                                 ),
                                //                               ),
                                //                             ],
                                //                           ),
                                //                         ),
                                //                         Flexible(
                                //                           flex: 3,
                                //                           child: Text(
                                //                             "${leaderboardEntry.totalPoints}",
                                //                             style: const TextStyle(
                                //                               fontSize: 13,
                                //                               fontWeight: FontWeight.w500,
                                //                               color: Colors.black,
                                //                             ),
                                //                             textAlign: TextAlign.center,
                                //                           ),
                                //                         ),
                                //                         const SizedBox(width: 10),
                                //                         Flexible(
                                //                           flex: 3,
                                //                           child: Text(
                                //                             "#${leaderboardEntry.rank}",
                                //                             style: const TextStyle(
                                //                               fontSize: 13,
                                //                               fontWeight: FontWeight.w500,
                                //                               color: Colors.black,
                                //                             ),
                                //                             textAlign: TextAlign.right,
                                //                           ),
                                //                         ),
                                //                         const SizedBox(width: 6),
                                //                       ]
                                //                         ],
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 );
                                //               }).toList(),
                                //             ),
                                //           );
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 140,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            // Other code...
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Center(
                                child: Container(
                                  height: 42,
                                  width: 278,
                                  // Set a fixed width or a responsive width as needed
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(22),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "This is used in create team API: ${widget.Id}");
                                        print(
                                            "idddd: ${contestData.data!.contestDetails!.id}");
                                        print(
                                            "match name: ${widget.MatchName}");
                                        print(
                                            'first team name:- ${widget.firstMatch}');
                                        print(
                                            'second team name:- ${widget.secMatch}');
                                        print(
                                            'this is useed in create team api ........check 2  ${contestData.data!.contestDetails!.matchId}');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateTeamScreen(
                                              isJoinContestScreen: true,
                                              Id: contestData.data!
                                                  .contestDetails!.matchId,
                                              contestID: contestData
                                                  .data!.contestDetails!.id,
                                              matchId: widget.Id,
                                              // Id: "${contestData.data.contestDetails.id}",
                                              matchName: "${widget.matchName}",
                                              time: widget.time,
                                              firstMatch:
                                                  "${widget.firstMatch}",
                                              secMatch: "${widget.secMatch}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 25,
                                        // Width for the button's content
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCustomPositionedDialog(context);
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/contest.png", height: 18),
                                                  const SizedBox(width: 7),
                                                  const Text(
                                                    "Contests",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text('|'),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CreateTeamScreen(
                                                      isContestScreen: true,
                                                      Id: widget.Id,
                                                      matchName: widget.MatchName,
                                                      firstMatch: widget.firstMatch,
                                                      secMatch: widget.secMatch,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/createteam.png", height: 18),
                                                  const SizedBox(width: 7),
                                                  const Text(
                                                    "Create Team",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
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
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}




// Padding(
//   padding: const EdgeInsets.only(left: 3),
//   child: Column(
//     children: [
//       ListView.builder(
//         shrinkWrap: true,
//         itemCount:
//         contestData!.data.leaderboard.length,
//         itemBuilder: (context, index) {
//           // Get the leaderboard entry for the current index
//           var leaderboardEntry = contestData!
//               .data.leaderboard[index];
//
//           return Column(
//             children: leaderboardEntry.myTeamId
//                 .map((teamId) {
//               // Extract team number from teamId
//               var teamNumber =
//               teamId.contains('T')
//                   ? teamId
//                   .split('T')
//                   .last
//                   .split(')')[0]
//                   : '';
//
//               // Find the user details for the current user
//               var userDetail = leaderboardEntry
//                   .userDetails.first;
//
//               return Padding(
//                 padding:
//                 const EdgeInsets.symmetric(
//                     horizontal: 15,
//                     vertical: 10),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey,
//                         image: DecorationImage(
//                           image: NetworkImage(
//                               userDetail
//                                   .profilePhoto),
//                           // Use NetworkImage for profile photo
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       "${userDetail.name} (T$teamNumber)",
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight:
//                         FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       )
//     ],
//   ),
// ),

// Row(
//   children: [
//     Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey,
//         image: DecorationImage(
//           image: NetworkImage(userDetail.profilePhoto),
//           fit: BoxFit.cover,
//         ),
//       ),
//     ),
//     SizedBox(width:5),
//     Text(
//       "${userDetail.name} (T$teamNumber)",
//       style: const TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),
//     ),
//     SizedBox(width: 50),
//     Text(
//       "${leaderboardEntry.totalPoints}",
//       style: const TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),),
//     SizedBox(width: 72),
//     Text(
//       "#${leaderboardEntry.rank}",
//       style: const TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround, // Ensures even spacing between items
//   crossAxisAlignment: CrossAxisAlignment.center, // Aligns items vertically
//   children: [
//     // SizedBox(width: 1),
//     Text(
//       'Teams (${contestData!.data.leaderboard.length})',
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//         color: Colors.grey[800],
//       ),
//     ),
//     SizedBox(width: 40),
//     Text(
//       'Points',
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//         color: Colors.grey[800],
//       ),
//     ),
//     Text(
//       'Rank',
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//         color: Colors.grey[800],
//       ),
//     ),
//   ],
// ),

// Padding(
//   padding: const EdgeInsets.only(left: 3),
//   child: SingleChildScrollView(
//     child: Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: contestData!.data.leaderboard.length,
//           itemBuilder: (context, index) {
//             var leaderboardEntries = contestData!.data.leaderboard;
//
//             // Deduplicate entries based on user ID
//             // leaderboardEntries = leaderboardEntries.where((entry) {
//             //   return leaderboardEntries
//             //       .indexWhere((e) => e.userDetails.first.id == entry.userDetails.first.id) ==
//             //       leaderboardEntries.indexOf(entry);
//             // }).toList();
//
//             // Get the current user's entry
//             // var currentUserEntry = leaderboardEntries.firstWhere(
//             //       (entry) => entry.userDetails.first.id == currentUserId,
//             //   orElse: () => null, // Return null if not found
//             // );
//             Leaderboard? currentUserEntry;
//             try {
//               currentUserEntry = leaderboardEntries.firstWhere(
//                     (entry) => entry.userDetails.first.id == currentUserId,
//               );
//             } catch (e) {
//               currentUserEntry = null; // No matching entry found
//             }
//
//
//             // Remove current user's entry from the list if it exists
//             if (currentUserEntry != null) {
//               leaderboardEntries.remove(currentUserEntry);
//             }
//
//             // Prepare the list of widgets to display
//             List<Widget> leaderboardWidgets = [];
//
//             // Add current user's entry to the top if it exists
//             if (currentUserEntry != null) {
//               leaderboardWidgets.add(
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey,
//                           image: DecorationImage(
//                             image: NetworkImage(currentUserEntry.userDetails.first.profilePhoto),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         "${currentUserEntry.userDetails.first.name} (Your Team)",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//
//             // Display the rest of the leaderboard entries
//             leaderboardWidgets.addAll(
//               leaderboardEntries.map((leaderboardEntry) {
//                 return Column(
//                   children: leaderboardEntry.myTeamId.map((teamId) {
//                     var teamNumber = teamId.contains('T')
//                         ? teamId.split('T').last.split(')')[0]
//                         : '';
//
//                     var userDetail = leaderboardEntry.userDetails.first;
//
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey,
//                               image: DecorationImage(
//                                 image: NetworkImage(userDetail.profilePhoto),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "${userDetail.name} (T$teamNumber)",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             );
//
//             return Column(children: leaderboardWidgets);
//           },
//         ),
//       ],
//     ),
//   ),
// ),

// Padding(
//   padding: const EdgeInsets.all(10),
//   child: Column(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[400],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Flexible(
//               flex: 2,
//               child: Text(
//                 'Teams (${contestData!.data.leaderboard.length})',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: Colors.grey[800],
//                 ),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//             SizedBox(width: 25),
//             Flexible(
//               flex: 1,
//               child: Text(
//                 'Points',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: Colors.grey[800],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Flexible(
//               flex: 1,
//               child: Text(
//                 'Rank',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: Colors.grey[800],
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//           ],
//         ),
//       ),
//       ListView.builder(
//         shrinkWrap: true,
//         itemCount: contestData!.data.leaderboard.length,
//         itemBuilder: (context, index) {
//           var leaderboardEntry = contestData!.data.leaderboard[index];
//
//           return GestureDetector(
//             onTap: () {
//               print("teamid of index :- ${leaderboardEntry.myTeamId[0]}");
//               // Ensure the index is valid for leaderboardEntry.myTeamId
//               if (leaderboardEntry.myTeamId.isNotEmpty) {
//                 String teamId = leaderboardEntry.myTeamId.first;
//                 String teamidplayer = leaderboardEntry.myTeamId[0];
//                 String teamIdWithoutSuffixplayer = teamidplayer.split('(')[0];// Use the first valid team ID
//                 String teamIdWithoutSuffix = teamId.split('(')[0];
//                 print("teamid of index :-${teamidplayer}");
//                 print('team id is :- $teamIdWithoutSuffix');
//
//                 // Navigate to MyTeamEdit screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MyTeamEdit(
//                       // teamId: teamIdWithoutSuffix,
//                       teamId: teamIdWithoutSuffix,
//                       appId: appId!,
//                       matchName: widget.matchName!,
//                       matchId: widget.Id,
//                     ),
//                   ),
//                 );
//
//                 Fluttertoast.showToast(
//                   msg: "Tap on entry",
//                   toastLength: Toast.LENGTH_SHORT,
//                   gravity: ToastGravity.BOTTOM,
//                   timeInSecForIosWeb: 1,
//                   backgroundColor: Colors.black54,
//                   textColor: Colors.white,
//                   fontSize: 14.0,
//                 );
//               } else {
//                 // Handle the case where myTeamId is empty
//                 print('No valid team ID in myTeamId list');
//               }
//             },
//             child: Column(
//               children: leaderboardEntry.myTeamId.map((teamId) {
//                 var teamNumber = teamId.contains('T') ? teamId.split('T').last.split(')')[0] : '';
//                 var userDetail = leaderboardEntry.userDetails.isNotEmpty ? leaderboardEntry.userDetails[0] : null;
//
//                 if (userDetail == null) {
//                   return SizedBox.shrink(); // Skip rendering if user details are missing
//                 }
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey,
//                               image: DecorationImage(
//                                 image: NetworkImage(userDetail.profilePhoto),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             "${userDetail.name} (T$teamNumber)",
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "${leaderboardEntry.totalPoints}",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       Text(
//                         "#${leaderboardEntry.rank}",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     ],
//   ),
// )

// Padding(
//   padding: const EdgeInsets.only(left: 3),
//   child: Column(
//     children: [
//       ListView.builder(
//         shrinkWrap: true,
//         itemCount: contestData!.data.leaderboard.length,
//         itemBuilder: (context, index) {
//           // Get the leaderboard entries
//           var leaderboardEntries = contestData!.data.leaderboard;
//
//           // Identify the current user's entry
//           var currentUserEntry = leaderboardEntries.firstWhere(
//                 (entry) => entry.userDetails.first.id == currentUserId,
//           );
//
//           // Remove the user's entry from the list if it exists
//           if (currentUserEntry != null) {
//             leaderboardEntries.remove(currentUserEntry);
//           }
//
//           // Sort the remaining leaderboard entries in reverse order based on score
//           // leaderboardEntries.sort((a, b) => b.score.compareTo(a.score));
//
//           // Build the list
//           List<Widget> leaderboardWidgets = [];
//
//           // Display the user's entry at the top if it exists
//           if (currentUserEntry != null) {
//             leaderboardWidgets.add(
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey,
//                         image: DecorationImage(
//                           image: NetworkImage(currentUserEntry.userDetails.first.profilePhoto),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       "${currentUserEntry.userDetails.first.name} (Your Team)",
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//
//           // Display the rest of the leaderboard entries
//           leaderboardWidgets.addAll(
//             leaderboardEntries.map((leaderboardEntry) {
//               return Column(
//                 children: leaderboardEntry.myTeamId.map((teamId) {
//                   // Extract team number from teamId
//                   var teamNumber = teamId.contains('T')
//                       ? teamId.split('T').last.split(')')[0]
//                       : '';
//
//                   // Find the user details for the current user
//                   var userDetail = leaderboardEntry.userDetails.first;
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey,
//                             image: DecorationImage(
//                               image: NetworkImage(userDetail.profilePhoto),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           "${userDetail.name} (T$teamNumber)",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             }).toList(),
//           );
//
//           return Column(children: leaderboardWidgets);
//         },
//       ),
//     ],
//   ),
// ),

// AppBar(
//   elevation: 0,
//   leading: InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: const Icon(
//         Icons.keyboard_backspace,
//         color: Colors.white,
//         size: 30,
//       )),
//   title: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       AppBarText(color: Colors.white, text: "${widget.matchName}"),
//       FutureBuilder<ContestInsideModel?>(
//         future: _futureData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Small3Text(color: Colors.white, text: "Loading...");
//           } else if (snapshot.hasError) {
//             return Small3Text(color: Colors.white, text: "Error loading time");
//           } else if (snapshot.hasData) {
//             final data = snapshot.data;
//             final remaining = formatRemainingTime(remainingTime);
//             return Small3Text(color: Colors.white, text: remaining);
//           } else {
//             return Small3Text(color: Colors.white, text: "No data available");
//           }
//         },
//       ),
//     ],
//   ),
//   actions: [
//     InkWell(
//       onTap: () async {
//         await showModalBottomSheet(
//           context: context,
//           builder: (context) {
//             return StatefulBuilder(
//               builder: (context, setState) {
//                 return  Container(
//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width,
//                   decoration:  BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(28.r),
//                         topLeft: Radius.circular(28.r)),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 98.h,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(28.r),
//                                 topLeft: Radius.circular(28.r)),
//                             gradient: LinearGradient(
//                                 begin: Alignment.bottomRight,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color(0xff1D1459)
//                                       .withOpacity(0.4),
//                                   Color(0xff1D1459)
//                                       .withOpacity(0.1),
//                                 ])),
//                         child:  Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15.r),
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             mainAxisAlignment:
//                             MainAxisAlignment.center,
//                             children: [
//                               Text("Current Balance"),
//                               FutureBuilder<WalletModel?>(
//                                 future: walletDisplay(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState == ConnectionState.waiting) {
//                                     return SizedBox(
//                                       height: 25.h,
//                                       width: 30.w,
//                                       child:  Center(
//                                           child: Text('0', style: TextStyle(fontSize: 25.sp, color: Colors.black),)
//                                       ),
//                                     );
//                                   } else if (snapshot.hasError) {
//                                     return const Center(child: Text('Error fetching data'));
//                                   } else if (!snapshot.hasData || snapshot.data == null) {
//                                     return const Center(child: Text('No data available'));
//                                   } else {
//                                     WalletModel walletData = snapshot.data!;
//                                     currentBalance = walletData.data?.funds.toString() ?? "0";
//                                     fundsUtilizedBalance = walletData.data?.fundsUtilized.toString() ?? "0"; // Fetch utilized balance
//                                     return Text(
//                                       '₹ $currentBalance',
//                                       style: TextStyle(
//                                         fontSize: 20.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 62.h,
//                         decoration:  BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(28.r),
//                               topLeft: Radius.circular(28.r)),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15.r),
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text("Unutilized Balance"),
//                                   InkWell(
//                                       onTap: () {},
//                                       child: Icon(
//                                         Icons
//                                             .info_outline_rounded,
//                                         color: Colors.grey,
//                                       ))
//                                 ],
//                               ),
//                               Text(
//                                 '₹ $fundsUtilizedBalance',
//                                 style: TextStyle(
//                                     fontSize: 15.sp,
//                                     fontWeight:
//                                     FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       Divider(),
//                       Container(
//                         width: double.infinity,
//                         height: 62.h,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(28.r),
//                               topLeft: Radius.circular(28.r)),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15.r),
//                           child: Row(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.center,
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment
//                                     .spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text("Winnings"),
//                                       InkWell(
//                                           onTap: () {},
//                                           child: Icon(
//                                             Icons
//                                                 .info_outline_rounded,
//                                             color: Colors.grey,
//                                           ))
//                                     ],
//                                   ),
//                                   Text(
//                                     '₹ 0.00',
//                                     style: TextStyle(
//                                         fontSize: 15.sp,
//                                         fontWeight:
//                                         FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               InkWell(
//                                 onTap: (){
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AddCashScreen(),
//                                       ));
//                                 },
//                                 child: Container(
//                                   height: 45.h,
//                                   width: 110.w,
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                       BorderRadius.circular(
//                                           8.r),
//                                       color: Color(0xff1D1459)),
//                                   child:  Center(
//                                     child: Text(
//                                       "Withdraw",
//                                       style: TextStyle(
//                                           fontWeight:
//                                           FontWeight.w800,
//                                           fontSize: 16.sp,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Divider(),
//                       Container(
//                         height: 60.h,
//                         width: double.infinity,
//                         decoration: BoxDecoration(),
//                         child:  Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15.r),
//                           child: Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "My Transactions",
//                                 style: TextStyle(
//                                     fontSize: 15.sp,
//                                     fontWeight:
//                                     FontWeight.w600),
//                               ),
//                               InkWell(
//                                 onTap: (){
//                                   Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                                 },
//                                 child: Icon(
//                                   Icons
//                                       .arrow_forward_ios_outlined,
//                                   size: 35.sp,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Divider(),
//                       Spacer(),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 15.r),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       AddCashScreen(),
//                                 ));
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             height: 45.h,
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                 BorderRadius.circular(8.r),
//                                 color: Color(0xff1D1459)),
//                             child: Center(
//                               child: Text(
//                                 "Add Cash",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16.sp),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30.h,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//       child: Container(
//         height: 40.h,
//         width: 104.w,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           color: Colors.white.withOpacity(0.1),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/Vector.png',
//               height: 17.h,
//               color: Colors.white,
//             ),
//             SizedBox(width: 4.w),
//             //  Text(
//             //   "₹220",
//             //   style: TextStyle(
//             //     fontWeight: FontWeight.w600,
//             //     color: Colors.white,
//             //   ),
//             // ),
//             FutureBuilder<WalletModel?>(
//               future: walletDisplay(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return SizedBox(
//                       height: 22.h,
//                       width: 22.w,
//                       child:  Center( child: Text('0', style: TextStyle(fontSize: 16.sp, color: Colors.white),)));
//                 } else if (snapshot.hasError) {
//                   return const Center(child: Text('Error fetching data'));
//                 } else if (!snapshot.hasData || snapshot.data == null) {
//                   return const Center(child: Text('No data available'));
//                 } else {
//                   WalletModel walletData = snapshot.data!;
//                   if (walletData.data != null) {
//                     currentBalance = walletData.data.funds.toString();
//                   }
//
//                   return Text(
//                     "₹$currentBalance",
//                     overflow: TextOverflow.clip,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp, fontWeight: FontWeight.w600),
//                   );
//                 }
//               },
//             ),
//             SizedBox(width: 4.w),
//             InkWell(
//               onTap: () {},
//               child: Image.asset(
//                 'assets/Plus (1).png',
//                 height: 17.h,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     SizedBox(width: 10.w,)
//   ],
//   flexibleSpace: Container(
//     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     height: 120,
//     width: MediaQuery.of(context).size.width,
//     decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff1D1459), Color(0xff140B40)])),
//   ),
// ),


//Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[400],
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           Flexible(
//                                             flex: 2,
//                                             child: Text(
//                                               'Teams (${contestData!.data.leaderboard.length})',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                                 color: Colors.grey[800],
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 25),
//                                           Flexible(
//                                             flex: 1,
//                                             child: Text(
//                                               'Points',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                                 color: Colors.grey[800],
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                           Flexible(
//                                             flex: 1,
//                                             child: Text(
//                                               'Rank',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                                 color: Colors.grey[800],
//                                               ),
//                                               textAlign: TextAlign.right,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(), // Allow parent scroll
//                                       itemCount: contestData.data.leaderboard.length,
//                                       itemBuilder: (context, leaderboardIndex) {
//                                         // var leaderboardEntry = contestData.data.leaderboard[leaderboardIndex];
//                                         var sortedLeaderboard = contestData.data.leaderboard;
//                                         sortedLeaderboard.sort((a, b) {
//                                           bool isCurrentUserA = a.userDetails.any((user) => user.id == currentUserId);
//                                           bool isCurrentUserB = b.userDetails.any((user) => user.id == currentUserId);
//                                           return isCurrentUserA && !isCurrentUserB ? -1 : (isCurrentUserB && !isCurrentUserA ? 1 : 0);
//                                         });
//
//                                         var leaderboardEntry = sortedLeaderboard[leaderboardIndex];
//                                         return Column(
//                                           children: leaderboardEntry.myTeamId.asMap().entries.map((entry) {
//                                             int teamIndex = entry.key; // Index of the teamId in myTeam_id
//                                             String teamId = entry.value; // The actual teamId
//
//                                             // Check if this teamId is already displayed
//                                             if (displayedTeamIds.contains(teamId)) {
//                                               return SizedBox.shrink(); // Skip rendering this teamId
//                                             }
//                                             displayedTeamIds.add(teamId); // Mark this teamId as displayed
//
//                                             // Extract team number from teamId
//                                             // var teamNumber = teamId.contains('T')
//                                             //     ? teamId.split('T').last.split(')')[0]
//                                             //     : '';
//                                             if (!teamNumbers.containsKey(teamId)) {
//                                               teamNumbers[teamId] = teamNumbers.length + 1; // Assign a new team number
//                                             }
//                                             var teamNumber = '${teamNumbers[teamId]}'; // Get the team number
//
//
//                                             // Find user details for the current user
//                                             var userDetail = leaderboardEntry.userDetails.first;
//
//                                             return GestureDetector(
//                                               onTap: () {
//                                                 String teamIdWithoutSuffix = teamId.split('(')[0];
//                                                 String lastFourDigits = teamIdWithoutSuffix.length >= 4
//                                                     ? teamIdWithoutSuffix.substring(teamIdWithoutSuffix.length - 4)
//                                                     : teamIdWithoutSuffix;
//                                                 var userappId = "BOSS $lastFourDigits (T$teamNumber)";
//
//                                                 print('Clicked on Team ID: $teamId');
//                                                 print('Team ID Without Suffix: $teamIdWithoutSuffix');
//                                                 print('App ID: $userappId');
//                                                 print('Match Name: ${widget.matchName}');
//                                                 print('Match ID: ${widget.Id}');
//                                                 bool isCurrentUser = leaderboardEntry.userDetails.any((user) => user.id == currentUserId);
//
//                                                 // if (formatRemainingTime(remainingTime) == '0h 0m left' || formatRemainingTime(remainingTime).compareTo('0h 0m left') < 0) {
//                                                 if (isCurrentUser || formatRemainingTime(remainingTime) == '0h 0m left' || formatRemainingTime(remainingTime).compareTo('0h 0m left') < 0) {
//                                                   Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) => MyTeamEdit(
//                                                       teamId: teamIdWithoutSuffix,
//                                                       appId: userappId,
//                                                       matchName: widget.matchName!,
//                                                       matchId: widget.Id,
//                                                     ),
//                                                   ),
//                                                 );
//                                                 }else{
//                                                   Fluttertoast.showToast(
//                                                     msg: "Match is not live.",
//                                                     toastLength: Toast.LENGTH_SHORT,
//                                                     gravity: ToastGravity.BOTTOM,
//                                                     timeInSecForIosWeb: 1,
//                                                     backgroundColor: Colors.black54,
//                                                     textColor: Colors.white,
//                                                     fontSize: 14.0,
//                                                   );
//                                                 }
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//                                                 child: Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Flexible(
//                                                           flex: 8,
//                                                           child: Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 40,
//                                                                 width: 40,
//                                                                 decoration: BoxDecoration(
//                                                                   shape: BoxShape.circle,
//                                                                   color: Colors.grey,
//                                                                   image: DecorationImage(
//                                                                     image: NetworkImage(userDetail.profilePhoto),
//                                                                     fit: BoxFit.cover,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(width: 5),
//                                                               Text(
//                                                                 "${userDetail.name} (T$teamNumber)",
//                                                                 style: const TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.black,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Flexible(
//                                                           flex: 3,
//                                                           child: Text(
//                                                             "${leaderboardEntry.totalPoints}",
//                                                             style: const TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.black,
//                                                             ),
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ),
//                                                         const SizedBox(width: 10),
//                                                         Flexible(
//                                                           flex: 3,
//                                                           child: Text(
//                                                             "#${leaderboardEntry.rank}",
//                                                             style: const TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.black,
//                                                             ),
//                                                             textAlign: TextAlign.right,
//                                                           ),
//                                                         ),
//                                                         const SizedBox(width: 6),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           }).toList(),
//                                         );
//                                       },
//                                     ),
//               ],
//                                 ),
//                               ),