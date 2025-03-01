import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/app_db.dart';
import '../model/WalletModel.dart';
// Replace with the actual path to your AppDB class

class WalletProvider with ChangeNotifier {
  WalletModel? _walletData;
  String? _error;
  bool _isLoading = false;

  WalletModel? get walletData => _walletData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchWalletData() async {
    _isLoading = true;
    notifyListeners();
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
        _walletData = WalletModel.fromJson(jsonDecode(response.body));
        _error = null;
      } else {
        _error = 'Failed to fetch wallet data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching wallet data: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
