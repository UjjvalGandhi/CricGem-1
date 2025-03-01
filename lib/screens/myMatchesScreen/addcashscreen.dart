import 'package:batting_app/widget/big2text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widget/appbartext.dart';

class AddCashScreenFromWallet extends StatefulWidget {
  final String currentBalance;
  final Function(String) onAddCash;

  const AddCashScreenFromWallet({
    super.key,
    required this.currentBalance,
    required this.onAddCash,
  });

  @override
  _AddCashScreenFromWalletState createState() => _AddCashScreenFromWalletState();
}

class _AddCashScreenFromWalletState extends State<AddCashScreenFromWallet> {
  String selectedAmount = "";
  List<String> amountOptions = ["50", "100", "200", "500", "1000", "1500", "2000"];
  TextEditingController addBalanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(95.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff1D1459), Color(0xff140B40)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      AppBarText(color: Colors.white, text: "Add Cash"),
                      Container(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16), // Margin around the entire card
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Padding inside the card
            decoration: BoxDecoration(
              color: Colors.white, // Set card background color to white
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                // Current Balance
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Current Balance",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Big2Text(
                        color: Colors.black,
                        text: "₹${widget.currentBalance}",
                      ),
                      // Text(
                      //   "₹${widget.currentBalance}",
                      //   style: const TextStyle(fontWeight: FontWeight.w600),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Amount Options
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: amountOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAmount = amountOptions[index];
                            addBalanceController.text = selectedAmount;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text("₹ ${amountOptions[index]}"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Input Amount
                TextField(
                  controller: addBalanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Add Amount",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        addBalanceController.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Add Button
                ElevatedButton(
                  onPressed: () {
                    String amountToAdd = addBalanceController.text;
                    if (double.tryParse(amountToAdd) != null) {
                      double amount = double.parse(amountToAdd);
                      if (amount <= 49) {
                        Fluttertoast.showToast(
                          msg: "Amount should be greater than 50",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } else {
                        widget.onAddCash(amountToAdd); // Call the function to add cash
                        Navigator.pop(context); // Close the screen
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid amount",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.06), // Adjust height
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    backgroundColor: const Color(0xff140B40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 1, color: Colors.grey.shade300), // Border color and width
                    ),
                    elevation: 0, // Removes shadow to match the container style
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Adjust font color
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
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
//
// import '../../widget/appbartext.dart';
//
// class AddCashScreenFromWallet extends StatefulWidget {
//   final String currentBalance;
//   final Function(String) onAddCash;
//
//   const AddCashScreenFromWallet({
//     Key? key,
//     required this.currentBalance,
//     required this.onAddCash,
//   }) : super(key: key);
//
//   @override
//   _AddCashScreenFromWalletState createState() => _AddCashScreenFromWalletState();
// }
//
// class _AddCashScreenFromWalletState extends State<AddCashScreenFromWallet> {
//   String selectedAmount = "";
//   List<String> amountOptions = ["50", "100", "200", "500", "1000", "1500", "2000"];
//   TextEditingController addBalanceController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70.0),
//         child: ClipRRect(
//           child: AppBar(
//             leading: Container(),
//             surfaceTintColor: const Color(0xffF0F1F5),
//             backgroundColor: const Color(0xffF0F1F5),
//             elevation: 0,
//             centerTitle: true,
//             flexibleSpace: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               height: 100,
//               width: MediaQuery.of(context).size.width,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xff1D1459), Color(0xff140B40)],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 50),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                         ),
//                       ),
//                       AppBarText(color: Colors.white, text: "Add Cash"),
//                       Container(
//                         width: 20,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             children: [
//               // Current Balance
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Current Balance",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "₹${widget.currentBalance}",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Amount Options
//               Container(
//                 height: 50,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: amountOptions.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedAmount = amountOptions[index];
//                           addBalanceController.text = selectedAmount;
//                         });
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(right: 10),
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Center(
//                           child: Text("₹ ${amountOptions[index]}"),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Input Amount
//               TextField(
//                 controller: addBalanceController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: "Add Amount",
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       addBalanceController.clear();
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Add Button
//               ElevatedButton(
//                 onPressed: () {
//                   String amountToAdd = addBalanceController.text;
//                   if (double.tryParse(amountToAdd) != null) {
//                     double amount = double.parse(amountToAdd);
//                     if (amount <= 49) {
//                       Fluttertoast.showToast(
//                         msg: "Amount should be greater than 50",
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                       );
//                     } else {
//                       widget.onAddCash(amountToAdd); // Call the function to add cash
//                       Navigator.pop(context); // Close the screen
//                     }
//                   } else {
//                     Fluttertoast.showToast(
//                       msg: "Invalid amount",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.06), // Adjust height
//                   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
//                   backgroundColor: Color(0xff140B40),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(width: 1, color: Colors.grey.shade300), // Border color and width
//                   ),
//                   elevation: 0, // Removes shadow to match the container style
//                 ),
//                 child: Text(
//                   "Add",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white, // Adjust font color
//                   ),
//                 ),
//               ),
//
//               // ElevatedButton(
//               //   onPressed: () {
//               //     String amountToAdd = addBalanceController.text;
//               //     if (double.tryParse(amountToAdd) != null) {
//               //       double amount = double.parse(amountToAdd);
//               //       if (amount <= 49) {
//               //         Fluttertoast.showToast(
//               //           msg: "Amount should be greater than 50",
//               //           toastLength: Toast.LENGTH_SHORT,
//               //           gravity: ToastGravity.BOTTOM,
//               //         );
//               //       } else {
//               //         widget.onAddCash(amountToAdd); // Call the function to add cash
//               //         Navigator.pop(context); // Close the screen
//               //       }
//               //     } else {
//               //       Fluttertoast.showToast(
//               //         msg: "Invalid amount",
//               //         toastLength: Toast.LENGTH_SHORT,
//               //         gravity: ToastGravity.BOTTOM,
//               //       );
//               //     }
//               //   },
//               //   child: Text("Add"),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }