import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../db/app_db.dart'; // Adjust import path based on your project structure
import '../model/AddWalletModel.dart'; // Adjust import path based on your project structure

class Depositescreen extends StatefulWidget {
  const Depositescreen({super.key});

  @override
  State<Depositescreen> createState() => _DepositescreenState();
}

class _DepositescreenState extends State<Depositescreen> {
  bool isLoading = true;
  AddWallateModlel? walletData;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      AddWallateModlel? data = await profileDisplay();
      setState(() {
        walletData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<AddWallateModlel?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/transaction/show'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final data = AddWallateModlel.fromJson(json.decode(response.body));
        debugPrint('Display wallet data: ${response.statusCode}');
        debugPrint("Response body: ${response.body}");
        return data;
      } else {
        debugPrint('Failed to fetch wallet data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching wallet data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xffF0F1F5),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : walletData == null
            ? const Center(child: Text("Failed to fetch data"))
            : _buildDepositsTab(),
      ),
    );
  }
  Widget _buildDepositsTab() {
    // Filter and reverse the list to show the latest transactions first
    var filteredData = walletData!.data
        .where((item) => item.paymentType == PaymentType.ADD_WALLET || item.paymentType == PaymentType.WINNING_AMOUNT)
        .toList()
        .reversed
        .toList();

    if (filteredData.isEmpty) {
      return const Center(child: Text("No deposits history"));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          var item = filteredData[index];
          return Column(
            children: [
              _buildTransactionCard(
                title: item.status.toString().split('.').last,
                subtitle: DateFormat.jm().format(item.createdAt),
                amount: "+ ₹${item.amount}",
                paymenttype: item.paymentType
                    .toString()
                    .split('.')
                    .last
                    .replaceAll('_', ' '), // Replace underscores with spaces
                date: DateFormat('dd-MM-yyyy').format(item.createdAt),
              ),
              if (index == filteredData.length - 1) // Check if it's the last item
                const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildDepositsTab() {
  //   // Filter and reverse the list to show latest transactions first
  //   var filteredData = walletData!.data
  //       .where((item) => item.paymentType == PaymentType.ADD_WALLET || item.paymentType == PaymentType.WINNING_AMOUNT)
  //       .toList()
  //       .reversed
  //       .toList();
  //
  //   if (filteredData.isEmpty) {
  //     return const Center(child: Text("No deposits history"));
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 3),
  //     child: ListView.builder(
  //       itemCount: filteredData.length,
  //       itemBuilder: (context, index) {
  //         var item = filteredData[index];
  //         return _buildTransactionCard(
  //           title: item.status.toString().split('.').last,
  //           subtitle: DateFormat.jm().format(item.createdAt),
  //           amount: "+ ₹${item.amount}",
  //           paymenttype: item.paymentType.toString().split('.').last.replaceAll('_', ' '), // Replace underscores with spaces
  //           date: DateFormat('dd-MM-yyyy').format(item.createdAt),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String amount,
    required String paymenttype,
    required String date,
  }) {
    const fallbackFont = 'Roboto'; // Define the fallback font here

    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1,
                        spreadRadius: 0,
                        offset: Offset(1.5, 2),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/deposit.webp',
                      height: 37,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10.5),
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xff140B40),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: fallbackFont,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                paymenttype,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import '../db/app_db.dart'; // Adjust import path based on your project structure
// import '../model/AddWalletModel.dart'; // Adjust import path based on your project structure
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// class Depositescreen extends StatefulWidget {
//   const Depositescreen({super.key});
//
//   @override
//   State<Depositescreen> createState() => _DepositescreenState();
// }
//
// class _DepositescreenState extends State<Depositescreen> {
//   bool isLoading = true;
//   AddWallateModlel? walletData;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWalletData();
//   }
//
//   Future<void> fetchWalletData() async {
//     try {
//       AddWallateModlel? data = await profileDisplay();
//       setState(() {
//         walletData = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<AddWallateModlel?> profileDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/transaction/show'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = AddWallateModlel.fromJson(json.decode(response.body));
//         debugPrint('Display wallet data: ${response.statusCode}');
//         debugPrint("Response body: ${response.body}");
//         return data;
//       } else {
//         debugPrint('Failed to fetch wallet data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching wallet data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: const Color(0xffF0F1F5),
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : walletData == null
//             ? const Center(child: Text("Failed to fetch data"))
//             : _buildDepositsTab(),
//       ),
//     );
//   }
//
//   Widget _buildDepositsTab() {
//     // Filter and reverse the list to show latest transactions first
//     var filteredData = walletData!.data
//         .where((item) => item.paymentType == PaymentType.ADD_WALLET)
//         .toList()
//         .reversed
//         .toList();
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 3),
//       child: ListView.builder(
//         itemCount: filteredData.length,
//         itemBuilder: (context, index) {
//           var item = filteredData[index];
//           return _buildTransactionCard(
//             title: item.status.toString().split('.').last,
//             subtitle: DateFormat.jm().format(item.createdAt),
//             amount: "+ ₹${item.amount}",
//             // paymenttype: item.paymentType.toString().split('.').last,
//             paymenttype: item.paymentType.toString().split('.').last.replaceAll('_', ' '), // Replace underscores with spaces
//             date: DateFormat('yyyy-MM-dd').format(item.createdAt),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTransactionCard({
//     required String title,
//     required String subtitle,
//     required String amount,
//     required String paymenttype,
//     required String date,
//   }) {
//     return Container(
//       height: 80.h,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 1,
//                         spreadRadius: 0,
//                         offset: Offset(1.5, 2),
//                       )
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.asset(
//                       'assets/deposit.webp',
//                       height: 37,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 5),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                   Text(
//                     date,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const SizedBox(height: 10.5),
//               Text(
//                 amount,
//                 style: TextStyle(
//                   color: const Color(0xff140B40),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 paymenttype,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 10,
//                 ),
//               ),
//             ],
//           ),
//         ],
//
//       ),
//     );
//   }
// }
//
//
//
//
// // children: [
// //   Row(
// //     children: [
// //       Container(
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: const [
// //             BoxShadow(
// //               color: Colors.grey,
// //               blurRadius: 1,
// //               spreadRadius: 0,
// //               offset: Offset(1.5, 2),
// //             )
// //           ],
// //         ),
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(20),
// //           child: Image.asset(
// //             'assets/deposit.webp',
// //             height: 37,
// //           ),
// //         ),
// //       ),
// //       const SizedBox(width: 10),
// //       Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(
// //               color: Colors.black,
// //               fontWeight: FontWeight.bold,
// //               fontSize: 15,
// //             ),
// //           ),
// //           // const SizedBox(height: 5),
// //           Text(
// //             subtitle,
// //             style: const TextStyle(
// //               color: Colors.grey,
// //               fontSize: 12,
// //             ),
// //           ),
// //           Text(
// //             date,
// //             style: const TextStyle(
// //               color: Colors.grey,
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),
// //   Column(
// //     crossAxisAlignment: CrossAxisAlignment.end,
// //     children: [
// //       Text(
// //         amount,
// //         style: const TextStyle(
// //           color: Color(0xff140B40),
// //           fontSize: 16,
// //           fontWeight: FontWeight.w600,
// //         ),
// //       ),
// //       const SizedBox(height: 5),
// //       Text(
// //         paymenttype,
// //         style: const TextStyle(
// //           color: Colors.grey,
// //           fontSize: 10,
// //         ),
// //       ),
// //     ],
// //   ),
// // ],