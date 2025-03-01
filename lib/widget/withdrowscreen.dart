import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import 'appbartext.dart';
import 'normaltext.dart';

class Withdrowscreen extends StatefulWidget {
  const Withdrowscreen({super.key});

  @override
  State<Withdrowscreen> createState() => _WithdrowscreenState();
}

class _WithdrowscreenState extends State<Withdrowscreen> {
  @override
  Widget build(BuildContext context) {
    String currentBalance = "0";
    String selectedAmount = "";
    List amount = ["50", "100", "200", "500", "1000", "1500", "2000"];
    List Wamount = ["50", "100", "200", "500", "1000", "1500", "2000"];
    TextEditingController withdrawBalance = TextEditingController();
    Future<void> withdrawWallet(String addbalance) async {
      try {
        String? token = await AppDB.appDB.getToken();
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token is null.'),
            ),
          );
          return;
        }

        var payload = jsonEncode({
          'amount': addbalance,
          'payment_mode': 'phonePe',
          'payment_type': 'add_wallet',
        });

        final response = await http.post(
          Uri.parse("https://batting-api-1.onrender.com/api/wallet/withdraw"),
          body: payload,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": token,
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          if (data != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('Wallet Add Successfully')),
              ),
            );

            setState(() {
              // Update state based on successful response
            });

            AppDB.appDB.saveToken(data['data']['token']);
          } else {
            print("Received null data from API");
          }
        } else {
          print("API request failed with status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("Exception occurred: $e");
      }
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        height: 600,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(28), topLeft: Radius.circular(28)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            AppBarText(color: Colors.black, text: "Withdraw Cash"),
            const SizedBox(height: 10),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/cash.png', height: 16),
                      const SizedBox(width: 10),
                      const Text(
                        "Current Balance",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "₹$currentBalance",
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ListView.builder(
                      itemCount: amount.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedAmount = amount[index];
                              withdrawBalance.text = amount[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 50,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child:
                            Center(child: Text("₹ ${Wamount[index]}")),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2.6,
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: withdrawBalance,
                        decoration: InputDecoration(
                          hintText: "Withdraw Amount",
                          suffix: InkWell(
                            onTap: () {
                              withdrawBalance.clear();
                            },
                            child: const Icon(Icons.remove_circle,
                                color: Colors.grey),
                          ),
                          hintStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Withdraw to Current Balance",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "₹ ${withdrawBalance.text}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(color: Colors.grey, text: "Payment Partners"),
                Row(
                  children: [
                    NormalText(color: Colors.grey, text: "View All"),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 67,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                1, // You might want to change this based on actual data
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      // Example of a payment partner widget
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 67,
                        width: 201,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 1, color: const Color(0xff6739B7)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 67,
                              width: 60,
                              child: Image.asset(
                                'assets/paybg.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "PhonePe UPI Lite",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff6739B7),
                                  ),
                                ),
                                Text(
                                  "Flat ₹10 Cashback",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff6739B7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Add more payment partner widgets here as needed
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  String amountToAdd = withdrawBalance.text.trim();
                  if (double.tryParse(amountToAdd) != null) {
                    double amount = double.parse(amountToAdd);
                    if (amount < 200) {
                      Fluttertoast.showToast(
                        msg: "Minimum withdrawal amount is ₹200",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                      print("Minimum withdrawal amount is 200");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child:
                            Text('Minimum withdrawal amount is ₹200'),
                          ),
                        ),
                      );
                    } else {
                      withdrawWallet(amountToAdd);
                      Navigator.pop(
                          context); // Close the screen after withdrawal
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid amount'),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xff140B40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Withdraw",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
