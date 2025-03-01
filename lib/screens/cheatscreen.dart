import 'package:batting_app/screens/addfriend.dart';
import 'package:batting_app/screens/cheat_inside.dart';
import 'package:batting_app/widget/normal_400.dart';
import 'package:batting_app/widget/normaltext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/appbartext.dart';
import '../widget/small2.0.dart';

class CheatScrren extends StatefulWidget {
  const CheatScrren({super.key});

  @override
  State<CheatScrren> createState() => _CheatScrrenState();
}

class _CheatScrrenState extends State<CheatScrren> {
  SnapshotController snapshot = SnapshotController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(95.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor:const Color(0xffF0F1F5) ,
            backgroundColor:const Color(0xffF0F1F5) , // Custom background color
            elevation: 0, // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff1D1459),Color(0xff140B40)
                      ])
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back,color: Colors.white,)),
                      AppBarText(color: Colors.white, text: "Chat"),
                      Container(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          color:const Color(0xffF0F1F5) ,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Stack(
                children:[
                  Container(
                    padding:const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>const CheatInside() ,));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset('assets/rdjr.jpg',fit: BoxFit.cover,),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NormalText(color: Colors.black, text: "Saathi Rathod"),
                                    Small2Text(color: Colors.grey, text: "Skill Score: 300")
                                  ],
                                )
                              ],),
                              Row(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    width: 60,
                                    child: Center(
                                      child: Image.asset("assets/massage_plus.png",height: 22,),
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset('assets/rdjr.jpg',fit: BoxFit.cover,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(color: Colors.black, text: "Sathi Rathod"),
                                  Small2Text(color: Colors.grey, text: "Skill Score: 300")
                                ],
                              )
                            ],),
                            Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  height: 45,
                                  width: 60,
                                  child: Center(
                                    child: Image.asset("assets/massage_plus.png",height: 22,),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset('assets/rdjr.jpg',fit: BoxFit.cover,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(color: Colors.black, text: "Saathi Rathod"),
                                  Small2Text(color: Colors.grey, text: "Skill Score: 300")
                                ],
                              )
                            ],),
                            Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  height: 45,
                                  width: 60,
                                  child: Center(
                                    child: Image.asset("assets/massage_plus.png",height: 22,),
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset('assets/rdjr.jpg',fit: BoxFit.cover,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(color: Colors.black, text: "Saathi Rathod"),
                                  Small2Text(color: Colors.grey, text: "Skill Score: 300")
                                ],
                              )
                            ],),
                            Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  height: 45,
                                  width: 60,
                                  child: Center(
                                    child: Image.asset("assets/massage_plus.png",height: 22,),
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      ],
                    ) ,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Positioned(
                      bottom: 255,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                      height: 116,
                      width: 195,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1,color: Colors.black.withOpacity(0.2))
                      ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>const AddFriendScreen() ,));
                                },
                                child: SizedBox(
                                  height: 28,
                                  width: 125,
                                  child: Row(
                                    children: [
                                      Image.asset('assets/mass_plus.png',height: 20,),
                                      const SizedBox(width: 8,),
                                      Normal400(color: Colors.black, text: "Direct Chat")
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              SizedBox(
                                height: 28,
                                width: 162,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/user_pluse.png',height: 15,),
                                    const SizedBox(width: 5,),
                                    Normal400(color: Colors.black, text: "Create A Group")
                                  ],
                                ),
                              ),
                            ],
                          ),
                    )),
                  )
                ]
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isVisible = !isVisible;
          });
        },
        backgroundColor: const Color(0xff140B40),
        // Making the FloatingActionButton circular
        shape: const CircleBorder(),
        child: Center(
          child: Image.asset('assets/massage_plus_white.png', height: 22),
        ),
      ),
    );
  }
  }
