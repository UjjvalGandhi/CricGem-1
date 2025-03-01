import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:batting_app/screens/country/contest_fees_screen.dart';
import 'package:batting_app/screens/deposite_screen.dart';
import 'package:batting_app/screens/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../db/app_db.dart';
import '../model/AddWalletModel.dart';
import '../widget/appbartext.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AddWallateModlel? walletData;
  bool isLoading = true;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index; // Update current tab index
      });
    });

  }
  Future<Uint8List> loadImageFromAssets(String path) async {
    return await rootBundle.load(path).then((data) => data.buffer.asUint8List());
  }
  Future<Uint8List> loadImageFromFile(String filePath) async {
    return await File(filePath).readAsBytes();
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

  String paymentTypeLabel(PaymentType paymentType) {
    switch (paymentType) {
      case PaymentType.CONTEST_FEE:
        return "Contest Fee";
      case PaymentType.WITHDRAW:
        return "Withdrawal Fee";
      case PaymentType.ADD_WALLET:
        return "Deposit Fee";
      case PaymentType.WINNING_AMOUNT:
        return "Winning Amount";
      default:
        return "Unknown Fee";
    }
  }
  void _downloadPDF() async {
    try {
      // Initialize the PDF document
      final pdf = pw.Document();

      // Load the asset image
      final imageBytes = await rootBundle.load('assets/deposit.webp');
      final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

      // Choose tab content based on the current tab index
      List<dynamic> tabData = [];
      String tabTitle;

      if (walletData != null) {
        switch (_currentTabIndex) {
          case 0: // Contests
            tabData = walletData!.data
                .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
                .toList();
            tabTitle = "Contests Transactions";
            break;
          case 1: // Withdrawals
            tabData = walletData!.data
                .where((item) => item.paymentType == PaymentType.WITHDRAW)
                .toList();
            tabTitle = "Withdrawals Transactions";
            break;
          case 2: // Deposits
            tabData = walletData!.data
                .where((item) => item.paymentType == PaymentType.ADD_WALLET ||  item.paymentType == PaymentType.WINNING_AMOUNT)
                .toList();
            tabTitle = "Deposits Transactions";
            break;
          default:
            Fluttertoast.showToast(
              msg: "No data to export",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            return;
        }

        if (tabData.isEmpty) {
          Fluttertoast.showToast(
            msg: "No data to export",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return;
        }
      } else {
        Fluttertoast.showToast(
          msg: "No data to export",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      // Method to add a page with transactions
      void addTransactionsPage(pw.Document pdf, List<dynamic> transactions) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    tabTitle,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#000000"),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 20),
                  for (var item in transactions) ...[
                    pw.Container(
                      margin: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#FFFFFF"),
                        borderRadius: pw.BorderRadius.circular(12),
                        border: pw.Border.all(color: PdfColor.fromHex("#E0E0E0"), width: 1),
                      ),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                width: 40,
                                height: 40,
                                child: pw.Image(image, fit: pw.BoxFit.cover),
                              ),
                              pw.SizedBox(width: 12),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    item.status.toString().split('.').last,
                                    style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex("#000000"),
                                    ),
                                  ),
                                  pw.Text(
                                    DateFormat('yyyy-MM-dd').format(item.createdAt),
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      color: PdfColor.fromHex("#757575"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                "Rs.${item.amount}",
                                style: pw.TextStyle(
                                  fontSize : 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex("#4CAF50"),
                                ),
                              ),
                              pw.Text(
                                paymentTypeLabel(item.paymentType),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromHex("#757575"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (item != transactions.last) pw.SizedBox(height: 10), // Add space between items
                  ],
                ],
              );
            },
          ),
        );
      }

      // Add transactions to the PDF, handling multiple pages
      int itemsPerPage = 7; // Adjust this number based on your layout
      for (int i = 0; i < tabData.length; i += itemsPerPage) {
        int end = (i + itemsPerPage < tabData.length) ? i + itemsPerPage : tabData.length;
        addTransactionsPage(pdf, tabData.sublist(i, end));
      }

      // Get the Downloads directory
      Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
      DateTime now = DateTime.now();
      String fileName =
          "$tabTitle ${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf";
      final file = File("${downloadsDirectory.path}/$fileName");

      // Save the PDF file
      await file.writeAsBytes(await pdf.save());

      Fluttertoast.showToast(
        msg: "PDF downloaded to ${file.path}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to download PDF: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      debugPrint('error is :-${e.toString()}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor: const Color(0xffF0F1F5),
            backgroundColor: const Color(0xffF0F1F5),
            // Custom background color
            elevation: 0,
            // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                        child:
                        const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      AppBarText(
                          color: Colors.white, text: "Transaction History"),
                      GestureDetector(
                          onTap: () {
                            String tabName;
                          switch (_currentTabIndex) {
                            case 0:
                              tabName = "Contest screen";
                              break;
                            case 1:
                              tabName = "Withdrawals screen";
                              break;
                            case 2:
                              tabName = "Deposits screen";
                              break;
                            default:
                              tabName = "Unknown screen";
                          }
                            _downloadPDF();
                            Fluttertoast.showToast(
                              msg: "Download button clicked from $tabName",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                          },
                          child: const Icon(Icons.file_download_outlined,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Container(
          color: const Color(0xffF0F1F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 20),
              Container(
                height: 48,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.white,
                child: TabBar(
                  // tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: false,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  // Adjust the indicator padding
                  labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  indicatorColor: const Color(0xff140B40),
                  labelColor: const Color(0xff140B40),
                  tabs: const [
                    // Tab(text: "Contests"),
                    // Tab(text: "Withdrawals"),
                    // Tab(text: "Deposits"),
                    Tab(
                      child: Center(
                        child: Text("Contests", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Center(
                        child: Text("Withdrawals", textAlign: TextAlign.center),
                      ),
                    ),
                    Tab(
                      child: Center(
                        child: Text("Deposits", textAlign: TextAlign.center),
                      ),
                    ),
                    // Tab(text: "TDS"),
                    // Tab(text: "Others"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    // Tab 1 Content
                    ContestFeesScreen(),
                    // Tab 2 Content
                    Withdrawalsscreen(),
                    // Tab 3 Content
                    Depositescreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// void _downloadPDF() async {
//   try {
//
//     // Initialize the PDF document
//     final pdf = pw.Document();
//
//     // Load the asset image
//     final imageBytes = await rootBundle.load('assets/deposit.webp');
//     final image = pw.MemoryImage(imageBytes.buffer.asUint8List());
//
//     // Choose tab content based on the current tab index
//     List<dynamic> tabData = [];
//     String tabTitle;
//
//     if (walletData != null) {
//       switch (_currentTabIndex) {
//         case 0: // Contests
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//               .toList();
//           tabTitle = "Contests Transactions";
//           break;
//         case 1: // Withdrawals
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.WITHDRAW)
//               .toList();
//           tabTitle = "Withdrawals Transactions";
//           break;
//         case 2: // Deposits
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.ADD_WALLET)
//               .toList();
//           tabTitle = "Deposits Transactions";
//           break;
//         default:
//           Fluttertoast.showToast(
//             msg: "No data to export",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//           );
//           return;
//       }
//
//       if (tabData.isEmpty) {
//         Fluttertoast.showToast(
//           msg: "No data to export",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//         return;
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "No data to export",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               // Centered Tab Title
//               pw.Text(
//                 tabTitle,
//                 style: pw.TextStyle(
//                   fontSize: 24,
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#000000"),
//                 ),
//                 textAlign: pw.TextAlign.center,
//               ),
//
//               pw.SizedBox(height: 20), // Space after title
//
//               // Transaction Cards
//               for (var item in tabData)
//                 pw.Container(
//                   margin: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Spacing around each card
//                   padding: pw.EdgeInsets.all(16), // Padding inside the card
//                   decoration: pw.BoxDecoration(
//                     color: PdfColor.fromHex("#FFFFFF"),
//                     borderRadius: pw.BorderRadius.circular(12), // Rounded corners
//                     border: pw.Border.all(color: PdfColor.fromHex("#E0E0E0"), width: 1),
//                   ),
//                   child: pw.Row(
//                     crossAxisAlignment: pw.CrossAxisAlignment.center,
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Left side: Image and Texts
//                       pw.Row(
//                         crossAxisAlignment: pw.CrossAxisAlignment.center,
//                         children: [
//                           // Image
//                           pw.Container(
//                             width: 40,
//                             height: 40,
//                             child: pw.Image(image, fit: pw.BoxFit.cover),
//                           ),
//                           pw.SizedBox(width: 12), // Space between image and texts
//
//                           // Text Column
//                           pw.Column(
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               // Status Text
//                               pw.Text(
//                                 item.status.toString().split('.').last,
//
//                                 // item['status'].toString().toUpperCase(),
//                                 style: pw.TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: pw.FontWeight.bold,
//                                   color: PdfColor.fromHex("#000000"),
//                                 ),
//                               ),
//                               // Time and Date
//                               pw.Text(
//                                 DateFormat('yyyy-MM-dd').format(item.createdAt),
//
//                                 // "${item['time']} - ${item['date']}",
//                                 style: pw.TextStyle(
//                                   fontSize: 12,
//                                   color: PdfColor.fromHex("#757575"),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                       // Right side: Amount and Fee Type
//                       pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.end,
//                         children: [
//                           // Amount
//                           pw.Text(
//                             "₹ ${item.amount}",
//
//                             // "- ₹${item['amount']}",
//                             style: pw.TextStyle(
//                               fontSize: 14,
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromHex("#4CAF50"),
//                             ),
//                           ),
//                           // Payment Type
//
//                           pw.Text(
//                             paymentTypeLabel(item.paymentType),
//
//                             // '${item.paymentType}',
//                             // item['feeType'],
//                             style: pw.TextStyle(
//                               fontSize: 12,
//                               color: PdfColor.fromHex("#757575"),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//
//     // best with image and container
//     // pdf.addPage(
//     //   pw.Page(
//     //     build: (pw.Context context) {
//     //       return pw.Column(
//     //         crossAxisAlignment: pw.CrossAxisAlignment.center,
//     //         children: [
//     //           pw.Text(tabTitle, style: pw.TextStyle(fontSize: 24),textAlign: pw.TextAlign.center),
//     //           pw.SizedBox(height: 20),
//     //           for (var item in tabData)
//     //             pw.Container(
//     //               margin: pw.EdgeInsets.symmetric(vertical: 8), // Spacing between cards
//     //               decoration: pw.BoxDecoration(
//     //                 color: PdfColor.fromHex("#F0F1F5"),
//     //                 borderRadius: pw.BorderRadius.circular(8),
//     //                 border: pw.Border.all(color: PdfColor.fromHex("#D1D1D1"), width: 1),
//     //               ),
//     //               padding: pw.EdgeInsets.all(12),
//     //               child: pw.Row(
//     //                 crossAxisAlignment: pw.CrossAxisAlignment.center,
//     //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//     //                 children: [
//     //                   pw.Image(image, width: 40, height: 40), // Add image here
//     //                   pw.SizedBox(width: 12),
//     //                   pw.Expanded(
//     //                     child: pw.Column(
//     //                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//     //                       children: [
//     //                         pw.Text(
//     //                           item.status.toString().split('.').last,
//     //                           style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//     //                         ),
//     //                         pw.Text(
//     //                           DateFormat('yyyy-MM-dd').format(item.createdAt),
//     //                           style: pw.TextStyle(fontSize: 12, color: PdfColor.fromHex("#757575")),
//     //                         ),
//     //
//     //                       ],
//     //                     ),
//     //                   ),
//     //
//     //                   pw.Text(
//     //                     "₹ ${item.amount}",
//     //                     style: pw.TextStyle(fontSize: 14, color: PdfColor.fromHex("#4CAF50")),
//     //                     textAlign: pw.TextAlign.end,
//     //                   ),
//     //                 ],
//     //               ),
//     //             ),
//     //         ],
//     //       );
//     //     },
//     //   ),
//     // );
//
//
//     // Get the Downloads directory
//     Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
//     DateTime now = DateTime.now();
//     String fileName =
//         "${tabTitle}${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf";
//     final file = File("${downloadsDirectory.path}/$fileName");
//
//     // Save the PDF file
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
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: "Failed to download PDF: $e",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
//     print('error is :-${e.toString()}');
//   }
//
// }


// void _downloadPDF() async {
//   try {
//     // Initialize the PDF document
//     final pdf = pw.Document();
//
//     // Choose tab content based on the current tab index
//     List<dynamic> tabData = [];
//     String tabTitle;
//
//     if (walletData != null) {
//       switch (_currentTabIndex) {
//         case 0: // Contests
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//               .toList();
//           tabTitle = "Contests Transactions";
//           break;
//         case 1: // Withdrawals
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.WITHDRAW)
//               .toList();
//           tabTitle = "Withdrawals Transactions";
//           break;
//         case 2: // Deposits
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.ADD_WALLET)
//               .toList();
//           tabTitle = "Deposits Transactions";
//           break;
//         default:
//           Fluttertoast.showToast(
//             msg: "No data to export",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//           );
//           return;
//       }
//
//       if (tabData.isEmpty) {
//         Fluttertoast.showToast(
//           msg: "No data to export",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//         return;
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "No data to export",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     // Load the images before building the PDF
//     List<Uint8List> images = [];
//     for (var item in tabData) {
//       // Load the image for each item (assuming the same image for simplicity)
//       print('images are stored11111111111111111 $item');
//
//       Uint8List imageData = await loadImageFromAssets('assets/deposit.webp');
//       images.add(imageData);
//       print('images are stored $imageData');
//     }
//
//     // Build the PDF content
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(tabTitle, style: pw.TextStyle(fontSize: 24)),
//               pw.SizedBox(height: 20),
//               for (int i = 0; i < tabData.length; i++)
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Image(pw.MemoryImage(images[i])), // Use the loaded image
//                     pw.Text(tabData[i].status.toString().split('.').last),
//                     pw.Text("- ₹${tabData[i].amount}"),
//                     pw.Text(DateFormat('yyyy-MM-dd').format(tabData[i].createdAt)),
//                   ],
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//
//     // Get the Downloads directory
//     Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
//     DateTime now = DateTime.now();
//     String fileName = "Transaction_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf";
//     final file = File("${downloadsDirectory.path}/$fileName");
//
//     // Save the PDF file
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
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: "Failed to download PDF: $e",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
//   }
// }


// void _downloadPDF() async {
//   try {
//     // Initialize the PDF document
//     final pdf = pw.Document();
//
//     // Choose tab content based on the current tab index
//     List<dynamic> tabData = [];
//     String tabTitle;
//
//     if (walletData != null) {
//       switch (_currentTabIndex) {
//         case 0: // Contests
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//               .toList();
//           tabTitle = "Contests Transactions";
//           break;
//         case 1: // Withdrawals
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.WITHDRAW)
//               .toList();
//           tabTitle = "Withdrawals Transactions";
//           break;
//         case 2: // Deposits
//           tabData = walletData!.data
//               .where((item) => item.paymentType == PaymentType.ADD_WALLET)
//               .toList();
//           tabTitle = "Deposits Transactions";
//           break;
//         default:
//           Fluttertoast.showToast(
//             msg: "No data to export",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//           );
//           return;
//       }
//
//       // Debugging: Check the filtered data
//       print("Filtered Data for $tabTitle: $tabData");
//
//       if (tabData.isEmpty) {
//         Fluttertoast.showToast(
//           msg: "No data to export",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//         return;
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "No data to export",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     // Build the PDF content
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(tabTitle, style: pw.TextStyle(fontSize: 24)),
//               pw.SizedBox(height: 20),
//               for (var item in tabData)
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//           // pw.Image(pw.MemoryImage( loadImageFromAssets('assets/deposit.webp'))), // Adjust path as needed
//                    pw.Text(item.status.toString().split('.').last),
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
//     // Get the Downloads directory
//     Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
//     DateTime now = DateTime.now();
//     String fileName = "Transaction_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf";
//     final file = File("${downloadsDirectory.path}/$fileName");
//
//     // Save the PDF file
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
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: "Failed to download PDF: $e",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
//   }
// }


// void _downloadPDF() async {
//   try {
//     // Initialize the PDF document
//     final pdf = pw.Document();
//
//     // Choose tab content based on the current tab index
//     List<dynamic> tabData;
//     String tabTitle;
//     if (_currentTabIndex == 0 && walletData != null) {
//       tabData = walletData!.data
//           .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//           .toList();
//       tabTitle = "Contests Transactions";
//     } else if (_currentTabIndex == 1 && walletData != null) {
//       tabData = walletData!.data
//           .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//           .toList();
//       tabTitle = "Withdrawals Transactions";
//     } else if (_currentTabIndex == 2 && walletData != null) {
//       tabData = walletData!.data
//           .where((item) => item.paymentType == PaymentType.CONTEST_FEE)
//           .toList();
//       tabTitle = "Deposits Transactions";
//     } else {
//       Fluttertoast.showToast(
//         msg: "No data to export",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     // Build the PDF content
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(tabTitle, style: pw.TextStyle(fontSize: 24)),
//               pw.SizedBox(height: 20),
//               for (var item in tabData)
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
//     // Get the Downloads directory
//     Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
//     DateTime now = DateTime.now();
//     String fileName = "Transaction_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf";
//     final file = File("${downloadsDirectory.path}/$fileName");
//
//     // Save the PDF file
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
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: "Failed to download PDF: $e",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
//   }
// }






// Future<void> _downloadPDF() async {
//   final pdf = pw.Document();
//
//   // Create a PDF page with the transaction data
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           children: [
//             pw.Text('Transaction History', style: pw.TextStyle(fontSize: 24)),
//             pw.SizedBox(height: 20),
//             // Assuming walletData is not null and has a data property
//             for (var item in walletData!.data)
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(item.status.toString().split('.').last),
//                   pw.Text("- ₹${item.amount}"),
//                   pw.Text(DateFormat('yyyy-MM-dd').format(item.createdAt)),
//                 ],
//               ),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Get the directory to save the PDF
//   // final output = await getTemporaryDirectory();
//   Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
//   DateTime now = DateTime.now();
//   String formattedDate = "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}";
//   final file = File("${downloadsDirectory.path}/download${formattedDate}.pdf");
//   await file.writeAsBytes(await pdf.save());
//
//   Fluttertoast.showToast(
//     msg: "PDF downloaded to ${file.path}",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.black54,
//     textColor: Colors.white,
//     fontSize: 14.0,
//   );
// }


// // Tab 4 Content
// Center(
//   child: Text(
//     "Tab 4 Content",
//     style: TextStyle(fontSize: 20),
//   ),
// ),
// // Tab 5 Content
// Center(
//   child: Text(
//     "Tab 5 Content",
//     style: TextStyle(fontSize: 20),
//   ),
// ),


  // Widget _buildContestTab() {
  //   return Container(
  //     child: Stack(children: [
  //       Container(
  //         width: MediaQuery.of(context).size.height,
  //         padding: const EdgeInsets.symmetric(horizontal: 15),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SmallText(color: Colors.grey, text: "26 April, 2024"),
  //             SizedBox(
  //               height: 3,
  //             ),
  //             Container(
  //               height: 135,
  //               width: MediaQuery.of(context).size.width,
  //               padding: const EdgeInsets.all(15),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(16)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/color.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black, text: "Winnings"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   Container(
  //                     height: 1,
  //                     width: MediaQuery.of(context).size.width,
  //                     color: Colors.grey.shade300,
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/grey.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black,
  //                                       text: "Offer Applied"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SmallText(color: Colors.grey, text: "16 April, 2024"),
  //             SizedBox(
  //               height: 3,
  //             ),
  //             Container(
  //               height: 135,
  //               width: MediaQuery.of(context).size.width,
  //               padding: const EdgeInsets.all(15),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(16)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/color.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black, text: "Winnings"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   Container(
  //                     height: 1,
  //                     width: MediaQuery.of(context).size.width,
  //                     color: Colors.grey.shade300,
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/grey.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black,
  //                                       text: "Offer Applied"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SmallText(color: Colors.grey, text: "06 April, 2024"),
  //             SizedBox(
  //               height: 3,
  //             ),
  //             Container(
  //               height: 135,
  //               width: MediaQuery.of(context).size.width,
  //               padding: const EdgeInsets.all(15),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(16)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/color.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black, text: "Winnings"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   Container(
  //                     height: 1,
  //                     width: MediaQuery.of(context).size.width,
  //                     color: Colors.grey.shade300,
  //                   ),
  //                   SizedBox(
  //                     height: 6,
  //                   ),
  //                   SizedBox(
  //                     height: 42,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Image.asset(
  //                               'assets/grey.png',
  //                               height: 37,
  //                               color: Color(0xff140B40),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Normal2Text(
  //                                       color: Colors.black,
  //                                       text: "Offer Applied"),
  //                                   Small2Text(
  //                                       color: Colors.grey,
  //                                       text: "11:10 PM | RR vs RCB")
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "+ ₹59",
  //                               style: TextStyle(
  //                                   color: const Color(0xff140B40),
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             )
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       Positioned(
  //         bottom: 0,
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20),
  //           height: 60,
  //           width: MediaQuery.of(context).size.width,
  //           color: Colors.white,
  //           child: SizedBox(
  //             height: 60,
  //             width: MediaQuery.of(context).size.width,
  //             child: Row(
  //               children: [
  //                 Container(
  //                   height: 30,
  //                   width: 95,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15),
  //                     color: Colors.white,
  //                     border: Border.all(color: const Color(0xff140B40)),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       const Text(
  //                         "Entry",
  //                         style: TextStyle(
  //                           color: Color(0xff140B40),
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: 2,
  //                       ),
  //                       Image.asset(
  //                         "assets/cross.png",
  //                         height: 12,
  //                         color: const Color(0xff140B40),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 200,
  //                 ),
  //                 Row(
  //                   children: [
  //                     Container(
  //                       height: 60,
  //                       width: 1,
  //                       color: Colors.grey.shade300,
  //                     ),
  //                     InkWell(
  //                         child: Image.asset(
  //                       'assets/Frame 5025 (1).png',
  //                       height: 50,
  //                     ))
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }
// }
