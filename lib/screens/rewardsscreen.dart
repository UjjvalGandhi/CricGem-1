import 'package:batting_app/screens/reworddetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/appbartext.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with TickerProviderStateMixin {
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
    List<Image> bg = [
      Image.asset(
        'assets/re1.png',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/re2.png',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/re1.png',
        fit: BoxFit.cover,
      ),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            // Custom background color
            elevation: 0,
            // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff1D1459), Color(0xff140B40)])),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      AppBarText(color: Colors.white, text: "Rewards"),
                      Container(
                        width: 20,
                      )
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
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 48, // Height of the tab bar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: const Color(0xff140B40),
                labelColor: const Color(0xff140B40),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: '  Reward Shop  '),
                  Tab(text: '  My Rewards  '),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(15),
                        color: const Color(0xffF0F1F5),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 166,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 45,
                                          child: Center(
                                              child: Image.asset(
                                            'assets/jack.png',
                                            height: 26,
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Jackpot",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Container(
                                                  height: 16,
                                                  width: 26,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white),
                                                  child: const Center(
                                                    child: Text(
                                                      "1",
                                                      style:
                                                          TextStyle(fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            const Text(
                                              "Collects your tickets to win bumper prize.",
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RewordDetails(),
                                            ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        height: 101,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/re_bg.png'),
                                                fit: BoxFit.cover)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "DC vs GT - Watch Live in Delhi",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const Text(
                                              "11:10 PM | RR vs RCB",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 20,
                                              width: 117,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 41,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: Colors.white
                                                            .withOpacity(0.2)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Image.asset(
                                                          'assets/noto_coin.png',
                                                          height: 16,
                                                        ),
                                                        const Text(
                                                          "20",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 66,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        color: Colors.white
                                                            .withOpacity(0.2)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Image.asset(
                                                          'assets/time.png',
                                                          height: 16,
                                                        ),
                                                        const Text(
                                                          "3 Days",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 45,
                                          child: Center(
                                              child: Image.asset(
                                            'assets/jack.png',
                                            height: 26,
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Tour Passes",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Container(
                                                  height: 16,
                                                  width: 26,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white),
                                                  child: const Center(
                                                    child: Text(
                                                      "4",
                                                      style:
                                                          TextStyle(fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            const Text(
                                              "Exclusive discounts on your favourite tours.",
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // SizedBox(
                                    //   height: 160,
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: ListView.builder(
                                    //     scrollDirection: Axis.horizontal,
                                    //     itemCount: 3,
                                    //     itemBuilder: (context, index) {
                                    //       return Container(
                                    //         padding: const EdgeInsets.all(15),
                                    //         height: 150,
                                    //         width: 129,
                                    //         margin:
                                    //             const EdgeInsets.only(right: 10),
                                    //         decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(20),
                                    //             image: const DecorationImage(
                                    //                 image: AssetImage(
                                    //                     'assets/re1.png'),
                                    //                 fit: BoxFit.cover)),
                                    //         child: Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             // SizedBox(
                                    //             //   height: 40,
                                    //             // ),
                                    //             Text(
                                    //               "3X Dream coin",
                                    //               style: TextStyle(
                                    //                   fontSize: 14,
                                    //                   color: Colors.white,
                                    //                   fontWeight:
                                    //                       FontWeight.w600),
                                    //             ),
                                    //             Text(
                                    //               "booster",
                                    //               style: TextStyle(
                                    //                   fontSize: 14,
                                    //                   color: Colors.white,
                                    //                   fontWeight:
                                    //                       FontWeight.w600),
                                    //             ),
                                    //
                                    //           ],
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: const Color(0xffF0F1F5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              height: 54,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/jack.png',
                                          height: 26,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Have a discount coupon code?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 45,
                                        child: Center(
                                            child: Image.asset(
                                          'assets/giveaway.png',
                                          height: 26,
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Giveaways",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Container(
                                                height: 16,
                                                width: 26,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white),
                                                child: const Center(
                                                  child: Text(
                                                    "4",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          const Text(
                                            "Exclusive discounts on your favourite tours.",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // SizedBox(
                                  //   height: 145,
                                  //   width: MediaQuery.of(context).size.width,
                                  //   child: ListView.builder(
                                  //     scrollDirection: Axis.horizontal,
                                  //     itemCount: 3,
                                  //     itemBuilder: (context, index) {
                                  //       return Container(
                                  //         padding: const EdgeInsets.all(15),
                                  //         height: 150,
                                  //         width: 129,
                                  //         margin:
                                  //             const EdgeInsets.only(right: 10),
                                  //         decoration: BoxDecoration(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(20),
                                  //             image: const DecorationImage(
                                  //                 image: AssetImage(
                                  //                     'assets/re1.png'),
                                  //                 fit: BoxFit.cover)),
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             SizedBox(
                                  //               height: 40,
                                  //             ),
                                  //             Text(
                                  //               "3X Dream coin",
                                  //               style: TextStyle(
                                  //                   fontSize: 14,
                                  //                   color: Colors.white,
                                  //                   fontWeight: FontWeight.w600),
                                  //             ),
                                  //             Text(
                                  //               "booster",
                                  //               style: TextStyle(
                                  //                   fontSize: 14,
                                  //                   color: Colors.white,
                                  //                   fontWeight: FontWeight.w600),
                                  //             ),
                                  //             SizedBox(
                                  //               height: 10,
                                  //             ),
                                  //             Container(
                                  //               height: 20,
                                  //               width: 41,
                                  //               decoration: BoxDecoration(
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(10),
                                  //                   color: Colors.white
                                  //                       .withOpacity(0.2)),
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceEvenly,
                                  //                 children: [
                                  //                   Image.asset(
                                  //                     'assets/noto_coin.png',
                                  //                     height: 16,
                                  //                   ),
                                  //                   const Text(
                                  //                     "20",
                                  //                     style: TextStyle(
                                  //                         fontSize: 12,
                                  //                         color: Colors.white),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          ],
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
    );
  }
}
