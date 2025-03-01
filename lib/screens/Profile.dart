import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../db/app_db.dart';
import '../model/ProfileDisplay.dart';
import '../model/RecentlyPlayedUserMatchModel.dart';
import '../model/WalletModel.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/appbartext.dart';
import '../widget/normal2.0.dart';
import '../widget/normaltext.dart';
import '../widget/profile_provider.dart';
import '../widget/recently_played_provider.dart';
import '../widget/small2.0.dart';
import '../widget/smalltext.dart';
import 'package:http/http.dart' as http;

import '../widget/walletprovider.dart';

class Profile extends StatefulWidget {
  final String name;
  final String? profilePhotoUrl;

  const Profile(
      {super.key,
      required this.name,
      this.profilePhotoUrl,
      String? profilePhoto});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // bool Isverified = true;

  // String? _profilePhotoUrl;
  // String name = '';
  // int? _winningAmount;
  // int? _totalMatches;
  // int? _totalcontest;
  // int? _totalWinContest;
  // int? _totalPoints;
  final bool _isProfileFetched =
      false; // Flag to check if profile data is fetched
  // int? _seriescount;

  // late Future<RecentlyPlayedUserMatchModel?> _futureData;
  // List RecentlyPlayed = [];
  //
  // Future<RecentlyPlayedUserMatchModel?> recentlyplayedmatch() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     debugPrint('Token $token');
  //     final response = await http.get(
  //       Uri.parse('https://batting-api-1.onrender.com/api/user/lastRecentlyMatchUser'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     print("status code :- ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       print('Recent Played response data : - ${response.body}');
  //       var data = RecentlyPlayedUserMatchModel.fromJson(jsonData);
  //       // setState(() {
  //       //   _totalPoints = data.data![0].totalPoints;
  //       //   print('total points is:- $_totalPoints');
  //       // });
  //       return data;
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
  void initState() {
    super.initState();
    // fetchProfileData();
    // recentlyplayedmatch();
    fetchProfile();
    _fetchDataRecentlyPlayed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false).fetchWalletData();
    });
    // _futureData = recentlyplayedmatch();
    //startTimer();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchProfileData();
  // }
  String currentBalance = "0";

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
  //       // print('response body:------ ${response.body}');
  //       return WalletModel.fromJson(jsonDecode(response.body));
  //     } else {
  //       print('Failed to fetch wallet data: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching wallet data: $e');
  //     return null;
  //   }
  // }
  Future<void> _fetchDataRecentlyPlayed() async {
    String? token = await AppDB.appDB.getToken();
    if (token != null) {
      Provider.of<RecentlyPlayedMatchProvider>(context, listen: false)
          .fetchRecentlyPlayedMatch(token);
    }
  }

  Future<void> fetchProfile() async {
    final token = await AppDB.appDB.getToken(); // Fetch token
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchProfileData(token!);
  }
  // Future<void> fetchProfileData() async {
  //   try {
  //     String? token = await AppDB.appDB.getToken();
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
  //       final data = ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
  //       setState(() {
  //         name = data.data?.name ?? '';
  //         _profilePhotoUrl = data.data?.profilePhoto ?? '';
  //         _totalMatches = data.totalMatches;
  //         _totalcontest = data.totalContest;
  //         _winningAmount = data.totalWinning;
  //         _totalWinContest = data.totalWinningContest;
  //         _isProfileFetched = true;
  //         _seriescount = data.series;
  //       });
  //     } else {
  //       debugPrint('Failed to fetch profile data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching profile data: $e');
  //   }
  // }

  // final Map<String, dynamic> lastplayedmatch = {
  //   "data": [
  //     {
  //       "date": "2024-09-22T00:00:00.000Z",
  //       // Add other fields as needed
  //     },
  //   ],
  // };

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final funds = walletProvider.walletData?.data.funds ?? 0;

    ScreenUtil.init(
      context,
      designSize: const Size(393, 852),
    );

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       leading: Container(),
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      //         height: 90.h,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             SizedBox(height: 50.h),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: Icon(
      //                     Icons.arrow_back,
      //                     color: Colors.white,
      //                     size: 24.sp,
      //                   ),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "Profile"),
      //                 SizedBox(width: 20.w),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // appBar: PreferredSize(
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
      //             colors: [Color(0xff140B40), Color(0xff140B40)],
      //             // colors: [Color(0xff1D1459), Color(0xff140B40)],
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
      //               AppBarText(color: Colors.white, text: "Profile"),
      //               Container(
      //                 width: 30,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(
        title: "Profile",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xffF0F1F5),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              //         Container(
              //   // height: 133, // Adjusted height to avoid overflow
              //          height: 133, // Adjusted height to avoid overflow
              //
              //          width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     image: const DecorationImage(
              //       image: AssetImage('assets/bg.png'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 15),
              //         child: SingleChildScrollView( // Wrap the content in a scroll view
              //           child: Container(
              //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              //             width: double.infinity,
              //             decoration: BoxDecoration(
              //               color: Colors.white.withOpacity(0.05),
              //               borderRadius: BorderRadius.circular(12.r),
              //               border: Border.all(color: Colors.grey.shade300, width: 0.5.w),
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Row(
              //                   children: [
              //                     SizedBox(
              //                       height: 50,
              //                       width: 50,
              //                       child:
              //                       ClipRRect(
              //                         borderRadius: BorderRadius.circular(25),
              //                         child:
              //                         // _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
              //                         //     ? Image.network(
              //                         //   _profilePhotoUrl!,
              //                         //   fit: BoxFit.cover,
              //                         //   errorBuilder: (context, error, stackTrace) {
              //                         //     // Show 'remove.png' image if there's an error loading the profile photo
              //                         //     return Image.asset(
              //                         //       'assets/remove.png',
              //                         //       fit: BoxFit.cover,
              //                         //     );
              //                         //   },
              //                         // )
              //                         profileProvider.profilePhotoUrl != null && profileProvider.profilePhotoUrl!.isNotEmpty
              //                             ? Image.network(
              //                           profileProvider.profilePhotoUrl!,
              //                           fit: BoxFit.cover,
              //                           errorBuilder: (context, error, stackTrace) {
              //                             // Show 'remove.png' image if there's an error loading the profile photo
              //                             return Image.asset(
              //                               'assets/remove.png',
              //                               fit: BoxFit.cover,
              //                             );
              //                           },
              //                         )
              //                             : Image.asset(
              //                           'assets/remove.png',
              //                           fit: BoxFit.cover,
              //                         ),
              //                       ),
              //                       // ClipRRect(
              //                       //   borderRadius: BorderRadius.circular(25),
              //                       //   child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
              //                       //       ? Image.network(
              //                       //     _profilePhotoUrl!,
              //                       //     fit: BoxFit.cover,
              //                       //   )
              //                       //       : Image.asset(
              //                       //     'assets/remove.png',
              //                       //     fit: BoxFit.cover,
              //                       //   ),
              //                       // ),
              //                     ),
              //                     SizedBox(width: 10.w),
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                     profileProvider.name ?? '',
              //                           // name,
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 20.sp,
              //                             letterSpacing: 0.2,
              //                             fontWeight: FontWeight.w500,
              //                           ),
              //                         ),
              //                         Text(
              //                           // "Total Wins : ₹${_winningAmount?.toString() ?? "0" }",
              //                           'Total Wins: ${profileProvider.winningAmount ?? 0}',
              //                           // "Total Wins: ₹3000",
              //                           style: TextStyle(
              //                             color: Colors.grey.shade200,
              //                             fontSize: 13.sp,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //                 Container(
              //                   height: 1.h,
              //                   width: MediaQuery.of(context).size.width,
              //                   color: Colors.grey.shade300,
              //                 ),
              //                 SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //                 Row(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   children: [
              //                     // Row(
              //                     //   children: [
              //                     //     Text(
              //                     //       "0 Followers",
              //                     //       style: TextStyle(
              //                     //         color: Colors.white,
              //                     //         fontSize: 15.sp,
              //                     //       ),
              //                     //     ),
              //                     //     SizedBox(width: 4.w),
              //                     //     Padding(
              //                     //       padding: EdgeInsets.only(top: 1.h),
              //                     //       child: Container(
              //                     //         height: 3.h,
              //                     //         width: 3.w,
              //                     //         decoration: BoxDecoration(
              //                     //           color: Colors.white,
              //                     //           borderRadius: BorderRadius.circular(1.5.r),
              //                     //         ),
              //                     //       ),
              //                     //     ),
              //                     //     SizedBox(width: 4.w),
              //                     //     Text(
              //                     //       "0 Following",
              //                     //       style: TextStyle(
              //                     //         color: Colors.white,
              //                     //         fontSize: 15.sp,
              //                     //       ),
              //                     //     ),
              //                     //   ],
              //                     // ),
              //                     // Padding(
              //                     //   padding: EdgeInsets.only(top: 1.h),
              //                     //   child: Container(
              //                     //     height: 25.h,
              //                     //     width: MediaQuery.of(context).size.width * 0.2,
              //                     //     decoration: BoxDecoration(
              //                     //       color: Colors.transparent.withOpacity(0.06),
              //                     //       borderRadius: BorderRadius.circular(20.r),
              //                     //     ),
              //                     //     child: Row(
              //                     //       mainAxisAlignment: MainAxisAlignment.center,
              //                     //       children: [
              //                     //         SizedBox(
              //                     //           height: 14.h,
              //                     //           width: 14.w,
              //                     //           child: Image.asset('assets/vec.png'),
              //                     //         ),
              //                     //         SizedBox(width: 5.w),
              //                     //         FutureBuilder<WalletModel?>(
              //                     //           future: walletDisplay(),
              //                     //           builder: (context, snapshot) {
              //                     //             if (snapshot.connectionState == ConnectionState.waiting) {
              //                     //               return SizedBox(
              //                     //                 height: 22.h,
              //                     //                 width: 22.w,
              //                     //                 child: Center(
              //                     //                   child: Text(
              //                     //                     '0',
              //                     //                     style: TextStyle(fontSize: 16.sp, color: Colors.white),
              //                     //                   ),
              //                     //                 ),
              //                     //               );
              //                     //             } else if (snapshot.hasError) {
              //                     //               return const Center(child: Text('Error fetching data'));
              //                     //             } else if (!snapshot.hasData || snapshot.data == null) {
              //                     //               return const Center(child: Text('No data available'));
              //                     //             } else {
              //                     //               WalletModel walletData = snapshot.data!;
              //                     //               currentBalance = walletData.data?.funds.toString() ?? "0";
              //                     //               return Text(
              //                     //                 "₹$currentBalance",
              //                     //                 overflow: TextOverflow.clip,
              //                     //                 style: TextStyle(
              //                     //                   color: Colors.white,
              //                     //                   fontSize: 16.sp,
              //                     //                   fontWeight: FontWeight.w600,
              //                     //                 ),
              //                     //               );
              //                     //             }
              //                     //           },
              //                     //         ),
              //                     //       ],
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                     Row(
              //                       mainAxisAlignment:
              //                       MainAxisAlignment.end,
              //                       children: [
              //
              //                         const SizedBox(
              //                           width: 5,
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsets.only(top: 3.h),
              //                           child: Container(
              //                             height: 25.h,
              //                             width: MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
              //                             decoration: BoxDecoration(
              //                               color: Colors.transparent.withOpacity(0.06),
              //                               borderRadius: BorderRadius.circular(20.r),
              //                             ),
              //                             child: Padding(
              //                               padding: const EdgeInsets.only(left: 8.0),
              //                               child: Row(
              //                                 crossAxisAlignment: CrossAxisAlignment.center,
              //                                 mainAxisAlignment: MainAxisAlignment.center,
              //                                 children: [
              //                                   SizedBox(
              //                                     height: 14.h,
              //                                     width: 14.w,
              //                                     child: Image.asset('assets/vec.png'),
              //                                   ),
              //                                   SizedBox(width: 15.w),
              //                                   // Flexible(
              //                                   //   child: FutureBuilder<WalletModel?>(
              //                                   //     // future: walletDisplay(),
              //                                   //     future: _isProfileFetched ? walletDisplay() : Future.value(null),
              //                                   //
              //                                   //     builder: (context, snapshot) {
              //                                   //       if (snapshot.connectionState == ConnectionState.waiting) {
              //                                   //         return SizedBox(
              //                                   //           height: 22.h,
              //                                   //           width: double.infinity, // Use double.infinity to take all available space
              //                                   //           child: Center(
              //                                   //             child: Text(
              //                                   //               '0',
              //                                   //               style: TextStyle(
              //                                   //                 fontSize: 16.sp,
              //                                   //                 color: Colors.white,
              //                                   //               ),
              //                                   //             ),
              //                                   //           ),
              //                                   //         );
              //                                   //       } else if (snapshot.hasError) {
              //                                   //         return const Center(child: Text('Error fetching data'));
              //                                   //       } else if (!snapshot.hasData || snapshot.data == null) {
              //                                   //         return  Center(child: Text('0',style: TextStyle(
              //                                   //           color: Colors.white,
              //                                   //           fontSize: 16.sp,
              //                                   //           fontWeight: FontWeight.w600,
              //                                   //         ),));
              //                                   //       } else {
              //                                   //         WalletModel walletData = snapshot.data!;
              //                                   //         currentBalance = walletData.data.funds.toString() ?? "0";
              //                                   //         return Center(
              //                                   //           child: Text(
              //                                   //             "₹$currentBalance",
              //                                   //             // Use ellipsis to handle overflow
              //                                   //             style: TextStyle(
              //                                   //               color: Colors.white,
              //                                   //               fontSize: 16.sp,
              //                                   //               fontWeight: FontWeight.w600,
              //                                   //             ),
              //                                   //           ),
              //                                   //         );
              //                                   //       }
              //                                   //     },
              //                                   //   ),
              //                                   // ),
              //                                   // walletProvider.isLoading
              //                                       // ?  Center(child: Padding(
              //                                       //   padding: const EdgeInsets.all(8.0),
              //                                       //   child: Container(
              //                                       //   height: 10,
              //                                       //   width: 10,
              //                                       //   child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)),
              //                                       // ))
              //                                       // : walletProvider.error != null
              //                                   //     ? const Center(
              //                                   //   child: const Text(
              //                                   //     // walletProvider.error!,
              //                                   //     '0',
              //                                   //     style: TextStyle(color: Colors.red, fontSize: 16),
              //                                   //   ),
              //                                   // )
              //                                   //     : walletProvider.walletData != null
              //                                   //     ?
              //                               Center(
              //                                     child: Column(
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                       children: [
              //                                         Flexible(
              //                                           child: Text(
              //                                             // "${walletProvider.walletData!.data!.funds!}",
              //                                             "₹${funds.toString()}",
              //
              //                                             // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //                                                                                       style: TextStyle(
              //                                                         color: Colors.white,
              //                                                         fontSize: 16.sp,
              //                                                         fontWeight: FontWeight.w600,
              //                                                       ),
              //                                           ),
              //                                         ),
              //                                         // Add more fields as needed
              //                                       ],
              //                                     ),
              //                                   )
              //                                   //     : const Center(
              //                                   //   child: Text("0"),
              //                                   // ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //               ],
              //             )
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Stack(
                children: [
                  Container(
                    height: 133,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 0.5.w),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child:
                                              profileProvider.profilePhotoUrl !=
                                                          null &&
                                                      profileProvider
                                                          .profilePhotoUrl!
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      profileProvider
                                                          .profilePhotoUrl!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          'assets/remove.png',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    )
                                                  : Image.asset(
                                                      'assets/remove.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profileProvider.name ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              letterSpacing: 0.2,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Total Wins: ${profileProvider.winningAmount ?? 0}',
                                            style: TextStyle(
                                              color: Colors.grey.shade200,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Container(
                                    height: 1.h,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.h),
                                        child: Container(
                                          height: 25.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.32,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.06),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 14.h,
                                                  width: 14.w,
                                                  child: Image.asset(
                                                      'assets/vec.png'),
                                                ),
                                                SizedBox(width: 15.w),
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "₹${funds.toString()}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Verification Badge
                  Positioned(
                    top: 10.h, // Position from top of the container
                    right: 19.w, // Adjust position from right
                    child: profileProvider.isVerifed ?? false
                        ?
                        // Container(
                        //   height: 20,
                        //   width: 20,
                        //   decoration: const BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: Colors.blue,
                        //   ),
                        //   child: const Icon(
                        //     Icons.check,
                        //     color: Colors.white,
                        //     size: 14,
                        //   ),
                        // )
                        const Icon(
                            Icons.verified_rounded,
                            color: Color(0xff140B40),
                          )
                        : const SizedBox(), // Empty if not verified
                  ),
                ],
              ),

              SizedBox(height: 15.h),
              NormalText(color: Colors.black, text: "Enter Champions Club"),
              SizedBox(height: 5.h),
              Container(
                height: 90.h,
                padding: EdgeInsets.all(10.w),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          'assets/trophy.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Normal2Text(
                              color: Colors.black,
                              text: "Enter the Champions Club"),
                          Flexible(
                            child: Text(
                              "Earn DreamCoins to get exclusive\nbenefits",
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 55.h,
                      width: 55.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff140B40).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/arrow.png',
                          height: 1.h,
                          color: const Color(0xff140B40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              NormalText(color: Colors.black, text: "Career Stats"),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.all(15.w),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 2.h),
                            height: 62.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F1F5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                    color: Colors.grey, text: "Contests Win"),
                                // NormalText(color: Colors.black, text: _totalWinContest?.toString() ?? '0'),
                                NormalText(
                                    color: Colors.black,
                                    text:
                                        '${profileProvider.totalWinContest ?? 0}'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 2.h),
                            height: 62.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F1F5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                    color: Colors.grey, text: "Total Contests"),
                                NormalText(
                                    color: Colors.black,
                                    text:
                                        '${profileProvider.totalContest ?? 0}'),
                                // NormalText(color: Colors.black, text: _totalcontest?.toString() ?? '0'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 2.h),
                            height: 62.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F1F5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(color: Colors.grey, text: "Matches"),
                                // NormalText(color: Colors.black, text: _totalMatches?.toString() ?? '0'),
                                NormalText(
                                    color: Colors.black,
                                    text:
                                        '${profileProvider.totalMatches ?? 0}'),

                                // SmallText(color: Colors.grey, text: "Series"),
                                // NormalText(color: Colors.black, text: "129"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 2.h),
                            height: 62.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F1F5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(color: Colors.grey, text: "Series"),
                                // NormalText(color: Colors.black, text: _seriescount?.toString() ?? "0"),
                                NormalText(
                                    color: Colors.black,
                                    text:
                                        '${profileProvider.seriesCount ?? 0}'),

                                // NormalText(color: Colors.black, text: "129"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              NormalText(color: Colors.black, text: "Recently Played"),
              SizedBox(height: 5.h),

              //         FutureBuilder<RecentlyPlayedUserMatchModel?>(
              //           future: _isProfileFetched ? recentlyplayedmatch() : Future.value(null),
              //
              //           // future:recentlyplayedmatch(),
              //           builder: (context, snapshot) {
              //             if (snapshot.connectionState == ConnectionState.waiting) {
              //               return const Center(child: CircularProgressIndicator());
              //             } else if (snapshot.hasError) {
              //               return const Center(child: Text('Error fetching data'));
              //             }  else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
              //
              //               // } else if (!snapshot.hasData || snapshot.data == null) {
              //               return  Center(child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   const SizedBox(height: 30),
              //                   Text('User not played any matches',style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 16.sp,
              //                     fontWeight: FontWeight.w600,
              //                   )),
              //                 ],
              //               ));
              //             }
              //             // else if (!snapshot.hasData || snapshot.data == null) {
              //             //   return const Center(child: Text('No data available'));
              //             // }
              //             else {
              //               RecentlyPlayedUserMatchModel lastpalyedmatch = snapshot.data!;
              //
              //               DateTime? matchDate;
              //               try {
              //                 matchDate = DateTime.parse(lastpalyedmatch.data![0].date.toString() ?? '');
              //               } catch (e) {
              //                 matchDate = null;
              //               }
              //
              // // Define DateFormat
              //               final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
              //
              // // If matchDate is successfully parsed, format it
              //               String formattedDate = matchDate != null ? dateFormatter.format(matchDate) : '';
              //
              // // Adjust match time
              //           //    String matchTime = adjustMatchTime(lastpalyedmatch!.data![0].time ?? ''.toString());
              //
              // // Calculate days remaining
              //             //  String daysRemaining = matchDate != null ? calculateDaysRemaining(matchDate) : '';
              //
              //              return Container(
              //                 padding: EdgeInsets.all(10.w),
              //                 height: 190.h,
              //                 width: MediaQuery.of(context).size.width,
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(20.r),
              //                 ),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Padding(
              //                       padding: const EdgeInsets.only(left: 10),
              //                       child: Row(
              //                         children: [
              //                           Normal2Text(color: Colors.black,
              //                               text: formattedDate ),
              //                           SizedBox(width: 10.w),
              //                           Small2Text(color: Colors.grey, text: "Cricket"),
              //                         ],
              //                       ),
              //                     ),
              //                     SizedBox(height: 6.h),
              //                     Container(
              //                       height: 0.8.h,
              //                       width: MediaQuery.of(context).size.width,
              //                       color: Colors.grey.shade300,
              //                     ),
              //                     SizedBox(height: 10.h),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Column(
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Container(
              //                               padding: EdgeInsets.only(right: 5.w),
              //                               height: 20.h,
              //                               width: MediaQuery.of(context).size.width * 0.8,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                 children: [
              //                                   Row(
              //                                     children: [
              //                                       SizedBox(
              //                                         width: MediaQuery.of(context).size.width * 0.1,
              //                                         height:30.h,
              //                                         child: Image.network(
              //                                           '${lastpalyedmatch.data![0].team1Details!.logo}'
              //                                         )
              //                                       ),
              //                                       SizedBox(width: 8.w),
              //                                       NormalText(color: Colors.black, text: "${lastpalyedmatch.data![0].team1Details!.shortName}"),
              //                                     ],
              //                                   ),
              //                                   Row(
              //                                     children: [
              //                                       Normal2Text(color: Colors.black, text:
              //                                       lastpalyedmatch.data![0].teamScore?.team1?.score == null ||
              //                                           lastpalyedmatch.data![0].teamScore!.team1!.score == "N/A"
              //                                           ? "0/0"
              //                                           : "${lastpalyedmatch.data![0].teamScore!.team1!.score}",
              //                                       // "${lastpalyedmatch.data![0].teamScore!.team1!.score}"
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             SizedBox(height: 10.h),
              //                             Container(
              //                               padding: EdgeInsets.only(right: 5.w),
              //                               height: 26.h,
              //                               width: MediaQuery.of(context).size.width * 0.8,
              //                               child: Row(
              //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                 children: [
              //                                   Row(
              //                                     children: [
              //                                       SizedBox(
              //                                         width: MediaQuery.of(context).size.width * 0.1,
              //                                         height: 30.h,
              //                                         child: Image.network(
              //                                           '${lastpalyedmatch.data![0].team2Details!.logo}'
              //                                         )
              //                                       ),
              //                                       SizedBox(width: 8.w),
              //                                       NormalText(color: Colors.black, text: "${lastpalyedmatch.data![0].team2Details!.shortName}"),
              //                                     ],
              //                                   ),
              //                                   Row(
              //                                     children: [
              //                                       Normal2Text(color: Colors.black, text:
              //                                       lastpalyedmatch.data![0].teamScore?.team2?.score == null ||
              //                                           lastpalyedmatch.data![0].teamScore!.team2!.score == "N/A"
              //                                           ? "0/0"
              //                                           : "${lastpalyedmatch.data![0].teamScore!.team2!.score}",
              //                                         // "${lastpalyedmatch.data![0].teamScore!.team2!.score}"
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             SizedBox(height: 13.4.h),
              //                             // SizedBox(width: 30),
              //                             // Small2Text(color: Colors.grey, text: "India beat South Africa by 5 wickets"),
              //                             Small2Text(color: Colors.grey, text: lastpalyedmatch.data![0].matchResult!),
              //
              //                             SizedBox(height: 7.h),
              //                             Container(
              //                               height: 0.8.h,
              //                               width: MediaQuery.of(context).size.width / 1.2,
              //                               color: Colors.grey.shade300,
              //                             ),
              //                             SizedBox(height: 5.h),
              //                             Text(
              //                               "Teams Highest points: ${lastpalyedmatch.data![0].totalPoints!.toStringAsFixed(0)}",
              //                               // "Teams Highest points: ${lastpalyedmatch.data![0].totalPoints! % 1 == 0 ? lastpalyedmatch.data![0].totalPoints!.toStringAsFixed(0) : lastpalyedmatch.data![0].totalPoints!.toStringAsFixed(1)}",
              //                               // "Teams Highest points: ${lastpalyedmatch.data![0].totalPoints!}",
              //                               style: TextStyle(
              //                                 color: Colors.black,
              //                                 fontWeight: FontWeight.w500,
              //                                 fontSize: 13.sp,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             }
              //           },
              //         ),
              Consumer<RecentlyPlayedMatchProvider>(
                // future:recentlyplayedmatch(),
                builder: (context, provider, child) {
                  // if (provider.isLoading) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  // // else if (provider.error != null || provider.error == '404') {
                  // //   // return Center(child: Text('Error: ${provider.error}'));
                  // //   // return const Center(child: Text('User has not played any matches'));
                  // //   return  Center(child: Column(
                  // //                   mainAxisAlignment: MainAxisAlignment.center,
                  // //                   children: [
                  // //                     const SizedBox(height: 30),
                  // //                     Text('User not played any matches',style: TextStyle(
                  // //                       color: Colors.black,
                  // //                       fontSize: 16.sp,
                  // //                       fontWeight: FontWeight.w600,
                  // //                     )),
                  // //                   ],
                  // //                 ));
                  // // }
                  // else if (provider.error != null) {
                  //   if (provider.error!.contains('404')) {
                  //     // Show "User has not played any matches" message
                  //     return Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const SizedBox(height: 30),
                  //           Text(
                  //             'No completed matches found for the user',
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 16.sp,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   } else {
                  //     // Show error message for other errors
                  //     return Center(
                  //       child: Text(
                  //         'Error: ${provider.error}',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 14.sp,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     );
                  //   }
                  // }
                  //
                  //
                  // else
                  if (provider.recentMatchData == null ||
                      provider.recentMatchData!.data == null ||
                      provider.recentMatchData!.data!.isEmpty) {
                    // return const Center(child: Text('User has not played any matches'));
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text('User not played any matches',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ));
                  }
                  // else if (!snapshot.hasData || snapshot.data == null) {
                  //   return const Center(child: Text('No data available'));
                  // }
                  else {
                    final lastpalyedmatch = provider.recentMatchData!.data![0];

                    DateTime? matchDate;
                    try {
                      matchDate =
                          DateTime.parse(lastpalyedmatch.date.toString());
                    } catch (e) {
                      matchDate = null;
                    }

                    // Define DateFormat
                    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

                    // If matchDate is successfully parsed, format it
                    String formattedDate = matchDate != null
                        ? dateFormatter.format(matchDate)
                        : '';

                    // Adjust match time
                    //    String matchTime = adjustMatchTime(lastpalyedmatch!.data![0].time ?? ''.toString());

                    // Calculate days remaining
                    //  String daysRemaining = matchDate != null ? calculateDaysRemaining(matchDate) : '';

                    return Container(
                      padding: EdgeInsets.all(10.w),
                      height: 190.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Normal2Text(
                                    color: Colors.black, text: formattedDate),
                                SizedBox(width: 10.w),
                                Small2Text(color: Colors.grey, text: "Cricket"),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 0.8.h,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 5.w),
                                    height: 20.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                height: 30.h,
                                                child: Image.network(
                                                    '${lastpalyedmatch.team1Details!.logo}')),
                                            SizedBox(width: 8.w),
                                            NormalText(
                                                color: Colors.black,
                                                text:
                                                    "${lastpalyedmatch.team1Details!.shortName}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Normal2Text(
                                              color: Colors.black,
                                              text: lastpalyedmatch.teamScore
                                                              ?.team1?.score ==
                                                          null ||
                                                      lastpalyedmatch.teamScore!
                                                              .team1!.score ==
                                                          "N/A"
                                                  ? "0/0"
                                                  : "${lastpalyedmatch.teamScore!.team1!.score}",
                                              // "${lastpalyedmatch.data![0].teamScore!.team1!.score}"
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: EdgeInsets.only(right: 5.w),
                                    height: 26.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                height: 30.h,
                                                child: Image.network(
                                                    '${lastpalyedmatch.team2Details!.logo}')),
                                            SizedBox(width: 8.w),
                                            NormalText(
                                                color: Colors.black,
                                                text:
                                                    "${lastpalyedmatch.team2Details!.shortName}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Normal2Text(
                                              color: Colors.black,
                                              text: lastpalyedmatch.teamScore
                                                              ?.team2?.score ==
                                                          null ||
                                                      lastpalyedmatch.teamScore!
                                                              .team2!.score ==
                                                          "N/A"
                                                  ? "0/0"
                                                  : "${lastpalyedmatch.teamScore!.team2!.score}",
                                              // "${lastpalyedmatch.data![0].teamScore!.team2!.score}"
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 13.4.h),
                                  // SizedBox(width: 30),
                                  // Small2Text(color: Colors.grey, text: "India beat South Africa by 5 wickets"),
                                  Small2Text(
                                      color: Colors.grey,
                                      text: lastpalyedmatch.matchResult!),

                                  SizedBox(height: 7.h),
                                  Container(
                                    height: 0.8.h,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Teams Highest points: ${lastpalyedmatch.totalPoints!.toStringAsFixed(0)}",
                                    // "Teams Highest points: ${lastpalyedmatch.data![0].totalPoints! % 1 == 0 ? lastpalyedmatch.data![0].totalPoints!.toStringAsFixed(0) : lastpalyedmatch.data![0].totalPoints!.toStringAsFixed(1)}",
                                    // "Teams Highest points: ${lastpalyedmatch.data![0].totalPoints!}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
