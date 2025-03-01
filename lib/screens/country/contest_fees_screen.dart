// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import "package:http/http.dart" as http;
// import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:fluttertoast/fluttertoast.dart';
// import '../../db/app_db.dart';
// import '../../model/AddWalletModel.dart';
//
// class ContestFeesScreen extends StatefulWidget {
//   const ContestFeesScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ContestFeesScreen> createState() => _ContestFeesScreenState();
// }
//
// class _ContestFeesScreenState extends State<ContestFeesScreen> {
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
//   Future<void> _downloadPDF() async {
//     if (walletData == null || walletData!.data.isEmpty) {
//       Fluttertoast.showToast(
//         msg: "No data available to download.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black54,
//         textColor: Colors.white,
//         fontSize: 14.0,
//       );
//       return;
//     }
//
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('Contest Fees', style: pw.TextStyle(fontSize: 24)),
//               pw.SizedBox(height: 20),
//               for (var item in walletData!.data
//                   .where((item) => item.paymentType == PaymentType.CONTEST_FEE))
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text(item.status.toString().split('.').last),
//                     pw.Text("- ₹${item.amount}"),
//                     pw.Text(DateFormat('yyyy-MM-dd').format(item.createdAt)),
//                   ],
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//
//     // Get the directory to save the PDF
//     Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
//     DateTime now = DateTime.now();
//     String formattedDate = "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}";
//     final file = File("${downloadsDirectory.path}/Contest_Fees_$formattedDate.pdf");
//     await file.writeAsBytes(await pdf.save());
//
//     Fluttertoast.showToast(
//       msg: "PDF downloaded to ${file.path}",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.black54,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
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
//             : _buildContestTab(),
//       ),
//     );
//   }
//
//   Widget _buildContestTab() {
//     var filteredData = walletData!.data
//         .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//         .toList()
//         .reversed
//         .toList();
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 3),
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _downloadPDF,
//             child: const Text("Download Contest Data as PDF"),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredData.length,
//               itemBuilder: (context, index) {
//                 var item = filteredData[index];
//                 return _buildTransactionCard(
//                   title: item.status.toString().split('.').last,
//                   subtitle: DateFormat.jm().format(item.createdAt),
//                   amount: "- ₹${item.amount}",
//                   paymenttype: item.paymentType.toString().split('.').last.replaceAll('_', ' '),
//                   date: DateFormat('yyyy-MM-dd').format(item.createdAt),
//                 );
//               },
//             ),
//           ),
//         ],
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
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 5),
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
//               SizedBox(height: 10.5),
//               Text(
//                 amount,
//                 style: const TextStyle(
//                   color: Color(0xff140B40),
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
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../db/app_db.dart';
import '../../model/AddWalletModel.dart';

class ContestFeesScreen extends StatefulWidget {
  const ContestFeesScreen({super.key});

  @override
  State<ContestFeesScreen> createState() => _ContestFeesScreenState();
}

class _ContestFeesScreenState extends State<ContestFeesScreen> {
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
        print("Response body: ${response.body}");
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
            : _buildWithdrawalsTab(),
      ),
    );
  }

  // Widget _buildWithdrawalsTab() {
  //   var filteredData = walletData!.data
  //       .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
  //       .toList()
  //       .reversed
  //       .toList();
  //
  //   if (filteredData.isEmpty) {
  //     return const Center(child: Text("No contest history"));
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
  //           amount: "- ₹${item.amount}",
  //           paymenttype: item.paymentType.toString().split('.').last.replaceAll('_', ' '), // Replace underscores with spaces
  //           // paymenttype: item.paymentType.toString().split('.').last,
  //           date: DateFormat('dd-MM-yyyy').format(item.createdAt),
  //         );
  //
  //       },
  //     ),
  //   );
  // }
  Widget _buildWithdrawalsTab() {
    var filteredData = walletData!.data
        .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
        .toList()
        .reversed
        .toList();

    if (filteredData.isEmpty) {
      return const Center(child: Text("No contest history"));
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
                amount: "- ₹${item.amount}",
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


  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String amount,
    required String paymenttype,
    required String date,
  }) {
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
