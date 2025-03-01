import 'dart:convert';

ProfileDisplay profileDisplayFromJson(String str) => ProfileDisplay.fromJson(json.decode(str));
String profileDisplayToJson(ProfileDisplay data) => json.encode(data.toJson());
class ProfileDisplay {
  ProfileDisplay({
      bool? success, 
      String? message, 
      Data? data,
    int? totalWinning,
    int? totalContest,
    int? totalMatches,
    int? totalWinningContest,
    int? series,
    bool? isVerify,

  }){
    _success = success;
    _message = message;
    _data = data;
    _totalWinning = totalWinning;
    _totalContest = totalContest;
    _totalMatches = totalMatches;
    _totalWinningContest = totalWinningContest;
    _series = series;
    _isVerify = isVerify;
}

  ProfileDisplay.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _totalWinning = json['totalWinning'];
    _totalMatches = json['totalMatches'];
    _totalContest = json['totalContest'];
    _totalWinningContest = json['totalWinningContest'];
    _series = json['series'];
    _isVerify = json['isVerify'];
  }
  bool? _success;
  String? _message;
  Data? _data;
  int? _totalWinning;
  int? _totalContest;
  int? _totalMatches;
  int? _totalWinningContest;
  int? _series;
  bool? _isVerify;
ProfileDisplay copyWith({  bool? success,
  String? message,
  Data? data,
  int? totalWinning,
  int? totalMatches,
  int? totalContest,
  int? totalWinningContest,
  int? series,
  bool? isVerify,

}) => ProfileDisplay(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  totalWinning: totalWinning ?? _totalWinning,
  totalContest: totalContest ?? _totalContest,
  totalMatches: totalMatches ?? _totalMatches,
  totalWinningContest: totalWinningContest ?? _totalWinningContest,
  series : series ?? _series,
  isVerify: isVerify ?? _isVerify,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;
  int? get totalWinning => _totalWinning;
  int? get totalContest => _totalContest;
  int? get totalMatches => _totalMatches;
  int? get totalWinningContest => _totalWinningContest;
  int? get series => _series;
  bool? get isVerify => _isVerify;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['totalWinning'] = _totalWinning;
    map['totalMatches'] = _totalMatches;
    map['totalContest'] = _totalContest;
    map['totalWinningContest'] = _totalWinningContest;
    map['series'] = _series;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// _id : "664efe9bc32d51aee4f457d7"
/// unique_id : "21a7d7"
/// name : "rakesh"
/// email : "rakesh3@gmail.com"
/// password : "123465"
/// mobile : 7896544567
/// dob : "10-06-2003"
/// gender : "male"
/// address : "sjldf"
/// city : "ahemdabad"
/// pincode : 123456
/// state : "gujrat"
/// country : "india"
/// profile_photo : "https://t3.ftcdn.net/jpg/03/64/62/36/240_F_364623624_eTeYrOr8oM08nsPPEmV8gGb60E0MK5vp.webp"
/// status : "active"
/// dateAndTime : "2024-05-23T08:30:19.707Z"
/// createdAt : "2024-05-23T08:30:19.707Z"
/// updatedAt : "2024-05-23T08:30:19.707Z"
/// __v : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? uniqueId, 
      String? name, 
      String? email, 
      String? password, 
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
    _password = password;
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

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _uniqueId = json['unique_id'];
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
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
  String? _password;
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
Data copyWith({  String? id,
  String? uniqueId,
  String? name,
  String? email,
  String? password,
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
}) => Data(  id: id ?? _id,
  uniqueId: uniqueId ?? _uniqueId,
  name: name ?? _name,
  email: email ?? _email,
  password: password ?? _password,
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
  String? get password => _password;
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
    map['password'] = _password;
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