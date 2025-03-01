import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/pointsmodelscreen.dart';
import '../widget/appbar_for_setting.dart';

class PointSystumScreen extends StatefulWidget {
  const PointSystumScreen({super.key});

  @override
  State<PointSystumScreen> createState() => _PointSystumScreenState();
}

class _PointSystumScreenState extends State<PointSystumScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<Pointsmodelscreen>? _pointsSystemFuture;
  final Map<String, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _pointsSystemFuture = fetchPointsSystem();
  }

  Future<Pointsmodelscreen> fetchPointsSystem() async {
    final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/pointsystem/point'));

    if (response.statusCode == 200) {
      return Pointsmodelscreen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load points system');
    }
  }

  // Widget buildDropdown(String title, List<Widget> children) {
  //   bool isExpanded = _isExpanded[title] ?? false;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _isExpanded[title] = !isExpanded;
  //       });
  //     },
  //     child: Column(
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10), // Added border radius
  //           ),
  //           padding: const EdgeInsets.all(15),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 title,
  //                 style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
  //               ),
  //               Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
  //             ],
  //           ),
  //         ),
  //         if (isExpanded)
  //           Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10), // Added border radius
  //             ),
  //             child: Column(
  //               children: children,
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
  // Widget buildDropdown(String title, List<Widget> children) {
  //   bool isExpanded = _isExpanded[title] ?? false;
  //   return Column(
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isExpanded[title] = !isExpanded;
  //           });
  //         },
  //         child: Container(
  //           margin: const EdgeInsets.only(bottom: 10), // Add margin between dropdowns
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.3),
  //                 spreadRadius: 1,
  //                 blurRadius: 5,
  //                 // offset: const Offset(0, 3), // Position of the shadow
  //               ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.all(15),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 title,
  //                 style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
  //               ),
  //               Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
  //             ],
  //           ),
  //         ),
  //       ),
  //       if (isExpanded)
  //         Container(
  //           margin: const EdgeInsets.only(bottom: 20), // Spacing after expanded content
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Column(
  //             children: children,
  //           ),
  //         ),
  //     ],
  //   );
  // }
  Widget buildDropdown(String title, List<Widget> children,
      {double titleTextSize = 18}) {
    bool isExpanded = _isExpanded[title] ?? false;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded[title] = !isExpanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(
                bottom: 10), // Add margin between dropdowns
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  // offset: const Offset(0, 3), // Position of the shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: titleTextSize),
                ),
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(
                bottom: 20), // Spacing after expanded content
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: children,
            ),
          ),
      ],
    );
  }

  Widget buildPointRow(String pointForName, String? points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pointForName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            points != null ? "+${points.toString()} pts" : "N/A",
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       leading: Container(),
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 20),
      //         height: 100,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             const SizedBox(height: 50),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: const Icon(Icons.arrow_back, color: Colors.white),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "Point System"),
      //                 Container(width: 20),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(67.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       automaticallyImplyLeading: false,
      //       flexibleSpace: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w),
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Padding(
      //           padding: EdgeInsets.only(top: 30.h),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               InkWell(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: const Icon(
      //                   Icons.arrow_back,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               AppBarText(color: Colors.white, text: "Point System"),
      //               Container(
      //                 width: 30,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(
        title: "Point System",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xffF0F1F5),
        child: FutureBuilder<Pointsmodelscreen>(
          future: _pointsSystemFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data?.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!.data!;
              return Column(
                children: [
                  // Updated TabBar with padding
                  TabBar(
                    tabAlignment: TabAlignment.start,

                    padding: const EdgeInsets.symmetric(vertical: 7),
                    controller: _tabController,
                    isScrollable: true,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    indicator: BoxDecoration(
                      color: Colors.black, // Active tab background color
                      borderRadius: BorderRadius.circular(21.0),
                    ),
                    labelColor: Colors.white, // Active tab text color
                    unselectedLabelColor:
                        Colors.black, // Inactive tab text color
                    tabs: data
                        .map((item) => Tab(
                              height: 42,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(item.matchTypeName ?? 'Unknown'),
                              ),
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: data.map<Widget>((item) {
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const SizedBox(height: 5),
                            buildDropdown(
                              "Fantasy Points",
                              [
                                buildDropdown(
                                  "Batting",
                                  item.pointTypes!
                                      .where((pointType) =>
                                          pointType.pointTypeName == "Batting")
                                      .expand<Widget>((pointType) {
                                    return pointType.pointFor
                                            ?.map<Widget>((point) {
                                          return buildPointRow(
                                              point.pointForName ?? '',
                                              point.points?.toString());
                                        }).toList() ??
                                        [];
                                  }).toList(),
                                ),
                                buildDropdown(
                                  "Bowling",
                                  item.pointTypes!
                                      .where((pointType) =>
                                          pointType.pointTypeName == "Bowling")
                                      .expand<Widget>((pointType) {
                                    return pointType.pointFor
                                            ?.map<Widget>((point) {
                                          return buildPointRow(
                                              point.pointForName ?? '',
                                              point.points?.toString());
                                        }).toList() ??
                                        [];
                                  }).toList(),
                                ),
                                buildDropdown(
                                  "Fielding",
                                  item.pointTypes!
                                      .where((pointType) =>
                                          pointType.pointTypeName ==
                                          "Fielding Points")
                                      .expand<Widget>((pointType) {
                                    return pointType.pointFor
                                            ?.map<Widget>((point) {
                                          return buildPointRow(
                                              point.pointForName ?? '',
                                              point.points?.toString());
                                        }).toList() ??
                                        [];
                                  }).toList(),
                                ),
                              ],
                              titleTextSize: 20,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
