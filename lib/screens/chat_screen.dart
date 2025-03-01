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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController usernameController = TextEditingController();
  String? userId;
  late SocketService _socketService;
  // late StreamSubscription<String> _messageSubscription;
  late StreamSubscription<Map<String, dynamic>> _messageSubscription;
  late StreamController<displaychetModel> _chatStreamController;
  // final ScrollController _scrollController = ScrollController();
  late ScrollController _scrollController;
  var userName;
  var nouser;
  var pic;
  var otherpic;
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
    //   print('message is:- $message');
    //   fetchData();
    // });

    _messageSubscription = _socketService.messages.listen((data) {
      print('Received message: $data');

      try {
        // Access the message fields
        final String userId = data['userId'].toString();
        final String userName = data['username'].toString();
        final String messageContent = data['message'].toString();
        final String createdAt = (data['createdAt'] is int)
            ? DateTime.fromMillisecondsSinceEpoch(data['createdAt']).toIso8601String()
            : data['createdAt'].toString();

        print('User ID: $userId');
        print('User Name: $userName');
        print('Message: $messageContent');
        print('Created At: $createdAt');

        // Create new message object
        final newMessage = Data(
          message: messageContent,
          time: DateFormat('hh:mm a').format(DateTime.now()),
          dateAndTime: createdAt,
          userDetails: UserDetails(
            sId: userId,
            name: userName,
            profilePhoto: otherpic ?? '',
          ),
        );

        // Avoid duplicates and add message
        if (!_allMessages.any((msg) => msg.sId == newMessage.sId && msg.message == newMessage.message)) {
          setState(() {
            _allMessages.add(newMessage);
          });
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              });
      } catch (e) {
        print('Error processing message: $e');
      }
    });


    // _messageSubscription = _socketService.messages.listen((message) {
    //   print('Received message: $message');
    //
    //   // Assuming the message is in JSON format, you need to parse it.
    //   try {
    //     // If the message is in JSON format, you can parse it into a Map
    //     final parsedMessage = jsonDecode(message);
    //
    //     // Extracting the data from the parsed message
    //     final String userId = parsedMessage['userId'];
    //     final String userName = parsedMessage['username'];
    //     final String messageContent = parsedMessage['message'];
    //     final String createdAt = parsedMessage['createdAt'];
    //     print('username is:-$userName');
    //     print('messageContent is:-$userName');
    //     // You can now use these extracted values
    //     final newMessage = Data(
    //       message: messageContent, // Use the message content
    //       time: DateFormat('hh:mm a').format(DateTime.now()),
    //       dateAndTime: DateTime.now().toIso8601String(),
    //       userDetails: UserDetails(
    //         sId: userId,  // Use the userId from the server
    //         name: userName, // Use the username from the server
    //         profilePhoto: otherpic ?? '', // You can assign profile photo if you have it
    //       ),
    //     );
    //
    //     // Add the message to your list of messages, making sure it's not a duplicate
    //     if (newMessage.userDetails!.sId != userId && !_allMessages.any((msg) => msg.sId == newMessage.sId && msg.message == newMessage.message)) {
    //       setState(() {
    //         _allMessages.add(newMessage);
    //         fetchData();  // Optionally, fetch additional data if necessary
    //       });
    //     }
    //
    //     // Scroll to the bottom of the messages if needed
    //     SchedulerBinding.instance.addPostFrameCallback((_) {
    //       if (_scrollController.hasClients) {
    //         _scrollController.animateTo(
    //           _scrollController.position.maxScrollExtent,
    //           duration: const Duration(milliseconds: 500),
    //           curve: Curves.easeOut,
    //         );
    //       }
    //     });
    //   } catch (e) {
    //     print('Error parsing message: $e');
    //   }
    // });


    _scrollController = ScrollController(
      initialScrollOffset: 1000000, // Temporarily set to 0, will adjust in post-frame
    );
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels == 0) {
        print('msg sended succesfully 3...............');
        fetchData(loadMore: true); // Load more messages when scrolled to the top
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
    String? token = await AppDB.appDB.getToken();
    final url = Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "$token",
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      _socketService.sendMessage(message); // Send message to Socket.IO server
    } else {
      print('Failed to post message: ${response.body}');
    }
  }
  Future<void> fetchData({bool loadMore = false}) async {
    if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;

    String? token = await AppDB.appDB.getToken();

    if (loadMore) {
      setState(() {
        _isLoadingOlderMessages = true;
      });
    } else {
      setState(() {
        _isLoadingInitialMessages = true;
      });
    }

    try {
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/chat/displayChat?page=$_currentPage&limit=$_messagesPerPage'),
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
            for (var newMessage in chatModel.data!) {
              if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) {
                _allMessages.insert(0, newMessage); // Insert messages at the beginning
              }

              // Check if the message is from the current user
              if (newMessage.userDetails?.sId == userId) {
                // Assign the current user's name and profile photo
                userName = newMessage.userDetails?.name;
                pic = newMessage.userDetails?.profilePhoto;
                print("Current User's Name: $userName");
              } else {
                // Assign the other user's name
                nouser = newMessage.userDetails?.name ?? "Unknown Sender";
                otherpic = newMessage.userDetails?.profilePhoto;
              }
            }
            _currentPage++; // Increment the page
          });

          // Scroll to bottom after initial data load
          if (!loadMore) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
          }
        } else {
          setState(() {
            _hasMoreMessages = false; // No more messages to load
          });
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught in fetchData: $e');
    } finally {
      if (loadMore) {
        setState(() {
          _isLoadingOlderMessages = false;
        });
      } else {
        setState(() {
          _isLoadingInitialMessages = false;
        });
      }
    }
  }

  // Future<void> fetchData({bool loadMore = false}) async {
  //   if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;
  //
  //   String? token = await AppDB.appDB.getToken();
  //
  //   if (loadMore) {
  //     setState(() {
  //       _isLoadingOlderMessages = true;
  //     });
  //   } else {
  //     setState(() {
  //       _isLoadingInitialMessages = true;
  //     });
  //   }
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://batting-api-1.onrender.com/api/chat/displayChat?page=$_currentPage&limit=$_messagesPerPage'),
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
  //       if (chatModel.data != null && chatModel.data!.isNotEmpty) {
  //         setState(() {
  //           for (var newMessage in chatModel.data!) {
  //             if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) {
  //               _allMessages.insert(0, newMessage); // Insert messages at the beginning
  //             }
  //             if (newMessage.userDetails?.sId == userId) {
  //               userName = newMessage.userDetails?.name; // Assign the user's name
  //               pic= newMessage.userDetails?.profilePhoto;
  //               print("Current User's Name: $userName");
  //             }
  //             else {
  //               // You can assign a default name or leave it blank for unknown users
  //               nouser = newMessage.userDetails?.name ?? "Unknown Sender";
  //               otherpic= newMessage.userDetails?.profilePhoto;
  //               Text('no user :-${nouser}');
  //         }
  //           }
  //           _currentPage++; // Increment the page
  //         });
  //
  //         // Scroll to bottom after initial data load
  //         if (!loadMore) {
  //           SchedulerBinding.instance.addPostFrameCallback((_) {
  //             if (_scrollController.hasClients) {
  //               _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //             }
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           _hasMoreMessages = false; // No more messages to load
  //         });
  //       }
  //     } else {
  //       print('Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception caught in fetchData: $e');
  //   } finally {
  //     if (loadMore) {
  //       setState(() {
  //         _isLoadingOlderMessages = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoadingInitialMessages = false;
  //       });
  //     }
  //   }
  // }
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

  void _handleSendMessage() {
    final message = usernameController.text;
    if (message.isNotEmpty) {
      final newMessage = Data(
        message: message,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        dateAndTime: DateTime.now().toIso8601String(), // Full date-time string
        userDetails: UserDetails(sId: userId, name: 'You'),
      );
      setState(() {
        _allMessages.add(newMessage);
      });
      postMessage(message).then((_) {
        usernameController.clear();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
            // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }).catchError((error) {
        print('Error posting message: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF0F1F5),
      appBar: PreferredSize(
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
      body:
      _isLoadingInitialMessages
          ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1D1459)),
        ),
      )
          : Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          if (_isLoadingOlderMessages)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // reverse: true, // This makes the list start from the bottom
              itemCount: _allMessages.length,
              itemBuilder: (context, index) {
                final message = _allMessages[index];
                final dateLabel = _getDateLabel(message.dateAndTime);
                final showDateLabel = lastDisplayedDate != dateLabel;
                lastDisplayedDate = showDateLabel ? dateLabel : lastDisplayedDate;
                final userDetails = message.userDetails;
                final profilePhotoUrl = userDetails?.profilePhoto;
                print('last display date:- $lastDisplayedDate');
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: message.userDetails?.sId == userId
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
                        mainAxisAlignment: message.userDetails?.sId == userId
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (message.userDetails?.sId != userId) ...[
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
                            crossAxisAlignment: message.userDetails?.sId == userId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (message.userDetails?.sId != userId) ...[
                                Text(
                                  message.userDetails?.name ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                              ]
                              else...[
                                Text(
                                  'You',
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
                                  borderRadius: message.userDetails?.sId == userId
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
                                  color: message.userDetails?.sId == userId
                                      ? const Color(0xff140B40)
                                      : const Color(0xff777777)
                                      .withOpacity(0.07),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message.message ?? '',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.034,
                                        color: message.userDetails?.sId == userId
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      message.time ?? '',
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
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Row(
              children: [
                Container(
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
                SizedBox(width: screenWidth * 0.05),
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


// if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) {
//   setState(() {
//     _allMessages.add(newMessage);
//   });
// }
// Add the message only if it's not from the current user
// Future<void> postMessage(String message) async {
//   String? token = await AppDB.appDB.getToken();
//   final url = Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
//   final response = await http.post(
//     url,
//     headers: {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "Authorization": "$token",
//     },
//     body: jsonEncode({
//       'message': message,
//       'userId': userId, // Add the current userId
//     }),
//   );
//   if (response.statusCode == 200) {
//     _socketService.sendMessage(message); // Send message to Socket.IO server
//   } else {
//     print('Failed to post message: ${response.body}');
//   }
// }
// _messageSubscription = _socketService.messages.listen((message) {
//   print('Received message: $message');
//
//   final newMessage = Data(
//     message: message, // Use plain string as the message
//     time: DateFormat('hh:mm a').format(DateTime.now()),
//     dateAndTime: DateTime.now().toIso8601String(),
//     userDetails: UserDetails(
//       sId: UserDetails.fromJson(json as Map<String, dynamic>).sId, // Default userId for now
//       name: UserDetails.fromJson(json as Map<String, dynamic>).name, // Default name
//       profilePhoto: UserDetails.fromJson(json as Map<String, dynamic>).profilePhoto, // Default or empty profile photo
//     ),
//   );
//
//   setState(() {
//     _allMessages.add(newMessage);
//   });
//
//   // Scroll to the latest message
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeOut,
//       );
//     }
//   });
// });


// Future<void> fetchData({bool loadMore = false}) async {
//   if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;
//   String? token = await AppDB.appDB.getToken();
//   if (loadMore) {
//     setState(() {
//       _isLoadingOlderMessages = true;
//     });
//   } else {
//     setState(() {
//       _isLoadingInitialMessages = true;
//     });
//   }
//   // await Future.delayed(Duration(seconds: 2));
//   try {
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/chat/displayChat?page=$_currentPage&limit=$_messagesPerPage'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       final chatModel = displaychetModel.fromJson(jsonResponse);
//       if (chatModel.data != null && chatModel.data!.isNotEmpty) {
//         setState(() {
//           for (var newMessage in chatModel.data!) {
//             if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) {
//               _allMessages.insert(0, newMessage); // Insert messages at the beginning
//             }
//           }
//           _currentPage++; // Increment the page for the next fetch
//           _isLoadingOlderMessages = false;
//           _isLoadingInitialMessages = false;
//         });
//         if (!loadMore) {
//
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             if (_scrollController.hasClients) {
//               _scrollController.animateTo(
//                 _scrollController.position.maxScrollExtent,
//                 duration: const Duration(milliseconds: 5),
//                 curve: Curves.easeOut,
//               );
//             }
//           });
//         }
//       } else {
//         setState(() {
//           _hasMoreMessages = false; // No more messages to load
//           _isLoadingOlderMessages = false;
//           _isLoadingInitialMessages = false;
//         });
//       }
//     } else if (response.statusCode == 404) {
//       setState(() {
//         _hasMoreMessages = false; // No more messages to load
//         _isLoadingOlderMessages = false;
//         _isLoadingInitialMessages = false;
//       });
//     } else {
//       print('Failed to load data: ${response.statusCode}');
//       setState(() {
//         _isLoadingOlderMessages = false;
//         _isLoadingInitialMessages = false;
//       });
//     }
//   } catch (e) {
//     print('Exception caught in fetchData: $e');
//     if(mounted){
//     setState(() {
//       _isLoadingOlderMessages = false;
//       _isLoadingInitialMessages = false;
//     });
//     }
//   }
// }


// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'package:batting_app/screens/socket_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../db/app_db.dart';
// import '../model/displaychetmodel.dart';
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();
//   final List<String> messages = [];
//   late SocketService _socketService;
//   //
//   bool _isLoadingOlderMessages = false;
//   bool _isLoadingInitialMessages = false;
//   final List<Data> _allMessages = [];
//   bool _hasMoreMessages = true; // Flag to indicate if there are more messages
//   int _currentPage = 1;
//   final int _messagesPerPage = 50;
//   final ScrollController _scrollController = ScrollController();
//   String? lastDisplayedDate;
//
//   String? userId;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchData();
//     fetchUserId();
//     _socketService= Provider.of<SocketService>(context, listen: false);
//     _socketService.messages.listen((newMessage) {
//       setState(() {
//         messages.add(newMessage);
//       });
//     });
//   }
//   @override
//   void dispose() {
//     messageController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchUserId() async {
//     String? fetchedUserId = await AppDB.appDB.getUserId();
//     setState(() {
//       userId = fetchedUserId;
//     });
//   }
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
//   Future<void> postMessage(String message) async {
//     print('msg printed55555555555555:-.....fdsfd....');
//     String? token = await AppDB.appDB.getToken();
//     final url =
//     Uri.parse('https://batting-api-1.onrender.com/api/chat/insertChat');
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//       body: jsonEncode({'message': message}),
//     );
//     print('msg printed666666666666666:-.....fdsfd....');
//     if (response.statusCode == 200) {
//       print('msg printed7777777777777777777777:-.....fdsfd....');
//       _socketService.sendMessage(message); // Send message to Socket.IO server
//     } else {
//       print('Failed to post message: ${response.body}');
//     }
//   }
//   Future<void> fetchData({bool loadMore = false}) async {
//     print('Data is fetching...........................');
//     if (loadMore && (_isLoadingOlderMessages || !_hasMoreMessages)) return;
//     String? token = await AppDB.appDB.getToken();
//     if (loadMore) {
//       setState(() {
//         _isLoadingOlderMessages = true;
//       }); // Trigger a rebuild to show the loading indicator
//     } else {
//       setState(() {
//         _isLoadingInitialMessages = true;
//       });
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
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final chatModel = displaychetModel.fromJson(jsonResponse);
//
//         if (chatModel.data != null && chatModel.data!.isNotEmpty) {
//           setState(() {
//             for (var newMessage in chatModel.data!) {
//               if (!_allMessages.any((msg) => msg.sId == newMessage.sId)) { // Assuming each message has a unique ID
//                 _allMessages.insert(0, newMessage); // Insert messages at the beginning
//
//               }
//             }
//             print('msg is .......................${chatModel.data!}');
//             print('Total messages after adding: ${_allMessages.length}'); // Log total messages
//             _currentPage++; // Increment the page for the next fetch
//             _isLoadingOlderMessages = false;
//             _isLoadingInitialMessages = false;
//           });
//           if (!loadMore) {
//             SchedulerBinding.instance.addPostFrameCallback((_)  {
//               if (_scrollController.hasClients) {
//                 _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//               }
//             });
//           }
//         } else {
//           setState(() {
//             _hasMoreMessages = false; // No more messages to load
//             _isLoadingOlderMessages = false;
//             _isLoadingInitialMessages = false;
// // Reset loading state
//           });
//         }
//       } else if (response.statusCode == 404) {
//         setState(() {
//           _hasMoreMessages = false; // No more messages to load
//           _isLoadingOlderMessages = false;
//           _isLoadingInitialMessages = false;
// // Reset loading state
//         });
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//         setState(() {
//           _isLoadingOlderMessages = false;
//           _isLoadingInitialMessages = false;
// // Reset loading state
//         });
//       }
//     } catch (e) {
//       print('Exception caught in fetchData: $e');
//       setState(() {
//         _isLoadingOlderMessages = false;
//         _isLoadingInitialMessages = false;
// // Reset loading state
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final socketService = Provider.of<SocketService>(context);
//     return Scaffold(
//       backgroundColor: const Color(0xffF0F1F5),
//       appBar: PreferredSize(
//         // preferredSize: Size.fromHeight(screenHeight * 0.07),
//         preferredSize: Size.fromHeight(67.0.h),
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
//                 height: 100.h,
//                 width: 140.w,
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
//                 colors: [Color(0xff140B40), Color(0xff140B40)],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: _isLoadingInitialMessages // Check if initial messages are still loading
//           ? const Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 5,
//           valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1D1459)),
//         ),
//       )
//           : Column(
//             children: [
//               SizedBox(height: screenHeight * 0.01),
//               if (_isLoadingOlderMessages)
//               // debugPrint(object);// Show loading indicator at the top
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: CircularProgressIndicator(
//                     strokeWidth: 1,
//                   ),
//                 ),
//               Expanded(
//                       child:
//                       ListView.builder(
//               // reverse: true,
//               controller: _scrollController,
//               itemCount: _allMessages.length + (_isLoadingOlderMessages ? 1 : 0),
//               // Show loading indicator if needed
//               itemBuilder: (context, index) {
//                 if (index == _allMessages.length && _isLoadingOlderMessages) {
//                   print('showing circular indicator......................');
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (index >= _allMessages.length) return const SizedBox.shrink();
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
//                   // if (dateLabel != lastDisplayedDate) {
//                   print("Comparing dates:");
//                   print("Current message date label: $dateLabel");
//                   // print("Last displayed date: $lastDisplayedDate");
//                   showDateLabel = true;
//                   lastDisplayedDate = dateLabel;
//                   print('lastDisplayedDate:- $lastDisplayedDate');
//                   if(lastDisplayedDate == null){
//                     showDateLabel = false;// Print only once for each unique date
//                   }
//                   // }
//                   // else if (lastDisplayedDate == null) {
//                   // If `lastDisplayedDate` is null, do not show the date label
//                   //  showDateLabel = false;
//                   //}
//                 }
//                 final userDetails = item.userDetails;
//                 // final profilePhoto = userDetails?.profilePhoto ?? Image.asset('assets/remove.png');
//                 final profilePhotoUrl = userDetails?.profilePhoto;
//
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                   child: Column(
//                     crossAxisAlignment: item.userDetails?.sId == userId
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: [
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
//                                     child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
//                                         ? Image.network(
//                                       profilePhotoUrl,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) {
//                                         return Image.asset(
//                                             'assets/dummy_player.png');
//                                       },
//                                     )
//                                         : Image.asset(
//                                       'assets/remove.png', // Default image if URL is null or empty
//                                       fit: BoxFit.cover,
//                                     ),
//                                     // child: Image.network(
//                                     //   // item.userDetails!.profilePhoto!,
//                                     //   profilePhoto.toString(),
//                                     //   fit: BoxFit.cover,
//                                     // ),
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
//                                     bottomRight: Radius.circular(10),
//                                     topLeft: Radius.circular(10),
//                                     bottomLeft: Radius.circular(10),
//                                   )
//                                       : const BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     topRight: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                   color: item.userDetails?.sId == userId
//                                       ? const Color(0xff140B40)
//                                       : const Color(0xff777777)
//                                       .withOpacity(0.07),
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
//                       ),
//                     ),
//             ],
//           ),
//       // body: SingleChildScrollView(
//       //   child: Column(
//       //     children: [
//       //
//       //     ],
//       //   ),
//       // ),
//       bottomSheet: BottomAppBar(
//         color: const Color(0xffF0F1F5),
//         child: Row(
//           children: [
//             Container(
//               height: screenHeight * 0.06,
//               width: screenWidth * 0.72,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.grey.shade400,
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Center(
//                 child: TextFormField(
//                   maxLines: 1,
//                   // controller: usernameController,
//                   controller: messageController,
//                   decoration: const InputDecoration(
//                     contentPadding:
//                     EdgeInsets.only(bottom: 5, left: 12, top: 0),
//                     hintText: "Write your message",
//                     hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: screenWidth * 0.03),
//             Container(
//               height: screenHeight * 0.06,
//               width: screenWidth * 0.15,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: const Color(0xff140B40),
//               ),
//               child: IconButton(
//                 icon: Image.asset('assets/shares.png',
//                     height: screenHeight * 0.02),
//                 onPressed: () {
//                   // if (usernameController.text.isNotEmpty) {
//                   //
//                   //   print('print msg:---.....');
//                   //   // _handleSendMessage();
//                   //   print('msg printed:-.........');
//                   //   usernameController.clear();
//                   // }
//                   if (messageController.text.isNotEmpty) {
//
//                     print('print msg:---.....');
//                     if (messageController.text.isNotEmpty) {
//                       final newMessage = Data(
//                         message: messageController.text,
//                         time: DateFormat('hh:mm a').format(DateTime.now()),
//                         dateAndTime: DateTime.now().toIso8601String(), // Full date-time string
//                         userDetails: UserDetails(sId: userId, name: 'You'), // Adjust this as needed
//                       );
//
//                       // Add the new message to the list and update the UI
//                       setState(() {
//                         print('msg printed333333333333:-.....fdsfd....');
//
//                         _allMessages.add(newMessage);
//                       });
//                       print('msg printed4444444444444444444:-.....fdsfd....');
//                       postMessage(messageController.text).then((_) {
//                         messageController.clear();
//                         SchedulerBinding.instance.addPostFrameCallback((_) {
//                           if (_scrollController.hasClients) {
//                             _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//                           }
//                         });
//                         // fetchData(); // Refresh chat data after posting a message
//                       }).catchError((error) {
//                         print('Error posting message: $error');
//                       });
//                     }                    print('msg printed:-.........');
//                     messageController.clear();
//                   }
//                   // if (messageController.text.isNotEmpty) {
//                   //   // Send the message using the SocketService
//                   //   socketService.sendMessage(messageController.text);
//                   //   setState(() {
//                   //     messages.add("You: ${messageController.text}");
//                   //   });
//                   //   messageController.clear();
//                   // }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
