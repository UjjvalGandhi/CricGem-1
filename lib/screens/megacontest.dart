import 'package:batting_app/widget/small2.0.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/appbartext.dart';
import '../widget/normaltext.dart';

class MegaContestScreen extends StatefulWidget {
  const MegaContestScreen({super.key});

  @override
  State<MegaContestScreen> createState() => _MegaContestScreenState();
}

class _MegaContestScreenState extends State<MegaContestScreen> {
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
                      AppBarText(color: Colors.white, text: "Mega Contest Winner"),
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
        physics:const  NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color:const Color(0xffF0F1F5),
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Container(
                height: 128,
                padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Indian Premier League",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "22 Mar 2024",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 0.8,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 20,
                              child: Image.asset('assets/india.png'),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            NormalText(color: Colors.black, text: "India")
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: NormalText(
                                  color: Colors.black,
                                  text: "South Africa"),
                            ),
                            SizedBox(
                              width: 30,
                              height: 20,
                              child: Image.asset('assets/nz.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 0.8,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "View your team",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                  height: 39,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return  Row(
                        children: [
                          Container(
                            height: 35,
                            width: 142,
                            margin:const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color(0xff140B40)
                            ),
                            child: const Center(
                              child:Text("₹57 Crores Contest",style: TextStyle(fontSize: 11,color: Colors.white),),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 142,
                            margin:const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white
                            ),
                            child: const Center(
                              child:Text("₹18 Crores Contest",style: TextStyle(fontSize: 11,color: Colors.black),),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 142,
                            margin:const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white
                            ),
                            child: const Center(
                              child:Text("₹18 Crores Contest",style: TextStyle(fontSize: 11,color: Colors.black),),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 142,
                            margin:const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white
                            ),
                            child: const Center(
                              child:Text("₹18 Crores Contest",style: TextStyle(fontSize: 11,color: Colors.black),),
                            ),
                          ),
                        ],
                      );
                    },)
              ),
              const SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height,
                // height: 610,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffF0F1F5),
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return  Column(

                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom:20),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  padding:const EdgeInsets.only(top: 0,left: 15,right: 15),
                                  height: 160,
                                  // height: MediaQuery.of(context).size.height *0.2,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Amount Won",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "₹1 Crores",
                                                style: TextStyle(
                                                  color: Color(0xff140B40),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "#1",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        // height:MediaQuery.of(context).size.height *0.01 ,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start ,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              child: Image.asset(
                                                'assets/rdjr.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6,),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              NormalText(color: Colors.black, text: "Saathi Rathod"),
                                              Small2Text(color: Colors.grey, text: "Bihar | 9*******1"),
                                              Small2Text(color: Colors.grey, text: "Playing Since 2019"),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 32,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff010101).withOpacity(0.03),
                                        borderRadius: const BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(20),
                                            bottomLeft:
                                            Radius.circular(20))),
                                    child:
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Won with team 18", style: TextStyle(color: Colors.black, fontSize: 12),)
                                        // NormalText(color: Colors.black, text: "Won with team 18", ),
                                      ],
                                    )
                                ),
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom:20),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  padding:const EdgeInsets.only(top: 0,left: 15,right: 15),
                                  height: 160,
                                  // height: MediaQuery.of(context).size.height *0.2,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Amount Won",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "₹1 Crores",
                                                style: TextStyle(
                                                  color: Color(0xff140B40),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "#1",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        // height:MediaQuery.of(context).size.height *0.01 ,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start ,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              child: Image.asset(
                                                'assets/rdjr.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6,),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              NormalText(color: Colors.black, text: "Saathi Rathod"),
                                              Small2Text(color: Colors.grey, text: "Bihar | 9*******1"),
                                              Small2Text(color: Colors.grey, text: "Playing Since 2019"),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 32,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff010101).withOpacity(0.03),
                                        borderRadius: const BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(20),
                                            bottomLeft:
                                            Radius.circular(20))),
                                    child:
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Won with team 18", style: TextStyle(color: Colors.black, fontSize: 12),)
                                        // NormalText(color: Colors.black, text: "Won with team 18", ),
                                      ],
                                    )
                                ),
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom:20),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  padding:const EdgeInsets.only(top: 0,left: 15,right: 15),
                                  height: 160,
                                  // height: MediaQuery.of(context).size.height *0.2,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Amount Won",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "₹1 Crores",
                                                style: TextStyle(
                                                  color: Color(0xff140B40),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "#1",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        // height:MediaQuery.of(context).size.height *0.01 ,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start ,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              child: Image.asset(
                                                'assets/rdjr.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6,),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              NormalText(color: Colors.black, text: "Saathi Rathod"),
                                              Small2Text(color: Colors.grey, text: "Bihar | 9*******1"),
                                              Small2Text(color: Colors.grey, text: "Playing Since 2019"),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 32,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff010101).withOpacity(0.03),
                                        borderRadius: const BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(20),
                                            bottomLeft:
                                            Radius.circular(20))),
                                    child:
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Won with team 18", style: TextStyle(color: Colors.black, fontSize: 12),)
                                        // NormalText(color: Colors.black, text: "Won with team 18", ),
                                      ],
                                    )
                                ),
                              ]),
                        ),

                        const SizedBox(height: 100,)
                      ],
                    );
                  },),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
