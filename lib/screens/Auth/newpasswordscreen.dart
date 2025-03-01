import 'dart:convert';
import 'dart:io';
import 'package:batting_app/screens/Auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/appbartext.dart';

class NewPasswordScreen extends StatefulWidget {
  final String? mobile;
  const NewPasswordScreen({
    super.key,
    this.mobile,
  });
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final conformPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  Future<void> newPass( String newpass) async {
    try {
      var payload = jsonEncode({
        'mobile': widget.mobile,
        'newPassword': newpass,
      });

      final response = await http.put(
        Uri.parse('https://batting-api-1.onrender.com/api/user/forget_password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'User -Agent': 'batting-app',
        },
        body: payload,
      );

      print("Request payload: $payload");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("${data['message']}")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data['message']}")),
        );
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please check your internet connection")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  // Future<void> newPass(
  //     String mobile,
  //     String newpass,
  //     ) async {
  //   // setState(() {
  //   //   _isRegistering = true;
  //   // });
  //
  //   try {
  //     var payload = jsonEncode({
  //       'mobile': mobile,
  //       'newPassword': newpass,
  //     });
  //
  //     final response = await http.post(
  //       Uri.parse('https://batting-api-1.onrender.com/api/user/forget_password'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'User-Agent': 'batting-app',
  //       },
  //       body: payload,
  //     );
  //     print("registration is happening:- $response");
  //     print("response of data11111:-${response.body}");
  //     var data1 = jsonDecode(response.body);
  //     print("response of data:-${response.body}");
  //     if (response.statusCode == 200) {
  //
  //       print("response of data11111111111:-${response.body}");
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Registration Successful")),
  //       );
  //       print("registration is happening11111111111:- ${response.body}");
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginScreen()),
  //       );
  //       // Show success dialog
  //
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         // const SnackBar(content: Text('Registration failed')),
  //         SnackBar(content: Text("${data1['message']}")),
  //
  //       );
  //       print("registration is happening11111111111:- ${response.body}");
  //     }
  //   } on SocketException {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Please check your internet connection"),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //       ),
  //     );
  //   } finally {
  //     // setState(() {
  //     //   _isRegistering = false;
  //     // });
  //   }
  // }
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              height: 90.h,
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
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      AppBarText(color: Colors.white, text: "New Password"),
                      SizedBox(width: 20.w),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: const Color(0xffF0F1F5),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                // Padding(
                //   padding: const EdgeInsets.all(2.0),
                //   child: Text('Mobile Number',style: TextStyle(color:Colors.grey,fontSize: 15.h,fontWeight: FontWeight.bold),),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.grey.shade400, width: 1.0),
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: TextFormField(
                //       controller: oldPasswordController,
                //       decoration: const InputDecoration(
                //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //         // hintText: 'Old Password',
                //         border: InputBorder.none,
                //       ),
                //       // validator: (value) {
                //       //   if (value!.isEmpty) {
                //       //     return 'Please enter old password';
                //       //   }
                //       //   return null;
                //       // },
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('New Password',style: TextStyle(color:Colors.grey,fontSize: 15.h,fontWeight: FontWeight.bold),),
                ),

                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),

                        // hintText: 'New Password',
                        border: InputBorder.none,
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter new password';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       // Update password logic here
                //       // ...
                //     }
                //   },
                //   child: Text('Submit'),
                // ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Confirm Password',style: TextStyle(color:Colors.grey,fontSize: 15.h,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: conformPasswordController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        // hintText: 'Old Password',
                        border: InputBorder.none,
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter old password';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  color: Colors.white,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // if (oldPasswordController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text("Please enter the Mobile Number")),
                          //   );
                          // } else
                          //   if (newPasswordController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //         content: Text("Please enter the New Password")),
                          //   );
                          // } if(conformPasswordController.text.isEmpty){
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content: Text("Please enter the Confirm Password")),
                          //     );
                          //   }if(newPasswordController.text == conformPasswordController.text){
                          //     newPass(
                          //       // oldPasswordController.text,
                          //       newPasswordController.text,
                          //     );
                          //     setState(() {
                          //       conformPasswordController.clear();
                          //       newPasswordController.clear();
                          //     });
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content: Text("Password Changed Successfully")),
                          //     );
                          //   }
                          //   else {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content: Text("Password and Confirm password should be same")),
                          //     );
                          // }
                          if (newPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter the New Password")),
                            );
                            return; // Exit if the new password is empty
                          }

                          // Check if the confirm password field is empty
                          if (conformPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter the Confirm Password")),
                            );
                            return; // Exit if the confirm password is empty
                          }

                          // Check if the new password and confirm password match
                          if (newPasswordController.text != conformPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password and Confirm password should be the same")),
                            );
                            return; // Exit if passwords do not match
                          }

                          // If all checks pass, call the newPass function
                          newPass(newPasswordController.text);

                          // Clear the text fields after successful submission
                          setState(() {
                            conformPasswordController.clear();
                            newPasswordController.clear();
                          });

                          // Show success message
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text("Password Changed Successfully")),
                          // );
                        },              // onTap: (){
                        //   if (_formKey.currentState!.validate()) {
                        //     newPass(
                        //       widget.mobile!,
                        //       newPasswordController.text,
                        //
                        //     );
                        //     // Update password logic here
                        //     // ...
                        //   }
                        //   // Share.share("www.google.com", subject: 'Check this out!');
                        // },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.89,
                          decoration: BoxDecoration(
                            color: const Color(0xff140B40),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 1),
                                  // child: Image.asset(
                                  //   'assets/whatsup.png',
                                  //   height: 18.h,
                                  // ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 48.h,
                      //   width: MediaQuery.of(context).size.width * 0.12,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(width: 1.w, color: Colors.grey),
                      //     borderRadius: BorderRadius.circular(10.r),
                      //   ),
                      //   child: Center(
                      //     child: Image.asset('assets/share_grey.png', height: 19.h),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.all(19.w),
      //   color: Colors.white,
      //   child: Row(
      //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           // if (oldPasswordController.text.isEmpty) {
      //           //   ScaffoldMessenger.of(context).showSnackBar(
      //           //     const SnackBar(content: Text("Please enter the Mobile Number")),
      //           //   );
      //           // } else
      //           //   if (newPasswordController.text.isEmpty) {
      //           //   ScaffoldMessenger.of(context).showSnackBar(
      //           //     const SnackBar(
      //           //         content: Text("Please enter the New Password")),
      //           //   );
      //           // } if(conformPasswordController.text.isEmpty){
      //           //     ScaffoldMessenger.of(context).showSnackBar(
      //           //       const SnackBar(
      //           //           content: Text("Please enter the Confirm Password")),
      //           //     );
      //           //   }if(newPasswordController.text == conformPasswordController.text){
      //           //     newPass(
      //           //       // oldPasswordController.text,
      //           //       newPasswordController.text,
      //           //     );
      //           //     setState(() {
      //           //       conformPasswordController.clear();
      //           //       newPasswordController.clear();
      //           //     });
      //           //     ScaffoldMessenger.of(context).showSnackBar(
      //           //       const SnackBar(
      //           //           content: Text("Password Changed Successfully")),
      //           //     );
      //           //   }
      //           //   else {
      //           //     ScaffoldMessenger.of(context).showSnackBar(
      //           //       const SnackBar(
      //           //           content: Text("Password and Confirm password should be same")),
      //           //     );
      //           // }
      //           if (newPasswordController.text.isEmpty) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("Please enter the New Password")),
      //             );
      //             return; // Exit if the new password is empty
      //           }
      //
      //           // Check if the confirm password field is empty
      //           if (conformPasswordController.text.isEmpty) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("Please enter the Confirm Password")),
      //             );
      //             return; // Exit if the confirm password is empty
      //           }
      //
      //           // Check if the new password and confirm password match
      //           if (newPasswordController.text != conformPasswordController.text) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("Password and Confirm password should be the same")),
      //             );
      //             return; // Exit if passwords do not match
      //           }
      //
      //           // If all checks pass, call the newPass function
      //           newPass(newPasswordController.text);
      //
      //           // Clear the text fields after successful submission
      //           setState(() {
      //             conformPasswordController.clear();
      //             newPasswordController.clear();
      //           });
      //
      //           // Show success message
      //           // ScaffoldMessenger.of(context).showSnackBar(
      //           //   const SnackBar(content: Text("Password Changed Successfully")),
      //           // );
      //         },              // onTap: (){
      //         //   if (_formKey.currentState!.validate()) {
      //         //     newPass(
      //         //       widget.mobile!,
      //         //       newPasswordController.text,
      //         //
      //         //     );
      //         //     // Update password logic here
      //         //     // ...
      //         //   }
      //         //   // Share.share("www.google.com", subject: 'Check this out!');
      //         // },
      //         child: Container(
      //           height: 47,
      //           width: MediaQuery.of(context).size.width * 0.89,
      //           decoration: BoxDecoration(
      //             color: const Color(0xff140B40),
      //             borderRadius: BorderRadius.circular(8.r),
      //           ),
      //           child: Center(
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 const Padding(
      //                   padding: EdgeInsets.only(bottom: 1),
      //                   // child: Image.asset(
      //                   //   'assets/whatsup.png',
      //                   //   height: 18.h,
      //                   // ),
      //                 ),
      //                 SizedBox(width: 5.w),
      //                 Text(
      //                   "Submit",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.w600,
      //                     fontSize: 16.sp,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       // Container(
      //       //   height: 48.h,
      //       //   width: MediaQuery.of(context).size.width * 0.12,
      //       //   decoration: BoxDecoration(
      //       //     border: Border.all(width: 1.w, color: Colors.grey),
      //       //     borderRadius: BorderRadius.circular(10.r),
      //       //   ),
      //       //   child: Center(
      //       //     child: Image.asset('assets/share_grey.png', height: 19.h),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}