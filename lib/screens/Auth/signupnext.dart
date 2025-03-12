import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/comanfuntion.dart';
import '../../widget/normaltext.dart';
import '../../widget/smalltext.dart';
import 'package:batting_app/screens/country/selection.dart';

import 'apicallforotp.dart';
import 'otpScreens.dart';

class SignUpNextScreen extends StatefulWidget {
  final List<dynamic> register;
  final String mobile;

  const SignUpNextScreen({super.key, required this.register, required this.mobile});



  @override
  State<SignUpNextScreen> createState() => _SignUpNextScreenState();
}

class _SignUpNextScreenState extends State<SignUpNextScreen> {
  final _formKey = GlobalKey<FormState>();
  ComunFunction comunFunction = ComunFunction();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController(text: "India");
  TextEditingController pincode = TextEditingController();
  LocationSelection locationSelection = LocationSelection();
  List<dynamic> register1 = [];
  String? _selectedState;
  String? _selectedCity;
  List<String> states = [];
  List<String> cities = [];
  // bool _isRegistering = false; // Track registration state

  // void register(
  //     String address,
  //     String country,
  //     String state,
  //     String city,
  //     String pincode,
  //     ) async {
  //   setState(() {
  //     _isRegistering = true;
  //   });
  //
  //   try {
  //     var payload = jsonEncode({
  //       'address': address,
  //       'city': city,
  //       'pincode': int.parse(pincode),
  //       'state': state,
  //       'country': country,
  //       'name': widget.register[0]["fullName"],
  //       'email': widget.register[0]['email'],
  //       'mobile': widget.register[0]['mobile'],
  //       'gender': widget.register[0]['gender'],
  //       'dob': widget.register[0]['dateOfBirth'],
  //       'password': widget.register[0]['password'],
  //       'confirm_password': widget.register[0]['confirm_password'],
  //     });
  //
  //     final response = await http.post(
  //     Uri.parse('https://batting-api-1.onrender.com/api/user/add_user'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'User-Agent': 'batting-app',
  //     },
  //     body: payload,
  //   );
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body.toString());
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Center(child: Text("Registration Successful")),
  //         ),
  //       );
  //
  //       // Send OTP
  //       int mobileNumber = int.parse(widget.mobile);
  //       print('mobile number:---- $mobileNumber');
  //       int otp = await sendSMS(mobileNumber);
  //
  //       if (otp != 0) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OtpScreens(
  //               address: address,
  //               country: country,
  //               state: state,
  //               city: city,
  //               pincode: pincode,
  //               otp: otp, // Pass the OTP to the next screen
  //             ),
  //           ),
  //         );
  //       } else {
  //         // Handle OTP sending failure
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Center(child: Text('Failed to send OTP'))),
  //         );
  //       }
  //     } else {
  //       print(response.body.toString());
  //       print("this print from else in api:::${payload}");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Center(child: Text('Registration failed'))),
  //       );
  //     }
  //   } on SocketException catch (_) {
  //     // Handles network-related exceptions
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Please check your internet connection"),
  //       ),
  //     );
  //   }
  //   catch (e) {
  //     print("Exception caught: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //        SnackBar(
  //         content: Center(child: Text('${e.toString()}')),
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isRegistering = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getStates();
  }

  void getStates() async {
    await locationSelection.countryNameList();
    setState(() {
      states = locationSelection.stateNameList("India");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        color: const Color(0xffF0F1F5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                SizedBox(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 26.sp,
                    letterSpacing: 0.8,
                    color: const Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SmallText(
                  color: Colors.black45,
                  text: "Register now to begin an amazing journey.",
                ),
                SizedBox(height: 20.h),
                NormalText(color: Colors.black, text: "Address"),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (add) {
                    if (add!.isEmpty) {
                      return "Please Enter Address";
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: address,
                  minLines: 1.sign,
                  maxLines: 5.sign,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
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
                  textAlignVertical: TextAlignVertical.top,
                ),
                SizedBox(height: 20.h),
                NormalText(color: Colors.black, text: "Country"),
                SizedBox(height: 5.h),
                TextFormField(
                  readOnly: true,
                  controller: country,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'India',
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: const EdgeInsets.all(15),
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
                NormalText(color: Colors.black, text: "State"),
                SizedBox(height: 5.h),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedState,
                  items: states.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          )),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedState = newValue;
                      _selectedCity = null;
                      cities = locationSelection.cityNameList(newValue!);
                    });
                    _formKey.currentState!.validate();
                  },
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                        maxHeight: 70.h,
                        maxWidth: MediaQuery.of(context).size.width),
                    contentPadding: const EdgeInsets.all(15),
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
                  validator: (value) =>
                      value == null ? 'Please select a state' : null,
                ),
                SizedBox(height: 20.h),
                NormalText(color: Colors.black, text: "City"),
                SizedBox(height: 5.h),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  items: cities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                    _formKey.currentState!.validate();
                  },
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5.w,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a city' : null,
                ),
                SizedBox(height: 20.h),
                NormalText(color: Colors.black, text: "Pincode"),
                SizedBox(height: 5.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (pin) {
                    if (pin!.isEmpty) {
                      return "Please Enter Pincode";
                    } else if (pin.length < 6) {
                      return "Pincode must be 6 digits";
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: pincode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Restrict input to digits only
                  ],
                  maxLength: 6,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 75.h,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 0.5.w,
                      ),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                SizedBox(height: 20.h),
                // _isRegistering
                //     ? Center(child: CircularProgressIndicator())
                //     :
                InkWell(
                  onTap: () async {
                    print('submit button clicked');
                    if (_formKey.currentState!.validate()) {
                      // Collect data for the second screen
                      register1.add({
                        'address': address.text.toString(),
                        'country': country.text.toString(),
                        'state': _selectedState.toString(),
                        'city': _selectedCity.toString(),
                        'pincode': pincode.text.toString(),
                      });

                      try {
                        int mobileNumber = int.parse(widget.mobile);
                        // Call the function to send OTP
                        int otp = await sendSMS(mobileNumber);

                        if (otp != 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreens(
                                address: address.text.toString(),
                                country: country.text.toString(),
                                state: _selectedState.toString(),
                                city: _selectedCity.toString(),
                                pincode: pincode.text.toString(),
                                otp: otp, // Pass the OTP to the next screen
                                register: widget.register,
                                mobile:widget.mobile,
                                // register1: register1, // Pass additional data
                              ),
                            ),
                          );
                        } else {
                          // Handle OTP sending failure
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to send OTP')),
                          );
                        }
                      } catch (e) {
                        // Handle errors (e.g., invalid mobile number or network issues)
                        ScaffoldMessenger. of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },

                  // onTap: () async {
                  //   // int otp =
                  //   //     await sendSMS(int.parse(widget.register[0]['mobile']));
                  //   // if (otp != 0) {
                  //   //   // Within the `FirstRoute` widget:
                  //   //   Navigator.push(
                  //   //     context,
                  //   //     MaterialPageRoute(
                  //   //         builder: (context) => OtpScreens(
                  //   //               address: address.text.toString(),
                  //   //               country: country.text.toString(),
                  //   //               state: _selectedState.toString(),
                  //   //               city: _selectedCity.toString(),
                  //   //               pincode: pincode.text.toString(),
                  //   //             )),
                  //   //   );
                  //   // }
                  //
                  //   if (_formKey.currentState!.validate()) {
                  //     // register.add(
                  //     //   address.text.toString(),
                  //     //   country.text.toString(),
                  //     //   _selectedState.toString(),
                  //     //   _selectedCity.toString(),
                  //     //   pincode.text.toString(),
                  //     // );
                  //     register1.add({
                  //       address.text.toString(),
                  //         country.text.toString(),
                  //         _selectedState.toString(),
                  //         _selectedCity.toString(),
                  //         pincode.text.toString(),
                  //     });
                  //   }
                  //
                  //   print("this data from first screen in register list${register1}");
                  // },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: const Color(0xff140B40),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// void register(
//   String address,
//   String country,
//   String state,
//   String city,
//   String pincode,
// ) async {
//   setState(() {
//     _isRegistering = true;
//   });
//
//   try {
//     var payload = jsonEncode({
//       'address': address,
//       'city': city,
//       'pincode': int.parse(pincode),
//       'state': state,
//       'country': country,
//       'name': widget.register[0]["fullName"],
//       'email': widget.register[0]['email'],
//       'mobile': widget.register[0]['mobile'],
//       'gender': widget.register[0]['gender'],
//       'dob': widget.register[0]['dateOfBirth'],
//       'password': widget.register[0]['password'],
//       'confirm_password': widget.register[0]['confirm_password'],
//     });
//
//     final response = await http.post(
//       Uri.parse('https://batting-api-1.onrender.com/api/user/add_user'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'User-Agent': 'batting-app',
//       },
//       body: payload,
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Center(child: Text("Registration Successful"))),
//       );
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//       print("This is from if part: $data");
//     } else {
//       print(response.body.toString());
//       print("this print from else in api:::${payload}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Center(child: Text('Registration failed'))),
//       );
//     }
//   } catch (e) {
//     print("Exception caught: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//           content:
//               Center(child: Text('Please Check Your Internet Connection'))),
//     );
//   } finally {
//     setState(() {
//       _isRegistering = false;
//     });
//   }
// }
