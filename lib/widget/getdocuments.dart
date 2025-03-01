import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/GetDocument.dart';

class DocumentProvider with ChangeNotifier {
  GetDocuments? _documentDetails;
  bool _isLoading = false;

  GetDocuments? get documentDetails => _documentDetails;
  bool get isLoading => _isLoading;



  Future<void> fetchDocumentDetails() async {
    if (_isLoading) return; // Prevent duplicate fetches
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/document/display'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      print('Error in this1111111111${response.statusCode}');
      print('Error in this2222222${response.body}');

      // if (response.statusCode == 200) {
      //   print('Error in this${response.body}');
      //   _contestData = JoinContestModel.fromJson(jsonDecode(response.body));
      // } else {
      //   _errorMessage = 'Failed to fetch contest data: ${response.statusCode}';
      // }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('data fetch successfully documents');
        _documentDetails = GetDocuments.fromJson(data);
      }  else if (response.statusCode == 404) {
        // Handle case where no documents are found
        _documentDetails = null;
      } else {
        throw Exception('Failed to fetch document details: ${response.reasonPhrase}');
      }
    } catch (error) {
      debugPrint('Error fetching documents: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Future<void> fetchDocumentDetails() async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final uri = Uri.parse('https://batting-api-1.onrender.com/api/document/display');
  //     final response = await http.get(uri);
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('data fetch successfully documents');
  //       _documentDetails = GetDocuments.fromJson(data);
  //     } else {
  //       throw Exception('Failed to fetch document details: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     debugPrint('Error fetching documents: $error');
  //     rethrow;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  // Future<void> fetchDocumentDetails() async {
  //   if (_isLoading) return; // Prevent duplicate fetches
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     String? token = await AppDB.appDB.getToken();
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://batting-api-1.onrender.com/api/document/display'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Authorization": "$token",
  //       },
  //     );
  //     print('Error in this1111111111${response.statusCode}');
  //     print('Error in this2222222${response.body}');
  //
  //     // if (response.statusCode == 200) {
  //     //   print('Error in this${response.body}');
  //     //   _contestData = JoinContestModel.fromJson(jsonDecode(response.body));
  //     // } else {
  //     //   _errorMessage = 'Failed to fetch contest data: ${response.statusCode}';
  //     // }
  //     if (response.statusCode == 200) {
  //             final data = jsonDecode(response.body);
  //             print('data fetch successfully documents');
  //             _documentDetails = GetDocuments.fromJson(data);
  //           } else {
  //             throw Exception('Failed to fetch document details: ${response.reasonPhrase}');
  //           }
  //   } catch (error) {
  //         debugPrint('Error fetching documents: $error');
  //         rethrow;
  //       } finally {
  //         _isLoading = false;
  //         notifyListeners();
  //       }
  // }
}
