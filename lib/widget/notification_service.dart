import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  Future<void> initNotification(BuildContext context) async {
    try {
      const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

      final bool? initialized = await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle navigation based on payload
          final payload = response.payload;

          if (payload != null && payload.isNotEmpty) {
            Navigator.of(context).pushNamed(payload); // Navigate using payload
          } else {
            Navigator.of(context).pushNamed('/defaultPage'); // Default route
          }
        },
      );
      debugPrint('Notification Plugin Initialized: $initialized');
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  // Show notification method
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'This channel is used for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    print('open socket notification.');
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload, // Add payload for navigation
    );
    notifyListeners(); // Notify listeners if you want to update UI
    print("Notification should be displayed now.");

  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//   // Future<void> initNotification() async {
//   //   const AndroidInitializationSettings androidInitializationSettings =
//   //   AndroidInitializationSettings('@mipmap/ic_launcher');
//   //
//   //   const InitializationSettings initializationSettings =
//   //   InitializationSettings(
//   //     android: androidInitializationSettings,
//   //   );
//   //
//   //   await _flutterLocalNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //   );
//   // }
//   Future<void> initNotification(BuildContext context) async {
//     try {
//       const AndroidInitializationSettings androidInitializationSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//
//       const InitializationSettings initializationSettings =
//       InitializationSettings(android: androidInitializationSettings);
//
//       final bool? initialized = await _flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//           // Handle navigation based on payload
//           final payload = response.payload;
//
//           if (payload != null && payload.isNotEmpty) {
//             Navigator.of(context).pushNamed(payload); // Navigate using payload
//           } else {
//             Navigator.of(context).pushNamed('/defaultPage'); // Default route
//           }
//         },
//       );
//       debugPrint('Notification Plugin Initialized: $initialized');
//     } catch (e) {
//       debugPrint('Error initializing notifications: $e');
//     }
//   }
//
//
//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'This channel is used for notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: payload, // Add payload for navigation
//     );
//   }
// }
