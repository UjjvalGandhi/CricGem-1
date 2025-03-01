import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../db/app_db.dart';
import '../model/AddWalletModel.dart';

class Withdrawalsscreen extends StatefulWidget {
  const Withdrawalsscreen({super.key});

  @override
  State<Withdrawalsscreen> createState() => _WithdrawalsscreenState();
}

class _WithdrawalsscreenState extends State<Withdrawalsscreen> {
  bool isLoading = true;
  AddWallateModlel? walletData;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  // Future<void> fetchWalletData() async {
  //   try {
  //     AddWallateModlel? data = await profileDisplay();
  //     setState(() {
  //       walletData = data;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  Future<void> fetchWalletData() async {
    try {
      AddWallateModlel? data = await profileDisplay();

      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        walletData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Check again before calling setState
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
        var filteredData = data.data
            .where((item) => item.paymentType == PaymentType.WITHDRAW)
            .toList()
            .reversed
            .toList();
        debugPrint('Display wallet data: ${response.statusCode}');
        print(data.data[0].status);
        print('filterdata status:-${filteredData[0].status}');
        print('filterdata:-${filteredData[0].paymentType}');
        print('filterdata:-${filteredData[0].amount}');
        print('filterdata:-${filteredData[0].approval}');
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
  //       .where((item) => item.paymentType == PaymentType.WITHDRAW)
  //       .toList()
  //       .reversed
  //       .toList();
  //
  //   if (filteredData.isEmpty) {
  //     return const Center(child: Text("No withdrawal history"));
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
  //       },
  //     ),
  //   );
  // }
  Widget _buildWithdrawalsTab() {
    var filteredData = walletData!.data
        .where((item) => item.paymentType == PaymentType.WITHDRAW)
        .toList()
        .reversed
        .toList();

    if (filteredData.isEmpty) {
      return const Center(child: Text("No withdrawal history"));
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
              if (index ==
                  filteredData.length - 1) // Check if it's the last item
                const SizedBox(height: 15), // Add SizedBox after the last item
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



// children: [
//   Row(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.grey,
//               blurRadius: 1,
//               spreadRadius: 0,
//               offset: Offset(1.5, 2),
//             )
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Image.asset(
//             'assets/deposit.webp',
//             height: 37,
//           ),
//         ),
//       ),
//       const SizedBox(width: 10),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//           Text(
//             subtitle,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//           Text(
//             date,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     ],
//   ),
//   Column(
//     crossAxisAlignment: CrossAxisAlignment.end,
//     children: [
//       Text(
//         amount,
//         style: const TextStyle(
//           color: Color(0xff140B40),
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 5),
//       Text(
//         paymenttype,
//         style: const TextStyle(
//           color: Colors.grey,
//           fontSize: 10,
//         ),
//       ),
//     ],
//   ),
// ],