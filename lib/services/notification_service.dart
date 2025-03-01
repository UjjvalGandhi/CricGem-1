import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:batting_app/main.dart';
import 'package:batting_app/screens/walletScreen.dart';
import 'package:batting_app/widget/balance_notifire.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // For request notification permission
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      carPlay: true,
      announcement: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User provisional granted permission');
    } else {
      Get.snackbar(
        "Notification permission denied",
        "Allow permissiom to receive notification",
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 3), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  // Device token


  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      carPlay: true,
      announcement: true,
    );

    String? token = await messaging.getToken();
    print("FCM token : $token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token!);

    print("FCM token hiii ${prefs.getString('fcm_token')}");
    String? token1 = prefs.getString('fcm_token');

    return token;
  }

  //init local notification
  void initLocalNotification(BuildContext build, RemoteMessage message) async {
    var androidInitSetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var iosInitSetting = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    var initializationSettings = InitializationSettings(
        android: androidInitSetting,
        iOS: iosInitSetting
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
     onDidReceiveNotificationResponse: (payload){
       HandleMessage(message);
     }
    );
  }

  // firebase init
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen(
            (message){
              RemoteNotification? notification = message.notification;
              AndroidNotification? android = message.notification?.android;

              if(kDebugMode)
                {
                  print("Notification title: ${notification?.title}");
                  print("Notification body: ${notification?.body}");
                }
              if(Platform.isIOS)
                {
                  iosForgroundMessage();
                }
              if(Platform.isAndroid)
                {
                  initLocalNotification(context, message);
                 // HandleMessage( context, message);
                  showNotification(message);
                }
            });
  }

  // function for show notification


  Future<void> showNotification(RemoteMessage message) async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    // Android Notification settings

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "channel description",
      importance: Importance.high,
      priority: Priority.high,
      sound: channel.sound,
      playSound: true,
    );

    // IOS Notification settings
    DarwinNotificationDetails  darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // show notification
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload:"my_data"
      );
    });

  }

  // background and terminated

  Future<void> setupInteractMessage(BuildContext context) async{
    FirebaseMessaging.onMessageOpenedApp.listen((event)
    {
      HandleMessage( event);
    });

    // terminated state

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message != null && message.data.isNotEmpty)
        {
          HandleMessage( message);
        }
    });
  }

  //handle message

  // Future<void> HandleMessage(BuildContext context,RemoteMessage message) async{
  //   final BalanceNotifier balanceNotifier;
  //
  //   // Access BalanceNotifier from the Provider
  //   balanceNotifier = Provider.of<BalanceNotifier>(context);
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(balanceNotifier:balanceNotifier)));
  // }

  Future<void> HandleMessage(RemoteMessage message) async {
    final BuildContext? context = navigatorKey.currentContext;

    if (context != null) {
      final BalanceNotifier balanceNotifier = context.read<BalanceNotifier>();

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => WalletScreen(balanceNotifier: balanceNotifier),
        ),
      );
    } else {
      print("Error: Navigator context is null, cannot navigate.");
    }
  }



  // ios forground message
  void iosForgroundMessage() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


}
