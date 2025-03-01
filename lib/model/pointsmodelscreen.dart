import 'dart:convert';
/// success : true
/// message : "Display Point System"
/// data : [{"match_type_name":"T20","point_types":[{"point_type_name":"Batting","point_for":[{"point_for_name":"Six Bonus","point_for_status":"six","points":2},{"point_for_name":"Run","point_for_status":"run","points":1},{"point_for_name":"Boundary Bonus","point_for_status":"boundary","points":1},{"point_for_name":"30 Run Bonus","point_for_status":"thirty_run","points":4},{"point_for_name":"Dismissal for a duck ","point_for_status":"duck","points":-2},{"point_for_name":"Century Bonus","point_for_status":"century","points":16},{"point_for_name":"Half-Century Bonus","point_for_status":"half_century","points":8}]},{"point_type_name":"Bowling","point_for":[{"point_for_name":"LBW","point_for_status":"lbw","points":8},{"point_for_name":"Bowled","point_for_status":"bowled","points":8},{"point_for_name":"Wicket (Excluding Run Out)","point_for_status":"wicket","points":25},{"point_for_name":"Maiden Over","point_for_status":"maiden","points":12},{"point_for_name":"4 Wicket Bonus","point_for_status":"four_wicket","points":8},{"point_for_name":"3 Wicket Bonus","point_for_status":"three_wicket","points":4},{"point_for_name":"5 Wicket Bonus","point_for_status":"five_wicket","points":16}]},{"point_type_name":"Fielding Points","point_for":[{"point_for_name":"Catch","point_for_status":"catch","points":8},{"point_for_name":"3 Catch Bonus","point_for_status":"three_catch","points":4},{"point_for_name":"Stumping","point_for_status":"stumping","points":12},{"point_for_name":"Run out","point_for_status":"runout","points":6}]}]},{"match_type_name":"OD","point_types":[{"point_type_name":"Batting","point_for":[{"point_for_name":"Run","point_for_status":"run","points":1},{"point_for_name":"Century Bonus","point_for_status":"century","points":8},{"point_for_name":"Half-Century Bonus","point_for_status":"half_century","points":4},{"point_for_name":"Boundary Bonus","point_for_status":"boundary","points":1},{"point_for_name":"Dismissal for a duck ","point_for_status":"duck","points":-3},{"point_for_name":"Six Bonus","point_for_status":"six","points":2},{"point_for_name":"30 Run Bonus","point_for_status":"thirty_run","points":null}]},{"point_type_name":"Bowling","point_for":[{"point_for_name":"3 Wicket Bonus","point_for_status":"three_wicket","points":null},{"point_for_name":"2 Wicket Bonus","point_for_status":"two_wicket","points":null},{"point_for_name":"Maiden Over","point_for_status":"maiden","points":4},{"point_for_name":"LBW","point_for_status":"lbw","points":8},{"point_for_name":"5 Wicket Bonus","point_for_status":"five_wicket","points":8},{"point_for_name":"Bowled","point_for_status":"bowled","points":8},{"point_for_name":"4 Wicket Bonus","point_for_status":"four_wicket","points":4},{"point_for_name":"Wicket (Excluding Run Out)","point_for_status":"wicket","points":25}]},{"point_type_name":"Fielding Points","point_for":[{"point_for_name":"Catch","point_for_status":"catch","points":8},{"point_for_name":"3 Catch Bonus","point_for_status":"three_catch","points":4},{"point_for_name":"3 Catch Bonus","point_for_status":"three_catch","points":4},{"point_for_name":"Stumping","point_for_status":"stumping","points":12},{"point_for_name":"Catch","point_for_status":"catch","points":8},{"point_for_name":"3 Catch Bonus","point_for_status":"three_catch","points":4},{"point_for_name":"Catch","point_for_status":"catch","points":8},{"point_for_name":"Run out","point_for_status":"runout","points":6},{"point_for_name":"Run out","point_for_status":"runout","points":6},{"point_for_name":"Stumping","point_for_status":"stumping","points":12},{"point_for_name":"Run out","point_for_status":"runout","points":6},{"point_for_name":"Stumping","point_for_status":"stumping","points":12}]}]}]

Pointsmodelscreen pointsmodelscreenFromJson(String str) => Pointsmodelscreen.fromJson(json.decode(str));
String pointsmodelscreenToJson(Pointsmodelscreen data) => json.encode(data.toJson());
class Pointsmodelscreen {
  Pointsmodelscreen({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  Pointsmodelscreen.fromJson(dynamic json) {
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
Pointsmodelscreen copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Pointsmodelscreen(  success: success ?? _success,
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

/// match_type_name : "T20"
/// point_types : [{"point_type_name":"Batting","point_for":[{"point_for_name":"Six Bonus","point_for_status":"six","points":2},{"point_for_name":"Run","point_for_status":"run","points":1},{"point_for_name":"Boundary Bonus","point_for_status":"boundary","points":1},{"point_for_name":"30 Run Bonus","point_for_status":"thirty_run","points":4},{"point_for_name":"Dismissal for a duck ","point_for_status":"duck","points":-2},{"point_for_name":"Century Bonus","point_for_status":"century","points":16},{"point_for_name":"Half-Century Bonus","point_for_status":"half_century","points":8}]},{"point_type_name":"Bowling","point_for":[{"point_for_name":"LBW","point_for_status":"lbw","points":8},{"point_for_name":"Bowled","point_for_status":"bowled","points":8},{"point_for_name":"Wicket (Excluding Run Out)","point_for_status":"wicket","points":25},{"point_for_name":"Maiden Over","point_for_status":"maiden","points":12},{"point_for_name":"4 Wicket Bonus","point_for_status":"four_wicket","points":8},{"point_for_name":"3 Wicket Bonus","point_for_status":"three_wicket","points":4},{"point_for_name":"5 Wicket Bonus","point_for_status":"five_wicket","points":16}]},{"point_type_name":"Fielding Points","point_for":[{"point_for_name":"Catch","point_for_status":"catch","points":8},{"point_for_name":"3 Catch Bonus","point_for_status":"three_catch","points":4},{"point_for_name":"Stumping","point_for_status":"stumping","points":12},{"point_for_name":"Run out","point_for_status":"runout","points":6}]}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? matchTypeName, 
      List<PointTypes>? pointTypes,}){
    _matchTypeName = matchTypeName;
    _pointTypes = pointTypes;
}

  Data.fromJson(dynamic json) {
    _matchTypeName = json['match_type_name'];
    if (json['point_types'] != null) {
      _pointTypes = [];
      json['point_types'].forEach((v) {
        _pointTypes?.add(PointTypes.fromJson(v));
      });
    }
  }
  String? _matchTypeName;
  List<PointTypes>? _pointTypes;
Data copyWith({  String? matchTypeName,
  List<PointTypes>? pointTypes,
}) => Data(  matchTypeName: matchTypeName ?? _matchTypeName,
  pointTypes: pointTypes ?? _pointTypes,
);
  String? get matchTypeName => _matchTypeName;
  List<PointTypes>? get pointTypes => _pointTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['match_type_name'] = _matchTypeName;
    if (_pointTypes != null) {
      map['point_types'] = _pointTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// point_type_name : "Batting"
/// point_for : [{"point_for_name":"Six Bonus","point_for_status":"six","points":2},{"point_for_name":"Run","point_for_status":"run","points":1},{"point_for_name":"Boundary Bonus","point_for_status":"boundary","points":1},{"point_for_name":"30 Run Bonus","point_for_status":"thirty_run","points":4},{"point_for_name":"Dismissal for a duck ","point_for_status":"duck","points":-2},{"point_for_name":"Century Bonus","point_for_status":"century","points":16},{"point_for_name":"Half-Century Bonus","point_for_status":"half_century","points":8}]

PointTypes pointTypesFromJson(String str) => PointTypes.fromJson(json.decode(str));
String pointTypesToJson(PointTypes data) => json.encode(data.toJson());
class PointTypes {
  PointTypes({
      String? pointTypeName, 
      List<PointFor>? pointFor,}){
    _pointTypeName = pointTypeName;
    _pointFor = pointFor;
}

  PointTypes.fromJson(dynamic json) {
    _pointTypeName = json['point_type_name'];
    if (json['point_for'] != null) {
      _pointFor = [];
      json['point_for'].forEach((v) {
        _pointFor?.add(PointFor.fromJson(v));
      });
    }
  }
  String? _pointTypeName;
  List<PointFor>? _pointFor;
PointTypes copyWith({  String? pointTypeName,
  List<PointFor>? pointFor,
}) => PointTypes(  pointTypeName: pointTypeName ?? _pointTypeName,
  pointFor: pointFor ?? _pointFor,
);
  String? get pointTypeName => _pointTypeName;
  List<PointFor>? get pointFor => _pointFor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_type_name'] = _pointTypeName;
    if (_pointFor != null) {
      map['point_for'] = _pointFor?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// point_for_name : "Six Bonus"
/// point_for_status : "six"
/// points : 2

PointFor pointForFromJson(String str) => PointFor.fromJson(json.decode(str));
String pointForToJson(PointFor data) => json.encode(data.toJson());
class PointFor {
  PointFor({
      String? pointForName, 
      String? pointForStatus, 
      num? points,}){
    _pointForName = pointForName;
    _pointForStatus = pointForStatus;
    _points = points;
}

  PointFor.fromJson(dynamic json) {
    _pointForName = json['point_for_name'];
    _pointForStatus = json['point_for_status'];
    _points = json['points'];
  }
  String? _pointForName;
  String? _pointForStatus;
  num? _points;
PointFor copyWith({  String? pointForName,
  String? pointForStatus,
  num? points,
}) => PointFor(  pointForName: pointForName ?? _pointForName,
  pointForStatus: pointForStatus ?? _pointForStatus,
  points: points ?? _points,
);
  String? get pointForName => _pointForName;
  String? get pointForStatus => _pointForStatus;
  num? get points => _points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_for_name'] = _pointForName;
    map['point_for_status'] = _pointForStatus;
    map['points'] = _points;
    return map;
  }

}