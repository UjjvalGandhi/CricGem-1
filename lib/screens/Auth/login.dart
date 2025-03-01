import 'dart:convert';
import 'dart:io';

import 'package:batting_app/db/app_db.dart';
import 'package:batting_app/screens/Auth/signup.dart';
import 'package:batting_app/services/send_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/normaltext.dart';
import '../../widget/smalltext.dart';
import '../bnb.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool tap = true;
  bool _isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> login(String email, String password) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please check your internet connection.'),
    //     ),
    //   );
    //   return;
    // }

    setState(() {
      _isLoading = true;
    });

    try {
      var payload = jsonEncode({
        'email': email,
        'password': password,
      });
      final response = await http.post(
        Uri.parse("https://batting-api-1.onrender.com/api/user/user_login"),
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        // Check if the response contains a token and userId
        if (data['data'] != null &&
            data['data']['token'] != null &&
            data['userId'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful'),
            ),
          );
          await AppDB.appDB.saveToken(data['data']['token']);
          await AppDB.appDB.saveUserId(data['userId']);
          // Show success notification
          // NotificationService().showNotification(
          //   title: 'Login Successful',
          //   body: 'Welcome back!',
          // );
          // final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
          // await notificationProvider.fetchNotifications();
          //
          // // Check if notifications are available
          // if (notificationProvider.notifications.isNotEmpty) {
          //   final notification = notificationProvider.notifications.last;
          //
          //   // Show notification using NotificationService
          //   NotificationService().showNotification(
          //     title: notification['title'] ?? 'No Title',
          //     body: notification['message'] ?? 'No Message',
          //   );
          // } else {
          //   // Show fallback notification if no notifications are available
          //   NotificationService().showNotification(
          //     title: 'Login Successful',
          //     body: 'Welcome back!',
          //     payload: '/homescreens',
          //   );
          // }

          final prefs = await SharedPreferences.getInstance();
          try {
            // Construct notification body with both amounts
            String notificationBody =
                "Welcome back! ";


            await SendNotificationService.sendNotifcationUsingApi(
              title: "Welcome Back!",
              body: "🎉🎉🎉🎉🎉🎉",
              token: "${prefs.getString('fcm_token')}",
              data: {"screen": "walletScreen"},
            );

            print("✅ Login notification sent successfully");
          } catch (e) {
            print("❌Login Error sending notification: $e");
          }

          print('login data is:- ${data.toString()}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Bottom(),
            ),
          );
        } else {
          // Handle unexpected successful response format
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unexpected error occurred'),
            ),
          );
        }
      } else {
        var errorData = jsonDecode(response.body);
        // Check if the error response contains a specific message
        String errorMessage = errorData['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(errorMessage)),

            // content: Center(child: Text("errorMessage")),
          ),
        );
        print("error:::${response.body}");
      }
    } on SocketException catch (_) {
      // Handles network-related exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your internet connection"),
        ),
      );
    } catch (e) {
      print("error message ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive sizing
    ScreenUtil.init(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          color: const Color(0xffF0F1F5),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 55.h),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 26.sp,
                    letterSpacing: 0.8,
                    color: const Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SmallText(
                  color: Colors.black45,
                  text: "Login now to begin an amazing journey.",
                  size: 16.sp,
                ),
                SizedBox(height: 20.h),
                NormalText(
                    color: Colors.black, text: "Email Address", size: 16.sp),
                SizedBox(height: 5.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9@a-zA-Z.]")),
                  ],
                  autocorrect: false,
                  onChanged: (value) {},
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h, // Set the max height
                    ),
                    contentPadding: EdgeInsets.only(left: 10.w),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                NormalText(color: Colors.black, text: "Password", size: 16.sp),
                SizedBox(height: 5.h),
                TextFormField(
                  obscureText: tap,
                  obscuringCharacter: "*",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return "Please Enter password";
                    } else if (pass.length < 6) {
                      return "Password minimum 6 digits";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  controller: password,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: EdgeInsets.only(left: 15.w),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          tap = !tap;
                        });
                      },
                      icon: Icon(
                        tap
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                        size: 20.sp,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: const Color(0xff140B40),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                          Container(
                            height: 1.h,
                            width: 129.w,
                            color: const Color(0xff140B40),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            login(email.text.toString(),
                                password.text.toString());
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.r),
                            color: const Color(0xff140B40),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            " Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xff140B40),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 50,
                            color: const Color(0xff140B40),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 2.5,
                      color: Colors.grey.shade300,
                    ),
                    const Text(
                      " OR ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 2.5,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48.h,
                      width: 159.w,
                      child:
                          Image.asset("assets/google.png", fit: BoxFit.cover),
                    ),
                    SizedBox(
                      height: 48.h,
                      width: 159.w,
                      child:
                          Image.asset("assets/facebook.png", fit: BoxFit.cover),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
