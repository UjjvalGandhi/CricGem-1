// To parse this JSON data, do
//
//     final getDocuments = getDocumentsFromJson(jsonString);

import 'dart:convert';

GetDocuments getDocumentsFromJson(String str) => GetDocuments.fromJson(json.decode(str));

String getDocumentsToJson(GetDocuments data) => json.encode(data.toJson());

class GetDocuments {
  bool success;
  String message;
  Data data;

  GetDocuments({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetDocuments.fromJson(Map<String, dynamic> json) => GetDocuments(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String userId;
  String adhaarCardFrontPhoto;
  String adhaarCardBackPhoto;
  String adhaarCardStatus;
  int adhaarCardNum;
  String panCardFrontPhoto;
  String panCardBackPhoto;
  String panCardStatus;
  String panCardNum;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Data({
    required this.id,
    required this.userId,
    required this.adhaarCardFrontPhoto,
    required this.adhaarCardBackPhoto,
    required this.adhaarCardStatus,
    required this.adhaarCardNum,
    required this.panCardFrontPhoto,
    required this.panCardBackPhoto,
    required this.panCardStatus,
    required this.panCardNum,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    userId: json["user_id"],
    adhaarCardFrontPhoto: json["adhaar_card_front_photo"],
    adhaarCardBackPhoto: json["adhaar_card_back_photo"],
    adhaarCardStatus: json["adhaar_card_status"],
    adhaarCardNum: json["adhaar_card_num"],
    panCardFrontPhoto: json["pan_card_front_photo"],
    panCardBackPhoto: json["pan_card_back_photo"],
    panCardStatus: json["pan_card_status"],
    panCardNum: json["pan_card_num"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "adhaar_card_front_photo": adhaarCardFrontPhoto,
    "adhaar_card_back_photo": adhaarCardBackPhoto,
    "adhaar_card_status": adhaarCardStatus,
    "adhaar_card_num": adhaarCardNum,
    "pan_card_front_photo": panCardFrontPhoto,
    "pan_card_back_photo": panCardBackPhoto,
    "pan_card_status": panCardStatus,
    "pan_card_num": panCardNum,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
