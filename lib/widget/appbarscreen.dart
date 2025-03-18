import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/WalletModel.dart';
import '../screens/walletScreen.dart';
import 'balance_notifire.dart';

class Appbarscreen extends StatefulWidget {
  final BalanceNotifier balanceNotifier;

  const Appbarscreen({super.key, required this.balanceNotifier});

  @override
  State<Appbarscreen> createState() => _AppbarscreenState();
}

class _AppbarscreenState extends State<Appbarscreen> {
  TextEditingController addbalance = TextEditingController();
  TextEditingController withdrawBalance = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAndSetWalletBalance();
  }

  Future<void> fetchAndSetWalletBalance() async {
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        WalletModel walletData = WalletModel.fromJson(jsonDecode(response.body));
        String newBalance = walletData.data.funds.toString() ?? "0";

        // Update the BalanceNotifier with the new balance
        widget.balanceNotifier.updateBalance(newBalance);
      } else {
        print('Failed to fetch wallet data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    // final balanceNotifier = Provider.of<BalanceNotifier>(context); // Access the BalanceNotifier here
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(95.h),
        child: ClipRRect(
          child: AppBar(
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff140B40), Color(0xff140B40)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          //height: 90.h,
                          width: 50.w,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/icon/logo.png"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Text("Cric",style: TextStyle(color: Colors.white,fontSize: 22,fontStyle: FontStyle.italic,),),

                        Text("Gem",style: TextStyle(color: HexColor("E6BE8A"),fontSize: 22,fontStyle: FontStyle.italic),),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(balanceNotifier: widget.balanceNotifier),
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
                            ValueListenableBuilder<String>(
                              valueListenable: widget.balanceNotifier,
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
                              onTap: () {},
                              child: Image.asset(
                                'assets/Plus (1).png',
                                height: 17.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:batting_app/MY_Screen/add_cash_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/WalletModel.dart';
// import '../screens/transactionhistory.dart';
// import '../screens/walletScreen.dart';
// import 'balance_notifire.dart';
//
// class Appbarscreen extends StatefulWidget {
//   final BalanceNotifier balanceNotifier;
//
//   const Appbarscreen({super.key, required this.balanceNotifier});
//
//   @override
//   State<Appbarscreen> createState() => _AppbarscreenState();
// }
//
// class _AppbarscreenState extends State<Appbarscreen> {
//   String currentBalance = "0";
//
//   String fundsUtilizedBalance = "0";
//   TextEditingController addbalance = TextEditingController();
//   TextEditingController withdrawBalance = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     walletDisplay();
//     currentBalance;
//   }
//
//   Future<WalletModel?> walletDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       if (response.statusCode == 200) {
//         // Return the WalletModel object
//         return WalletModel.fromJson(jsonDecode(response.body));
//       } else {
//         print('Failed to fetch wallet data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching wallet data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.h),
//         child: ClipRRect(
//           child: AppBar(
//             surfaceTintColor: const Color(0xffF0F1F5),
//             backgroundColor: const Color(0xffF0F1F5),
//             elevation: 0,
//             centerTitle: true,
//             flexibleSpace: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(top: 30.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 100.h,
//                       width: 140.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("assets/crictek_app_logo.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         // Within the `FirstRoute` widget:
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) =>  WalletScreen(balanceNotifier: balanceNotifier)),
//                           );
//
//                       },
//                       child:
//                       Container(
//                         height: 40.h,
//                         width: 145.w,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white.withOpacity(0.1),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/Vector.png',
//                               height: 17.h,
//                               color: Colors.white,
//                             ),
//                             SizedBox(width: 4.w),
//                             FutureBuilder<WalletModel?>(
//                               future: walletDisplay(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState == ConnectionState.waiting) {
//                                   return Text(
//                                     "₹$currentBalance", // Show the current balance while loading
//                                     overflow: TextOverflow.clip,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   );
//                                 } else if (snapshot.hasError) {
//                                   return const Center(child: Text('Error fetching data'));
//                                 } else if (!snapshot.hasData || snapshot.data == null) {
//                                   return const Center(child: Text('No data available'));
//                                 } else {
//                                   WalletModel walletData = snapshot.data!;
//                                   currentBalance = walletData.data?.funds.toString() ?? "0";
//                                   return Text(
//                                     "₹$currentBalance",
//                                     overflow: TextOverflow.clip,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                             SizedBox(width: 4.w),
//                             InkWell(
//                               onTap: () {},
//                               child: Image.asset(
//                                 'assets/Plus (1).png',
//                                 height: 17.h,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// Future<void> addwallet(String addbalance) async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Token is null.')),
//       );
//       return;
//     }
//
//     var payload = jsonEncode({
//       'amount': addbalance,
//       'payment_mode': 'phonePe',
//       'payment_type': 'add_wallet',
//     });
//
//     final response = await http.post(
//       Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
//       body: payload,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Center(child: Text('Wallet Add Successfully'))),
//       );
//
//       setState(() {
//         int currentBalanceValue = int.parse(currentBalance);
//         int addedBalanceValue = int.parse(addbalance);
//         currentBalanceValue += addedBalanceValue;
//         currentBalance = currentBalanceValue.toString();
//       });
//
//       AppDB.appDB.saveToken(data['data']['token']);
//     } else {
//       print("Error: ${response.body}");
//     }
//   } catch (e) {
//     print("Exception occurred: $e");
//   }
// }



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
// Future<WalletModel?> walletDisplay() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//     if (response.statusCode == 200) {
//       return WalletModel.fromJson(jsonDecode(response.body));
//     } else {
//       print('Failed to fetch wallet data: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching wallet data: $e');
//     return null;
//   }
// }



// Navigator.push(context, route)
// await showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(28),
//                 topLeft: Radius.circular(28),
//               ),
//               color: Colors.white,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 100.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomRight,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color(0xff1D1459).withOpacity(0.4),
//                         Color(0xff1D1459).withOpacity(0.1),
//                       ],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Current Balance"),
//                         FutureBuilder<WalletModel?>(
//                           future: walletDisplay(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return SizedBox(
//                                 height: 25.h,
//                                 width: 30.w,
//                                 child: Center(
//                                   child: Text('0', style: TextStyle(fontSize: 25.sp, color: Colors.black),),
//                                 ),
//                               );
//                             } else if (snapshot.hasError) {
//                               return const Center(child: Text('Error fetching data'));
//                             } else if (!snapshot.hasData || snapshot.data == null) {
//                               return const Center(child: Text('0'));
//                             } else {
//                               WalletModel walletData = snapshot.data!;
//                               currentBalance = walletData.data?.funds.toString() ?? "0";
//                               fundsUtilizedBalance = walletData.data?.fundsUtilized.toString() ?? "0";
//                               return Text(
//                                 '₹ $currentBalance',
//                                 style: TextStyle(
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Container(
//                   width: double.infinity,
//                   height: 61.h,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Unutilized Balance"),
//                             InkWell(
//                               onTap: () {},
//                               child: Icon(
//                                 Icons.info_outline_rounded,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           '₹ $fundsUtilizedBalance',
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Divider(),
//                 Container(
//                   width: double.infinity,
//                   height: 61.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text("Winnings"),
//                                 InkWell(
//                                   onTap: () {},
//                                   child: Icon(
//                                     Icons.info_outline_rounded,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               '₹ 0.00',
//                               style: TextStyle(
//                                 fontSize: 15.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AddCashScreen(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: 45.h,
//                             width: 110.w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Color(0xff1D1459),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Withdraw",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 16.sp,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                   },
//                   child: Container(
//                     height: 60.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             "My Transactions",
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                             },
//                             child: Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               size: 22,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 // Spacer(),
//                 // SizedBox(height: 55),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddCashScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 45.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Color(0xff1D1459),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Add Cash",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   },
// );




// Navigator.push(context, route)
// await showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(28),
//                 topLeft: Radius.circular(28),
//               ),
//               color: Colors.white,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 100.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomRight,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color(0xff1D1459).withOpacity(0.4),
//                         Color(0xff1D1459).withOpacity(0.1),
//                       ],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Current Balance"),
//                         FutureBuilder<WalletModel?>(
//                           future: walletDisplay(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return SizedBox(
//                                 height: 25.h,
//                                 width: 30.w,
//                                 child: Center(
//                                   child: Text('0', style: TextStyle(fontSize: 25.sp, color: Colors.black),),
//                                 ),
//                               );
//                             } else if (snapshot.hasError) {
//                               return const Center(child: Text('Error fetching data'));
//                             } else if (!snapshot.hasData || snapshot.data == null) {
//                               return const Center(child: Text('0'));
//                             } else {
//                               WalletModel walletData = snapshot.data!;
//                               currentBalance = walletData.data?.funds.toString() ?? "0";
//                               fundsUtilizedBalance = walletData.data?.fundsUtilized.toString() ?? "0";
//                               return Text(
//                                 '₹ $currentBalance',
//                                 style: TextStyle(
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Container(
//                   width: double.infinity,
//                   height: 61.h,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Unutilized Balance"),
//                             InkWell(
//                               onTap: () {},
//                               child: Icon(
//                                 Icons.info_outline_rounded,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           '₹ $fundsUtilizedBalance',
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Divider(),
//                 Container(
//                   width: double.infinity,
//                   height: 61.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text("Winnings"),
//                                 InkWell(
//                                   onTap: () {},
//                                   child: Icon(
//                                     Icons.info_outline_rounded,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               '₹ 0.00',
//                               style: TextStyle(
//                                 fontSize: 15.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AddCashScreen(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: 45.h,
//                             width: 110.w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Color(0xff1D1459),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Withdraw",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 16.sp,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                   },
//                   child: Container(
//                     height: 60.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             "My Transactions",
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                             },
//                             child: Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               size: 22,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 // Spacer(),
//                 // SizedBox(height: 55),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddCashScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 45.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Color(0xff1D1459),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Add Cash",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   },
// );

// import 'dart:convert';
//
// import 'package:batting_app/MY_Screen/add_cash_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/WalletModel.dart';
// import '../screens/transactionhistory.dart';
//
// class Appbarscreen extends StatefulWidget {
//   const Appbarscreen({super.key});
//
//   @override
//   State<Appbarscreen> createState() => _AppbarscreenState();
// }
//
// class _AppbarscreenState extends State<Appbarscreen> {
//   String currentBalance = "0";
//   String fundsUtilizedBalance = "0";
//   TextEditingController addbalance = TextEditingController();
//   TextEditingController withdrawBalance = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     walletDisplay();
//   }
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
//       var payload = jsonEncode({
//         'amount': addbalance,
//         'payment_mode': 'phonePe',
//         'payment_type': 'add_wallet',
//       });
//
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
//         print("Error: ${response.body}");
//       }
//     } catch (e) {
//       print("Exception occurred: $e");
//     }
//   }
//
//   Future<WalletModel?> walletDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/wallet/display'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//       if (response.statusCode == 200) {
//         return WalletModel.fromJson(jsonDecode(response.body));
//       } else {
//         print('Failed to fetch wallet data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching wallet data: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.h),
//         child: ClipRRect(
//           child: AppBar(
//             surfaceTintColor: const Color(0xffF0F1F5),
//             backgroundColor: const Color(0xffF0F1F5),
//             elevation: 0,
//             centerTitle: true,
//             flexibleSpace: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               height: 100.h,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(top: 30.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 100.h,
//                       width: 140.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("assets/crictek_app_logo.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         await showModalBottomSheet(
//                           context: context,
//                           builder: (context) {
//                             return StatefulBuilder(
//                               builder: (context, setState) {
//                                 return Container(
//                                   width: double.infinity,
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(28),
//                                       topLeft: Radius.circular(28),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         width: double.infinity,
//                                         height: 100.h,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(28),
//                                             topLeft: Radius.circular(28),
//                                           ),
//                                           gradient: LinearGradient(
//                                             begin: Alignment.bottomRight,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               Color(0xff1D1459).withOpacity(0.4),
//                                               Color(0xff1D1459).withOpacity(0.1),
//                                             ],
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Text("Current Balance"),
//                                               FutureBuilder<WalletModel?>(
//                                                 future: walletDisplay(),
//                                                 builder: (context, snapshot) {
//                                                   if (snapshot.connectionState == ConnectionState.waiting) {
//                                                     return SizedBox(
//                                                       height: 25.h,
//                                                       width: 30.w,
//                                                       child:  Center(
//                                                         child: Text('0', style: TextStyle(fontSize: 25.sp, color: Colors.black),)
//                                                       ),
//                                                     );
//                                                   } else if (snapshot.hasError) {
//                                                     return const Center(child: Text('Error fetching data'));
//                                                   } else if (!snapshot.hasData || snapshot.data == null) {
//                                                     return const Center(child: Text('0'));
//                                                   } else {
//                                                     WalletModel walletData = snapshot.data!;
//                                                     currentBalance = walletData.data?.funds.toString() ?? "0";
//                                                     fundsUtilizedBalance = walletData.data?.fundsUtilized.toString() ?? "0"; // Fetch utilized balance
//                                                     return Text(
//                                                       '₹ $currentBalance',
//                                                       style: TextStyle(
//                                                         fontSize: 20.sp,
//                                                         fontWeight: FontWeight.bold,
//                                                       ),
//                                                     );
//                                                   }
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: 5.h),
//                                       Container(
//                                         width: double.infinity,
//                                         height: 61.h,
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(28),
//                                             topLeft: Radius.circular(28),
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text("Unutilized Balance"),
//                                                   InkWell(
//                                                     onTap: () {},
//                                                     child: Icon(
//                                                       Icons.info_outline_rounded,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Text(
//                                                 '₹ $fundsUtilizedBalance',
//                                                 style: TextStyle(
//                                                   fontSize: 15.sp,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: 5.h),
//                                       Divider(),
//                                       Container(
//                                         width: double.infinity,
//                                         height: 61.h,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(28),
//                                             topLeft: Radius.circular(28),
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Text("Winnings"),
//                                                       InkWell(
//                                                         onTap: () {},
//                                                         child: Icon(
//                                                           Icons.info_outline_rounded,
//                                                           color: Colors.grey,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Text(
//                                                     '₹ 0.00',
//                                                     style: TextStyle(
//                                                       fontSize: 15.sp,
//                                                       fontWeight: FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               InkWell(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => AddCashScreen(),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   height: 45.h,
//                                                   width: 110.w,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(8),
//                                                     color: Color(0xff1D1459),
//                                                   ),
//                                                   child:  Center(
//                                                     child: Text(
//                                                       "Withdraw",
//                                                       style: TextStyle(
//                                                         fontWeight: FontWeight.w800,
//                                                         fontSize: 16.sp,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(),
//                                       GestureDetector(
//                                         onTap: (){
//                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                                         },
//                                         child: Container(
//                                           height: 60.h,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(),
//                                           child: Padding(
//                                             padding: EdgeInsets.symmetric(horizontal: 15.w),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   "My Transactions",
//                                                   style: TextStyle(
//                                                     fontSize: 15.sp,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: (){
//                                                     Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionHistory()));
//                                                   },
//                                                   child: Icon(
//                                                     Icons.arrow_forward_ios_outlined,
//                                                     size: 22,
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(),
//                                       // Spacer(),
//                                       SizedBox(height: 55),
//                                       Padding(
//                                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => AddCashScreen(),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             width: double.infinity,
//                                             height: 45.h,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               color: Color(0xff1D1459),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Add Cash",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 16.sp,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: 30),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                       child: Container(
//                         height: 40.h,
//                         width: 104.w,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white.withOpacity(0.1),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/Vector.png',
//                               height: 17.h,
//                               color: Colors.white,
//                             ),
//                             SizedBox(width: 4.w),
//                             FutureBuilder<WalletModel?>(
//                               future: walletDisplay(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState == ConnectionState.waiting) {
//                                   return SizedBox(
//                                     height: 22.h,
//                                     width: 22.w,
//                                     child:  Center(
//                                       child: Text('0', style: TextStyle(fontSize: 16.sp, color: Colors.white),)
//                                     ),
//                                   );
//                                 } else if (snapshot.hasError) {
//                                   return const Center(child: Text('Error fetching data'));
//                                 } else if (!snapshot.hasData || snapshot.data == null) {
//                                   return const Center(child: Text('No data available'));
//                                 } else {
//                                   WalletModel walletData = snapshot.data!;
//                                   currentBalance = walletData.data?.funds.toString() ?? "0";
//                                   return Text(
//                                     "₹$currentBalance",
//                                     overflow: TextOverflow.clip,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                             SizedBox(width: 4.w),
//                             InkWell(
//                               onTap: () {},
//                               child: Image.asset(
//                                 'assets/Plus (1).png',
//                                 height: 17.h,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }