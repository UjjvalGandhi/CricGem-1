import 'package:batting_app/screens/view_pass_ticket.dart';
import 'package:batting_app/screens/writetous_screen.dart';
import 'package:flutter/material.dart';
import 'package:batting_app/widget/normal_400.dart';
import 'package:batting_app/widget/smalltext.dart';
import '../model/HeldandSupportModel.dart';
import 'package:http/http.dart' as http;

import '../widget/appbar_for_setting.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  bool _isWithdrawalExpanded1 = false;
  final bool _isWithdrawalExpanded2 = false;
  final bool _isWithdrawalExpanded3 = false;
  late Future<HeldandSupportModel> _futureHelpAndSupport;

  @override
  void initState() {
    super.initState();
    _futureHelpAndSupport = fetchHelpAndSupport();
  }

  Future<HeldandSupportModel> fetchHelpAndSupport() async {
    final response = await http.get(Uri.parse(
        'https://batting-api-1.onrender.com/api/help_and_support/display'));

    if (response.statusCode == 200) {
      return heldandSupportModelFromJson(response.body);
    } else {
      throw Exception('Failed to load help and support data');
    }
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
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
      //                 AppBarText(color: Colors.white, text: "Help & Support"),
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
      //
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
      //               AppBarText(color: Colors.white, text: "Help & Support"),
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
        title: "Help & Support",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder<HeldandSupportModel>(
        future: _futureHelpAndSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data?.data == null ||
              snapshot.data!.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final helpAndSupportData = snapshot.data!;

          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffF0F1F5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewPastTicket(),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 26,
                                width: 238,
                                child: Row(
                                  children: [
                                    Image.asset('assets/carbon_ticket.png',
                                        height: 24),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "View Past Tickets",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SmallText(
                          color: Colors.grey,
                          text: "Frequently Asked Questions",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 310,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: helpAndSupportData.data!.map((item) {
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: _buildDropdown(
                                      item.question ?? 'No question',
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          item.answer ?? 'No answer',
                                          style: const TextStyle(
                                              color: Colors.black45),
                                        ),
                                        // SmallText(
                                        //   color: Colors.black45,
                                        //   text: item.answer ?? 'No answer',
                                        // ),
                                      ),
                                      _isWithdrawalExpanded1,
                                      () {
                                        setState(() {
                                          _isWithdrawalExpanded1 =
                                              !_isWithdrawalExpanded1;
                                        });
                                      },
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade300),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 115,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Normal400(
                          color: Colors.black,
                          text: "Didn't find what you were looking for?"),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WriteToUsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 354,
                          decoration: BoxDecoration(
                            // color: const Color(0xff140B40).withOpacity(0.05),
                            color: const Color(0xff140B40),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xff140B40).withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset('assets/write to us.png', height: 14, color: const Color(0xff140B40)),
                                Image.asset('assets/write to us.png',
                                    height: 14, color: Colors.white),

                                const SizedBox(width: 5),
                                const Text(
                                  "Write to Us",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String question, Widget answerWidget, bool isExpanded,
      VoidCallback onTap) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.start, // Align column items at the start
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align items at the start horizontally
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis, // Handles long text
                  ),
                ),
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0), // Optional padding for answer text
            child: answerWidget,
          ),
      ],
    );
  }
}
