import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import 'appbartext.dart';
import 'normaltext.dart';

class AddWalletScreen extends StatelessWidget {
  AddWalletScreen({super.key, this.currentBalance});

  String? currentBalance;
  String selectedAmount = "";
  List amount = ["50", "100", "200", "500", "1000", "1500", "2000"];
  TextEditingController addbalance = TextEditingController();

  late BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    context = ctx;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          height: 610,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(28), topLeft: Radius.circular(28)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBarText(color: Colors.black, text: "Add Cash"),
              const SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              const SizedBox(
                height: 20,
              ),
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
                        Image.asset(
                          'assets/cash.png',
                          height: 16,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
              const SizedBox(
                height: 25,
              ),
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
                                addbalance.text =
                                    selectedAmount; // Set the text field value
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
                              child: Center(
                                child: Text("₹ ${amount[index]}"),
                              ),
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
                          controller: addbalance,
                          decoration: InputDecoration(
                              hintText: "Add Amount",
                              suffix: InkWell(
                                  onTap: () {
                                   // addbalance.clear();
                                  },
                                  child: const Icon(Icons.remove_circle,
                                      color: Colors.grey)),
                              hintStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                          "Add to Current Balance",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "₹ ${addbalance.text}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
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
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 67,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
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
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "PhonePe UPI Lite",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff6739B7)),
                                  ),
                                  Text(
                                    "Flat ₹10 Cashback",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6739B7)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 67,
                          width: 201,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                width: 1, color: const Color(0xffA8B0F7)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 67,
                                width: 60,
                                child: Image.asset(
                                  'assets/gbg.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Google Pay UPI",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffA8B0F7)),
                                  ),
                                  Text(
                                    "Flat ₹20 Cashback",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xffA8B0F7)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 67,
                          width: 201,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                width: 1, color: const Color(0xff333E47)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 67,
                                width: 60,
                                child: Image.asset(
                                  'assets/ppbg.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Amazon Pay UPI",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff333E47)),
                                  ),
                                  Text(
                                    "Flat ₹20 Cashback",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff333E47)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    String amountToAdd = addbalance.text;
                    if (double.tryParse(amountToAdd) != null) {
                      double amount = double.parse(amountToAdd);
                      if (amount <= 49) {
                        Fluttertoast.showToast(
                          msg: "Amount should be greater than 50",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                        print("Amount should be greater than 50");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text('Amount should be greater than 50'),
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          addwallet(amountToAdd);
                        });
                        Navigator.pop(context);
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
                        "Add",
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
        );
      },
    );
  }

  Future<void> addwallet(String addbalance) async {
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

      debugPrint('Token $token');
      var payload = jsonEncode({
        'amount': addbalance,
        'payment_mode': 'phonePe',
        'payment_type': 'add_wallet',
      });
      print("this is payload $payload");
      final response = await http.post(
        Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("this is from if part::$data");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Wallet Add Successfully')),
          ),
        );


          int currentBalanceValue = int.parse(currentBalance??'');
          int addedBalanceValue = int.parse(addbalance);
          currentBalanceValue += addedBalanceValue;
          currentBalance = currentBalanceValue.toString();


        AppDB.appDB.saveToken(data['data']['token']);
      } else {
        print("this is current balance from else::$currentBalance");
        print("this is current addbalance from else::$addbalance");
        print("this is from else::${response.body}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

}

