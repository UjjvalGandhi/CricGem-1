import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/ProfileDisplay.dart';

class ProfileProvider extends ChangeNotifier {
  String? name;
  String? profilePhotoUrl;
  int? totalMatches;
  int? totalContest;
  var winningAmount;
  int? totalWinContest;
  int? seriesCount;
  bool isProfileFetched = false;
  bool? isVerifed;
  Future<void> fetchProfileData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        final data = ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
        name = data.data?.name ?? '';
        profilePhotoUrl = data.data?.profilePhoto ?? '';
        totalMatches = data.totalMatches;
        totalContest = data.totalContest;
        winningAmount = data.totalWinning;
        totalWinContest = data.totalWinningContest;
        seriesCount = data.series;
        isProfileFetched = true;
        isVerifed = data.isVerify;

        notifyListeners(); // Notify listeners of the state change
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
  }
}
