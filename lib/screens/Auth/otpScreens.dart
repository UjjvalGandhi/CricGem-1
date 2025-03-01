import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:batting_app/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:batting_app/screens/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widget/appbar_for_setting.dart';
import '../../widget/notification_service.dart';
import '../../widget/notificationprovider.dart';
import '../../widget/smalltext.dart';
import '../country/chnage_pass.dart';
import 'apicallforotp.dart';
import 'newpasswordscreen.dart';

class OtpScreens extends StatefulWidget {
  final List<dynamic>? register;
  final bool isForgotPassword; // Add a flag to indicate forgot password flow
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? pincode;
  final String? mobile;
  final bool isChangePassword;
  int otp; // Add OTP parameter

  OtpScreens(
      {super.key,
      this.address,
      this.country,
      this.state,
      this.city,
      this.pincode,
      required this.otp,
      this.mobile,
      this.isForgotPassword = false,
      this.register,
      this.isChangePassword = false});

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  bool _isRegistering = false; // Track registration state
  late Timer _timer; // Timer variable
  int _start = 59; // Countdown start value
  bool _canResendOtp = true;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _startTimer();
  }

  void _startTimer() {
    _canResendOtp = false; // Disable resend OTP initially
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResendOtp = true; // Enable resend OTP
        });
        timer.cancel(); // Stop the timer
      } else {
        setState(() {
          _start--; // Decrement the timer
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Image.asset(
                  'assets/verify.png',
                  height: 110,
                  color: const Color(0xff140B40),
                ),
                const SizedBox(height: 15),
                const Expanded(
                  child: Text(
                    "OTP Verified Successfully",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 0.4,
                      color: Color(0xff140B40),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SmallText(
                  color: Colors.black,
                  text: "Your Security Confirmed,",
                ),
                SmallText(
                  color: Colors.black,
                  text: "Access Granted",
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    NotificationServices notificationService =
                        NotificationServices();

                    String userdevicetoken =
                        await notificationService.getDeviceToken();
                    print("Device Token : $userdevicetoken");

                    String otpInput = '';
                    for (var controller in _otpControllers) {
                      otpInput += controller.text;
                    }
                    if (otpInput == widget.otp.toString()) {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
                      // );
                      final notificationProvider =
                          Provider.of<NotificationProvider>(context,
                              listen: false);
                      await notificationProvider.fetchNotifications();

                      // Check if notifications are available
                      if (notificationProvider.notifications.isNotEmpty) {
                        final notification =
                            notificationProvider.notifications.last;

                        // Show notification using NotificationService
                        NotificationService().showNotification(
                          title: notification['title'] ?? 'No Title',
                          body: notification['message'] ?? 'No Message',
                        );
                      } else {
                        // Show fallback notification if no notifications are available
                        NotificationService().showNotification(
                          title: 'Registration Successful',
                          body: 'Welcome back!',
                        );
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) =>
                            false, // Remove all previous routes
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text('Invalid OTP'),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 272,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: const Color(0xff140B40),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verifyOtp() {
    print("is changing password:- ${widget.isChangePassword}");
    print("is changing forgetpassword:- ${widget.isForgotPassword}");

    String otpInput = '';
    for (var controller in _otpControllers) {
      otpInput += controller.text;
    }

    if (otpInput == widget.otp.toString()) {
      // Call register method after OTP verification
      if (widget.isForgotPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(
              mobile: widget.mobile!,
            ),
          ),
        );
      } else if (widget.isChangePassword) {
        // Check if isChangePassword is true
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChangePass()));
      } else {
        register(
          widget.address!,
          widget.country!,
          widget.state!,
          widget.city!,
          widget.pincode!,
        );
      }
    } else {
      if (otpInput.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Enter OTP'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP'),
          ),
        );
      }
    }
  }

  Future<void> register(
    String address,
    String country,
    String state,
    String city,
    String pincode,
  ) async {
    setState(() {
      _isRegistering = true;
    });

    try {
      var payload = jsonEncode({
        'address': address,
        'city': city,
        'pincode': int.parse(pincode),
        'state': state,
        'country': country,
        // Replace the below with actual user registration details
        'name': widget.register![0]["fullName"],
        'email': widget.register![0]['email'],
        'mobile': widget.register![0]['mobile'],
        'gender': widget.register![0]['gender'],
        'dob': widget.register![0]['dateOfBirth'],
        'password': widget.register![0]['password'],
        'confirm_password': widget.register![0]['confirm_password'],
      });

      final response = await http.post(
        Uri.parse('https://batting-api-1.onrender.com/api/user/add_user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'batting-app',
        },
        body: payload,
      );
      print("registration is happening:- $response");
      var data1 = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")),
        );
        print("registration is happening11111111111:- ${response.body}");

        // Show success dialog
        _dialogBuilder(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          // const SnackBar(content: Text('Registration failed')),
          SnackBar(content: Text("${data1['message']}")),
        );
        print("registration is happening11111111111:- ${response.body}");
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your internet connection"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    resizeToAvoidBottomInset:
    true; // This is the default, but you can explicitly set it
    print("OTP ssssssssssssss.........: ${widget.otp}"); // Print the OTP here
    return Scaffold(
        // appBar: AppBar(
        //   surfaceTintColor: Colors.white,
        //   backgroundColor: const Color(0xffF0F1F5),
        //   leading: InkWell(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: const Icon(Icons.arrow_back),
        //   ),
        // ),
        //   appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(67.h),
        //     child: ClipRRect(
        //       child: AppBar(
        //         surfaceTintColor: const Color(0xffF0F1F5),
        //         backgroundColor: const Color(0xffF0F1F5),
        //         elevation: 0,
        //         centerTitle: true,
        //         automaticallyImplyLeading: false,
        //         flexibleSpace: Container(
        //           padding: EdgeInsets.symmetric(horizontal: 20.w),
        //           decoration: const BoxDecoration(
        //             gradient: LinearGradient(
        //               begin: Alignment.topCenter,
        //               end: Alignment.bottomCenter,
        //               colors: [Color(0xff1D1459), Color(0xff140B40)],
        //             ),
        //           ),
        //           child: Padding(
        //             padding: EdgeInsets.only(top: 30.h),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 InkWell(
        //                   onTap: () {
        //                     Navigator.pop(context);
        //                   },
        //                   child: const Icon(
        //                     Icons.arrow_back,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //                 AppBarText(color: Colors.white, text: "One Time Password"),
        //                 Container(
        //                   width: 30,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        appBar: CustomAppBar(
          title: "One Time Password",
          onBackButtonPressed: () {
            // Custom behavior for back button (if needed)
            Navigator.pop(context);
          },
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 10.r),
          color: const Color(0xffF0F1F5),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "One Time Password",
              //   style: TextStyle(
              //     fontSize: 26.sp,
              //     letterSpacing: 0.8,
              //     color: const Color(0xff140B40),
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              SmallText(
                color: Colors.black45,
                text:
                    "Enter OTP recieved on this number +91 ${widget.mobile!.isNotEmpty ? '${widget.mobile!.substring(0, 3)}*****${widget.mobile!.substring(widget.mobile!.length - 2)}' : ''}. ",

                // text: "Put the OPT number below sent to your number +91 ${widget.mobile}. ",
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[0],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[1],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[2],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[3],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[4],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 13.r),
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: .8.w, color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _otpControllers[5],
                      // focusNode: _focusNodes[5],
                      onChanged: (value) {
                        if (value.length == 1) {
                          // FocusScope.of(context).nextFocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).nextFocus();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Code send in 00:${_start.toString().padLeft(2, '0')}", // Display the countdown
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _canResendOtp
                        ? () async {
                            int mobileNumber = int.parse(widget.mobile!);
                            int newOtp = await sendSMS(mobileNumber);
                            setState(() {
                              widget.otp = newOtp;
                              _start = 59; // Reset timer
                              _startTimer(); // Restart timer
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("New OTP has been sent!"),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      " Resend OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: _canResendOtp
                            ? const Color(0xff140B40)
                            : Colors.grey, // Change color based on flag

                        // color: const Color(0xff140B40),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              InkWell(
                onTap: () {
                  _verifyOtp();
                },
                child: Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.r),
                    color: const Color(0xff140B40),
                  ),
                  child: Center(
                    child: _isRegistering
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            "Verify",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}


// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => ChangePass(), // Navigate to ChangePass screen
//   ),
// );
// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[0],
//     // focusNode: _focusNodes[0],
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 500), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[1],
//     // focusNode: _focusNodes[1],
//
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 100), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18.sp,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[2],
//     // focusNode: _focusNodes[2],
//
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 100), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18.sp,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[3],
//     // focusNode: _focusNodes[3],
//
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 100), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18.sp,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[4],
//     // focusNode: _focusNodes[4],
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 100), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18.sp,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// Container(
//   padding: EdgeInsets.only(bottom: 13.r),
//   height: 50.h,
//   width: 50.w,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//         width: .8.w, color: Colors.grey.shade400),
//     borderRadius: BorderRadius.circular(12.r),
//   ),
//   child: TextField(
//     controller: _otpControllers[5],
//     // focusNode: _focusNodes[5],
//     onChanged: (value) {
//       if (value.length == 1) {
//         // FocusScope.of(context).nextFocus();
//         Future.delayed(const Duration(milliseconds: 100), () {
//           FocusScope.of(context).nextFocus();
//         });
//       }
//     },
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//       ),
//     ),
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 18.sp,
//     ),
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.center,
//     inputFormatters: [
//       LengthLimitingTextInputFormatter(1),
//       FilteringTextInputFormatter.digitsOnly,
//     ],
//   ),
// ),

// onTap: () async {
//   int mobileNumber = int.parse(widget.mobile!);
//   // Call the function to send OTP
//   int newOtp = await sendSMS(mobileNumber);
//
//   // Update the state with the new OTP
//   setState(() {
//     widget.otp = newOtp; // Update the OTP in the widget
//   });
//
//   // Optionally, you can show a message to the user
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text("New OTP has been sent!"),
//     ),
//   );
// },



// final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
// @override
// void dispose() {
//   for (var controller in _otpControllers) {
//     controller.dispose();
//   }
//   for (var focusNode in _focusNodes) {
//     focusNode.dispose();
//   }
//   super.dispose();
// }
// void _onChanged(int index, String value) {
//   if (value.length == 1) {
//     // Move to next field
//     if (index < _focusNodes.length - 1) {
//       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//       Future.delayed(const Duration(milliseconds: 100), () {
//         FocusScope.of(context).nextFocus();
//       });
//     }
//   } else if (value.isEmpty) {
//     // Move to previous field if current field is cleared
//     if (index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//       Future.delayed(const Duration(milliseconds: 100), () {
//         FocusScope.of(context).previousFocus();
//       });
//     }
//   }
// }

// void _verifyOtp() {
//   String otpInput = '';
//   for (var controller in _otpControllers) {
//     otpInput += controller.text;
//   }
//
//   // Check if the entered OTP matches the expected OTP
//   if (otpInput == widget.otp.toString()) {
//     _dialogBuilder(context); // Show the success dialog
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Center(child: Text('Invalid OTP')),
//       ),
//     );
//   }
// }

// class OtpScreens extends StatefulWidget {
//   const OtpScreens({super.key, required String address, required String country, required String state, required String city, required String pincode, required int otp});
//
//   @override
//   State<OtpScreens> createState() => _OtpScreensState();
// }

// class _OtpScreensState extends State<OtpScreens> {
//   final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: Colors.white,
//         backgroundColor: const Color(0xffF0F1F5),
//         leading:InkWell(
//           onTap: (){
//             Navigator.pop(context);
//           },
//           child: const Icon(
//               Icons.arrow_back
//           ),
//         ),
//       ),
//       body:SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15.r,vertical: 10.r) ,
//           color: const Color(0xffF0F1F5),
//           height: MediaQuery.of(context).size.height,
//           child:  Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                Text("One Time Password",style: TextStyle(
//                   fontSize: 26.sp,
//                   letterSpacing: 0.8,color: Color(0xff140B40),
//                   fontWeight: FontWeight.w600
//               )),
//               SmallText(color: Colors.black45, text: "Put the OPT number below sent to your number +91 987*****69. "),
//               SizedBox(height: 20.h,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: TextField(
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration:const InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none
//                           )
//                       ),
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                       //Theme.of(context).textTheme.headlineMedium,
//
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                    SizedBox(width: 6.w,),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w
//                     ,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child:
//                     TextField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none
//                           )
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                       //Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                    SizedBox(width: 6.w,),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: TextField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none
//                           )
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                       //Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                    SizedBox(width: 6.w,),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: TextField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none
//                           )
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                       // Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                    SizedBox(width: 6.w,),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: TextField(
//                       decoration:const InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none
//                           )
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                       // Theme.of(context).textTheme.headlineMedium,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 6.w,),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 13.r),
//                     height: 50.h,
//                     width: 50.w,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(width: .8.w,color: Colors.grey.shade400,),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     child: Center(
//                       child: TextField(
//                         textAlignVertical: TextAlignVertical.center,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide.none
//                             )
//                         ),
//                         onChanged: (value) {
//                           if (value.length == 1) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.sp,),
//                         // Theme.of(context).textTheme.headlineMedium,
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(1),
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//               SizedBox(height: 20.h,),
//               Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Code send in 00:29",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.grey),),
//                   Text(" Send OTP",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp,color:Color(0xff140B40)),),
//                 ],
//               ),
//
//               SizedBox(height: 30.h,),
//               InkWell(
//                 onTap: (){
//                   _dialogBuilder(context);
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) =>const NewPassword(),));
//                 },
//                 child: Container(
//                   height: 50.h,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(9.r),
//                       color:const Color(0xff140B40)
//                   ),
//                   child: Center(child:
//                   Text("Verify",style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.w500),)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future<void> _dialogBuilder(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding:const EdgeInsets.only(top: 15,right: 20,left: 20),
//             height: 318.h,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20.r),
//               color: Colors.white
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset('assets/verify.png',height: 110.h,color: Color(0xff140B40),),
//                 SizedBox(height: 15.h),
//                 Text("OTP Verified Successfully",style: TextStyle(
//                     fontSize: 20.sp,
//                     letterSpacing: 0.8
//                     ,color: Color(0xff140B40),
//                     fontWeight: FontWeight.w600
//                 )),
//                 SmallText(color: Colors.black, text: "Your Security Confirmed,"),
//                 SmallText(color: Colors.black, text: "Access Granted"),
//                 SizedBox(height: 20.h),
//                 InkWell(
//                   onTap: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const NewPassword(),));
//                   },
//                   child: Container(
//                     height: 50.h,
//                     width: 272.w
//                     ,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(9.r),
//                         color:const Color(0xff140B40)
//                     ),
//                     child: Center(child:
//                     Text("Continue",style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.w500),)),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//
//           ),
//         );
//       },
//     );
//   }
// }
