import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/ContestModel.dart'; // Ensure this is the correct file

class ContestProvider with ChangeNotifier {
  ContestModlel? _contestData;
  bool _isLoading = false;
  String? _errorMessage;

  ContestModlel? get contestData => _contestData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchContestData(String matchId) async {
    if (_isLoading) return; // Prevent duplicate fetches
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/match/displaycontests?matchId=$matchId'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        _contestData = ContestModlel.fromJson(jsonDecode(response.body));
      } else {
        _errorMessage = 'Failed to fetch contest data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching contest data: $e';
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../db/app_db.dart';
// import '../model/ContestModel.dart'; // Ensure this is the correct file
//
// class ContestProvider with ChangeNotifier {
//   ContestModlel? _contestData;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   ContestModlel? get contestData => _contestData;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//
//   Future<void> fetchContestData(String matchId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       String? token = await AppDB.appDB.getToken();
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/match/displaycontests?matchId=$matchId'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         _contestData = ContestModlel.fromJson(jsonDecode(response.body));
//       } else {
//         _errorMessage = 'Failed to fetch contest data: ${response.statusCode}';
//       }
//     } catch (e) {
//       _errorMessage = 'Error fetching contest data: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }