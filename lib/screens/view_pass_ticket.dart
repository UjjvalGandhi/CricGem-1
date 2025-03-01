import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/app_db.dart';
import '../model/ViewPastTicketModal.dart';
import '../widget/appbar_for_setting.dart';

class ViewPastTicket extends StatefulWidget {
  const ViewPastTicket({super.key});

  @override
  State<ViewPastTicket> createState() => _ViewPastTicketState();
}

class _ViewPastTicketState extends State<ViewPastTicket> {
  late Future<ViewPastTicketModal?> _futureData;
  List<bool> _isExpandedList =
      []; // List to track the expansion state of each ticket

  @override
  void initState() {
    super.initState();
    _futureData = profileDisplay(); // Initialize the future data
  }

  Future<ViewPastTicketModal?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/write_to_us/displayByUser'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = ViewPastTicketModal.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print(response.statusCode);
        // print('primMatch$primerMatch');
        // print('mymatches $myMatch');
        print("print from if part ${response.body}");

        return data;
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching profile data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      //         height: 90.h,
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
      //             SizedBox(height: 50.h),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: Icon(
      //                     Icons.arrow_back,
      //                     color: Colors.white,
      //                     size: 24.sp,
      //                   ),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "View Past Ticket"),
      //                 SizedBox(width: 20.w),
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
      //               AppBarText(color: Colors.white, text: "View Past Ticket"),
      //               Container(
      //                 width: 20,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(67.h),
//         child: ClipRRect(
//           child: AppBar(
//             leading: null,
//             automaticallyImplyLeading: false,
// // Remove the default back arrow
//             surfaceTintColor: const Color(0xffF0F1F5),
//             backgroundColor: const Color(0xffF0F1F5),
//             elevation: 0,
//             centerTitle: true,
//             flexibleSpace: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(top: 30.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Custom back button in white color
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,  // Set to white here
//                       ),
//                     ),
//                     AppBarText(color: Colors.white, text: "View Past Ticket"),
//                     Container(
//                       width: 30,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
      appBar: CustomAppBar(
        title: "View Past Ticket",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),

      body: Container(
        color: const Color(0xffF0F1F5),
        child: FutureBuilder<ViewPastTicketModal?>(
          future: _futureData,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError) {
            //   return Center(child: Text('Error: ${snapshot.error}'));
            // } else if (!snapshot.hasData || snapshot.data == null) {
            //   return const Center(child: Text('No past ticket available'));
            // }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: const Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data?.data.isEmpty == true) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: const Center(child: Text('no ticket available')));
            } else {
              final tickets = snapshot.data!.data;

              // Initialize the expansion state list
              if (_isExpandedList.length != tickets.length) {
                _isExpandedList = List<bool>.filled(tickets.length, false);
              }

              // Use a Set to track unique titles and descriptions
              Set<String> uniqueTickets = {};

              return Container(
                color: const Color(0xffF0F1F5),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      String ticketKey =
                          '${tickets[index].title}-${tickets[index].description}';

                      // Check for uniqueness
                      if (!uniqueTickets.contains(ticketKey)) {
                        uniqueTickets.add(ticketKey); // Add to the set

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // const SizedBox(height: 20), // Space before each dropdown
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: _buildDropdown(
                                    tickets[index].title,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        tickets[index].description,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 18),
                                      ),
                                    ),
                                    _isExpandedList[index],
                                    () {
                                      setState(() {
                                        _isExpandedList[index] =
                                            !_isExpandedList[index];
                                      });
                                    },
                                  ),
                                ),
                                // Divider(), // Divider between items
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Return an empty container for duplicates
                        return Container();
                      }
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// Widget _buildDropdown(String question, Widget answerWidget, bool isExpanded, VoidCallback onTap) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       GestureDetector(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   question,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 18,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
//             ],
//           ),
//         ),
//       ),
//       if (isExpanded) answerWidget,
//     ],
//   );
// }
Widget _buildDropdown(
    String title, Widget content, bool isExpanded, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10), // Space between dropdowns
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 2,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Color(0xffF6F7F9), // Header background color
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              color: Colors.white, // Content background color
            ),
            child: content,
          ),
      ],
    ),
  );
}




// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: PreferredSize(
//       preferredSize: Size.fromHeight(70.h),
//       child: ClipRRect(
//         child: AppBar(
//           leading: Container(),
//           surfaceTintColor: const Color(0xffF0F1F5),
//           backgroundColor: const Color(0xffF0F1F5),
//           elevation: 0,
//           centerTitle: true,
//           flexibleSpace: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//             height: 90.h,
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
//                 SizedBox(height: 50.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 24.sp,
//                       ),
//                     ),
//                     AppBarText(color: Colors.white, text: "View Past Ticket"),
//                     SizedBox(width: 20.w),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//     body: FutureBuilder<ViewPastTicketModal?>(
//       future: _futureData,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError || !snapshot.hasData) {
//           return Center(child: Text('Error fetching data'));
//         } else {
//           final tickets = snapshot.data!.data;
//
//           // Initialize the expansion state list
//           if (_isExpandedList.length != tickets.length) {
//             _isExpandedList = List<bool>.filled(tickets.length, false);
//           }
//
//           return Container(
//             color: const Color(0xffF0F1F5),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: ListView.builder(
//                 itemCount: tickets.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     // height: MediaQuery.of(context).size.height, // Set the height to match your design
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.symmetric(horizontal: 1),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: List.generate(tickets.length, (index) {
//                           return Column(
//                             children: [
//                               SizedBox(height: 20), // Space before each dropdown
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: _buildDropdown(
//                                   tickets[index].title,
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                                     child: Text(
//                                       tickets[index].description,
//                                       style: TextStyle(color: Colors.black45,fontSize: 15),
//                                     ),
//                                   ),
//                                   _isExpandedList[index],
//                                       () {
//                                     setState(() {
//                                       _isExpandedList[index] = !_isExpandedList[index];
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Divider(color: Colors.grey.shade300), // Divider between items
//                             ],
//                           );
//                         }),
//                       ),
//                     ),
//                   );
//                   // return Container(
//                   //   padding: const EdgeInsets.all(15),
//                   //   height: MediaQuery.of(context).size.height,
//                   //   width: MediaQuery.of(context).size.width,
//                   //   color: const Color(0xffF0F1F5),
//                   //   child: _buildDropdown(
//                   //     tickets[index].title,
//                   //     Padding(
//                   //       padding: const EdgeInsets.all(15.0),
//                   //       child: Column(
//                   //         crossAxisAlignment: CrossAxisAlignment.start,
//                   //         children: [
//                   //           Text(tickets[index].description, style: TextStyle(fontSize: 14)),
//                   //         ],
//                   //       ),
//                   //     ),
//                   //     _isExpandedList[index],
//                   //         () {
//                   //       setState(() {
//                   //         _isExpandedList[index] = !_isExpandedList[index];
//                   //       });
//                   //
//                   //     },
//                   //   ),
//                   //
//                   // );
//                 },
//               ),
//             ),
//           );
//         }
//       },
//     ),
//   );
// }