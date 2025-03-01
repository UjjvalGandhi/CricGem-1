import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/appbartext.dart';
import '../widget/normaltext.dart';
import '../widget/small2.0.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen>
    with SingleTickerProviderStateMixin { // Add SingleTickerProviderStateMixin
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Use SingleTickerProviderStateMixin
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the tab controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0.h),
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
                      AppBarText(color: Colors.white, text: "Add Friends"),
                      Container(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xffF0F1F5),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.only(bottom: 5),
                height: 48,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Search Your friends",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer between search field and tab bar
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
                  Tab(text: '          Contacts          '),
                  Tab(text: '          Friends          '),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children:  [
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
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                        ],
                      ) ,
                    ),
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
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                          const SizedBox(height: 15,),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child:Row(
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
                        ],
                      ) ,
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
