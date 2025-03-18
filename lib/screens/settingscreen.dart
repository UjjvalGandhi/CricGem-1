import 'dart:convert';
import 'dart:ui';
import 'package:batting_app/screens/chat_screen.dart';
import 'package:batting_app/screens/cheat_inside.dart';
import 'package:batting_app/screens/rewardsscreen.dart';
import 'package:batting_app/screens/walletScreen.dart';
import 'package:batting_app/screens/winnerScreens.dart';
import 'package:batting_app/services/send_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_db.dart';
import '../model/ProfileDisplay.dart';
import '../model/WalletModel.dart';
import '../widget/balance_notifire.dart';
import '../widget/normaltext.dart';
import '../widget/smalltext.dart';
import 'Auth/forgotpassword.dart';
import 'Auth/login.dart';
import 'Profile.dart';
import 'about_us.dart';

import 'bnb.dart';
import 'communityscreen.dart';
import 'documents_upload.dart';
import 'edit_profile.dart';
import 'help&support.dart';
import 'invitefriend.dart';
import 'notification_view.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int? _winningamount;
  String? _profilePhotoUrl;
  String name = ''; // Variable to hold the fetched name
  bool _isProfileFetched = false; // Flag to check if profile data is fetched
  bool? _isVerify;
  @override
  void initState() {
    super.initState();
    // Call the function to fetch profile data when the screen initializes
    // fetchProfileData();
    // walletDisplay();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchProfileData(),
      walletDisplay(),
    ]);
  }

  // String currentBalance = "0";

  Future<WalletModel?> walletDisplay() async {
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
        return WalletModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch wallet data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
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
          name = "${data.data!.name}";
          _profilePhotoUrl = '${data.data!.profilePhoto}';
          _winningamount = data.totalWinning;
          _isProfileFetched = true;
          _isVerify = data.isVerify;
        });
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true) {
      // If the result is true, fetch the updated profile data
      fetchProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceNotifier =
        Provider.of<BalanceNotifier>(context); // Access BalanceNotifier

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Navigate to HomeScreens when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
        return; // Prevent the default back navigation
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xffF0F1F5),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Profile(
                //           name: name,
                //           profilePhoto: _profilePhotoUrl,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     height: 133,
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         image: const DecorationImage(
                //             image: AssetImage('assets/bg.png'),
                //             fit: BoxFit.cover)),
                //     child: BackdropFilter(
                //       filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                //       child: Center(
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15),
                //           child: Container(
                //             padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                //             height: 123,
                //             width: double.infinity,
                //             decoration: BoxDecoration(
                //               color: Colors.white.withOpacity(0.05),
                //               borderRadius: BorderRadius.circular(12),
                //               border: Border.all(color: Colors.grey.shade300, width: 0.5),
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
                //                       child: ClipRRect(
                //                         borderRadius: BorderRadius.circular(25),
                //                         child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                //                             ? Image.network(
                //                           _profilePhotoUrl!,
                //                           fit: BoxFit.cover,
                //                           errorBuilder: (context, error, stackTrace) {
                //                             return Image.asset('assets/remove.png', fit: BoxFit.cover);
                //                           },
                //                         )
                //                             : Image.asset('assets/remove.png', fit: BoxFit.cover),
                //                       ),
                //                     ),
                //                     const SizedBox(width: 10),
                //                     Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Row(
                //                           children: [
                //                             Text(
                //                               name.isNotEmpty ? name : "",
                //                               style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 20,
                //                                 letterSpacing: 0.2,
                //                                 fontWeight: FontWeight.w500,
                //                               ),
                //                             ),
                //                             SizedBox(width: 5.w),
                //                             // Add Blue Tick here
                //                             if (isVerified) // Show the tick if user is verified
                //                               Icon(
                //                                 Icons.verified_rounded,
                //                                 color: Color(0xff140B40),
                //                               )
                //                           ],
                //                         ),
                //                         Text(
                //                           "Total Wins : ₹${_winningamount?.toString() ?? "0"}",
                //                           style: TextStyle(
                //                             color: Colors.grey.shade200,
                //                             fontSize: 12,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //                 const SizedBox(height: 6),
                //                 Container(
                //                   height: 0.8,
                //                   width: MediaQuery.of(context).size.width,
                //                   color: Colors.grey.shade300,
                //                 ),
                //                 const SizedBox(height: 8),
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   crossAxisAlignment: CrossAxisAlignment.center,
                //                   children: [
                //                     Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         const SizedBox(width: 5),
                //                         Padding(
                //                           padding: EdgeInsets.only(top: 3.h),
                //                           child: Container(
                //                             height: 25.h,
                //                             width: MediaQuery.of(context).size.width * 0.32,
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
                //                                   SizedBox(width: 2.w),
                //                                   Flexible(
                //                                     child: FutureBuilder<WalletModel?>(
                //                                       future: _isProfileFetched ? walletDisplay() : Future.value(null),
                //                                       builder: (context, snapshot) {
                //                                         if (snapshot.connectionState == ConnectionState.waiting) {
                //                                           return SizedBox(
                //                                             height: 22.h,
                //                                             width: double.infinity,
                //                                             child: Center(
                //                                               child: Text(
                //                                                 '0',
                //                                                 style: TextStyle(
                //                                                   fontSize: 16.sp,
                //                                                   color: Colors.white,
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                           );
                //                                         } else if (snapshot.hasError) {
                //                                           return const Center(child: Text('Error fetching data'));
                //                                         } else if (!snapshot.hasData || snapshot.data == null) {
                //                                           return Center(
                //                                             child: Text(
                //                                               '0',
                //                                               style: TextStyle(
                //                                                 color: Colors.white,
                //                                                 fontSize: 16.sp,
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                           );
                //                                         } else {
                //                                           WalletModel walletData = snapshot.data!;
                //                                           return Center(
                //                                             child: Text(
                //                                               walletData.data.funds.toString() ?? "0",
                //                                               style: TextStyle(
                //                                                 color: Colors.white,
                //                                                 fontSize: 16.sp,
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                           );
                //                                         }
                //                                       },
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          name: name,
                          profilePhoto: _profilePhotoUrl,
                        ),
                      ),
                    );
                  },
                  child: Stack(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                height: 123,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 0.5),
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
                                            child: _profilePhotoUrl != null &&
                                                    _profilePhotoUrl!.isNotEmpty
                                                ? Image.network(
                                                    _profilePhotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/remove.png',
                                                          fit: BoxFit.cover);
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/remove.png',
                                                    fit: BoxFit.cover),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name.isNotEmpty ? name : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Total Wins : ₹${_winningamount?.toString() ?? "0"}",
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      height: 0.8,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(width: 5),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.h),
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
                                                      BorderRadius.circular(
                                                          20.r),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 14.h,
                                                        width: 14.w,
                                                        child: Image.asset(
                                                            'assets/vec.png'),
                                                      ),
                                                      SizedBox(width: 2.w),
                                                      Flexible(
                                                        child: FutureBuilder<
                                                            WalletModel?>(
                                                          future: _isProfileFetched
                                                              ? walletDisplay()
                                                              : Future.value(
                                                                  null),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return SizedBox(
                                                                height: 22.h,
                                                                width: double
                                                                    .infinity,
                                                                child: Center(
                                                                  child: Text(
                                                                    '0',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return const Center(
                                                                  child: Text(
                                                                      'Error fetching data'));
                                                            } else if (!snapshot
                                                                    .hasData ||
                                                                snapshot.data ==
                                                                    null) {
                                                              return Center(
                                                                child: Text(
                                                                  '0',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              WalletModel
                                                                  walletData =
                                                                  snapshot
                                                                      .data!;
                                                              return Center(
                                                                child: Text(
                                                                  walletData
                                                                          .data
                                                                          .funds
                                                                          .toString() ??
                                                                      "0",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
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
                            ),
                          ),
                        ),
                      ),
                      // Verified badge in top-right corner using Stack widget
                      Positioned(
                        top: 10.h, // Position from top of the container
                        right: 19.w, // Position from right of the container
                        child: _isVerify ??
                                false // Check if the user is verified
                            ?
                            // Container(
                            //   height: 20,
                            //   width: 20,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Color(0xff140B40),
                            //   ),
                            //   child: const Icon(
                            //     Icons.check,
                            //     color: Colors.white,
                            //     size: 14,
                            //   ),
                            // )
                            //   if (isVerified) // Show the tick if user is verified
                            const Icon(
                                Icons.verified_rounded,
                                color: Color(0xff140B40),
                              )
                            : Container(), // Empty container if not verified
                      ),
                    ],
                  ),
                ),

                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Profile(
                //             name: name,
                //               profilePhoto :  _profilePhotoUrl,
                //           ),
                //         ));
                //   },
                //   child: Container(
                //     height: 133,
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         image: const DecorationImage(
                //             image: AssetImage('assets/bg.png'),
                //             fit: BoxFit.cover)),
                //     child: BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 15),
                //             child: Container(
                //               padding: const EdgeInsets.only(
                //                   left: 10, right: 10, top: 10),
                //               height: 123,
                //               width: double.infinity,
                //               decoration: BoxDecoration(
                //                   color: Colors.white.withOpacity(0.05),
                //                   borderRadius: BorderRadius.circular(12),
                //                   border: Border.all(
                //                       color: Colors.grey.shade300, width: 0.5)),
                //               child: Column(
                //                  crossAxisAlignment: CrossAxisAlignment.center,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Row(
                //
                //                     children: [
                //                       SizedBox(
                //                         height: 50,
                //                         width: 50,
                //                         child:
                //                         // ClipRRect(
                //                         //   borderRadius: BorderRadius.circular(25),
                //                         //   child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                //                         //       ? Image.network(
                //                         //     _profilePhotoUrl!,
                //                         //     fit: BoxFit.cover,
                //                         //     errorBuilder: (context, error, stackTrace) {
                //                         //       // Show 'remove.png' image if there's an error loading the profile photo
                //                         //       return Image.asset(
                //                         //         'assets/remove.png',
                //                         //         fit: BoxFit.cover,
                //                         //       );
                //                         //     },
                //                         //   )
                //                         //       : Image.asset(
                //                         //     'assets/remove.png',
                //                         //     fit: BoxFit.cover,
                //                         //   ),
                //                         // ),
                //                         ClipRRect(
                //                           borderRadius: BorderRadius.circular(25),
                //                           child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                //                               ? Image.network(
                //                             _profilePhotoUrl!,
                //                             fit: BoxFit.cover,
                //                             errorBuilder: (context, error, stackTrace) {
                //                               // Show 'remove.png' image if there's an error loading the profile photo
                //                               return Image.asset(
                //                                 'assets/remove.png',
                //                                 fit: BoxFit.cover,
                //                               );
                //                             },
                //                           )
                //                               : Image.asset(
                //                             'assets/remove.png',
                //                             fit: BoxFit.cover,
                //                           ),
                //                         ),
                //
                //                         //             ClipRRect(
                //             //               borderRadius: BorderRadius.circular(25),
                //             //                child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                //             //             ? Image.network(
                //             //               _profilePhotoUrl!,
                //             //               fit: BoxFit.cover,
                //             //             )
                //             //         : Image.asset(
                //             //                  'assets/remove.png',
                //             //     // '${  _profilePhotoUrl}',
                //             //     fit: BoxFit.cover,
                //             //   ),
                //             // ),
                //           ),
                //                       const SizedBox(
                //                         width: 10,
                //                       ),
                //                       Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //
                //                         children: [
                //                           Text(
                //                             overflow: TextOverflow.visible,
                //                             name.isNotEmpty ? name : "",
                //                             style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 20,
                //                                 letterSpacing: 0.2,
                //                                 fontWeight: FontWeight.w500),
                //                           ),
                //                           Text(
                //                             "Total Wins : ₹${_winningamount?.toString() ?? "0"}",
                //                             // "Total Wins: ₹3000",
                //                             style: TextStyle(
                //                               color: Colors.grey.shade200,
                //                               fontSize: 12,
                //                             ),
                //                           ),
                //                         ],
                //                       )
                //                     ],
                //                   ),
                //                   const SizedBox(
                //                     height: 6,
                //                   ),
                //                   Container(
                //                     height: 0.8,
                //                     width: MediaQuery.of(context).size.width,
                //                     color: Colors.grey.shade300,
                //                   ),
                //                   const SizedBox(
                //                     height: 8,
                //                     // height:15,
                //                   ),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.end,
                //                     crossAxisAlignment: CrossAxisAlignment.center,
                //                     children: [
                //                       // Row(
                //                       //   // mainAxisAlignment: MainAxisAlignment.center,
                //                       //   // crossAxisAlignment: CrossAxisAlignment.center,
                //                       //   children: [
                //                       //     Text(
                //                       //       "0 Followers",
                //                       //       textAlign: TextAlign.center,
                //                       //       style: TextStyle(
                //                       //         color: Colors.white,
                //                       //         fontSize: 14,
                //                       //       ),
                //                       //     ),
                //                       //     SizedBox(
                //                       //       width: 4,
                //                       //     ),
                //                       //     Padding(
                //                       //       padding:
                //                       //           const EdgeInsets.only(top: 3),
                //                       //       child: Container(
                //                       //         height: 3,
                //                       //         width: 3,
                //                       //         decoration: BoxDecoration(
                //                       //             color: Colors.white,
                //                       //             borderRadius:
                //                       //                 BorderRadius.circular(1.5)),
                //                       //       ),
                //                       //     ),
                //                       //     SizedBox(
                //                       //       width: 4,
                //                       //     ),
                //                       //     Text(
                //                       //       textAlign: TextAlign.center,
                //                       //       "0 Following",
                //                       //       style: TextStyle(
                //                       //         color: Colors.white,
                //                       //         fontSize: 14,
                //                       //       ),
                //                       //     ),
                //                       //   ],
                //                       // ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //
                //                           const SizedBox(
                //                             width: 5,
                //                           ),
                //                           Padding(
                //                             padding: EdgeInsets.only(top: 3.h),
                //                             child: Container(
                //                               height: 25.h,
                //                               width: MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
                //                               decoration: BoxDecoration(
                //                                 color: Colors.transparent.withOpacity(0.06),
                //                                 borderRadius: BorderRadius.circular(20.r),
                //                               ),
                //                               child: Padding(
                //                                 padding: const EdgeInsets.only(left: 8.0),
                //                                 child: Row(
                //                                   crossAxisAlignment: CrossAxisAlignment.center,
                //                                   mainAxisAlignment: MainAxisAlignment.center,
                //                                   children: [
                //                                     SizedBox(
                //                                       height: 14.h,
                //                                       width: 14.w,
                //                                       child: Image.asset('assets/vec.png'),
                //                                     ),
                //                                     SizedBox(width: 2.w),
                //                                     Flexible(
                //                                       child: FutureBuilder<WalletModel?>(
                //                                         future: _isProfileFetched ? walletDisplay() : Future.value(null),
                //
                //                                         // future: walletDisplay(),
                //                                         builder: (context, snapshot) {
                //                                           if (snapshot.connectionState == ConnectionState.waiting) {
                //                                             return SizedBox(
                //                                               height: 22.h,
                //                                               width: double.infinity, // Use double.infinity to take all available space
                //                                               child: Center(
                //                                                 child: Text(
                //                                                   '0',
                //                                                   style: TextStyle(
                //                                                     fontSize: 16.sp,
                //                                                     color: Colors.white,
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             );
                //                                           } else if (snapshot.hasError) {
                //                                             return const Center(child: Text('Error fetching data'));
                //                                           } else if (!snapshot.hasData || snapshot.data == null) {
                //                                             return Center(child: Text('0',style: TextStyle(
                //                                               color: Colors.white,
                //                                               fontSize: 16.sp,
                //                                               fontWeight: FontWeight.w600,
                //                                             ),)); // Show 0 if no data
                //
                //                                             // return Center(child: Text('No data available'));
                //                                           } else {
                //                                             WalletModel walletData = snapshot.data!;
                //                                             // currentBalance = walletData.data?.funds.toString() ?? "0";
                //                                             return Center(
                //                                               child: Text(
                //                                                 walletData.data.funds.toString() ?? "0",
                //                                                 // "₹$currentBalance",
                //                                                // Use ellipsis to handle overflow
                //                                                 style: TextStyle(
                //                                                   color: Colors.white,
                //                                                   fontSize: 16.sp,
                //                                                   fontWeight: FontWeight.w600,
                //                                                 ),
                //                                               ),
                //                                             );
                //                                           }
                //                                         },
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //
                //                         ],
                //                       )
                //                     ],
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )),
                //   ),
                // ),
                const SizedBox(
                  height: 18,
                ),
                SmallText(color: Colors.grey, text: "Account Information"),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const EditProfileScreen(),
                          //     ));
                          _navigateToEditProfile();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/Group.png',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  NormalText(
                                      color: Colors.black, text: "Profile"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Divider(
                      //   color: Colors.grey.shade300,
                      // ),
                      const SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DocumentsUploadScreen(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/document.png',
                                    height: 24,
                                  ),
                                  // Icon(Icons.document_scanner,size: 25),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Verify Documents"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletScreen(
                                  balanceNotifier: balanceNotifier,
                                ),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/solar_user-circle-linear.png',
                                    height: 32,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black, text: "Wallet"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SmallText(color: Colors.grey, text: "Features"),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                // const ChatScreen(),
                                const CheatInside(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/cheats.png',
                                    height: 32,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black, text: "Live Chat"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WinnerScreen(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/winner_black.png',
                                    height: 26,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black, text: "Winner"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationView(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/notification.png',
                                    height: 26,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Notification"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SmallText(color: Colors.grey, text: "Help & support"),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InviteFriend(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/refer.png',
                                    height: 28,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Refer & Earn"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/game1.png',
                                  height: 18,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                NormalText(
                                    color: Colors.black, text: "How to Play"),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpAndSupport(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/ri_headphone-line.png',
                                    height: 26,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Help & Support"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SmallText(color: Colors.grey, text: "Other"),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 210,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CommunityScreen(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/co.png',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Community Guidelines"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("www.google.com",
                              subject: 'Check this out!');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/share_app.png',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Share Application"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUsScreen(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/game.png',
                                    height: 28,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black, text: "About Us"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePass()));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(
                                  isChangePassword: true), // Pass the flag
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/co.png',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  NormalText(
                                      color: Colors.black,
                                      text: "Change Password"),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),
                SmallText(color: Colors.grey, text: "Logout"),
                const SizedBox(
                  height: 4,
                ),
                InkWell(
                  onTap: () {
                    _dialogBuilder(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/logout.png',
                          height: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        NormalText(color: Colors.black, text: "Logout"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 290,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
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
                const Text("Are you sure you want",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.8,
                        color: Color(0xff140B40),
                        fontWeight: FontWeight.w600)),
                const Text("to Logout?",
                    style: TextStyle(
                        fontSize: 22,
                        letterSpacing: 0.8,
                        color: Color(0xff140B40),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _logoutAndNavigate(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: const Color(0xff010101).withOpacity(0.35)),
                          child: const Center(
                              child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: const Color(0xff140B40)),
                          child: const Center(
                              child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logoutAndNavigate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Construct notification body with both amounts
      String notificationBody =
          "Welcome back! ";

      await SendNotificationService.sendNotifcationUsingApi(
        title: "See you soon!!",
        body: "😊😊😊",
        token: "${prefs.getString('fcm_token')}",
        data: {"screen": "walletScreen"},
      );

      print("✅ Logout notification sent successfully");
    } catch (e) {
      print("❌Logout Error sending notification: $e");
    }


    await prefs.remove('token'); // Adjust the key as needed

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) =>
          false, // This line ensures all previous routes are removed
    );
    //final prefs = await SharedPreferences.getInstance();

  }
}
// Padding(
//   padding: const EdgeInsets.only(left: 5),
//   child: Container(
//     height: 18,
//     width: 18,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       color: Color(0xff140B40),
//     ),
//     child: const Icon(
//       Icons.check,
//       color: Colors.white,
//       size: 14,
//     ),
//   ),
// ),
