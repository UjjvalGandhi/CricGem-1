import 'dart:convert';
/// success : true
/// message : "Points retrieved successfully"
/// data : [{"_id":{"playerId":"669a4fe291f4793dc9421a57"},"playerName":"Sam Curran","playerRole":"All Rounder","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Sam Curran.png","teamShortName":"DC","totalPoints":0},{"_id":{"playerId":"669a5d6d91f4793dc9421cae"},"playerName":"Shai Hope","playerRole":"Wicket Keeper","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Shai Hope.png","teamShortName":"DC","totalPoints":20},{"_id":{"playerId":"669a52f191f4793dc9421b01"},"playerName":"Arshdeep Singh","playerRole":"Bowler","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Arshdeep Singh.png","teamShortName":"DC","totalPoints":25},{"_id":{"playerId":"669a617491f4793dc9421e84"},"playerName":"Mitchell Marsh","playerRole":"All Rounder","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Mitchell Marsh.png","teamShortName":"DC","totalPoints":34},{"_id":{"playerId":"669a5bd391f4793dc9421c30"},"playerName":"David Warner","playerRole":"Batsman","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/David Warner.png","teamShortName":"DC","totalPoints":32},{"_id":{"playerId":"669a53eb91f4793dc9421b2b"},"playerName":"Rahul Chahar","playerRole":"Bowler","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Rahul Chahar.png","teamShortName":"DC","totalPoints":8},{"_id":{"playerId":"669a533b91f4793dc9421b0d"},"playerName":"Kagiso Rabada","playerRole":"Bowler","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Kagiso Rabada.png","teamShortName":"DC","totalPoints":0},{"_id":{"playerId":"669a52a991f4793dc9421afc"},"playerName":"Harpreet Brar","playerRole":"Bowler","playerPhoto":"https://batting-api-1.onrender.com/playerPhoto/Harpreet Brar.png","teamShortName":"DC","totalPoints":0}]

ViewStatsModel viewStatsModelFromJson(String str) => ViewStatsModel.fromJson(json.decode(str));
String viewStatsModelToJson(ViewStatsModel data) => json.encode(data.toJson());
class ViewStatsModel {
  ViewStatsModel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ViewStatsModel.fromJson(dynamic json) {
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
ViewStatsModel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => ViewStatsModel(  success: success ?? _success,
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

/// _id : {"playerId":"669a4fe291f4793dc9421a57"}
/// playerName : "Sam Curran"
/// playerRole : "All Rounder"
/// playerPhoto : "https://batting-api-1.onrender.com/playerPhoto/Sam Curran.png"
/// teamShortName : "DC"
/// totalPoints : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      Id? id, 
      String? playerName, 
      String? playerRole, 
      String? playerPhoto, 
      String? teamShortName, 
      num? totalPoints,}){
    _id = id;
    _playerName = playerName;
    _playerRole = playerRole;
    _playerPhoto = playerPhoto;
    _teamShortName = teamShortName;
    _totalPoints = totalPoints;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'] != null ? Id.fromJson(json['_id']) : null;
    _playerName = json['playerName'];
    _playerRole = json['playerRole'];
    _playerPhoto = json['playerPhoto'];
    _teamShortName = json['teamShortName'];
    _totalPoints = json['totalPoints'];
  }
  Id? _id;
  String? _playerName;
  String? _playerRole;
  String? _playerPhoto;
  String? _teamShortName;
  num? _totalPoints;
Data copyWith({  Id? id,
  String? playerName,
  String? playerRole,
  String? playerPhoto,
  String? teamShortName,
  num? totalPoints,
}) => Data(  id: id ?? _id,
  playerName: playerName ?? _playerName,
  playerRole: playerRole ?? _playerRole,
  playerPhoto: playerPhoto ?? _playerPhoto,
  teamShortName: teamShortName ?? _teamShortName,
  totalPoints: totalPoints ?? _totalPoints,
);
  Id? get id => _id;
  String? get playerName => _playerName;
  String? get playerRole => _playerRole;
  String? get playerPhoto => _playerPhoto;
  String? get teamShortName => _teamShortName;
  num? get totalPoints => _totalPoints;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_id != null) {
      map['_id'] = _id?.toJson();
    }
    map['playerName'] = _playerName;
    map['playerRole'] = _playerRole;
    map['playerPhoto'] = _playerPhoto;
    map['teamShortName'] = _teamShortName;
    map['totalPoints'] = _totalPoints;
    return map;
  }

}

/// playerId : "669a4fe291f4793dc9421a57"

Id idFromJson(String str) => Id.fromJson(json.decode(str));
String idToJson(Id data) => json.encode(data.toJson());
class Id {
  Id({
      String? playerId,}){
    _playerId = playerId;
}

  Id.fromJson(dynamic json) {
    _playerId = json['playerId'];
  }
  String? _playerId;
Id copyWith({  String? playerId,
}) => Id(  playerId: playerId ?? _playerId,
);
  String? get playerId => _playerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    return map;
  }

}