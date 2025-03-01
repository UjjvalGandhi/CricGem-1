import 'dart:convert';
import 'package:batting_app/services/get_server_key.dart';
import 'package:batting_app/services/send_notification_service.dart';
import 'package:batting_app/widget/balance_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/app_db.dart';
import '../model/WalletModel.dart';
import '../widget/appbar_for_setting.dart';
import '../widget/appbartext.dart';
import '../widget/big2text.dart';
import '../widget/normaltext.dart';
import '../widget/notification_service.dart';
import '../widget/notificationprovider.dart';
import '../widget/smalltext.dart';
import 'documents_upload.dart';
import 'invitefriend.dart';
import 'transactionhistory.dart';

class WalletScreen extends StatefulWidget {
  final BalanceNotifier? balanceNotifier;

  const WalletScreen({super.key, required this.balanceNotifier});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isHintVisible = true;
  String currentBalance = "0";
  double difference = 0.0; // Variable to hold the difference
  String selectedAmount = "";
  bool isProcessing = false;
  String fundsUtilizedBalance = "0";
  List<String> amount = ["50", "100", "200", "500", "1000", "1500", "2000"];
  TextEditingController addbalance = TextEditingController();
  ValueNotifier<String> amountNotifier = ValueNotifier<String>("");
  TextEditingController withdrawBalance = TextEditingController();
  final TextEditingController addBalanceController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController scrollController = TextEditingController();

  WalletModel? walletData; // Store wallet data here
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchWalletData(); // Fetch wallet data on initialization
    addBalanceController.addListener(() {
      setState(() {
        isHintVisible = addBalanceController.text.isEmpty;
      });
    });
  }

  Future<void> fetchWalletData() async {
    walletData = await walletDisplay();
    if (walletData?.data != null) {
      currentBalance = walletData!.data.funds.toString();
    }
    setState(() {
      isLoading = false; // Update loading state
    });
  }

  Future<void> withdrawWallet(String addbalance, String upiId) async {
    try {
      String? token = await AppDB.appDB.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token is null.')),
        );
        return;
      }

      var payload = jsonEncode({
        'amount': addbalance,
        'UPI_ID': upiId,
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
                content: Center(child: Text('Withdraw Amount Successfully'))),
          );
          final notificationProvider =
              Provider.of<NotificationProvider>(context, listen: false);
          await notificationProvider.fetchNotifications();


          // Notification for cash withdrawal

          final prefs = await SharedPreferences.getInstance();

          // prefs.getString('token');

          print('token hiiiiii:- ${prefs.getString('token')}');

          print("✅ Money withdraw successfully. Sending notification...");

          try {
            // Construct notification body with both amounts

            String notificationBody =
                "  rupees withdraw successfully.";


            await SendNotificationService.sendNotifcationUsingApi(
              title: "Cash Withdraw",
              body: notificationBody,
              token: "${prefs.getString('fcm_token')}",
              data: {"screen": "walletScreen"},
            );

            print("✅ Notification sent successfully.");
          } catch (e) {
            print("❌ Error sending notification: $e");
          }

          // Check if notifications are available
          if (notificationProvider.notifications.isNotEmpty) {
            final notification = notificationProvider.notifications.last;

            // Show notification using NotificationService
            NotificationService().showNotification(
              title: notification['title'] ?? 'No Title',
              body: notification['message'] ?? 'No Message',
              payload: '/walletScreen',
            );
          } else {
            // Show fallback notification if no notifications are available
            NotificationService().showNotification(
              title: 'Withdrawal cash request initalized',
              body: 'Your Withdrawal request...........!',
              payload: '/walletScreen',
            );
          }
          setState(() {
            int currentBalanceValue = int.parse(currentBalance);
            int addedBalanceValue = int.parse(addbalance);
            int newBalance = currentBalanceValue - addedBalanceValue;
            currentBalance = newBalance.toString();
            widget.balanceNotifier!.updateBalance(newBalance.toString());
          });

          AppDB.appDB.saveToken(data['data']['token']);
        } else {
          debugPrint("Received null data from API");
        }
      } else {
        debugPrint(
            "API request failed with status code: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Center(child: Text('Please verify your documents first'))),
          );
        }
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
    }
  }

  // Future<void> addwallet(String addbalance) async {
  //   setState(() {
  //     isProcessing = true; // Start processing
  //   });
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     if (token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Token is null.')),
  //       );
  //       return;
  //     }
  //
  //     var payload = json.encode({
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
  //         "Authorization": token,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body.toString());
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Center(child: Text('Wallet Add Successfully'))),
  //       );
  //       final notificationProvider =
  //           Provider.of<NotificationProvider>(context, listen: false);
  //       await notificationProvider.fetchNotifications();
  //
  //       // Check if notifications are available
  //       // if (notificationProvider.notifications.isNotEmpty) {
  //       //   final notification = notificationProvider.notifications.last;
  //       //
  //       //   // Show notification using NotificationService
  //       //   NotificationService().showNotification(
  //       //     title: notification['title'] ?? 'No Title',
  //       //     body: notification['message'] ?? 'No Message',
  //       //   );
  //       //   Provider.of<NotificationService>(context, listen: false).showNotification(
  //       //     title: notification['title'] ?? 'No Title',
  //       //     body: notification['message'] ?? 'No Message',
  //       //   );
  //       // } else {
  //       //   // Show fallback notification if no notifications are available
  //       //   NotificationService().showNotification(
  //       //     title: 'Adding cash request initalized',
  //       //     body: 'Your add request...........!',
  //       //   );
  //       // }
  //       setState(() {
  //         int currentBalanceValue = int.parse(currentBalance);
  //         int addedBalanceValue = int.parse(addbalance);
  //         int newBalance = currentBalanceValue + addedBalanceValue;
  //         currentBalance = newBalance.toString();
  //         widget.balanceNotifier!.updateBalance(newBalance.toString());
  //       });
  //       AppDB.appDB.saveToken(data['data']['token']);
  //       setState(() {
  //         isProcessing = false; // Stop processing
  //       });
  //     } else {
  //       print("Error: ${response.body}");
  //       setState(() {
  //         isProcessing = false; // Stop processing
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception occurred: $e");
  //     setState(() {
  //       isProcessing = false; // Stop processing
  //     });
  //   }
  // }

  // Future<bool> addwallet(String addbalance) async {
  //   setState(() {
  //     isProcessing = true; // Start processing
  //   });
  //
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     if (token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Token is null.')),
  //       );
  //       return false; // Return false when token is null
  //     }
  //
  //     var payload = json.encode({
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
  //         "Authorization": token,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body.toString());
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Center(child: Text('Wallet Add Successfully')),
  //         ),
  //       );
  //
  //       final notificationProvider =
  //       Provider.of<NotificationProvider>(context, listen: false);
  //       await notificationProvider.fetchNotifications();
  //
  //       // ✅ Update balance
  //       setState(() {
  //         int currentBalanceValue = int.parse(currentBalance);
  //         int addedBalanceValue = int.parse(addbalance);
  //         int newBalance = currentBalanceValue + addedBalanceValue;
  //         currentBalance = newBalance.toString();
  //         widget.balanceNotifier!.updateBalance(newBalance.toString());
  //       });
  //
  //       // Save token if needed
  //       AppDB.appDB.saveToken(data['data']['token']);
  //
  //       setState(() {
  //         isProcessing = false; // Stop processing
  //       });
  //
  //       return true; // ✅ Return true when successful
  //     } else {
  //       print("Error: ${response.body}");
  //
  //       setState(() {
  //         isProcessing = false; // Stop processing
  //       });
  //
  //       return false; // ❌ Return false when API call fails
  //     }
  //   } catch (e) {
  //     print("Exception occurred: $e");
  //
  //     setState(() {
  //       isProcessing = false; // Stop processing
  //     });
  //
  //     return false; // ❌ Return false when exception occurs
  //   }
  // }
  Future<bool> addwallet(String addbalance) async {
    try {
      // ✅ Print the amount before using it
      print("🔹 Attempting to add money: $addbalance");

      String? token = await AppDB.appDB.getToken();
      print("🔹 Token received: $token");

      if (token == null) {
        print("❌ Error: Token is null.");
        Fluttertoast.showToast(msg: "Authentication failed. Please login again.");
        return false;
      }

      var payload = json.encode({
        'amount': addbalance,
        'payment_mode': 'phonePe',
        'payment_type': 'add_wallet',
      });

      print("📤 Sending API request with payload: $payload");

      final response = await http.post(
        Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": token,
        },
      );

      print("📨 Response Status Code: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ Debug API Response
        print("🔹 API Response: $data");
        setState(() {
                  int currentBalanceValue = int.parse(currentBalance);
                  int addedBalanceValue = int.parse(addbalance);
                  int newBalance = currentBalanceValue + addedBalanceValue;
                  currentBalance = newBalance.toString();
                  widget.balanceNotifier!.updateBalance(newBalance.toString());
                });

        if (data['success'] == true) {
          print("✅ Wallet updated successfully!");
          return true;
        } else {
          print("❌ API Error Message: ${data['message']}");
          Fluttertoast.showToast(msg: data['message'] ?? "Failed to add money.");
          return false;
        }
      } else {
        print("❌ API Call Failed: ${response.statusCode}");
        Fluttertoast.showToast(msg: "Failed to add money. Please try again.");
        return false;
      }
    } catch (e) {
      print("❌ Exception in addwallet: $e");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
      return false;
    }
  }


  Future<WalletModel?> walletDisplay() async {
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
        debugPrint("Response Body: ${response.body}");
        return WalletModel.fromJson(jsonDecode(response.body));
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
  void dispose() {
    addbalance.dispose();
    amountNotifier.dispose();
    addBalanceController.dispose();
    withdrawBalance.dispose();
    upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       leading: Container(),
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       elevation: 0,
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //         height: 120,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff1D1459), Color(0xff140B40)],
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             const SizedBox(height: 50),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 InkWell(
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: const Icon(
      //                     Icons.arrow_back,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //                 AppBarText(color: Colors.white, text: "Wallet"),
      //                 Container(
      //                   width: 20,
      //                 )
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(67.h),
      //   child: ClipRRect(
      //     child: AppBar(
      //       surfaceTintColor: const Color(0xffF0F1F5),
      //       backgroundColor: const Color(0xffF0F1F5),
      //       leading: null,
      //       automaticallyImplyLeading: false,
      //       elevation: 0,
      //       centerTitle: true,
      //       flexibleSpace: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w),
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //             colors: [Color(0xff140B40), Color(0xff140B40)],
      //               // Color(0xff1D1459)
      //           ),
      //         ),
      //         child: Padding(
      //           padding: EdgeInsets.only(top: 30.h),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               InkWell(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: const Icon(
      //                   Icons.arrow_back,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               Align(
      //                 alignment: Alignment.center,
      //                   child: AppBarText(color: Colors.white, text: "Wallet")),
      //               Container(
      //                 width:30,
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(
        title: "Wallet",
        onBackButtonPressed: () {
          // Custom behavior for back button (if needed)
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : walletData != null
              ? buildWalletContent(walletData!)
              : const Center(child: Text('No data available')),
    );
  }

  Widget buildWalletContent(WalletModel walletData) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xffF0F1F5),
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 3),
              height: 126,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallText(color: Colors.black, text: "Balance"),
                      Big2Text(
                        color: Colors.black,
                        text: "₹$currentBalance",
                      ),
                      InkWell(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setModalState) {
                                  double screenHeight =
                                      MediaQuery.of(context).size.height;

                                  // Get the height of the keyboard
                                  // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                                  double keyboardHeight =
                                      MediaQuery.of(context).viewInsets.bottom *
                                          2.5;

                                  // Calculate the available height for the bottom sheet
                                  double availableHeight =
                                      screenHeight + keyboardHeight;

                                  // final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

                                  // setModalState(){
                                  //
                                  // }
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        // vertical: isKeyboardOpen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height/1,
                                      ),
                                      // height: MediaQuery.of(context).size.height /1.42,
                                      // width: MediaQuery.of(context).size.width,
                                      // constraints: BoxConstraints(
                                      //   maxHeight: MediaQuery.of(
                                      //               context)
                                      //           .size
                                      //           .height *
                                      //       0.90, // Limit the height
                                      // ),
                                      // height: availableHeight / 2.30, // Adjust height based on available space
                                      height: availableHeight * 0.42,
                                      constraints: BoxConstraints(
                                        maxHeight: availableHeight *
                                            0.99, // Limit the height
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(28),
                                          topLeft: Radius.circular(28),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppBarText(
                                              color: Colors.black,
                                              text: "Add Cash"),
                                          Divider(
                                              height: 1,
                                              color: Colors.grey.shade200),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/cash.png',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                    Text(
                                                      "Current Balance",
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const Icon(Icons
                                                        .keyboard_arrow_down),
                                                  ],
                                                ),
                                                Text(
                                                  "₹$currentBalance",
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: ListView.builder(
                                                    itemCount: amount.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setModalState(() {
                                                            // Use setModalState here
                                                            selectedAmount =
                                                                amount[index];
                                                            addbalance.text =
                                                                selectedAmount; // Update the text field
                                                          });
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          margin:
                                                              EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "₹ ${amount[index]}",
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: addbalance,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText: "Add Amount",
                                                      hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              top: 12.5,
                                                              right: 0,
                                                              bottom:
                                                                  0), // Only add padding to the top
                                                      suffixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 4.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            addbalance.clear();
                                                          },
                                                          child: const Icon(
                                                            Icons.remove_circle,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                    ),
                                                    maxLines: 1,
                                                    onChanged: (value) {
                                                      setModalState(() {
                                                        // Check if the input starts with '0'
                                                        if (value.isNotEmpty &&
                                                            value[0] == '0') {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Amount cannot start with 0",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff140B40),
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 14.0,
                                                          );
                                                          addbalance.clear();
                                                        }

                                                        // Check if the amount exceeds 1,00,000
                                                        if (value.isNotEmpty &&
                                                            int.tryParse(
                                                                    value) !=
                                                                null) {
                                                          int enteredAmount =
                                                              int.parse(value);
                                                          if (enteredAmount >
                                                              100000) {
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Amount cannot exceed ₹1,00,000",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xff140B40),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                            );
                                                            // Reset the value to ₹1,00,000
                                                            addbalance.text =
                                                                "100000";
                                                            addbalance
                                                                    .selection =
                                                                TextSelection
                                                                    .fromPosition(
                                                              TextPosition(
                                                                  offset:
                                                                      addbalance
                                                                          .text
                                                                          .length),
                                                            );
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),

                                                // Expanded(
                                                //   child: TextFormField(keyboardType:TextInputType.number,
                                                //     controller:addbalance,
                                                //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                //     decoration: InputDecoration(
                                                //       hintText: "Add Amount",
                                                //       hintStyle:TextStyle(fontSize: MediaQuery.of(context).size.width *0.035,),
                                                //       contentPadding: const EdgeInsets.only(left: 0, top: 12.5, right: 0, bottom: 0), // Only add padding to the top
                                                //       suffixIcon: Padding(
                                                //         padding: const EdgeInsets.only(bottom: 4.0),
                                                //         child: InkWell(
                                                //           onTap: () {
                                                //             addbalance.clear();
                                                //           },
                                                //           child: const Icon(
                                                //             Icons.remove_circle,
                                                //             color: Colors.grey,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       border:InputBorder.none,
                                                //       // contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                                                //     ),
                                                //     style: TextStyle(
                                                //       fontSize: MediaQuery.of(
                                                //                   context)
                                                //               .size
                                                //               .width *
                                                //           0.035,
                                                //     ),
                                                //     maxLines: 1,
                                                //     onChanged: (value) {
                                                //       setModalState(() {
                                                //         if (value.isNotEmpty && value[0] == '0') {
                                                //           // If it starts with '0', show a message or reset the field
                                                //           // ScaffoldMessenger.of(context).showSnackBar(
                                                //           //   const SnackBar(
                                                //           //     content: Center(
                                                //           //         child: Text(
                                                //           //             'Amount cannot start with 0')),
                                                //           //   ),
                                                //           // );
                                                //           Fluttertoast.showToast(
                                                //             msg: "Amount cannot start with 0",
                                                //             toastLength: Toast.LENGTH_SHORT,
                                                //             gravity: ToastGravity.BOTTOM,
                                                //             timeInSecForIosWeb: 1,
                                                //             backgroundColor: const Color(0xff140B40),
                                                //             textColor: Colors.white,
                                                //             fontSize: 14.0,
                                                //           );
                                                //           // Optionally, you can clear the field or modify the input
                                                //           addbalance.clear();
                                                //         }
                                                //         // Update any state if necessary
                                                //       });
                                                //     },
                                                //   ),
                                                // ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "₹ ${addbalance.text}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03),

                                      GestureDetector(
                                        onTap: () async {
                                          // Get server key
                                          GetServerKey getServerKey = GetServerKey();
                                          String accesstoken = await getServerKey.getServerKeyToken();
                                          print('Serverkey: $accesstoken');

                                          // Show loading indicator
                                          EasyLoading.show(status: 'loading...');

                                          // Validate amount input
                                          String amountToAdd = addbalance.text;
                                          if (amountToAdd.isEmpty || double.tryParse(amountToAdd) == null) {
                                            Fluttertoast.showToast(
                                              msg: "Please enter a valid amount",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: const Color(0xff140B40),
                                              textColor: Colors.white,
                                            );
                                            setModalState(() {
                                              isProcessing = false;
                                              selectedAmount = '0';
                                            });
                                            EasyLoading.dismiss();
                                            return;
                                          }

                                          double amount = double.parse(amountToAdd);
                                          if (amount <= 49) {
                                            Fluttertoast.showToast(
                                              msg: "Amount should be greater than 50",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: const Color(0xff140B40),
                                              textColor: Colors.white,
                                            );
                                            setModalState(() {
                                              selectedAmount = '0';
                                              isProcessing = false;
                                            });
                                            EasyLoading.dismiss();
                                            return;
                                          } else if (amount > 100000) {
                                            Fluttertoast.showToast(
                                              msg: "Amount should be lesser than 100000",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: const Color(0xff140B40),
                                              textColor: Colors.white,
                                            );
                                            setModalState(() {
                                              selectedAmount = '0';
                                              isProcessing = false;
                                            });
                                            EasyLoading.dismiss();
                                            return;
                                          }

                                          // Set processing state
                                          setModalState(() {
                                            isProcessing = true;
                                          });

                                          // Proceed with adding money
                                          bool success = await addwallet(amountToAdd);

                                          // If money added successfully, send the notification
                                          if (success) {
                                            setModalState(() {
                                              isProcessing = false;
                                            });

                                            final prefs = await SharedPreferences.getInstance();

                                            // prefs.getString('token');

                                            print('token hiiiiii:- ${prefs.getString('token')}');

                                            print("✅ Money added successfully. Sending notification...");

                                            try {
                                              // Construct notification body with both amounts

                                              String notificationBody =
                                                  " $amountToAdd rupees added successfully.";


                                              await SendNotificationService.sendNotifcationUsingApi(
                                                title: "Cash Added",
                                                body: notificationBody,
                                                token: "${prefs.getString('fcm_token')}",
                                                data: {"screen": "walletScreen"},
                                              );

                                              print("✅ Notification sent successfully.");
                                            } catch (e) {
                                              print("❌ Error sending notification: $e");
                                            }

                                            EasyLoading.dismiss();
                                            Navigator.pop(context);
                                            selectedAmount = '0';
                                          } else {
                                            print("❌ Money was not added. Skipping notification.");
                                            setModalState(() {
                                              isProcessing = false;
                                              selectedAmount = '0';
                                            });
                                            EasyLoading.dismiss();
                                          }
                                        },
                                        child: Container(
                                          height: 45,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff140B40),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: isProcessing
                                                ? const CircularProgressIndicator(color: Colors.white) // Show loader when processing
                                                : Text(
                                              "Add",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // GestureDetector(
                                          //   onTap: () async {
                                          //     // Get server key
                                          //     GetServerKey getServerKey = GetServerKey();
                                          //     String accesstoken = await getServerKey.getServerKeyToken();
                                          //     print('Serverkey: $accesstoken');
                                          //
                                          //     // Show loading indicator
                                          //     EasyLoading.show(status: 'loading...');
                                          //
                                          //     // Validate amount input
                                          //     String amountToAdd = addbalance.text;
                                          //     if (amountToAdd.isEmpty || double.tryParse(amountToAdd) == null) {
                                          //       Fluttertoast.showToast(
                                          //         msg: "Please enter a valid amount",
                                          //         toastLength: Toast.LENGTH_SHORT,
                                          //         gravity: ToastGravity.BOTTOM,
                                          //         backgroundColor: const Color(0xff140B40),
                                          //         textColor: Colors.white,
                                          //       );
                                          //       setModalState(() {
                                          //         isProcessing = false;
                                          //         selectedAmount = '0';
                                          //       });
                                          //       EasyLoading.dismiss();
                                          //       return;
                                          //     }
                                          //
                                          //     double amount = double.parse(amountToAdd);
                                          //     if (amount <= 49) {
                                          //       Fluttertoast.showToast(
                                          //         msg: "Amount should be greater than 50",
                                          //         toastLength: Toast.LENGTH_SHORT,
                                          //         gravity: ToastGravity.BOTTOM,
                                          //         backgroundColor: const Color(0xff140B40),
                                          //         textColor: Colors.white,
                                          //       );
                                          //       setModalState(() {
                                          //         selectedAmount = '0';
                                          //         isProcessing = false;
                                          //       });
                                          //       EasyLoading.dismiss();
                                          //       return;
                                          //     } else if (amount > 100000) {
                                          //       Fluttertoast.showToast(
                                          //         msg: "Amount should be lesser than 100000",
                                          //         toastLength: Toast.LENGTH_SHORT,
                                          //         gravity: ToastGravity.BOTTOM,
                                          //         backgroundColor: const Color(0xff140B40),
                                          //         textColor: Colors.white,
                                          //       );
                                          //       setModalState(() {
                                          //         selectedAmount = '0';
                                          //         isProcessing = false;
                                          //       });
                                          //       EasyLoading.dismiss();
                                          //       return;
                                          //     }
                                          //
                                          //     // Set processing state
                                          //     setModalState(() {
                                          //       isProcessing = true;
                                          //     });
                                          //
                                          //     // Proceed with adding money
                                          //     bool success = await addwallet(amountToAdd);
                                          //
                                          //     // If money added successfully, send the notification
                                          //     if (success) {
                                          //       setModalState(() {
                                          //         isProcessing = false;
                                          //       });
                                          //
                                          //       print("✅ Money added successfully. Sending notification...");
                                          //
                                          //       try {
                                          //         await SendNotificationService.sendNotifcationUsingApi(
                                          //           title: "Cash Added",
                                          //           body: "$selectedAmount rupees added successfully",
                                          //           token: "eqryGFdvSi2Ui-5qkTUlA_:APA91bHx-KuB7Hgr2XpE5dDZ8Upk67mxV_uHBZcTZL8YbUN-lY1hVBHbMvN3TPvetim0rlvAMcuyxTpWxCaJR3vmTwRPmSq47Uxxjvnxlbwcyjxxwvu9k4M",
                                          //           data: {"screen": "walletScreen"},
                                          //         );
                                          //
                                          //         print("✅ Notification sent successfully.");
                                          //       } catch (e) {
                                          //         print("❌ Error sending notification: $e");
                                          //       }
                                          //
                                          //       EasyLoading.dismiss();
                                          //       Navigator.pop(context);
                                          //       selectedAmount = '0';
                                          //     } else {
                                          //       print("❌ Money was not added. Skipping notification.");
                                          //       setModalState(() {
                                          //         isProcessing = false;
                                          //         selectedAmount = '0';
                                          //       });
                                          //       EasyLoading.dismiss();
                                          //     }
                                          //
                                          //   },
                                          //   child: Container(
                                          //     height: 45,
                                          //     width: MediaQuery.of(context).size.width,
                                          //     decoration: BoxDecoration(
                                          //       color: const Color(0xff140B40),
                                          //       borderRadius: BorderRadius.circular(10),
                                          //     ),
                                          //     child: Center(
                                          //       child: isProcessing
                                          //           ? const CircularProgressIndicator(
                                          //           color: Colors.white) // Show loader when processing
                                          //           : Text(
                                          //         "Add",
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: MediaQuery.of(context).size.width * 0.04,
                                          //           color: Colors.white,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )

                                          // GestureDetector(
                                          //     onTap: () async {
                                          //       // Get server key
                                          //       GetServerKey getServerKey = GetServerKey();
                                          //       String accesstoken = await getServerKey.getServerKeyToken();
                                          //       print('Serverkey: $accesstoken');
                                          //
                                          //       setModalState(() {
                                          //         isProcessing = true; // Show loader
                                          //       });
                                          //
                                          //       String amountToAdd = addbalance.text;
                                          //
                                          //       if (amountToAdd.isEmpty || double.tryParse(amountToAdd) == null) {
                                          //         Fluttertoast.showToast(
                                          //           msg: "Please enter a valid amount",
                                          //           toastLength: Toast.LENGTH_SHORT,
                                          //           gravity: ToastGravity.BOTTOM,
                                          //           backgroundColor: const Color(0xff140B40),
                                          //           textColor: Colors.white,
                                          //         );
                                          //         setModalState(() {
                                          //           isProcessing = false;
                                          //           selectedAmount = '0';
                                          //         });
                                          //         return;
                                          //       }
                                          //
                                          //       double amount = double.parse(amountToAdd);
                                          //       if (amount <= 49) {
                                          //         Fluttertoast.showToast(
                                          //           msg: "Amount should be greater than 50",
                                          //           toastLength: Toast.LENGTH_SHORT,
                                          //           gravity: ToastGravity.BOTTOM,
                                          //           backgroundColor: const Color(0xff140B40),
                                          //           textColor: Colors.white,
                                          //         );
                                          //         setModalState(() {
                                          //           isProcessing = false;
                                          //           selectedAmount = '0';
                                          //         });
                                          //         return;
                                          //       } else if (amount > 100000) {
                                          //         Fluttertoast.showToast(
                                          //           msg: "Amount should be lesser than 100000",
                                          //           toastLength: Toast.LENGTH_SHORT,
                                          //           gravity: ToastGravity.BOTTOM,
                                          //           backgroundColor: const Color(0xff140B40),
                                          //           textColor: Colors.white,
                                          //         );
                                          //         setModalState(() {
                                          //           isProcessing = false;
                                          //           selectedAmount = '0';
                                          //         });
                                          //         return;
                                          //       }
                                          //
                                          //       // ✅ Proceed with adding money
                                          //       bool success = await addwallet(amountToAdd);
                                          //
                                          //       // If adding money was successful, send the notification
                                          //       if (success) {
                                          //         setModalState(() {
                                          //           isProcessing = false; // Stop loader
                                          //         });
                                          //
                                          //         // ✅ Send Notification after successful money addition
                                          //         EasyLoading.show(status: 'Sending notification...');
                                          //         await SendNotificationService.sendNotifcationUsingApi(
                                          //           title: "Cash Added",
                                          //           body: "Money added successfully",
                                          //           token: "ex2WT_L2SkGUsqW4kKqntl:APA91bESrtI686RBfgTCHxdy9ZZl-Ush13cU2VtVPwrLU3gld15X8rzY-U0DqnA5QBivD72nYY4XIQSwCP4C_zsqStT1ncdTefl1htSB3fG0M5XEdZ-meG8",
                                          //           data: {"screen": "walletScreen"},
                                          //         );
                                          //         EasyLoading.dismiss();
                                          //
                                          //         Navigator.pop(context);
                                          //         selectedAmount = '0';
                                          //       } else {
                                          //         // If money addition failed, show an error message and do NOT send a notification
                                          //         setModalState(() {
                                          //           isProcessing = false;
                                          //           selectedAmount = '0';
                                          //         });
                                          //         Fluttertoast.showToast(
                                          //           msg: "Failed to add money. Try again.",
                                          //           toastLength: Toast.LENGTH_SHORT,
                                          //           gravity: ToastGravity.BOTTOM,
                                          //           backgroundColor: Colors.red,
                                          //           textColor: Colors.white,
                                          //         );
                                          //       }
                                          //     }
                                          //
                                          // )
                                          // GestureDetector(
                                          //   onTap: () async {
                                          //
                                          //     //get server key
                                          //     GetServerKey getServerKey = GetServerKey();
                                          //     String accesstoken =
                                          //         await getServerKey
                                          //             .getServerKeyToken();
                                          //     print('Serverkey: $accesstoken');
                                          //
                                          //     //Send Notification using api
                                          //
                                          //     EasyLoading.show(status: 'loading...');
                                          //     SendNotificationService .sendNotifcationUsingApi(
                                          //         title: "Cash Addded",
                                          //         body: "Money added successfully",
                                          //         token: "ex2WT_L2SkGUsqW4kKqntl:APA91bESrtI686RBfgTCHxdy9ZZl-Ush13cU2VtVPwrLU3gld15X8rzY-U0DqnA5QBivD72nYY4XIQSwCP4C_zsqStT1ncdTefl1htSB3fG0M5XEdZ-meG8",
                                          //         data: {
                                          //           "screen" : "walletScreen"
                                          //         }
                                          //     );
                                          //     EasyLoading.dismiss();
                                          //
                                          //     // if (isProcessing) return;
                                          //     setModalState(() {
                                          //       isProcessing =
                                          //           true; // Set processing state
                                          //     });
                                          //     String amountToAdd =
                                          //         addbalance.text;
                                          //     if (amountToAdd.isEmpty ||
                                          //         double.tryParse(
                                          //                 amountToAdd) ==
                                          //             null) {
                                          //       Fluttertoast.showToast(
                                          //         msg:
                                          //             "Please enter a valid amount",
                                          //         toastLength:
                                          //             Toast.LENGTH_SHORT,
                                          //         gravity: ToastGravity.BOTTOM,
                                          //         timeInSecForIosWeb: 1,
                                          //         backgroundColor:
                                          //             const Color(0xff140B40),
                                          //         textColor: Colors.white,
                                          //         fontSize: 14.0,
                                          //       );
                                          //       // ScaffoldMessenger.of(context).showSnackBar(
                                          //       //   const SnackBar(
                                          //       //     content: Center(
                                          //       //         child: Text(
                                          //       //             "Please enter a valid number")),
                                          //       //   ),
                                          //       // );
                                          //       setModalState(() {
                                          //         isProcessing = false;
                                          //         selectedAmount =
                                          //             '0'; // Reset processing state
                                          //       });
                                          //       return; //  // Exit the function if validation fails
                                          //     }
                                          //
                                          //     if (double.tryParse(
                                          //             amountToAdd) !=
                                          //         null) {
                                          //       double amount =
                                          //           double.parse(amountToAdd);
                                          //       if (amount <= 49) {
                                          //         Fluttertoast.showToast(
                                          //           msg:
                                          //               "Amount should be greater than 50",
                                          //           toastLength:
                                          //               Toast.LENGTH_SHORT,
                                          //           gravity:
                                          //               ToastGravity.BOTTOM,
                                          //           timeInSecForIosWeb: 1,
                                          //           backgroundColor:
                                          //               const Color(0xff140B40),
                                          //           textColor: Colors.white,
                                          //           fontSize: 14.0,
                                          //         );
                                          //         // ScaffoldMessenger.of(context).showSnackBar(
                                          //         //   const SnackBar(
                                          //         //     content: Center(
                                          //         //         child: Text(
                                          //         //             "Amount should be greater than 50")),
                                          //         //   ),
                                          //         // );
                                          //         setModalState(() {
                                          //           selectedAmount = '0';
                                          //           isProcessing =
                                          //               false; // Reset processing state
                                          //         });
                                          //       } else if (amount > 100000) {
                                          //         Fluttertoast.showToast(
                                          //           msg:
                                          //               "Amount should be lesser than 100000",
                                          //           toastLength:
                                          //               Toast.LENGTH_SHORT,
                                          //           gravity:
                                          //               ToastGravity.BOTTOM,
                                          //           timeInSecForIosWeb: 1,
                                          //           backgroundColor:
                                          //               const Color(0xff140B40),
                                          //           textColor: Colors.white,
                                          //           fontSize: 14.0,
                                          //         );
                                          //         // ScaffoldMessenger.of(context).showSnackBar(
                                          //         //   const SnackBar(
                                          //         //     content: Center(
                                          //         //         child: Text(
                                          //         //             "Amount should be greater than 50")),
                                          //         //   ),
                                          //         // );
                                          //         setModalState(() {
                                          //           selectedAmount = '0';
                                          //           isProcessing =
                                          //               false; // Reset processing state
                                          //         });
                                          //       } else {
                                          //         // setState(() {
                                          //         //   isProcessing =
                                          //         //       true; // Set processing state
                                          //         // });
                                          //         await addwallet(amountToAdd);
                                          //         setModalState(() {
                                          //           isProcessing =
                                          //               false; // Stop processing after the API call
                                          //         });
                                          //         Navigator.pop(context);
                                          //         selectedAmount = '0';
                                          //       }
                                          //     } else {
                                          //       selectedAmount = '0';
                                          //       ScaffoldMessenger.of(context)
                                          //           .showSnackBar(
                                          //         const SnackBar(
                                          //           content:
                                          //               Text('Invalid amount'),
                                          //         ),
                                          //       );
                                          //       setModalState(() {
                                          //         isProcessing =
                                          //             false; // Reset processing state
                                          //       });
                                          //     }
                                          //   },
                                          //   child: Container(
                                          //     height: 45,
                                          //     width: MediaQuery.of(context)
                                          //         .size
                                          //         .width,
                                          //     decoration: BoxDecoration(
                                          //       color: const Color(0xff140B40),
                                          //       borderRadius:
                                          //           BorderRadius.circular(10),
                                          //     ),
                                          //     child: Center(
                                          //       child: isProcessing
                                          //           ? const CircularProgressIndicator(
                                          //               color: Colors
                                          //                   .white) // Show loader
                                          //           : Text(
                                          //               "Add",
                                          //               style: TextStyle(
                                          //                 fontWeight:
                                          //                     FontWeight.w500,
                                          //                 fontSize: MediaQuery.of(context).size.width * 0.04,
                                          //                 color: Colors.white,
                                          //               ),
                                          //             ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color(0xff140B40).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xff140B40).withOpacity(0.3),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Add Cash",
                              style: TextStyle(
                                color: Color(0xff140B40),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallText(color: Colors.black, text: "Winnings"),
                      Big2Text(
                        color: Colors.black,
                        text: "₹${walletData.data.winnings.toString()}",
                      ),
                      InkWell(
                        onTap: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setModelState) {
                                  // double screenHeight = MediaQuery.of(context).size.height *1.3;
                                  double screenHeight =
                                      MediaQuery.of(context).size.height * 1.1;

                                  // Get the height of the keyboard
                                  double keyboardHeight =
                                      MediaQuery.of(context).viewInsets.bottom *
                                          2;

                                  // Calculate the available height for the bottom sheet
                                  double availableHeight =
                                      screenHeight + keyboardHeight;
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      height: availableHeight * 0.5,
                                      constraints: BoxConstraints(
                                        maxHeight: availableHeight *
                                            0.99, // Limit the height
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(28),
                                          topLeft: Radius.circular(28),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppBarText(
                                            color: Colors.black,
                                            text: "Withdraw Cash",
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Divider(
                                            height: 1,
                                            color: Colors.grey.shade200,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/cash.png',
                                                        height: 16),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                    const Text(
                                                      "Current Balance",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const Icon(Icons
                                                        .keyboard_arrow_down),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "₹$currentBalance",
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1,
                                                    child: ListView.builder(
                                                      itemCount: amount.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setModelState(() {
                                                              // selectedAmount = amount[index];
                                                              // withdrawBalance.text = amount[index];
                                                              selectedAmount =
                                                                  amount[index];
                                                              // withdrawBalance.text = amount[index].toString(); // Ensure it's a string
                                                              double
                                                                  amountValue =
                                                                  double.tryParse(
                                                                          amount[
                                                                              index]) ??
                                                                      0;
                                                              double
                                                                  currentBalanceValue =
                                                                  double.tryParse(
                                                                          currentBalance) ??
                                                                      0;
                                                              if (amountValue >
                                                                  currentBalanceValue) {
                                                                // Set the withdraw balance to the current balance
                                                                withdrawBalance
                                                                        .text =
                                                                    currentBalanceValue
                                                                        .toStringAsFixed(
                                                                            0); // Format to remove decimal
                                                                difference =
                                                                    0; // Set difference to 0 since you can't withdraw more than the balance
                                                              } else {
                                                                // If the selected amount is valid, set it as the withdraw amount
                                                                withdrawBalance
                                                                    .text = amount[
                                                                        index]
                                                                    .toString(); // Ensure it's a string
                                                                difference =
                                                                    currentBalanceValue -
                                                                        amountValue; // Update the difference
                                                              }
                                                              // Update the difference when an amount is selected
                                                              // difference = currentBalanceValue - amountValue;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 1),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  "₹ ${amount[index]}"),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: withdrawBalance,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Withdraw Amount",
                                                      suffixIcon: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            withdrawBalance
                                                                .clear();
                                                            setModelState(() {
                                                              selectedAmount =
                                                                  '';
                                                              difference = double
                                                                      .tryParse(
                                                                          currentBalance) ??
                                                                  0.0; // Reset difference to full balance
                                                              // selectedAmount = null; // Reset selected amount if needed
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 12),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                    ),
                                                    maxLines: 1,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        double withdrawAmount =
                                                            double.tryParse(
                                                                    value) ??
                                                                0;
                                                        double
                                                            currentBalanceValue =
                                                            double.tryParse(
                                                                    currentBalance) ??
                                                                0;
                                                        setModelState(() {
                                                          if (withdrawAmount >
                                                              5000) {
                                                            withdrawBalance
                                                                .text = "5000";
                                                            withdrawBalance
                                                                    .selection =
                                                                TextSelection
                                                                    .fromPosition(
                                                              TextPosition(
                                                                  offset:
                                                                      withdrawBalance
                                                                          .text
                                                                          .length),
                                                            );
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Maximum withdrawal amount is ₹5000",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xff140B40),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                            );
                                                          }
                                                          difference =
                                                              currentBalanceValue -
                                                                  withdrawAmount;
                                                          if (difference < 0) {
                                                            difference = 0.0;
                                                            // withdrawBalance.text = currentBalanceValue.toString();
                                                            withdrawBalance
                                                                    .text =
                                                                currentBalanceValue
                                                                    .toStringAsFixed(
                                                                        0); // Format to remove decimal
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Cannot withdraw more than current balance",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xff140B40),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                            );
                                                            // ScaffoldMessenger.of(context).showSnackBar(
                                                            //   const SnackBar(
                                                            //     content: Center(
                                                            //         child: Text(
                                                            //             'Cannot withdraw more than current balance')),
                                                            //   ),
                                                            // );
                                                          }
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  // "₹ ${((double.tryParse(withdrawBalance.text) ?? 0) - double.parse(currentBalance)).toStringAsFixed(2)} ",
                                                  "₹ ${difference < 0 ? 0 : difference.toStringAsFixed(0)}", // "₹ ${withdrawBalance.text - currentBalance} ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              NormalText(
                                                  color: Colors.grey,
                                                  text: "Enter UPI ID"),
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          SingleChildScrollView(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Center(
                                                child: TextFormField(
                                                  controller: upiIdController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    hintText: 'Enter UPI ID',
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Builder(
                                            builder: (context) =>
                                                GestureDetector(
                                              onTap: () {
                                                String amountToAdd =
                                                    withdrawBalance.text.trim();
                                                String upiId =
                                                    upiIdController.text.trim();

                                                // Check if the withdraw amount is valid
                                                if (amountToAdd.isEmpty ||
                                                    double.tryParse(
                                                            amountToAdd) ==
                                                        null ||
                                                    difference <= 0) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Please enter a valid amount",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        const Color(0xff140B40),
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                  // ScaffoldMessenger.of(context).showSnackBar(
                                                  //   const SnackBar(
                                                  //     content: Center(
                                                  //         child: Text(
                                                  //             'Please enter a valid amount')),
                                                  //   ),
                                                  // );
                                                } else if (upiId.isEmpty) {
                                                  // Check if UPI ID is empty
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Please enter a valid UPI ID",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        const Color(0xff140B40),
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                } else {
                                                  double amount =
                                                      double.parse(amountToAdd);
                                                  if (amount < 200) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Minimum withdrawal amount is ₹200",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff140B40),
                                                      textColor: Colors.white,
                                                      fontSize: 14.0,
                                                    );
                                                  } else if (amount >
                                                      double.parse(
                                                          currentBalance)) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Withdrawal amount cannot exceed current balance",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff140B40),
                                                      textColor: Colors.white,
                                                      fontSize: 14.0,
                                                    );
                                                  } else {
                                                    withdrawWallet(
                                                        amountToAdd, upiId);
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 45,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff140B40),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Withdraw",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Builder(
                                          //   builder: (context) => GestureDetector(
                                          //     onTap: () {
                                          //       String amountToAdd = withdrawBalance.text.trim();
                                          //       String upiId = upiIdController.text.trim();
                                          //
                                          //       if (double.tryParse(amountToAdd) != null) {
                                          //         double amount = double.parse(amountToAdd);
                                          //         if (amount < 200) {
                                          //           Fluttertoast.showToast(
                                          //             msg: "Minimum withdrawal amount is ₹200",
                                          //             toastLength: Toast.LENGTH_SHORT,
                                          //             gravity: ToastGravity.BOTTOM,
                                          //             timeInSecForIosWeb: 1,
                                          //             backgroundColor: Colors.black54,
                                          //             textColor: Colors.white,
                                          //             fontSize: 14.0,
                                          //           );
                                          //         }else if (amount > double.parse(currentBalance)) {
                                          //           Fluttertoast.showToast(
                                          //             msg: "Withdrawal amount cannot exceed current balance",
                                          //             toastLength: Toast.LENGTH_SHORT,
                                          //             gravity: ToastGravity.BOTTOM,
                                          //             timeInSecForIosWeb: 1,
                                          //             backgroundColor: Colors.black54,
                                          //             textColor: Colors.white,
                                          //             fontSize: 14.0,
                                          //           );
                                          //         }  else {
                                          //           withdrawWallet(amountToAdd, upiId);
                                          //           Navigator.pop(context);
                                          //         }
                                          //       } else {
                                          //         ScaffoldMessenger.of(context).showSnackBar(
                                          //           const SnackBar(
                                          //             content: Text('Invalid amount'),
                                          //           ),
                                          //         );
                                          //       }
                                          //     },
                                          //     child: Container(
                                          //       height: 45,
                                          //       width: double.infinity,
                                          //       decoration: BoxDecoration(
                                          //         color: const Color(0xff140B40),
                                          //         borderRadius: BorderRadius.circular(10),
                                          //       ),
                                          //       child: const Center(
                                          //         child: Text(
                                          //           "Withdraw",
                                          //           style: TextStyle(
                                          //             fontWeight: FontWeight.w500,
                                          //             fontSize: 16,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color(0xff140B40).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xff140B40).withOpacity(0.3),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Verify to Withdraw",
                              style: TextStyle(
                                color: Color(0xff140B40),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallText(color: Colors.black, text: "Amount Utilized"),
                      Big2Text(
                        color: Colors.black,
                        text: "₹${walletData.data.fundsUtilized.toString()}",
                      ),
                    ],
                  ),
                  const SizedBox(width: 82),
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallText(color: Colors.black, text: "Bonus"),
                      Big2Text(
                        color: Colors.black,
                        text: "₹${walletData.data.bonus.toString()}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionHistory(),
                          // builder: (context) => const DocumentsUploadScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction History",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InviteFriend(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Invite & Collect",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Bring your friends on app & win rewards",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:batting_app/screens/bnb.dart';
// import 'package:batting_app/widget/balance_notifire.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/WalletModel.dart';
// import '../widget/appbarscreen.dart';
// import '../widget/appbartext.dart';
// import '../widget/big2text.dart';
// import '../widget/normaltext.dart';
// import '../widget/smalltext.dart';
// import 'manage_product.dart';
// import 'transactionhistory.dart';
//
// class WalletScreen extends StatefulWidget {
//   final BalanceNotifier? balanceNotifier;
//
//   WalletScreen({Key? key, required this.balanceNotifier}) : super(key: key);
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }
// class _WalletScreenState extends State<WalletScreen> {
//   bool isHintVisible = true;
//
//   String currentBalance = "0";
//   String selectedAmount = "";
//   bool isProcessing = false; // Add this variable at the top of your state
//   // String currentBalance = "0";
//   String fundsUtilizedBalance = "0";
//   List amount = ["50", "100", "200", "500", "1000", "1500", "2000"];
//   TextEditingController addbalance = TextEditingController();
//   ValueNotifier<String> amountNotifier = ValueNotifier<String>("");
//   TextEditingController withdrawBalance = TextEditingController();
//   final TextEditingController addBalanceController = TextEditingController();
//   TextEditingController UPI_IDController = TextEditingController();
//   TextEditingController  scrollController = TextEditingController();
//
//   Future<void> withdrawWallet(String addbalance, String UPI_ID) async {
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
//         'UPI_ID': UPI_ID,
//         'payment_mode': 'phonePe',
//         'payment_type': 'add_wallet',
//       });
//
//       final response = await http.post(
//         Uri.parse("https://batting-api-1.onrender.com/api/wallet/withdraw"),
//         body: payload,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           "Authorization": token,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body.toString());
//         if (data != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Center(child: Text('WithDraw Amount Successfully')),
//             ),
//           );
//
//           setState(() {
//               int currentBalanceValue = int.parse(currentBalance);
//               int addedBalanceValue = int.parse(addbalance);
//               int newBalance = currentBalanceValue - addedBalanceValue;
//               currentBalance = newBalance.toString();
//               widget.balanceNotifier!.updateBalance(newBalance.toString());
//
//
//
//           });
//
//           AppDB.appDB.saveToken(data['data']['token']);
//         } else {
//           debugPrint("Received null data from API");
//         }
//       } else {
//         debugPrint("API request failed with status code: ${response.statusCode}");
//         debugPrint("Response body: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Exception occurred: $e");
//     }
//   }
//
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void dispose() {
//     _upiFocusNode.dispose(); // Dispose of the FocusNode
//     _scrollController.dispose();
//     addbalance.dispose();
//     amountNotifier.dispose();
//     addBalanceController.dispose();
//     super.dispose();
//   }
//
//
//   Future<void> addwallet(String addbalance) async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Token is null.')),
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
//           const SnackBar(content: Center(child: Text('Wallet Add Successfully'))),
//         );
//
//         setState(() {
//           int currentBalanceValue = int.parse(currentBalance);
//           int addedBalanceValue = int.parse(addbalance);
//           int newBalance = currentBalanceValue + addedBalanceValue;
//           currentBalance = newBalance.toString();
//           widget.balanceNotifier!.updateBalance(newBalance.toString());
//
//
//
//         });
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
//         debugPrint("Response Body: ${response.body}");
//         return WalletModel.fromJson(jsonDecode(response.body));
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
//
//   final FocusNode _upiFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     addBalanceController.addListener(() {
//       setState(() {
//         // Hide the hint if the field is not empty
//         isHintVisible = addBalanceController.text.isEmpty;
//       });
//     });
//     // Add listener to detect focus changes
//     _upiFocusNode.addListener(() {
//       if (_upiFocusNode.hasFocus) {
//         // Scroll to the TextField when focused
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent, // Scroll to the bottom
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         // Scroll back to the original position when focus is lost
//         _scrollController.animateTo(
//           _scrollController.position.minScrollExtent, // Scroll back to the top
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//       addbalance.addListener(() {
//         amountNotifier.value = addbalance.text; // Update ValueNotifier when text changes
//       });
//     });
//   }
// @override
//   Widget build(BuildContext context) {
//     final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
//     return Scaffold(
//       // resizeToAvoidBottomInset: true,
//       resizeToAvoidBottomInset: true, // Prevent the background from resizing
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
//                       AppBarText(color: Colors.white, text: "Wallet"),
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
//       body: FutureBuilder<WalletModel?>(
//         future: walletDisplay(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: const Color(0xffF0F1F5),
//                 child: const Center(child: CircularProgressIndicator()));
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error fetching data'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No data available'));
//           } else {
//             WalletModel walletData = snapshot.data!;
//             if (walletData.data != null) {
//               currentBalance = walletData.data.funds.toString();
//             }
//
//             return Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               color: const Color(0xffF0F1F5),
//               padding: EdgeInsets.all(15),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 7),
//                     Container(
//                       padding: EdgeInsets.only(left: 15, right: 15, top: 3),
//                       height: 126,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.white,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SmallText(color: Colors.black, text: "Balance"),
//                               Big2Text(
//                                 color: Colors.black,
//                                 text: "₹$currentBalance",
//                               ),
//                               // InkWell(
//                               //   onTap: ()  async {
//                               //      await showModalBottomSheet(
//                               //       context: context,
//                               //        isScrollControlled: true,
//                               //        useSafeArea: true,// Allow the bottom sheet to resize with the keyboard
//                               //        builder: (context) {
//                               //
//                               //         return StatefulBuilder(
//                               //           builder: (context,setModalState) {
//                               //             return SafeArea(
//                               //               child: SingleChildScrollView(
//                               //                 child: Container(
//                               //                   padding: EdgeInsets.symmetric(
//                               //                     horizontal: MediaQuery.of(context).size.width * 0.04,
//                               //                     vertical: MediaQuery.of(context).size.height * 0.02,
//                               //                   ),
//                               //                   // height: MediaQuery.of(context).size.height,
//                               //                   // width: MediaQuery.of(context).size.width,
//                               //                   constraints: BoxConstraints(
//                               //                     maxHeight: MediaQuery.of(context).size.height * 0.75, // Limit the height
//                               //                   ),
//                               //                   decoration: BoxDecoration(
//                               //                     borderRadius: BorderRadius.only(
//                               //                       topRight: Radius.circular(28),
//                               //                       topLeft: Radius.circular(28),
//                               //                     ),
//                               //                     color: Colors.white,
//                               //                   ),
//                               //                   child: Column(
//                               //                     mainAxisSize: MainAxisSize.min,
//                               //                     children: [
//                               //                       AppBarText(color: Colors.black, text: "Add Cash"),
//                               //                       // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                               //                       Divider(height: 1, color: Colors.grey.shade200),
//                               //                       SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                               //                       Container(
//                               //                         padding: EdgeInsets.symmetric(
//                               //                           horizontal: MediaQuery.of(context).size.width * 0.03,
//                               //                         ),
//                               //                         height: MediaQuery.of(context).size.height * 0.07,
//                               //                         width: MediaQuery.of(context).size.width,
//                               //                         decoration: BoxDecoration(
//                               //                           borderRadius: BorderRadius.circular(10),
//                               //                           border: Border.all(width: 1, color: Colors.grey.shade300),
//                               //                         ),
//                               //                         child: Row(
//                               //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //                           children: [
//                               //                             Row(
//                               //                               children: [
//                               //                                 Image.asset(
//                               //                                   'assets/cash.png',
//                               //                                   height: MediaQuery.of(context).size.height * 0.02, // Adjusted size
//                               //                                 ),
//                               //                                 SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                               //                                 Text(
//                               //                                   "Current Balance",
//                               //                                   style: TextStyle(
//                               //                                     fontSize: MediaQuery.of(context).size.width * 0.045, // Adjusted font size
//                               //                                     fontWeight: FontWeight.w500,
//                               //                                   ),
//                               //                                 ),
//                               //                                 Icon(Icons.keyboard_arrow_down),
//                               //                               ],
//                               //                             ),
//                               //                             Text(
//                               //                               "₹$currentBalance",
//                               //                               overflow: TextOverflow.clip,
//                               //                               style: TextStyle(
//                               //                                 fontSize: MediaQuery.of(context).size.width * 0.045, // Adjusted font size
//                               //                                 fontWeight: FontWeight.w600,
//                               //                               ),
//                               //                             ),
//                               //                           ],
//                               //                         ),
//                               //                       ),
//                               //                       SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                               //                       SizedBox(
//                               //                         height: MediaQuery.of(context).size.height * 0.05,
//                               //                         width: MediaQuery.of(context).size.width,
//                               //                         child: Row(
//                               //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //                           children: [
//                               //                             Expanded(
//                               //                               flex: 1,
//                               //                               child: ListView.builder(
//                               //                                 itemCount: amount.length,
//                               //                                 scrollDirection: Axis.horizontal,
//                               //                                 itemBuilder: (context, index) {
//                               //                                   return InkWell(
//                               //                                     onTap: () {
//                               //                                       setState(() {
//                               //                                         selectedAmount = amount[index];
//                               //                                         addbalance.text = selectedAmount;
//                               //                                       });
//                               //                                     },
//                               //                                     child: Container(
//                               //                                       width: MediaQuery.of(context).size.width * 0.2,
//                               //                                       margin: EdgeInsets.only(
//                               //                                         right: MediaQuery.of(context).size.width * 0.02,
//                               //                                       ),
//                               //                                       height: MediaQuery.of(context).size.height * 0.05,
//                               //                                       decoration: BoxDecoration(
//                               //                                         borderRadius: BorderRadius.circular(12),
//                               //                                         border: Border.all(
//                               //                                           color: Colors.grey.shade300,
//                               //                                           width: 1,
//                               //                                         ),
//                               //                                       ),
//                               //                                       child: Center(
//                               //                                         child: Text(
//                               //                                           "₹ ${amount[index]}",
//                               //                                           style: TextStyle(
//                               //                                             fontSize: MediaQuery.of(context).size.width * 0.04, // Adjusted font size
//                               //                                           ),
//                               //                                         ),
//                               //                                       ),
//                               //                                     ),
//                               //                                   );
//                               //                                 },
//                               //                               ),
//                               //                             ),
//                               //                           ],
//                               //                         ),
//                               //                       ),
//                               //                       SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                               //                       Container(
//                               //                         padding: EdgeInsets.symmetric(
//                               //                           horizontal: MediaQuery.of(context).size.width * 0.03,
//                               //                         ),
//                               //                         height: 50, // Set a fixed height for one line of text
//                               //                         decoration: BoxDecoration(
//                               //                           borderRadius: BorderRadius.circular(12),
//                               //                           border: Border.all(
//                               //                             color: Colors.grey.shade300,
//                               //                             width: 1,
//                               //                           ),
//                               //                         ),
//                               //                         child: Row(
//                               //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //                           children: [
//                               //                             Expanded(
//                               //                               child: TextFormField(
//                               //                                 keyboardType: TextInputType.number,
//                               //                                 controller: addbalance, // Make sure this controller is initialized
//                               //                                 decoration: InputDecoration(
//                               //                                   hintText: "Add Amount",
//                               //                                   hintStyle: TextStyle(
//                               //                                     fontSize: MediaQuery.of(context).size.width * 0.035,
//                               //
//                               //                                     // Adjusted font size
//                               //                                   ),
//                               //                                   suffix: InkWell(
//                               //                                     onTap: () {
//                               //                                       // Clear the input when the icon is tapped
//                               //                                       addbalance.clear();
//                               //                                     },
//                               //                                     child: Icon(Icons.remove_circle, color: Colors.grey,),
//                               //                                   ),
//                               //
//                               //                                   border: InputBorder.none,
//                               //                                   contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15), // Adjusts padding to align the text and icon
//                               //
//                               //                                   // contentPadding: EdgeInsets.symmetric(vertical: 0), // Adjusts vertical padding for one line
//                               //                                 ),
//                               //                                 style: TextStyle(
//                               //                                   fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                               //                                 ),
//                               //                                 maxLines: 1, // Ensures the TextFormField does not exceed one line
//                               //                               ),
//                               //                             ),
//                               //
//                               //                             SizedBox(width: 10), // Add spacing if needed
//                               //                             Text(
//                               //                               "₹ ${addbalance.text}",
//                               //                               style: TextStyle(
//                               //                                 fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                               //                                 fontWeight: FontWeight.w400,
//                               //                               ),
//                               //                             ),
//                               //                           ],
//                               //                         ),
//                               //                       ),
//                               //                       SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                               //                       GestureDetector(
//                               //                         onTap: () async {
//                               //                           if (isProcessing) return; // Prevent further taps if already processing
//                               //
//                               //                           String amountToAdd = addbalance.text;
//                               //                           if (double.tryParse(amountToAdd) != null) {
//                               //                             double amount = double.parse(amountToAdd);
//                               //                             if (amount <= 49) {
//                               //                               Fluttertoast.showToast(
//                               //                                 msg: "Amount should be greater than 50",
//                               //                                 toastLength: Toast.LENGTH_SHORT,
//                               //                                 gravity: ToastGravity.BOTTOM,
//                               //                                 timeInSecForIosWeb: 1,
//                               //                                 backgroundColor: Colors.black54,
//                               //                                 textColor: Colors.white,
//                               //                                 fontSize: 14.0,
//                               //                               );
//                               //                               ScaffoldMessenger.of(context).showSnackBar(
//                               //                                 SnackBar(
//                               //                                   content: Center(
//                               //                                     child: Text('Amount should be greater than 50'),
//                               //                                   ),
//                               //                                 ),
//                               //                               );
//                               //                             } else {
//                               //                               setState(() {
//                               //                                 addwallet(amountToAdd);
//                               //                               });
//                               //                               Navigator.pop(context);
//                               //                             }
//                               //                           } else {
//                               //                             ScaffoldMessenger.of(context).showSnackBar(
//                               //                               SnackBar(
//                               //                                 content: Text('Invalid amount'),
//                               //                               ),
//                               //                             );
//                               //                           }
//                               //                         },
//                               //                         child: Container(
//                               //                           height: 45,
//                               //                           width: MediaQuery.of(context).size.width,
//                               //                           decoration: BoxDecoration(
//                               //                             color: Color(0xff140B40),
//                               //                             borderRadius: BorderRadius.circular(10),
//                               //                           ),
//                               //                           child: Center(
//                               //                             child: Text(
//                               //                               "Add",
//                               //                               style: TextStyle(
//                               //                                 fontWeight: FontWeight.w500,
//                               //                                 fontSize: MediaQuery.of(context).size.width * 0.04, // Adjusted font size
//                               //                                 color: Colors.white,
//                               //                               ),
//                               //                             ),
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                     ],
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //             );
//                               //           }
//                               //         );
//                               //
//                               //       },
//                               //     );
//                               //   },
//                               //   child: Container(
//                               //     height: MediaQuery.of(context).size.height * 0.05, // Adjust height as needed
//                               //     width: MediaQuery.of(context).size.width * 0.4, // Adjust width as needed
//                               //     decoration: BoxDecoration(
//                               //       color: const Color(0xff140B40).withOpacity(0.05),
//                               //       borderRadius: BorderRadius.circular(8),
//                               //       border: Border.all(
//                               //         color: const Color(0xff140B40).withOpacity(0.3),
//                               //       ),
//                               //     ),
//                               //     child: Center(
//                               //       child: Text(
//                               //         "Add Cash",
//                               //         style: TextStyle(
//                               //             color: const Color(0xff140B40),
//                               //             fontWeight: FontWeight.w600,
//                               //             fontSize: 12),
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                               InkWell(
//                                 onTap: () async {
//                                   await showModalBottomSheet(
//                                     context: context,
//                                     isScrollControlled: true,
//                                     useSafeArea: true,
//                                     builder: (context) {
//                                       return StatefulBuilder(
//                                         builder: (context, setModalState) {
//                                           double screenHeight = MediaQuery.of(context).size.height;
//
//                                           // Get the height of the keyboard
//                                           double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//
//                                           // Calculate the available height for the bottom sheet
//                                           double availableHeight = screenHeight + keyboardHeight;
//
//                                           // final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
//
//                                           // setModalState(){
//                                           //
//                                           // }
//                                           return SingleChildScrollView(
//                                                                                       child: Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal:
//                                                 MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.04,
//                                             vertical: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.02,
//                                             // vertical: isKeyboardOpen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height/1,
//                                           ),
//                                           // height: MediaQuery.of(context).size.height /1.42,
//                                                             // width: MediaQuery.of(context).size.width,
//                                           // constraints: BoxConstraints(
//                                           //   maxHeight: MediaQuery.of(
//                                           //               context)
//                                           //           .size
//                                           //           .height *
//                                           //       0.90, // Limit the height
//                                           // ),
//                                           // height: availableHeight / 2.30, // Adjust height based on available space
//                                           height: availableHeight * 0.50,
//                                           constraints: BoxConstraints(
//                                             maxHeight: availableHeight * 0.99, // Limit the height
//                                           ),
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(28),
//                                               topLeft: Radius.circular(28),
//                                             ),
//                                             color: Colors.white,
//                                           ),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               AppBarText(
//                                                   color: Colors.black,
//                                                   text: "Add Cash"),
//                                               Divider(
//                                                   height: 1,
//                                                   color:
//                                                       Colors.grey.shade200),
//                                               SizedBox(
//                                                   height:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .height *
//                                                           0.02),
//                                               Container(
//                                                 padding:
//                                                     EdgeInsets.symmetric(
//                                                   horizontal:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .width *
//                                                           0.03,
//                                                 ),
//                                                 height:
//                                                     MediaQuery.of(context)
//                                                             .size
//                                                             .height *
//                                                         0.07,
//                                                 width:
//                                                     MediaQuery.of(context)
//                                                         .size
//                                                         .width,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10),
//                                                   border: Border.all(
//                                                       width: 1,
//                                                       color: Colors
//                                                           .grey.shade300),
//                                                 ),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Image.asset(
//                                                           'assets/cash.png',
//                                                           height: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .height *
//                                                               0.02,
//                                                         ),
//                                                         SizedBox(
//                                                             width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width *
//                                                                 0.02),
//                                                         Text(
//                                                           "Current Balance",
//                                                           style: TextStyle(
//                                                             fontSize: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width *
//                                                                 0.045,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                           ),
//                                                         ),
//                                                         Icon(Icons
//                                                             .keyboard_arrow_down),
//                                                       ],
//                                                     ),
//                                                     Text(
//                                                       "₹$currentBalance",
//                                                       overflow:
//                                                           TextOverflow.clip,
//                                                       style: TextStyle(
//                                                         fontSize: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width *
//                                                             0.045,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .height *
//                                                           0.03),
//                                               SizedBox(
//                                                 height:
//                                                     MediaQuery.of(context)
//                                                             .size
//                                                             .height *
//                                                         0.05,
//                                                 width:
//                                                     MediaQuery.of(context)
//                                                         .size
//                                                         .width,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Expanded(
//                                                       flex: 1,
//                                                       child:
//                                                           ListView.builder(
//                                                         itemCount:
//                                                             amount.length,
//                                                         scrollDirection:
//                                                             Axis.horizontal,
//                                                         itemBuilder:
//                                                             (context,
//                                                                 index) {
//                                                           return InkWell(
//                                                             onTap: () {
//                                                               setModalState(
//                                                                   () {
//                                                                 // Use setModalState here
//                                                                 selectedAmount =
//                                                                     amount[
//                                                                         index];
//                                                                 addbalance
//                                                                         .text =
//                                                                     selectedAmount; // Update the text field
//                                                               });
//                                                             },
//                                                             child:
//                                                                 Container(
//                                                               width: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width *
//                                                                   0.2,
//                                                               margin:
//                                                                   EdgeInsets
//                                                                       .only(
//                                                                 right: MediaQuery.of(context)
//                                                                         .size
//                                                                         .width *
//                                                                     0.02,
//                                                               ),
//                                                               height: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .height *
//                                                                   0.05,
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius.circular(
//                                                                         12),
//                                                                 border:
//                                                                     Border
//                                                                         .all(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .shade300,
//                                                                   width: 1,
//                                                                 ),
//                                                               ),
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   "₹ ${amount[index]}",
//                                                                   style:
//                                                                       TextStyle(
//                                                                     fontSize:
//                                                                         MediaQuery.of(context).size.width *
//                                                                             0.04,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .height *
//                                                           0.02),
//                                               Container(
//                                                 padding:
//                                                     EdgeInsets.symmetric(
//                                                   horizontal:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .width *
//                                                           0.03,
//                                                 ),
//                                                 height: 50,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12),
//                                                   border: Border.all(
//                                                     color: Colors
//                                                         .grey.shade300,
//                                                     width: 1,
//                                                   ),
//                                                 ),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Expanded(
//                                                       child: TextFormField(keyboardType:TextInputType.number,
//                                                         controller:addbalance,
//                                                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                                         decoration: InputDecoration(
//                                                           hintText: "Add Amount",
//                                                           hintStyle:TextStyle(fontSize: MediaQuery.of(context).size.width *0.035,),
//                                                           contentPadding: EdgeInsets.only(left: 0, top: 12.5, right: 0, bottom: 0), // Only add padding to the top
//                                                           // suffix: Container(
//                                                           //   height: 40, // Set this to the height of the TextFormField
//                                                           //   width: 40,
//                                                           //   child: Padding(
//                                                           //     padding: const EdgeInsets.only(top: 8.0),
//                                                           //     child: InkWell(
//                                                           //       onTap: () {
//                                                           //         addbalance.clear();
//                                                           //       },
//                                                           //       child: Icon(
//                                                           //           Icons.remove_circle,
//                                                           //           color: Colors.grey
//                                                           //       ),
//                                                           //     ),
//                                                           //   ),
//                                                           // ),
//                                                           suffixIcon: Padding(
//                                                             padding: const EdgeInsets.only(bottom: 4.0),
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 addbalance.clear();
//                                                               },
//                                                               child: Icon(
//                                                                 Icons.remove_circle,
//                                                                 color: Colors.grey,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           border:InputBorder.none,
//                                                           // contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical: 15),
//                                                         ),
//                                                         style: TextStyle(
//                                                           fontSize: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .width *
//                                                               0.035,
//                                                         ),
//                                                         maxLines: 1,
//                                                         onChanged: (value) {
//                                                           setModalState(() {
//                                                             if (value.isNotEmpty && value[0] == '0') {
//                                                               // If it starts with '0', show a message or reset the field
//                                                               Fluttertoast.showToast(
//                                                                 msg: "Amount cannot start with 0",
//                                                                 toastLength: Toast.LENGTH_SHORT,
//                                                                 gravity: ToastGravity.BOTTOM,
//                                                                 timeInSecForIosWeb: 1,
//                                                                 backgroundColor: Colors.black54,
//                                                                 textColor: Colors.white,
//                                                                 fontSize: 14.0,
//                                                               );
//                                                               // Optionally, you can clear the field or modify the input
//                                                               addbalance.clear();
//                                                             }
//                                                             // Update any state if necessary
//                                                           });
//                                                         },
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     Text(
//                                                       "₹ ${addbalance.text}",
//                                                       style: TextStyle(
//                                                         fontSize: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width *
//                                                             0.035,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .height *
//                                                           0.01),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   if (isProcessing) return;
//
//                                                   String amountToAdd = addbalance.text;
//                                                   if (amountToAdd.isEmpty || double.tryParse(amountToAdd) == null) {
//                                                     Fluttertoast.showToast(
//                                                       msg: "Please enter a valid number",
//                                                       toastLength: Toast.LENGTH_SHORT,
//                                                       gravity: ToastGravity.BOTTOM,
//                                                       timeInSecForIosWeb: 1,
//                                                       backgroundColor: Colors.black54,
//                                                       textColor: Colors.white,
//                                                       fontSize: 14.0,
//                                                     );
//                                                     return; // Exit the function if validation fails
//                                                   }
//
//
//                                                   if (double.tryParse(amountToAdd) != null) {
//                                                     double amount = double.parse(amountToAdd);
//                                                     if (amount <= 49) {
//                                                       Fluttertoast
//                                                           .showToast(
//                                                         msg:
//                                                             "Amount should be greater than 50",
//                                                         toastLength: Toast
//                                                             .LENGTH_SHORT,
//                                                         gravity:
//                                                             ToastGravity
//                                                                 .BOTTOM,
//                                                         timeInSecForIosWeb:
//                                                             1,
//                                                         backgroundColor:
//                                                             Colors.black54,
//                                                         textColor:
//                                                             Colors.white,
//                                                         fontSize: 14.0,
//                                                       );
//                                                     } else {
//                                                       setState(() {
//                                                         isProcessing =
//                                                             true; // Set processing state
//                                                       });
//                                                       await addwallet(
//                                                           amountToAdd);
//                                                       setModalState(() {
//                                                         // Update any state if necessary after adding
//                                                       });
//                                                       Navigator.pop(
//                                                           context);
//                                                     }
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       SnackBar(
//                                                         content: Text(
//                                                             'Invalid amount'),
//                                                       ),
//                                                     );
//                                                   }
//                                                 },
//                                                 child: Container(
//                                                   height: 45,
//                                                   width:
//                                                       MediaQuery.of(context)
//                                                           .size
//                                                           .width,
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         Color(0xff140B40),
//                                                     borderRadius:
//                                                         BorderRadius
//                                                             .circular(10),
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       "Add",
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width *
//                                                             0.04,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                                                                       ),
//                                                                                     );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.4,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xff140B40)
//                                         .withOpacity(0.05),
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: const Color(0xff140B40)
//                                           .withOpacity(0.3),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Add Cash",
//                                       style: TextStyle(
//                                         color: const Color(0xff140B40),
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             height: 100,
//                             width: 1,
//                             color: Colors.grey.shade300,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SmallText(color: Colors.black, text: "Winnings"),
//                               Big2Text(
//                                 color: Colors.black,
//                                 text: "₹${walletData.data.winnings.toString()}",
//                               ),
//                               InkWell(
//                                 onTap: () async {
//                                   await showModalBottomSheet(
//
//                                     context: context,
//                                     builder: (context) {
//                                       return StatefulBuilder(
//                                         builder: (context, setModelState) {
//                                           return SingleChildScrollView(
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: MediaQuery.of(context).size.width * 0.04,
//                                                 vertical: MediaQuery.of(context).size.height * 0.02,
//                                               ),
//                                               height: MediaQuery.of(context).size.height,
//                                                                 // width: MediaQuery.of(context).size.width,
//                                               constraints: BoxConstraints(
//                                                 minHeight: MediaQuery.of(context).size.height * 0.75, // Adjust height dynamically
//                                               ),
//                                               width: MediaQuery.of(context).size.width,
//                                               decoration: const BoxDecoration(
//                                                 borderRadius: BorderRadius.only(
//                                                     topRight: Radius.circular(28),
//                                                     topLeft: Radius.circular(28)
//                                                 ),
//                                                 color: Colors.white,
//                                               ),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   AppBarText(
//                                                     color: Colors.black,
//                                                     text: "Withdraw Cash",
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                                                   Divider(
//                                                     height: 1,
//                                                     color: Colors.grey.shade200,
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                                                   Container(
//                                                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
//                                                     height: MediaQuery.of(context).size.height * 0.06,
//                                                     width: double.infinity,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                       border: Border.all(width: 1, color: Colors.grey.shade300),
//                                                     ),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Image.asset('assets/cash.png', height: 16),
//                                                             SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                                                             Text(
//                                                               "Current Balance",
//                                                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                                                             ),
//                                                             const Icon(Icons.keyboard_arrow_down),
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Text(
//                                                               "₹$currentBalance",
//                                                               overflow: TextOverflow.clip,
//                                                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                                                   SizedBox(
//                                                     height: MediaQuery.of(context).size.height * 0.07,
//                                                     width: double.infinity,
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Expanded(
//                                                           child: SizedBox(
//                                                             height: MediaQuery.of(context).size.height * 0.05,
//                                                             width: MediaQuery.of(context).size.width / 1,
//                                                             child: ListView.builder(
//                                                               itemCount: amount.length,
//                                                               scrollDirection: Axis.horizontal,
//                                                               itemBuilder: (context, index) {
//                                                                 return InkWell(
//                                                                   onTap: () {
//                                                                     setState(() {
//                                                                       selectedAmount = amount[index];
//                                                                       withdrawBalance.text = amount[index];
//                                                                     });
//                                                                   },
//                                                                   child: Container(
//                                                                     margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
//                                                                     height: MediaQuery.of(context).size.height * 0.05,
//                                                                     width: MediaQuery.of(context).size.width * 0.2,
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius.circular(12),
//                                                                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                                                                     ),
//                                                                     child: Center(
//                                                                       child: Text("₹ ${amount[index]}"),
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                          ],
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                                                   Container(
//                                                     padding: EdgeInsets.symmetric(
//                                                       horizontal: MediaQuery.of(context).size.width * 0.03,
//                                                     ),
//                                                     height: 50, // Set a fixed height for one line of text
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(12),
//                                                       border: Border.all(
//                                                         color: Colors.grey.shade300,
//                                                         width: 1,
//                                                       ),
//                                                     ),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Expanded(
//                                                           child: TextFormField(
//                                                             keyboardType: TextInputType.number,
//                                                             controller: withdrawBalance, // Make sure this controller is initialized
//                                                             decoration: InputDecoration(
//                                                               hintText: "Withdraw Amount",
//                                                               suffix: Container(
//                                                                 padding: EdgeInsets.symmetric(vertical: 0.0000125), // To remove any extra padding
//                                                                 // alignment: Alignment.center,
//                                                                 child: InkWell(
//                                                                   onTap: () {
//                                                                     // Clear the input when the icon is tapped
//                                                                     withdrawBalance.clear();
//                                                                   },
//                                                                   child: Icon(Icons.remove_circle, color: Colors.grey),
//                                                                 ),
//                                                               ),
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                                                               ),
//                                                               border: InputBorder.none,
//                                                               contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjusts vertical padding for one line
//                                                             ),
//                                                             style: TextStyle(
//                                                               fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                                                             ),
//                                                             maxLines: 1, // Ensures the TextFormField does not exceed one line
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: 10), // Add spacing if needed
//                                                         Text(
//                                                           "₹ ${withdrawBalance.text}",
//                                                           style: TextStyle(
//                                                             fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                                                             fontWeight: FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       NormalText(color: Colors.grey, text: "Enter UPI ID"),
//                                                       // Row(
//                                                       //   children: [
//                                                       //     NormalText(color: Colors.grey, text: "View All"),
//                                                       //     const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//                                                       //   ],
//                                                       // ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                                                   SingleChildScrollView(
//                                                     child: Container(
//                                                       height: 50,
//                                                       width: MediaQuery.of(context).size.width * 0.9,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(11),
//                                                         border: Border.all(color: Colors.grey.shade300),
//                                                       ),
//                                                       padding: EdgeInsets.symmetric(horizontal: 16), // Add padding for better spacing
//                                                       child: Center(
//                                                         child: TextFormField(
//                                                           controller: UPI_IDController,
//                                                           decoration: InputDecoration(
//                                                             hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                                             hintText: 'Enter UPI ID', // Custom hint text
//                                                             border: InputBorder.none, // Remove the default border
//                                                           ),
//                                                           keyboardType: TextInputType.emailAddress, // UPI IDs are like email addresses
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                                                   Builder(
//                                                     builder: (context) => GestureDetector(
//                                                       onTap: () {
//                                                         String amountToAdd = withdrawBalance.text.trim();
//                                                         String UPI_ID = UPI_IDController.text.trim();
//
//                                                         if (double.tryParse(amountToAdd) != null) {
//                                                           double amount = double.parse(amountToAdd);
//                                                           if (amount < 200) {
//                                                             Fluttertoast.showToast(
//                                                               msg: "Minimum withdrawal amount is ₹200",
//                                                               toastLength: Toast.LENGTH_SHORT,
//                                                               gravity: ToastGravity.BOTTOM,
//                                                               timeInSecForIosWeb: 1,
//                                                               backgroundColor: Colors.black54,
//                                                               textColor: Colors.white,
//                                                               fontSize: 14.0,
//                                                             );
//                                                           } else {
//                                                             withdrawWallet(amountToAdd, UPI_ID);
//                                                             Navigator.pop(context); // Close the screen after withdrawal
//                                                           }
//                                                         } else {
//                                                           ScaffoldMessenger.of(context).showSnackBar(
//                                                             const SnackBar(
//                                                               content: Text('Invalid amount'),
//                                                             ),
//                                                           );
//                                                         }
//                                                       },
//                                                       child: Container(
//                                                         height: 45,
//                                                         width: double.infinity,
//                                                         decoration: BoxDecoration(
//                                                           color: const Color(0xff140B40),
//                                                           borderRadius: BorderRadius.circular(10),
//                                                         ),
//                                                         child: const Center(
//                                                           child: Text(
//                                                             "Withdraw",
//                                                             style: TextStyle(
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: 16,
//                                                               color: Colors.white,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//
//                                         },
//                                       );
//                                     },
//                                   );
//                                 },
//
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height * 0.05, // Adjust height as needed
//                                   width: MediaQuery.of(context).size.width * 0.4,
//                                   decoration: BoxDecoration(
//                                     color:
//                                         const Color(0xff140B40).withOpacity(0.05),
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: const Color(0xff140B40)
//                                           .withOpacity(0.3),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Verify to Withdraw",
//                                       style: TextStyle(
//                                         color: const Color(0xff140B40),
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 22),
//                     Container(
//                       padding: EdgeInsets.only(left: 15, right: 15, top: 2),
//                       height: 75,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.white,
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SmallText(
//                                   color: Colors.black, text: "Amount Utilized"),
//                               Big2Text(
//                                 color: Colors.black,
//                                 text:
//                                     "₹${walletData.data.fundsUtilized.toString()}",
//                               ),
//                             ],
//                           ),
//
//                           SizedBox(width: 82),
//                           Container(
//                             height: 50,
//                             width: 1,
//                             color: Colors.grey.shade300,
//                           ),
//                           SizedBox(width: 25),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SmallText(color: Colors.black, text: "Bonus"),
//                               Big2Text(
//                                 color: Colors.black,
//                                 text: "₹${walletData.data.bonus.toString()}",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 22),
//                     Container(
//                       height: 140,
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.only(left: 15, right: 15),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         // crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const TransactionHistory(),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 5,),
//                               height: 50,
//                               width: MediaQuery.of(context).size.width,
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                                 children: [
//                                   Text(
//                                     "Transaction History",
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           Divider(
//                             color: Colors.grey.shade300,
//                           ),
//                           InkWell(
//                             onTap: () {},
//                             child: Container(
//                               height: 60,
//                               padding: const EdgeInsets.all(5),
//                               width: MediaQuery.of(context).size.width,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         "Invite & Collect",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Bring your friends on app & win rewards",
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

//         Expanded(
//         child: Stack(
//         children: [
//             if (isHintVisible) // Display hint only if visible
//         Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 15),
//           child: Text(
//             "Add Amount",
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.width * 0.035,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ),
//       TextFormField(
//         keyboardType: TextInputType.number,
//         controller: addBalanceController,
//         decoration: InputDecoration(
//           suffix: InkWell(
//             onTap: () {
//               addBalanceController.clear();
//             },
//             child: Icon(
//               Icons.remove_circle,
//               color: Colors.grey,
//             ),
//           ),
//           border: InputBorder.none,
//         ),
//         style: TextStyle(
//           fontSize: MediaQuery.of(context).size.width * 0.035,
//         ),
//         maxLines: 1,
//       ),
//     ],
//   ),
// ),

// int currentBalanceValue = int.parse(currentBalance);
// int addedBalanceValue = int.parse(addbalance);
// currentBalanceValue += addedBalanceValue;
// currentBalance = currentBalanceValue.toString(); // Within the `FirstRoute` widget:
//
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) =>  Bottom()),
//               // );

// int currentBalanceValue = int.parse(currentBalance);
// int addedBalanceValue = int.parse(addbalance);
// currentBalanceValue += addedBalanceValue;
// currentBalance = currentBalanceValue.toString();

// Within the `FirstRoute` widget:

// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) =>  Bottom()),
// );
// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return AlertDialog(
//       title: const Text('Success', textAlign: TextAlign.center),
//       content: const Text('Amount added successfully.', textAlign: TextAlign.center),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           style: TextButton.styleFrom(
//             backgroundColor: const Color(0xff140B40),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           child: const Text(
//             'Done',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   },
// );

// class WalletScreen extends StatefulWidget {
//   final BalanceNotifier balanceNotifier;
//
//   WalletScreen({Key? key, required this.balanceNotifier}) : super(key: key);
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// Future<void> addwallet(String addbalance) async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token is null.'),
//         ),
//       );
//       return;
//     }
//
//     debugPrint('Token $token');
//     var payload = jsonEncode({
//       'amount': addbalance,
//       'payment_mode': 'phonePe',
//       'payment_type': 'add_wallet',
//     });
//     debugPrint("this is payload $payload");
//     final response = await http.post(
//       Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
//       body: payload,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         "Authorization": token,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       debugPrint("this is from if part::$data");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Center(child: Text('Wallet Add Successfully')),
//         ),
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
//       debugPrint("this is current balance from else::$currentBalance");
//       debugPrint("this is current addbalance from else::$addbalance");
//       debugPrint("this is from else::${response.body}");
//     }
//   } catch (e) {
//     debugPrint("Exception occurred: $e");
//   }
// }

// Assuming the API response has the UPI_ID and amount fields

// Future<void> addwallet(String addbalance) async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token is null.'),
//         ),
//       );
//       return;
//     }
//
//     debugPrint('Token $token');
//     var payload = jsonEncode({
//       'amount': addbalance,
//       'payment_mode': 'phonePe',
//       'payment_type': 'add_wallet',
//     });
//     debugPrint("this is payload $payload");
//     final response = await http.post(
//       Uri.parse("https://batting-api-1.onrender.com/api/wallet/add"),
//       body: payload,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         "Authorization": token,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       debugPrint("this is from if part::$data");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Center(child: Text('Wallet Add Successfully')),
//         ),
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
//       debugPrint("this is current balance from else::$currentBalance");
//       debugPrint("this is current addbalance from else::$addbalance");
//       debugPrint("this is from else::${response.body}");
//     }
//   } catch (e) {
//     debugPrint("Exception occurred: $e");
//   }
// }

// Assuming the API response has the UPI_ID and amount fields

// Container(
//   height: MediaQuery.of(context).size.height * 0.05,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(12),
//     border: Border.all(color: Colors.grey.shade300, width: 1),
//   ),
//   padding: EdgeInsets.symmetric(horizontal: 10),
//   width: MediaQuery.of(context).size.width / 2.6,
//   child: Center(
//     child: TextFormField(
//       keyboardType: TextInputType.number,
//       controller: withdrawBalance,
//       decoration: InputDecoration(
//         hintText: "Withdraw Amount",
//         suffix: InkWell(
//           onTap: () {
//             withdrawBalance.clear();
//           },
//           child: const Icon(Icons.remove_circle, color: Colors.grey),
//         ),
//         hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//         border: InputBorder.none,
//       ),
//     ),
//   ),
// ),

// Container(
//   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
//   height: MediaQuery.of(context).size.height * 0.06,
//   width: double.infinity,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     border: Border.all(width: 1, color: Colors.grey.shade300),
//   ),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         "Withdraw to Current Balance",
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
//       ),
//       Text(
//         "₹ ${withdrawBalance.text}",
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//       ),
//     ],
//   ),
// ),

// Expanded(
//   flex: 1,
//   child: Container(
//     height: MediaQuery.of(context).size.height * 0.05,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: Colors.grey.shade300,
//         width: 1,
//       ),
//     ),
//     padding: EdgeInsets.symmetric(
//       horizontal: MediaQuery.of(context).size.width * 0.03,
//     ),
//     child: Center(
//       child: TextFormField(
//         keyboardType: TextInputType.number,
//         controller: addbalance,
//         decoration: InputDecoration(
//           hintText: "Add Amount",
//           suffix: InkWell(
//             onTap: () {
//               // addbalance.clear();
//             },
//             child: Icon(Icons.remove_circle, color: Colors.grey),
//           ),
//           hintStyle: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//           ),
//           border: InputBorder.none,
//         ),
//       ),
//     ),
//   ),
// ),

// Container(
//   padding: EdgeInsets.symmetric(
//     horizontal: MediaQuery.of(context).size.width * 0.03,
//   ),
//   height: MediaQuery.of(context).size.height * 0.07,
//   width: MediaQuery.of(context).size.width,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     border: Border.all(width: 1, color: Colors.grey.shade300),
//   ),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         "Add to Current Balance",
//         style: TextStyle(
//           fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//           fontWeight: FontWeight.w400,
//           color: Colors.grey,
//         ),
//       ),
//       Text(
//         "₹ ${addbalance.text}",
//         style: TextStyle(
//           fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     ],
//   ),
// ),

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     NormalText(color: Colors.grey, text: "Payment Partners"),
//     Row(
//       children: [
//         NormalText(color: Colors.grey, text: "View All"),
//         Icon(
//           Icons.arrow_forward_ios,
//           size: MediaQuery.of(context).size.width * 0.045, // Adjusted icon size
//           color: Colors.grey,
//         ),
//       ],
//     ),
//   ],
// ),
// SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//
//
//
//
// SizedBox(
//   height: MediaQuery.of(context).size.height * 0.08,
//   width: MediaQuery.of(context).size.width,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: 3,
//     itemBuilder: (context, index) {
//       List<Map<String, String>> paymentOptions = [
//         {
//           'image': 'assets/paybg.png',
//           'title': 'PhonePe UPI Lite',
//           'subtitle': 'Flat ₹10 Cashback',
//           'color': '0xff6739B7',
//         },
//         {
//           'image': 'assets/gbg.png',
//           'title': 'Google Pay UPI',
//           'subtitle': 'Flat ₹20 Cashback',
//           'color': '0xffA8B0F7',
//         },
//         {
//           'image': 'assets/ppbg.png',
//           'title': 'Amazon Pay UPI',
//           'subtitle': 'Flat ₹20 Cashback',
//           'color': '0xff333E47',
//         },
//       ];
//
//       return Row(
//         children: paymentOptions.map((option) {
//           return Container(
//             margin: EdgeInsets.only(
//               right: MediaQuery.of(context).size.width * 0.02,
//             ),
//             height: MediaQuery.of(context).size.height * 0.08,
//             width: MediaQuery.of(context).size.width * 0.7,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 width: 1,
//                 color: Color(int.parse(option['color']!)),
//               ),
//             ),
//             child: Row(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.08,
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   child: Image.asset(
//                     option['image']!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       option['title']!,
//                       style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                         fontWeight: FontWeight.w600,
//                         color: Color(int.parse(option['color']!)),
//                       ),
//                     ),
//                     Text(
//                       option['subtitle']!,
//                       style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width * 0.03, // Adjusted font size
//                         fontWeight: FontWeight.w400,
//                         color: Color(int.parse(option['color']!)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       );
//     },
//   ),
// ),
// SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//Original inkwell of withdrawal
// InkWell(
//   onTap: () async {
//     await showModalBottomSheet(
//
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModelState) {
//             return SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.04,
//                   vertical: MediaQuery.of(context).size.height * 0.02,
//                 ),
//                 height: MediaQuery.of(context).size.height,
//                 // width: MediaQuery.of(context).size.width,
//                 constraints: BoxConstraints(
//                   minHeight: MediaQuery.of(context).size.height * 0.75, // Adjust height dynamically
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(28),
//                       topLeft: Radius.circular(28)
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AppBarText(
//                       color: Colors.black,
//                       text: "Withdraw Cash",
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     Divider(
//                       height: 1,
//                       color: Colors.grey.shade200,
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(width: 1, color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Image.asset('assets/cash.png', height: 16),
//                               SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                               Text(
//                                 "Current Balance",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "₹$currentBalance",
//                                 overflow: TextOverflow.clip,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.07,
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.05,
//                               width: MediaQuery.of(context).size.width / 1,
//                               child: ListView.builder(
//                                 itemCount: amount.length,
//                                 scrollDirection: Axis.horizontal,
//                                 itemBuilder: (context, index) {
//                                   return InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         selectedAmount = amount[index];
//                                         withdrawBalance.text = amount[index];
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
//                                       height: MediaQuery.of(context).size.height * 0.05,
//                                       width: MediaQuery.of(context).size.width * 0.2,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(color: Colors.grey.shade300, width: 1),
//                                       ),
//                                       child: Center(
//                                         child: Text("₹ ${amount[index]}"),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       height: 50, // Set a fixed height for one line of text
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.grey.shade300,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: withdrawBalance, // Make sure this controller is initialized
//                               decoration: InputDecoration(
//                                 hintText: "Withdraw Amount",
//                                 suffix: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 0.0000125), // To remove any extra padding
//                                   // alignment: Alignment.center,
//                                   child: InkWell(
//                                     onTap: () {
//                                       // Clear the input when the icon is tapped
//                                       withdrawBalance.clear();
//                                     },
//                                     child: Icon(Icons.remove_circle, color: Colors.grey),
//                                   ),
//                                 ),
//                                 hintStyle: TextStyle(
//                                   fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjusts vertical padding for one line
//                               ),
//                               style: TextStyle(
//                                 fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                               ),
//                               maxLines: 1, // Ensures the TextFormField does not exceed one line
//                             ),
//                           ),
//                           SizedBox(width: 10), // Add spacing if needed
//                           Text(
//                             "₹ ${withdrawBalance.text}",
//                             style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusted font size
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         NormalText(color: Colors.grey, text: "Enter UPI ID"),
//                         // Row(
//                         //   children: [
//                         //     NormalText(color: Colors.grey, text: "View All"),
//                         //     const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     SingleChildScrollView(
//                       child: Container(
//                         height: 50,
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(11),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 16), // Add padding for better spacing
//                         child: Center(
//                           child: TextFormField(
//                             controller: UPI_IDController,
//                             decoration: InputDecoration(
//                               hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                               hintText: 'Enter UPI ID', // Custom hint text
//                               border: InputBorder.none, // Remove the default border
//                             ),
//                             keyboardType: TextInputType.emailAddress, // UPI IDs are like email addresses
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Builder(
//                       builder: (context) => GestureDetector(
//                         onTap: () {
//                           String amountToAdd = withdrawBalance.text.trim();
//                           String UPI_ID = UPI_IDController.text.trim();
//
//                           if (double.tryParse(amountToAdd) != null) {
//                             double amount = double.parse(amountToAdd);
//                             if (amount < 200) {
//                               Fluttertoast.showToast(
//                                 msg: "Minimum withdrawal amount is ₹200",
//                                 toastLength: Toast.LENGTH_SHORT,
//                                 gravity: ToastGravity.BOTTOM,
//                                 timeInSecForIosWeb: 1,
//                                 backgroundColor: Colors.black54,
//                                 textColor: Colors.white,
//                                 fontSize: 14.0,
//                               );
//                             } else {
//                               withdrawWallet(amountToAdd, UPI_ID);
//                               Navigator.pop(context); // Close the screen after withdrawal
//                             }
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Invalid amount'),
//                               ),
//                             );
//                           }
//                         },
//                         child: Container(
//                           height: 45,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xff140B40),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Withdraw",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//
//           },
//         );
//       },
//     );
//   },
//
//   child: Container(
//     height: MediaQuery.of(context).size.height * 0.05, // Adjust height as needed
//     width: MediaQuery.of(context).size.width * 0.4,
//     decoration: BoxDecoration(
//       color:
//       const Color(0xff140B40).withOpacity(0.05),
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(
//         color: const Color(0xff140B40)
//             .withOpacity(0.3),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         "Verify to Withdraw",
//         style: TextStyle(
//           color: const Color(0xff140B40),
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     ),
//   ),
// ),

//blackbox.ai answer
// InkWell(
//   onTap: () async {
//     await showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModelState) {
//             return SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.04,
//                   vertical: MediaQuery.of(context).size.height * 0.02,
//                 ),
//                 height: MediaQuery.of(context).size.height,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(28),
//                     topLeft: Radius.circular(28),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AppBarText(color: Colors.black, text: "Withdraw Cash"),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     Divider(height: 1, color: Colors.grey.shade200),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(width: 1, color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Image.asset('assets/cash.png', height: 16),
//                               SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                               Text(
//                                 "Current Balance",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "₹$currentBalance",
//                                 overflow: TextOverflow.clip,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300, width: 1),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: withdrawBalance,
//                               decoration: InputDecoration(
//                                 hintText: "Withdraw Amount",
//                                 border: InputBorder.none,
//                                 suffix: InkWell(
//                                   onTap: () {
//                                     withdrawBalance.clear();
//                                   },
//                                   child: Icon(Icons.remove_circle, color: Colors.grey),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "₹ ${withdrawBalance.text}",
//                             style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width * 0.035,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         NormalText(color: Colors.grey, text: "Enter UPI ID"),
//                       ],
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     SingleChildScrollView(
//                       child: Container(
//                         height: 50,
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(11),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Center(
//                           child: TextFormField(
//                             controller: UPI_IDController,
//                             decoration: InputDecoration(
//                               hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                               hintText: 'Enter UPI ID',
//                               border: InputBorder.none,
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     GestureDetector(
//                       onTap: () {
//                         String amountToWithdraw = withdrawBalance.text.trim();
//                         String UPI_ID = UPI_IDController.text.trim();
//
//                         if (double.tryParse(amountToWithdraw) != null) {
//                           double amount = double.parse(amountToWithdraw);
//                           if (amount < 200) {
//                             Fluttertoast.showToast(
//                               msg: "Minimum withdrawal amount is ₹200",
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.BOTTOM,
//                               timeInSecForIosWeb: 1,
//                               backgroundColor: Colors.black54,
//                               textColor: Colors.white,
//                               fontSize: 14.0,
//                             );
//                           } else {
//                             withdrawWallet(amountToWithdraw, UPI_ID);
//                             Navigator.pop(context);
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Invalid amount')),
//                           );
//                         }
//                       },
//                       child: Container(
//                         height: 45,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color(0xff140B40),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "Withdraw",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   },
//   child: Container(
//     height: MediaQuery.of(context).size.height * 0.05,
//     width: MediaQuery.of(context).size.width * 0.4,
//     decoration: BoxDecoration(
//       color: const Color(0xff140B40).withOpacity(0.05),
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(
//         color: const Color(0xff140B40).withOpacity(0.3),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         "Verify to Withdraw",
//         style: TextStyle(
//           color: const Color(0xff140B40),
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     ),
//   ),
// ),

// suffix: Container(
//   height: 40, // Set this to the height of the TextFormField
//   width: 40,
//   child: Padding(
//     padding: const EdgeInsets.only(top: 8.0),
//     child: InkWell(
//       onTap: () {
//         addbalance.clear();
//       },
//       child: Icon(
//           Icons.remove_circle,
//           color: Colors.grey
//       ),
//     ),
//   ),
// ),
// InkWell(
//   onTap: () async {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.04,
//                   vertical: MediaQuery.of(context).size.height * 0.02,
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(28),
//                     topLeft: Radius.circular(28),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AppBarText(color: Colors.black, text: "Add Cash"),
//                     Divider(height: 1, color: Colors.grey.shade200),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       height: MediaQuery.of(context).size.height * 0.07,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(width: 1, color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Image.asset('assets/cash.png', height: MediaQuery.of(context).size.height * 0.02),
//                               SizedBox(width: MediaQuery.of(context).size.width * 0.02),
//                               Text(
//                                 "Current Balance",
//                                 style: TextStyle(
//                                   fontSize: MediaQuery.of(context).size.width * 0.045,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Icon(Icons.keyboard_arrow_down),
//                             ],
//                           ),
//                           Text(
//                             "₹$currentBalance",
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width * 0.045,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300, width: 1),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: addbalance,
//                               decoration: InputDecoration(
//                                 hintText: "Add Amount",
//                                 border: InputBorder.none,
//                               ),
//                               style: TextStyle(
//                                 fontSize: MediaQuery.of(context).size.width * 0.035,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "₹ ${addbalance.text}",
//                             style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width * 0.035,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     GestureDetector(
//                       onTap: () async {
//                         if (isProcessing) return;
//
//                         String amountToAdd = addbalance.text;
//                         if (double.tryParse(amountToAdd) != null) {
//                           double amount = double.parse(amountToAdd);
//                           if (amount <= 49) {
//                             Fluttertoast.showToast(
//                               msg: "Amount should be greater than 50",
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.BOTTOM,
//                               timeInSecForIosWeb: 1,
//                               backgroundColor: Colors.black54,
//                               textColor: Colors.white,
//                               fontSize: 14.0,
//                             );
//                           } else {
//                             setState(() {
//                               isProcessing = true;
//                             });
//                             await addwallet(amountToAdd);
//                             Navigator.pop(context);
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Invalid amount")),
//                           );
//                           // Scaffold.showSnackBar(
//                           //   SnackBar(
//                           //     content: Text('Invalid amount'),
//                           //   ),
//                           // );
//                         }
//                       },
//                       child: Container(
//                         height: 45,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: Color(0xff140B40),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Add",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: MediaQuery.of(context).size.width * 0.04,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   },
//   child: Container(
//     height: MediaQuery.of(context).size.height * 0.05,
//     width: MediaQuery.of(context).size.width * 0.4,
//     decoration: BoxDecoration(
//       color: const Color(0xff140B40).withOpacity(0.05),
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(
//         color: const Color(0xff140B40).withOpacity(0.3),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         "Add Cash",
//         style: TextStyle(
//           color: const Color(0xff140B40),
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     ),
//   ),
// ),
//   ],
// ),
// height: MediaQuery.of(context).size.height,
// constraints: BoxConstraints(
//   minHeight: MediaQuery.of(context).size.height * 0.75,
// ),

// difference = currentBalanceValue - withdrawAmount; // Update difference
// if (difference < 0) {
//   difference = 0.0;
//   withdrawBalance.text = currentBalanceValue.toString();
//   Fluttertoast.showToast(
//     msg: "Cannot withdraw more than current balance",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.black54,
//     textColor: Colors.white ,
//     fontSize: 14.0,
//   );
// }
