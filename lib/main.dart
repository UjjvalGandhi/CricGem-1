import 'package:batting_app/firebase_options.dart';
import 'package:batting_app/screens/socket_service.dart';
import 'package:batting_app/services/fcm_service.dart';
import 'package:batting_app/services/notification_service.dart';
import 'package:batting_app/widget/balance_notifire.dart';
import 'package:batting_app/widget/contestprovider.dart';
import 'package:batting_app/widget/getdocuments.dart';
import 'package:batting_app/widget/joincontestprovider.dart';
import 'package:batting_app/widget/leaugeprovider.dart';
import 'package:batting_app/widget/myteamprovider.dart';
import 'package:batting_app/widget/notification_service.dart';
import 'package:batting_app/widget/notificationprovider.dart';
import 'package:batting_app/widget/profile_provider.dart';
import 'package:batting_app/widget/recently_played_provider.dart';
import 'package:batting_app/widget/walletprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:batting_app/screens/bnb.dart';
import 'package:batting_app/screens/bording/on_bordind_one.dart';

import 'db/app_db.dart'; // Import your SocketService


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final BalanceNotifier balanceNotifier = BalanceNotifier("0");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  //
  // final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>();
  //
  // await androidImplementation?.requestNotificationsPermission();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidImplementation != null) {
    bool? granted = await androidImplementation.requestNotificationsPermission();
    print('Notification permission granted: $granted');
  }



  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final String? token = await AppDB.appDB.getToken();
  // await NotificationService().initNotification();

  runApp(
    // ChangeNotifierProvider(
    //   create: (_) => SocketService(),
    //   create: (_) => BalanceNotifier("0")), // BalanceNotifier provider
// Use ChangeNotifierProvider for SocketService
//       child: MyApp(token: token),
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()), // SocketService provider
        ChangeNotifierProvider(create: (_) => NotificationService()),  // Add NotificationService here
        ChangeNotifierProvider(create: (_) => BalanceNotifier("0")), // BalanceNotifier provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyPlayedMatchProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => LeagueProvider()),
        ChangeNotifierProvider(create: (_) => ContestProvider()),
        ChangeNotifierProvider(create: (_) => JoinContestProvider()),
        ChangeNotifierProvider(create: (_) => MyTeamProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

      ],
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? token;


  const MyApp({super.key, this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? deviceToken;
  NotificationServices notificationService = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    notificationService.requestNotificationPermission();
    //notificationService.getDeviceToken();
    notificationService.getDeviceToken().then((token) {
      setState(() {
        deviceToken = token; // Store the token
      });
      print('Device Token: $deviceToken'); // Debug print
    });
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    FcmService.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Initializing NotificationService...');
      Provider.of<NotificationService>(context, listen: false).initNotification(context);

      print('Initializing SocketService...');
      Provider.of<SocketService>(context, listen: false).initializeWithContext(context);
    });

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, context) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          //builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: widget.token != null ? const Bottom() : const OnboardingScreen(),
        );
      },
    );
  }
}
