// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Api/provider/accept_display_provider.dart';
// import 'Model/display_chat.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import 'Personal_Profile.dart';
// import 'firebase/LocalNotification.dart';
// import 'manmbership_plan_screen.dart';
//
// class UserChatingScreen extends StatefulWidget {
//   final String userId;
//   final String userName;
//   final String photo;
//
//   UserChatingScreen(
//       {super.key,
//         required this.userId,
//         required this.userName,
//         required this.photo});
//
//   @override
//   State<UserChatingScreen> createState() => _UserChatingScreenState();
// }
//
// class _UserChatingScreenState extends State<UserChatingScreen> {
//   static const String _url =
//       "https://saptavidhi-api-1.onrender.com/api/message/messages/";
//   static const String _postUrl =
//       "https://saptavidhi-api-1.onrender.com/api/message/send/";
//
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late Future<List<DisplayChat>> _messagesFuture;
//   late IO.Socket _socket;
//   List<DisplayChat> _messages = [];
//   String lMSg = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _messagesFuture = fetchMessages();
//     _initializeSocket();
//   }
//
//   Future<List<DisplayChat>> fetchMessages() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final response =
//       await http.get(Uri.parse("$_url${widget.userId}"), headers: {
//         "Authorization": prefs.getString("user")!,
//       });
//
//       if (response.statusCode == 200) {
//         final List<DisplayChat> messages = displayChatFromJson(response.body);
//         setState(() {
//           _messages = messages;
//           _scrollToBottom();
//         });
//         return messages;
//       } else {
//         print('Failed to load messages: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         throw Exception('Failed to load messages');
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Failed to load messages');
//     }
//   }
//
//   Future<void> _initializeSocket() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _socket = IO.io('https://your-backend-url', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'extraHeaders': {'Authorization': prefs.getString("user")!},
//     });
//
//     // Connect to socket
//     _socket.connect();
//
//     // Listen for successful connection
//     _socket.onConnect(() {
//       print('Connected to the chat socket');
//     });
//
//     // Listen for incoming messages from the other user
//     _socket.on('new_message', (data) {
//       final newMessage = DisplayChat.fromJson(data);
//       setState(() {
//         _messages.add(newMessage);  // Add the message to the message list
//         _scrollToBottom();          // Scroll the chat to the bottom
//       });
//     });
//
//     // Handle socket disconnection
//     _socket.onDisconnect(() {
//       print('Disconnected from the chat socket');
//     });
//   }
//
//   Future<void> sendMessage(String message) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final response = await http.post(
//         Uri.parse("$_postUrl${widget.userId}"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": prefs.getString("user")!,
//         },
//         body: json.encode({"message": message}),
//       );
//
//       if (response.statusCode == 200) {
//         final messageData = json.decode(response.body);
//         final newMessage = DisplayChat.fromJson(messageData);
//
//         setState(() {
//           _messages.add(newMessage);  // Add the new message to the list
//           _scrollToBottom();          // Scroll to bottom after sending
//         });
//
//         // Emit the message via Socket.IO after saving it via the API
//         _socket.emit('send_message', {
//           'userId': widget.userId,
//           'message': message,
//         });
//
//         _messageController.clear(); // Clear the input field
//       } else {
//         print('Failed to send message: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _socket.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/chatBack.png"), fit: BoxFit.cover)),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 35,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       size: 30,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: CachedNetworkImageProvider(widget.photo),
//                         fit: BoxFit.cover, // Adjust as per your requirement
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PersonalProfile(
//                                 id: widget.userId, name: widget.userName),
//                           ));
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           widget.userName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 18),
//                         ),
//                         Text(
//                           "Active Now",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 14),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder<List<DisplayChat>>(
//                 future: _messagesFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     final chats = snapshot.data!;
//                     if (chats.isEmpty) {
//                       return Center(child: Text('No messages found'));
//                     }
//                     return ListView.builder(
//                       controller: _scrollController,
//                       itemCount: _messages.length,
//                       reverse: false, // List view order remains the same
//                       itemBuilder: (context, index) {
//                         final chat = _messages[index];
//                         final isSentByMe = chat.senderId == widget.userId;
//                         return Align(
//                           alignment: isSentByMe
//                               ? Alignment.centerLeft
//                               : Alignment.centerRight,
//                           child: LayoutBuilder(
//                             builder: (context, constraints) {
//                               return ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   minWidth: constraints.maxWidth * 0.3,
//                                   maxWidth: constraints.maxWidth * 0.8,
//                                 ),
//                                 child: IntrinsicWidth(
//                                   child: Container(
//                                     padding: EdgeInsets.only(
//                                         left: 10, top: 3, right: 10),
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 2, horizontal: 8),
//                                     decoration: BoxDecoration(
//                                       color: isSentByMe
//                                           ? Theme.of(context)
//                                           .colorScheme
//                                           .secondary
//                                           : Colors.grey,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           chat.message,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 15,
//                                             color: isSentByMe
//                                                 ? Colors.white
//                                                 : Colors.white,
//                                           ),
//                                         ),
//                                         const Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Text(
//                                             "2:30 ",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     );
//                   } else {
//                     return Center(child: Text('No messages found'));
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.80,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         controller: _messageController,
//                         style: const TextStyle(fontSize: 12),
//                         keyboardType: TextInputType.multiline,
//                         // textInputAction: TextInputType.multiline,
//                         decoration: InputDecoration(
//                             contentPadding: const EdgeInsets.all(5),
//                             fillColor: Colors.transparent,
//                             filled: true,
//                             hintText: "Message",
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromRGBO(220, 80, 156, 1)),
//                                 borderRadius: BorderRadius.circular(15)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromRGBO(220, 80, 156, 1)),
//                                 borderRadius: BorderRadius.circular(15))),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                       String? sp = prefs.getString("user");
//                       print("==================>$sp");
//                       if(sp != null){
//                         //  LocalNotificationService().sendNotification(" SaptaVidhi", "Welcome to the SaptaVidhi");
//                       }
//                       SharedPreferences pref =
//                       await SharedPreferences.getInstance();
//
//                       // Access the provider
//                       final provider = Provider.of<AcceptDisplayProvider>(
//                           context,
//                           listen: false);
//
//                       // Fetch data from API if necessary
//                       if (provider.isLoading) {
//                         await provider.getDataFromApi();
//
//
//                       }
//
//                       print(pref.getString("memberType").toString() + " ashok check 111 ");
//
//                       // Check conditions before sending message
//                       if (provider.isAccepted ||
//                           (pref.getString("memberType").toString() == "paid" ||
//                               lMSg.isNotEmpty)) {
//                         return sendMessage(_messageController.text);
//                       } else if (provider.isAccepted == true) {
//                         print("ok ok ok");
//
//                         return sendMessage(_messageController.text);
//                       } else {
//                         // return showPopUp(0.8);
//                       }
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: const Color(0xfffdebff).withOpacity(0.6)),
//                       child: Center(
//                         child: Icon(
//                           CupertinoIcons.paperplane_fill,
//                           size: 25,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
