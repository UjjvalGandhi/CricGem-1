import 'package:batting_app/widget/small3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../values/string.dart';
import '../widget/appbartext.dart';
import '../widget/normal2.0.dart';
import '../widget/normaltext.dart';
import '../widget/small2.0.dart';
import '../widget/smalltext.dart';

class LeaderBoad extends StatefulWidget {
  const LeaderBoad({super.key});

  @override
  State<LeaderBoad> createState() => _LeaderBoadState();
}

class _LeaderBoadState extends State<LeaderBoad>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: ClipRRect(
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: Container(),
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration:const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff1D1459),Color(0xff140B40)
                      ])
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back,color: Colors.white,)),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBarText(color: Colors.white, text: "IND vs SA"),
                              Small3Text(color: Colors.white, text: "4h 5m left")
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async{
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    padding: const EdgeInsets.only(top: 10,left: 15,right: 15),
                                    height: 600,
                                    width: MediaQuery.of(context).size.width,
                                    decoration:const BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(28),topLeft: Radius.circular(28)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        AppBarText(color: Colors.black, text: "Add Cash"),
                                        const SizedBox(height: 10,),
                                        Divider(
                                          height: 1,
                                          color: Colors.grey.shade200,

                                        ),
                                        const SizedBox(height: 20,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(width: 1,color: Colors.grey.shade300)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset('assets/cash.png',height: 16,),
                                                  const SizedBox(width: 10,),
                                                  const Text("Current Balance",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                                  const Icon(Icons.keyboard_arrow_down)
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text("₹222",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                                                ],
                                              )

                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 25,),
                                        SizedBox(
                                          height: 67,
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 48,
                                                width: 78,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(width: 1,color: Colors.grey.shade300),
                                                ),
                                                child: Center(
                                                  child: NormalText(color: Colors.black, text: "₹500"),
                                                ),
                                              ),

                                              Container(
                                                height: 48,
                                                width: 78,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(width: 1,color: Colors.grey.shade300),
                                                ),
                                                child: Center(
                                                  child: NormalText(color: Colors.black, text: "₹100"),
                                                ),
                                              ),

                                              Container(
                                                  height: 59,
                                                  width: 177,
                                                  padding: const EdgeInsets.only(top: 9,left: 15,right: 15),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 1,color: Colors.grey.shade300),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SmallText(color: Colors.grey, text: "Amount to Add"),
                                                          NormalText(color: Colors.black, text: "₹120")
                                                        ],
                                                      ),
                                                      Image.asset('assets/cancle.png',height: 19,)
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(width: 1,color: Colors.grey.shade300)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SmallText(color: Colors.grey, text: AppString.addToCurrentBal)
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text("₹120",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                                  Icon(Icons.keyboard_arrow_down,size: 14,)
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 25,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/tag.png',height: 17,),
                                                const SizedBox(width: 5,),
                                                NormalText(color: Colors.black, text: "Payment Offers (10)"),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                SmallText(color: Colors.grey, text: "View All"),
                                                const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.grey,)
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        SizedBox(
                                          height: 67,

                                          width: MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(width: 1,color:const Color(0xff6739B7))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset('assets/paybg.png',fit: BoxFit.cover,),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        const Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("PhonePe UPI Lite",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff6739B7) ),),
                                                            Text("Flat ₹10 Cashback",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff6739B7) ),),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(width: 1,color:const Color(0xffA8B0F7))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset('assets/gbg.png',fit: BoxFit.cover,),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        const Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Google Pay UPI",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xffA8B0F7) ),),
                                                            Text("Flat ₹20 Cashback",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xffA8B0F7) ),),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(width: 1,color:const Color(0xff333E47))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset('assets/ppbg.png',fit: BoxFit.cover,),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        const Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Amazon Pay UPI",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff333E47) ),),
                                                            Text("Flat ₹20 Cashback",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff333E47) ),),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },),
                                        ),
                                        const SizedBox(height: 20,),
                                        Container(
                                          height: 48,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color:const Color(0xff140B40),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Center(
                                            child:  Text("Add",style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color:Colors.white
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },);

                            },);
                        },
                        child: Container(
                          height: 40,
                          width: 88.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:  Colors.white.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/Vector.png', height: 17,color: Colors.white,),
                              const SizedBox(width: 4),
                              const Text(
                                "₹220",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {},
                                child: Image.asset('assets/Plus (1).png', height: 17,),
                              ),
                            ],
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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffF0F1F5),
          child: Column(
            children: [
              Container(
                padding:const EdgeInsets.all(15),
                height: 161,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.white, width: 1)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Prize Pool",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "₹58 Crores",
                              style: TextStyle(
                                color: Color(0xff140B40),
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Normal2Text(color: Colors.black, text: "#1 - ₹1 Cr"),
                            Normal2Text(color: Colors.black, text: "#2 - ₹1 Cr"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 2.5,
                      width: MediaQuery.of(context).size.width,
                      color:const  Color(0xff777777).withOpacity(0.3),
                      child: Row(
                        children: [
                          Container(
                            height: 2.5,
                            width: 100,
                            color: const Color(0xff140B40),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("13,21,200 spots left",style: TextStyle(fontSize: 12,color:Color(0xff140B40)),),
                        Text("13,21,200 spots",style: TextStyle(fontSize: 12,color:Colors.grey),),
                      ],
                    ),
                    const SizedBox(height: 9,),
                    InkWell(
                      onTap: () async{
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                                  height: 330,
                                  width: MediaQuery.of(context).size.width,
                                  decoration:const BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(28),topLeft: Radius.circular(28)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          AppBarText(color: Colors.black, text: "CONFIRMATION"),
                                          const Text("Amount Unutilized + Winnings = ₹0",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey),)
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade200,

                                      ),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        height: 100,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Small2Text(color: Colors.grey, text: "Entry"),
                                                Small2Text(color: Colors.grey, text: "₹0"),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Small2Text(color: Colors.grey, text: "Usable Discount Bonus"),
                                                Small2Text(color: Colors.grey, text: "₹0"),
                                              ],
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.grey.shade200,
                                            ),
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("To Pay",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                Text("₹0",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Align(
                                        alignment:Alignment.centerLeft ,
                                          child: Text("I Agree with the standard T&Cs",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                                      Container(
                                        height: 48,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color:const Color(0xff140B40),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: const Center(
                                          child:  Text("Join Contest",style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color:Colors.white
                                          ),),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },);

                          },);
                      },
                      child: Container(
                        height: 34,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color:const Color(0xff140B40)
                        ),
                        child: const Center(child:
                        Text("JOIN ₹0",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),)),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 219,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/fluent.png'),
                                const Text("₹3 Crores",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w500),)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/cup.png'),
                                const Text("%63",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w500),)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/m.png'),
                                const Text("Upto 20",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w500),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 94,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/granted.png'),
                          const Text("Guaranteed",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w500),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              Container(
                height: 48, // Height of the tab bar
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize:TabBarIndicatorSize.label,
                  indicatorColor: const Color(0xff140B40),
                  labelColor:const Color(0xff140B40) ,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: '          Winnings          '),
                    Tab(text: '          Leaderboard          '),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children:  [
                    Container(
                      padding:const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  height: 30,
                                  width: 132,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("RANK",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.3)),)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 90,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("WINNINGS",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.3)),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 450,
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#1",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹3 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#2",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹2 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#3",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#4",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹3 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#5",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 80,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#6",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 110,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#16-50",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 40),
                                            height: 30,
                                            width: 120,
                                            child: const Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("#17-15",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 50,),

                                  ],
                                );
                              },),
                          )

                        ],
                      ) ,
                    ),
                    Container(
                      padding:const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    height: 30,
                                    width: 132,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("RANK",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.3)),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 90,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("WINNINGS",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.3)),)
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 450,
                              child: ListView.builder(
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 10),
                                              height: 30,
                                              width: 170,
                                              child: const Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("Ashish Prajapati",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                              width: 110,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("₹1 Crores",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.black),)
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  );
                                },),
                            )

                          ],
                        ),
                      ) ,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
