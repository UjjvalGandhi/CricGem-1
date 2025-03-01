import 'dart:convert';
/// success : true
/// message : "About Us fetched successfully"
/// data : [{"_id":"66a3424b2d90c4e0097d8ac1","about_us":"<p>about_us about_us &nbsp;</p>","createdAt":"2024-07-26T11:59:31.295Z","updatedAt":"2024-08-30T13:29:23.803Z","__v":0}]

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));
String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());
class AboutUsModel {
  AboutUsModel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AboutUsModel.fromJson(dynamic json) {
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
AboutUsModel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => AboutUsModel(  success: success ?? _success,
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

/// _id : "66a3424b2d90c4e0097d8ac1"
/// about_us : "<p>about_us about_us &nbsp;</p>"
/// createdAt : "2024-07-26T11:59:31.295Z"
/// updatedAt : "2024-08-30T13:29:23.803Z"
/// __v : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? aboutUs, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _aboutUs = aboutUs;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _aboutUs = json['about_us'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _aboutUs;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Data copyWith({  String? id,
  String? aboutUs,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
  aboutUs: aboutUs ?? _aboutUs,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get aboutUs => _aboutUs;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['about_us'] = _aboutUs;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}