// To parse this JSON data, do
//
//     final profileDetailsModel = profileDetailsModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailsModel profileDetailsModelFromJson(String str) => ProfileDetailsModel.fromJson(json.decode(str));

String profileDetailsModelToJson(ProfileDetailsModel data) => json.encode(data.toJson());

class ProfileDetailsModel {
  bool success;
  String message;
  Data data;

  ProfileDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) => ProfileDetailsModel(
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
  String uniqueId;
  String name;
  String email;
  String password;
  int mobile;
  String dob;
  String gender;
  String address;
  String city;
  int pincode;
  String state;
  String country;
  String status;
  DateTime dateAndTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String profilePhoto;

  Data({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.country,
    required this.status,
    required this.dateAndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.profilePhoto,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    uniqueId: json["unique_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    mobile: json["mobile"],
    dob: json["dob"],
    gender: json["gender"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    state: json["state"],
    country: json["country"],
    status: json["status"],
    dateAndTime: DateTime.parse(json["dateAndTime"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "unique_id": uniqueId,
    "name": name,
    "email": email,
    "password": password,
    "mobile": mobile,
    "dob": dob,
    "gender": gender,
    "address": address,
    "city": city,
    "pincode": pincode,
    "state": state,
    "country": country,
    "status": status,
    "dateAndTime": dateAndTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "profile_photo": profilePhoto,
  };
}
