import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/joincontestprovider.dart';
import '../widget/normal2.0.dart';
import '../widget/priceformatter.dart';
import 'content_inside screen.dart';

class JoincontestListScreen extends StatelessWidget {
  final String? Id;
  final String? matchName;
  final String? time;

  const JoincontestListScreen({super.key, this.Id, this.matchName, this.time});

  // String formatMegaPrice(int price) {
  //   if (price >= 10000000) {
  //     return "${(price / 10000000).toStringAsFixed(1)} cr";
  //   } else if (price >= 100000) {
  //     return "${(price / 100000).toStringAsFixed(1)} lakh";
  //   } else {
  //     return "₹${price.toString()}";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JoinContestProvider>(context, listen: false);

    // Fetch data when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchContestData(Id!);
    });

    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      body: Consumer<JoinContestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.contestData == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Text(provider.errorMessage!),
            );
          }

          final contests = provider.contestData?.data ?? [];
          if (contests.isEmpty) {
            return const Center(
              child: Text(
                "No contests available.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            );
          }
          return RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              await provider.fetchContestData(Id!);
            },
            child: ListView.builder(
              itemCount: contests.length,
              itemBuilder: (context, index) {
                final contest = contests[index];
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          print(matchName);
                          print('id:..........$Id');
                          print('contest.id is................${contest.id}');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContentInside(
                                        matchName: matchName,
                                        CId: contest.id,
                                        Id: Id,
                                        // Id: ,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
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
                                      PriceDisplay(
                                        price: contest.contestDetails.pricePool,
                                        isjoincontest: true,
                                      ), // Assuming match.megaprice is an int
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      // Display prize for rank 1 if `maxWinning` has at least one item
                                      if (contest.maxWinning.isNotEmpty)
                                        Normal2Text(
                                          color: Colors.black,
                                          text:
                                              "#1 - ₹${contest.maxWinning[0].prize}",
                                        ),
                                      // Display prize for rank 2 if `maxWinning` has more than one item
                                      if (contest.maxWinning.length > 1)
                                        Normal2Text(
                                          color: Colors.black,
                                          text:
                                              "#2 - ₹${contest.maxWinning[1].prize}",
                                        ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                minHeight: 2.5,
                                backgroundColor:
                                    const Color(0xff777777).withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xff140B40)),
                                value: 1 - (contest.remainingSpots / 2000),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${contest.remainingSpots} spots left",
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xff140B40)),
                                  ),
                                  Text(
                                    "${contest.contestDetails.totalParticipant} spots",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              Container(
                                height: 34,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: const Color(0xff140B40),
                                ),
                                child: Center(
                                  child: Text(
                                    "₹${contest.contestDetails.entryFees}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
          return const SizedBox.shrink();
          // }
        },
      ),
    );
  }
}




// if (provider.isLoading) {
//   return const Center(child: CircularProgressIndicator());
// }
// else if (provider.errorMessage != null) {
//   return Center(child: Text(provider.errorMessage!));
// } else if (provider.contestData == null ||
//     provider.contestData!.data.isEmpty) {
//   return const Center(child: Text('No data available'));
// } else {
// return Container(
//   color: const Color(0xffF0F1F5),
//   child: ListView.builder(
//     itemCount: contests.length,
//     itemBuilder: (context, index) {
//       final contest = contests[index];
//       return Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ContentInside(
//                   matchName: matchName,
//                   CId: contest.id,
//                   Id: Id,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.white, width: 1),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Prize Pool",
//                             style: TextStyle(
//                               color: Colors.black45,
//                               fontSize: 12,
//                             )),
//                         Text(
//                           formatMegaPrice(contest
//                               .contestDetails.pricePool),
//                           style: const TextStyle(
//                             color: Color(0xff140B40),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 22,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         if (contest.maxWinning.isNotEmpty)
//                           Normal2Text(
//                             color: Colors.black,
//                             text: "#1 - ₹${contest.maxWinning[0].prize}",
//                           ),
//                         if (contest.maxWinning.length > 1)
//                           Normal2Text(
//                             color: Colors.black,
//                             text: "#2 - ₹${contest.maxWinning[1].prize}",
//                           ),
//                       ],
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 LinearProgressIndicator(
//                   minHeight: 2.5,
//                   backgroundColor: const Color(0xff777777)
//                       .withOpacity(0.3),
//                   valueColor: const AlwaysStoppedAnimation<Color>(
//                       Color(0xff140B40)),
//                   value: 1 - (contest.remainingSpots / 2000),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${contest.remainingSpots} spots left",
//                       style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xff140B40)),
//                     ),
//                     Text(
//                       "${contest.contestDetails.totalParticipant} spots",
//                       style: const TextStyle(
//                           fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 9),
//                 Container(
//                   height: 34,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(9),
//                     color: const Color(0xff140B40),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "₹${contest.contestDetails.entryFees}",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   ),
// );
// Text(
//   formatMegaPrice(contest.contestDetails.pricePool),
//
//   // "₹${contest.contestDetails.pricePool}",
//   style: const TextStyle(
//     color: Color(0xff140B40),
//     fontWeight: FontWeight.w600,
//     fontSize: 22,
//   ),
// ),



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/JoinContestModel.dart';
// import '../widget/normal2.0.dart';
// import 'content_inside screen.dart';
//
// class JoincontestListScreen extends StatelessWidget {
//
//   final String? Id;
//   final String? matchName;
//   final String? time;
//
//
//   const JoincontestListScreen(
//       {super.key, this.Id,this.matchName,this.time});
//   // String formatMegaPrice(int price) {
//   //   if (price >= 10000000) {
//   //     // 1 crore = 10,000,000
//   //     return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
//   //   } else if (price >= 100000) {
//   //     // 1 lakh = 100,000
//   //     return "${(price / 100000).toStringAsFixed(0)} lakh"; // Format to whole number
//   //   } else {
//   //     return "₹${price.toString()}"; // For values less than 1 lakh
//   //   }
//   // }
//   String formatMegaPrice(int price) {
//     if (price >= 10000000) {
//       // 1 crore = 10,000,000
//       return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
//     } else if (price >= 100000) {
//       // 1 lakh = 100,000
//       return "${(price / 100000).toStringAsFixed(1)} lakh"; // Format to 1 decimal place
//     } else {
//       return "₹${price.toString()}"; // For values less than 1 lakh
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     print("Match ID used in API request: $Id");
//     return Scaffold(
//       body: FutureBuilder<JoinContestModel>(
//         future: _fetchContestData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: const Color(0xffF0F1F5),
//                 child: const Center(child: CircularProgressIndicator()));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
//             return Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: const Color(0xffF0F1F5),
//                 child: const Center(child: Text('No data available')));
//           } else {
//             final contests = snapshot.data!.data;
//             return Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               color: const Color(0xffF0F1F5),
//               child: ListView.builder(
//                 itemCount: contests.length,
//                 itemBuilder: (context, index) {
//                   final contest = contests[index];
//                   return Column(
//                     children: [
//                       const SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: InkWell(
//                           onTap: () {
//                             print(matchName);
//                             print('id:..........$Id');
//                             print('contest.id is................${contest.id}');
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ContentInside(
//                                      matchName: matchName,
//                                      CId: contest.id,
//                                       Id: Id,
//                                       // Id: ,
//                                     )));
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(bottom: 10),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 10),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 border:
//                                 Border.all(color: Colors.white, width: 1)),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           "Prize Pool",
//                                           style: TextStyle(
//                                             color: Colors.black45,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                         Text(
//                                           formatMegaPrice(contest.contestDetails.pricePool),
//
//                                           // "₹${contest.contestDetails.pricePool}",
//                                           style: const TextStyle(
//                                             color: Color(0xff140B40),
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 22,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         // Display prize for rank 1 if `maxWinning` has at least one item
//                                         if (contest.maxWinning.isNotEmpty)
//                                           Normal2Text(
//                                             color: Colors.black,
//                                             text: "#1 - ₹${contest.maxWinning[0].prize}",
//                                           ),
//                                         // Display prize for rank 2 if `maxWinning` has more than one item
//                                         if (contest.maxWinning.length > 1)
//                                           Normal2Text(
//                                             color: Colors.black,
//                                             text: "#2 - ₹${contest.maxWinning[1].prize}",
//                                           ),
//                                       ],
//                                     )
//
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 LinearProgressIndicator(
//                                   minHeight: 2.5,
//                                   backgroundColor:
//                                   const Color(0xff777777).withOpacity(0.3),
//                                   valueColor: const AlwaysStoppedAnimation<Color>(
//                                       Color(0xff140B40)),
//                                   value: 1 - (contest.remainingSpots / 2000),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "${contest.remainingSpots} spots left",
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           color: Color(0xff140B40)),
//                                     ),
//                                     Text(
//                                       "${contest.contestDetails.totalParticipant} spots",
//                                       style: const TextStyle(
//                                           fontSize: 12, color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 9),
//                                 Container(
//                                   height: 34,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(9),
//                                     color: const Color(0xff140B40),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "₹${contest.contestDetails.entryFees}",
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<JoinContestModel> _fetchContestData() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse(
//
//             'https://batting-api-1.onrender.com/api/joinContest/mycontests?matchId=$Id'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       if (response.statusCode == 200) {
//         print(response.body);
//
//
//         return JoinContestModel.fromJson(jsonDecode(response.body));
//
//
//
//       } else {
//         throw Exception('Failed to fetch contest data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Error fetching contest data: $e');
//     }
//   }
// }
