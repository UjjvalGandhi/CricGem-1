import 'dart:convert';  // For JSON encoding
import 'package:batting_app/screens/bnb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../db/app_db.dart';
import '../../widget/appbartext.dart';
import '../../widget/notification_service.dart';
import '../../widget/notificationprovider.dart';
import '../Auth/forgotpassword.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  bool tap2 = true;
  bool tap1 = true;
  bool ctap = true;
  bool isLoading = false; // Flag to toggle loading state


  final _formKey = GlobalKey<FormState>(); // Key for form validation

  TextEditingController password = TextEditingController();
  TextEditingController conformPassword = TextEditingController();
  TextEditingController newpass = TextEditingController();

  Future<void> _changePassword() async {
    setState(() {
      isLoading = true; // Show the loader
    });
    // API endpoint
    const String url = "https://batting-api-1.onrender.com/api/user/changePassword";

    try {
      // Prepare the request body
      final Map<String, dynamic> body = {
        'oldPassword': password.text,
        'newPassword': newpass.text,
      };
      print("ashok try");
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      print("Token : $token");

      // Make the POST request
      final response = await http.post(
        Uri.parse("https://batting-api-1.onrender.com/api/user/changePassword"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "$token",


          },
        body: jsonEncode(body),
      );
      var data1 = jsonDecode(response.body);
      // Check if the request was successful
      if (response.statusCode == 200) {
        _showSuccessSnackbar();
        print('Response data:-$data1');
        Future.delayed(const Duration(milliseconds: 500), () async {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const Bottom()),
          // ).then((_) {
          //
          //   // Clear the text fields after navigation completes
          //   password.clear();
          //   newpass.clear();
          //   conformPassword.clear();
          // });
          final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
          await notificationProvider.fetchNotifications();

          // Check if notifications are available
          if (notificationProvider.notifications.isNotEmpty) {
            final notification = notificationProvider.notifications.last;

            // Show notification using NotificationService
            NotificationService().showNotification(
              title: notification['title'] ?? 'No Title',
              body: notification['message'] ?? 'No Message',
            );
          } else {
            // Show fallback notification if no notifications are available
            NotificationService().showNotification(
              title: 'Password change Request',
              body: 'Password change Successfully!',
            );
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Bottom()),
                (Route<dynamic> route) => false, // This condition removes all previous routes
          ).then((_) {
            // Clear the text fields after navigation completes
            password.clear();
            newpass.clear();
            conformPassword.clear();
          });

        });
        setState(() {
          isLoading = false; // Hide the loader
        });
      } else {
        _showErrorSnackbar("${data1['message']}");
        setState(() {
          isLoading = false; // Hide the loader
        });
        // _showErrorSnackbar('Failed to change password. Please try again.');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred. Please try again.');
      setState(() {
        isLoading = false; // Hide the loader
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _changePassword();
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
      ),
    );
    // password.clear();
    // newpass.clear();
    // conformPassword.clear();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff1D1459), Color(0xff140B40)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword(isChangePassword: true,ishomescreen : true)),
                            ModalRoute.withName('/screens/settingscreen.dart'), // This will remove all previous routes
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      AppBarText(color: Colors.white, text: "Change Password"),
                      Container(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xffF0F1F5),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  const Text("Old Password", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: tap2,
                    obscuringCharacter: "*",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Please Enter Old Password";
                      } else if (pass.length < 6) {
                        return "Password minimum 6 digits";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    controller: password,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxHeight: 75,
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            tap2 = !tap2;
                          });
                        },
                        icon: Icon(
                          tap2 ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 15),
                  const Text("New Password", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: tap1,
                    obscuringCharacter: "*",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Please Enter New Password";
                      } else if (pass.length < 6) {
                        return "Password minimum 6 digits";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    controller: newpass,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxHeight: 75,
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            tap1 = !tap1;
                          });
                        },
                        icon: Icon(
                          tap1 ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 15),
                  const Text("Confirm New Password", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: ctap,
                    obscuringCharacter: "*",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Please Enter Confirm New Password";
                      } else if (pass.length < 6) {
                        return "Password minimum 6 digits";
                      } else if (pass != newpass.text) {
                        return "Passwords do not match";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    controller: conformPassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxHeight: 75,
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ctap = !ctap;
                          });
                        },
                        icon: Icon(
                          ctap ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  SizedBox(height: 15.h),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const ForgotPassword(),
                  //       ),
                  //     );
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Text(
                  //             "Forget Password?",
                  //             style: TextStyle(
                  //               color: const Color(0xff140B40),
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 13.sp,
                  //             ),
                  //           ),
                  //           Container(
                  //             height: 1.h,
                  //             width: 109.w,
                  //             color: const Color(0xff140B40),
                  //           )
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  InkWell(
                    onTap:(){
                      if (!isLoading) _submitForm();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: const Color(0xff140B40),
                      ),
                      child: Center(
                        child:  isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            :const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
