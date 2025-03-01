import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/JoinContestModel.dart';

class JoinContestProvider with ChangeNotifier {
  JoinContestModel? _contestData;
  bool _isLoading = false;
  String? _errorMessage;

  JoinContestModel? get contestData => _contestData;
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
            'https://batting-api-1.onrender.com/api/joinContest/mycontests?matchId=$matchId'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print('Error in this1111111111${response.statusCode}');
      print('Error in this2222222${response.body}');

      if (response.statusCode == 200) {
        print('Error in this${response.body}');
        _contestData = JoinContestModel.fromJson(jsonDecode(response.body));
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
// import '../model/JoinContestModel.dart';
//
// class JoinContestProvider with ChangeNotifier {
//   JoinContestModel? _contestData;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   JoinContestModel? get contestData => _contestData;
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
//         Uri.parse(
//             'https://batting-api-1.onrender.com/api/joinContest/mycontests?matchId=$matchId'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         _contestData = JoinContestModel.fromJson(jsonDecode(response.body));
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
