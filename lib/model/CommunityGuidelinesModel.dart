import 'dart:convert';
/// success : true
/// message : "Community Guidelines fetched successfully"
/// data : [{"_id":"66a343402d90c4e0097d8ac7","community_guidelines":"community_guidelines community_guidelines","createdAt":"2024-07-26T12:03:36.900Z","updatedAt":"2024-07-26T12:05:07.399Z","__v":0}]

CommunityGuidelinesModel communityGuidelinesModelFromJson(String str) => CommunityGuidelinesModel.fromJson(json.decode(str));
String communityGuidelinesModelToJson(CommunityGuidelinesModel data) => json.encode(data.toJson());
class CommunityGuidelinesModel {
  CommunityGuidelinesModel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  CommunityGuidelinesModel.fromJson(dynamic json) {
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
CommunityGuidelinesModel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => CommunityGuidelinesModel(  success: success ?? _success,
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

/// _id : "66a343402d90c4e0097d8ac7"
/// community_guidelines : "community_guidelines community_guidelines"
/// createdAt : "2024-07-26T12:03:36.900Z"
/// updatedAt : "2024-07-26T12:05:07.399Z"
/// __v : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? communityGuidelines, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _communityGuidelines = communityGuidelines;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _communityGuidelines = json['community_guidelines'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _communityGuidelines;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Data copyWith({  String? id,
  String? communityGuidelines,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
  communityGuidelines: communityGuidelines ?? _communityGuidelines,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get communityGuidelines => _communityGuidelines;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['community_guidelines'] = _communityGuidelines;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}