import 'dart:convert';
/// success : true
/// message : "Chat messages retrieved successfully"
/// data : [{"_id":"66bc86f15ab3e2a90c86d709","message":"kya","dateAndTime":"2024-08-14T15:59:02.095Z","user_details":{"_id":"669b8f83f3f98509f2ed3362","unique_id":"700fff","name":"parmar rakesh","email":"rakeshparmar.webearl@gmail.com","mobile":8487934682,"dob":"2024-7-22","gender":"Male","address":"bsnsnsns","city":"Ahmedabad","pincode":123156,"state":"Gujarat","country":"India","profile_photo":"https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp","status":"active","dateAndTime":"2024-07-20T10:20:51.989Z","createdAt":"2024-07-20T10:20:51.990Z","updatedAt":"2024-07-25T10:14:16.518Z","__v":0},"date":"14-08-2024","time":"15:59"},{"_id":"66bc86f45ab3e2a90c86d70c","message":"kya","dateAndTime":"2024-08-14T15:59:02.095Z","user_details":{"_id":"669b8f83f3f98509f2ed3362","unique_id":"700fff","name":"parmar rakesh","email":"rakeshparmar.webearl@gmail.com","mobile":8487934682,"dob":"2024-7-22","gender":"Male","address":"bsnsnsns","city":"Ahmedabad","pincode":123156,"state":"Gujarat","country":"India","profile_photo":"https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp","status":"active","dateAndTime":"2024-07-20T10:20:51.989Z","createdAt":"2024-07-20T10:20:51.990Z","updatedAt":"2024-07-25T10:14:16.518Z","__v":0},"date":"14-08-2024","time":"15:59"},{"_id":"66bc86f95ab3e2a90c86d70f","message":"kya","dateAndTime":"2024-08-14T15:59:02.095Z","user_details":{"_id":"669b8f83f3f98509f2ed3362","unique_id":"700fff","name":"parmar rakesh","email":"rakeshparmar.webearl@gmail.com","mobile":8487934682,"dob":"2024-7-22","gender":"Male","address":"bsnsnsns","city":"Ahmedabad","pincode":123156,"state":"Gujarat","country":"India","profile_photo":"https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp","status":"active","dateAndTime":"2024-07-20T10:20:51.989Z","createdAt":"2024-07-20T10:20:51.990Z","updatedAt":"2024-07-25T10:14:16.518Z","__v":0},"date":"14-08-2024","time":"15:59"}]

Chtdisplymodel chtdisplymodelFromJson(String str) => Chtdisplymodel.fromJson(json.decode(str));
String chtdisplymodelToJson(Chtdisplymodel data) => json.encode(data.toJson());
class Chtdisplymodel {
  Chtdisplymodel({
      bool? success,
      String? message,
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  Chtdisplymodel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  List<Data>? _data;
Chtdisplymodel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Chtdisplymodel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "66bc86f15ab3e2a90c86d709"
/// message : "kya"
/// dateAndTime : "2024-08-14T15:59:02.095Z"
/// user_details : {"_id":"669b8f83f3f98509f2ed3362","unique_id":"700fff","name":"parmar rakesh","email":"rakeshparmar.webearl@gmail.com","mobile":8487934682,"dob":"2024-7-22","gender":"Male","address":"bsnsnsns","city":"Ahmedabad","pincode":123156,"state":"Gujarat","country":"India","profile_photo":"https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp","status":"active","dateAndTime":"2024-07-20T10:20:51.989Z","createdAt":"2024-07-20T10:20:51.990Z","updatedAt":"2024-07-25T10:14:16.518Z","__v":0}
/// date : "14-08-2024"
/// time : "15:59"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id,
      String? message,
      String? dateAndTime,
      UserDetails? userDetails,
      String? date,
      String? time,}){
    _id = id;
    _message = message;
    _dateAndTime = dateAndTime;
    _userDetails = userDetails;
    _date = date;
    _time = time;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _message = json['message'];
    _dateAndTime = json['dateAndTime'];
    _userDetails = json['user_details'] != null ? UserDetails.fromJson(json['user_details']) : null;
    _date = json['date'];
    _time = json['time'];
  }
  String? _id;
  String? _message;
  String? _dateAndTime;
  UserDetails? _userDetails;
  String? _date;
  String? _time;
Data copyWith({  String? id,
  String? message,
  String? dateAndTime,
  UserDetails? userDetails,
  String? date,
  String? time,
}) => Data(  id: id ?? _id,
  message: message ?? _message,
  dateAndTime: dateAndTime ?? _dateAndTime,
  userDetails: userDetails ?? _userDetails,
  date: date ?? _date,
  time: time ?? _time,
);
  String? get id => _id;
  String? get message => _message;
  String? get dateAndTime => _dateAndTime;
  UserDetails? get userDetails => _userDetails;
  String? get date => _date;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['message'] = _message;
    map['dateAndTime'] = _dateAndTime;
    if (_userDetails != null) {
      map['user_details'] = _userDetails?.toJson();
    }
    map['date'] = _date;
    map['time'] = _time;
    return map;
  }

}

/// _id : "669b8f83f3f98509f2ed3362"
/// unique_id : "700fff"
/// name : "parmar rakesh"
/// email : "rakeshparmar.webearl@gmail.com"
/// mobile : 8487934682
/// dob : "2024-7-22"
/// gender : "Male"
/// address : "bsnsnsns"
/// city : "Ahmedabad"
/// pincode : 123156
/// state : "Gujarat"
/// country : "India"
/// profile_photo : "https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp"
/// status : "active"
/// dateAndTime : "2024-07-20T10:20:51.989Z"
/// createdAt : "2024-07-20T10:20:51.990Z"
/// updatedAt : "2024-07-25T10:14:16.518Z"
/// __v : 0

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));
String userDetailsToJson(UserDetails data) => json.encode(data.toJson());
class UserDetails {
  UserDetails({
      String? id,
      String? uniqueId,
      String? name,
      String? email,
      num? mobile,
      String? dob,
      String? gender,
      String? address,
      String? city,
      num? pincode,
      String? state,
      String? country,
      String? profilePhoto,
      String? status,
      String? dateAndTime,
      String? createdAt,
      String? updatedAt,
      num? v,}){
    _id = id;
    _uniqueId = uniqueId;
    _name = name;
    _email = email;
    _mobile = mobile;
    _dob = dob;
    _gender = gender;
    _address = address;
    _city = city;
    _pincode = pincode;
    _state = state;
    _country = country;
    _profilePhoto = profilePhoto;
    _status = status;
    _dateAndTime = dateAndTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  UserDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _uniqueId = json['unique_id'];
    _name = json['name'];
    _email = json['email'];
    _mobile = json['mobile'];
    _dob = json['dob'];
    _gender = json['gender'];
    _address = json['address'];
    _city = json['city'];
    _pincode = json['pincode'];
    _state = json['state'];
    _country = json['country'];
    _profilePhoto = json['profile_photo'];
    _status = json['status'];
    _dateAndTime = json['dateAndTime'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _uniqueId;
  String? _name;
  String? _email;
  num? _mobile;
  String? _dob;
  String? _gender;
  String? _address;
  String? _city;
  num? _pincode;
  String? _state;
  String? _country;
  String? _profilePhoto;
  String? _status;
  String? _dateAndTime;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
UserDetails copyWith({  String? id,
  String? uniqueId,
  String? name,
  String? email,
  num? mobile,
  String? dob,
  String? gender,
  String? address,
  String? city,
  num? pincode,
  String? state,
  String? country,
  String? profilePhoto,
  String? status,
  String? dateAndTime,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => UserDetails(  id: id ?? _id,
  uniqueId: uniqueId ?? _uniqueId,
  name: name ?? _name,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  dob: dob ?? _dob,
  gender: gender ?? _gender,
  address: address ?? _address,
  city: city ?? _city,
  pincode: pincode ?? _pincode,
  state: state ?? _state,
  country: country ?? _country,
  profilePhoto: profilePhoto ?? _profilePhoto,
  status: status ?? _status,
  dateAndTime: dateAndTime ?? _dateAndTime,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get uniqueId => _uniqueId;
  String? get name => _name;
  String? get email => _email;
  num? get mobile => _mobile;
  String? get dob => _dob;
  String? get gender => _gender;
  String? get address => _address;
  String? get city => _city;
  num? get pincode => _pincode;
  String? get state => _state;
  String? get country => _country;
  String? get profilePhoto => _profilePhoto;
  String? get status => _status;
  String? get dateAndTime => _dateAndTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['unique_id'] = _uniqueId;
    map['name'] = _name;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['dob'] = _dob;
    map['gender'] = _gender;
    map['address'] = _address;
    map['city'] = _city;
    map['pincode'] = _pincode;
    map['state'] = _state;
    map['country'] = _country;
    map['profile_photo'] = _profilePhoto;
    map['status'] = _status;
    map['dateAndTime'] = _dateAndTime;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}