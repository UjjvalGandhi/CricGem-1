import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widget/myteamprovider.dart';
import 'myteam_edit.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/normal2.0.dart';

class Myteamlist extends StatefulWidget {
  final String? MatchID;
  final String? matchName;
  final bool ismyMatches;

  const Myteamlist({super.key, this.MatchID, this.matchName, this.ismyMatches = false});

  @override
  _MyteamlistState createState() => _MyteamlistState();
}

class _MyteamlistState extends State<Myteamlist> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MyTeamProvider>(context, listen: false);
    provider.fetchMyTeamData(widget.MatchID); // Fetch data every time the widget is built.
  }

  String formatMegaPrice(int price) {
    if (price >= 10000000) {
      double croreValue = price / 10000000;
      return croreValue % 1 == 0
          ? "${croreValue.toStringAsFixed(0)} cr"
          : "${croreValue.toStringAsFixed(1)} cr";
    } else if (price >= 100000) {
      double lakhValue = price / 100000;
      return lakhValue % 1 == 0
          ? "${lakhValue.toStringAsFixed(0)} lakh"
          : "${lakhValue.toStringAsFixed(1)} lakh";
    } else {
      return "₹${price.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      appBar: widget.ismyMatches
          ? CustomAppBar(
        title: "My Teams",
        onBackButtonPressed: () => Navigator.pop(context),
      )
          : null,
      body: Consumer<MyTeamProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              await provider.fetchMyTeamData(widget.MatchID); // Fetch on pull-to-refresh
            },
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : provider.myTeamList == null || provider.myTeamList!.data.isEmpty
                ? const Center(child: Text('No teams available'))
                : ListView.builder(
              itemCount: provider.myTeamList?.data.length ?? 0,
              itemBuilder: (context, index) {
                final team = provider.myTeamList!.data[index];
                final lastFourDigits = team.id.substring(team.id.length - 4);
                final teamLabel = team.team_label ?? '';
                final appId = "BOSS $lastFourDigits $teamLabel";
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        print('team id is............${team.id}');
                        print('appid is..............$appId');
                        print('match name is:..............${widget.matchName}');
                        print('match id is.......................${widget.MatchID}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyTeamEdit(
                              teamId: team.id,
                              matchId:widget.MatchID,
                              appId: appId,
                              matchName: "${widget.matchName}",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                padding: const EdgeInsets.all(15),
                                height: 167,
                                width:
                                MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "BOSS $lastFourDigits $teamLabel",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children:[
                                            Image.network(
                                              team.team1Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
                                              height: 30,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/remove.png', height: 26); // Default image
                                              },
                                            ),
                                            const SizedBox(width: 5,),
                                            const Text("vs"),
                                            const SizedBox(width: 5,),
                                            Image.network(
                                              team.team2Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
                                              height: 30,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/default_team_image.png', height: 26); // Default image
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Divider(
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 43,
                                              width: 43,
                                              child:  Image.network(
                                                team.captain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
                                                height: 36,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset('assets/dummy_player.png', height: 26); // Default image

                                                  // return Image.asset('assets/default_team_image.png', height: 26); // Default image
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xffF0F1F5),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(2),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  team.captain?.playerName ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 43,
                                              width: 43,
                                              child:  Image.network(
                                                team.vicecaptain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
                                                height: 36,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset('assets/dummy_player.png', height: 26); // Default image
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 2),
                                              decoration:
                                              BoxDecoration(
                                                color: const Color(
                                                    0xffF0F1F5),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(2),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  team.vicecaptain?.playerName ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    color:
                                                    Colors.black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
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
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                height: 34,
                                width:
                                MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: const Color(0xff010101)
                                      .withOpacity(0.03),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Normal2Text(
                                      color: Colors.black,
                                      text:
                                      "WK ${team.wicketkeeper ?? ''}",
                                    ),
                                    Normal2Text(
                                      color: Colors.black,
                                      text: "BAT ${team.batsman ?? ''}",
                                    ),
                                    Normal2Text(
                                      color: Colors.black,
                                      text:
                                      "AR ${team.allrounder ?? ''}",
                                    ),
                                    Normal2Text(
                                      color: Colors.black,
                                      text: "BOWL ${team.bowler ?? ''}",
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
                );
                // return Column(
                //   children: [
                //     const SizedBox(height: 15),
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => MyTeamEdit(
                //               teamId: team.id,
                //               matchId: widget.MatchID,
                //               appId: appId,
                //               matchName: widget.matchName ?? '',
                //             ),
                //           ),
                //         );
                //       },
                //       child: Column(
                //         children: [
                //           Stack(
                //             alignment: Alignment.bottomCenter,
                //             children: [
                //               Container(
                //                 margin: const EdgeInsets.symmetric(horizontal: 15),
                //                 padding: const EdgeInsets.all(15),
                //                 height: 167,
                //                 width: MediaQuery.of(context).size.width,
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(color: Colors.grey.shade300),
                //                   borderRadius: BorderRadius.circular(20),
                //                 ),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(
                //                           "BOSS $lastFourDigits $teamLabel",
                //                           style: const TextStyle(
                //                             fontSize: 14,
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.w600,
                //                           ),
                //                         ),
                //                         Row(
                //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                           children: [
                //                             Image.network(
                //                               team.team1Logo ?? 'https://via.placeholder.com/26',
                //                               height: 30,
                //                               errorBuilder: (context, error, stackTrace) {
                //                                 return Image.asset('assets/remove.png', height: 26);
                //                               },
                //                             ),
                //                             const SizedBox(width: 5),
                //                             const Text("vs"),
                //                             const SizedBox(width: 5),
                //                             Image.network(
                //                               team.team2Logo ?? 'https://via.placeholder.com/26',
                //                               height: 30,
                //                               errorBuilder: (context, error, stackTrace) {
                //                                 return Image.asset('assets/default_team_image.png',
                //                                     height: 26);
                //                               },
                //                             ),
                //                           ],
                //                         ),
                //                       ],
                //                     ),
                //                     const SizedBox(height: 5),
                //                     Divider(height: 1, color: Colors.grey.shade300),
                //                     const SizedBox(height: 12),
                //                     Row(
                //                       mainAxisAlignment: MainAxisAlignment.start,
                //                       children: [
                //                         const Spacer(),
                //                         Column(
                //                           children: [
                //                             SizedBox(
                //                               height: 43,
                //                               width: 43,
                //                               child: Image.network(
                //                                 team.captain?.playerPhoto ?? 'https://via.placeholder.com/26',
                //                                 height: 36,
                //                                 errorBuilder: (context, error, stackTrace) {
                //                                   return Image.asset('assets/dummy_player.png',
                //                                       height: 26);
                //                                 },
                //                               ),
                //                             ),
                //                             Container(
                //                               padding: const EdgeInsets.symmetric(
                //                                   horizontal: 15, vertical: 2),
                //                               decoration: BoxDecoration(
                //                                 color: const Color(0xffF0F1F5),
                //                                 borderRadius: BorderRadius.circular(2),
                //                               ),
                //                               child: Center(
                //                                 child: Text(
                //                                   overflow: TextOverflow.ellipsis,
                //                                   team.captain?.playerName ?? '',
                //                                   textAlign: TextAlign.center,
                //                                   style: const TextStyle(
                //                                     fontSize: 9,
                //                                     color: Colors.black,
                //                                     fontWeight: FontWeight.w400,
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         const SizedBox(width: 10),
                //                         Column(
                //                           children: [
                //                             SizedBox(
                //                               height: 43,
                //                               width: 43,
                //                               child: Image.network(
                //                                 team.vicecaptain?.playerPhoto ??
                //                                     'https://via.placeholder.com/26',
                //                                 height: 36,
                //                                 errorBuilder: (context, error, stackTrace) {
                //                                   return Image.asset('assets/dummy_player.png',
                //                                       height: 26);
                //                                 },
                //                               ),
                //                             ),
                //                             Container(
                //                               padding: const EdgeInsets.symmetric(
                //                                   horizontal: 15, vertical: 2),
                //                               decoration: BoxDecoration(
                //                                 color: const Color(0xffF0F1F5),
                //                                 borderRadius: BorderRadius.circular(2),
                //                               ),
                //                               child: Center(
                //                                 child: Text(
                //                                   overflow: TextOverflow.ellipsis,
                //                                   team.vicecaptain?.playerName ?? '',
                //                                   style: const TextStyle(
                //                                     fontSize: 9,
                //                                     color: Colors.black,
                //                                     fontWeight: FontWeight.w400,
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // );
              },
            ),
          );
        },
      ),
    );
  }
}
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../model/JoinContestModel.dart';
// import '../model/PlayerModel.dart';
// import '../widget/myteamprovider.dart';
// import 'myteam_edit.dart';
// import '../widget/appbar_for_setting.dart';
// import '../widget/normal2.0.dart';
//
// class Myteamlist extends StatelessWidget {
//   final String? MatchID;
//   final String? matchName;
//   final bool ismyMatches;
//
//   const Myteamlist({super.key, this.MatchID, this.matchName, this.ismyMatches = false});
//
//   // String formatMegaPrice(int price) {
//   //   if (price >= 10000000) {
//   //     return "${(price / 10000000).toStringAsFixed(1)} cr";
//   //   } else if (price >= 100000) {
//   //     return "${(price / 100000).toStringAsFixed(1)} lakh";
//   //   } else {
//   //     return "₹${price.toString()}";
//   //   }
//   // }
//   String formatMegaPrice(int price) {
//     if (price >= 10000000) {
//       // 1 crore = 10,000,000
//       double croreValue = price / 10000000;
//       return croreValue % 1 == 0
//           ? "${croreValue.toStringAsFixed(0)} cr"
//           : "${croreValue.toStringAsFixed(1)} cr";
//     } else if (price >= 100000) {
//       // 1 lakh = 100,000
//       double lakhValue = price / 100000;
//       return lakhValue % 1 == 0
//           ? "${lakhValue.toStringAsFixed(0)} lakh"
//           : "${lakhValue.toStringAsFixed(1)} lakh";
//     } else {
//       return "₹${price.toString()}"; // For values less than 1 lakh
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<MyTeamProvider>(context);
//
//     // Fetch data when the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (provider.myTeamList == null && !provider.isLoading) {
//         provider.fetchMyTeamData(MatchID);
//       }
//     });
//
//     return Scaffold(
//       backgroundColor:const Color(0xffF0F1F5),
//       appBar: ismyMatches
//           ? CustomAppBar(
//         title: "My Teams",
//         onBackButtonPressed: () => Navigator.pop(context),
//       )
//           : null,
//       body:
//       // provider.isLoading
//       //     ? const Center(child: CircularProgressIndicator())
//       //     : provider.errorMessage != null
//       //     ? Center(child: Text(provider.errorMessage!))
//       //     : provider.myTeamList == null || provider.myTeamList!.data.isEmpty
//       //     ? RefreshIndicator(backgroundColor: Colors.white,
//       //     onRefresh: ()async{
//       //       await provider.fetchMyTeamData(MatchID);
//       //     },child: const Center(child: Text('No teams available')))
//       //     :
//     provider.isLoading
//     ? const Center(child: CircularProgressIndicator())
//         : provider.errorMessage != null
//     ? Center(child: Text(provider.errorMessage!))
//         : RefreshIndicator(
//     backgroundColor: Colors.white,
//     onRefresh: () async {
//     await provider.fetchMyTeamData(MatchID);
//     },
//     child: provider.myTeamList == null || provider.myTeamList!.data.isEmpty
//     ? const Center(child: Text('No teams available'))
//         :
//       RefreshIndicator(
//         backgroundColor: Colors.white,
//         onRefresh: ()async{
//           await provider.fetchMyTeamData(MatchID);
//         },
//         child: ListView.builder(
//           itemCount: provider.myTeamList?.data.length ?? 0,
//           itemBuilder: (context, index) {
//             final team = provider.myTeamList!.data[index];
//             final lastFourDigits = team.id.substring(team.id.length - 4);
//             final teamLabel = team.team_label ?? '';
//             final appId = "BOSS $lastFourDigits $teamLabel";
//             return Column(
//               children: [
//                 const SizedBox(height: 15),
//                 InkWell(
//                   onTap: () {
//                     print('team id is............${team.id}');
//                     print('appid is..............$appId');
//                     print('match name is:..............${matchName}');
//                     print('match id is.......................${MatchID}');
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyTeamEdit(
//                           teamId: team.id,
//                           matchId:MatchID,
//                           appId: appId,
//                           matchName: "${matchName}",
//                         ),
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Stack(
//                         alignment: Alignment.bottomCenter,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 15),
//                             padding: const EdgeInsets.all(15),
//                             height: 167,
//                             width:
//                             MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                   color: Colors.grey.shade300),
//                               borderRadius:
//                               BorderRadius.circular(20),
//                             ),
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "BOSS $lastFourDigits $teamLabel",
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment
//                                           .spaceEvenly,
//                                       children:[
//                                         Image.network(
//                                           team.team1Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                           height: 30,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return Image.asset('assets/remove.png', height: 26); // Default image
//                                           },
//                                         ),
//                                         const SizedBox(width: 5,),
//                                         const Text("vs"),
//                                         const SizedBox(width: 5,),
//                                         Image.network(
//                                           team.team2Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                           height: 30,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return Image.asset('assets/default_team_image.png', height: 26); // Default image
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Divider(
//                                     height: 1,
//                                     color: Colors.grey.shade300),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.start,
//                                   children: [
//                                     const Spacer(),
//                                     Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 43,
//                                           width: 43,
//                                           child:  Image.network(
//                                             team.captain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                             height: 36,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Image.asset('assets/dummy_player.png', height: 26); // Default image
//
//                                               // return Image.asset('assets/default_team_image.png', height: 26); // Default image
//                                             },
//                                           ),
//                                         ),
//                                         Container(
//                                           padding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 15,
//                                               vertical: 2),
//                                           decoration: BoxDecoration(
//                                             color: const Color(
//                                                 0xffF0F1F5),
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(2),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               overflow: TextOverflow.ellipsis,
//                                               team.captain?.playerName ?? '',
//                                               textAlign: TextAlign.center,
//                                               style: const TextStyle(
//                                                 fontSize: 9,
//                                                 color: Colors.black,
//                                                 fontWeight:
//                                                 FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 43,
//                                           width: 43,
//                                           child:  Image.network(
//                                             team.vicecaptain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
//                                             height: 36,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Image.asset('assets/dummy_player.png', height: 26); // Default image
//                                             },
//                                           ),
//                                         ),
//                                         Container(
//                                           padding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 15,
//                                               vertical: 2),
//                                           decoration:
//                                           BoxDecoration(
//                                             color: const Color(
//                                                 0xffF0F1F5),
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(2),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               overflow: TextOverflow.ellipsis,
//                                               team.vicecaptain?.playerName ?? '',
//                                               style: const TextStyle(
//                                                 fontSize: 9,
//                                                 color:
//                                                 Colors.black,
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 15),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15),
//                             height: 34,
//                             width:
//                             MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               color: const Color(0xff010101)
//                                   .withOpacity(0.03),
//                               borderRadius: const BorderRadius.only(
//                                 bottomRight: Radius.circular(20),
//                                 bottomLeft: Radius.circular(20),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Normal2Text(
//                                   color: Colors.black,
//                                   text:
//                                   "WK ${team.wicketkeeper ?? ''}",
//                                 ),
//                                 Normal2Text(
//                                   color: Colors.black,
//                                   text: "BAT ${team.batsman ?? ''}",
//                                 ),
//                                 Normal2Text(
//                                   color: Colors.black,
//                                   text:
//                                   "AR ${team.allrounder ?? ''}",
//                                 ),
//                                 Normal2Text(
//                                   color: Colors.black,
//                                   text: "BOWL ${team.bowler ?? ''}",
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//             // return Padding(
//             //   padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
//             //   child: InkWell(
//             //     onTap: () {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (context) => MyTeamEdit(
//             //             teamId: team.id,
//             //             matchId: MatchID,
//             //             appId: appId,
//             //             matchName: matchName!,
//             //           ),
//             //         ),
//             //       );
//             //     },
//             //     child: TeamCard(team: team, appId: appId),
//             //   ),
//             // );
//           },
//         ),
//       ),
//     ));
//   }
// }


// //
// // import 'dart:convert';
// // import 'package:batting_app/model/totalplayerpointmodal.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:http/http.dart' as http;
// // import '../db/app_db.dart';
// // import '../model/MyTeamListModel.dart';
// // import '../widget/appbar_for_setting.dart';
// // import '../widget/appbartext.dart';
// // import '../widget/normal2.0.dart';
// // import 'myteam_edit.dart';
// // class PointsStorage {
// //   List<PointsResponse> _pointsData = [];
// //   void storePoints(List<PointsResponse> pointsData) {
// //     _pointsData = pointsData;
// //   }
// //   List<PointsResponse> getPoints() {
// //     return _pointsData;
// //   }
// // }
// // final pointsStorage = PointsStorage();
// // class Myteamlist extends StatefulWidget {
// //   final String? MatchID;
// //   final String? matchName;
// //   final bool ismyMatches;
// //   const Myteamlist({super.key, this.MatchID, this.matchName,this.ismyMatches = false});
// //   @override
// //   State<Myteamlist> createState() => _MyteamlistState();
// // }
// // class _MyteamlistState extends State<Myteamlist> {
// //   late Future<MyTeamLIstModel?> _futureDataTeam;
// //   late Future<PointsResponse?> _futurePlayerTotalPoints;
// //   var totalpoints;
// //   @override
// //   void initState() {
// //     super.initState();
// //     _futureDataTeam = matchDisplay();
// //     totalpoints;
// //   }
// //   String formatMegaPrice(int price) {
// //     if (price >= 10000000) {
// //       // 1 crore = 10,000,000
// //       return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
// //     } else if (price >= 100000) {
// //       // 1 lakh = 100,000
// //       return "${(price / 100000).toStringAsFixed(1)} lakh"; // Format to 1 decimal place
// //     } else {
// //       return "₹${price.toString()}"; // For values less than 1 lakh
// //     }
// //   }
// //   Future<MyTeamLIstModel?> matchDisplay() async {
// //     try {
// //       String? token = await AppDB.appDB.getToken();
// //       final response = await http.get(
// //         Uri.parse(
// //             'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=${widget.MatchID}'),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Accept": "application/json",
// //           "Authorization": "$token",
// //         },
// //       );
// //       if (response.statusCode == 200) {
// //         print('my matchv : ${widget.MatchID}');
// //         print("this is respons of My team List ::${response.body}");
// //         return MyTeamLIstModel.fromJson(jsonDecode(response.body));
// //       } else {
// //         debugPrint('Failed to fetch team data: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching team data: $e');
// //       return null;
// //     }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     print("thia id used in my teamlist::${widget.MatchID}");
// //     return Scaffold(
// //       appBar: widget.ismyMatches ?
// //       CustomAppBar(
// //         title: "My Teams",
// //         onBackButtonPressed: () {
// //           // Custom behavior for back button (if needed)
// //           Navigator.pop(context);
// //         },
// //       )
// //           : null,
// //       body: FutureBuilder<MyTeamLIstModel?>(
// //         future: _futureDataTeam,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Container(
// //                 height: MediaQuery.of(context).size.height,
// //                 width: MediaQuery.of(context).size.width,
// //                 color: const Color(0xffF0F1F5),
// //                 child: const Center(child: CircularProgressIndicator()));
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data?.data.isEmpty == true) {
// //             return Container(
// //                 height: MediaQuery.of(context).size.height,
// //                 width: MediaQuery.of(context).size.width,
// //                 color: const Color(0xffF0F1F5),
// //                 child: const Center(child: Text('No teams available')));
// //           } else {
// //             final myTeamData = snapshot.data!.data;
// //             print("this is my team list data ::$myTeamData");
// //             return Container(
// //               height: MediaQuery.of(context).size.height,
// //               width: MediaQuery.of(context).size.width,
// //               color: const Color(0xffF0F1F5),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     Column(
// //                       children: myTeamData.asMap().entries.map((entry)
// //                       {
// //                         int index = entry.key;
// //                         var team = entry.value;
// //                         String lastFourDigits =
// //                             team.id.substring(team.id.length - 4);
// //                         String teamLabel = '${team.team_label}';
// //                         String appId = "BOSS $lastFourDigits $teamLabel";
// //                         return Column(
// //                           children: [
// //                             const SizedBox(height: 15),
// //                             InkWell(
// //                               onTap: () {
// //                                 print('team id is............${team.id}');
// //                                 print('appid is..............$appId');
// //                                 print('match name is:..............${widget.matchName}');
// //                                 print('match id is.......................${widget.MatchID}');
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => MyTeamEdit(
// //                                       teamId: team.id,
// //                                       matchId: widget.MatchID,
// //                                       appId: appId,
// //                                       matchName: "${widget.matchName}",
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                               child: Column(
// //                                 children: [
// //                                   Stack(
// //                                     alignment: Alignment.bottomCenter,
// //                                     children: [
// //                                       Container(
// //                                         margin: const EdgeInsets.symmetric(
// //                                             horizontal: 15),
// //                                         padding: const EdgeInsets.all(15),
// //                                         height: 167,
// //                                         width:
// //                                             MediaQuery.of(context).size.width,
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.white,
// //                                           border: Border.all(
// //                                               color: Colors.grey.shade300),
// //                                           borderRadius:
// //                                               BorderRadius.circular(20),
// //                                         ),
// //                                         child: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: [
// //                                             Row(
// //                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                               children: [
// //                                                 Text(
// //                                                   "BOSS $lastFourDigits $teamLabel",
// //                                                   style: const TextStyle(
// //                                                     fontSize: 14,
// //                                                     color: Colors.black,
// //                                                     fontWeight: FontWeight.w600,
// //                                                   ),
// //                                                 ),
// //                                                 Row(
// //                                                   mainAxisAlignment:
// //                                                   MainAxisAlignment
// //                                                       .spaceEvenly,
// //                                                   children:[
// //                                                     Image.network(
// //                                                       team.team1Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
// //                                                       height: 30,
// //                                                       errorBuilder: (context, error, stackTrace) {
// //                                                         return Image.asset('assets/remove.png', height: 26); // Default image
// //                                                       },
// //                                                     ),
// //                                                     const SizedBox(width: 5,),
// //                                                     const Text("vs"),
// //                                                     const SizedBox(width: 5,),
// //                                                     Image.network(
// //                                                       team.team2Logo ?? 'https://via.placeholder.com/26', // Placeholder URL
// //                                                       height: 30,
// //                                                       errorBuilder: (context, error, stackTrace) {
// //                                                         return Image.asset('assets/default_team_image.png', height: 26); // Default image
// //                                                       },
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                             const SizedBox(height: 5),
// //                                             Divider(
// //                                                 height: 1,
// //                                                 color: Colors.grey.shade300),
// //                                             const SizedBox(height: 12),
// //                                             Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment.start,
// //                                               children: [
// //                                                 const Spacer(),
// //                                                 Column(
// //                                                   children: [
// //                                                     SizedBox(
// //                                                       height: 43,
// //                                                       width: 43,
// //                                                       child:  Image.network(
// //                                                        team.captain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
// //                                                         height: 36,
// //                                                         errorBuilder: (context, error, stackTrace) {
// //                                                           return Image.asset('assets/dummy_player.png', height: 26); // Default image
// //
// //                                                           // return Image.asset('assets/default_team_image.png', height: 26); // Default image
// //                                                         },
// //                                                       ),
// //                                                     ),
// //                                                     Container(
// //                                                       padding:
// //                                                           const EdgeInsets.symmetric(
// //                                                               horizontal: 15,
// //                                                               vertical: 2),
// //                                                       decoration: BoxDecoration(
// //                                                         color: const Color(
// //                                                             0xffF0F1F5),
// //                                                         borderRadius:
// //                                                             BorderRadius
// //                                                                 .circular(2),
// //                                                       ),
// //                                                       child: Center(
// //                                                         child: Text(
// //                                                           overflow: TextOverflow.ellipsis,
// //                                                           team.captain?.playerName ?? '',
// //                                                           textAlign: TextAlign.center,
// //                                                           style: const TextStyle(
// //                                                             fontSize: 9,
// //                                                             color: Colors.black,
// //                                                             fontWeight:
// //                                                                 FontWeight.w400,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                                 const SizedBox(width: 10),
// //                                                 Column(
// //                                                   children: [
// //                                                     SizedBox(
// //                                                       height: 43,
// //                                                       width: 43,
// //                                                       child:  Image.network(
// //                                                         team.vicecaptain?.playerPhoto ?? 'https://via.placeholder.com/26', // Placeholder URL
// //                                                         height: 36,
// //                                                         errorBuilder: (context, error, stackTrace) {
// //                                                           return Image.asset('assets/dummy_player.png', height: 26); // Default image
// //                                                         },
// //                                                       ),
// //                                                     ),
// //                                                     Container(
// //                                                       padding:
// //                                                       const EdgeInsets.symmetric(
// //                                                           horizontal: 15,
// //                                                           vertical: 2),
// //                                                       decoration:
// //                                                           BoxDecoration(
// //                                                         color: const Color(
// //                                                             0xffF0F1F5),
// //                                                         borderRadius:
// //                                                             BorderRadius
// //                                                                 .circular(2),
// //                                                       ),
// //                                                       child: Center(
// //                                                         child: Text(
// //                                                           overflow: TextOverflow.ellipsis,
// //                                                           team.vicecaptain?.playerName ?? '',
// //                                                           style: const TextStyle(
// //                                                             fontSize: 9,
// //                                                             color:
// //                                                                 Colors.black,
// //                                                             fontWeight:
// //                                                                 FontWeight
// //                                                                     .w400,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       Container(
// //                                         margin: const EdgeInsets.symmetric(
// //                                             horizontal: 15),
// //                                         padding: const EdgeInsets.symmetric(
// //                                             horizontal: 15),
// //                                         height: 34,
// //                                         width:
// //                                             MediaQuery.of(context).size.width,
// //                                         decoration: BoxDecoration(
// //                                           color: const Color(0xff010101)
// //                                               .withOpacity(0.03),
// //                                           borderRadius: const BorderRadius.only(
// //                                             bottomRight: Radius.circular(20),
// //                                             bottomLeft: Radius.circular(20),
// //                                           ),
// //                                         ),
// //                                         child: Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             Normal2Text(
// //                                               color: Colors.black,
// //                                               text:
// //                                                   "WK ${team.wicketkeeper ?? ''}",
// //                                             ),
// //                                             Normal2Text(
// //                                               color: Colors.black,
// //                                               text: "BAT ${team.batsman ?? ''}",
// //                                             ),
// //                                             Normal2Text(
// //                                               color: Colors.black,
// //                                               text:
// //                                                   "AR ${team.allrounder ?? ''}",
// //                                             ),
// //                                             Normal2Text(
// //                                               color: Colors.black,
// //                                               text: "BOWL ${team.bowler ?? ''}",
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }).toList(),
// //                     ),
// //                     const SizedBox(
// //                       height: 20,
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
//
// // child: Image.asset(
// //   'assets/rohilleft.png',
// //   fit: BoxFit.fill,
// // ),
//
// // child: Image.asset(
// //   'assets/nzright.png',
// //   fit: BoxFit.fill,
// // ),
// // return Image.asset('assets/default_team_image.png', height: 26); // Default image
//
// // String formatMegaPrice(int price) {
// //   if (price >= 10000000) {
// //     // 1 crore = 10,000,000
// //     return "${(price / 10000000).toStringAsFixed(1)} cr"; // Format to 1 decimal place
// //   } else if (price >= 100000) {
// //     // 1 lakh = 100,000
// //     return "${(price / 100000).toStringAsFixed(0)} lakh"; // Format to whole number
// //   } else {
// //     return "₹${price.toString()}"; // For values less than 1 lakh
// //   }
// // }
// // PreferredSize(
// //   preferredSize:  Size.fromHeight(60.0.h),
// //   child: ClipRRect(
// //     child: AppBar(
// //       leading: Container(),
// //       surfaceTintColor: const Color(0xffF0F1F5),
// //       backgroundColor: const Color(0xffF0F1F5),
// //       elevation: 0,
// //       centerTitle: true,
// //       flexibleSpace: Container(
// //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
// //         height: 90.h,
// //         width: MediaQuery.of(context).size.width,
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Color(0xff1D1459), Color(0xff140B40)],
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             SizedBox(height: 50.h),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 InkWell(
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                   },
// //                   child: Icon(
// //                     Icons.arrow_back,
// //                     color: Colors.white,
// //                     size: 24.sp,
// //                   ),
// //                 ),
// //                 AppBarText(color: Colors.white, text: "My Teams"),
// //                 SizedBox(width: 30),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     ),
// //   ),
// // )
//
// // Column(
// //   children: [
// //     Normal2Text(
// //         color: Colors.black,
// //         text: "Points"),
// //      Text(
// //        totalpoints?.toString() ?? "0",                                                      // "100",
// //       style: TextStyle(
// //         fontSize: 22,
// //         color: Colors.black,
// //         fontWeight:
// //             FontWeight.w600,
// //       ),
// //     ),
// //   ],
// // ),
//
//
// // InkWell(
// //   onTap: (){
// //
// //   },
// //   child: const Icon(Icons.share,
// //       size: 18),
// // ),
//
//
// // Future<PointsResponse?> playerTotalPoints() async {
// //   try {
// //     String? token = await AppDB.appDB.getToken();
// //     final response = await http.get(
// //       Uri.parse(
// //        "https://batting-api-1.onrender.com/api/playerpoints/playerPointByMatch?matchId=${widget.MatchID}"),
// //       headers: {
// //         "Content-Type": "application/json",
// //         "Accept": "application/json",
// //         "Authorization": "$token",
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       // var data = response.body;
// //       final dynamic jsonData = jsonDecode(response.body);
// //       print('my matchv : ${widget.MatchID}');
// //       print("this is respons of My team List ::${response.body}");
// //
// //       final data = PointsResponse.fromJson(jsonData);
// //       // totalpoints = data.data;
// //
// //       setState(() {
// //         if (data.data.isNotEmpty) {
// //           // Assuming data.data is a List<PlayerPointsData>
// //           totalpoints = data.data[0].totalPoints; // Get totalPoints from the first item
// //         } else {
// //           totalpoints = 0; // Default value if no data
// //         }
// //
// //         pointsStorage.storePoints(totalpoints);
// //         print('points are showing right or not:- ${totalpoints}');
// //         totalpoints;
// //       });
// //
// //       // return PointsResponse.fromJson(jsonDecode(response.body));
// //       return data;
// //     } else {
// //       debugPrint('Failed to fetch team data: ${response.statusCode}');
// //       return null;
// //     }
// //   } catch (e) {
// //     debugPrint('Error fetching team data: $e');
// //     return null;
// //   }
// // }
