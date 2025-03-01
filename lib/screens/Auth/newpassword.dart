import 'package:batting_app/screens/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/normaltext.dart';
import '../../widget/smalltext.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool tap = true;
  bool ctap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: const Color(0xffF0F1F5),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
          color: const Color(0xffF0F1F5),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Enter New Password",
                  style: TextStyle(
                    fontSize: 26.sp,
                    letterSpacing: 0.8,
                    color: const Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SmallText(
                  color: Colors.black45,
                  text: "Enter your new password",
                ),
                SizedBox(height: 20.h),
                NormalText(color: Colors.black, text: "New Password"),
                SizedBox(height: 5.h),
                TextFormField(
                  obscureText: tap,
                  obscuringCharacter: "*",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return "Please Enter password";
                    } else if (pass.length < 6) {
                      return "Password must be 6 digits";
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: password,
                  keyboardType: TextInputType.number,
                  maxLength: 6.bitLength,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,  // Set the max height
                    ),
                    contentPadding: EdgeInsets.only(left: 15.r), // Padding only on the left
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          tap = !tap;
                        });
                      },
                      icon: Icon(
                        tap ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                NormalText(color: Colors.black, text: "Confirm New Password"),
                SizedBox(height: 5.h),
                TextFormField(
                  obscureText: ctap,
                  obscuringCharacter: "*",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return "Please Enter password";
                    } else if (pass.length < 6) {
                      return "Password must be 6 digits";
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: confirmPassword,
                  keyboardType: TextInputType.number,
                  maxLength: 6.bitLength,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,  // Set the max height
                    ),
                    contentPadding: EdgeInsets.only(left: 15.r), // Padding only on the left
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ctap = !ctap;
                        });
                      },
                      icon: Icon(
                        tap ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5.w),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (password.text == confirmPassword.text) {
                        _dialogBuilder(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );
                      }
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
                        "Confirm",
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
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 330,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/change.png',
                  height: 110,
                  color: const Color(0xff140B40),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Password Changed",
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SmallText(
                  color: Colors.black,
                  text: "Your password was changed",
                ),
                SmallText(
                  color: Colors.black,
                  text: "successfully you can login now!",
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 50,
                    width: 272,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: const Color(0xff140B40),
                    ),
                    child: const Center(
                      child: Text(
                        "Back to Login",
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
}
