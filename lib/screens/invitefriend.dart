import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../model/referandearnModel.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/small3.dart';
import '../widget/smalltext.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key});

  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  bool _isWithdrawalExpanded1 = false;
  bool _isWithdrawalExpanded2 = false;
  bool _isWithdrawalExpanded3 = false;
  ReferandearnModel? _referandearnModel;

  @override
  void initState() {
    super.initState();
    _fetchReferAndEarnData();
  }

  Future<void> _fetchReferAndEarnData() async {
    const url = 'https://batting-api-1.onrender.com/api/referAndEarn/display';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _referandearnModel = referandearnModelFromJson(response.body);
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: false,
  //     // Prevent resizing
  //     appBar: PreferredSize(
  //       preferredSize: Size.fromHeight(60.h),
  //       child: ClipRRect(
  //         child: AppBar(
  //           leading: Container(),
  //           surfaceTintColor: const Color(0xffF0F1F5),
  //           backgroundColor: const Color(0xffF0F1F5),
  //           elevation: 0,
  //           centerTitle: true,
  //           flexibleSpace: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //             height: 100,
  //             width: MediaQuery.of(context).size.width,
  //             decoration: const BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //                 colors: [Color(0xff1D1459), Color(0xff140B40)],
  //               ),
  //             ),
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: 50),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     InkWell(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Icon(
  //                         Icons.arrow_back,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     AppBarText(color: Colors.white, text: "Invite Friends"),
  //                     Container(
  //                       width: 20,
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     body: _referandearnModel == null
  //         ? const Center(child: CircularProgressIndicator())
  //         : SingleChildScrollView(
  //                 physics:  const ClampingScrollPhysics(),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // const SizedBox(height: 10),
  //               Stack(
  //                 children: [
  //                   Container(
  //                     height: 240.h,
  //                     width: double.infinity,
  //                     decoration: const BoxDecoration(
  //                       image: DecorationImage(
  //                         image: AssetImage('assets/Invite1.png'),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                     child: Align(
  //                       alignment: Alignment.topLeft,
  //                       child: Padding(
  //                         padding: EdgeInsets.only(top: 43.h, left: 27.w),
  //                         child: Container(
  //                           width: double.infinity,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: -15,
  //                     top: 0,
  //                     child: Container(
  //                       height: 240.h,
  //                       width: 150.h,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage('assets/Invite2.png'),
  //                           fit: BoxFit.cover,
  //                         ),
  //                         // borderRadius: BorderRadius.circular(15),
  //                       ),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Padding(
  //                           padding: EdgeInsets.only(top: 45.h, left: 27.w),
  //                           child: Container(
  //                             width: double.infinity,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: 5,
  //                     top: 15,
  //                     child: Container(
  //                       height: 218.h,
  //                       width: 140.h,
  //                       decoration: BoxDecoration(
  //                         image: const DecorationImage(
  //                           image: AssetImage('assets/Invite3.png'),
  //                           fit: BoxFit.cover,
  //                         ),
  //                         borderRadius: BorderRadius.circular(15),
  //                       ),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Padding(
  //                           padding: EdgeInsets.only(top: 45.h, left: 27.w),
  //                           child: Container(
  //                             width: double.infinity,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //
  //               ),
  //               SizedBox(height: 10.h),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 15.w),
  //                 child: SmallText(
  //                   color: Colors.grey,
  //                   text: "Frequently Asked Questions",
  //                 ),
  //               ),
  //               SizedBox(height: 5.h),
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(15.r),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SizedBox(height: 12.h),
  //                     for (var i = 0; i < _referandearnModel!.data!.length; i++)
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(bottom: 5.h),
  //                             child: _buildDropdown(
  //                               _referandearnModel!.data![i].question ?? "",
  //                               Padding(
  //                                 padding: EdgeInsets.only(right: 40.w, left: 10.w),
  //                                 child: Small3Text(
  //                                   color: Colors.black45,
  //                                   text: _referandearnModel!.data![i].answer ?? "",
  //                                 ),
  //                               ),
  //                               i == 0
  //                                   ? _isWithdrawalExpanded1
  //                                   : i == 1
  //                                   ? _isWithdrawalExpanded2
  //                                   : _isWithdrawalExpanded3,
  //                                   () {
  //                                 setState(() {
  //                                   if (i == 0) {
  //                                     _isWithdrawalExpanded1 = !_isWithdrawalExpanded1;
  //                                   } else if (i == 1) {
  //                                     _isWithdrawalExpanded2 = !_isWithdrawalExpanded2;
  //                                   } else {
  //                                     _isWithdrawalExpanded3 = !_isWithdrawalExpanded3;
  //                                   }
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                           Divider(
  //                             color: Colors.grey.shade300,
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //     bottomNavigationBar: Container(
  //       // height: 100.h,
  //       padding: EdgeInsets.all(20.w),
  //       color: const Color(0xffF0F1F5),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           GestureDetector(
  //             onTap: (){
  //               Share.share("www.google.com", subject: 'Check this out!');
  //             },
  //             child: Container(
  //               height: 48.h,
  //               width: MediaQuery.of(context).size.width * 0.88,
  //               decoration: BoxDecoration(
  //                 color: const Color(0xff008000),
  //                 borderRadius: BorderRadius.circular(8.r),
  //               ),
  //               child: Center(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 1),
  //                       child: Image.asset(
  //                         'assets/whatsup.png',
  //                         height: 18.h,
  //                       ),
  //                     ),
  //                     SizedBox(width: 5.w),
  //                     Text(
  //                       "Invite Now",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 16.sp,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildDropdown(String question, Widget answerWidget, bool isExpanded,
      VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  question,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (isExpanded) answerWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      resizeToAvoidBottomInset: false,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.h),
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
      //                   child: const Icon(
      //                     Icons.arrow_back,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "Invite Friends"),
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
      //       automaticallyImplyLeading: false,
      //
      //       centerTitle: true,
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
      //               AppBarText(color: Colors.white, text: "Invite Friends"),
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
        title: "Invite Friends",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: _referandearnModel == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Enable scrolling
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 240.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/Invite1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: -15,
                          top: 0,
                          child: Container(
                            height: 240.h,
                            width: 150.h,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/Invite2.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          top: 15,
                          child: Container(
                            height: 218.h,
                            width: 140.h,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/Invite3.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    SmallText(
                      color: Colors.grey,
                      text: "Frequently Asked Questions",
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          for (var i = 0;
                              i < _referandearnModel!.data!.length;
                              i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.h),
                                  child: _buildDropdown(
                                    _referandearnModel!.data![i].question ?? "",
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 40.w, left: 10.w),
                                      child: Small3Text(
                                        color: Colors.black45,
                                        text: _referandearnModel!
                                                .data![i].answer ??
                                            "",
                                      ),
                                    ),
                                    i == 0
                                        ? _isWithdrawalExpanded1
                                        : i == 1
                                            ? _isWithdrawalExpanded2
                                            : _isWithdrawalExpanded3,
                                    () {
                                      setState(() {
                                        if (i == 0) {
                                          _isWithdrawalExpanded1 =
                                              !_isWithdrawalExpanded1;
                                        } else if (i == 1) {
                                          _isWithdrawalExpanded2 =
                                              !_isWithdrawalExpanded2;
                                        } else {
                                          _isWithdrawalExpanded3 =
                                              !_isWithdrawalExpanded3;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Divider(color: Colors.grey.shade300),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        color: const Color(0xffF0F1F5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Share.share("www.google.com", subject: 'Check this out!');
              },
              child: Container(
                height: 48.h,
                width: MediaQuery.of(context).size.width * 0.88,
                decoration: BoxDecoration(
                  color: const Color(0xff008000),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Image.asset(
                          'assets/whatsup.png',
                          height: 18.h,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Invite Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// appBar: PreferredSize(
//   preferredSize: Size.fromHeight(70.0),
//   child: AppBar(
//     leading: Container(),
//     surfaceTintColor: const Color(0xffF0F1F5),
//     backgroundColor: const Color(0xffF0F1F5),
//     elevation: 0,
//     centerTitle: true,
//     flexibleSpace: Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
//       height: 100.h,
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xff1D1459), Color(0xff140B40)],
//         ),
//       ),
//       child: Column(
//         children: [
//           SizedBox(height: 50.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(Icons.arrow_back, color: Colors.white)),
//               AppBarText(color: Colors.white, text: "Invite Friends"),
//               SizedBox(width: 20.w),
//             ],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // Set your design size
//       minTextAdapt: true,
//       builder: (context, child) {
//         return MaterialApp(
//           title: 'Invite Friends',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//           ),
//           home: const InviteFriend(),
//         );
//       },
//     );
//   }
// }



// Container(
//   height: 48.h,
//   width: MediaQuery.of(context).size.width * 0.12,
//   decoration: BoxDecoration(
//     border: Border.all(width: 1.w, color: Colors.grey),
//     borderRadius: BorderRadius.circular(10.r),
//   ),
//   child: Center(
//     child: Image.asset('assets/share_grey.png', height: 19.h),
//   ),
// ),