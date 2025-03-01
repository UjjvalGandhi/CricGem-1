import 'dart:convert';
import 'package:batting_app/screens/ind_vs_sa_screen.dart';
import 'package:batting_app/screens/leaglistscreen.dart';
import 'package:batting_app/values/string.dart';
import 'package:batting_app/widget/appbartext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';
import '../values/style.dart';
import '../widget/normaltext.dart';
import '../widget/smalltext.dart';

class HomeTwoScreens extends StatefulWidget {
  const HomeTwoScreens({super.key});

  @override
  State<HomeTwoScreens> createState() => _HomeTwoScreensState();
}

class _HomeTwoScreensState extends State<HomeTwoScreens> {
  late Future<HomeLeagModel?> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = profileDisplay();
  }

  Future<HomeLeagModel?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/user/desbord_details'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final data = HomeLeagModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print("print from if part ${response.body}");
        return data;
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0.h),
        child: ClipRRect(
          child: AppBar(
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff1D1459), Color(0xff140B40)])),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 88.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/aword.png',
                              height: 17,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              " ₹220",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 15, right: 15),
                                    height: 600,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(28),
                                          topLeft: Radius.circular(28)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        AppBarText(
                                            color: Colors.black,
                                            text: "Add Cash"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.grey.shade200,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 50,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300)),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/cash.png',
                                                    height: 16,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Text(
                                                    "Current Balance",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  const Icon(
                                                      Icons.keyboard_arrow_down)
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text(
                                                    "₹222",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        SizedBox(
                                          height: 67,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 48,
                                                width: 78,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                      Colors.grey.shade300),
                                                ),
                                                child: Center(
                                                  child: NormalText(
                                                      color: Colors.black,
                                                      text: "₹500"),
                                                ),
                                              ),
                                              Container(
                                                height: 48,
                                                width: 78,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                      Colors.grey.shade300),
                                                ),
                                                child: Center(
                                                  child: NormalText(
                                                      color: Colors.black,
                                                      text: "₹100"),
                                                ),
                                              ),
                                              Container(
                                                  height: 59,
                                                  width: 177,
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          SmallText(
                                                              color:
                                                              Colors.grey,
                                                              text:
                                                              "Amount to Add"),
                                                          NormalText(
                                                              color:
                                                              Colors.black,
                                                              text: "₹120")
                                                        ],
                                                      ),
                                                      Image.asset(
                                                        'assets/cancle.png',
                                                        height: 19,
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 50,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300)),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SmallText(
                                                      color: Colors.grey,
                                                      text: AppString
                                                          .addToCurrentBal)
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Text(
                                                    "₹120",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 14,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/tag.png',
                                                  height: 17,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                NormalText(
                                                    color: Colors.black,
                                                    text:
                                                    "Payment Offers (10)"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SmallText(
                                                    color: Colors.grey,
                                                    text: "View All"),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 18,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          height: 67,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(16),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: const Color(
                                                                0xff6739B7))),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset(
                                                            'assets/paybg.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "PhonePe UPI Lite",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  color: Color(
                                                                      0xff6739B7)),
                                                            ),
                                                            Text(
                                                              "Flat ₹10 Cashback",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xff6739B7)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(16),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: const Color(
                                                                0xffA8B0F7))),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset(
                                                            'assets/gbg.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Google Pay UPI",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  color: Color(
                                                                      0xffA8B0F7)),
                                                            ),
                                                            Text(
                                                              "Flat ₹20 Cashback",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xffA8B0F7)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        right: 10),
                                                    height: 67,
                                                    width: 201,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(16),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: const Color(
                                                                0xff333E47))),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 67,
                                                          width: 60,
                                                          child: Image.asset(
                                                            'assets/ppbg.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Amazon Pay UPI",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  color: Color(
                                                                      0xff333E47)),
                                                            ),
                                                            Text(
                                                              "Flat ₹20 Cashback",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xff333E47)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 48,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff140B40),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 88.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/Vector.png',
                                height: 17,
                                color: Colors.white,
                              ),
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
                                child: Image.asset(
                                  'assets/Plus (1).png',
                                  height: 17,
                                ),
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
      body: FutureBuilder<HomeLeagModel?>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffF0F1F5),
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xffF0F1F5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(

                        itemCount: data.data?.length,
                        itemBuilder: (context, index) {
                          final model = data.data?[index];

                          //  final match=data.data[index];

                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeagListScreeen(model: model,),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    NormalText(
                                      color: Colors.black,
                                      text: data.data![index].leagueDetails!.leaguaName.toString(),
                                      textStyle: AppStyles.text16s500wStyle,
                                    ),
                                    Row(
                                      children: [
                                        SmallText(
                                            color: Colors.grey, text: "View All"),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.grey,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  itemCount: model?.leagueDetails?.matches?.length,
                                  itemBuilder: (context, subIndex) {
                                    final match =
                                    model?.leagueDetails!.matches?[subIndex];

                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IndVsSaScreens(
                                                      Id: match?.id,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 171,
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8),
                                                width: 297,
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                decoration: BoxDecoration(
                                                  image:
                                                  const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/Frame 5223.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                                  color: Colors.red,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            match?.matchName
                                                                ?.split(
                                                                ' ')[0] ??
                                                                '',
                                                            style:
                                                            const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 7),
                                                          Image.asset(
                                                              'assets/vs.png',
                                                              height: 40),
                                                          const SizedBox(
                                                              width: 7),
                                                          Text(
                                                            match?.matchName ??
                                                                '',
                                                            style:
                                                            const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20,
                                                      right: 25),
                                                  height: 96,
                                                  width: 297,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      const SizedBox(height: 3),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 80,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  match?.team1Details
                                                                      ?.teamName ??
                                                                      '',
                                                                  style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    color: Color(
                                                                        0xffFFCB05),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                  "55m 27s",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    color: Color(
                                                                        0xffDC0000),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      match?.time ??
                                                                          '',
                                                                      style:
                                                                      const TextStyle(
                                                                        fontSize:
                                                                        14,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        color:
                                                                        Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 55,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  match?.team2Details
                                                                      ?.teamName ??
                                                                      '',
                                                                  style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    color: Color(
                                                                        0xff005195),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      const Text(
                                                        "Mega Content ₹70 Crores",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Color(
                                                              0xffD4AF37),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 27,
                                                left: 20,
                                                child: Image.asset(
                                                    'assets/csk.png',
                                                    height: 63),
                                              ),
                                              Positioned(
                                                top: 34,
                                                right: 27,
                                                child: Image.asset(
                                                    'assets/mubai.png',
                                                    height: 47),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                    // switch (index) {
                                    //   case 0:
                                    //     return Row(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: () {
                                    //             Navigator.push(
                                    //               context,
                                    //               MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     IndVsSaScreens(
                                    //                   Id: match.id,
                                    //                 ),
                                    //               ),
                                    //             );
                                    //           },
                                    //           child: Stack(
                                    //             children: [
                                    //               Container(
                                    //                 height: 171,
                                    //                 padding:
                                    //                     const EdgeInsets.only(
                                    //                         top: 8),
                                    //                 width: 297,
                                    //                 margin: const EdgeInsets.only(
                                    //                     right: 15),
                                    //                 decoration: BoxDecoration(
                                    //                   image:
                                    //                       const DecorationImage(
                                    //                     image: AssetImage(
                                    //                         'assets/Frame 5223.png'),
                                    //                     fit: BoxFit.cover,
                                    //                   ),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           10),
                                    //                   color: Colors.red,
                                    //                 ),
                                    //                 child: Column(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.start,
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment
                                    //                           .center,
                                    //                   children: [
                                    //                     SizedBox(
                                    //                       height: 40,
                                    //                       child: Row(
                                    //                         mainAxisAlignment:
                                    //                             MainAxisAlignment
                                    //                                 .center,
                                    //                         children: [
                                    //                           Text(
                                    //                             match.matchName
                                    //                                     ?.split(
                                    //                                         ' ')[0] ??
                                    //                                 '',
                                    //                             style:
                                    //                                 const TextStyle(
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w700,
                                    //                               color: Colors
                                    //                                   .white,
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                               width: 7),
                                    //                           Image.asset(
                                    //                               'assets/vs.png',
                                    //                               height: 40),
                                    //                           SizedBox(
                                    //                               width: 7),
                                    //                           Text(
                                    //                             match.matchName ??
                                    //                                 '',
                                    //                             style:
                                    //                                 const TextStyle(
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w700,
                                    //                               color: Colors
                                    //                                   .white,
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               Positioned(
                                    //                 bottom: 0,
                                    //                 child: Container(
                                    //                   padding:
                                    //                       const EdgeInsets.only(
                                    //                           left: 20,
                                    //                           right: 25),
                                    //                   height: 96,
                                    //                   width: 297,
                                    //                   decoration: BoxDecoration(
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10),
                                    //                     color: Colors.white,
                                    //                   ),
                                    //                   child: Column(
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .start,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .spaceEvenly,
                                    //                     children: [
                                    //                       SizedBox(height: 3),
                                    //                       Row(
                                    //                         mainAxisAlignment:
                                    //                             MainAxisAlignment
                                    //                                 .spaceBetween,
                                    //                         children: [
                                    //                           SizedBox(
                                    //                             width: 80,
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   match.team1Details
                                    //                                           ?.teamName ??
                                    //                                       '',
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w500,
                                    //                                     color: const Color(
                                    //                                         0xffFFCB05),
                                    //                                   ),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   "55m 27s",
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w700,
                                    //                                     color: const Color(
                                    //                                         0xffDC0000),
                                    //                                   ),
                                    //                                 ),
                                    //                                 Column(
                                    //                                   children: [
                                    //                                     Text(
                                    //                                       match.time ??
                                    //                                           '',
                                    //                                       style:
                                    //                                           TextStyle(
                                    //                                         fontSize:
                                    //                                             14,
                                    //                                         fontWeight:
                                    //                                             FontWeight.w500,
                                    //                                         color:
                                    //                                             Colors.black,
                                    //                                       ),
                                    //                                     ),
                                    //                                   ],
                                    //                                 )
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                             width: 55,
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   match.team2Details
                                    //                                           ?.teamName ??
                                    //                                       '',
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w500,
                                    //                                     color: const Color(
                                    //                                         0xff005195),
                                    //                                   ),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                       Container(
                                    //                         height: 1,
                                    //                         width: MediaQuery.of(
                                    //                                 context)
                                    //                             .size
                                    //                             .width,
                                    //                         color: Colors
                                    //                             .grey.shade300,
                                    //                       ),
                                    //                       Text(
                                    //                         "Mega Content ₹70 Crores",
                                    //                         style: TextStyle(
                                    //                           fontSize: 12,
                                    //                           fontWeight:
                                    //                               FontWeight.w500,
                                    //                           color: const Color(
                                    //                               0xffD4AF37),
                                    //                         ),
                                    //                       )
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               Positioned(
                                    //                 top: 27,
                                    //                 left: 20,
                                    //                 child: Image.asset(
                                    //                     'assets/csk.png',
                                    //                     height: 63),
                                    //               ),
                                    //               Positioned(
                                    //                 top: 34,
                                    //                 right: 27,
                                    //                 child: Image.asset(
                                    //                     'assets/mubai.png',
                                    //                     height: 47),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   case 1:
                                    //     return Row(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: () {
                                    //             Navigator.push(
                                    //               context,
                                    //               MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     IndVsSaScreens(
                                    //                   Id: match.id,
                                    //                 ),
                                    //               ),
                                    //             );
                                    //           },
                                    //           child: Stack(
                                    //             children: [
                                    //               Container(
                                    //                 height: 171,
                                    //                 padding:
                                    //                     const EdgeInsets.only(
                                    //                         top: 8),
                                    //                 width: 297,
                                    //                 margin: const EdgeInsets.only(
                                    //                     right: 15),
                                    //                 decoration: BoxDecoration(
                                    //                   image:
                                    //                       const DecorationImage(
                                    //                     image: AssetImage(
                                    //                         'assets/Frame 5223.png'),
                                    //                     fit: BoxFit.cover,
                                    //                   ),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           10),
                                    //                   color: Colors.red,
                                    //                 ),
                                    //                 child: Column(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.start,
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment
                                    //                           .center,
                                    //                   children: [
                                    //                     SizedBox(
                                    //                       height: 40,
                                    //                       child: Row(
                                    //                         mainAxisAlignment:
                                    //                             MainAxisAlignment
                                    //                                 .center,
                                    //                         children: [
                                    //                           Text(
                                    //                             match.matchName
                                    //                                     ?.split(
                                    //                                         ' ')[0] ??
                                    //                                 '',
                                    //                             style:
                                    //                                 const TextStyle(
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w700,
                                    //                               color: Colors
                                    //                                   .white,
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                               width: 7),
                                    //                           Image.asset(
                                    //                               'assets/vs.png',
                                    //                               height: 40),
                                    //                           SizedBox(
                                    //                               width: 7),
                                    //                           Text(
                                    //                             match.matchName ??
                                    //                                 '',
                                    //                             style:
                                    //                                 const TextStyle(
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w700,
                                    //                               color: Colors
                                    //                                   .white,
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               Positioned(
                                    //                 bottom: 0,
                                    //                 child: Container(
                                    //                   padding:
                                    //                       const EdgeInsets.only(
                                    //                           left: 20,
                                    //                           right: 25),
                                    //                   height: 96,
                                    //                   width: 297,
                                    //                   decoration: BoxDecoration(
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10),
                                    //                     color: Colors.white,
                                    //                   ),
                                    //                   child: Column(
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .start,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .spaceEvenly,
                                    //                     children: [
                                    //                       SizedBox(height: 3),
                                    //                       Row(
                                    //                         mainAxisAlignment:
                                    //                             MainAxisAlignment
                                    //                                 .spaceBetween,
                                    //                         children: [
                                    //                           SizedBox(
                                    //                             width: 80,
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   match.team1Details
                                    //                                           ?.teamName ??
                                    //                                       '',
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w500,
                                    //                                     color: const Color(
                                    //                                         0xffFFCB05),
                                    //                                   ),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   "55m 27s",
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w700,
                                    //                                     color: const Color(
                                    //                                         0xffDC0000),
                                    //                                   ),
                                    //                                 ),
                                    //                                 Column(
                                    //                                   children: [
                                    //                                     Text(
                                    //                                       match.time ??
                                    //                                           '',
                                    //                                       style:
                                    //                                           TextStyle(
                                    //                                         fontSize:
                                    //                                             14,
                                    //                                         fontWeight:
                                    //                                             FontWeight.w500,
                                    //                                         color:
                                    //                                             Colors.black,
                                    //                                       ),
                                    //                                     ),
                                    //                                   ],
                                    //                                 )
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                           SizedBox(
                                    //                             width: 55,
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Text(
                                    //                                   match.team2Details
                                    //                                           ?.teamName ??
                                    //                                       '',
                                    //                                   style:
                                    //                                       TextStyle(
                                    //                                     fontSize:
                                    //                                         14,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w500,
                                    //                                     color: const Color(
                                    //                                         0xff005195),
                                    //                                   ),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                       Container(
                                    //                         height: 1,
                                    //                         width: MediaQuery.of(
                                    //                                 context)
                                    //                             .size
                                    //                             .width,
                                    //                         color: Colors
                                    //                             .grey.shade300,
                                    //                       ),
                                    //                       Text(
                                    //                         "Mega Content ₹70 Crores",
                                    //                         style: TextStyle(
                                    //                           fontSize: 12,
                                    //                           fontWeight:
                                    //                               FontWeight.w500,
                                    //                           color: const Color(
                                    //                               0xffD4AF37),
                                    //                         ),
                                    //                       )
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               Positioned(
                                    //                 top: 27,
                                    //                 left: 20,
                                    //                 child: Image.asset(
                                    //                     'assets/csk.png',
                                    //                     height: 63),
                                    //               ),
                                    //               Positioned(
                                    //                 top: 34,
                                    //                 right: 27,
                                    //                 child: Image.asset(
                                    //                     'assets/mubai.png',
                                    //                     height: 47),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    // }
                                  },
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     NormalText(color: Colors.black, text: "ICC World Cup"),
                    //     Row(
                    //       children: [
                    //         SmallText(color: Colors.grey, text: "View All"),
                    //         const Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: 18,
                    //           color: Colors.grey,
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Stack(children: [
                    //   Container(
                    //     height: 171,
                    //     width: MediaQuery.of(context).size.width,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10),
                    //         image: const DecorationImage(
                    //             image: AssetImage('assets/card_bg.png'),
                    //             fit: BoxFit.cover,
                    //             opacity: 0.1)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         SizedBox(
                    //           height: 148,
                    //           width: 69,
                    //           child: Image.asset(
                    //             'assets/indcard.png',
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 145,
                    //           width: 90,
                    //           child: Column(
                    //             children: [
                    //               SizedBox(
                    //                 height: 43,
                    //                 child: const Column(
                    //                   children: [
                    //                     Text(
                    //                       "ICC T20",
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w700,
                    //                           color: Color(0xff140B40)),
                    //                     ),
                    //                     Text(
                    //                       "WORLD CUP",
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w700,
                    //                           color: Color(0xff140B40)),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               const Text("Semi Finals",
                    //                   style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w500,
                    //                     color: Colors.red,
                    //                   )),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               SizedBox(
                    //                 height: 41,
                    //                 child: const Column(
                    //                   children: [
                    //                     Text("Starts at",
                    //                         style: TextStyle(
                    //                           fontSize: 10,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: Color(0xff140B40),
                    //                         )),
                    //                     Text("08:30 PM IST",
                    //                         style: TextStyle(
                    //                           fontSize: 13,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: Color(0xff140B40),
                    //                         )),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Container(
                    //                 height: 24,
                    //                 width: 61,
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(3),
                    //                     color: const Color(0xff140B40)),
                    //                 child: const Center(
                    //                   child: Text(
                    //                     "JOIN NOW",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.w500,
                    //                         fontSize: 10,
                    //                         color: Colors.white),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 148,
                    //           width: 69,
                    //           child: Image.asset(
                    //             'assets/nzcard.png',
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   Positioned(
                    //       bottom: 0,
                    //       left: 0,
                    //       child: Container(
                    //           decoration: const BoxDecoration(
                    //               borderRadius: BorderRadius.only(
                    //                   bottomLeft: Radius.circular(10)),
                    //               image: DecorationImage(
                    //                   image: AssetImage('assets/blur.png'))),
                    //           height: 23,
                    //           width: 137,
                    //           child: Center(
                    //             child: Text(
                    //               "INDIA",
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.white),
                    //             ),
                    //           ))),
                    //   Positioned(
                    //       right: 0,
                    //       bottom: 0,
                    //       child: Container(
                    //           decoration: const BoxDecoration(
                    //               borderRadius: BorderRadius.only(
                    //                   bottomLeft: Radius.circular(10)),
                    //               image: DecorationImage(
                    //                   image: AssetImage('assets/nz_blur.png'))),
                    //           height: 23,
                    //           width: 137,
                    //           child: Center(
                    //             child: Text(
                    //               "NEW ZELAND",
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.white),
                    //             ),
                    //           )))
                    // ]),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => Upcominglistscreen(),
                    //         ));
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       NormalText(
                    //           color: Colors.black, text: "Upcoming Matches"),
                    //       Row(
                    //         children: [
                    //           SmallText(color: Colors.grey, text: "View All"),
                    //           const Icon(
                    //             Icons.arrow_forward_ios,
                    //             size: 18,
                    //             color: Colors.grey,
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // SizedBox(
                    //   height: 150,
                    //   child: ListView.builder(
                    //     itemCount: 2,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       return Stack(children: [
                    //         Container(
                    //           height: 150,
                    //           margin: const EdgeInsets.only(right: 15),
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 20, vertical: 10),
                    //           width: 291,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               color: Colors.white),
                    //           child: Column(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               SizedBox(
                    //                 height: 28,
                    //               ),
                    //               SizedBox(
                    //                 height: 38,
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     SizedBox(
                    //                       height: 26,
                    //                       width: 73,
                    //                       child: Row(
                    //                         children: [
                    //                           Image.asset(
                    //                             'assets/india.png',
                    //                             height: 26,
                    //                           ),
                    //                           SizedBox(
                    //                             width: 8,
                    //                           ),
                    //                           const Text(
                    //                             "IND",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 fontWeight:
                    //                                     FontWeight.w500),
                    //                           )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 40,
                    //                       width: 75,
                    //                       child: Column(
                    //                         children: [
                    //                           Text(
                    //                             "Today",
                    //                             style: TextStyle(
                    //                                 fontWeight: FontWeight.w400,
                    //                                 fontSize: 12,
                    //                                 color: Colors.grey),
                    //                           ),
                    //                           Text(
                    //                             "08:30 PM",
                    //                             style: TextStyle(
                    //                                 fontWeight: FontWeight.w500,
                    //                                 fontSize: 14,
                    //                                 color: Colors.red),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 26,
                    //                       width: 73,
                    //                       child: Row(
                    //                         children: [
                    //                           const Text(
                    //                             "SA",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 fontWeight:
                    //                                     FontWeight.w500),
                    //                           ),
                    //                           SizedBox(
                    //                             width: 8,
                    //                           ),
                    //                           Image.asset(
                    //                             'assets/nz.png',
                    //                             height: 26,
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Divider(
                    //                 height: 1,
                    //                 color: Colors.grey.shade300,
                    //               ),
                    //               Container(
                    //                 height: 38,
                    //                 width: MediaQuery.of(context).size.width,
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(8),
                    //                     color: const Color(0xff140B40)),
                    //                 child: const Center(
                    //                     child: Text(
                    //                   "Join Now",
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.w500,
                    //                       color: Colors.white),
                    //                 )),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         Container(
                    //           height: 30,
                    //           width: 291,
                    //           padding: const EdgeInsets.only(left: 15, top: 7),
                    //           decoration: BoxDecoration(
                    //               color: Colors.black.withOpacity(0.1),
                    //               borderRadius: const BorderRadius.only(
                    //                   topLeft: Radius.circular(12),
                    //                   topRight: Radius.circular(12))),
                    //           child: const Text(
                    //             "Indian Premier League",
                    //             style: TextStyle(
                    //                 fontSize: 12, fontWeight: FontWeight.w500),
                    //           ),
                    //         )
                    //       ]);
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     NormalText(color: Colors.black, text: "My Matches"),
                    //     Row(
                    //       children: [
                    //         SmallText(color: Colors.grey, text: "View All"),
                    //         const Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: 18,
                    //           color: Colors.grey,
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // SizedBox(
                    //   height: 172,
                    //   child: ListView.builder(
                    //     itemCount: 1,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       return Row(
                    //         children: [
                    //           Stack(children: [
                    //             Container(
                    //               height: 172,
                    //               margin: const EdgeInsets.only(right: 15),
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 10),
                    //               width: 291,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(12),
                    //                   color: Colors.white),
                    //               child: Column(
                    //                 children: [
                    //                   SizedBox(
                    //                     height: 30,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 38,
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             children: [
                    //                               Image.asset(
                    //                                 'assets/india.png',
                    //                                 height: 26,
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               const Text(
                    //                                 "IND",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 40,
                    //                           width: 75,
                    //                           child: Column(
                    //                             children: [
                    //                               Text(
                    //                                 "Today",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                               Text(
                    //                                 "elected bat",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               const Text(
                    //                                 "SA",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               Image.asset(
                    //                                 'assets/nz.png',
                    //                                 height: 26,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "280/6",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(50)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       ),
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "221/10",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(40.3)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       )
                    //                     ],
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Divider(
                    //                     height: 1,
                    //                     color: Colors.grey.shade300,
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Container(
                    //                         height: 38,
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width /
                    //                             3.2,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             color: const Color(0xff140B40)
                    //                                 .withOpacity(0.1)),
                    //                         child: const Center(
                    //                             child: Text(
                    //                           "View Stats",
                    //                           style: TextStyle(
                    //                               fontSize: 12,
                    //                               fontWeight: FontWeight.w500,
                    //                               color: Color(0xff140B40)),
                    //                         )),
                    //                       ),
                    //                       Container(
                    //                         height: 38,
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width /
                    //                             3.2,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             color: const Color(0xff140B40)),
                    //                         child: const Center(
                    //                             child: Text(
                    //                           "My Team",
                    //                           style: TextStyle(
                    //                               fontSize: 12,
                    //                               fontWeight: FontWeight.w500,
                    //                               color: Colors.white),
                    //                         )),
                    //                       ),
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 30,
                    //               width: 291,
                    //               padding: const EdgeInsets.only(
                    //                   left: 15, right: 15),
                    //               decoration: BoxDecoration(
                    //                   color: Colors.black.withOpacity(0.1),
                    //                   borderRadius: const BorderRadius.only(
                    //                       topLeft: Radius.circular(12),
                    //                       topRight: Radius.circular(12))),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   const Text(
                    //                     "Indian Premier League",
                    //                     style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                   Row(
                    //                     children: [
                    //                       Container(
                    //                         height: 5,
                    //                         width: 5,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             color: Colors.red),
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 5,
                    //                       ),
                    //                       const Text(
                    //                         "Live",
                    //                         style: TextStyle(
                    //                             fontSize: 12,
                    //                             fontWeight: FontWeight.w400),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             )
                    //           ]),
                    //           Stack(children: [
                    //             Container(
                    //               height: 172,
                    //               margin: const EdgeInsets.only(right: 15),
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 10),
                    //               width: 291,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(12),
                    //                   color: Colors.white),
                    //               child: Column(
                    //                 children: [
                    //                   SizedBox(
                    //                     height: 30,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 38,
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             children: [
                    //                               Image.asset(
                    //                                 'assets/india.png',
                    //                                 height: 26,
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               const Text(
                    //                                 "IND",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 40,
                    //                           width: 75,
                    //                           child: Column(
                    //                             children: [
                    //                               Text(
                    //                                 "India won",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                               Text(
                    //                                 "by 7 wk",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               const Text(
                    //                                 "SA",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               Image.asset(
                    //                                 'assets/nz.png',
                    //                                 height: 26,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "280/6",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(50)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       ),
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "221/10",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(40.3)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       )
                    //                     ],
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Divider(
                    //                     height: 1,
                    //                     color: Colors.grey.shade300,
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Container(
                    //                     height: 38,
                    //                     width:
                    //                         MediaQuery.of(context).size.width,
                    //                     decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                         color:
                    //                             Colors.green.withOpacity(0.1)),
                    //                     child: const Center(
                    //                         child: Text(
                    //                       "You won ₹58",
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: Colors.green),
                    //                     )),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 30,
                    //               width: 291,
                    //               padding: const EdgeInsets.only(
                    //                   left: 15, right: 15),
                    //               decoration: BoxDecoration(
                    //                   color: Colors.black.withOpacity(0.1),
                    //                   borderRadius: const BorderRadius.only(
                    //                       topLeft: Radius.circular(12),
                    //                       topRight: Radius.circular(12))),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   const Text(
                    //                     "Indian Premier League",
                    //                     style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                   Row(
                    //                     children: [
                    //                       Container(
                    //                         height: 5,
                    //                         width: 5,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             color: Colors.green),
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 5,
                    //                       ),
                    //                       const Text(
                    //                         "Completed",
                    //                         style: TextStyle(
                    //                             fontSize: 12,
                    //                             fontWeight: FontWeight.w400),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             )
                    //           ]),
                    //           Stack(children: [
                    //             Container(
                    //               height: 172,
                    //               margin: const EdgeInsets.only(right: 15),
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 10),
                    //               width: 291,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(12),
                    //                   color: Colors.white),
                    //               child: Column(
                    //                 children: [
                    //                   SizedBox(
                    //                     height: 30,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 38,
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             children: [
                    //                               Image.asset(
                    //                                 'assets/india.png',
                    //                                 height: 26,
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               const Text(
                    //                                 "IND",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 40,
                    //                           width: 75,
                    //                           child: Column(
                    //                             children: [
                    //                               Text(
                    //                                 "India won",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                               Text(
                    //                                 "by 7 wk",
                    //                                 style: TextStyle(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     fontSize: 12,
                    //                                     color: Colors.grey),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         SizedBox(
                    //                           height: 26,
                    //                           width: 73,
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               const Text(
                    //                                 "SA",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight.w500),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 8,
                    //                               ),
                    //                               Image.asset(
                    //                                 'assets/nz.png',
                    //                                 height: 26,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "280/6",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(50)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       ),
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             "221/10",
                    //                             style: TextStyle(
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           Text(
                    //                             "(40.3)",
                    //                             style: TextStyle(
                    //                                 fontSize: 10,
                    //                                 color: Colors.black),
                    //                           )
                    //                         ],
                    //                       )
                    //                     ],
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Divider(
                    //                     height: 1,
                    //                     color: Colors.grey.shade300,
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   Container(
                    //                     height: 38,
                    //                     width:
                    //                         MediaQuery.of(context).size.width,
                    //                     decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                         color: const Color(0xff140B40)),
                    //                     child: const Center(
                    //                         child: Text(
                    //                       "My Team",
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: Colors.white),
                    //                     )),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 30,
                    //               width: 291,
                    //               padding: const EdgeInsets.only(
                    //                   left: 15, right: 15),
                    //               decoration: BoxDecoration(
                    //                   color: Colors.black.withOpacity(0.1),
                    //                   borderRadius: const BorderRadius.only(
                    //                       topLeft: Radius.circular(12),
                    //                       topRight: Radius.circular(12))),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   const Text(
                    //                     "Indian Premier League",
                    //                     style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                   Row(
                    //                     children: [
                    //                       Container(
                    //                         height: 5,
                    //                         width: 5,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             color: const Color(0xff140B40)),
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 5,
                    //                       ),
                    //                       const Text(
                    //                         "Upcoming",
                    //                         style: TextStyle(
                    //                             fontSize: 12,
                    //                             fontWeight: FontWeight.w400),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             )
                    //           ]),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
