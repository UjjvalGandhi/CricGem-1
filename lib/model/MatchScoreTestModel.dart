import 'dart:convert';
/// success : true
/// message : "Scoreboard fetched successfully"
/// data : {"team1":{"_id":"669a4e1491f4793dc94219de","name":"Delhi Capitals","score":"69/1 (7.0)"},"team2":{"_id":"669a4f1491f4793dc9421a1f","name":"Mumbai Indians","score":"0/0 (0.0)"}}

MatchScoreTestModel matchScoreTestModelFromJson(String str) => MatchScoreTestModel.fromJson(json.decode(str));
String matchScoreTestModelToJson(MatchScoreTestModel data) => json.encode(data.toJson());
class MatchScoreTestModel {
  MatchScoreTestModel({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  MatchScoreTestModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
MatchScoreTestModel copyWith({  bool? success,
  String? message,
  Data? data,
}) => MatchScoreTestModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// team1 : {"_id":"669a4e1491f4793dc94219de","name":"Delhi Capitals","score":"69/1 (7.0)"}
/// team2 : {"_id":"669a4f1491f4793dc9421a1f","name":"Mumbai Indians","score":"0/0 (0.0)"}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      Team1? team1, 
      Team2? team2,}){
    _team1 = team1;
    _team2 = team2;
}

  Data.fromJson(dynamic json) {
    _team1 = json['team1'] != null ? Team1.fromJson(json['team1']) : null;
    _team2 = json['team2'] != null ? Team2.fromJson(json['team2']) : null;
  }
  Team1? _team1;
  Team2? _team2;
Data copyWith({  Team1? team1,
  Team2? team2,
}) => Data(  team1: team1 ?? _team1,
  team2: team2 ?? _team2,
);
  Team1? get team1 => _team1;
  Team2? get team2 => _team2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_team1 != null) {
      map['team1'] = _team1?.toJson();
    }
    if (_team2 != null) {
      map['team2'] = _team2?.toJson();
    }
    return map;
  }

}

/// _id : "669a4f1491f4793dc9421a1f"
/// name : "Mumbai Indians"
/// score : "0/0 (0.0)"

Team2 team2FromJson(String str) => Team2.fromJson(json.decode(str));
String team2ToJson(Team2 data) => json.encode(data.toJson());
class Team2 {
  Team2({
      String? id, 
      String? name, 
      String? score,}){
    _id = id;
    _name = name;
    _score = score;
}

  Team2.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _score = json['score'];
  }
  String? _id;
  String? _name;
  String? _score;
Team2 copyWith({  String? id,
  String? name,
  String? score,
}) => Team2(  id: id ?? _id,
  name: name ?? _name,
  score: score ?? _score,
);
  String? get id => _id;
  String? get name => _name;
  String? get score => _score;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['score'] = _score;
    return map;
  }

}

/// _id : "669a4e1491f4793dc94219de"
/// name : "Delhi Capitals"
/// score : "69/1 (7.0)"

Team1 team1FromJson(String str) => Team1.fromJson(json.decode(str));
String team1ToJson(Team1 data) => json.encode(data.toJson());
class Team1 {
  Team1({
      String? id, 
      String? name, 
      String? score,}){
    _id = id;
    _name = name;
    _score = score;
}

  Team1.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _score = json['score'];
  }
  String? _id;
  String? _name;
  String? _score;
Team1 copyWith({  String? id,
  String? name,
  String? score,
}) => Team1(  id: id ?? _id,
  name: name ?? _name,
  score: score ?? _score,
);
  String? get id => _id;
  String? get name => _name;
  String? get score => _score;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['score'] = _score;
    return map;
  }

}