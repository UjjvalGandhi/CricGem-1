import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/app_db.dart';
import '../widget/appbar_for_setting.dart';

class WriteToUsScreen extends StatefulWidget {
  const WriteToUsScreen({super.key});

  @override
  State<WriteToUsScreen> createState() => _WriteToUsScreenState();
}

class _WriteToUsScreenState extends State<WriteToUsScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<void> writeToUs(String title, String description) async {
    print('sending the inquiry');
    try {
      print('sending the inquiry 11111111111111111111');
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      var payload = jsonEncode({
        'title': title,
        'description': description,
      });

      final response = await http.post(
        Uri.parse('https://batting-api-1.onrender.com/api/write_to_us/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": '$token',
          // 'User -Agent': 'batting-app',
        },
        body: payload,
      );

      print("Request payload: $payload");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('sending the inquiry 2222222222222222222222');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquiry is submitted")),
        );
        Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HelpAndSupport(),
        //   ),
        //   ModalRoute.withName('/WritetoUs'), // Retain routes with this name
        // );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
      } else {
        print('sending the inquiry 3333333333333333333333');

        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data['message']}")),
        );
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please check your internet connection")),
      );
    } catch (e) {
      print('sending the inquiry 44444444444444444444444444444');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       leading: Container(),
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      //         height: 90.h,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             SizedBox(height: 50.h),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: Icon(
      //                     Icons.arrow_back,
      //                     color: Colors.white,
      //                     size: 24.sp,
      //                   ),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "Write to Us"),
      //                 SizedBox(width: 20.w),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
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
      //
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
      //                   Navigator.pop(context);
      //                 },
      //                 child: const Icon(
      //                   Icons.arrow_back,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               AppBarText(color: Colors.white, text: "Write to Us"),
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
        title: "Write to us",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: Container(
        color: const Color(0xffF0F1F5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Title',
                  style: TextStyle(fontSize: 15.h, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              _buildTextField(title),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 15.h, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                  height: 120, child: _buildTextField(description, maxLine: 4)),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            if (title.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter the title")),
              );
            } else if (description.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter the description")),
              );
            } else {
              writeToUs(
                title.text,
                description.text,
              );
              setState(() {
                title.clear();
                description.clear();
              });
              Fluttertoast.showToast(
                msg: "Inquiry submitted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 14.0,
              );
            }
          },
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width * 0.85.w,
            decoration: BoxDecoration(
              color: const Color(0xff140B40),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 1),
                  //   child: Image.asset(
                  //     'assets/whatsup.png',
                  //     height: 18.h,
                  //   ),
                  // ),
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
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int? maxLength,
    int? maxLine}) {
  return Container(
    height: 44,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade400, width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: null,
      expands: true,
      // Allows the text field to expand vertically
      decoration: const InputDecoration(
        // contentPadding: EdgeInsets.only(bottom: 5, left: 10, top: 10), // Padding for the text inside the field
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // Adjusted padding for better appearance
        // contentPadding: EdgeInsets.only(bottom: 5, left: 10),
        border: InputBorder.none,
        counterText: "",
      ),
    ),
  );
}



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

// onTap: (){
//   if(title.text.isEmpty) {
//     if (description.text.isEmpty) {
//       newPass(
//         title.text,
//         description.text,
//       );
//       Fluttertoast.showToast(
//         msg: "Click on Submit",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black54,
//         textColor: Colors.white,
//         fontSize: 14.0,
//       );
//     }else{
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter the title")),
//       );
//     }
//   }else{
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please enter the description")),
//     );
//   }
// },