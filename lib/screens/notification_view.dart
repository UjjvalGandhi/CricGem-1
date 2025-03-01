import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/notificationprovider.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String formatDate(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications();
  }

  String formatTime(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.hour}:${parsedDate.minute}";
    } catch (e) {
      return "Invalid Time";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      appBar: const CustomAppBar(title: 'Notifications'),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.notifications.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }

          final notifications = notificationProvider.notifications;

          return ListView.builder(
            padding: const EdgeInsets.all(6.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final dateAndTime = notification["dateAndTime"] ?? "";
              final date = formatDate(dateAndTime);
              final time = formatTime(dateAndTime);

              return Card(
                color: Colors.white,
                elevation:
                    6.0, // Slightly higher elevation for a prominent shadow effect
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal:
                        12.0), // Added horizontal margin for better spacing
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Softer corners for a modern look
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      20.0), // Increased padding for better readability
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              notification["title"] ?? "No Title Available",
                              style: const TextStyle(
                                fontSize: 20.0, // Larger font for title
                                fontWeight: FontWeight.bold,
                                color: Color(
                                    0xFF333333), // Darker color for better contrast
                              ),
                            ),
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 14.0, // Slightly smaller font for date
                              // fontStyle: FontStyle.italic, // Italic for a distinct appearance
                              color: Color(
                                  0xff140B40), // Subtle color for the date
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20.0, // Divider for better separation
                        thickness: 1.0,
                        color: Colors.grey, // Subtle color for the divider
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0), // Spacing after the message
                        child: Text(
                          notification["message"] ?? "No Message Available",
                          style: const TextStyle(
                            fontSize: 16.0, // Balanced font size for content
                            color:
                                Color(0xFF555555), // Slightly muted text color
                            height: 1.5, // Line height for better readability
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment
                            .bottomRight, // Positioned to the bottom right
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 14.0, // Smaller font for the time
                            color: Colors.grey, // Muted color for subtlety
                            fontWeight:
                                FontWeight.w500, // Medium weight for emphasis
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../db/app_db.dart';
// import '../model/NotificationModal.dart';
// import '../widget/appbar_for_setting.dart';
//
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});
//
//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }
//
// class _NotificationViewState extends State<NotificationView> {
//   late Future<List<Map<String, String>>> _futureNotifications;
//   final String apiUrl = "https://batting-api-1.onrender.com/api/notification/update";
//
//   @override
//   void initState() {
//     super.initState();
//     _futureNotifications = fetchNotifications();
//     updateNotificationStatus();
//
//   }
//
//   Future<List<Map<String, String>>> fetchNotifications() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token: $token');
//
//       final response = await http.get(
//         Uri.parse(
//           'https://batting-api-1.onrender.com/api/notification/displayNotification',
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         if (responseData['success']) {
//           List<Map<String, String>> notifications = [];
//           for (var notification in responseData['data']) {
//             notifications.add({
//               "title": notification["title"] ?? "No Title",
//               "message": notification["message"] ?? "No Message",
//               "dateAndTime": notification["dateAndTime"] ?? "No dateAndTime",
//             });
//           }
//           return notifications;
//         } else {
//           debugPrint('API Response Error: ${responseData['message']}');
//           return [];
//         }
//       } else {
//         debugPrint('Failed to fetch notifications: ${response.statusCode}');
//         return [];
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error fetching notifications: $e');
//       debugPrint('Stack trace: $stackTrace');
//       return [];
//     }
//   }
//   Future<void> updateNotificationStatus() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token: $token');
//       // Create the request body (if required by your API)
//       Map<String, dynamic> requestBody = {
//
//         // Add necessary request parameters here if needed
//       };
//
//       // Make the POST request
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       // Handle the response
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData['success'] == true) {
//           debugPrint("Status updated successfully: ${responseData['message']}");
//           debugPrint("Data: ${responseData['data']}");
//         } else {
//           debugPrint("Failed to update status: ${responseData['message']}");
//         }
//       } else {
//         debugPrint("Failed with status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("Error occurred: $e");
//     }
//   }
//   String formatDate(String dateTime) {
//     try {
//       DateTime parsedDate = DateTime.parse(dateTime);
//       return DateFormat('dd-MM-yyyy').format(parsedDate);
//     } catch (e) {
//       return "Invalid Date";
//     }
//   }
//
//   String formatTime(String dateTime) {
//     try {
//       DateTime parsedDate = DateTime.parse(dateTime);
//       return DateFormat('hh:mm a').format(parsedDate); // 12-hour format
//     } catch (e) {
//       return "Invalid Time";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF0F1F5),
//       appBar: CustomAppBar(title: 'Notifications'),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: _futureNotifications,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error loading notifications"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No notifications available"));
//           }
//
//           final notifications = snapshot.data!;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(6.0),
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               final dateAndTime = notification["dateAndTime"] ?? "";
//               final date = formatDate(dateAndTime);
//               final time = formatTime(dateAndTime);
//
//               return Card(
//                   elevation: 6.0, // Slightly higher elevation for a prominent shadow effect
//                   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Added horizontal margin for better spacing
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0), // Softer corners for a modern look
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0), // Increased padding for better readability
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 notification["title"] ?? "No Title Available",
//                                 style: const TextStyle(
//                                   fontSize: 20.0, // Larger font for title
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF333333), // Darker color for better contrast
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               date ?? "No Date",
//                               style: const TextStyle(
//                                 fontSize: 14.0, // Slightly smaller font for date
//                                 fontStyle: FontStyle.italic, // Italic for a distinct appearance
//                                 color: Color(0xff140B40), // Subtle color for the date
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           height: 20.0, // Divider for better separation
//                           thickness: 1.0,
//                           color: Colors.grey, // Subtle color for the divider
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 10.0), // Spacing after the message
//                           child: Text(
//                             notification["message"] ?? "No Message Available",
//                             style: const TextStyle(
//                               fontSize: 16.0, // Balanced font size for content
//                               color: Color(0xFF555555), // Slightly muted text color
//                               height: 1.5, // Line height for better readability
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight, // Positioned to the bottom right
//                           child: Text(
//                             time ?? "No Time",
//                             style: const TextStyle(
//                               fontSize: 14.0, // Smaller font for the time
//                               color: Colors.grey, // Muted color for subtlety
//                               fontWeight: FontWeight.w500, // Medium weight for emphasis
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//
//
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../widget/appbar_for_setting.dart';
// import '../widget/notificationprovider.dart';
//
// class NotificationView extends StatelessWidget {
//   const NotificationView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<NotificationProvider>(context);
//     // Future.microtask(() => provider.fetchNotifications());
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF0F1F5),
//       appBar: const CustomAppBar(title: 'Notifications'),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.notifications.isEmpty
//           ? const Center(child: Text("No notifications available"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(6.0),
//         itemCount: provider.notifications.length,
//         itemBuilder: (context, index) {
//           final notification = provider.notifications[index];
//           final date = provider.formatDate(
//             notification["dateAndTime"] ?? "",
//           );
//           final time = provider.formatTime(
//             notification["dateAndTime"] ?? "",
//           );
//
//           return Card(
//             elevation: 6.0,
//             margin: const EdgeInsets.symmetric(
//                 vertical: 8.0, horizontal: 12.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           notification["title"] ??
//                               "No Title Available",
//                           style: const TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF333333),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         date,
//                         style: const TextStyle(
//                           fontSize: 14.0,
//                           fontStyle: FontStyle.italic,
//                           color: Color(0xff140B40),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     height: 20.0,
//                     thickness: 1.0,
//                     color: Colors.grey,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Text(
//                       notification["message"] ??
//                           "No Message Available",
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF555555),
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Text(
//                       time,
//                       style: const TextStyle(
//                         fontSize: 14.0,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


//   Card(
//   elevation: 4.0,
//   margin: const EdgeInsets.symmetric(vertical: 8.0),
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(10.0),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Text(
//                 notification["title"] ?? "",
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               "${date!}",
//               style: const TextStyle(fontSize: 16.0),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Text(
//                 notification["message"] ?? "",
//                 style: const TextStyle(fontSize: 16.0),
//               ),
//             ),
//             Text(
//               '${time!}',
//               style: const TextStyle(fontSize: 16.0),
//             ),
//           ],
//         ),
//         // Text(
//         //   notification["dateAndTime"] ?? "",
//         //   style: const TextStyle(fontSize: 16.0),
//         // ),
//       ],
//     ),
//   ),
// );
// import 'dart:convert';
//
// import 'package:batting_app/widget/appbar_for_setting.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../db/app_db.dart';
// import '../model/NotificationModal.dart';
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});
//
//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }
//
// class _NotificationViewState extends State<NotificationView> {
//   late Future<NotificationModal?> _futureData;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureData = profileDisplay(); // Initialize the future data
//   }
//
//
//   Future<NotificationModal?> profileDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/notification/displayNotification'
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       print(response.body);
//       if (response.statusCode == 200) {
//         final data = NotificationModal.fromJson(jsonDecode(response.body));
//         debugPrint('Data: ${data.message}');
//         print(response.statusCode);
//         // print('primMatch$primerMatch');
//         // print('mymatches $myMatch');
//         print("print from if part ${response.body}");
//
//         return data;
//       } else {
//         debugPrint('Failed to fetch profile data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error fetching profile data: $e');
//       debugPrint('Stack trace: $stackTrace');
//       return null;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: 'Notification'),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//
//           ],
//         ),
//       ),
//     );
//   }
// }



// Card(
//   elevation: 5.0,
//   margin: const EdgeInsets.symmetric(vertical: 8.0),
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(10.0),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Text(
//                 notification["title"] ?? "",
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               "${date!}",
//               style: const TextStyle(fontSize: 16.0),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           notification["message"] ?? "",
//           style: const TextStyle(fontSize: 16.0),
//         ),
//         // const SizedBox(height: 12.0), // Add spacing before the time
//         Align(
//           alignment: Alignment.bottomRight, // Align the time to the bottom left
//           child: Text(
//             '${time!}',
//             style: const TextStyle(fontSize: 14.0, color: Colors.grey),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
