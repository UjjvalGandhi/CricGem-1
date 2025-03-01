import 'package:batting_app/model/PlayerModel.dart';
import 'package:batting_app/screens/point_systum.dart';
import 'package:batting_app/widget/normaltext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/appbartext.dart';

class MyTeamdetails extends StatefulWidget {
  final List<Player>? selectedPlayers;
  final String? matchName;
  final String? teamname1;
  final String? teamname2;


  const MyTeamdetails({super.key, this.selectedPlayers, this.matchName, this.teamname1,this.teamname2});

  @override
  State<MyTeamdetails> createState() => _MyTeamdetailsState();
}

class _MyTeamdetailsState extends State<MyTeamdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: ClipRRect(
          child: AppBar(
            surfaceTintColor: const Color(0xff140B40),
            backgroundColor: const Color(0xff140B40), // Custom background color
            elevation: 0,
            leading: Container(), // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff140B40),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 53),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      AppBarText(color: Colors.white, text: "BOSS7069 (T1)"),
                      Container(width: 20),
                      Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Image.asset(
                            'assets/share_app.png',
                            height: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PointSystumScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(width: 0.5, color: Colors.white),
                              ),
                              child: const Center(
                                child: Text(
                                  "P",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/groundmain.png'), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const SizedBox(height: 62),
                SizedBox(
                  height: MediaQuery.of(context).size.height /2,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics( ),

                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (widget.selectedPlayers!.length < 3) ? widget.selectedPlayers!.length : 3, // Adjust based on player count
                      childAspectRatio: (widget.selectedPlayers!.length == 1) ? 2 : 1.20, // Set aspect ratio based on player count
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: widget.selectedPlayers?.length ?? 0,
                    itemBuilder: (context, index) {
                      final player = widget.selectedPlayers![index];
                      final nameParts = player.playerName.split(' ');
                      final shortName = nameParts.length > 1
                          ? '${nameParts[0][0]}.${nameParts[1]}'
                          : player.playerName;
                  // Fetching player from the list
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent, // Set the background color to transparent
                        ),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: ClipOval(
                                  child: Image.network(
                                    player.playerPhoto, // Placeholder image if URL is null
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Expanded(child: Image.asset('assets/dummy_player.png', height: 43)); // Default image if URL fails
                                    },
                                  ),
                                ),
                              ),
                              // SizedBox(height: 8),
                              Container(
                                height: 15.h,
                                width: 70.h,
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Center(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    // player.playerName,
                                    shortName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //   player.playerName, // Player's name
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.black,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  "${player.totalPoints} pts", // Player's points
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 34,
                    width: 93,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        // NormalText(color: Colors.white, text: widget.teamname1!),
                        NormalText(color: Colors.white, text: widget.teamname1 ?? "Default Team 1"),
                        const SizedBox(width: 5),
                        Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.black),
                        ),
                        const SizedBox(width: 5),
                        // NormalText(color: Colors.white, text: widget.teamname2!),
                        NormalText(color: Colors.white, text: widget.teamname2 ?? "Default Team 2"),

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
//
// import 'package:batting_app/model/PlayerModel.dart';
// import 'package:batting_app/screens/point_systum.dart';
// import 'package:batting_app/widget/normaltext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../widget/appbartext.dart';
// import '../widget/normal3.dart';
//
// class MyTeamdetails extends StatefulWidget {
//   final List<Player>? selectedPlayers;
//   final String? matchName;
//   final String? teamname1;
//   final String? teamname2;
//
//
//   MyTeamdetails({super.key, this.selectedPlayers, this.matchName, this.teamname1,this.teamname2});
//
//   @override
//   State<MyTeamdetails> createState() => _MyTeamdetailsState();
// }
//
// class _MyTeamdetailsState extends State<MyTeamdetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(63.0),
//         child: ClipRRect(
//           child: AppBar(
//             surfaceTintColor:const Color(0xff140B40),
//             backgroundColor:const Color(0xff140B40) , // Custom background color
//             elevation: 0,
//             leading: Container(),// Remove shadow
//             centerTitle: true,
//             flexibleSpace:   Container(
//               padding:  EdgeInsets.symmetric(horizontal: 20),
//               height: 100,
//               width: MediaQuery.of(context).size.width,
//               decoration:  const BoxDecoration(
//                   color: Color(0xff140B40),
//               ),
//               child:  Column(
//                 children: [
//                   const SizedBox(height: 53),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                           onTap: (){
//                             Navigator.pop(context);
//                           },
//                           child: const Icon(Icons.arrow_back,color: Colors.white,)),
//                       AppBarText(color: Colors.white, text: "BOSS7069 (T1)"),
//                       Container(width: 20,),
//
//                       Row(
//                         children: [
//                           const Icon(Icons.edit,color: Colors.white,size: 18,),
//                           SizedBox(width: 10,),
//                          Image.asset('assets/share_app.png',height: 18,color: Colors.white,),
//                           SizedBox(width: 10,),
//                           InkWell(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) =>const  PointSystumScreen(),));
//                             },
//                             child: Container(
//                               height: 22,
//                               width: 22,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(11),
//                                   border: Border.all(width: 0.5,color: Colors.white)
//                               ),
//                               child: const Center(
//                                 child: Text("P",style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children:[
//           Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/groundmain.png'),fit: BoxFit.cover)
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 62,),
//               Container(
//                 margin:const EdgeInsets.all(15),
//                 height: 586,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 78,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             height: 78,
//                             width: 64,
//                             child: Column(
//
//
//                               children: [
//                                 SizedBox(
//                                   height: 43,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.white,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("R Sharma",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 40,
//                                   width: 46,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 17,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 85,),
//                     Container(
//                       height: 78,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 78,
//                             width: 64,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 43,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.white,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("R Sharma",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 42,
//                                   width: 46,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 17,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.white,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 42,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 17,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 85,),
//                     Container(
//                       height: 78,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 43,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.white,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("R Sharma",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 43,
//                                   width: 46,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 43,
//                                   width: 46,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 85,),
//                     Container(
//                       height: 74,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 78,
//                             width: 64,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 40,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 15,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.white,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("R Sharma",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 39,
//                                   width: 46,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 78,
//                             width: 70,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 39,
//                                   width: 43,
//                                   child: Image.asset('assets/kohli.png',fit: BoxFit.cover,),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       color:  Colors.black,
//                                       borderRadius: BorderRadius.circular(2)
//                                   ),
//                                   child: Center(child:
//                                   Text("K Williams",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)),
//
//                                 ),
//                                 Text("157 pts",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w400),)
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//           Positioned(
//             bottom: 0,
//             child: Container(
//               height: 44,
//               padding:const EdgeInsets.symmetric(horizontal: 15),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 34,
//                     width: 93,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 5,
//                           width: 5,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(3),
//                             color: Colors.white
//                           ),
//                         ),
//                         SizedBox(width: 10,),
//                         NormalText(color: Colors.white, text: "IND"),
//                         SizedBox(width: 5,),
//                         Container(
//                           height: 5,
//                           width: 5,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(3),
//                               color: Colors.black
//                           ),
//                         ),
//                         SizedBox(width: 5,),
//                         NormalText(color: Colors.white, text: "NZ"),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//
//             ),
//           )
//     ]
//       ),
//     );
//   }
// }
