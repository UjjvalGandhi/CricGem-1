import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../db/app_db.dart';
import '../model/WinnerScreenModal.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/appbartext.dart';
import '../widget/normaltext.dart';
import '../widget/priceformatter.dart';
import '../widget/smalltext.dart';
import 'package:http/http.dart' as http;

import 'bnb.dart';

class WinnerScreen extends StatefulWidget {
  final bool isfromhomescreen; // Add a flag to indicate forgot password flow

  const WinnerScreen({
    super.key,
    this.isfromhomescreen = false,
  });

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  Future<WinnerScreenModal?>? _futureData;
  final bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _futureData = fetchMatches(); // Initialize _futureData here
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
  String formatDate(String dateString) {
    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date to dd-MM-yyyy format
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureData = fetchMatches(); // Refresh the data
    });
  }

  Future<WinnerScreenModal?> fetchMatches() async {
    print('Fetching matches...');
    try {
      String? token = await AppDB.appDB.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      debugPrint('Token: $token');

      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/contest/winner'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": token, // Adjust as needed
        },
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WinnerScreenModal.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load my matches: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error fetching My Matches data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await Future.microtask(() {
          // Check if the navigator can pop before trying to pop
          if (widget.isfromhomescreen) {
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
      child: Scaffold(
        backgroundColor: const Color(0xffF0F1F5),
        appBar: widget.isfromhomescreen
            ? null
            :
            // PreferredSize(
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
            //             colors: [Color(0xff140B40), Color(0xff140B40)],
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
            //               AppBarText(color: Colors.white, text: "Winner"),
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
            CustomAppBar(
                title: "Winner",
                onBackButtonPressed: () {
                  // Custom behavior for back button (if needed)
                  Navigator.pop(context);
                },
              ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<WinnerScreenModal?>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final matchesData = snapshot.data!.data;
                return SingleChildScrollView(
                  child: Column(
                    children: matchesData.map((matchDetails) {
                      final match = matchDetails.matches;
                      final team1 = matchDetails.team1Details;
                      final team2 = matchDetails.team2Details;
                      final isLastItem = matchesData.indexOf(matchDetails) ==
                          matchesData.length - 1;

                      // return Column(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 20),
                      //       width: MediaQuery.of(context).size.width,
                      //       color: const Color(0xffF0F1F5),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           const SizedBox(height: 15),
                      //           NormalText(
                      //             fontWeight: FontWeight.w600,
                      //             color: Colors.black,
                      //             text: 'Mega Contest Winners',
                      //           ),
                      //           SmallText(color: Colors.grey, text: "Recent Matches"),
                      //           const SizedBox(height: 15),
                      //           InkWell(
                      //             onTap: () {
                      //               // Handle tap if necessary
                      //             },
                      //             child: Container(
                      //               height: 290,
                      //               padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(20),
                      //               ),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Row(
                      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       NormalText(
                      //                         fontWeight: FontWeight.w600,
                      //                         color: Colors.black,
                      //                         text: matchDetails.leagueName,
                      //                       ),
                      //                       SmallText(
                      //                         color: Colors.grey,
                      //                         text: formatDate(match.date.toString()),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   const Divider(),
                      //                   Row(
                      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Row(
                      //                         children: [
                      //                           Image.network(team1.logo, width: 30, height: 25),
                      //                           const SizedBox(width: 8),
                      //                           Text(
                      //                             team1.teamShortName ?? "",
                      //                             textAlign: TextAlign.center,
                      //                             maxLines: 2,
                      //                             softWrap: true,
                      //                             overflow: TextOverflow.ellipsis,
                      //                             style: const TextStyle(
                      //                               fontSize: 14,
                      //                               fontWeight: FontWeight.w600,
                      //                               color: Colors.black,
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Row(
                      //                         children: [
                      //                           Text(
                      //                             team2.teamShortName ?? "",
                      //                             textAlign: TextAlign.center,
                      //                             maxLines: 2,
                      //                             softWrap: true,
                      //                             overflow: TextOverflow.ellipsis,
                      //                             style: const TextStyle(
                      //                               fontSize: 14,
                      //                               fontWeight: FontWeight.w600,
                      //                               color: Colors.black,
                      //                             ),
                      //                           ),
                      //                           const SizedBox(width: 8),
                      //                           Image.network(team2.logo, width: 30, height: 25),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   const Divider(),
                      //                   Row(
                      //                     children: [
                      //                       Image.asset(
                      //                         'assets/win.png',
                      //                         height: 20,
                      //                       ),
                      //                       const SizedBox(width: 8),
                      //                       Text(
                      //                         formatMegaPrice(matchDetails.contests.first.pricePool) ?? "0",
                      //                         style: const TextStyle(
                      //                           color: Colors.black,
                      //                           fontWeight: FontWeight.w500,
                      //                           fontSize: 16,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   SizedBox(
                      //                     height: 160,
                      //                     width: MediaQuery.of(context).size.width,
                      //                     child: ListView.builder(
                      //                       scrollDirection: Axis.horizontal,
                      //                       itemCount: matchDetails.contests.length,
                      //                       itemBuilder: (context, index) {
                      //                         var contest = matchDetails.contests[index];
                      //
                      //                         return Container(
                      //                           margin: const EdgeInsets.only(right: 10),
                      //                           child: Stack(
                      //                             alignment: Alignment.bottomCenter,
                      //                             children: [
                      //                               Container(
                      //                                 height: 150,
                      //                                 width: 105,
                      //                                 decoration: BoxDecoration(
                      //                                   color: Colors.white,
                      //                                   border: Border.all(color: Colors.grey.shade300),
                      //                                   borderRadius: BorderRadius.circular(10),
                      //                                 ),
                      //                                 child: Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.center,
                      //                                   children: [
                      //                                     const SizedBox(height: 5),
                      //                                     Text(
                      //                                       "Rank #${contest.rank}",
                      //                                       style: const TextStyle(
                      //                                         color: Colors.black,
                      //                                         fontWeight: FontWeight.w500,
                      //                                         fontSize: 15,
                      //                                       ),
                      //                                     ),
                      //                                     const SizedBox(height: 1),
                      //                                     Expanded(
                      //                                       child: Text(
                      //                                         contest.userDetails.name,
                      //                                         style: const TextStyle(
                      //                                           color: Colors.black,
                      //                                           fontWeight: FontWeight.w400,
                      //                                           fontSize: 12,
                      //                                         ),
                      //                                         textAlign: TextAlign.center,
                      //                                       ),
                      //                                     ),
                      //                                     const SizedBox(height: 9),
                      //                                     SizedBox(
                      //                                       height: 45,
                      //                                       width: 45,
                      //                                       child: ClipRRect(
                      //                                         borderRadius: BorderRadius.circular(25),
                      //                                         child: Image.network(
                      //                                           contest.userDetails.profilePhoto,
                      //                                           errorBuilder: (context, error, stackTrace) {
                      //                                             return Image.asset('assets/dummy_player.png');
                      //                                           },
                      //                                           fit: BoxFit.cover,
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                     const Spacer(),
                      //                                     Container(
                      //                                       height: 32,
                      //                                       width: double.infinity,
                      //                                       decoration: const BoxDecoration(
                      //                                         color: Color(0xff140B40),
                      //                                         borderRadius: BorderRadius.only(
                      //                                           bottomRight: Radius.circular(10),
                      //                                           bottomLeft: Radius.circular(10),
                      //                                         ),
                      //                                       ),
                      //                                       child: Center(
                      //                                         child: Text(
                      //                                           "Won ₹${contest.winningAmount}",
                      //                                           style: const TextStyle(
                      //                                             fontSize: 15,
                      //                                             color: Colors.white,
                      //                                             fontWeight: FontWeight.w400,
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         );
                      //                       },
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     if (isLastItem) SizedBox(height: 18.h ,child: Container(
                      //       color: Color(0xffF0F1F5),
                      //     ),),
                      //   ],
                      // );
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xffF0F1F5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                NormalText(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  text: 'Mega Contest Winners',
                                ),
                                SmallText(
                                    color: Colors.grey, text: "Recent Matches"),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    // Handle tap if necessary
                                  },
                                  child: Container(
                                    height: 290,
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            NormalText(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              text: matchDetails.leagueName,
                                            ),
                                            SmallText(
                                              color: Colors.grey,
                                              text: formatDate(
                                                  match.date.toString()),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(team1.logo,
                                                    width: 30, height: 25),
                                                const SizedBox(width: 8),
                                                Text(
                                                  team1.teamShortName ?? "",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  team2.teamShortName ?? "",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Image.network(team2.logo,
                                                    width: 30, height: 25),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/win.png',
                                              height: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            // Text(
                                            //   formatMegaPrice(matchDetails.contests.first.pricePool) ?? "0",
                                            //   style: const TextStyle(
                                            //     color: Colors.black,
                                            //     fontWeight: FontWeight.w500,
                                            //     fontSize: 16,
                                            //   ),
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Mega contest ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                PriceDisplay(
                                                    price: matchDetails.contests
                                                        .first.pricePool,
                                                    iswinner:
                                                        true), // Assuming match.megaprice is an int
                                              ],
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 10),

                                        Center(
                                          // Center aligns the ListView
                                          child: SizedBox(
                                            height: 160,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8, // Adjust width if needed
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  matchDetails.contests.length,
                                              itemBuilder: (context, index) {
                                                var contest = matchDetails
                                                    .contests[index];

                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        width: 105,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              "Rank #${contest.rank}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 1),
                                                            Expanded(
                                                              child: Text(
                                                                contest
                                                                    .userDetails
                                                                    .name,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 9),
                                                            SizedBox(
                                                              height: 45,
                                                              width: 45,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child: Image
                                                                    .network(
                                                                  contest
                                                                      .userDetails
                                                                      .profilePhoto,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                            'assets/dummy_player.png');
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              height: 32,
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xff140B40),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "Won ₹${contest.winningAmount}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isLastItem)
                            SizedBox(
                              height: 18,
                              child: Container(
                                color: const Color(0xffF0F1F5),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
        ),
      ),
    );
  }
}



//best
// return SingleChildScrollView(
//   child: Column(
//     children: matchesData.map((matchDetails) {
//       final match = matchDetails.matches;
//       final team1 = matchDetails.team1Details;
//       final team2 = matchDetails.team2Details;
//
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         width: MediaQuery.of(context).size.width,
//         color: const Color(0xffF0F1F5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 15),
//             // const Text(
//             //   'Mega Contest Winners',
//             //   // matchDetails.leagueName,
//             //   style: TextStyle(
//             //     color: Colors.black,
//             //     fontWeight: FontWeight.w500,
//             //     fontSize: 18,
//             //   ),
//             // ),
//             NormalText(
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//               text: 'Mega Contest Winners',
//             ),
//             SmallText(color: Colors.grey, text: "Recent Matches"),
//   const SizedBox(
//     height: 15,
//   ),
//             InkWell(
//               onTap: () {
//                 // Handle tap if necessary
//               },
//               child: Container(
//                 height: 275,
//                 padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Text(
//                         //   matchDetails.leagueName,
//                         //   style: const TextStyle(
//                         //     color: Colors.black,
//                         //     fontWeight: FontWeight.w500,
//                         //     fontSize: 14,
//                         //   ),
//                         // ),
//                         NormalText(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                           text: matchDetails.leagueName,
//                         ),
//                         // Text(
//                         //   formatDate(match.date.toString()),
//                         //   // "${match.date}",
//                         //   style: const TextStyle(
//                         //     color: Colors.black45,
//                         //     fontSize: 12,
//                         //   ),
//                         // ),
//                         SmallText(
//                             color: Colors.grey, text: formatDate(match.date.toString())),
//                       ],
//                     ),
//                     // SizedBox(height: 6),
//                     const Divider(),
//                     // Display match details
//                 Row(
//                                         mainAxisAlignment: MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Image.network(
//                                                   team1.logo, width: 30, height: 25),
//                                               const SizedBox(width: 8),
//                                               // NormalText(color: Colors.black,
//                                               //     text: team1.teamShortName)
//                                               Text(
//                                                 team1.teamShortName ?? "",
//                                                 textAlign: TextAlign.center,
//                                                 maxLines: 2,
//                                                 softWrap: true,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               // NormalText(color: Colors.black,
//                                               //     text: team2.teamShortName),
//                                               Text(
//                                                 team2.teamShortName ?? "",
//                                                 textAlign: TextAlign.center,
//                                                 maxLines: 2,
//                                                 softWrap: true,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Image.network(
//                                                   team2.logo, width: 30, height: 25),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //
//                     //     // Text(
//                     //     //   "${team1.teamShortName} vs ${team2.teamShortName}",
//                     //     //   style: TextStyle(
//                     //     //     color: Colors.black,
//                     //     //     fontWeight: FontWeight.w500,
//                     //     //     fontSize: 14,
//                     //     //   ),
//                     //     // ),
//                     //
//                     //   ],
//                     // ),
//                     // SizedBox(height: 6),
//                     const Divider(),
//                     // SizedBox(height: 10),
//                 Row(
//                         children: [
//                           Image.asset(
//                             'assets/win.png',
//                             height: 20,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             formatMegaPrice(matchDetails.contests.first.pricePool) ?? "0",
//                             // "${matchDetails.contests.first.pricePool}",
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                             ),
//                           ),
//                     ]),
//                     // Loop through contests for the current match
//                     SizedBox(
//                       height: 150,
//                       width: MediaQuery.of(context).size.width,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: matchDetails.contests.length, // Count of contests
//                         itemBuilder: (context, index) {
//                           var contest = matchDetails.contests[index];
//
//                           return Container(
//                             margin: const EdgeInsets.only(right: 10),
//                             child: Stack(
//                               alignment: Alignment.bottomCenter,
//                               children: [
//                                 Container(
//                                   height: 140,
//                                   width: 101,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(color: Colors.grey.shade300),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "Rank #${contest.rank}",
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 1),
//                                       Expanded(
//                                         child: Text(
//                                           contest.userDetails.name,
//                                           style: const TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 9),
//                                       SizedBox(
//                                         height: 45,
//                                         width: 45,
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(25),
//                                           child: Image.network(
//                                             contest.userDetails.profilePhoto,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Image.asset('assets/dummy_player.png');
//                                             },
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Container(
//                                         height: 32,
//                                         width: double.infinity,
//                                         decoration: const BoxDecoration(
//                                           // color: Color(0xffedb60a),
//                                           // color: Color(
//                                           //     0xfff1b405),
//                                           color: Color(
//                                               0xff140B40),
//                                           borderRadius: BorderRadius.only(
//                                             bottomRight: Radius.circular(10),
//                                             bottomLeft: Radius.circular(10),
//                                           ),
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             "Won ₹${contest.winningAmount}", // Dynamic winning amount
//                                             style: const TextStyle(
//                                               fontSize: 15,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 15.h),
//           ],
//         ),
//       );
//     }).toList(),
//   ),
// );
// return SingleChildScrollView(
//   child: Column(
//     children: matchesData.map((matchDetails) {
//       SizedBox(height: 10);
//       final match = matchDetails.matches;
//       final team1 = matchDetails.team1Details;
//       final team2 = matchDetails.team2Details;
//       final contest = matchDetails.contests.first; // Assuming first contest for display
//
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         height: MediaQuery
//             .of(context)
//             .size
//             .height,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         color: const Color(0xffF0F1F5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               matchDetails.leagueName,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 18,
//               ),
//             ),
//             SizedBox(height: 4),
//             SmallText(color: Colors.grey, text: "Recent Matches"),
//             SizedBox(height: 20),
//             InkWell(
//               onTap: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) =>const MegaContestScreen() ,));
//               },
//               child: Container(
//                 height: 310,
//                 padding: const EdgeInsets.only(
//                     top: 15, left: 15, right: 15),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment
//                           .spaceBetween,
//                       children: [
//                         Text(
//                           "${team1.teamShortName} vs ${team2
//                               .teamShortName}",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           "${match.date}",
//                           style: TextStyle(
//                             color: Colors.black45,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 6),
//                     Container(
//                       height: 0.8,
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
//                       color: Colors.grey.shade300,
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment
//                           .spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             // Image.network(
//                             //     team1.logo, width: 30, height: 20),
//                             SizedBox(width: 8),
//                             NormalText(color: Colors.black,
//                                 text: matchDetails.leagueName)
//                           ],
//                         ),
//                         // Row(
//                         //   children: [
//                         //     NormalText(color: Colors.black,
//                         //         text: team2.teamName),
//                         //     SizedBox(width: 8),
//                         //     Image.network(
//                         //         team2.logo, width: 30, height: 20),
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment
//                     //       .spaceBetween,
//                     //   children: [
//                     //     Row(
//                     //       children: [
//                     //         Image.network(
//                     //             team1.logo, width: 30, height: 20),
//                     //         SizedBox(width: 8),
//                     //         NormalText(color: Colors.black,
//                     //             text: team1.teamName)
//                     //       ],
//                     //     ),
//                     //     Row(
//                     //       children: [
//                     //         NormalText(color: Colors.black,
//                     //             text: team2.teamName),
//                     //         SizedBox(width: 8),
//                     //         Image.network(
//                     //             team2.logo, width: 30, height: 20),
//                     //       ],
//                     //     ),
//                     //   ],
//                     // ),
//                     SizedBox(height: 6),
//                     Container(
//                       height: 0.8,
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
//                       color: Colors.grey.shade300,
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/win.png',
//                           height: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           "Winning Amount: ₹${contest
//                               .winningAmount}",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 18,
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 7),
//                     SizedBox(
//                       height: 150,
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: matchDetails.contests.length,
//                         // Adjust according to the actual data
//                         itemBuilder: (context, index) {
//                           var user = matchDetails.contests[index];
//
//                           return Container(
//                             margin: EdgeInsets.only(right: 10),
//                             child: Stack(
//                                 alignment: Alignment.bottomCenter,
//                                 children: [
//                                   Container(
//                                     height: 140,
//                                     width: 101,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                             color: Colors.grey
//                                                 .shade300),
//                                         borderRadius:
//                                         BorderRadius.circular(10)),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment
//                                           .center,
//                                       children: [
//                                         SizedBox(height: 4),
//                                         Text(
//                                           "Rank #${user.rank}",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight
//                                                 .w500,
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                         SizedBox(height: 1),
//                                         Expanded(
//                                           child: Text(
//                                             user.userDetails.name,
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight
//                                                   .w400,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius
//                                                 .circular(25),
//                                             child: Image.network(
//                                               user.userDetails.profilePhoto,
//                                               errorBuilder: (context, error, stackTrace) {
//                                                 return Image.asset('assets/dummy_player.png');
//                                               },
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Container(
//                                           height: 32,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                               color: const Color(
//                                                   0xffD4AF37),
//                                               borderRadius: BorderRadius
//                                                   .only(
//                                                   bottomRight: Radius
//                                                       .circular(10),
//                                                   bottomLeft: Radius
//                                                       .circular(
//                                                       10))),
//                                           child: Center(
//                                             child: Text(
//                                               "Won ₹${contest
//                                                   .winningAmount}",
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   color: Colors
//                                                       .white,
//                                                   fontWeight: FontWeight
//                                                       .w400),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ]),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       );
//     }).toList(),
//   ),
// );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar:widget.isfromhomescreen! ?null : PreferredSize(
//           preferredSize: const Size.fromHeight(70.0),
//           child: ClipRRect(
//             child: AppBar(
//               leading: Container(),
//               surfaceTintColor:const Color(0xffF0F1F5) ,
//               backgroundColor:const Color(0xffF0F1F5) , // Custom background color
//               elevation: 0, // Remove shadow
//               centerTitle: true,
//               flexibleSpace: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
//                 height: 100,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xff1D1459),Color(0xff140B40)
//                         ])
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 50),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                             onTap: (){
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(Icons.arrow_back,color: Colors.white,)),
//                         AppBarText(color: Colors.white, text: "Winner"),
//                         Container(width: 20,)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: FutureBuilder<WinnerScreenModal?>(
//             future: _futureData,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData) {
//                 return Center(child: Text('No data available'));
//               }
//
//               final matchesData = snapshot.data!.data;
//
//             return SingleChildScrollView(
//
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     color:const Color(0xffF0F1F5),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             matchesData[0].leagueName,
//                             // "Mega Contest Winners",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           SmallText(color: Colors.grey, text: "Recent Matches"),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           InkWell(
//                             onTap: (){
//                               // Navigator.push(context, MaterialPageRoute(builder: (context) =>const MegaContestScreen() ,));
//                             },
//                             child: Container(
//                               height: 310,
//                               padding:
//                               const EdgeInsets.only(top: 15, left: 15, right: 15),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Indian Premier League",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       Text(
//                                         "22 Mar 2024",
//                                         style: TextStyle(
//                                           color: Colors.black45,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 6,
//                                   ),
//                                   Container(
//                                     height: 0.8,
//                                     width: MediaQuery.of(context).size.width,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Container(
//                                             width: 30,
//                                             height: 20,
//                                             child: Image.asset('assets/india.png'),
//                                           ),
//                                           SizedBox(
//                                             width: 8,
//                                           ),
//                                           NormalText(color: Colors.black, text: "India")
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 6),
//                                             child: NormalText(
//                                                 color: Colors.black,
//                                                 text: "South Africa"),
//                                           ),
//                                           Container(
//                                             width: 30,
//                                             height: 20,
//                                             child: Image.asset('assets/nz.png'),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 6,
//                                   ),
//                                   Container(
//                                     height: 0.8,
//                                     width: MediaQuery.of(context).size.width,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/win.png',
//                                         height: 20,
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                         "₹2200 Crores",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 18,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   SizedBox(
//                                     height: 150,
//                                     width: MediaQuery.of(context).size.width,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: 3,
//                                       itemBuilder: (context, index) {
//                                         return Container(
//                                           margin: EdgeInsets.only(right: 10),
//                                           child: Stack(
//                                               alignment: Alignment.bottomCenter,
//                                               children: [
//                                                 Container(
//                                                   // padding: EdgeInsets.symmetric(
//                                                   //     horizontal: 8),
//                                                   height: 140,
//                                                   width: 101,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       border: Border.all(
//                                                           color: Colors.grey.shade300),
//                                                       borderRadius:
//                                                       BorderRadius.circular(10)),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                     children: [
//                                                       SizedBox(height: 4),
//                                                       Text(
//                                                         "Rank #1",
//                                                         style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontWeight: FontWeight.w500,
//                                                           fontSize: 15,
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         "Rajavin11",
//                                                         style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontWeight: FontWeight.w400,
//                                                           fontSize: 12,
//                                                         ),
//                                                       ),
//                                                       Container(
//                                                         height: 50,
//                                                         width: 50,
//                                                         child: ClipRRect(
//                                                           borderRadius:
//                                                           BorderRadius.circular(25),
//                                                           child: Image.asset(
//                                                             'assets/rdjr.jpg',
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Spacer(),
//                                                       Container(
//
//                                                         height: 32,
//                                                         width: double.infinity,
//                                                         decoration: BoxDecoration(
//                                                             color: const Color(0xffD4AF37),
//                                                             borderRadius: BorderRadius.only(
//                                                                 bottomRight:
//                                                                 Radius.circular(10),
//                                                                 bottomLeft:
//                                                                 Radius.circular(10))),
//                                                         child: Center(
//                                                           child: Text(
//                                                             "Won ₹15 Lakhs",
//                                                             style: TextStyle(
//                                                                 fontSize: 10,
//                                                                 color: Colors.white,
//                                                                 fontWeight: FontWeight.w400),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//
//                                               ]),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//
//                           Container(
//                             height: 310,
//                             padding:
//                             const EdgeInsets.only(top: 15, left: 15, right: 15),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Indian Premier League",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     Text(
//                                       "22 Mar 2024",
//                                       style: TextStyle(
//                                         color: Colors.black45,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 6,
//                                 ),
//                                 Container(
//                                   height: 0.8,
//                                   width: MediaQuery.of(context).size.width,
//                                   color: Colors.grey.shade300,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 30,
//                                           height: 20,
//                                           child: Image.asset('assets/india.png'),
//                                         ),
//                                         SizedBox(
//                                           width: 8,
//                                         ),
//                                         NormalText(color: Colors.black, text: "India")
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(right: 6),
//                                           child: NormalText(
//                                               color: Colors.black,
//                                               text: "South Africa"),
//                                         ),
//                                         Container(
//                                           width: 30,
//                                           height: 20,
//                                           child: Image.asset('assets/nz.png'),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 6,
//                                 ),
//                                 Container(
//                                   height: 0.8,
//                                   width: MediaQuery.of(context).size.width,
//                                   color: Colors.grey.shade300,
//                                 ),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Image.asset(
//                                       'assets/win.png',
//                                       height: 20,
//                                     ),
//                                     SizedBox(
//                                       width: 8,
//                                     ),
//                                     Text(
//                                       "₹2200 Crores",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 18,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 7,
//                                 ),
//                                 SizedBox(
//                                   height: 150,
//                                   width: MediaQuery.of(context).size.width,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: 3,
//                                     itemBuilder: (context, index) {
//                                       return Container(
//                                         margin: EdgeInsets.only(right: 10),
//                                         child: Stack(
//                                             alignment: Alignment.bottomCenter,
//                                             children: [
//                                               Container(
//                                                 // padding: EdgeInsets.symmetric(
//                                                 //     horizontal: 8),
//                                                 height: 140,
//                                                 width: 101,
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color: Colors.grey.shade300),
//                                                     borderRadius:
//                                                     BorderRadius.circular(10)),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                                   children: [
//                                                     SizedBox(height: 4),
//                                                     Text(
//                                                       "Rank #1",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.w500,
//                                                         fontSize: 15,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "Rajavin11",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.w400,
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       height: 50,
//                                                       width: 50,
//                                                       child: ClipRRect(
//                                                         borderRadius:
//                                                         BorderRadius.circular(25),
//                                                         child: Image.asset(
//                                                           'assets/rdjr.jpg',
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Spacer(),
//                                                     Container(
//
//                                                       height: 32,
//                                                       width: double.infinity,
//                                                       decoration: BoxDecoration(
//                                                           color: const Color(0xffD4AF37),
//                                                           borderRadius: BorderRadius.only(
//                                                               bottomRight:
//                                                               Radius.circular(10),
//                                                               bottomLeft:
//                                                               Radius.circular(10))),
//                                                       child: Center(
//                                                         child: Text(
//                                                           "Won ₹15 Lakhs",
//                                                           style: TextStyle(
//                                                               fontSize: 10,
//                                                               color: Colors.white,
//                                                               fontWeight: FontWeight.w400),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//
//                                             ]),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//         )
//
//     );
//   }
// }

//     body: SingleChildScrollView(
//
//   child: Column(
//     children: [
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color:const Color(0xffF0F1F5),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Mega Contest Winners",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               SmallText(color: Colors.grey, text: "Recent Matches"),
//               SizedBox(
//                 height: 20,
//               ),
//               InkWell(
//                 onTap: (){
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) =>const MegaContestScreen() ,));
//                 },
//                 child: Container(
//                   height: 310,
//                   padding:
//                       const EdgeInsets.only(top: 15, left: 15, right: 15),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Indian Premier League",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             "22 Mar 2024",
//                             style: TextStyle(
//                               color: Colors.black45,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Container(
//                         height: 0.8,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.shade300,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 30,
//                                 height: 20,
//                                 child: Image.asset('assets/india.png'),
//                               ),
//                               SizedBox(
//                                 width: 8,
//                               ),
//                               NormalText(color: Colors.black, text: "India")
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 6),
//                                 child: NormalText(
//                                     color: Colors.black,
//                                     text: "South Africa"),
//                               ),
//                               Container(
//                                 width: 30,
//                                 height: 20,
//                                 child: Image.asset('assets/nz.png'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Container(
//                         height: 0.8,
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.shade300,
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [
//                           Image.asset(
//                             'assets/win.png',
//                             height: 20,
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "₹2200 Crores",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                       SizedBox(
//                         height: 150,
//                         width: MediaQuery.of(context).size.width,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 3,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               margin: EdgeInsets.only(right: 10),
//                               child: Stack(
//                                   alignment: Alignment.bottomCenter,
//                                   children: [
//                                     Container(
//                                       // padding: EdgeInsets.symmetric(
//                                       //     horizontal: 8),
//                                       height: 140,
//                                       width: 101,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           border: Border.all(
//                                               color: Colors.grey.shade300),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           SizedBox(height: 4),
//                                           Text(
//                                             "Rank #1",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           Text(
//                                             "Rajavin11",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                           Container(
//                                             height: 50,
//                                             width: 50,
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(25),
//                                               child: Image.asset(
//                                                 'assets/rdjr.jpg',
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           Spacer(),
//                                           Container(
//
//                                             height: 32,
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 color: const Color(0xffD4AF37),
//                                                 borderRadius: BorderRadius.only(
//                                                     bottomRight:
//                                                     Radius.circular(10),
//                                                     bottomLeft:
//                                                     Radius.circular(10))),
//                                             child: Center(
//                                               child: Text(
//                                                 "Won ₹15 Lakhs",
//                                                 style: TextStyle(
//                                                     fontSize: 10,
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w400),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//                                   ]),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//
//               Container(
//                 height: 310,
//                 padding:
//                 const EdgeInsets.only(top: 15, left: 15, right: 15),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Indian Premier League",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           "22 Mar 2024",
//                           style: TextStyle(
//                             color: Colors.black45,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 6,
//                     ),
//                     Container(
//                       height: 0.8,
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.grey.shade300,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 30,
//                               height: 20,
//                               child: Image.asset('assets/india.png'),
//                             ),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             NormalText(color: Colors.black, text: "India")
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 6),
//                               child: NormalText(
//                                   color: Colors.black,
//                                   text: "South Africa"),
//                             ),
//                             Container(
//                               width: 30,
//                               height: 20,
//                               child: Image.asset('assets/nz.png'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 6,
//                     ),
//                     Container(
//                       height: 0.8,
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.grey.shade300,
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/win.png',
//                           height: 20,
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Text(
//                           "₹2200 Crores",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 18,
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     SizedBox(
//                       height: 150,
//                       width: MediaQuery.of(context).size.width,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: 3,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             margin: EdgeInsets.only(right: 10),
//                             child: Stack(
//                                 alignment: Alignment.bottomCenter,
//                                 children: [
//                                   Container(
//                                     // padding: EdgeInsets.symmetric(
//                                     //     horizontal: 8),
//                                     height: 140,
//                                     width: 101,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                             color: Colors.grey.shade300),
//                                         borderRadius:
//                                         BorderRadius.circular(10)),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                       children: [
//                                         SizedBox(height: 4),
//                                         Text(
//                                           "Rank #1",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Rajavin11",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                             child: Image.asset(
//                                               'assets/rdjr.jpg',
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Container(
//
//                                           height: 32,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                               color: const Color(0xffD4AF37),
//                                               borderRadius: BorderRadius.only(
//                                                   bottomRight:
//                                                   Radius.circular(10),
//                                                   bottomLeft:
//                                                   Radius.circular(10))),
//                                           child: Center(
//                                             child: Text(
//                                               "Won ₹15 Lakhs",
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                 ]),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       )
//     ],
//   ),
// )






// PopScope(
// canPop:false,
// onPopInvokedWithResult: (didPop, result) async {
//   // Navigate to HomeScreens when back button is pressed
//   if(widget.isfromhomescreen) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const MyHomePage(),
//       ),
//     );
//   }
//   else{
//     Navigator.pop(context);
//   }
//   return; // Prevent the default back navigation
// },

// WillPopScope(
//   onWillPop: () async {
//     if (widget.isfromhomescreen) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//             (route) => false, // Remove all previous routes
//       );
//       return false; // Prevent default back button behavior
//     }
//     return true; // Allow back navigation
//   },

// PreferredSize(
//   preferredSize: Size.fromHeight(60.0.h),
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
//           gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xff1D1459), Color(0xff140B40)]),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     // if(widget.isfromhomescreen) {
//                     //   Navigator.pushReplacement(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //       builder: (context) => const MyHomePage(),
//                     //     ),
//                     //   );
//                     // }
//                     // else{
//                     //   Navigator.pop(context);
//                     // }
//                     Navigator.pop(context);
//                   //   if (!_isNavigating) {
//                   //     _isNavigating = true; // Lock the navigation
//                   //
//                   //     if (widget.isfromhomescreen) {
//                   //       Navigator.pushReplacement(
//                   //         context,
//                   //         MaterialPageRoute(
//                   //           builder: (context) => const MyHomePage(),
//                   //         ),
//                   //       );
//                   //     } else {
//                   //       Navigator.pop(context);
//                   //     }
//                   //
//                   //     _isNavigating = false; // Unlock navigation after the operation
//                   //   }
//                   },
//                   child: const Icon(
//                       Icons.arrow_back, color: Colors.white),
//                 ),
//                 AppBarText(color: Colors.white, text: "Winner"),
//                 Container(width: 20),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),