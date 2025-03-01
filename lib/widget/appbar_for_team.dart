import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../screens/walletScreen.dart';
import 'balance_notifire.dart'; // Import Provider

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final BalanceNotifier balanceNotifier;

    // Access BalanceNotifier from the Provider
    balanceNotifier = Provider.of<BalanceNotifier>(context);
    String balance = balanceNotifier.balance; // Use the balance getter

    return
      AppBar(
      elevation: 0,
      leading: InkWell(
        onTap: onBackPressed,
        child: Icon(
          Icons.keyboard_backspace,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 20.sp)),
          Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletScreen(balanceNotifier: balanceNotifier),
                ),
              );
            },
            child: Container(
              height: 40.h,
              width: 145.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Image.asset(
                      'assets/Vector.png',
                      height: 17.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // Text(
                  //   "₹$balance",
                  //   overflow: TextOverflow.clip,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  ValueListenableBuilder<String>(
                    valueListenable: balanceNotifier,
                    builder: (context, balance, child) {
                      return Text(
                        "₹$balance",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {
                      // Handle the tap event for adding money to wallet
                    },
                    child: Image.asset(
                      'assets/Plus (1).png',
                      height: 17.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff140B40), Color(0xff140B40)],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(95.0.h);
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import 'balance_notifire.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final String subtitle;
//   final VoidCallback onBackPressed;
//   final Future<String?> Function() fetchWalletBalance;
//
//   const CustomAppBar({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.onBackPressed,
//     required this.fetchWalletBalance,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final balanceNotifier = Provider.of<BalanceNotifier>(context);
//     String balance = balanceNotifier.balance; // Get the current balance
//
//     return AppBar(
//       elevation: 0,
//       leading: InkWell(
//         onTap: onBackPressed,
//         child: Icon(
//           Icons.keyboard_backspace,
//           color: Colors.white,
//           size: 30.sp,
//         ),
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(title, style: TextStyle(color: Colors.white, fontSize: 20.sp)),
//           Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
//         ],
//       ),
//       actions: [
//         FutureBuilder<String?>(
//           future: fetchWalletBalance(),
//           builder: (context, snapshot) {
//             String balance = snapshot.data ?? "0";
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal:
//                       4.w),
//               child:
//               Container(
//                 height: 40.h,
//                 width: 145.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white.withOpacity(0.1),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/Vector.png',
//                       height: 17.h,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: 4.w),
//                 Text(
//                         "₹$balance",
//                   overflow: TextOverflow.clip,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                         // style: TextStyle(color: Colors.white, fontSize: 16.sp,fontWeight: FontWeight.w600),
//                       ),
//                     SizedBox(width: 4.w),
//                     InkWell(
//                       onTap: () {},
//                       child: Image.asset(
//                         'assets/Plus (1).png',
//                         height: 17.h,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//       flexibleSpace: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff1D1459), Color(0xff140B40)],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(63.0);
// }
//

// Row(
//   children: [
//     Text(
//       "₹$balance",
//       style: TextStyle(color: Colors.white, fontSize: 16.sp),
//     ),
//     SizedBox(width: 8.w),
//     Icon(Icons.account_balance_wallet, color: Colors.white, size: 20.sp),
//   ],
// ),


// FutureBuilder<WalletModel?>(
//   future: walletDisplay(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return SizedBox(
//         height: 28.h,
//         width: 28.w,
//         child: Center(
//           child: Text('0', style: TextStyle(fontSize: 16.sp, color: Colors.white),),
//         ),
//       );
//     } else if (snapshot.hasError) {
//       return const Center(child: Text('Error fetching data'));
//     } else if (!snapshot.hasData || snapshot.data == null) {
//       return const Center(child: Text('No data available'));
//     } else {
//       WalletModel walletData = snapshot.data!;
//       currentBalance = walletData.data?.funds.toString() ?? "0";
//       return Text(
//         "₹$currentBalance",
//         overflow: TextOverflow.clip,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       );
//     }
//   },
// ),


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../model/WalletModel.dart';
//
// class CustomAppBar extends StatelessWidget {
//   final String matchName;
//   final Future<WalletModel?> walletFuture;
//
//   const CustomAppBar({
//     Key? key,
//     required this.matchName,
//     required this.walletFuture,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       leading: InkWell(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Icon(
//           Icons.keyboard_backspace,
//           color: Colors.white,
//           size: 30.sp,
//         ),
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             matchName,
//             style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
//           ),
//           FutureBuilder<WalletModel?>(
//             future: walletFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Text("Loading...", style: TextStyle(color: Colors.white));
//               } else if (snapshot.hasError) {
//                 return Text("Error loading balance", style: TextStyle(color: Colors.white));
//               } else if (snapshot.hasData) {
//                 final walletData = snapshot.data;
//                 final currentBalance = walletData?.data?.funds.toString() ?? "0";
//                 return Text("₹$currentBalance", style: TextStyle(color: Colors.white));
//               } else {
//                 return Text("No data available", style: TextStyle(color: Colors.white));
//               }
//             },
//           ),
//         ],
//       ),
//       actions: [
//         SizedBox(width: 10.w),
//       ],
//       flexibleSpace: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
//         height: 120.h,
//         width: MediaQuery.of(context).size.width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xff1D1459), Color(0xff140B40)],
//           ),
//         ),
//       ),
//     );
//   }
// }