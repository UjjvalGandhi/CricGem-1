import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';

class LeagueProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  HomeLeagModel? _data;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HomeLeagModel? get data => _data;

  Future<void> fetchLeagueData() async {
    if (_isLoading) return; // Prevent duplicate fetches
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? token = await AppDB.appDB.getToken(); // Fetch token from DB
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/desbord_details'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print("token : $token");

      if (response.statusCode == 200) {
        _data = HomeLeagModel.fromJson(jsonDecode(response.body));
      } else {
        _errorMessage = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../db/app_db.dart';
// import '../model/Homeleagmodel.dart';
//
//
// class LeagueProvider with ChangeNotifier {
//   bool _isLoading = false;
//   String? _errorMessage;
//   HomeLeagModel? _data;
//
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   HomeLeagModel? get data => _data;
//
//   Future<void> fetchLeagueData() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       String? token = await AppDB.appDB.getToken(); // Fetch token from DB
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/user/desbord_details'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         _data = HomeLeagModel.fromJson(jsonDecode(response.body));
//       } else {
//         _errorMessage = 'Failed to fetch data: ${response.statusCode}';
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
