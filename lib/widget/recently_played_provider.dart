import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/RecentlyPlayedUserMatchModel.dart';

class RecentlyPlayedMatchProvider extends ChangeNotifier {
  RecentlyPlayedUserMatchModel? _recentMatchData;
  bool _isLoading = false;
  String? _error;

  RecentlyPlayedUserMatchModel? get recentMatchData => _recentMatchData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecentlyPlayedMatch(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/lastRecentlyMatchUser'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _recentMatchData = RecentlyPlayedUserMatchModel.fromJson(jsonData);
        _error = null;
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        print('failed to load data recently ${response.statusCode}');
        print('failed to load data recently ${response.body}');

      }
    } catch (e) {
      _error = 'Error fetching data: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
