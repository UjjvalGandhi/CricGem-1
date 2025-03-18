import 'dart:convert';
import 'package:batting_app/widget/contest_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/contestprovider.dart';
import '../widget/normal2.0.dart';
import '../widget/normaltext.dart';
import 'content_inside screen.dart';
import 'create_team.dart';

class Contestscrenn extends StatefulWidget {
  final String? Id;
  final String? MatchName;
  final String? firstMatch;
  final String? secMatch;
  final DateTime? date;
  final String? time;

  const Contestscrenn({
    super.key,
    this.Id,
    this.MatchName,
    this.firstMatch,
    this.secMatch,
    this.date,
    this.time,
  });

  @override
  State<Contestscrenn> createState() => _ContestscrennState();
}

class _ContestscrennState extends State<Contestscrenn> {
  final bool _isLoading = true;
  bool _isFloatingButtonVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isLoading;
    _fetchContestData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0) {
        if (_isFloatingButtonVisible) {
          setState(() {
            _isFloatingButtonVisible = false;
          });
        }
      } else {
        if (!_isFloatingButtonVisible) {
          setState(() {
            _isFloatingButtonVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchContestData() async {
    try {
      final contestProvider =
      Provider.of<ContestProvider>(context, listen: false);
      print("Fetching data for Match ID: ${widget.Id}"); // Debug
      await contestProvider.fetchContestData(widget.Id!);
    } catch (e) {
      print('Error fetching contest data: $e');
    }
  }

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
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);
    if (contestProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contestProvider.errorMessage != null) {
      return Center(child: Text(contestProvider.errorMessage!));
    }

    if (contestProvider.contestData == null ||
        contestProvider.contestData!.data.isEmpty) {
      return const Center(child: Text("No contests available."));
    }
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF0F1F5),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RefreshIndicator(
              onRefresh: _fetchContestData,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: contestProvider.contestData?.data.length ?? 0,
                itemBuilder: (context, index) {
                  final contest = contestProvider.contestData!.data[index];
                  return Column(
                    children: contest.contests.map((contestItem) {
                      final prizePool = contestItem.pricePool;
                      final totalAmount = contestItem.totalParticipant;
                      final remainingAmount = contestItem.remainingSpots;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Container(
                          height: 222,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage('assets/megabg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NormalText(
                                  color: Colors.black,
                                  text: contestItem.contestType.contestType,
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContentInside(
                                          time: widget.time,
                                          CId: contestItem.id,
                                          matchName: widget.MatchName,
                                          Id: widget.Id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 161,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                                    formatMegaPrice(prizePool.toInt()),
                                                    style: const TextStyle(
                                                      color: Color(0xff140B40),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  if (contestItem
                                                      .maxWinning.isNotEmpty)
                                                    Normal2Text(
                                                      color: Colors.black,
                                                      text:
                                                      "#1 - ${formatMegaPrice(int.parse(contestItem.maxWinning[0].prize))}",
                                                    ),
                                                  if (contestItem
                                                      .maxWinning.length >
                                                      1)
                                                    Normal2Text(
                                                      color: Colors.black,
                                                      text:
                                                      "#2 - ${formatMegaPrice(int.parse(contestItem.maxWinning[1].prize))}",
                                                    ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            minHeight: 2.5,
                                            backgroundColor:
                                            const Color(0xff777777)
                                                .withOpacity(0.3),
                                            valueColor:
                                            const AlwaysStoppedAnimation<
                                                Color>(
                                              Color(0xff140B40),
                                            ),
                                            value:
                                            (totalAmount - remainingAmount) /
                                                totalAmount,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "$remainingAmount spots left",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff140B40),
                                                ),
                                              ),
                                              Text(
                                                "$totalAmount spots total",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 9),
                                          Container(
                                            height: 34,
                                            width:
                                            MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(9),
                                              color: const Color(0xff140B40),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "₹${contestItem.entryFees}",
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
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            if (_isFloatingButtonVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  height: 42,
                  width: 278,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../db/app_db.dart';
// import '../model/ContestModel.dart'; // Ensure this is the correct file
// import '../widget/contestprovider.dart';
// import '../widget/normal2.0.dart';
// import '../widget/normaltext.dart';
// import 'content_inside screen.dart'; // Updated import name
// import 'create_team.dart';
//
// class Contestscrenn extends StatefulWidget {
//   final String? Id;
//   final String? MatchName;
//   final String? firstMatch;
//   final String? secMatch;
//   final DateTime? date;
//   final String? time;
//
//   const Contestscrenn(
//       {super.key,
//         this.Id,
//         this.MatchName,
//         this.firstMatch,
//         this.secMatch,
//         this.date,
//         this.time});
//
//   @override
//   State<Contestscrenn> createState() => _ContestscrennState();
// }
//
// class _ContestscrennState extends State<Contestscrenn> {
//   bool isvisible = false;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchContestData();
//   }
//   Future<void> fetchContestData() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final contestProvider =
//       Provider.of<ContestProvider>(context, listen: false);
//       await contestProvider.fetchContestData(widget.Id!);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   String formatMegaPrice(int price) {
//     if (price >= 10000000) {
//       return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
//     } else if (price >= 100000) {
//       return "${(price / 100000).toStringAsFixed(1)} lakh"; // Format to 1 decimal place
//     } else {
//       return "₹${price.toString()}"; // For values less than 1 lakh
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final contestProvider = Provider.of<ContestProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF0F1F5),
//       body: Stack(alignment: Alignment.bottomCenter, children: [
//         RefreshIndicator(
//           onRefresh: fetchContestData,
//           child: ListView.builder(
//             itemCount: contestProvider.contestData?.data.length ?? 0,
//             itemBuilder: (context, index) {
//               final contest = contestProvider.contestData!.data[index];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 80),
//                 child: Column(
//                   children: contest.contests.map((contestItem) {
//                     final prizePool = contestItem.pricePool;
//                     final totalAmount = contestItem.totalParticipant;
//                     final rememberAmount = contestItem.remainingSpots;
//
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                       child: Container(
//                         height: 222,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           image: const DecorationImage(
//                             image: AssetImage('assets/megabg.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               NormalText(
//                                 color: Colors.black,
//                                 text: contestItem.contestType.contestType,
//                               ),
//                               const SizedBox(height: 10),
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ContentInside(
//                                         time: widget.time,
//                                         CId: contestItem.id,
//                                         matchName: widget.MatchName,
//                                         Id: widget.Id,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: 161,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.05),
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(color: Colors.white, width: 1),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 const Text(
//                                                   "Prize Pool",
//                                                   style: TextStyle(
//                                                     color: Colors.black45,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   formatMegaPrice(prizePool),
//                                                   style: const TextStyle(
//                                                     color: Color(0xff140B40),
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 22,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 if (contestItem.maxWinning.isNotEmpty)
//                                                   Normal2Text(
//                                                     color: Colors.black,
//                                                     text: "#1 - ${formatMegaPrice(int.parse(contestItem.maxWinning[0].prize))}",
//                                                   ),
//                                                 if (contestItem.maxWinning.length > 1)
//                                                   Normal2Text(
//                                                     color: Colors.black,
//                                                     text: "#2 - ${formatMegaPrice(int.parse(contestItem.maxWinning[1].prize))}",
//                                                   ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                         const SizedBox(height: 10),
//                                         LinearProgressIndicator(
//                                           minHeight: 2.5,
//                                           backgroundColor: const Color(0xff777777).withOpacity(0.3),
//                                           valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff140B40)),
//                                           value: (totalAmount - rememberAmount) / totalAmount,
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "$rememberAmount spots left",
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                                 color: Color(0xff140B40),
//                                               ),
//                                             ),
//                                             Text(
//                                               "$totalAmount spots total",
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 9),
//                                         Container(
//                                           height: 34,
//                                           width: MediaQuery.of(context).size.width,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(9),
//                                             color: const Color(0xff140B40),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               "₹${contestItem.entryFees}",
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 30),
//           child: Container(
//             height: 42,
//             width: 278,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//                 border: Border.all(width: 0.5, color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(22),
//                 color: Colors.white),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CreateTeamScreen(
//                               isContestScreen: true,
//                               Id: "${widget.Id}",
//                               matchName: "${widget.MatchName}",
//                               firstMatch: "${widget.firstMatch}",
//                               secMatch: "${widget.secMatch}",
//                             ),
//                           ));
//                     },
//                     child: SizedBox(
//                       height: 25,
//                       width: 136,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             "assets/createteam.png",
//                             height: 18,
//                           ),
//                           const SizedBox(
//                             width: 7,
//                           ),
//                           const Center(
//                             child: Text(
//                               "Create Team",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/ContestModel.dart'; // Ensure this is the correct file
// import '../widget/normal2.0.dart';
// import '../widget/normaltext.dart';
// import 'content_inside screen.dart'; // Updated import name
// import 'create_team.dart';
//
// class Contestscrenn extends StatefulWidget {
//   final String? Id;
//   final String? MatchName;
//   final String? firstMatch;
//   final String? secMatch;
//   final DateTime? date;
//   final String? time;
//
//   const Contestscrenn(
//       {super.key,
//       this.Id,
//       this.MatchName,
//       this.firstMatch,
//       this.secMatch,
//       this.date,
//       this.time});
//
//   @override
//   State<Contestscrenn> createState() => _ContestscrennState();
// }
//
// class _ContestscrennState extends State<Contestscrenn> {
//   late Future<ContestModlel?> _futureData;
//   bool isvisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureData = contestDisplay();
//   }
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
//
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
//   Future<ContestModlel?> contestDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/match/displaycontests?matchId=${widget.Id}'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       print(widget.Id);
//       print('this is contest data from if part:- ${response.statusCode}');
//       if (response.statusCode == 200) {
//         print("this is contest data from if part::${response.body}");
//         return ContestModlel.fromJson(jsonDecode(response.body));
//       } else {
//         debugPrint('Failed to fetch contest data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching contest data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("this is from home screen::${widget.Id}");
//     return Scaffold(
//       body: Stack(alignment: Alignment.bottomCenter, children: [
//
//         Container(
//           color: const Color(0xffF0F1F5),
//           child: FutureBuilder<ContestModlel?>(
//             future: _futureData,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
//                 return const Center(child: Text('No data available'));
//               } else {
//                 final contestData = snapshot.data!;
//
//                 return ListView.builder(
//                   itemCount: contestData.data.length,
//                   itemBuilder: (context, index) {
//                     final contest = contestData.data[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 80),
//                       child: Column(
//                         children: contest.contests.map((contestItem) {
//                           final prizePool = contestItem.pricePool;
//                           final totalAmount = contestItem.totalParticipant;
//                           final rememberAmount = contestItem.remainingSpots;
//                           // final maxwinng = contestItem.maxWinning;
//                           // final firstprice = contestItem.maxWinning[index].prize;
//                           // print('frist ::${firstprice}');
//                           //
//                           // final secoundprice = contestItem.maxWinning[index].prize;
//                           // print('second:: ${secoundprice}');
//
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 15),
//                             child: Container(
//                               height: 222,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 image: const DecorationImage(
//                                   image: AssetImage('assets/megabg.png'),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     NormalText(
//                                         color: Colors.black,
//                                         text: contestItem.contestType.contestType,
//                                         // text: "Mega Contest "
//                                     ),
//                                     const SizedBox(height: 10),
//                                     InkWell(
//                                       onTap: () {
//                                         print('time:- ${widget.time}');
//                                         print('contestId:- ${contestItem.id}');
//                                         print('match name is:- ${widget.MatchName}');
//                                         print('id is:- ${widget.Id}');
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ContentInside(
//                                               time: widget.time,
//                                               CId: contestItem.id,
//                                               matchName: widget.MatchName,
//                                               Id: widget.Id,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         height: 161,
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white.withOpacity(0.05),
//                                           borderRadius: BorderRadius.circular(20),
//                                           border: Border.all(
//                                               color: Colors.white, width: 1),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                     children: [
//                                                       const Text(
//                                                         "Prize Pool",
//                                                         style: TextStyle(
//                                                           color: Colors.black45,
//                                                           fontSize: 12,
//                                                         ),
//                                                       ),
//
//
//                                                       Text(
//                                                         formatMegaPrice(prizePool),
//
//                                                         // "₹$prizePool",
//                                                         style: const TextStyle(
//                                                           color: Color(
//                                                               0xff140B40),
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           fontSize: 22,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   // Column(
//                                                   //   children: [
//                                                   //     // Display prize for rank 1 if `maxwinng` is not null and has at least one item
//                                                   //     if (maxwinng != null && maxwinng!.isNotEmpty && maxwinng!.length > 0)
//                                                   //       Normal2Text(
//                                                   //         color: Colors.black,
//                                                   //         text: "#1 - ₹${maxwinng![0].prize}",
//                                                   //       ),
//                                                   //     // Display prize for rank 2 if `maxwinng` is not null and has more than one item
//                                                   //     if (maxwinng != null && maxwinng!.length > 1)
//                                                   //       Normal2Text(
//                                                   //         color: Colors.black,
//                                                   //         text: "#2 - ₹${maxwinng![1].prize}",
//                                                   //       ),
//                                                   //   ],
//                                                   // )
//                                                   Column(
//                                                     children: [
//                                                       // Display prize for rank 1 if `maxWinning` has at least one item
//                                                       if (contestItem.maxWinning
//                                                               .isNotEmpty)
//                                                         Normal2Text(
//                                                           color: Colors.black,
//                                                           text:
//                                                           "#1 - ${formatMegaPrice(int.parse(contestItem.maxWinning[0].prize))}",
//
//                                                           // "#1 - ₹${contestItem.maxWinning[0].prize}",
//                                                         ),
//                                                       // Display prize for rank 2 if `maxWinning` has more than one item
//                                                       if (contestItem.maxWinning
//                                                                   .length >
//                                                               1)
//                                                         Normal2Text(
//                                                           color: Colors.black,
//                                                           text:
//                                                               "#2 - ${formatMegaPrice(int.parse(contestItem.maxWinning[1].prize))}",
//                                                         ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 10),
//                                               LinearProgressIndicator(
//                                                 minHeight: 2.5,
//                                                 backgroundColor:
//                                                     const Color(0xff777777)
//                                                         .withOpacity(0.3),
//                                                 valueColor:
//                                                     const AlwaysStoppedAnimation<
//                                                         Color>(
//                                                   Color(0xff140B40),
//                                                 ),
//                                                 value: (totalAmount -
//                                                         rememberAmount) /
//                                                     totalAmount,
//                                               ),
//                                               const SizedBox(height: 6),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "$rememberAmount spots left",
//                                                     style: const TextStyle(
//                                                       fontSize: 12,
//                                                       color:
//                                                           Color(0xff140B40),
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     "$totalAmount spots total",
//                                                     style: const TextStyle(
//                                                       fontSize: 12,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 9),
//                                               Container(
//                                                 height: 34,
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(9),
//                                                   color: const Color(0xff140B40),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     "₹${contestItem.entryFees}",
//                                                     style: const TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.white,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 80),
//           child: Visibility(
//             visible: isvisible,
//             child: Container(
//               height: 315,
//               width: 288,
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16), color: Colors.white),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Enter Quick Join Mode",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 11,
//                             )
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Create A Contest",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 11,
//                             )
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Enter Contest Code",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 11,
//                             )
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 18,
//                     ),
//                     SizedBox(
//                         height: 16,
//                         child: Row(
//                           children: [
//                             const Text(
//                               "Categories",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 3, left: 5),
//                               child: Container(
//                                 height: 1,
//                                 width: 170,
//                                 color: Colors.grey.shade300,
//                               ),
//                             )
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Mega Contest",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "1  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Specially For You",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "5  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "PowerPlay",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "2  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "PowerPlay",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "2  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "PowerPlay",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "2  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 7,
//                     ),
//                     const SizedBox(
//                         height: 21,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "PowerPlay",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             Text(
//                               "2  ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         )),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 30),
//           child: Container(
//             height: 42,
//             width: 278,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//                 border: Border.all(width: 0.5, color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(22),
//                 color: Colors.white),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // InkWell(
//                 //   onTap: () {
//                 //     setState(() {
//                 //       isvisible = !isvisible;
//                 //     });
//                 //   },
//                 //   child: SizedBox(
//                 //     height: 32,
//                 //     width: 105,
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       children: [
//                 //         Image.asset(
//                 //           "assets/contests.png",
//                 //           height: 18,
//                 //         ),
//                 //         SizedBox(
//                 //           width: 7,
//                 //         ),
//                 //         const Text(
//                 //           "Contests",
//                 //           style: TextStyle(
//                 //               fontSize: 14,
//                 //               fontWeight: FontWeight.w600,
//                 //               color: Colors.black),
//                 //         )
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 // Container(
//                 //   height: 32,
//                 //   width: 1,
//                 //   color: Colors.grey.shade300,
//                 // ),
//                 Center(
//                   child: InkWell(
//                     onTap: () {
//                       print("this is useed in create team api ........check 1:${widget.Id}");
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CreateTeamScreen(
//                               isContestScreen:true,
//                               Id: "${widget.Id}",
//                               matchName: "${widget.MatchName}",
//                               firstMatch: "${widget.firstMatch}",
//                               secMatch: "${widget.secMatch}",
//                             ),
//                           ));
//                     },
//                     child: SizedBox(
//                       height: 25,
//                       width: 136,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             "assets/createteam.png",
//                             height: 18,
//                           ),
//                           const SizedBox(
//                             width: 7,
//                           ),
//                           const Center(
//                             child: Text(
//                               "Create Team",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
