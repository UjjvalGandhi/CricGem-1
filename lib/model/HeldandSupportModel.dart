import 'dart:convert';
/// success : true
/// message : "Help and Support entries fetched successfully"
/// data : [{"_id":"66d1c4149c748a5415316b98","question":"waht is your name ??","answer":"rahul","createdAt":"2024-08-30T18:37:32.855Z","updatedAt":"2024-08-30T18:37:32.855Z","__v":0}]

HeldandSupportModel heldandSupportModelFromJson(String str) => HeldandSupportModel.fromJson(json.decode(str));
String heldandSupportModelToJson(HeldandSupportModel data) => json.encode(data.toJson());
class HeldandSupportModel {
  HeldandSupportModel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  HeldandSupportModel.fromJson(dynamic json) {
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
HeldandSupportModel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => HeldandSupportModel(  success: success ?? _success,
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

/// _id : "66d1c4149c748a5415316b98"
/// question : "waht is your name ??"
/// answer : "rahul"
/// createdAt : "2024-08-30T18:37:32.855Z"
/// updatedAt : "2024-08-30T18:37:32.855Z"
/// __v : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? question, 
      String? answer, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _question = question;
    _answer = answer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _question = json['question'];
    _answer = json['answer'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _question;
  String? _answer;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Data copyWith({  String? id,
  String? question,
  String? answer,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
  question: question ?? _question,
  answer: answer ?? _answer,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get question => _question;
  String? get answer => _answer;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['question'] = _question;
    map['answer'] = _answer;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}