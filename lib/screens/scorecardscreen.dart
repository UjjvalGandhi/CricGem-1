import 'dart:convert';
import 'package:batting_app/screens/walletScreen.dart';
import 'package:batting_app/widget/normal2.0.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../db/app_db.dart';
import '../model/ContentInsideModel.dart';
import '../model/JoinContestModel.dart';
import '../model/MyTeamListModel.dart';
import '../model/ProfileDisplay.dart';
import '../model/ScoreboardtestModel.dart';

import '../widget/balance_notifire.dart';
import '../widget/small2.0.dart';
import 'package:http/http.dart' as http;

import 'myteam_edit.dart';

class ScoreCardScreen extends StatefulWidget {
  final String? Team1Sortname;
  final String? ContestId;
  final String? Team2Sortname;
  final String? matchid;
  final String? Team1logo;
  final String? Team2logo;

  const ScoreCardScreen(
      {super.key,
      required this.matchid,
      this.ContestId,
      this.Team1Sortname,
      this.Team2Sortname,
      this.Team1logo,
      this.Team2logo});

  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var teamWinningAmounts = {};

  late Future<MyTeamLIstModel?> _futureDataTeam;
  late DateTime matchDateTime;
  final bool _isWithdrawalExpanded1 = false;
  late Duration remainingTime = Duration.zero;
  String currentBalance = "0";
  String? team1Logo;
  String? team2Logo;
  String? team1name;
  String? team2name;

  // Store contest data
  var _contests = [];
  var currentUserId;
  Leaderboard? currentUser;
  String fundsUtilizedBalance = "0";
  TextEditingController addbalance = TextEditingController();
  TextEditingController withdrawBalance = TextEditingController();
  var totalpoints;
  var teamNumber;

  // late Future<ScoreboardtestModel?> _futureData;
  late Future<ScoreboardtestModel?> _futureData = Future.value(null);

  @override
  void initState() {
    super.initState();
    _futureData = Matchscoredata();

    fetchProfileData().then((_) {
      contestDisplay();

    });
    _futureDataTeam = matchDisplay();
    currentUser;
    // playerTotalPoints();

    _tabController = TabController(length: 3, vsync: this);

    //startTimer();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _futureData = Matchscoredata();
  //
  //   fetchProfileData().then((_){
  //     contestDisplay();
  //   });
  //   _futureDataTeam = matchDisplay();
  //
  //   currentUser;
  //   // playerTotalPoints();
  //
  //
  //   _tabController = TabController(length: 3, vsync: this);
  //
  //
  //   //startTimer();
  // }

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


  Future<ContestInsideModel?> contestDisplay() async {
    print('contest displayy 111111111111111111');
    try {
      print('contest displayy 2222222222222222222222');

      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/contest/display?contestId=${widget.ContestId!}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        print('contest displayy 3333333333333333333333333');

        final data = ContestInsideModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print('iddd${data.data!.contestDetails!.id}');
        debugPrint("debugPrint from if part ${response.body}");
        debugPrint('Leaderboard of the contest: ${data.data!.leaderboard}');

        // Parse the match date and time
        matchDateTime =
            DateTime.parse(data.data!.contestDetails!.matchDate.toString()).add(
                Duration(
                    hours: int.parse(
                        data.data!.contestDetails!.matchTime!.split(':')[0]),
                    minutes: int.parse(
                        data.data!.contestDetails!.matchTime!.split(':')[1])));

        // Calculate remaining time
        setState(() {
          for (var entry in data.data!.leaderboard!) {
            teamWinningAmounts[entry.myTeamId!.first] = entry.totalPoints!;
          }
          _contests = data.data!.leaderboard!;
          remainingTime = matchDateTime.difference(DateTime.now());
          print("remaining time is : -----$remainingTime");
          print("remaining time is : -----$matchDateTime");

          // Update currentUser  based on leaderboard
          var storedata = data.data!.leaderboard!.first.winningAmount;
          var storeid = data.data!.leaderboard!.first.id;
          print('store data:- $storedata');
          print('store data:- $storeid');

          for (var entry in data.data!.leaderboard!) {
            debugPrint(
                'User  ID check: ${entry.userId}, Winning Amount: ${entry.winningAmount}, Rank: ${entry.rank}');
            if (entry.userId == currentUserId) {
              currentUser = entry; // Store the current user's leaderboard data
              print(
                  "current user all leaderboard entry:- ${currentUser!.userDetails}");
              print('Current User Found: ${currentUser!.winningAmount}');
              var teamId = currentUser!
                  .myTeamId!.first; // Assuming teamId is part of currentUser
              teamNumber = teamId.contains('T')
                  ? teamId.split('T').last.split(')')[0]
                  : '';
              print('teamid is:-$teamId');
              print('team number is:-$teamNumber');

              break; // Exit the loop once found
            }
          }

          if (currentUser != null) {
            print('Current user winning amount: ${currentUser!.winningAmount}');
          } else {
            print('Current user not found in leaderboard.');
          }
        });

        return data;
      } else {
        debugPrint('Failed to fetch contest message: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching contest data: $e');
      return null;
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
        final data =
            ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
        debugPrint('data ${data.message}'); // Ensure to parse the correct field
        setState(() {
          currentUserId = "${data.data!.id}";
          print('currentUser Id:- $currentUserId');
        });
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
  }

  Future<MyTeamLIstModel?> matchDisplay() async {
    print('MyTeamLIstModel displayy 111111111111111111');
    try {
      print('MyTeamLIstModel displayy 2222222222222222222222');

      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.matchid!}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print('MyTeamLIstModel modal response:- ${response.body}');
      if (response.statusCode == 200) {
        print('MyTeamLIstModel displayy 3333333333333333333333333');

        final data = MyTeamLIstModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        return data;
      } else {
        debugPrint('Failed to fetch contest message: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching contest data: $e');
      return null;
    }
  }

  Future<ScoreboardtestModel?> Matchscoredata() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/scoreboard/userScore/${widget.matchid}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      print('matchid ${widget.matchid}');
      print('status code:- ${response.statusCode}');
      print('status code:- ${response.body}');

      if (response.statusCode == 200) {
        print('matchid ${response.body}');
        // If the server returns a successful response, parse the JSON
        final jsonData = json.decode(response.body);
        team1Logo = jsonData['data']['team1']['logo'];
        team2Logo = jsonData['data']['team2']['logo'];
        team1name = jsonData['data']['team1']['name'];
        team2name = jsonData['data']['team2']['name'];
        setState(() {
          team1Logo = team1Logo;
          team2Logo = team2Logo;
          team1name = team1name;
          team2name = team2name;

          print('team1 logo is:-$team1Logo');
          print('team2 logo is:-$team2Logo');
        });
        return ScoreboardtestModel.fromJson(jsonData);
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

  String? selectedValue;
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  Future<JoinContestModel> _fetchContestData() async {
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/joinContest/mycontests?matchId=${widget.matchid}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        print(response.body);

        return JoinContestModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch contest data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching contest data: $e');
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      _futureData = Matchscoredata();
      // fetchProfileData().then((_) {
      //   contestDisplay();
      // });
      // _futureDataTeam = matchDisplay();
      // Refresh the data
    });
  }
  @override
  Widget build(BuildContext context) {
    final balanceNotifier = Provider.of<BalanceNotifier>(context);
    String balance = balanceNotifier.balance; // Use the balance getter

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  "${team1name ?? widget.Team2Sortname ?? "Unknown Team 1"} vs ${team2name ?? widget.Team1Sortname ?? "Unknown Team 2"}",

                  // "${team1name? ?? "${widget.Team2Sortname}"} vs ${team2name!}",
                  style: TextStyle(color: Colors.white, fontSize: 20.sp)),
              // Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WalletScreen(balanceNotifier: balanceNotifier),
                    ),
                  );
                },
                child: Container(
                  height: 40.h,
                  width: 145.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Vector.png',
                        height: 17.h,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "₹$balance",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      InkWell(
                        onTap: () {
                          // Handle the tap event for adding money to wallet
                        },
                        child: Image.asset(
                          'assets/Plus (1).png',
                          height: 17.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            height: 180.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff140B40), Color(0xff140B40)],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,

          child: FutureBuilder<ScoreboardtestModel?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else if(!snapshot.hasData ){
              return const Center(child: CircularProgressIndicator());
            }
    //   else {
          //     final data = snapshot.data!;// body: FutureBuilder<ScoreboardtestModel?>(


          //     future: _futureData,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Container(
          //             height: MediaQuery.of(context).size.height,
          //             width: MediaQuery.of(context).size.width,
          //             color: const Color(0xffF0F1F5),
          //             child: const Center(child: CircularProgressIndicator()));
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text('Error: ${snapshot.error}'));
          //       } else if (!snapshot.hasData || snapshot.data == null) {
          //         return const Center(child: Text('No data available'));
          //       }
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(child: CircularProgressIndicator());
              //   } else if (snapshot.hasError) {
              //     return Center(child: Text('Error: ${snapshot.error}'));
              //   } else if (!snapshot.hasData && snapshot.data == null) {
              //     return const Center(child: CircularProgressIndicator());
              //
              //     // return const Center(child: Text('No data available'));
              //   }
                else {
                  final data = snapshot.data!;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      child: Stack(children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: const Color(0xffF0F1F5),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                height: 144,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 15),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.black.withOpacity(0.2))),
                                child: Column(
                                  children: [
                                    // Align(
                                    //   alignment: Alignment.topCenter,
                                    //   child: Image.asset(
                                    //     'assets/Frame 5079.png',
                                    //     height: 35,
                                    //   ) ,
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 14),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2E004C),
                                        // Dark purple background color
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          // Rounded corner for bottom-left
                                          bottomRight: Radius.circular(15),
                                        ), // Rounded corners
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'YOU WON',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // Small spacing between texts
                                          Text(
                                            formatMegaPrice(int.parse(currentUser?.winningAmount ?? '0')) ?? "0",
                                            // "₹ ${currentUser?.winningAmount ?? '0' }",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // Text("Live",
                                    //     style: TextStyle(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w500,
                                    //       color: const Color(0xff140B40),
                                    //     )),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 5.h,
                                          width: 5.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "Live",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 3,horizontal: 25),
                                              // padding: const EdgeInsets.only(
                                              //     left: 21, top: 6),
                                              child: Normal2Text(
                                                  color: Colors.black,
                                                  text:
                                                  team1name ?? widget.Team1Sortname ?? "Unknown Team 2",

                                                // "${widget.Team1Sortname}"
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 1,horizontal: 9),
                                              // padding: const EdgeInsets.only(
                                              //     left: 4.0),
                                              child: Small2Text(
                                                  color: Colors.grey,
                                                  text:
                                                      "${data.data!.team1!.score}"),
                                            )
                                          ],
                                        ),
                                        // Column(
                                        //   children: [
                                        //     Normal2Text(
                                        //         color: Colors.black,
                                        //         text: "India beat NZ by 6"
                                        //     ),
                                        //     Normal2Text(color: Colors.black, text: "wickets"),
                                        //   ],
                                        // ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              // padding: const EdgeInsets.only(
                                              //     right: 20, top: 5),
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 3,horizontal: 25),
                                              child: Normal2Text(
                                                  color: Colors.black,
                                                  text:
                                                  team2name ?? widget.Team2Sortname ?? "Unknown Team 2",

                                                // "${widget.Team2Sortname}"
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  // padding: const EdgeInsets.only(
                                                  //     right: 0.0),
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 1,horizontal: 9),
                                                  child: Small2Text(
                                                      color: Colors.grey,
                                                      text:
                                                          "${data.data!.team2!.score}"),
                                                ),
                                                //Small3Text(color: Colors.grey, text: "(40.3)")
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 48,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: TabBar(
                                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the indicator padding
                                  labelPadding:
                                      const EdgeInsets.symmetric(horizontal: 30.0),
                                  tabAlignment: TabAlignment.start,
                                  isScrollable: true,
                                  indicatorColor: const Color(0xff140B40),
                                  labelColor: const Color(0xff140B40),
                                  controller: _tabController,
                                  tabs: const [
                                    Tab(text: 'My Contests'),
                                    Tab(text: 'My Teams'),
                                    // Tab(text: 'Commentary'),
                                    Tab(text: 'Score Card'),
                                    // Tab(text: 'Stats'),
                                    //Tab(text: 'My Network'),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Content for Tab 1
                                    RefreshIndicator(
                                      onRefresh: _refreshData,

                                      child: FutureBuilder<JoinContestModel>(
                                        future: _fetchContestData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color(0xffF0F1F5),
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.data.isEmpty) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color(0xffF0F1F5),
                                                child: const Center(
                                                    child:
                                                        Text('No data available')));
                                          } else {
                                            final contests = snapshot.data!.data;
                                            return Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              color: const Color(0xffF0F1F5),
                                              child: ListView.builder(
                                                itemCount: contests.length,
                                                itemBuilder: (context, index) {
                                                  final contest = contests[index];
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  bottom: 20),
                                                          child: Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  height: 154,
                                                                  width:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  20)),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            formatMegaPrice(contest.contestDetails.pricePool) ?? "0",

                                                                            // "₹${contest.contestDetails.pricePool}",
                                                                            style: const TextStyle(
                                                                                fontSize:
                                                                                    14,
                                                                                color:
                                                                                    Colors.black,
                                                                                fontWeight: FontWeight.w600),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 8,
                                                                      ),
                                                                      Divider(
                                                                        height: 1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 4,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                51,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                Small2Text(
                                                                                    color: Colors.grey,
                                                                                    text: "Prize Pool"),
                                                                                Text(
                                                                                  formatMegaPrice(contest.contestDetails.pricePool) ?? "0",

                                                                                  // "₹${contest.contestDetails.pricePool}",
                                                                                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                51,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                Small2Text(
                                                                                    color: Colors.grey,
                                                                                    text: "Total Spots"),
                                                                                Text(
                                                                                  "${contest.contestDetails.totalParticipant}",
                                                                                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                51,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              children: [
                                                                                Small2Text(
                                                                                    color: Colors.grey,
                                                                                    text: "Entry"),
                                                                                Text(
                                                                                  "₹${contest.contestDetails.entryFees}",
                                                                                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                  height: 50,
                                                                  width:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                            0xff010101)
                                                                        .withOpacity(
                                                                            0.03),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      bottomRight: Radius
                                                                          .circular(
                                                                              20),
                                                                      bottomLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      // Username and Winning Amount Section
                                                                      Flexible(
                                                                        flex: 1,
                                                                        // This allows it to take up only necessary space without affecting other sections
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  8),
                                                                          height:
                                                                              51,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Small2Text(
                                                                                color:
                                                                                    Colors.grey,
                                                                                text:
                                                                                    "Username",
                                                                              ),
                                                                              Text(
                                                                                'You Won ${formatMegaPrice(int.parse(currentUser?.winningAmount ?? "0"))}',

                                                                                // "You Won ₹ ${currentUser?.winningAmount ?? "0"}",
                                                                                style:
                                                                                    const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color(0xff140B40),
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                                overflow:
                                                                                    TextOverflow.ellipsis,
                                                                                // Ensures text does not overflow
                                                                                maxLines:
                                                                                    1,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Points Section
                                                                      SizedBox(
                                                                        width: 100,
                                                                        // Fixed width for the points section
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              48,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              RichText(
                                                                                text:
                                                                                    TextSpan(
                                                                                  children: [
                                                                                    const TextSpan(
                                                                                      text: "T",
                                                                                      // The "T" part
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        color: Colors.grey,
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: teamNumber?.toString() ?? "0",
                                                                                      // The number part
                                                                                      style: const TextStyle(
                                                                                        fontSize: 14,
                                                                                        color: Colors.grey,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                  width: 4),
                                                                              Text(
                                                                                currentUser?.totalPoints.toString() ??
                                                                                    '0',
                                                                                style:
                                                                                    const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Rank Section
                                                                      SizedBox(
                                                                        width: 70,
                                                                        // Fixed width for the rank section
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              48,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "#${currentUser?.rank.toString() ?? '0'}",
                                                                                style:
                                                                                    const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // Content for Tab 2
                                    InkWell(
                                      onTap: () {},
                                      child: FutureBuilder<MyTeamLIstModel?>(
                                        future: _futureDataTeam,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color(0xffF0F1F5),
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data?.data.isEmpty ==
                                                  true) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: const Color(0xffF0F1F5),
                                                child: const Center(
                                                    child: Text(
                                                        'No teams available')));
                                          } else {
                                            final myTeamData =
                                                snapshot.data!.data;
                                            print(
                                                "this is my team list data ::$myTeamData");
                                            return Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: const Color(0xffF0F1F5),
                                              child: SingleChildScrollView(
                                                // physics: NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  children: myTeamData
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    int index = entry.key;
                                                    var team = entry.value;
                                                    String lastFourDigits =
                                                        team.id.substring(
                                                            team.id.length - 4);
                                                    String teamLabel = team.team_label!;
                                                        // 'T${index + 1}';
                                                    String appId =
                                                        "BOSS $lastFourDigits $teamLabel";

                                                        // "BOSS $lastFourDigits ($teamLabel)";
                                                    String matchname =
                                                        "${widget.Team1Sortname} vs ${widget.Team2Sortname}";
                                                    var totalpointsofteam =
                                                        teamWinningAmounts[
                                                                team.id] ??
                                                            '0';

                                                    print(
                                                        "match name is:- $matchname");
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            'team label is:- $teamLabel');
                                                        print(
                                                            "team id is: - ${team.id}");
                                                        print(
                                                            "match id is:- ${widget.matchid}");
                                                        print(
                                                            "app id is:- $appId");
                                                        print(
                                                            "match name is:- $matchname");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MyTeamEdit(
                                                                isScoreboardTeam:
                                                                    true,
                                                                teamId: team.id,
                                                                matchId: widget
                                                                    .matchid,
                                                                appId: appId,
                                                                matchName:
                                                                    matchname,
                                                              ),
                                                            ));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(height: 10),
                                                          Column(
                                                            children: [
                                                              Stack(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    height: 167,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              appId,
                                                                              // "BOSS $lastFourDigits ($teamLabel)",
                                                                              style:
                                                                                  const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Image.network(
                                                                                  team.team1Logo ?? 'https://via.placeholder.com/26',
                                                                                  // Placeholder URL
                                                                                  height: 30,
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset('assets/remove.png', height: 26); // Default image
                                                                                  },
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                const Text("vs"),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Image.network(
                                                                                  team.team2Logo ?? 'https://via.placeholder.com/26',
                                                                                  // Placeholder URL
                                                                                  height: 30,
                                                                                  errorBuilder: (context, error, stackTrace) {
                                                                                    return Image.asset('assets/default_team_image.png', height: 26); // Default image
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            // InkWell(
                                                                            //   onTap: (){
                                                                            //
                                                                            //   },
                                                                            //   child: const Icon(Icons.share,
                                                                            //       size: 18),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                5),
                                                                        Divider(
                                                                            height:
                                                                                1,
                                                                            color: Colors
                                                                                .grey
                                                                                .shade300),
                                                                        const SizedBox(
                                                                            height:
                                                                                12),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Normal2Text(color: Colors.black, text: "Points"),
                                                                                Text(
                                                                                  (totalpointsofteam is double ? totalpointsofteam : double.tryParse(totalpointsofteam?.toString() ?? '0'))?.toStringAsFixed(0) ?? '0',

                                                                                  // '${totalpointsofteam?.toStringAsFixed(0) ?? '0'}',
                                                                                  // currentUser?.totalPoints.toString() ?? '0',
                                                                                  // totalpoints?.toString() ?? "0",
                                                                                  // "100",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 22,
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Spacer(),
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 43,
                                                                                  width: 43,
                                                                                  child: Image.network(
                                                                                    team.captain?.playerPhoto ?? 'https://via.placeholder.com/26',
                                                                                    // Placeholder URL
                                                                                    height: 36,
                                                                                    errorBuilder: (context, error, stackTrace) {
                                                                                      return Image.asset('assets/dummy_player.png', height: 26); // Default image
                                                                                    },
                                                                                  ),
                                                                                  // child: Image.asset(
                                                                                  //   'assets/rohilleft.png',
                                                                                  //   fit: BoxFit.fill,
                                                                                  // ),
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(0xffF0F1F5),
                                                                                    borderRadius: BorderRadius.circular(2),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      team.captain?.playerName ?? '',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: const TextStyle(
                                                                                        fontSize: 9,
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                                width: 10),
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 43,
                                                                                  width: 43,
                                                                                  child: Image.network(
                                                                                    team.vicecaptain?.playerPhoto ?? 'https://via.placeholder.com/26',
                                                                                    // Placeholder URL
                                                                                    height: 36,
                                                                                    errorBuilder: (context, error, stackTrace) {
                                                                                      return Image.asset('assets/dummy_player.png', height: 26); // Default image
                                                                                    },
                                                                                  ),
                                                                                  // child: Image.asset(
                                                                                  //   'assets/nzright.png',
                                                                                  //   fit: BoxFit.fill,
                                                                                  // ),
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(0xffF0F1F5),
                                                                                    borderRadius: BorderRadius.circular(2),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      team.vicecaptain?.playerName ?? '',
                                                                                      style: const TextStyle(
                                                                                        fontSize: 9,
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    height: 34,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                              0xff010101)
                                                                          .withOpacity(
                                                                              0.03),
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                20),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Normal2Text(
                                                                          color: Colors
                                                                              .black,
                                                                          text:
                                                                              "WK ${team.wicketkeeper ?? ''}",
                                                                        ),
                                                                        Normal2Text(
                                                                          color: Colors
                                                                              .black,
                                                                          text:
                                                                              "BAT ${team.batsman}",
                                                                        ),
                                                                        Normal2Text(
                                                                          color: Colors
                                                                              .black,
                                                                          text:
                                                                              "AR ${team.allrounder}",
                                                                        ),
                                                                        Normal2Text(
                                                                          color: Colors
                                                                              .black,
                                                                          text:
                                                                              "BOWL ${team.bowler ?? ''}",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // Content for Tab 3
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: SingleChildScrollView(
                                        // scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 5),
                                                child: SingleChildScrollView(
                                                  child: ExpansionTile(
                                                    iconColor: Colors.black,
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                            '${data
                                                                .data!
                                                                .team1!.name} 1st Inn',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15)),
                                                        const Spacer(),
                                                        Text(
                                                            '${data.data!.team1!.score}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                    children: [
                                                      const Divider(
                                                          height: 6,
                                                          thickness: 1,
                                                          color: Colors.grey),
                                                      const SizedBox(height: 5),

                                                      // Batters Section
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        child: Container(
                                                          color:
                                                              const Color(0xff140B40),
                                                          // Set background color to brown
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                      ' Batter',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                              Spacer(),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('R',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('B',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('4s',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('6s',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('SR',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),

                                                      // Batters List
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: data
                                                            .data!
                                                            .team1!
                                                            .batting1Players!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var player = data
                                                                  .data!
                                                                  .team1!
                                                                  .batting1Players![
                                                              index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 4),
                                                            child: Container(
                                                              color: index % 2 ==
                                                                      0
                                                                  ? Colors
                                                                      .grey[300]
                                                                  : Colors.white,
                                                              // Alternate colors
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child: Text(
                                                                          ' ${player.playerName}',
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                  const Spacer(),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          '${player.runs}',
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          '${player.ballsFaced}',
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          '${player.four}',
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          '${player.six}',
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          '${player.strikeRate}',
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .w500,
                                                                              fontSize:
                                                                                  13),
                                                                          maxLines:
                                                                              1)),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),

                                                      const SizedBox(height: 6),

                                                      // Bowlers Section
                                                      const Divider(
                                                          height: 1,
                                                          color: Colors.grey,
                                                          thickness: 1),
                                                      const SizedBox(height: 6),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        child: Container(
                                                          color:
                                                              const Color(0xff140B40),
                                                          // Set background color to brown
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                      ' Bowler',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Spacer(),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('O',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('R',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('W',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('E',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),

                                                      // Bowlers List
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: data
                                                            .data!
                                                            .team1!
                                                            .bowling1Players!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var bowler = data
                                                                  .data!
                                                                  .team1!
                                                                  .bowling1Players![
                                                              index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 4),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .white,
                                                                  // Alternate colors
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                          flex: 3,
                                                                          child: Text(
                                                                              ' ${bowler.playerName}',
                                                                              style:
                                                                                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                      const Spacer(),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                              '${bowler.overs}',
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                              '${bowler.runs}',
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                              '${bowler.wickets}',
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                              '${bowler.economy}',
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width, // No fixed height
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 5),
                                                // Reduced vertical padding
                                                child: SingleChildScrollView(
                                                  child: ExpansionTile(
                                                    iconColor: Colors.black,
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                            '${data
                                                                .data!
                                                                .team2!.name} 2nd Inn',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15)),
                                                        const Spacer(),
                                                        Text(
                                                            '${data.data!.team2!.score}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                    children: [
                                                      const Divider(
                                                          height: 6,
                                                          thickness: 1,
                                                          color: Colors.grey),
                                                      const SizedBox(height: 3),
                                                      // Reduced height
                                                      // Batters Section
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        child: Container(
                                                          color:
                                                              const Color(0xff140B40),
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                      ' Batter',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Spacer(),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('R',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('B',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                      '4s',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                      '6s',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                      'SR',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      // Reduced height

                                                      // Batters List
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        // Disable scrolling inside
                                                        itemCount: data
                                                            .data!
                                                            .team2!
                                                            .batting2Players!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var player = data
                                                                  .data!
                                                                  .team2!
                                                                  .batting2Players![
                                                              index];
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            3),
                                                                child: Container(
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .white,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                          flex: 3,
                                                                          child:
                                                                              Text(
                                                                            ' ${player.playerName}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      const Spacer(),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${player.runs}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${player.ballsFaced}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${player.four}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${player.six}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${player.strikeRate}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 3),
                                                              // Reduced height
                                                            ],
                                                          );
                                                        },
                                                      ),

                                                      const SizedBox(height: 3),
                                                      // Maintain a small height

                                                      // Bowlers Section
                                                      const Divider(
                                                          height: 1,
                                                          color: Colors.grey,
                                                          thickness: 1),
                                                      const SizedBox(height: 5),
                                                      // Maintain a small height
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        child: Container(
                                                          color:
                                                              const Color(0xff140B40),
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                      ' Bowler',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Spacer(),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('O',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('R',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('W',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('E',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      // Reduced height

                                                      // Bowlers List
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: data
                                                            .data!
                                                            .team2!
                                                            .bowling2Players!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var bowler = data
                                                                  .data!
                                                                  .team2!
                                                                  .bowling2Players![
                                                              index];
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            2),
                                                                child: Container(
                                                                  color: index %
                                                                              2 ==
                                                                          0
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .white,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                          flex: 3,
                                                                          child:
                                                                              Text(
                                                                            ' ${bowler.playerName}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      const Spacer(),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${bowler.overs}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${bowler.runs}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Text(
                                                                            '${bowler.wickets}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13),
                                                                            maxLines:
                                                                                1,
                                                                          )),
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                              '${bowler.economy}',
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                              maxLines: 1)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5),
                                                              // Reduced height
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 120,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: 50,
                            left: 36,
                            child: Image.network(
                              team1Logo ?? widget.Team1logo ?? "Unknown Team 1",

                              // '${team1Logo}',
                              height: 60,
                            )),
                        Positioned(
                            top: 50,
                            right: 36,
                            child: Image.network(
                              team2Logo ?? widget.Team2logo ?? "Unknown Team 2",

                              // '${team2Logo}',
                              height: 60,
                            ))
                      ]),
                    ),
                  );
                }
              }),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBatterRow(String name, String runs, String balls, String fours,
      String sixes, String sr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              runs,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              balls,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              fours,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              sixes,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              sr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExtrasAndTotalRow() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Extras", style: TextStyle(color: Colors.black)),
            Text("6", style: TextStyle(color: Colors.black)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total", style: TextStyle(color: Colors.black)),
            Text("107-3 (35.0)", style: TextStyle(color: Colors.black)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("CRR", style: TextStyle(color: Colors.black)),
            Text("3.06", style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget buildBowlerRow(String name, String overs, String maidens, String runs,
      String wickets, String er) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              overs,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              maidens,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              runs,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              wickets,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              er,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

// print('iddd${data.data!.contestDetails!.id}');
// debugPrint("debugPrint from if part ${response.body}");
// debugPrint('Leaderboard of the contest: ${data.data!.leaderboard}');
//
// // Parse the match date and time
// matchDateTime = DateTime.parse(data.data!.contestDetails!.matchDate.toString()).add(
//     Duration(
//         hours: int.parse(data.data!.contestDetails!.matchTime!.split(':')[0]),
//         minutes: int.parse(data.data!.contestDetails!.matchTime!.split(':')[1])));
//
// // Calculate remaining time
// setState(() {
//   _contests = data.data!.leaderboard!;
//   remainingTime = matchDateTime.difference(DateTime.now());
//   print("remaining time is : -----$remainingTime");
//   print("remaining time is : -----$matchDateTime");
//
//   // Update currentUser  based on leaderboard
//   var storedata = data.data!.leaderboard!.first.winningAmount;
//   var storeid = data.data!.leaderboard!.first.id;
//   print('store data:- ${storedata}');
//   print('store data:- ${storeid}');
//
//   for (var entry in data.data!.leaderboard!) {
//     debugPrint('User  ID check: ${entry.userId}, Winning Amount: ${entry.winningAmount}, Rank: ${entry.rank}');
//     if (entry.userId == currentUserId) {
//       currentUser = entry; // Store the current user's leaderboard data
//       print("current user all leaderboard entry:- ${currentUser!.userDetails}");
//       print('Current User Found: ${currentUser!.winningAmount}');
//       var teamId = currentUser!.myTeamId!.first; // Assuming teamId is part of currentUser
//       teamNumber = teamId.contains('T')
//           ? teamId.split('T').last.split(')')[0]
//           : '';
//       print('teamid is:-${teamId}');
//       print('team number is:-${teamNumber}');
//
//       break; // Exit the loop once found
//     }
//   }
//
//   if (currentUser != null) {
//     print('Current user winning amount: ${currentUser!.winningAmount}');
//   } else {
//     print('Current user not found in leaderboard.');
//   }
// });

// Future<ContestInsideModel?> contestDisplay() async {
//   print('contest display is showing...............');
//   try {
//     print('current user full details:-${currentUser}');
//
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token aaaaaaaaaaaaaaaaaaaaaaaas:- $token');
//     final response = await http.get(
//       Uri.parse(
//           'https://batting-api-1.onrender.com/api/contest/display?contestId=${widget.ContestId}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     print("working of the response :-${response.body}");
//     if (response.statusCode == 200) {
//       print("working of the response 22222222222222222222222222:-${response.body}");
//
//       final data = ContestInsideModel.fromJson(jsonDecode(response.body));
//       print("working of the response 333333333333333333333333:-${response.body}");
//
//       debugPrint('Data: ${data.message}');
//       print("working of the response 444444444444444444444444444:-${response.body}");
//
//       print('iddd${data.data?.contestDetails?.id}');
//       print("working of the response 5555555555555555555:-${response.body}");
//
//       debugPrint("debugPrint from if part ${response.body}");
//       print("working of the response 66666666666666666666666666:-${response.body}");
//
//       print('current user full details222222:-${currentUser}');
//       print("working of the response 777777777777777777777777:-${response.body}");
//
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
//         _contests = data.data!.leaderboard!;
//         remainingTime = matchDateTime.difference(DateTime.now());
//         print("remaining time is : -----$remainingTime");
//         print("remaining time is : -----$matchDateTime");
//         for (var entry in data.data!.leaderboard!) {
//           if (entry.userId == currentUserId) {
//             print("working of the response 888888888888888888888:-${response.body}");
//
//             currentUser = entry; // Store the current user's leaderboard data
//             var teamId = currentUser!.myTeamId!.first; // Assuming teamId is part of currentUser
//             teamNumber = teamId.contains('T')
//                 ? teamId.split('T').last.split(')')[0]
//                 : '';
//             print('current user full details33333333333333333:-${currentUser}');
//
//             // You can now use teamNumber as needed
//             debugPrint("Current User's Team Number: $teamNumber");
//             break; // Exit the loop once found
//           }
//         }
//         currentUser;
//         print('current user amount:- ${currentUser!.totalPoints.toString()}');
//       });
//
//       return data;
//     } else {
//       debugPrint("this is else response::${response.body}");
//       debugPrint('Failed to fetch contest data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching contest data: $e');
//     debugPrint('error fetching contest data: ${e.toString()}');
//     return null;
//   }
// }
// Future<MyTeamLIstModel?> matchDisplay() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse(
//           'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.matchid}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//
//       print("this is respons of My team List ::${response.body}");
//       return MyTeamLIstModel.fromJson(jsonDecode(response.body));
//     } else {
//       debugPrint('Failed to fetch team data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching team data: $e');
//     return null;
//   }
// }

// Future<PointsResponse?> playerTotalPoints() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse(
//           "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.matchid}"),
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
//       print('my matchv : ${widget.matchid}');
//       print("this is respons of My team List ::${response.body}");
//
//       final data = PointsResponse.fromJson(jsonData);
//       // totalpoints = data.data;
//
//       setState(() {
//         if (data.data.isNotEmpty) {
//           // Assuming data.data is a List<PlayerPointsData>
//           totalpoints = data.data[0].totalPoints; // Get totalPoints from the first item
//         } else {
//           totalpoints = 0; // Default value if no data
//         }
//
//         // pointsStorage.storePoints(totalpoints);
//         print('points are showing right or not:- ${totalpoints}');
//         totalpoints;
//       });
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

//
// Container(
//     margin: const EdgeInsets.all(15),
//     padding: const EdgeInsets.symmetric(
//         horizontal: 8),
//     height: 50,
//     width: MediaQuery.of(context).size.width,
//     decoration: BoxDecoration(
//         color: const Color(0xff010101)
//             .withOpacity(0.03),
//         borderRadius: BorderRadius.only(
//             bottomRight:
//             Radius.circular(20),
//             bottomLeft:
//             Radius.circular(20))),
//     child: Row(
//       mainAxisAlignment:
//       MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           padding:
//           const EdgeInsets.only(left: 8),
//           height: 51,
//           child: Column(
//             mainAxisAlignment:
//             MainAxisAlignment.center,
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//             children: [
//               Small2Text(
//                   color: Colors.grey,
//                   text: "Username"),
//               Text(
//
//                 // currentUser != null && currentUser!.userDetails.isNotEmpty
//                 //   ? "${currentUser!.userDetails[0].name}" // Access the name safely
//                 //   : "No User",
//
//
//                 // "${currentUser!.userDetails[0].name ?? ""}",
//                 "You Won ₹ ${currentUser?.winningAmount ?? "0"}",
//                 style: TextStyle(
//                     fontSize: 14,
//                     color: const Color(
//                         0xff140B40),
//                     fontWeight:
//                     FontWeight.w500),
//               )
//             ],
//           ),
//         ),
//         // SizedBox(width: 10),
//         Container(
//             padding: EdgeInsets.only(left: 6),
//             height: 48,
//             child: Row(
//               children: [
//                 // Small2Text(
//                 //     color: Colors.grey,
//                 //     text:
//                 //     "T${teamNumber!.toString()}",
//                 //     // "T1 "
//                 // ),
//                 // Text("T${teamNumber!.toString()}",style: TextStyle(fontSize: 14,color: Colors.grey),),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "T", // The "T" part
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           // fontWeight: FontWeight., // You can change the style as needed
//                         ),
//                       ),
//                       TextSpan(
//                         text: teamNumber!.toString(), // The number part
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey, // Change color or style as needed
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   currentUser!.totalPoints.toString(),
//                   // "647",
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight:
//                       FontWeight.w500),
//                 )
//               ],
//             )),
//         Container(
//             padding:  EdgeInsets.only(
//                 right: 9),
//             height: 48,
//             child: Row(
//               children: [
//                 Text(
//             "#${currentUser!.rank.toString()}",
//                   // "#65,69,554",
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight:
//                       FontWeight.w500),
//                 ),
//               ],
//             ))
//       ],
//     )),
// appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(63.0),
//   child: ClipRRect(
//     child: CustomAppBar(title: "${widget.Team1Sortname} vs ${widget.Team2Sortname}" ?? "",
//       // subtitle: formatRemainingTime(widget.remainingTime),
// subtitle: "",
//       // subtitle: formatRemainingTime(remainingTime),
//
//       onBackPressed: () => Navigator.pop(context),
//       // fetchWalletBalance: walletDisplay
//     ),
//   ),
// ),

// appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(70.0),
//   child: ClipRRect(
//     child: AppBar(
//       surfaceTintColor: const Color(0xffF0F1F5),
//       backgroundColor: const Color(0xffF0F1F5), // Custom background color
//       elevation: 0, // Remove shadow
//       centerTitle: true,
//       leading: Container(),
//       flexibleSpace: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         height: 100,
//         width: MediaQuery.of(context).size.width,
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xff1D1459), Color(0xff140B40)])),
//         child: Column(
//           children: [
//             const SizedBox(height: 48),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     AppBarText(color: Colors.white, text: "${widget.Team1Sortname} vs ${widget.Team2Sortname}"),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     await showModalBottomSheet(
//                       context: context,
//                       builder: (context) {
//                         return StatefulBuilder(
//                           builder: (context, setState) {
//                             return Container(
//                               // padding: const EdgeInsets.only(
//                               //     top: 10, left: 15, right: 15),
//                               //height: 800,
//                               width: MediaQuery
//                                   .of(context)
//                                   .size
//                                   .width,
//                               decoration: const BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(28),
//                                     topLeft: Radius.circular(28)),
//                                 color: Colors.white,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: double.infinity,
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(28),
//                                             topLeft: Radius.circular(28)),
//                                         gradient: LinearGradient(
//                                             begin: Alignment.bottomRight,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               Color(0xff1D1459)
//                                                   .withOpacity(0.4),
//                                               Color(0xff1D1459)
//                                                   .withOpacity(0.1),
//                                             ])),
//                                     child: const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           Text("Current Balance"),
//                                           Text(
//                                             '₹ 0.00',
//                                             style: TextStyle(
//                                                 fontSize: 25,
//                                                 fontWeight:
//                                                 FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     height: 62,
//                                     decoration: const BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(28),
//                                           topLeft: Radius.circular(28)),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text("Unutilized Balance"),
//                                               InkWell(
//                                                   onTap: () {},
//                                                   child: Icon(
//                                                     Icons
//                                                         .info_outline_rounded,
//                                                     color: Colors.grey,
//                                                   ))
//                                             ],
//                                           ),
//                                           Text(
//                                             '₹ $fundsUtilizedBalance',
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight:
//                                                 FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Divider(),
//                                   Container(
//                                     width: double.infinity,
//                                     height: 62,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(28),
//                                           topLeft: Radius.circular(28)),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                             MainAxisAlignment
//                                                 .spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text("Winnings"),
//                                                   InkWell(
//                                                       onTap: () {},
//                                                       child: Icon(
//                                                         Icons
//                                                             .info_outline_rounded,
//                                                         color: Colors.grey,
//                                                       ))
//                                                 ],
//                                               ),
//                                               Text(
//                                                 '₹ 0.00',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                           InkWell(
//                                             onTap: (){
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         AddCashScreen(),
//                                                   ));
//                                             },
//                                             child: Container(
//                                               height: 45,
//                                               width: 110,
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       8),
//                                                   color: Color(0xff1D1459)),
//                                               child: const Center(
//                                                 child: Text(
//                                                   "Withdraw",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                       FontWeight.w800,
//                                                       fontSize: 16,
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//
//                                   Divider(),
//                                   Container(
//                                     height: 60,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(),
//                                     child:  Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "My Transactions",
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight:
//                                                 FontWeight.w600),
//                                           ),
//                                           InkWell(
//                                             onTap: (){
//                                               Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                                             },
//                                             child: Icon(
//                                               Icons
//                                                   .arrow_forward_ios_outlined,
//                                               size: 35,
//                                               color: Colors.black,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//
//                                   Divider(),
//                                   Spacer(),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 15),
//                                     child: InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   AddCashScreen(),
//                                             ));
//                                       },
//                                       child: Container(
//                                         width: double.infinity,
//                                         height: 45,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(8),
//                                             color: Color(0xff1D1459)),
//                                         child: Center(
//                                           child: Text(
//                                             "Add Cash",
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                 ],
//                               ),
//                             );
//
//                           },
//                         );
//                       },
//                     );
//                   },
//                   child: Container(
//                     height: 40,
//                     width: 94,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.white.withOpacity(0.1),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/Vector.png',
//                           height: 17,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(width: 4),
//                         const Text(
//                           "₹220",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         InkWell(
//                           onTap: () {},
//                           child: Image.asset(
//                             'assets/Plus (1).png',
//                             height: 17,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
