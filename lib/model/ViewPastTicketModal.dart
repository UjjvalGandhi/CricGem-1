import 'dart:convert';

// Main function to parse JSON to Dart objects
ViewPastTicketModal writeToUsResponseFromJson(String str) =>
    ViewPastTicketModal.fromJson(json.decode(str));

String writeToUsResponseToJson(ViewPastTicketModal data) =>
    json.encode(data.toJson());

// Main Response Class
class ViewPastTicketModal {
  ViewPastTicketModal({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<WriteToUsData> data;

  factory ViewPastTicketModal.fromJson(Map<String, dynamic> json) =>
      ViewPastTicketModal(
        success: json["success"],
        message: json["message"],
        data: List<WriteToUsData>.from(
            json["data"].map((x) => WriteToUsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// WriteToUs Data Class
class WriteToUsData {
  WriteToUsData({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.userDetails,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<UserDetail> userDetails;

  factory WriteToUsData.fromJson(Map<String, dynamic> json) => WriteToUsData(
    id: json["_id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    userDetails: List<UserDetail>.from(
        json["user_details"].map((x) => UserDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "user_details": List<dynamic>.from(userDetails.map((x) => x.toJson())),
  };
}

// User Details Class
class UserDetail {
  UserDetail({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.country,
    required this.profilePhoto,
    required this.status,
    required this.dateAndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String uniqueId;
  final String name;
  final String email;
  final int mobile;
  final DateTime dob;
  final String gender;
  final String address;
  final String city;
  final int pincode;
  final String state;
  final String country;
  final String profilePhoto;
  final String status;
  final DateTime dateAndTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["_id"],
    uniqueId: json["unique_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    state: json["state"],
    country: json["country"],
    profilePhoto: json["profile_photo"],
    status: json["status"],
    dateAndTime: DateTime.parse(json["dateAndTime"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "unique_id": uniqueId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "dob": dob.toIso8601String(),
    "gender": gender,
    "address": address,
    "city": city,
    "pincode": pincode,
    "state": state,
    "country": country,
    "profile_photo": profilePhoto,
    "status": status,
    "dateAndTime": dateAndTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
