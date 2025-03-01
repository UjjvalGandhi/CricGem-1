// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'model/chat_disply_screen_model.dart';
// // Adjust the path accordingly
//
// class ApiService {
//   Future<chatscreendisplayModel> fetchChatData() async {
//     final url = 'https://example.com/api/chat'; // Replace with your actual API endpoint
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return chatscreendisplayModel.fromJson(jsonResponse);
//     } else {
//       throw Exception('Failed to load chat data');
//     }
//   }
// }
