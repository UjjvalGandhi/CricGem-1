import 'dart:convert';

import 'package:batting_app/services/get_server_key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotifcationUsingApi({
    required String title,
    required String body,
    required String token,
    required Map<String, dynamic>? data,
}) async{
    String serverkey = await GetServerKey().getServerKeyToken();

    String url = "https://fcm.googleapis.com/v1/projects/batting-app-ce894/messages:send";

    var headers= <String, String>{
      "Content-Type": "application/json",
      "Authorization" :" Bearer $serverkey"
    };

    Map<String, dynamic> message = {
      "message":{
        "token": token,
        "notification":{"body": body, "title": title,},
        "data" : data,
      }
    };

    // api hit
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );
    if(response.statusCode == 200) {
      print("Notification send successfully");
    }
    else{
      print("Notification send failed");
    }
  }
}