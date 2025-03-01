import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:batting_app/widget/notification_service.dart';

class SocketService with ChangeNotifier {
  IO.Socket? _socket;
    final _controller = StreamController<Map<String, dynamic>>.broadcast();


  SocketService();

  void _initializeSocket(BuildContext context) {
    _socket = IO.io('https://batting-api-1.onrender.com', IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000)
        .build());
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    _socket?.onConnect((_) {
      print('Connected to Socket.IO server');
      listenForNotifications(context); // Attach event listeners after connection
      print('Work in progress');
      Provider.of<SocketService>(context, listen: false).initializeWithContext(context);
    });

    _socket?.on('globalChat', (data) {
      print('New message received: ${data['message']},${data['userId']}');
      print('data...$data');
      // _controller.add(data['message']);
      _controller.add(data); // Add the full message object to the stream

    });
    // Listening for incoming notifications
    print('start notification:');
    _socket?.on("newNotification", (data) {
      print("🛑 Raw Notification Data Received: $data"); // Debugging
      print("New Notification Received: ${data['title']} - ${data['body']}");
      notificationService.showNotification(title: data['title'], body: data['body']);
    });

    // Handling connection errors
    _socket?.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  void listenForNotifications(BuildContext context) {
    print('work under proress');
    _socket?.on('newNotification', (data) {
      print('📩 New notification received from server: $data');

      final notificationService = Provider.of<NotificationService>(context, listen: false);

      if (data != null && data['title'] != null && data['message'] != null) {
        notificationService.showNotification(
          title: data['title'],
          body: data['message'],
          payload: 'notificationPage',
        );
        print('📲 Notification triggered successfully.');
      } else {
        print('⚠️ Received invalid notification data: $data');
      }
    });
    print('workin progress');
  }

  // Initialize socket with context
  void initializeWithContext(BuildContext context) {
    _initializeSocket(context);
    print('open socket.');
  }

  void sendMessage(String message) {
    _socket?.emit('chat_message', {'message': message});
    print('message send $message');
  }
  Stream<Map<String, dynamic>> get messages => _controller.stream;

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }
}

// import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter/material.dart';
//
// import '../widget/notification_service.dart';
//
// class SocketService with ChangeNotifier {
//   IO.Socket? _socket;
//   // final _controller = StreamController<String>.broadcast();
//   final _controller = StreamController<Map<String, dynamic>>.broadcast();
//   // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   // FlutterLocalNotificationsPlugin();
//
//   SocketService() {
//     // _initializeNotifications();  // Initialize notifications
//     _initializeSocket();
//   }
//   // void _initializeNotifications() async {
//   //   const AndroidInitializationSettings initializationSettingsAndroid =
//   //   AndroidInitializationSettings('@mipmap/ic_launcher');
//   //
//   //   final InitializationSettings initializationSettings =
//   //   InitializationSettings(android: initializationSettingsAndroid);
//   //
//   //   await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   // }
//   //
//   // void _showNotification(String title, String body) async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //   AndroidNotificationDetails(
//   //     'channel_id', // Unique channel ID
//   //     'Channel Name', // Channel name
//   //     importance: Importance.high,
//   //     priority: Priority.high,
//   //   );
//   //
//   //   const NotificationDetails platformChannelSpecifics =
//   //   NotificationDetails(android: androidPlatformChannelSpecifics);
//   //
//   //   await _flutterLocalNotificationsPlugin.show(
//   //     0, // Notification ID
//   //     title,
//   //     body,
//   //     platformChannelSpecifics,
//   //   );
//   // }
//   void _initializeSocket() {
//     _socket = IO.io('https://batting-api-1.onrender.com', IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .build());
//
//     _socket?.onConnect((_) {
//       print('Connected to Socket.IO server');
//     });
//
//     // globalChat
//     // Listening for incoming chat messages
//     _socket?.on('globalChat', (data) {
//       print('New message received: ${data['message']},${data['userId']}');
//       print('data...$data');
//       // _controller.add(data['message']);
//       _controller.add(data); // Add the full message object to the stream
//
//     });
//       // Trigger the notification using NotificationService
//     _socket?.on('newNotification', (data) {
//       print('New notification received: $data');
//
//       // Access NotificationService using Provider to show the notification
//       final notificationService = Provider.of<NotificationService>(context, listen: false);
//       notificationService.showNotification(
//         title: data['title'],
//         body: data['message'],
//         payload: 'notificationPage', // Optional: You can send a payload for navigation
//       );
//     });
//
//     // _socket?.on('newNotification', (data) {
//     //   print('New notification received: $data');
//     //
//     //   // Show push notification
//     //   _showNotification(data['title'], data['message']);
//     //
//     //   _controller.add(data);
//     // });
//
//
//     // Handling connection errors
//     _socket?.onDisconnect((_) {
//       print('Disconnected from Socket.IO server');
//     });
//   }
//
//
//
//   void sendMessage(String message) {
//     _socket?.emit('chat_message', {'message': message});
//   }
//
//   // Stream<String> get messages => _controller.stream;
//   Stream<Map<String, dynamic>> get messages => _controller.stream;
//
//   @override
//   void dispose() {
//     _controller.close();
//     _socket?.dispose();
//     super.dispose();
//   }
// }

// import 'dart:async';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter/material.dart';
//
// class SocketService with ChangeNotifier {
//   IO.Socket? _socket;
//   // final _controller = StreamController<String>.broadcast();
//   final _controller = StreamController<Map<String, dynamic>>.broadcast();
//
//
//   SocketService() {
//     _initializeSocket();
//   }
//
//   void _initializeSocket() {
//     _socket = IO.io('https://batting-api-1.onrender.com', IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .build());
//
//     _socket?.onConnect((_) {
//       print('Connected to Socket.IO server');
//     });
//
//     // globalChat
//     // Listening for incoming chat messages
//     _socket?.on('globalChat', (data) {
//       print('New message received: ${data['message']},${data['userId']}');
//       print('data...$data');
//       // _controller.add(data['message']);
//       _controller.add(data); // Add the full message object to the stream
//
//     });
//
//
//     // Handling connection errors
//     _socket?.onDisconnect((_) {
//       print('Disconnected from Socket.IO server');
//     });
//   }
//
//
//
//   void sendMessage(String message) {
//     _socket?.emit('chat_message', {'message': message});
//   }
//
//   // Stream<String> get messages => _controller.stream;
//   Stream<Map<String, dynamic>> get messages => _controller.stream;
//
//   @override
//   void dispose() {
//     _controller.close();
//     _socket?.dispose();
//     super.dispose();
//   }
// }
