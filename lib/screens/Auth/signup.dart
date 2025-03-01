import 'package:batting_app/screens/Auth/login.dart';
import 'package:batting_app/screens/Auth/signupnext.dart';
import 'package:batting_app/widget/comanfuntion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/normaltext.dart';
import '../../widget/smalltext.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController dateController = TextEditingController();
  bool tap = true;
  bool ctap = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conformPassword = TextEditingController();
  TextEditingController date = TextEditingController();
  String? _character = "Male";

  ComunFunction comunFunction = ComunFunction();

  var age = DateTime.now();
  Widget _buildTextFormField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    String? Function(String?)? validator,
    int? maxLength, // Add maxLength parameter
  }) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      maxLength: maxLength, // Set maxLength
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
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
    );
  }

  late DateTime pickedDate;
  String selectedDateText = "";
  final TextEditingController _dateController = TextEditingController();
  List<dynamic> register = [];

  String dateError = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.r),
        color: const Color(0xffF0F1F5),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 55.h),
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 26.sp,
                    letterSpacing: 0.8.sign,
                    color: const Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SmallText(
                  color: Colors.black45,
                  text: "Register now to begin an amazing journey.",
                ),
                SizedBox(height: 20.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(color: Colors.black, text: "First Name"),
                    SizedBox(height: 5.h),
                    _buildTextFormField(
                      controller: fullName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Name";
                        } else if (value.length > 18) {
                          return "Name should be maximum 18 characters";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                NormalText(color: Colors.black, text: "Email Address"),
                SizedBox(height: 5.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9@a-zA-Z.]")),
                  ],
                  autocorrect: false,
                  onChanged: (value) {},
                  style: const TextStyle(color: Colors.black),
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
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ), // Padding only on the left
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
                NormalText(color: Colors.black, text: "Mobile Number"),
                SizedBox(height: 5.h),
                _buildTextFormField(
                  controller: mobile,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (phone) {
                    if (phone!.isEmpty) {
                      return "Please enter Mobile No";
                    } else if (phone.length < 10) {
                      return "Mobile num must be 10 digits";
                    }
                    return null;
                  },
                  maxLength: 10,
                  // Set maxLength to 10
                ),
                SizedBox(height: 15.h),
                NormalText(color: Colors.black, text: "Gender"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          activeColor: const Color(0xff140B40),
                          value: "Male",
                          groupValue: _character,
                          onChanged: (value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        const Text('Male'),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Row(
                      children: [
                        Radio<String>(
                          activeColor: const Color(0xff140B40),
                          value: "Female",
                          groupValue: _character,
                          onChanged: (value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                NormalText(color: Colors.black, text: "Date Of Birth"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          // color: dateError.isEmpty ? Colors.grey.shade400 : Colors.red, // Dynamic border color
                          color: dateError.isEmpty
                              ? Colors.grey.shade400
                              : const Color(0xffbd1509), // Dynamic border color
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        child: GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(
                                  days: 365 *
                                      100)), // Allow past dates up to 100 years
                              lastDate: DateTime.now(),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                setState(() {
                                  pickedDate =
                                      selectedDate; // Assign the selected date to pickedDate
                                  DateTime today = DateTime.now();
                                  DateTime eighteen = DateTime(
                                      today.year - 18, today.month, today.day);
                                  if (pickedDate.isBefore(eighteen)) {
                                    // Format the date and set it to the date controller
                                    date.text = DateFormat('dd-MM-yyyy')
                                        .format(selectedDate);
                                    dateError = ""; // Clear the error message
                                  } else {
                                    dateError =
                                        "You must be at least 18 years old.";
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Center(
                                              child: Text("You are not 18+"))),
                                    ); // Set error message
                                  }
                                });
                              }
                            });
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              controller: date,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.date_range,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (dateError
                        .isNotEmpty) // Show error text if there is an error
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 12),
                        child: Text(
                          dateError,
                          style: const TextStyle(
                              color: Color(0xffbd1509), fontSize: 12),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 15.h),
                NormalText(color: Colors.black, text: "Password"),
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
                  style: const TextStyle(color: Colors.black),
                  controller: password,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 15), // Padding only on the left
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
                NormalText(color: Colors.black, text: "Confirm Password"),
                SizedBox(height: 5.h),
                TextFormField(
                  obscureText: ctap,
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
                  style: const TextStyle(color: Colors.black),
                  controller: conformPassword,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 15), // Padding only on the left
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ctap = !ctap;
                        });
                      },
                      icon: Icon(
                        tap
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: Colors.grey,
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
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    // Reset the date error message before validation
                    setState(() {
                      dateError = ""; // Clear previous error message
                    });

                    if (_formKey.currentState!.validate()) {
                      // Check if date of birth is empty
                      if (date.text.isEmpty) {
                        setState(() {
                          dateError =
                              "Please enter date of birth"; // Set error message for date of birth
                        });
                      } else {
                        if (password.text == conformPassword.text) {
                          DateTime today = DateTime.now();
                          DateTime eighteenYearsAgo =
                              DateTime(today.year - 18, today.month, today.day);
                          if (pickedDate.isBefore(eighteenYearsAgo)) {
                            selectedDateText =
                                DateFormat('YYYY-MM-DD').format(pickedDate);
                            register.add({
                              'fullName': fullName.text,
                              'email': email.text,
                              'mobile': mobile.text,
                              'gender': _character,
                              'dateOfBirth': DateFormat('yyyy-MM-dd').format(
                                  pickedDate), // Store in yyyy-MM-dd format

                              // 'dateOfBirth': date.text,
                              'password': password.text,
                              'confirm password': conformPassword.text,
                            });
                            print(
                                "this data from first screen in register list$register");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpNextScreen(
                                      register: register, mobile: mobile.text)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("You are not 18+")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Passwords do not match")),
                          );
                        }
                      }
                    } else {
                      // If the form is not valid, check for date error
                      if (date.text.isEmpty) {
                        setState(() {
                          dateError =
                              "Please enter date of birth"; // Set error message for date of birth
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 50.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: const Color(0xff140B40),
                    ),
                    child: Center(
                      child: Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            " Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: const Color(0xff140B40)),
                          ),
                          Container(
                              height: 1.h,
                              width: 50.w,
                              color: const Color(0xff140B40))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 1.h,
                        width: MediaQuery.of(context).size.width / 2.5,
                        color: Colors.grey.shade300),
                    Text(
                      " OR ",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                        height: 1.h,
                        width: MediaQuery.of(context).size.width / 2.5,
                        color: Colors.grey.shade300),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 48.h,
                        width: 159.w,
                        child: Image.asset(
                          "assets/google.png",
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                        height: 48.h,
                        width: 159.w,
                        child: Image.asset(
                          "assets/facebook.png",
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// inputFormatters: inputFormatters,
// [
//   FilteringTextInputFormatter.digitsOnly, // Allow only digits (no special characters or letters)
// ],

// InkWell(
//   onTap: () {
//     setState(() {
//       dateError = ""; // Clear previous error message
//     });
//     if (_formKey.currentState!.validate()) {
//       if (password.text == conformPassword.text) {
//         if (pickedDate != null) {
//           DateTime today = DateTime.now();
//           DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);
//           if (pickedDate.isBefore(eighteenYearsAgo)) {
//             selectedDateText = DateFormat('YYYY-MM-DD').format(pickedDate);
//             register.add({
//               'fullName': fullName.text,
//               'email': email.text,
//               'mobile': mobile.text,
//               'gender': _character,
//               'dateOfBirth': date.text,
//               'password': password.text,
//               'confirm password': conformPassword.text,
//             });
//             print("this data from first screen in register list${register}");
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SignUpNextScreen(register:register,mobile: mobile.text)),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("You are not 18+")),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Please select your date of birth")),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Passwords do not match")),
//         );
//       }
//     }
//   },
//   child: Container(
//     height: 50.h,
//     width: MediaQuery.of(context).size.width,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(9.r),
//       color: const Color(0xff140B40),
//     ),
//     child: Center(
//       child: Text(
//         "Registration",
//         style: TextStyle(
//           fontSize: 16.sp,
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//   ),
// ),




// validator: (value) {
//
//   if (value!.isEmpty) {
//     return 'Please enter your first name';
//   }
//   return null;
// },

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Expanded(
//       child: ListTile(
//
//         onTap: (){
//         },
//         title:  const Text('Male'),
//         leading: Radio<String>(
//           activeColor: const Color(0xff140B40),
//           value: "Male",
//           groupValue: _character,
//           onChanged: (value) {
//             setState(() {
//                _character = value;
//             });
//           },
//         ),
//       ),
//     ),
//     Expanded(
//       child: ListTile(
//         onTap: (){
//         },
//         title:  const Text('Female'),
//         leading: Radio<String>(
//           activeColor: const Color(0xff140B40),
//           value: "Female",
//           groupValue: _character,
//           onChanged: (value) {
//             setState(() {
//               _character = value;
//             });
//           },
//         ),
//       ),
//     ),
//   ],
// ),
// SizedBox(height: 5.h),
// Container(
//   height: 50,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//       color: Colors.grey.shade400,
//       width: 1.0.w,
//     ),
//     borderRadius: BorderRadius.circular(10.0.r),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
//     child: GestureDetector(
//       onTap: () {
//         showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)), // Allow past dates up to 100 years
//           lastDate: DateTime.now(),
//         ).then((selectedDate) {
//           if (selectedDate != null) {
//             setState(() {
//               pickedDate = selectedDate;
//               DateTime today = DateTime.now();
//               DateTime eighteen = DateTime(today.year - 18, today.month, today.day);
//               if (pickedDate.isBefore(eighteen)) {
//                 // Format the date and set it to the date controller
//                 date.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Center(child: Text("You are not 18+"))),
//                 );
//               }
//             });
//           } else {
//             print("not selected");
//           }
//         });
//       },
//       child: AbsorbPointer(
//         child:
//         TextFormField(
//           style: const TextStyle(color: Colors.black),
//           controller: date,
//           readOnly: true,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             suffixIcon:  Icon(
//                     Icons.date_range,
//                     color: Colors.grey.shade400,
//                   ),
//           ),
//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Please enter date of birth";
//             } else if (value.length > 18) {
//               return "Date of birth should be above 18 years";
//             }
//             return null;
//           },
//         ),
//       ),
//     ),
//
//   ),
// ),

// showDatePicker(
//   context: context,
//   initialDate: DateTime.now(),
//   firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)), // Allow past dates up to 100 years
//   lastDate: DateTime.now(),
// ).then((selectedDate) {
//   if (selectedDate != null) {
//     setState(() {
//
//       DateTime today = DateTime.now();
//       DateTime eighteen = DateTime(today.year - 18, today.month, today.day);
//       if (selectedDate.isBefore(eighteen)) {
//         // Format the date and set it to the date controller
//         date.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//         // if(date.text.isEmpty)
//           dateError = ""; // Clear the error message
//       } else {
//         dateError = "You must be at least 18 years old.";
//         ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Center(child: Text("You are not 18+"))),
//                             );// Set error message
//       }
//     });
//   }
// });

// child: Row(
//   children: <Widget>[
//     Expanded(
//       child: IgnorePointer(
//         child: TextFormField(
//           controller: date,
//           keyboardType: TextInputType.datetime,
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//           ),
//           style: const TextStyle(color: Colors.black),
//         ),
//       ),
//     ),
//     Icon(
//       Icons.date_range,
//       color: Colors.grey.shade400,
//     ),
//   ],
// ),