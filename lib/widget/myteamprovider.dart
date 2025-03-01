import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/MyTeamListModel.dart';
class MyTeamProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  MyTeamLIstModel? myTeamList;

  Future<void> fetchMyTeamData(String? matchID) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/myTeam/displaybymatch?matchId=$matchID'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        myTeamList = MyTeamLIstModel.fromJson(jsonDecode(response.body));
      } else {
        errorMessage = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
