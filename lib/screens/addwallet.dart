// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart'as http;
// import '../db/app_db.dart';
// import '../widget/appbartext.dart';
// import '../widget/normaltext.dart';
//
// class Addwallet extends StatefulWidget {
//   const Addwallet({super.key});
//
//   @override
//   State<Addwallet> createState() => _AddwalletState();
// }
//
// class _AddwalletState extends State<Addwallet> {
//   String currentBalance = "0";
//   String selectedAmount = "";
//   List amount = ["50", "100", "200", "500", "1000", "1500", "2000"];
//   TextEditingController addbalance = TextEditingController();
//
//   Future<void> addwallet(String addbalance) async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Token is null.'),
//           ),
//         );
//         return;
//       }
//
//       debugPrint('Token $token');
//       var payload = jsonEncode({
//         'amount': addbalance,
//         'payment_mode': 'phonePe',
//         'payment_type': 'add_wallet',
//       });
//       print("this is payload $payload");
//       final response = await http.post(
//         Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
//         body: payload,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body.toString());
//         print("this is from if part::$data");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Center(child: Text('Wallet Add Successfully')),
//           ),
//         );
//
//         setState(() {
//           int currentBalanceValue = int.parse(currentBalance);
//           int addedBalanceValue = int.parse(addbalance);
//           currentBalanceValue += addedBalanceValue;
//           currentBalance = currentBalanceValue.toString();
//         });
//
//         AppDB.appDB.saveToken(data['data']['token']);
//       } else {
//         print("this is current balance from else::$currentBalance");
//         print("this is current addbalance from else::$addbalance");
//         print("this is from else::${response.body}");
//       }
//     } catch (e) {
//       print("Exception occurred: $e");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:SingleChildScrollView(
//         child:
//       )
//
//     );
//   }
// }
