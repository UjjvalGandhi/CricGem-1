import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class AddCashScreen extends StatefulWidget {
  const AddCashScreen({super.key});

  @override
  State<AddCashScreen> createState() => _AddCashScreenState();
}

class _AddCashScreenState extends State<AddCashScreen> {
  List<String> amount = ["1", "50", "100", "200", "500", "1000", "1500", "2000"];
  String selectedAmount = "";
  TextEditingController addBalanceController = TextEditingController();
  String environment = "PRODUCTION";
  String appId = ""; // Add your app ID here
  String merchantId = "M22TYL06SCE61"; // Add your merchant ID here
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool enableLogging = true;
  late String checksum;
  String saltKey = "aa6f3137-1163-40da-aef6-558e86ee6450"; // Add your salt key here
  String saltIndex = "1";
  String callBackUrl = "https://your-callback-url.com";
  late String body;
  String apiEndPoint = "/pg/v1/pay";
  Object? result;

  String getChecksum(String amount) {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "MUID123",
      "amount": int.parse(amount) * 100, // Convert to paise
      "callbackUrl": callBackUrl,
      "mobileNumber": "9999999999",
      "paymentInstrument": {
        "type": "UPI_INTENT",
        "targetApp": "com.phonepe.app"
      }
    };
    String base64body = base64.encode(utf8.encode(json.encode(requestData)));
    checksum = "${sha256.convert(utf8.encode(base64body + apiEndPoint + saltKey)).toString()} + ### + $saltIndex";
    return base64body;
  }

  @override
  void initState() {
    super.initState();
    phonepeInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: const Color(0xff1D1459),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          "Add Cash",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Center(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: addBalanceController,
                  decoration: const InputDecoration(
                      hintText: "Add Amount",
                      hintStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: amount.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 50,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount[index];
                          addBalanceController.text = selectedAmount;
                        });
                      },
                      child: Center(
                        child: Text("₹ ${amount[index]}"),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                startPgTransaction();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xff1D1459)),
                child: const Center(
                  child: Text(
                    "Add Cash",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
        print(result);
      });
    }).catchError((error) {
      handleError(error);
    });
  }

  void startPgTransaction() async {
    final amount = addBalanceController.text;
    if (amount.isEmpty || int.tryParse(amount) == null || int.parse(amount) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid amount");
      return;
    }

    body = getChecksum(amount);
    print("Request Body: $body");
    print("Checksum: $checksum");
    print("Callback URL: $callBackUrl");

    try {
      final response = await PhonePePaymentSdk.startTransaction(
        body,
        callBackUrl,
        checksum,
        "",
      );

      if (response != null) {
        print("Response: $response");
        if (response.containsKey('error')) {
          String error = response['error'];
          result = "Flow Completed - Error: $error";
        } else if (response.containsKey('status')) {
          String status = response['status'];
          if (status == 'SUCCESS') {
            result = "Flow Completed - Status: Success!";
            await checkStatus();
          } else {
            result = "Flow Completed - Status: $status";
          }
        } else {
          result = "Unexpected Response Structure";
        }
      } else {
        result = "Flow Incomplete";
      }
    } catch (error) {
      handleError(error);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void handleError(error) {
    print("Error: $error");
    setState(() {
      result = {"error": error};
    });
    Fluttertoast.showToast(msg: "Error: $error");
  }

  Future<void> checkStatus() async {
    String url = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
    String concatString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
    var bytes = utf8.encode(concatString);
    var digest = sha256.convert(bytes).toString();
    String xVerify = "$digest###$saltIndex";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-VERIFY": xVerify,
      "X-MERCHANT-ID": merchantId
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final res = jsonDecode(response.body);
     // print("Resp mhie: $res");
      if (res["success"] == true &&
          res["code"] == "PAYMENT_SUCCESS" &&
          res["data"]["state"] == "COMPLETED") {
        print("Success Response: $res");
        Fluttertoast.showToast(msg: res['message']);
      } else {
        print("Failure Response: $res");
        Fluttertoast.showToast(msg:"Something went wrong");
      }
    } catch (error) {
      print("Error in checkStatus: $error");
      Fluttertoast.showToast(msg: "Error in checkStatus: $error");
    }
  }
}
