import 'package:batting_app/screens/Auth/otpScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/appbar_for_setting.dart';
import '../../widget/appbartext.dart';
import '../../widget/normaltext.dart';
import '../../widget/smalltext.dart';
import '../bnb.dart';
import 'apicallforotp.dart';

class ForgotPassword extends StatefulWidget {
  final bool isChangePassword; // Add this line
  final bool ishomescreen;

  const ForgotPassword(
      {super.key, this.isChangePassword = false, this.ishomescreen = false});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mobile = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('widget of change password is:- ${widget.isChangePassword}');
        // if (widget.isChangePassword) {
        // Navigate to MyHomePage when back button is pressed
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MyHomePage(),
        //   ),
        // );

        // } else {
        // Default behavior for back button
        // Navigator.pop(context);
        // }
        await Future.microtask(() {
          // Check if the navigator can pop before trying to pop
          if (widget.ishomescreen) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
              (route) => false, // Clears all previous routes
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
              print('Navigaton working');
            } else {
              print("No route to pop!");
            }
          }
        });
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF0F1F5),
        // appBar: AppBar(
        //   surfaceTintColor: Colors.white,
        //   backgroundColor: const Color(0xffF0F1F5),
        //   leading: InkWell(
        //     onTap: () {
        //       // if (widget.isChangePassword) {
        //         // Navigate to MyHomePage when back button is pressed
        //         // Navigator.pushReplacement(
        //         //   context,
        //         //   MaterialPageRoute(
        //         //     builder: (context) => const MyHomePage(),
        //         //   ),
        //         // );
        //       // } else {
        //         // Default behavior for back button
        //         Navigator.pop(context);
        //       // }
        //       },
        //     child: const Icon(Icons.arrow_back),
        //   ),
        // ),
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(67.h),
        //   child: ClipRRect(
        //     child: AppBar(
        //       surfaceTintColor: const Color(0xffF0F1F5),
        //       backgroundColor: const Color(0xffF0F1F5),
        //       elevation: 0,
        //       centerTitle: true,
        //       automaticallyImplyLeading: false,
        //       flexibleSpace: Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20.w),
        //         decoration: const BoxDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [Color(0xff1D1459), Color(0xff140B40)],
        //           ),
        //         ),
        //         child: Padding(
        //           padding: EdgeInsets.only(top: 30.h),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               InkWell(
        //                 onTap: () {
        //                   if(widget.ishomescreen) {
        //                     // Navigator.pushAndRemoveUntil(
        //                     //   context,
        //                     //   MaterialPageRoute(
        //                     //       builder: (context) => const ForgotPassword(
        //                     //           isChangePassword: true)),
        //                     //   ModalRoute.withName(
        //                     //       '/screens/homescreens.dart'), // This will remove all previous routes
        //                     // );
        //                     Navigator.pushAndRemoveUntil(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => const MyHomePage(),
        //                       ),
        //                           (route) => false, // Clears all previous routes
        //                     );
        //                   }
        //                   else{
        //                     Navigator.pop(context,'settingscreen');
        //                   }
        //                   // Navigator.pop(context);
        //                 },
        //                 child: const Icon(
        //                   Icons.arrow_back,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               AppBarText(color: Colors.white, text: widget.isChangePassword ? "Change Password" : "Forgot Password"),
        //               Container(
        //                 width: 30,
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        appBar: CustomAppBar(
          title:
              widget.isChangePassword ? "Change Password" : "Forgot Password",
          onBackButtonPressed: () {
            // Custom behavior for back button (if needed)
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
            color: const Color(0xffF0F1F5),
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Text(
                  //    widget.isChangePassword ? "Change Password" : "Forgot Password", // Update this line
                  //
                  //    // "Forgot Password",
                  //   style: TextStyle(
                  //     fontSize: 26.sp,
                  //     letterSpacing: 0.8,
                  //     color: const Color(0xff140B40),
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(height: 15.h),
                  NormalText(color: Colors.black, text: "Mobile Number"),
                  SizedBox(height: 5.h),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (phone) {
                      if (phone!.isEmpty) {
                        return "Please Enter Mobile No";
                      } else if (phone.length < 10) {
                        return "Mobile num must be 10 digit";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    controller: mobile,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 75.h, // Set the max height
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 10.r), // Padding only on the left
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400, width: 0.5.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400, width: 0.5.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400, width: 0.5.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      // int mobileNumber = int.parse(mobile);
                      //
                      // int otp =  sendSMS(mobileNumber);
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true; // Start loader
                        });
                        try {
                          String mobileString = mobile.text;
                          int mobileNumber = int.parse(mobileString);
                          print('mobile number is :- $mobileNumber');
                          // Call the function to send OTP
                          int otp = await sendSMS(mobileNumber);

                          if (otp != 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpScreens(
                                  isChangePassword: widget.isChangePassword,
                                  isForgotPassword: widget.isChangePassword
                                      ? false
                                      : true, // Add a flag to indicate forgot password flow
                                  mobile: mobileString,
                                  otp: otp, // Pass the OTP to the next screen
                                  // register1: register1, // Pass additional data
                                ),
                              ),
                            );
                            setState(() {
                              _isLoading = false; // Stop loader
                            });
                          } else {
                            // Handle OTP sending failure
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to send OTP')),
                            );
                          }
                          setState(() {
                            _isLoading = false; // Stop loader
                          });
                        } catch (e) {
                          // Handle errors (e.g., invalid mobile number or network issues)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                          setState(() {
                            _isLoading = false; // Stop loader
                          });
                        } finally {
                          setState(() {
                            _isLoading = false; // Stop loader
                          });
                        }
                      }
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => OtpScreens(
                      //         // otp: otp,
                      //       ),
                      //     ),
                      //   );
                      // }
                    },
                    child: Container(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r),
                        color: const Color(0xff140B40),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Send OTP",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // SmallText(
                  //   color: Colors.black45,
                  //   text: widget.isChangePassword
                  //       ? "enter your mobile number to receive your OTP for changing password."
                  //       : "Please enter your mobile number below to receive your OTP number.",
                  //   // text: "Please enter mobile number below to receive your OTP number.",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
