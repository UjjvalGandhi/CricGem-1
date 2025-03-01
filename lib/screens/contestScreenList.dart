import 'dart:convert';
import 'package:batting_app/screens/ind_vs_sa_screen.dart';
import 'package:batting_app/screens/myteam_edit.dart';
import 'package:batting_app/screens/walletScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';
import '../model/MyTeamListModel.dart';
import '../model/WalletModel.dart';
import '../model/totalplayerpointmodal.dart';
import '../widget/appbar_for_team.dart';
import '../widget/balance_notifire.dart';
import '../widget/normal3.dart';
import '../widget/notification_service.dart';
import '../widget/notificationprovider.dart';
import 'content_inside screen.dart';
import 'create_team.dart';

class ContestMatchList extends StatefulWidget {
  final String matchName;
  final bool iscreatematch;

  final String cId;
  final String Id;
  final DateTime? date;
  final String? time;
  final String? firstmatch;
  final String? secMatch;
  final List<String>? currentUserTeamIds; // Add this line in ContestMatchList
  final String? amount;

  const ContestMatchList({
    super.key,
    required this.matchName,
    this.iscreatematch = false,
    required this.cId,
    this.currentUserTeamIds,
    required this.Id,
    this.date,
    this.time,
    this.amount,
    this.firstmatch,
    this.secMatch,
  });

  @override
  State<ContestMatchList> createState() => _ContestMatchListState();
}

class _ContestMatchListState extends State<ContestMatchList> {
  bool _isLoading = false; // New variable to track loading state
  var totalpoints;

  late Future<MyTeamLIstModel?> _futureDataTeam;
  final List<String> _selectedTeamIds = [];

  late DateTime matchDateTime;
  late Duration remainingTime = Duration.zero;

  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m left";
  }

  bool _isButtonEnabled = false;
  List paymentImage = ['assets/paybg.png', 'assets/gbg.png', 'assets/ppbg.png'];
  List paymentText = [
    "PhonePe UPI Lite",
    "Google Pay UPI",
    "Amazon Pay UPI",
  ];

  // String currentBalance = "0";
  // String fundsUtilizedBalance = "0";

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

  late Future<HomeLeagModel?> _futureData;

  @override
  void initState() {
    super.initState();
    _futureDataTeam = matchDisplay();
    playerTotalPoints();
    totalpoints;
    walletDisplay();
  }

  Future<PointsResponse?> playerTotalPoints() async {
    try {
      String? token = await AppDB.appDB.getToken();
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
        // var data = response.body;
        final dynamic jsonData = jsonDecode(response.body);
        print('my match id  : ${widget.Id}');
        print("this is respons of My team List ::${response.body}");

        final data = PointsResponse.fromJson(jsonData);
        // totalpoints = data.data;

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
        });

        // return PointsResponse.fromJson(jsonDecode(response.body));
        return data;
      } else {
        debugPrint('Failed to fetch team data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching team data: $e');
      return null;
    }
  }

  // Future<MyTeamLIstModel?> matchDisplay() async {
  //   print("Page open for select team:-----------------");
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.Id}'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       debugPrint("this is response of My team List :: ${response.body}");
  //       var myTeamListModel =
  //       MyTeamLIstModel.fromJson(jsonDecode(response.body));
  //       matchDateTime = DateTime.parse(myTeamListModel.data[0].match_date.toString())
  //           .add(Duration(
  //           hours: int.parse(myTeamListModel.data[0].match_time!.split(':')[0]),
  //           minutes: int.parse(myTeamListModel.data[0].match_time!.split(':')[1])));
  //
  //       // Calculate remaining time
  //       setState(() {
  //         remainingTime = matchDateTime.difference(DateTime.now());
  //
  //       });
  //
  //
  //       print(remainingTime);
  //       print(matchDateTime);
  //
  //
  //
  //       return myTeamListModel;
  //     } else {
  //       debugPrint('Failed to fetch team data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching team data: $e');
  //     return null;
  //   }
  // }
  Future<MyTeamLIstModel?> matchDisplay() async {
    print("Page open for select team:-----------------");
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
        debugPrint("this is response of My team List :: ${response.body}");
        var myTeamListModel =
            MyTeamLIstModel.fromJson(jsonDecode(response.body));

        // Parse the match date and time (assume UTC from API)
        matchDateTime =
            DateTime.parse(myTeamListModel.data[0].match_date.toString()).add(
                Duration(
                    hours: int.parse(
                        myTeamListModel.data[0].match_time!.split(':')[0]),
                    minutes: int.parse(
                        myTeamListModel.data[0].match_time!.split(':')[1])));

        // If match time is in UTC, convert to the desired time zone (e.g., IST)
        // matchDateTime = matchDateTime.toUtc().add(Duration(hours: 5, minutes: 30)); // Convert to IST (UTC+5:30)

        // Debug log: check match time after conversion
        print("Match DateTime (IST): $matchDateTime");

        // Calculate remaining time
        setState(() {
          // Convert current time to IST
          DateTime currentTimeIST = DateTime.now().toUtc().add(const Duration(
              hours: 5, minutes: 30)); // Convert current time to IST

          // Calculate the difference
          remainingTime = matchDateTime.difference(currentTimeIST);

          print("Remaining time is: -----$remainingTime");
          print("Match DateTime is: -----$matchDateTime");
        });

        return myTeamListModel;
      } else {
        debugPrint('Failed to fetch team data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching team data: $e');
      return null;
    }
  }

  // Future<void> joinContest() async {
  //   debugPrint("Join contest called:--------------------------");
  //   print("Selected team IDs: $_selectedTeamIds");
  //
  //   setState(() {
  //     _isLoading = true; // Start loading
  //   });
  //
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     if (token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Token is null.')),
  //       );
  //       setState(() {
  //         _isLoading = false; // Stop loading
  //       });
  //       return;
  //     }
  //
  //     // Fetch balance to validate before making the request
  //     final balanceNotifier = Provider.of<BalanceNotifier>(context, listen: false);
  //     double currentBalance = double.parse(balanceNotifier.balance);
  //     double contestAmount = double.parse(widget.amount!);
  //     List<String> messages = []; // To store messages from API responses
  //
  //     for (String teamId in _selectedTeamIds) {
  //       // Prepare payload for the API
  //       var payload = jsonEncode({
  //         'contest_id': widget.cId,
  //         'myTeam_id': teamId,
  //       });
  //
  //       // Log current balance before the API call
  //       print('Current balance before joining team $teamId: $currentBalance');
  //       print('Total amount required for team $teamId: $contestAmount');
  //
  //       // Check if balance is sufficient before proceeding
  //       if (currentBalance < contestAmount) {
  //         messages.add(
  //             'Insufficient balance to join contest with team ID: $teamId.');
  //         continue; // Skip this team and process the next
  //       }
  //
  //       // Call API for the current team ID
  //       final response = await http.post(
  //         Uri.parse("https://batting-api-1.onrender.com/api/joinContest/joinContest"),
  //         body: payload,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           "Authorization": token,
  //         },
  //       );
  //
  //       // Handle API response
  //       final responseData = jsonDecode(response.body);
  //       if (response.statusCode == 200) {
  //         if (responseData['success'] == true) {
  //           // Update balance after successful join
  //           currentBalance -= contestAmount; // Deduct the contest amount
  //           balanceNotifier.updateBalance(currentBalance.toString());
  //
  //           messages.add('Successfully joined contest with team ID: $teamId.');
  //         } else if (responseData['message'] ==
  //             "You Have Join already joined with Team") {
  //           messages.add('You have already joined the contest with team ID: $teamId.');
  //         } else {
  //           messages.add(
  //               'Failed to join contest with team ID: $teamId: ${responseData['message']}');
  //         }
  //       } else {
  //         messages.add(
  //             'Failed to join contest with team ID: $teamId: ${responseData['message']}');
  //       }
  //     }
  //
  //     // Show all accumulated messages at the end
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(messages.join('\n'))),
  //     );
  //   } catch (e) {
  //     print("Exception occurred: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('An error occurred while trying to join the contest.')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Stop loading
  //     });
  //   }
  // }

  Future<void> joinContest() async {
    debugPrint("Join contest called:--------------------------");
    print("team id is :- $_selectedTeamIds");
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      String? token = await AppDB.appDB.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is null.'),
          ),
        );
        setState(() {
          _isLoading = false; // Stop loading
        });
        return;
      }

      // Prepare payload and total amount calculation
      var payload = jsonEncode({
        'contest_id': widget.cId,
        'myTeam_id': _selectedTeamIds,
      });
      double totalAmount =
          _selectedTeamIds.length * double.parse(widget.amount!);

      // Fetch balance to validate before making the request
      final balanceNotifier =
          Provider.of<BalanceNotifier>(context, listen: false);
      double currentBalance = double.parse(balanceNotifier.balance);

      // Check for insufficient balance before proceeding
      if (currentBalance < totalAmount) {
        setState(() {
          _isLoading = false; // Stop loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'You have insufficient balance in your wallet. Please add funds.',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        );

        // Navigate to WalletScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WalletScreen(balanceNotifier: balanceNotifier),
          ),
        );
        return; // Stop further execution
      }

      // Proceed with API request
      final response = await http.post(
        Uri.parse(
            "https://batting-api-1.onrender.com/api/joinContest/joinContest"),
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": token,
        },
      );

      // Handle response
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(responseData['message'])),
          ),
        );
      }
      if (response.statusCode == 200) {
        print('Response data: $responseData');

        if (responseData['success'] == false &&
            responseData['message'] ==
                "You Have Join already joined with Team") {
          setState(() {
            _isLoading = false; // Stop loading
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                  child: Text('You have already joined with this team.')),
            ),
          );
          return; // Exit without navigating
        }

        // Update balance after successful join
        int newBalance = (currentBalance - totalAmount).toInt();
        balanceNotifier.updateBalance(newBalance.toString());

        setState(() {
          _isLoading = false; // Stop loading
        });
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
            title: 'Join successful',
            body: 'Team join contest successfully!',
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(responseData['message'])),
          ),
        );

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IndVsSaScreens(
              IsCreateTeamScreen: true,
              matchName: widget.matchName,
              Id: widget.Id,
              date: widget.date,
              time: widget.time,
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false; // Stop loading
        });
        print("print the status code of response :- ${response.statusCode}");
        print("Failed to join contest: ${response.body}");

        // Handle other failure scenarios
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child:
                  Text('Failed to join contest. ${responseData['message']}.'),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      print("Exception occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while trying to join the contest.'),
        ),
      );
    }
  }

  void updateButtonState() {
    setState(() {
      _isButtonEnabled = _selectedTeamIds.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BalanceNotifier balanceNotifier;
    // Access BalanceNotifier from the Provider
    balanceNotifier = Provider.of<BalanceNotifier>(context);
    final currentUserTeamIds = widget.currentUserTeamIds ?? [];
    // Initialize ScreenUtil before using it
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);

    print("this is cId::${widget.cId}");
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Navigate to the login page when the back button is pressed
        // if(widget.iscreatematch){
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ContentInside(
        //         isCreateTeam:true,
        //         time: widget.time,
        //         CId: widget.cId,
        //         matchName: widget.matchName,
        //         Id: widget.Id,
        //       ),
        //     ),
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
              builder: (context) => ContentInside(
                isCreateTeam: true,
                time: widget.time,
                CId: widget.cId,
                matchName: widget.matchName,
                Id: widget.Id,
              ),
            ),
            (route) => false,
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
                    // subtitle: formatRemainingTime(remainingTime),
                    subtitle: widget.time ?? '',
                    onBackPressed: () async => {
                          await Future.microtask(() {
                            // Check if the navigator can pop before trying to pop
                            // if(widget.isCreateTeam){
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
                              (route) => false,
                            );
                            // } else {
                            //   if (Navigator.canPop(context)) {
                            //     Navigator.pop(context);
                            //   } else {
                            //     print("No route to pop!");
                            //   }
                            // }
                          }),
                        }
                    // widget.iscreatematch ?
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ContentInside(
                    //       isCreateTeam:true,
                    //       time: widget.time,
                    //       CId: widget.cId,
                    //       matchName: widget.matchName,
                    //       Id: widget.Id,
                    //     ),
                    //   ),
                    // ) : Navigator.pop(context),
                    // fetchWalletBalance: walletDisplay
                    )),
          ),
          body: FutureBuilder<MyTeamLIstModel?>(
              future: _futureDataTeam,
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
                } else if (!snapshot.hasData ||
                    snapshot.data?.data.isEmpty == true) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xffF0F1F5),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 350),
                          child: Center(child: Text('No teams available')),
                        ),
                        // SizedBox(width: 150),
                        Positioned(
                          bottom: 110,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              // Other code...
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50),
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
                                          print("idddd: ${widget.cId}");
                                          print(
                                              "match name: ${widget.matchName}");
                                          print(
                                              'first team name:- ${widget.firstmatch}');
                                          print(
                                              'second team name:- ${widget.secMatch}');

                                          // print('this is useed in create team api ........check 2  ${contestData.data!.contestDetails!.matchId}');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateTeamScreen(
                                                isMyTeam: true,
                                                contestID: widget.cId,
                                                amount: widget.amount,
                                                currentuserids:
                                                    widget.currentUserTeamIds,
                                                Id: widget.Id,
                                                // Id: "${contestData.data.contestDetails.id}",
                                                matchName: widget.matchName,
                                                firstMatch:
                                                    "${widget.firstmatch}",
                                                secMatch: "${widget.secMatch}",
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 25,
                                          width: 136,
                                          // Width for the button's content
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/createteam.png",
                                                height: 18,
                                              ),
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
                  );
                } else {
                  final myTeamData = snapshot.data!.data;
                  return SizedBox(
                      child: Stack(children: [
                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      // padding: EdgeInsets.symmetric(horizontal: 15.w),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xffF0F1F5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: myTeamData.asMap().entries.map((entry) {
                                int index = entry.key;
                                var team = entry.value;
                                String lastFourDigits =
                                    team.id.substring(team.id.length - 4);
                                String teamLabel = 'T${index + 1}';
                                String appId =
                                    "BOSS $lastFourDigits ($teamLabel)";
                                bool isSelected =
                                    _selectedTeamIds.contains(team.id);
                                print("team ids from listview :-${team.id}");
                                // bool isAlreadyPlaying = widget.currentUserTeamIds!.contains(team.id);
                                // bool isAlreadyPlaying = widget.currentUserTeamIds?.contains(team.id) ?? false;
                                bool isAlreadyPlaying =
                                    currentUserTeamIds.contains(team.id);

                                print(
                                    "already selected team ids:- ${widget.currentUserTeamIds}");
                                print(
                                    "already playing teams :-$isAlreadyPlaying");
                                // bool isAlreadyPlaying = widget.currentUserTeamIds.contains(team.id);
                                return Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (isAlreadyPlaying) {
                                                // Show Snackbar message if the team is already playing
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Team ($teamLabel) is already joined!'),
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );
                                              } else {
                                                // Navigate to MyTeamEdit if the team is not already playing
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyTeamEdit(
                                                      teamId: team.id,
                                                      appId: appId,
                                                      matchName:
                                                          widget.matchName,
                                                    ),
                                                  ),
                                                );
                                              }
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => MyTeamEdit(
                                              //       teamId: team.id,
                                              //       appId: appId,
                                              //       matchName: widget.matchName,
                                              //     ),
                                              //   ),
                                              // );
                                            },
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04),
                                                  height: 150.h,
                                                  decoration: BoxDecoration(
                                                    color: isAlreadyPlaying
                                                        ? Colors.grey.shade400
                                                        : Colors
                                                            .white, // color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "BOSS $lastFourDigits ($teamLabel)",
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Image.network(
                                                                team.team1Logo ??
                                                                    'https://via.placeholder.com/26', // Placeholder URL
                                                                height: 30,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image.asset(
                                                                      'assets/remove.png',
                                                                      height:
                                                                          26); // Default image
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
                                                                team.team2Logo ??
                                                                    'https://via.placeholder.com/26', // Placeholder URL
                                                                height: 30,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image.asset(
                                                                      'assets/default_team_image.png',
                                                                      height:
                                                                          26); // Default image
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                      Divider(
                                                        height: 1,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.012),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // Column(
                                                            //   children: [
                                                            //     Normal2Text(
                                                            //       color: Colors.black,
                                                            //       text: "Points",
                                                            //     ),
                                                            //     Text(
                                                            //       totalpoints?.toString() ?? "0",
                                                            //       // "100",
                                                            //       style: TextStyle(
                                                            //         fontSize: MediaQuery.of(context).size.width * 0.04,
                                                            //         color: Colors.black,
                                                            //         fontWeight: FontWeight.w600,
                                                            //       ),
                                                            //     ),
                                                            //   ],
                                                            // ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.07,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.2,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.05,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                        child: Image
                                                                            .network(
                                                                          team.captain?.playerPhoto ??
                                                                              'https://via.placeholder.com/26',
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.04,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/dummy_player.png',
                                                                              height: MediaQuery.of(context).size.height * 0.04,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.02,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.2,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              const Color(0xffF0F1F5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.r),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "${team.captain?.playerName}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.03,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.2,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.05,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.1,
                                                                        child: Image
                                                                            .network(
                                                                          team.vicecaptain?.playerPhoto ??
                                                                              'https://via.placeholder.com/26',
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.04,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/dummy_player.png',
                                                                              height: MediaQuery.of(context).size.height * 0.04,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.02,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.2,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              const Color(0xffF0F1F5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.r),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "${team.vicecaptain?.playerName}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.03,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff010101)
                                                            .withOpacity(0.03),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(20.r),
                                                      bottomLeft:
                                                          Radius.circular(20.r),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Normal3Text(
                                                        color: Colors.black,
                                                        text:
                                                            "WK ${team.wicketkeeper}",
                                                      ),
                                                      Normal3Text(
                                                        color: Colors.black,
                                                        text:
                                                            "BAT ${team.batsman}",
                                                      ),
                                                      Normal3Text(
                                                        color: Colors.black,
                                                        text:
                                                            "AR ${team.allrounder}",
                                                      ),
                                                      Normal3Text(
                                                        color: Colors.black,
                                                        text:
                                                            "BOWL ${team.bowler}",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          child: InkWell(
                                            onTap: () {
                                              if (isAlreadyPlaying) {
                                                // Show Snackbar message if the team is already playing
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Team ($teamLabel) is already joined!'),
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  if (_selectedTeamIds
                                                      .contains(team.id)) {
                                                    _selectedTeamIds
                                                        .remove(team.id);
                                                  } else {
                                                    _selectedTeamIds
                                                        .add(team.id);
                                                  }
                                                  updateButtonState();
                                                });
                                              }
                                              // setState(() {
                                              //   if (_selectedTeamIds.contains(team.id)) {
                                              //     _selectedTeamIds.remove(team.id);
                                              //   } else {
                                              //     _selectedTeamIds.add(team.id);
                                              //   }
                                              //   updateButtonState();
                                              // });
                                            },
                                            child: Checkbox(
                                              activeColor:
                                                  const Color(0xff1D1459),
                                              checkColor: Colors.white,
                                              value: isSelected,
                                              // onChanged: (bool? value) {
                                              onChanged: isAlreadyPlaying
                                                  ? null
                                                  : (bool? value) {
                                                      setState(() {
                                                        if (value ?? false) {
                                                          _selectedTeamIds
                                                              .add(team.id);
                                                        } else {
                                                          _selectedTeamIds
                                                              .remove(team.id);
                                                        }
                                                        updateButtonState();
                                                      });
                                                    },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 90,
                            ),
                            // SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        height: 57.h,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 33.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _isButtonEnabled
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (_isButtonEnabled && !_isLoading) {
                                    debugPrint(
                                        "Join button tapped with selected team ids: $_selectedTeamIds");
                                    joinContest();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Center(
                                          child: Text('Select Team First'),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                // child: Center(
                                //   child: _isLoading
                                //       ? const CircularProgressIndicator(strokeWidth: 1,
                                //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                //   )
                                //       :const Text(
                                //     "Join",
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 16, // Set a small width
                                          height: 16, // Set a small height
                                          child: CircularProgressIndicator(
                                            strokeWidth:
                                                2, // Adjust the thickness of the indicator
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          "Join",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 50,
                    //   left: 0,
                    //   right: 0,
                    //   child: Column(
                    //     children: [
                    //       // Other code...
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 30),
                    //         child: Center(
                    //           child: Container(
                    //             height: 42,
                    //             width: 278,
                    //             // Set a fixed width or a responsive width as needed
                    //             padding: const EdgeInsets.symmetric(horizontal: 10),
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                   width: 0.5, color: Colors.grey.shade400),
                    //               borderRadius: BorderRadius.circular(22),
                    //               color: Colors.white,
                    //             ),
                    //             child: Center(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   print(
                    //                       "This is used in create team API: ${widget.Id}");
                    //                   print(
                    //                       "idddd: ${widget.cId}");
                    //                   print("match name: ${widget.matchName}");
                    //                   print('first team name:- ${widget.firstmatch}');
                    //                   print('second team name:- ${widget.secMatch}');
                    //
                    //                   // print('this is useed in create team api ........check 2  ${contestData.data!.contestDetails!.matchId}');
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           CreateTeamScreen(
                    //                             isMyTeam:true,
                    //                             contestID: widget.cId,
                    //                             amount:widget.amount,
                    //                             currentuserids: widget.currentUserTeamIds,
                    //                             Id: widget.Id,
                    //                             // Id: "${contestData.data.contestDetails.id}",
                    //                             matchName: widget.matchName,
                    //                             firstMatch: "${widget.firstmatch}",
                    //                             secMatch: "${widget.secMatch}",
                    //                           ),
                    //                     ),
                    //                   );
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 25,
                    //                   width: 136,
                    //                   // Width for the button's content
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                     MainAxisAlignment.center,
                    //                     children: [
                    //                       Image.asset(
                    //                         "assets/createteam.png",
                    //                         height: 18,
                    //                       ),
                    //                       const SizedBox(width: 7),
                    //                       const Text(
                    //                         "Create Team",
                    //                         style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Colors.black,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ]));
                }
              })),
    );
  }
}


// Future<void> joinContest() async {
//   debugPrint("Join contest called:--------------------------");
//   print("team id is :- $_selectedTeamIds");
//   setState(() {
//     _isLoading = true; // Start loading
//   });
//   try {
//     String? token = await AppDB.appDB.getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token is null.'),
//         ),
//       );
//       setState(() {
//         _isLoading = false; // Stop loading
//       });
//       return;
//     }
//
//     var payload = jsonEncode({
//       'contest_id': widget.cId,
//       'myTeam_id': _selectedTeamIds,
//     });
//     double totalAmount = _selectedTeamIds.length * double.parse(widget.amount!);
//     final response = await http.post(
//       Uri.parse(
//           "https://batting-api-1.onrender.com/api/joinContest/joinContest"),
//       body: payload,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         "Authorization": token,
//       },
//     );
//     final balanceNotifier = Provider.of<BalanceNotifier>(context, listen: false);
//
//     if (response.statusCode == 200) {
//
//       // final responseData = jsonDecode(response.body);
//       // print('balance before update:------${widget.amount}');
//       //
//       // String newBalance = (double.parse(balanceNotifier.balance) - double.parse(widget.amount!)).toString();
//       // // Update the balance in the notifier
//       // print('balance after update:------$newBalance');
//       //
//       // balanceNotifier.updateBalance(newBalance);
//       // print('balance after update11111111:------$newBalance');
//       final responseData = jsonDecode(response.body);
//       print('Response data: $responseData');
//       // Access the BalanceNotifier with listen: false
//       if (responseData['success'] == false && responseData['message'] == "You Have Join already joined with Team") {
//         setState(() {
//           _isLoading = false; // Stop loading
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Center(child: Text('You have already joined with this team.')),
//           ),
//         );
//         return; // Exit the function early
//       }
//
//
//       // Update balance after joining contest
//       double currentBalance = double.parse(balanceNotifier.balance);
//       // double contestAmount = double.parse(widget.amount!);
//       // int newBalance = (currentBalance - contestAmount).toInt();
//       int newBalance = (currentBalance - totalAmount).toInt();
//       // Update the balance in the notifier
//       balanceNotifier.updateBalance(newBalance.toString());
//
//       setState(() {
//         _isLoading = false; // Stop loading after request completes
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Center(child: Text('Join Contest Added Successfully')),
//         ),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => IndVsSaScreens(
//               matchName: widget.matchName,
//               Id: widget.Id,
//               date: widget.date,
//               time: widget.time,
//             ),
//           ));
//     } else {
//       setState(() {
//         _isLoading = false; // Stop loading after request completes
//       });
//       await walletDisplay();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Center(
//                 child: Text(
//                   'You have insufficient balance in your wallet. Please add funds.',
//                   style: TextStyle(fontSize: 11),
//                 ))),
//       );
//       await walletDisplay();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => WalletScreen(balanceNotifier: balanceNotifier),
//           ));
//       print("Failed to join contest: ${response.body}");
//       await walletDisplay();
//     }
//   } catch (e) {
//     setState(() {
//       _isLoading = false; // Stop loading after request completes
//     });
//
//     print("Exception occurred: $e");
//   }
// }




// Future<WalletModel?> walletDisplay() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     if (response.statusCode == 200) {
//       debugPrint("Response Body: ${response.body}");
//       return WalletModel.fromJson(jsonDecode(response.body));
//     } else {
//       debugPrint('Failed to fetch wallet data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error fetching wallet data: $e');
//     return null;
//   }
// }
// AppBar(
//   elevation: 0,
//   leading: InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Icon(
//         Icons.keyboard_backspace,
//         color: Colors.white,
//         size: 30.sp,
//       )),
//   title: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       AppBarText(color: Colors.white, text: "${widget.matchName}"),
//       FutureBuilder<MyTeamLIstModel?>(
//         future:_futureDataTeam ,
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
//                         height: 90.h,
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
//                         height: 60.h,
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
//                         height: 60.h,
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
//                                   height: 38.h,
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
//                         height: 58.h,
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
//                                   size: 30.sp,
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
//                             height: 40.h,
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
//         height: 38.h,
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
//                       child:  Center( child:  Text('0', style: TextStyle(fontSize: 16.sp, color: Colors.white),)));
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
//     SizedBox(
//       width: 10.w,
//     )
//   ],
//   flexibleSpace: Container(
//     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     height: 120.h,
//     width: MediaQuery.of(context).size.width,
//     decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff1D1459), Color(0xff140B40)])),
//   ),
// ),