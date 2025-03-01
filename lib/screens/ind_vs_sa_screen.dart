import 'dart:async';
import 'dart:convert';
import 'package:batting_app/screens/bnb.dart';
import 'package:batting_app/screens/contestScrenn.dart';
import 'package:batting_app/screens/joincontest_list.dart';
import 'package:batting_app/screens/myteamlist.dart';
import 'package:batting_app/widget/appbar_for_team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../db/app_db.dart';
import '../model/ContestModel.dart';
import '../model/WalletModel.dart';
import 'package:http/http.dart' as http;

class IndVsSaScreens extends StatefulWidget {
  final String? Id;
  final String? matchName;
  final String? firstMatch;
  final String? secMatch;
  // New parameter to check the source
  DateTime? date;
  String? time;
  final bool IsCreateTeamScreen;
  final int? defaultTabIndex; // New parameter
  IndVsSaScreens({
    super.key,
    this.Id,
    this.IsCreateTeamScreen = false,
    this.firstMatch,
    this.secMatch,
    this.matchName,
    this.date,
    this.time,
    this.defaultTabIndex, // Default to false
  });
  late DateTime matchDateTime;
  late Duration remainingTime;
  @override
  State<IndVsSaScreens> createState() => _IndVsSaScreensState();
}

class _IndVsSaScreensState extends State<IndVsSaScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String currentBalance = "0";
  String fundsUtilizedBalance = "0";
  DateTime? matchDateTime;
  // late Duration remainingTime;
  late Duration remainingTime =
      Duration.zero; // Initialize with a default value
  late Future<ContestModlel?> _futureData;
  late Duration _timeRemaining;

  Timer? _timer;
  List paymentImage = ['assets/paybg.png', 'assets/gbg.png', 'assets/ppbg.png'];
  List paymentText = [
    "PhonePe UPI Lite",
    "Google Pay UPI",
    "Amazon Pay UPI",
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this, initialIndex: widget.defaultTabIndex ?? 0);
    _futureData = contestDisplay();

    // Update remaining time every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        remainingTime = matchDateTime!.difference(DateTime.now());
        // print('remaining timing:- $remainingTime');
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 4, vsync: this,initialIndex: widget.defaultTabIndex ?? 0, );
  //   _futureData = contestDisplay();
  // }

  // String formatRemainingTime(Duration duration) {
  //   final hours = duration.inHours;
  //   final minutes = duration.inMinutes % 60;
  //   return "${hours}h ${minutes}m left";
  // }

  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m left";
  }
  // Future<ContestModlel?> contestDisplay() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/match/displaycontests?matchId=${widget.Id}'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     print(widget.Id);
  //     if (response.statusCode == 200) {
  //       final data = ContestModlel.fromJson(jsonDecode(response.body));
  //       matchDateTime = DateTime.parse(data.data[0].date.toString())
  //           .add(Duration(
  //           hours: int.parse(data.data[0].time.split(':')[0]),
  //           minutes: int.parse(data.data[0].time.split(':')[1])));
  //       remainingTime = matchDateTime.difference(DateTime.now());
  //       print(remainingTime);
  //       print(matchDateTime);
  //       print('remaining time is.....................$remainingTime');
  //
  //       return data;
  //     } else {
  //       debugPrint('Failed to fetch contest data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching contest data: $e');
  //     return null;
  //   }
  // }

  // Future<ContestModlel?> contestDisplay() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/match/displaycontests?matchId=${widget.Id}'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     print("match id is :-  asdasdAsdaf .........${widget.Id}");
  //     if (response.statusCode == 200) {
  //       final data = ContestModlel.fromJson(jsonDecode(response.body));
  //       matchDateTime = DateTime.parse(data.data[0].date.toString())
  //           .add(Duration(
  //           hours: int.parse(data.data[0].time.split(':')[0]),
  //           minutes: int.parse(data.data[0].time.split(':')[1])));
  //       setState(() {
  //         remainingTime = matchDateTime.difference(DateTime.now());
  //       });
  //       print('remaining time is.....................$remainingTime');
  //       return data;
  //     } else {
  //       debugPrint('Failed to fetch contest data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching contest data: $e');
  //     return null;
  //   }
  // }
  Future<ContestModlel?> contestDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/match/displaycontests?matchId=${widget.Id}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      print("match id is :- ${widget.Id}");
      if (response.statusCode == 200) {
        final data = ContestModlel.fromJson(jsonDecode(response.body));

        // Ensure data integrity
        if (data.data.isEmpty) {
          debugPrint('Invalid data from API');
          return null;
        }

        // Parse date and time from response
        DateTime apiDate = DateTime.parse(data.data[0].date.toString());
        try {
          List<String> timeParts = data.data[0].time.split(':');
          int matchHour = int.parse(timeParts[0]);
          int matchMinute = int.parse(timeParts[1]);

          // Create a combined UTC DateTime object for the match
          matchDateTime = DateTime.utc(
            apiDate.year,
            apiDate.month,
            apiDate.day,
            matchHour,
            matchMinute,
          );

          // Debug log: match time in UTC
          print("Match DateTime (UTC): $matchDateTime");

          // Convert match time to IST (UTC+5:30)
          // matchDateTime = matchDateTime.add(Duration(hours: 5, minutes: 30));

          // Debug log: match time in IST
          print("Match DateTime (IST): $matchDateTime");

          // Get current time in UTC and convert it to IST (UTC+5:30)
          DateTime currentTimeUTC = DateTime.now().toUtc();
          DateTime currentTimeIST =
              currentTimeUTC.add(const Duration(hours: 5, minutes: 30));

          // Debug log: current time in IST
          print("Current DateTime (IST): $currentTimeIST");

          // Calculate remaining time in IST
          setState(() {
            remainingTime = matchDateTime!.difference(currentTimeIST);
          });

          // Debug log: log the raw remaining time difference
          print("Raw remaining time: $remainingTime");

          // Calculate the hours and minutes from the remaining duration
          final hours = remainingTime.inHours;
          final minutes = remainingTime.inMinutes % 60;

          // Print the formatted remaining time
          print("Formatted remaining time: ${hours}h ${minutes}m left");

          return data;
        } catch (e) {
          debugPrint('Error parsing time: $e');
          return null;
        }
      } else {
        debugPrint('Failed to fetch contest data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching contest data: $e');
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

  @override
  Widget build(BuildContext context) {
    debugPrint("this is id from home ::${widget.Id}");
    print(
        'AppBar is building with matchName: ${formatRemainingTime(remainingTime)}');
    return
        // PopScope(
        // canPop: false,
        // onPopInvokedWithResult: (didPop, result) async {
        //   // Navigate to the login page when the back button is pressed
        //   // Navigator.of(context).pushAndRemoveUntil(
        //   //   MaterialPageRoute(builder: (context) => MyHomePage()), // Replace with your actual login page
        //   //       (Route<dynamic> route) => false,
        //   // );
        //   if(widget.IsCreateTeamScreen)
        //   {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const MyHomePage()),
        //     );
        //   }
        //   else{
        //     Navigator.pop(context);
        //
        //   }
        //   // Navigator.pop(context);
        //
        //   // Return `true` if you want to indicate that the pop was handled manually.
        //   // return true;
        // },
        PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await Future.microtask(() {
          // Check if the navigator can pop before trying to pop
          if (widget.IsCreateTeamScreen) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              print("No route to pop!");
            }
          }
        });
        return; // Prevent the default back navigation
      },
      // WillPopScope(
      //   onWillPop: () async {
      //     if (widget.IsCreateTeamScreen) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => const MyHomePage()),
      //       );
      //       return false; // Prevent default back navigation
      //     }
      //     return true; // Allow back navigation
      //   },
      child: Scaffold(
          backgroundColor: const Color(0xffF0F1F5),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(63.0),
            child: ClipRRect(
              child: CustomAppBar(
                title: widget.matchName ?? "",
                // subtitle: formatRemainingTime(widget.remainingTime),

                subtitle: formatRemainingTime(remainingTime),
                onBackPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                  // );
                  // if (widget.cameFromCreateTeam) {
                  // Go back to create_team.dart
                  // } else {
                  //   Navigator.push(context,MaterialPageRoute(builder: (context)=> MyHomePage()) ); // Navigate to home screen
                  // }
                  // if(widget.IsCreateTeamScreen)
                  // {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const MyHomePage()),
                  //     );
                  // }
                  // else{
                  //   Navigator.pop(context);
                  //
                  // }
                  await Future.microtask(() {
                    // Check if the navigator can pop before trying to pop
                    if (widget.IsCreateTeamScreen) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    } else {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                        print('Navigaton working');
                      } else {
                        print("No route to pop!");
                      }
                    }
                  });
                },
                // onBackPressed: () => Navigator.pop(context),
                // fetchWalletBalance: walletDisplay
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                height: 48.h,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: TabBar(
                  indicatorColor: const Color(0xff140B40),
                  labelColor: const Color(0xff140B40),
                  controller: _tabController,
                  //isScrollable: true,
                  indicatorPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0), // Adjust the indicator padding
                  labelPadding: const EdgeInsets.symmetric(
                      horizontal:
                          20.0), // Adjust the space between labels (tabs)
                  tabs: const [
                    Tab(text: 'Contests'),
                    Tab(text: 'My Contests'),
                    Tab(text: 'My Teams'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Contestscrenn(
                      time: formatRemainingTime(remainingTime),
                      Id: "${widget.Id}",
                      MatchName: "${widget.matchName}",
                      firstMatch: "${widget.firstMatch}",
                      secMatch: "${widget.secMatch}",
                    ),
                    JoincontestListScreen(
                      Id: "${widget.Id}",
                      matchName: "${widget.matchName}",
                      time: formatRemainingTime(remainingTime),
                      // Id: "${widget.Id}",
                    ),
                    Myteamlist(
                      MatchID: "${widget.Id}",
                      matchName: '${widget.matchName}',
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }
}



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


// child: AppBar(
//   elevation: 0,
//   leading: InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child:  Icon(
//         Icons.keyboard_backspace,
//         color: Colors.white,
//         size: 30.sp,
//       )),
//   title: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       AppBarText(color: Colors.white, text: "${widget.matchName}"),
//       FutureBuilder<ContestModlel?>(
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
//         // Within the `FirstRoute` widget:
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const WalletScreen()),
//           );
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
//              SizedBox(width: 4.w),
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
//              SizedBox(width: 4.w),
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
//     padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
//     height: 120.h,
//     width: MediaQuery.of(context).size.width,
//     decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff1D1459), Color(0xff140B40)])),
//   ),
// ),


// await showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return  Container(
//           width: MediaQuery
//               .of(context)
//               .size
//               .width,
//           decoration:  BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(28.r),
//                 topLeft: Radius.circular(28.r)),
//             color: Colors.white,
//           ),
//           child: Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 98.h,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(28.r),
//                         topLeft: Radius.circular(28.r)),
//                     gradient: LinearGradient(
//                         begin: Alignment.bottomRight,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xff1D1459)
//                               .withOpacity(0.4),
//                           Color(0xff1D1459)
//                               .withOpacity(0.1),
//                         ])),
//                 child:  Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 15.r),
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     mainAxisAlignment:
//                     MainAxisAlignment.center,
//                     children: [
//                       Text("Current Balance"),
//                       FutureBuilder<WalletModel?>(
//                         future: walletDisplay(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return SizedBox(
//                               height: 25.h,
//                               width: 30.w,
//                               child:  Center(
//                                   child: Text('0', style: TextStyle(fontSize: 25.sp, color: Colors.black),)
//                               ),
//                             );
//                           } else if (snapshot.hasError) {
//                             return const Center(child: Text('Error fetching data'));
//                           } else if (!snapshot.hasData || snapshot.data == null) {
//                             return const Center(child: Text('No data available'));
//                           } else {
//                             WalletModel walletData = snapshot.data!;
//                             currentBalance = walletData.data?.funds.toString() ?? "0";
//                             fundsUtilizedBalance = walletData.data?.fundsUtilized.toString() ?? "0"; // Fetch utilized balance
//                             return Text(
//                               '₹ $currentBalance',
//                               style: TextStyle(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//                SizedBox(
//                 height: 5.h,
//               ),
//               Container(
//                 width: double.infinity,
//                 height: 62.h,
//                 decoration:  BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28.r),
//                       topLeft: Radius.circular(28.r)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 15.r),
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text("Unutilized Balance"),
//                           InkWell(
//                               onTap: () {},
//                               child: Icon(
//                                 Icons
//                                     .info_outline_rounded,
//                                 color: Colors.grey,
//                               ))
//                         ],
//                       ),
//                       Text(
//                         '₹ $fundsUtilizedBalance',
//                         style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight:
//                             FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Divider(),
//               Container(
//                 width: double.infinity,
//                 height: 62.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28.r),
//                       topLeft: Radius.circular(28.r)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 15.r),
//                   child: Row(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.center,
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         mainAxisAlignment:
//                         MainAxisAlignment
//                             .spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text("Winnings"),
//                               InkWell(
//                                   onTap: () {},
//                                   child: Icon(
//                                     Icons
//                                         .info_outline_rounded,
//                                     color: Colors.grey,
//                                   ))
//                             ],
//                           ),
//                           Text(
//                             '₹ 0.00',
//                             style: TextStyle(
//                                 fontSize: 15.sp,
//                                 fontWeight:
//                                 FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       InkWell(
//                         onTap: (){
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     AddCashScreen(),
//                               ));
//                         },
//                         child: Container(
//                           height: 45.h,
//                           width: 110.w,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.circular(
//                                   8.r),
//                               color: Color(0xff1D1459)),
//                           child:  Center(
//                             child: Text(
//                               "Withdraw",
//                               style: TextStyle(
//                                   fontWeight:
//                                   FontWeight.w800,
//                                   fontSize: 16.sp,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(),
//               Container(
//                 height: 60.h,
//                 width: double.infinity,
//                 decoration: BoxDecoration(),
//                 child:  Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 15.r),
//                   child: Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment:
//                     CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "My Transactions",
//                         style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight:
//                             FontWeight.w600),
//                       ),
//                       InkWell(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                         },
//                         child: Icon(
//                           Icons
//                               .arrow_forward_ios_outlined,
//                           size: 35.sp,
//                           color: Colors.black,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(),
//               Spacer(),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 15.r),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               AddCashScreen(),
//                         ));
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 45.h,
//                     decoration: BoxDecoration(
//                         borderRadius:
//                         BorderRadius.circular(8.r),
//                         color: Color(0xff1D1459)),
//                     child: Center(
//                       child: Text(
//                         "Add Cash",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16.sp),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30.h,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   },
// );