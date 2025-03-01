// To parse this JSON data, do
//
//     final notificationModal = notificationModalFromJson(jsonString);

import 'dart:convert';

NotificationModal notificationModalFromJson(String str) => NotificationModal.fromJson(json.decode(str));

String notificationModalToJson(NotificationModal data) => json.encode(data.toJson());

class NotificationModal {
  bool success;
  String message;
  List<Datum> data;

  NotificationModal({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationModal.fromJson(Map<String, dynamic> json) => NotificationModal(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String userId;
  String title;
  String message;
  DateTime dateAndTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Datum({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.dateAndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    userId: json["user_id"],
    title: json["title"],
    message: json["message"],
    dateAndTime: DateTime.parse(json["dateAndTime"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "title": title,
    "message": message,
    "dateAndTime": dateAndTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
