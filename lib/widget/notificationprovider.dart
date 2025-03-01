import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/app_db.dart';

class NotificationProvider with ChangeNotifier {
  List<Map<String, String>> _notifications = [];
  bool _isLoading = false;

  List<Map<String, String>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token: $token');

      final response = await http.get(
        Uri.parse(
          'https://batting-api-1.onrender.com/api/notification/displayNotification',
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success']) {
          _notifications = responseData['data']
              .map<Map<String, String>>((notification) {
            return {
              "title": notification["title"]?.toString() ?? "No Title",
              "message": notification["message"]?.toString() ?? "No Message",
              "dateAndTime": notification["dateAndTime"]?.toString() ??
                  "No dateAndTime",
            };
          }).toList();
        } else {
          debugPrint('API Response Error: ${responseData['message']}');
        }
      } else {
        debugPrint('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatDate(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  String formatTime(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.hour}:${parsedDate.minute}";
    } catch (e) {
      return "Invalid Time";
    }
  }
}
