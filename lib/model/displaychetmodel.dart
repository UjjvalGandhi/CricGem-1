class displaychetModel {
  bool? success;
  String? message;
  List<Data>? data;

  displaychetModel({this.success, this.message, this.data});

  displaychetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? message;
  String? dateAndTime;
  String? createdAt;
  UserDetails? userDetails;
  String? date;
  String? time;

  Data(
      {this.sId,
        this.message,
        this.dateAndTime,
        this.createdAt,
        this.userDetails,
        this.date,
        this.time});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    dateAndTime = json['dateAndTime'];
    createdAt = json['createdAt'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['message'] = message;
    data['dateAndTime'] = dateAndTime;
    data['createdAt'] = createdAt;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}

class UserDetails {
  String? sId;
  String? uniqueId;
  String? name;
  String? email;
  int? mobile;
  String? dob;
  String? gender;
  String? address;
  String? city;
  int? pincode;
  String? state;
  String? country;
  String? profilePhoto;
  String? status;
  String? dateAndTime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserDetails(
      {this.sId,
        this.uniqueId,
        this.name,
        this.email,
        this.mobile,
        this.dob,
        this.gender,
        this.address,
        this.city,
        this.pincode,
        this.state,
        this.country,
        this.profilePhoto,
        this.status,
        this.dateAndTime,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uniqueId = json['unique_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    country = json['country'];
    profilePhoto = json['profile_photo'];
    status = json['status'];
    dateAndTime = json['dateAndTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['unique_id'] = uniqueId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['dob'] = dob;
    data['gender'] = gender;
    data['address'] = address;
    data['city'] = city;
    data['pincode'] = pincode;
    data['state'] = state;
    data['country'] = country;
    data['profile_photo'] = profilePhoto;
    data['status'] = status;
    data['dateAndTime'] = dateAndTime;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
