import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/AddWalletModel.dart';
import '../db/app_db.dart'; // Import your local database class for token retrieval

AddWallateModlel? walletData; // Global variable to store the fetched wallet data

/// Function to fetch and cache wallet data
Future<void> fetchAndCacheWalletData() async {
  try {
    String? token = await AppDB.appDB.getToken(); // Retrieve token from database
    debugPrint('Token: $token');

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
      walletData = data; // Cache the fetched data globally
      debugPrint('Wallet data fetched and cached successfully.');
    } else {
      debugPrint('Failed to fetch wallet data: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error fetching wallet data: $e');
  }
}

// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import '../model/AddWalletModel.dart';
// import '../db/app_db.dart'; // Import your local database class for token retrieval
//
// AddWallateModlel? walletData;
//
// // Function to fetch and cache wallet data
// Future<void> fetchAndCacheWalletData() async {
//   try {
//     String? token = await AppDB.appDB.getToken();
//     debugPrint('Token: $token');
//
//     final response = await http.get(
//       Uri.parse('https://batting-api-1.onrender.com/api/transaction/show'),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "$token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = AddWallateModlel.fromJson(json.decode(response.body));
//       walletData = data; // Cache the fetched data globally
//       debugPrint('Wallet data fetched and cached successfully.');
//     } else {
//       debugPrint('Failed to fetch wallet data: ${response.statusCode}');
//     }
//   } catch (e) {
//     debugPrint('Error fetching wallet data: $e');
//   }
// }
