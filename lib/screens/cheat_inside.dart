import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import '../db/app_db.dart';
import '../model/displaychetmodel.dart';
import '../screens/socket_service.dart';
class CheatInside extends StatefulWidget {
  const CheatInside({super.key});
  @override
  State<CheatInside> createState() => _CheatInsideState();
}
class _CheatInsideState extends State<CheatInside> {
  final TextEditingController usernameController = TextEditingController();
  String? userId;
  late SocketService _socketService;
  late StreamSubscription<String> _messageSubscription;
  late StreamController<displaychetModel> _chatStreamController;
  late ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMoreMessages = true; // Flag to indicate if there are more messages
  final int _messagesPerPage = 50;
  bool _isLoadingOlderMessages = false;
  bool _isLoadingInitialMessages = false;
  final List<Data> _allMessages = [];
  String? lastDisplayedDate;
  @override
  void initState() {
    super.initState();
    fetchUserId();
    _allMessages.clear(); // Clear list on reinitializing the page
    _chatStreamController = StreamController<displaychetModel>.broadcast();
    _socketService = Provider.of<SocketService>(context, listen: false);
    // _messageSubscription = _socketService.messages.listen((message) {
    //   print('msg sended succesfully 1...............');
    // });
    print('msg sended succesfully 2...............');
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //     // _scrollController.animateTo(duration: Duration(microseconds: 600),_scrollController.position.maxScrollExtent, curve: Curves.bounceIn);
    //   }
    // });
    _scrollController = ScrollController(
      initialScrollOffset: 100000, // Temporarily set to 0, will adjust in post-frame
    );
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels == 0) {
        print('msg sended succesfully 3...............');
        fetchData(
            loadMore: true); // Load more messages when scrolled to the top
      }
    });

  }
  @override
  void dispose() {
    _messageSubscription.cancel();
    _chatStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchUserId() async {
    String? fetchedUserId = await AppDB.appDB.getUserId();
    setState(() {
      userId = fetchedUserId;
    });
  }

  Future<void> postMessage(String message) async {
    print('msg printed55555555555555:-.....fdsfd....');
    String? token = await AppDB.appDB.getToken();
    final url =
    Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "$token",
      },
      body: jsonEncode({'message': message}),
    );
    print('msg printed666666666666666:-.....fdsfd....');

    if (response.statusCode == 200) {
      print('msg printed7777777777777777777777:-.....fdsfd....');

      _socketService.sendMessage(message); // Send message to Socket.IO server
    } else {
      print('Failed to post message: ${response.body}');
    }
  }
  Future<void> fetchData({bool loadMore = false}) async {
    print('Data is fetching...........................');
    if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;

    String? token = await AppDB.appDB.getToken();
    if (loadMore) {
      setState(() {
        _isLoadingOlderMessages = true;
        // _isLoadingOlderMessages = true;
      }); // Trigger a rebuild to show the loading indicator
    } else {
      setState(() {
        _isLoadingInitialMessages = true;
      });
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/chat/displayChat?page=$_currentPage&limit=$_messagesPerPage'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatModel = displaychetModel.fromJson(jsonResponse);

        if (chatModel.data != null && chatModel.data!.isNotEmpty) {
          setState(() {
            // Append new messages to the existing list
            // _allMessages.addAll(chatModel.data!);
            //final reversedMessages = chatModel.data!.reversed.toList(); // Reverse order
            //for (var newMessage in reversedMessages) {
            for (var newMessage in chatModel.data!) {
              if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) { // Assuming each message has a unique ID
                // _allMessages.add(newMessage);
                _allMessages.insert(0, newMessage); // Insert messages at the beginning

              }
            }
            print('msg is .......................${chatModel.data!}');
            print('Total messages after adding: ${_allMessages.length}'); // Log total messages
            _currentPage++; // Increment the page for the next fetch
            _isLoadingOlderMessages = false;
            _isLoadingInitialMessages = false;
            // Reset loading state
          });
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //
          //   if (_scrollController.hasClients) {
          //     _scrollController.animateTo(
          //       _scrollController.position.maxScrollExtent,
          //       duration: Duration(milliseconds: 900),
          //       curve: Curves.easeInOut,
          //     );
          //   }
          // });
          if (!loadMore) {
            SchedulerBinding.instance.addPostFrameCallback((_)  {
              if (_scrollController.hasClients) {
                // Timer(Duration.zero,() {_scrollController.jumpTo(_scrollController.position.maxScrollExtent);});

                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                // _scrollController.offset +10;
                print('offset:-${_scrollController.position.maxScrollExtent}');
                // _scrollController.jumpTo(_scrollController.position.extentInside + 280);

                // _scrollController.animateTo(duration: Duration(milliseconds: 01),_scrollController.position.extentAfter, curve: Curves.linear);

                // _scrollController.animateTo(
                //   _scrollController.position.maxScrollExtent,
                //   duration: Duration(milliseconds: 900),
                //   curve: Curves.easeInOut,
                // );
              }
            });
          }
        } else {
          setState(() {
            _hasMoreMessages = false; // No more messages to load
            _isLoadingOlderMessages = false;
            _isLoadingInitialMessages = false;
// Reset loading state
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _hasMoreMessages = false; // No more messages to load
          _isLoadingOlderMessages = false;
          _isLoadingInitialMessages = false;
// Reset loading state
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          _isLoadingOlderMessages = false;
          _isLoadingInitialMessages = false;
// Reset loading state
        });
      }
    } catch (e) {
      print('Exception caught in fetchData: $e');
      setState(() {
        _isLoadingOlderMessages = false;
        _isLoadingInitialMessages = false;
// Reset loading state
      });
    }
  }

  String _getDateLabel(String? dateAndTime) {
    if (dateAndTime == null) return '';
    final messageDate = DateTime.parse(dateAndTime);
    final currentDate = DateTime.now();
    if (messageDate.year == currentDate.year &&
        messageDate.month == currentDate.month &&
        messageDate.day == currentDate.day) {
      return 'Today';
    } else if (messageDate.year == currentDate.year &&
        messageDate.month == currentDate.month &&
        messageDate.day == currentDate.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(messageDate);
    }
  }

  // void _handleSendMessage() {
  //     print('msg printed:-.....fdsfd....');
  //
  //   final message = usernameController.text;
  //   if (message.isNotEmpty) {
  //       print('msg printed22222222222222222:-.....fdsfd....');
  //
  //     // Clear the input field
  //     usernameController.clear();
  //
  //     // Create a mock message object to add to the UI immediately
  //     final newMessage = Data(
  //       message: message,
  //       time: DateFormat('hh:mm a').format(DateTime.now()),
  //       dateAndTime: DateTime.now().toIso8601String(), // Full date-time string
  //       userDetails: UserDetails(sId: userId, name: 'You'), // Adjust this as needed
  //     );
  //
  //     // Add the new message to the list and update the UI
  //     setState(() {
  //         print('msg printed333333333333:-.....fdsfd....');
  //
  //       _allMessages.add(newMessage);
  //     });
  //         print('msg printed4444444444444444444:-.....fdsfd....');
  //
  //     // Ensure only one message is sent and added
  //     postMessage(message).then((_) {
  //       print('Message sent to server');
  //     }).catchError((error) {
  //       print('Error posting message: $error');
  //     });
  //
  //     // Scroll to the bottom after sending a message
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       if (_scrollController.hasClients) {
  //         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //       }
  //     });
  //   }
  // }
  void _handleSendMessage() {
    final message = usernameController.text;
    if (message.isNotEmpty) {
      final newMessage = Data(
        message: message,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        dateAndTime: DateTime.now().toIso8601String(), // Full date-time string
        userDetails: UserDetails(sId: userId, name: 'You'), // Adjust this as needed
      );

      // Add the new message to the list and update the UI
      setState(() {
        print('msg printed333333333333:-.....fdsfd....');

        _allMessages.add(newMessage);

      });
      print('msg printed4444444444444444444:-.....fdsfd....');
      postMessage(message).then((_) {
        usernameController.clear();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
        // fetchData(); // Refresh chat data after posting a message
      }).catchError((error) {
        print('Error posting message: $error');
      });
    }
  }
  // void _handleSendMessage() {
  //   print('msg printed:-.....fdsfd....');
  //   final message = usernameController.text;
  //   if (message.isNotEmpty) {
  //     // Clear the input field
  //     // Send the message to the server
  //     usernameController.clear();
  //     print('msg printed2222:-.....fdsfd....');
  //     // Create a mock message object to add to the UI immediately
  //     final newMessage = Data(
  //       message: message,
  //       time: DateFormat('hh:mm a').format(DateTime.now()),
  //       dateAndTime: DateTime.now().toIso8601String(), // Full date-time string
  //
  //       // Set the current time
  //       userDetails: UserDetails(sId: userId, name: 'You'), // Adjust this as needed
  //     );
  //     print('msg printed33333:-.....fdsfd....');
  //     // Add the new message to the list and update the UI
  //     setState(() {
  //       _allMessages.add(newMessage);
  //       print('msg printed4444444444444:-.....fdsfd....');
  //       print('Total messages after Sending message : ${_allMessages.length}');
  //       _isLoadingInitialMessages = false;
  //
  //     });
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       if (_scrollController.hasClients) {
  //         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //       }
  //     });
  //     postMessage(message).then((_) {
  //     }).catchError((error) {
  //       print('Error posting message: $error');
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      appBar: PreferredSize(
        // preferredSize: Size.fromHeight(screenHeight * 0.07),
        preferredSize: Size.fromHeight(67.0.h),
        child: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                width: 140.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/crictek_app_logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff140B40), Color(0xff140B40)],
              ),
            ),
          ),
        ),
      ),
      body:_isLoadingInitialMessages // Check if initial messages are still loading
          ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1D1459)),
        ),
      )
          : Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          if (_isLoadingOlderMessages)
          // debugPrint(object);// Show loading indicator at the top
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          Expanded(
            child: ListView.builder(
              // reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: _allMessages.length + (_isLoadingOlderMessages ? 1 : 0),
              // Show loading indicator if needed
              itemBuilder: (context, index) {
                if (index == _allMessages.length && _isLoadingOlderMessages) {
                  print('showing circular indicator......................');
                  // return const Center(child: CircularProgressIndicator(strokeWidth: 2,));
                }

                if (index >= _allMessages.length) return const SizedBox.shrink();

                final item = _allMessages[index]; // Use _allMessages directly
                final dateLabel = _getDateLabel(item.dateAndTime);
                // String? lastDisplayedDate;
                bool showDateLabel = false;
                final itemIndex = index;

                // Check if we should show the date label
                if (itemIndex == 0 ||
                    _getDateLabel(_allMessages[itemIndex - 1].dateAndTime) !=
                        dateLabel) {
                  // if (dateLabel != lastDisplayedDate) {
                  print("Comparing dates:");
                  print("Current message date label: $dateLabel");
                  // print("Last displayed date: $lastDisplayedDate");
                  showDateLabel = true;
                  lastDisplayedDate = dateLabel;
                  print('lastDisplayedDate:- $lastDisplayedDate');
                  if(lastDisplayedDate == null){
                    showDateLabel = false;// Print only once for each unique date
                  }
                  // }
                  // else if (lastDisplayedDate == null) {
                  // If `lastDisplayedDate` is null, do not show the date label
                  //  showDateLabel = false;
                  //}
                }
                final userDetails = item.userDetails;
                // final profilePhoto = userDetails?.profilePhoto ?? Image.asset('assets/remove.png');
                final profilePhotoUrl = userDetails?.profilePhoto;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: item.userDetails?.sId == userId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (showDateLabel) ...[
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: const Color(0xff777777).withOpacity(0.07),
                            ),
                            child: Center(
                              child: Text(
                                dateLabel,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: item.userDetails?.sId == userId
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (item.userDetails?.sId != userId) ...[
                            Stack(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.03,
                                  width: screenHeight * 0.03,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                                        ? Image.network(
                                      profilePhotoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/dummy_player.png');
                                      },
                                    )
                                        : Image.asset(
                                      'assets/remove.png', // Default image if URL is null or empty
                                      fit: BoxFit.cover,
                                    ),
                                    // child: Image.network(
                                    //   // item.userDetails!.profilePhoto!,
                                    //   profilePhoto.toString(),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                Positioned(
                                  bottom: screenHeight * 0.004,
                                  right: screenWidth * 0.01,
                                  child: Container(
                                    height: screenHeight * 0.005,
                                    width: screenHeight * 0.005,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color(0xff2BEF83),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: screenWidth * 0.03),
                          ],
                          Column(
                            crossAxisAlignment: item.userDetails?.sId == userId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (item.userDetails?.sId != userId) ...[
                                Text(
                                  item.userDetails?.name ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * 0.7,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: item.userDetails?.sId == userId
                                      ? const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )
                                      : const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: item.userDetails?.sId == userId
                                      ? const Color(0xff140B40)
                                      : const Color(0xff777777)
                                      .withOpacity(0.07),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.message ?? '',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.034,
                                        color: item.userDetails?.sId == userId
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      item.time ?? '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.025,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25,left: 10,right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: TextFormField(
                        maxLines: 1,
                        controller: usernameController,
                        decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.only(bottom: 5, left: 12, top: 0),
                          hintText: "Write your message",
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xff140B40),
                  ),
                  child: IconButton(
                    icon: Image.asset('assets/shares.png',
                        height: screenHeight * 0.02),
                    onPressed: () {
                      if (usernameController.text.isNotEmpty) {

                        print('print msg:---.....');
                        _handleSendMessage();
                        print('msg printed:-.........');
                        usernameController.clear();
                      }
                    },
                  ),
                ),

              ],
            ),

          ),
        ],
      ),
    );
  }
}


// if (_isLoadingOlderMessages)
// // debugPrint(object);// Show loading indicator at the top
//   Padding(
//     padding: EdgeInsets.symmetric(vertical: 10),
//     child: CircularProgressIndicator(
//       strokeWidth: 1,
//     ),
//   ),

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/scheduler.dart';
//
// import '../MY_Screen/add_cash_screen.dart';
// import '../db/app_db.dart';
// import '../model/displaychetmodel.dart';
// import '../screens/socket_service.dart';
//
// class CheatInside extends StatefulWidget {
//   const CheatInside({super.key});
//
//   @override
//   State<CheatInside> createState() => _CheatInsideState();
// }
//
// class _CheatInsideState extends State<CheatInside> {
//   final TextEditingController usernameController = TextEditingController();
//   String? userId;
//   late SocketService _socketService;
//   late StreamSubscription<String> _messageSubscription;
//   late StreamController<displaychetModel> _chatStreamController;
//   final ScrollController _scrollController = ScrollController();
//   int _currentPage = 1;
//   bool _hasMoreMessages = true; // Flag to indicate if there are more messages
//   final int _messagesPerPage = 50;
//   bool _isLoadingOlderMessages = false;
//   List<Data> _allMessages = [];
//   String? lastDisplayedDate;
//
// // Store all messages
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserId();
//     _isLoadingOlderMessages = true; // Set loading to true initially
//     _chatStreamController = StreamController<displaychetModel>.broadcast();
//     _socketService = Provider.of<SocketService>(context, listen: false);
//
//     _messageSubscription = _socketService.messages.listen((message) {
//       fetchData(); // Fetch new data when a new message arrives
//     });
//
//     fetchData();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.atEdge &&
//           _scrollController.position.pixels == 0) {
//         fetchData(
//             loadMore: true); // Load more messages when scrolled to the top
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _messageSubscription.cancel();
//     _chatStreamController.close();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchUserId() async {
//     String? fetchedUserId = await AppDB.appDB.getUserId();
//     setState(() {
//       userId = fetchedUserId;
//     });
//   }
//
//   Future<void> postMessage(String message) async {
//     String? token = await AppDB.appDB.getToken();
//     final url =
//         Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//       body: jsonEncode({'message': message}),
//     );
//
//     if (response.statusCode == 200) {
//       _socketService.sendMessage(message); // Send message to Socket.IO server
//     } else {
//       print('Failed to post message: ${response.body}');
//     }
//   }
//
//   Future<void> fetchData({bool loadMore = false}) async {
//     if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;
//
//     String? token = await AppDB.appDB.getToken();
//     if (loadMore) {
//       setState(() {
//         _isLoadingOlderMessages = true;
//       }); // Trigger a rebuild to show the loading indicator
//     }
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/chat/displayChat?page=$_currentPage&limit=$_messagesPerPage'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final chatModel = displaychetModel.fromJson(jsonResponse);
//
//         if (chatModel.data != null && chatModel.data!.isNotEmpty) {
//           setState(() {
//             // Append new messages to the existing list
//             _allMessages.addAll(chatModel.data!);
//             print(
//                 'Total messages after adding: ${_allMessages.length}'); // Log total messages
//             _currentPage++; // Increment the page for the next fetch
//             _isLoadingOlderMessages = false;
//             // Reset loading state
//           });
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             // if (_scrollController.hasClients) {
//             //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//             // }
//             if (_scrollController.hasClients) {
//               _scrollController.animateTo(
//                 _scrollController.position.maxScrollExtent,
//                 duration: Duration(milliseconds: 900),
//                 curve: Curves.easeInOut,
//               );
//             }
//           });
//         } else {
//           setState(() {
//             _hasMoreMessages = false; // No more messages to load
//             _isLoadingOlderMessages = false; // Reset loading state
//           });
//         }
//       } else if (response.statusCode == 404) {
//         setState(() {
//           _hasMoreMessages = false; // No more messages to load
//           _isLoadingOlderMessages = false; // Reset loading state
//         });
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//         setState(() {
//           _isLoadingOlderMessages = false; // Reset loading state
//         });
//       }
//     } catch (e) {
//       print('Exception caught in fetchData: $e');
//       setState(() {
//         _isLoadingOlderMessages = false; // Reset loading state
//       });
//     }
//   }
//
//   String _getDateLabel(String? dateAndTime) {
//     if (dateAndTime == null) return '';
//     final messageDate = DateTime.parse(dateAndTime);
//     final currentDate = DateTime.now();
//     if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day) {
//       return 'Today';
//     } else if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day - 1) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('dd MMM yyyy').format(messageDate);
//     }
//   }
//
//   void _handleSendMessage() {
//     print('msg printed:-.....fdsfd....');
//     final message = usernameController.text;
//     if (message.isNotEmpty) {
//       print('msg printed22222222222222222:-.....fdsfd....');
//       usernameController.clear();
//       postMessage(message).then((_) {
//         print('msg printed333333333333333:-.....fdsfd....');
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           if (_scrollController.hasClients) {
//             _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//           }
//         });
//                 _allMessages.add(Data(message: )); // Add the message to the UI after posting
//         print('msg printed44444444444444444444444:-.....fdsfd....');
//         fetchData();
//       }).catchError((error) {
//         print('Error posting message: $error');
//       });
//     }
//   }
//
//   // void _handleSendMessage() {
//   //   print('msg printed:-.....fdsfd....');
//   //   final message = usernameController.text;
//   //   if (message.isNotEmpty) {
//   //     print('msg printed2222:-.....fdsfd....');
//   //     // Create a mock message object to add to the UI immediately
//   //     final newMessage = Data(
//   //       message: message,
//   //       time: DateFormat('hh:mm a').format(DateTime.now()),
//   //       // Set the current time
//   //       userDetails:
//   //           UserDetails(sId: userId, name: 'You'), // Adjust this as needed
//   //     );
//   //     print('msg printed33333:-.....fdsfd....');
//   //     // Add the new message to the list and update the UI
//   //     setState(() {
//   //       _allMessages.add(newMessage);
//   //       print('msg printed4444444444444:-.....fdsfd....');
//   //     });
//   //
//   //     // Clear the input field
//   //     usernameController.clear();
//   //
//   //     // Send the message to the server
//   //     postMessage(message).then((_) {
//   //       // Optionally, you can fetchData() here if you want to refresh the message list
//   //       fetchData();
//   //     }).catchError((error) {
//   //       print('Error posting message: $error');
//   //     });
//   //   }
//   // }
//   // void _handleSendMessage() {
//   //     print('msg printed:-.....fdsfd....');
//   //
//   //   final message = usernameController.text;
//   //   if (message.isNotEmpty) {
//   //     print('msg printed22222222:-.....fdsfd....');
//   //     // Clear the text field immediately
//   //     usernameController.clear();
//   //
//   //     // Send the message to the server first
//   //     postMessage(message).then((_) {
//   //       print('msg printed3333333333333333333:-.....fdsfd....');
//   //       // Add the message to the list after it is posted
//   //       final newMessage = Data(
//   //         message: message,
//   //         time: DateFormat('hh:mm a').format(DateTime.now()),
//   //         userDetails: UserDetails(sId: userId, name: 'You'),
//   //       );
//   //
//   //       setState(() {
//   //         print('msg printed444444444444444444:-.....fdsfd....');
//   //         _allMessages.add(newMessage); // Add the message to the UI after posting
//   //       });
//   //       SchedulerBinding.instance.addPostFrameCallback((_) {
//   //                 if (_scrollController.hasClients) {
//   //                   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//   //                 }
//   //               });
//   //       // Optionally fetch new data here if you need to refresh
//   //       fetchData();
//   //     }).catchError((error) {
//   //       print('Error posting message: $error');
//   //     });
//   //   }
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(screenHeight * 0.07),
//         child: AppBar(
//           elevation: 0,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 100,
//                 width: 140,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/crictek_app_logo.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           flexibleSpace: Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xff1D1459), Color(0xff140B40)],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: screenHeight * 0.01),
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _allMessages.length + (_isLoadingOlderMessages ? 1 : 0),
//               // Show loading indicator if needed
//               itemBuilder: (context, index) {
//                 if (index == _allMessages.length && _isLoadingOlderMessages) {
//                   print('showing Circular Indicator....................');
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (index >= _allMessages.length) return SizedBox.shrink();
//
//                 final item = _allMessages[index]; // Use _allMessages directly
//                 final dateLabel = _getDateLabel(item.dateAndTime);
//                 // String? lastDisplayedDate;
//                 bool showDateLabel = false;
//                 final itemIndex = index;
//
//                 // Check if we should show the date label
//                 if (itemIndex == 0 ||
//                     _getDateLabel(_allMessages[itemIndex - 1].dateAndTime) !=
//                         dateLabel) {
//                   // showDateLabel = true;
//                   // lastDisplayedDate = dateLabel; // Update last displayed date
//                   // print('lastDisplayedDate:- $lastDisplayedDate'); // Print only once for each unique date
//                   if (dateLabel != lastDisplayedDate) {
//                     print("Comparing dates:");
//                     print("Current message date label: $dateLabel");
//                     // print("Last displayed date: $lastDisplayedDate");
//                     showDateLabel = true;
//                     lastDisplayedDate = dateLabel;
//                     print(
//                         'lastDisplayedDate:- $lastDisplayedDate'); // Print only once for each unique date
//                   } else if (lastDisplayedDate == null) {
//                     // If `lastDisplayedDate` is null, do not show the date label
//                     showDateLabel = false;
//                   }
//                 }
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                   child: Column(
//                     crossAxisAlignment: item.userDetails?.sId == userId
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: [
//                       // if (dateLabel.isNotEmpty) // Display date label if not empty
//                       //   Padding(
//                       //     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       //     child: Text(
//                       //       dateLabel,
//                       //       style: TextStyle(
//                       //         fontSize: screenWidth * 0.025,
//                       //         color: Colors.grey,
//                       //       ),
//                       //     ),
//                       //   ),
//                       if (showDateLabel) ...[
//                         SizedBox(height: screenHeight * 0.02),
//                         Center(
//                           child: Container(
//                             height: screenHeight * 0.05,
//                             width: screenWidth * 0.25,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(11),
//                               color: const Color(0xff777777).withOpacity(0.07),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 dateLabel,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: screenWidth * 0.03,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                       SizedBox(height: screenHeight * 0.04),
//                       Row(
//                         mainAxisAlignment: item.userDetails?.sId == userId
//                             ? MainAxisAlignment.end
//                             : MainAxisAlignment.start,
//                         children: [
//                           if (item.userDetails?.sId != userId) ...[
//                             Stack(
//                               children: [
//                                 SizedBox(
//                                   height: screenHeight * 0.03,
//                                   width: screenHeight * 0.03,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(30),
//                                     child: Image.network(
//                                       item.userDetails!.profilePhoto!,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: screenHeight * 0.004,
//                                   right: screenWidth * 0.01,
//                                   child: Container(
//                                     height: screenHeight * 0.005,
//                                     width: screenHeight * 0.005,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(4),
//                                       color: const Color(0xff2BEF83),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: screenWidth * 0.03),
//                           ],
//                           Column(
//                             crossAxisAlignment: item.userDetails?.sId == userId
//                                 ? CrossAxisAlignment.end
//                                 : CrossAxisAlignment.start,
//                             children: [
//                               if (item.userDetails?.sId != userId) ...[
//                                 Text(
//                                   item.userDetails?.name ?? '',
//                                   style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontSize: screenWidth * 0.03,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.005),
//                               ],
//                               Container(
//                                 constraints: BoxConstraints(
//                                   maxWidth: screenWidth * 0.7,
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: screenWidth * 0.03,
//                                   vertical: screenHeight * 0.015,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   borderRadius: item.userDetails?.sId == userId
//                                       ? const BorderRadius.only(
//                                           bottomRight: Radius.circular(10),
//                                           topLeft: Radius.circular(10),
//                                           bottomLeft: Radius.circular(10),
//                                         )
//                                       : const BorderRadius.only(
//                                           bottomLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10),
//                                           bottomRight: Radius.circular(10),
//                                         ),
//                                   color: item.userDetails?.sId == userId
//                                       ? const Color(0xff140B40)
//                                       : const Color(0xff777777)
//                                           .withOpacity(0.07),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       item.message ?? '',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.034,
//                                         color: item.userDetails?.sId == userId
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                     Text(
//                                       item.time ?? '',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: screenWidth * 0.025,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(screenWidth * 0.02),
//             child: Row(
//               children: [
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.7,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey.shade400,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Center(
//                     child: TextFormField(
//                       maxLines: 1,
//                       controller: usernameController,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.only(bottom: 5, left: 12, top: 10),
//                         hintText: "Write your message",
//                         hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: screenWidth * 0.05),
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.15,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xff140B40),
//                   ),
//                   child: IconButton(
//                     icon: Image.asset('assets/shares.png',
//                         height: screenHeight * 0.02),
//                     onPressed: () {
//                       // if (usernameController.text.isNotEmpty) {
//                       //   _handleSendMessage();
//                       // }
//                       if (usernameController.text.isNotEmpty) {
//                         postMessage(usernameController.text);
//
//                         print('print msg:---.....');
//                         _handleSendMessage();
//                         print('msg printed:-.........');
//                         usernameController.clear();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


//best
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:batting_app/screens/socket_service.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../MY_Screen/add_cash_screen.dart';
// import '../db/app_db.dart';
// import '../model/displaychetmodel.dart'; // Import SocketService
//
// class CheatInside extends StatefulWidget {
//   const CheatInside({super.key});
//
//   @override
//   State<CheatInside> createState() => _CheatInsideState();
// }
//
// class _CheatInsideState extends State<CheatInside> {
//   final TextEditingController usernameController = TextEditingController();
//   String? userId;
//   String? lastDisplayedDate;
//   late SocketService _socketService;
//   late StreamSubscription<String> _messageSubscription;
//   late StreamController<displaychetModel> _chatStreamController;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserId();
//     _chatStreamController = StreamController<displaychetModel>.broadcast();
//     // _chatStreamController = StreamController<displaychetModel>();
//     _socketService = Provider.of<SocketService>(context, listen: false);
//
//     // Listen for incoming messages
//     _messageSubscription = _socketService.messages.listen((message) {
//       fetchData(); // Fetch new data when a new message arrives
//     });
//
//     // Fetch initial data
//     fetchData();
//   }
//
//   @override
//   void dispose() {
//     _messageSubscription.cancel();
//     _chatStreamController.close();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchUserId() async {
//     String? fetchedUserId = await AppDB.appDB.getUserId();
//     setState(() {
//       userId = fetchedUserId;
//     });
//     print('userId $userId');
//   }
//
//   Future<void> postMessage(String message) async {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final url = Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//       body: jsonEncode({'message': message}),
//     );
//
//     if (response.statusCode == 200) {
//       print('Message posted successfully');
//       _socketService.sendMessage(message); // Send message to Socket.IO server
//     } else {
//       print('Failed to post message: ${response.body}');
//     }
//   }
//
//   Future<void> fetchData() async {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/chat/displayChat'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       final chatModel = displaychetModel.fromJson(jsonResponse);
//       _chatStreamController.add(chatModel);
//
//       // Scroll to the bottom after adding new messages
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//         }
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void _handleSendMessage() {
//     final message = usernameController.text;
//     if (message.isNotEmpty) {
//       postMessage(message).then((_) {
//         usernameController.clear();
//         // fetchData(); // Refresh chat data after posting a message
//       }).catchError((error) {
//         print('Error posting message: $error');
//       });
//     }
//   }
//
//   String _getDateLabel(String? dateAndTime) {
//     if (dateAndTime == null) return '';
//
//     final messageDate = DateTime.parse(dateAndTime);
//     final currentDate = DateTime.now();
//
//     // Compare dates
//     if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day) {
//       return 'Today';
//     } else if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day - 1) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('MMM dd yyyy').format(messageDate);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(screenHeight * 0.07),
//         child: ClipRRect(
//           child: AppBar(
//             elevation: 0,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(Icons.arrow_back, color: Colors.white),
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: 100,
//                   width: 140,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/crictek_app_logo.png"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             flexibleSpace: Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.05,
//                   vertical: screenHeight * 0.01),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: screenHeight * 0.01),
//           Expanded(
//             child: StreamBuilder<displaychetModel>(
//               stream: _chatStreamController.stream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.hasData) {
//                   final data = snapshot.data;
//                   String? lastDisplayedDate;
//
//                   return ListView.builder(
//                     controller: _scrollController,
//                     itemCount: data?.data?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final item = data!.data![index];
//
//                       // Check if dateAndTime is not null before parsing
//                       final messageDate = item.dateAndTime != null
//                           ? DateTime.parse(item.dateAndTime!)
//                           : DateTime.now(); // or handle it differently
//                       print('MessageData is ...............$messageDate');
//
//                       final dateLabel = _getDateLabel(item.dateAndTime);
//
//                       // Show the date label only if it's different from the last one
//                       bool showDateLabel = (lastDisplayedDate != dateLabel);
//                       if (showDateLabel) {
//                         lastDisplayedDate = dateLabel; // Update last displayed date
//                       }
//                       print('LastDisplayedDate is ...............$lastDisplayedDate');
//
//                       return Padding(
//                         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                         child: Column(
//                           crossAxisAlignment: item.userDetails?.sId == userId
//                               ? CrossAxisAlignment.end
//                               : CrossAxisAlignment.start,
//                           children: [
//                             if (showDateLabel) ...[
//                               SizedBox(height: screenHeight * 0.02),
//                               Center(
//                                 child: Container(
//                                   height: screenHeight * 0.05,
//                                   width: screenWidth * 0.25,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(11),
//                                     color: const Color(0xff777777).withOpacity(0.07),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       dateLabel,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: screenWidth * 0.03,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                             SizedBox(height: screenHeight * 0.04),
//                             Row(
//                               mainAxisAlignment: item.userDetails?.sId == userId
//                                   ? MainAxisAlignment.end
//                                   : MainAxisAlignment.start,
//                               children: [
//                                 if (item.userDetails?.sId != userId) ...[
//                                   Stack(
//                                     children: [
//                                       SizedBox(
//                                         height: screenHeight * 0.03,
//                                         width: screenHeight * 0.03,
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(30),
//                                           child: Image.network(
//                                             item.userDetails!.profilePhoto!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         bottom: screenHeight * 0.004,
//                                         right: screenWidth * 0.01,
//                                         child: Container(
//                                           height: screenHeight * 0.005,
//                                           width: screenHeight * 0.005,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(4),
//                                             color: const Color(0xff2BEF83),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(width: screenWidth * 0.03),
//                                 ],
//                                 Column(
//                                   crossAxisAlignment: item.userDetails?.sId == userId
//                                       ? CrossAxisAlignment.end
//                                       : CrossAxisAlignment.start,
//                                   children: [
//                                     if (item.userDetails?.sId != userId) ...[
//                                       Text(
//                                         item.userDetails?.name ?? '',
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                           fontSize: screenWidth * 0.03,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                     ],
//                                     Container(
//                                       constraints: BoxConstraints(
//                                         maxWidth: screenWidth * 0.7,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: screenWidth * 0.03,
//                                         vertical: screenHeight * 0.015,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         borderRadius: item.userDetails?.sId == userId
//                                             ? const BorderRadius.only(
//                                           bottomRight: Radius.circular(10),
//                                           topLeft: Radius.circular(10),
//                                           bottomLeft: Radius.circular(10),
//                                         )
//                                             : const BorderRadius.only(
//                                           bottomLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10),
//                                           bottomRight: Radius.circular(10),
//                                         ),
//                                         color: item.userDetails?.sId == userId
//                                             ? const Color(0xff140B40)
//                                             : const Color(0xff777777).withOpacity(0.07),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             item.message ?? '',
//                                             style: TextStyle(
//                                               fontSize: screenWidth * 0.034,
//                                               color: item.userDetails?.sId == userId ? Colors.white : Colors.black,
//                                             ),
//                                           ),
//                                           Text(
//                                             item.time ?? '',
//                                             style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: screenWidth * 0.025,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   return const Center(child: Text('No Message Available'));
//                 }
//               },
//             ),
//           ),
//           // Input area
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.05,
//               vertical: screenHeight * 0.02,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.7,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey.shade400,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Center(
//                     child: TextFormField(
//                       maxLines: 20,
//                       controller: usernameController,
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.only(bottom: 5, left: 12, top: 10),
//                         hintText: "Write your message",
//                         hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: screenWidth * 0.05),
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.15,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xff140B40),
//                   ),
//                   child: IconButton(
//                     icon: Image.asset('assets/shares.png', height: screenHeight * 0.02),
//                     onPressed: _handleSendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// String _getDateLabel(String? dateAndTime) {
//   if (dateAndTime == null) return '';
//
//   final messageDate = DateTime.parse(dateAndTime);
//   final normalizedCurrentDate = DateTime.now();
//   final normalizedYesterday =
//       normalizedCurrentDate.subtract(Duration(days: 1));
//
//   if (messageDate.isAtSameMomentAs(normalizedCurrentDate)) {
//     return 'Today';
//   } else if (messageDate.isAtSameMomentAs(normalizedYesterday)) {
//     return 'Yesterday';
//   } else {
//     return DateFormat('MMM dd yyyy').format(messageDate);
//   }
// }

// return ListView.builder(
//   controller: _scrollController,
//   itemCount: data?.data?.length ?? 0,
//   itemBuilder: (context, index) {
//     final item = data!.data![index];
//     final messageDate = DateTime.parse(item.dateAndTime!);
//     final dateLabel = _getDateLabel(item.dateAndTime);
//
//     bool showDateLabel = (lastDisplayedDate == null ||
//         lastDisplayedDate!.day != messageDate.day);
//
//     if (showDateLabel) {
//       lastDisplayedDate = messageDate;
//     }
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//       child: Column(
//         crossAxisAlignment: item.userDetails?.sId == userId
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           if (showDateLabel) ...[
//             Center(
//               child: Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   color: const Color(0xff777777).withOpacity(0.07),
//                 ),
//                 child: Text(dateLabel),
//               ),
//             ),
//           ],
//           Row(
//             mainAxisAlignment: item.userDetails?.sId == userId
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               if (item.userDetails?.sId != userId) ...[
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: Image.network(
//                     item.userDetails!.profilePhoto!,
//                     height: screenHeight * 0.03,
//                     width: screenHeight * 0.03,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//               ],
//               Column(
//                 crossAxisAlignment: item.userDetails?.sId == userId
//                     ? CrossAxisAlignment.end
//                     : CrossAxisAlignment.start,
//                 children: [
//     // if (item.userDetails?.sId != userId) ...[
//     //                 Text(
//     //                   item.userDetails?.name ?? '',
//     //                   style: TextStyle(
//     //                     color: Colors.grey.shade600,
//     //                     fontSize: screenWidth * 0.03,
//     //                     fontWeight: FontWeight.bold,
//     //                   ),
//     //                 ),
//     //                 SizedBox(height: screenHeight * 0.005),
//     //               ],
//                   Text(
//                     item.userDetails?.name ?? '',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.03,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       borderRadius: item.userDetails?.sId == userId
//                           ? BorderRadius.only(
//                         bottomRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                         bottomLeft: Radius.circular(10),
//                       )
//                           : BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                       color: item.userDetails?.sId == userId
//                           ? const Color(0xff140B40)
//                           : const Color(0xff777777).withOpacity(0.07),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           item.message ?? '',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.034,
//                             color: item.userDetails?.sId == userId
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                         Text(
//                           item.time ?? '',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   },
// );

//   final item = data!.data![index];
//
// // Check if dateAndTime is not null before parsing
// final messageDate = item.dateAndTime != null
//     ? DateTime.parse(item.dateAndTime!)
//     : DateTime.now(); // Handle null case appropriately
// print('MessageData is ...............$messageDate');
//
// final dateLabel = _getDateLabel(item.dateAndTime);
//
// // Show the date label only if it's different from the last one
// bool showDateLabel = (lastDisplayedDate != dateLabel);
// if (showDateLabel) {
//   lastDisplayedDate = dateLabel; // Update last displayed date
// }
// print('LastDisplayedDate is ...............$lastDisplayedDate');
//   final item = data!.data![index];
//
//   // Store the date of the current message
//   final messageDate = item.dateAndTime != null ? DateTime.parse(item.dateAndTime!) : DateTime.now();
//
//   // Define a local variable to store the last displayed date
//   // for this specific message
//   String? lastDateLabelForMessage;
//
//   final dateLabel = _getDateLabel(item.dateAndTime);
//   final showDateLabel = (lastDateLabelForMessage != dateLabel);
//
//   // Update the last displayed date for this message if needed
//   if (showDateLabel) {
//     lastDateLabelForMessage = dateLabel;
//   }

// @override
// Widget build(BuildContext context) {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;
//
//   return Scaffold(
//     appBar: PreferredSize(
//       preferredSize: Size.fromHeight(screenHeight * 0.07),
//       child: ClipRRect(
//         child: AppBar(
//           elevation: 0,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 // height: screenHeight * 0.12,
//                 // width: screenWidth * 0.4,
//                 height: 100,
//                 width: 140,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/crictek_app_logo.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           flexibleSpace: Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: screenWidth * 0.05,
//                 vertical: screenHeight * 0.01),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xff1D1459), Color(0xff140B40)],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//     body: Column(
//       children: [
//         SizedBox(height: screenHeight * 0.01),
//         Expanded(
//           child: StreamBuilder<displaychetModel>(
//             stream: _chatStreamController.stream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.hasData) {
//                 final data = snapshot.data;
//                 String? lastDisplayedDate;
//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: data?.data?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final item = data!.data![index];
//                     final isOwnMessage = item.userDetails?.sId == userId;
//                     final dateLabel = _getDateLabel(item.dateAndTime);
//
//                     bool showDateLabel = false;
//
//                     // Only show the date label if it is different from the last displayed date
//                     if (lastDisplayedDate != dateLabel) {
//                       showDateLabel = true;
//                       lastDisplayedDate = dateLabel; // Update the last displayed date
//                     }
//
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                       child: Column(
//                         crossAxisAlignment: isOwnMessage
//                             ? CrossAxisAlignment.end
//                             : CrossAxisAlignment.start,
//                         children: [
//                           if (showDateLabel) ...[
//                             SizedBox(height: screenHeight * 0.02),
//                             Center(
//                               child: Container(
//                                 height: screenHeight * 0.05,
//                                 width: screenWidth * 0.25,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(11),
//                                   color: const Color(0xff777777).withOpacity(0.07),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     dateLabel,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: screenWidth * 0.03,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                           SizedBox(height: screenHeight * 0.04),
//                           Row(
//                             mainAxisAlignment: isOwnMessage
//                                 ? MainAxisAlignment.end
//                                 : MainAxisAlignment.start,
//                             children: [
//                               if (!isOwnMessage) ...[
//                                 Stack(
//                                   children: [
//                                     SizedBox(
//                                       height: screenHeight * 0.03,
//                                       width: screenHeight * 0.03,
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(30),
//                                         child: Image.network(
//                                           item.userDetails!.profilePhoto!,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: screenHeight * 0.004,
//                                       right: screenWidth * 0.01,
//                                       child: Container(
//                                         height: screenHeight * 0.005,
//                                         width: screenHeight * 0.005,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(4),
//                                           color: const Color(0xff2BEF83),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: screenWidth * 0.03),
//                               ],
//                               Column(
//                                 crossAxisAlignment: isOwnMessage
//                                     ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                                 children: [
//                                   if (!isOwnMessage) ...[
//                                     Text(
//                                       item.userDetails?.name ?? '',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontSize: screenWidth * 0.03,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.005),
//                                   ],
//                                   Container(
//                                     constraints: BoxConstraints(
//                                       maxWidth: screenWidth * 0.7,
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.03,
//                                       vertical: screenHeight * 0.015,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: isOwnMessage
//                                           ? const BorderRadius.only(
//                                         bottomRight: Radius.circular(10),
//                                         topLeft: Radius.circular(10),
//                                         bottomLeft: Radius.circular(10),
//                                       )
//                                           : const BorderRadius.only(
//                                         bottomLeft: Radius.circular(10),
//                                         topRight: Radius.circular(10),
//                                         bottomRight: Radius.circular(10),
//                                       ),
//                                       color: isOwnMessage
//                                           ? const Color(0xff140B40)
//                                           : const Color(0xff777777).withOpacity(0.07),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           item.message ?? '',
//                                           style: TextStyle(
//                                             fontSize: screenWidth * 0.034,
//                                             color: isOwnMessage ? Colors.white : Colors.black,
//                                           ),
//                                         ),
//                                         Text(
//                                           item.time ?? '',
//                                           style: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: screenWidth * 0.025,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 return const Center(child: Text('No Message Available'));
//               }
//             },
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: screenWidth * 0.05,
//             vertical: screenHeight * 0.02,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: screenHeight * 0.06,
//                 width: screenWidth * 0.7,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: Colors.grey.shade400,
//                     width: 1.0,
//                   ),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Center(
//                   child: TextFormField(
//                     maxLines: 20,
//                     controller: usernameController,
//                     decoration: const InputDecoration(
//                       contentPadding: EdgeInsets.only(bottom: 5, left: 12, top: 10),
//                       hintText: "Write your message",
//                       hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: screenWidth * 0.05),
//               Container(
//                 height: screenHeight * 0.06,
//                 width: screenWidth * 0.15,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: const Color(0xff140B40),
//                 ),
//                 child: IconButton(
//                   icon: Image.asset('assets/shares.png', height: screenHeight * 0.02),
//                   onPressed: _handleSendMessage,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:batting_app/screens/socket_service.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../MY_Screen/add_cash_screen.dart';
// import '../db/app_db.dart';
// import '../model/displaychetmodel.dart'; // Import SocketService
//
// class CheatInside extends StatefulWidget {
//   const CheatInside({super.key});
//
//   @override
//   State<CheatInside> createState() => _CheatInsideState();
// }
//
// class _CheatInsideState extends State<CheatInside> {
//   final TextEditingController usernameController = TextEditingController();
//   String? userId;
//   String? lastDisplayedDate;
//   late SocketService _socketService;
//   late StreamSubscription<String> _messageSubscription;
//   late StreamController<displaychetModel> _chatStreamController;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserId();
//     _chatStreamController = StreamController<displaychetModel>();
//     _socketService = Provider.of<SocketService>(context, listen: false);
//
//     // Listen for incoming messages
//     _messageSubscription = _socketService.messages.listen((message) {
//       fetchData(); // Fetch new data when a new message arrives
//     });
//
//     // Fetch initial data
//     fetchData();
//   }
//
//   @override
//   void dispose() {
//     _messageSubscription.cancel();
//     _chatStreamController.close();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchUserId() async {
//     String? fetchedUserId = await AppDB.appDB.getUserId();
//     setState(() {
//       userId = fetchedUserId;
//     });
//     print('userId $userId');
//   }
//
//   Future<void> postMessage(String message) async {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final url =
//     Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//       body: jsonEncode({
//         'message': message,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('Message posted successfully');
//       _socketService.sendMessage(message); // Send message to Socket.IO server
//     } else {
//       print('Failed to post message: ${response.body}');
//     }
//   }
//
//   Future<void> fetchData() async {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token $token');
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/chat/displayChat'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       final chatModel = displaychetModel.fromJson(jsonResponse);
//       _chatStreamController.add(chatModel);
//
//       // Scroll to the bottom after adding new messages
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//         }
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void _handleSendMessage() {
//     final message = usernameController.text;
//     if (message.isNotEmpty) {
//       postMessage(message).then((_) {
//         usernameController.clear();
//         fetchData(); // Refresh chat data after posting a message
//       }).catchError((error) {
//         print('Error posting message: $error');
//       });
//     }
//   }
//
//   //String _getDateLabel(String? dateAndTime) {
//    // if (dateAndTime == null) return '';
//
//    // final messageDate = DateTime.parse(dateAndTime);
//     //final currentDate = DateTime.now().toLocal();
//     //final messageDateOnly = DateTime(messageDate.year, messageDate.month, messageDate.day);
//    // final currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//    // final difference = currentDateOnly.difference(messageDateOnly).inDays;
//
//     //if (difference == 0) {
//       //return 'Today';
// //    } else if (difference == 1) {
//   //    return 'Yesterday';
//     //} else {
//       //return DateFormat('MMM dd yyyy').format(messageDateOnly);
//     //}
//   //}
//
//   // String _getDateLabel(String? dateAndTime) {
//   //   if (dateAndTime == null) return '';
//   //
//   //   final messageDate = DateTime.parse(dateAndTime);
//   //   final messageDateOnly = DateTime(messageDate.year, messageDate.month, messageDate.day);
//   //
//   //   // Format the date as "MMM dd yyyy"
//   //   return DateFormat('MMM dd yyyy').format(messageDateOnly);
//   // }
//   String _getDateLabel(String? dateAndTime) {
//     if (dateAndTime == null) return '';
//
//     final messageDate = DateTime.parse(dateAndTime);
//     final currentDate = DateTime.now();
//
//     // Compare dates
//     if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day) {
//       return 'Today';
//     } else if (messageDate.year == currentDate.year &&
//         messageDate.month == currentDate.month &&
//         messageDate.day == currentDate.day - 1) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('MMM dd yyyy').format(messageDate);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(screenHeight * 0.1),
//         child: ClipRRect(
//           child: AppBar(
//             elevation: 0,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(Icons.arrow_back, color: Colors.white),
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: screenHeight * 0.12,
//                   width: screenWidth * 0.4,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/crictek_app_logo.png"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             flexibleSpace: Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.05,
//                   vertical: screenHeight * 0.01),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: screenHeight * 0.01),
//           Expanded(
//             child: StreamBuilder<displaychetModel>(
//               stream: _chatStreamController.stream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.hasData) {
//                   final data = snapshot.data;
//                   // String? lastDisplayedDate;
//                   return ListView.builder(
//                     controller: _scrollController,
//                     itemCount: data?.data?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final item = data!.data![index];
//                       final isOwnMessage = item.userDetails?.sId == userId;
//                       final dateLabel = _getDateLabel(item.dateAndTime);
//
//                       bool showDateLabel = false;
//
//                       // Only show the date label if it is different from the last displayed date
//                       if (lastDisplayedDate != dateLabel) {
//                         showDateLabel = true;
//                         lastDisplayedDate = dateLabel; // Update the last displayed date
//                       }
//                       // bool showDateLabel = false;
//                       // if (lastDisplayedDate != dateLabel) {
//                       //   showDateLabel = true;
//                       //   lastDisplayedDate = dateLabel;
//                       // }
//
//                       return Padding(
//                         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                         child: Column(
//                           crossAxisAlignment: isOwnMessage
//                               ? CrossAxisAlignment.end
//                               : CrossAxisAlignment.start,
//                           children: [
//                             if (showDateLabel) ...[
//                               SizedBox(height: screenHeight * 0.02),
//                               Center(
//                                 child: Container(
//                                   height: screenHeight * 0.05,
//                                   width: screenWidth * 0.25,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(11),
//                                     color: const Color(0xff777777).withOpacity(0.07),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       dateLabel,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: screenWidth * 0.03,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                             SizedBox(height: screenHeight * 0.04),
//                             Row(
//                               mainAxisAlignment: isOwnMessage
//                                   ? MainAxisAlignment.end
//                                   : MainAxisAlignment.start,
//                               children: [
//                                 if (!isOwnMessage) ...[
//                                   Stack(
//                                     children: [
//                                       SizedBox(
//                                         height: screenHeight * 0.03,
//                                         width: screenHeight * 0.03,
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(30),
//                                           child: Image.network(
//                                             item.userDetails!.profilePhoto!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         bottom: screenHeight * 0.004,
//                                         right: screenWidth * 0.01,
//                                         child: Container(
//                                           height: screenHeight * 0.005,
//                                           width: screenHeight * 0.005,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(4),
//                                             color: const Color(0xff2BEF83),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(width: screenWidth * 0.03),
//                                 ],
//                                 Column(
//                                   crossAxisAlignment: isOwnMessage
//                                       ? CrossAxisAlignment.end
//                                       : CrossAxisAlignment.start,
//                                   children: [
//                                     if(!isOwnMessage) ...[
//                                       Text(
//                                         item.userDetails?.name ?? '',
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                           fontSize: screenWidth * 0.03,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                     ],
//                                     Container(
//                                       constraints: BoxConstraints(
//                                         maxWidth: screenWidth * 0.7,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: screenWidth * 0.03,
//                                         vertical: screenHeight * 0.015,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         borderRadius: isOwnMessage
//                                             ? const BorderRadius.only(
//                                           bottomRight: Radius.circular(10),
//                                           topLeft: Radius.circular(10),
//                                           bottomLeft: Radius.circular(10),
//                                         )
//                                             : const BorderRadius.only(
//                                           bottomLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10),
//                                           bottomRight: Radius.circular(10),
//                                         ),
//                                         color: isOwnMessage
//                                             ? const Color(0xff140B40)
//                                             : const Color(0xff777777).withOpacity(0.07),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//
//                                           Text(
//                                             item.message ?? '',
//                                             style: TextStyle(
//                                               fontSize: screenWidth * 0.034,
//                                               color: isOwnMessage ? Colors.white : Colors.black,
//                                             ),
//                                           ),
//                                           Text(
//                                             item.time ?? '',
//                                             style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: screenWidth * 0.025,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   return const Center(child: Text('No Message Available'));
//                 }
//               },
//             ),
//           ),
//
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.05,
//               vertical: screenHeight * 0.02,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.7,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey.shade400,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Center(
//                     child: TextFormField(
//                     maxLines: 20,
//                       controller: usernameController,
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.only(bottom: 5, left: 12, top: 10),
//                         hintText: "Write your message",
//                         hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: screenWidth * 0.05),
//                 Container(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.15,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xff140B40),
//                   ),
//                   child: IconButton(
//                     icon: Image.asset('assets/shares.png', height: screenHeight * 0.02),
//                     onPressed: _handleSendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
