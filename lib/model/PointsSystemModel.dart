// import 'dart:convert';
// /// success : true
// /// message : "display Point System"
// /// data : [{"_id":"669a3f8b3b226c10dc5811cb","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3b7c071193c4b7bd1197","points":2,"match_type_name":"T20","point_for_name":"Six Bonus","point_for_status":"six","point_type_name":"Batting"},{"_id":"669a3f8b3b226c10dc5811c7","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3b5c071193c4b7bd118d","points":1,"match_type_name":"T20","point_for_name":"Run","point_for_status":"run","point_type_name":"Batting"},{"_id":"669a3f8b3b226c10dc5811c9","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3b75071193c4b7bd1192","points":1,"match_type_name":"T20","point_for_name":"Boundary Bonus","point_for_status":"boundary","point_type_name":"Batting"},{"_id":"669a3f8b3b226c10dc5811cd","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3bab071193c4b7bd119c","points":4,"match_type_name":"T20","point_for_name":"30 Run Bonus","point_for_status":"thirty_run","point_type_name":"Batting"},{"_id":"669a3f8b3b226c10dc5811cf","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3bcd071193c4b7bd11ab","points":-2,"match_type_name":"T20","point_for_name":"Dismissal for a duck ","point_for_status":"duck","point_type_name":"Batting"},{"_id":"669a3f8c3b226c10dc5811d1","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3bc5071193c4b7bd11a6","points":16,"match_type_name":"T20","point_for_name":"Century Bonus","point_for_status":"century","point_type_name":"Batting"},{"_id":"669a3f8c3b226c10dc5811d3","matchType":"669a3f49767133a748438e09","pointType":"669a3df45370b31a798ae243","pointFor":"669a3bba071193c4b7bd11a1","points":8,"match_type_name":"T20","point_for_name":"Half-Century Bonus","point_for_status":"half_century","point_type_name":"Batting"},{"_id":"669a3fbe3b226c10dc5811ec","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3c00b8d2d20ed0963543","points":8,"match_type_name":"T20","point_for_name":"LBW","point_for_status":"lbw","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811f0","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3c3e720c77044f4c13c0","points":8,"match_type_name":"T20","point_for_name":"Bowled","point_for_status":"bowled","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811ea","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3bebb8d2d20ed096353e","points":25,"match_type_name":"T20","point_for_name":"Wicket (Excluding Run Out)","point_for_status":"wicket","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811ee","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3cf82381f922519f3b15","points":12,"match_type_name":"T20","point_for_name":"Maiden Over","point_for_status":"maiden","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811f2","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3c842381f922519f3b0b","points":8,"match_type_name":"T20","point_for_name":"4 Wicket Bonus","point_for_status":"four_wicket","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811f4","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3c49720c77044f4c13c5","points":4,"match_type_name":"T20","point_for_name":"3 Wicket Bonus","point_for_status":"three_wicket","point_type_name":"Bowling"},{"_id":"669a3fbe3b226c10dc5811f6","matchType":"669a3f49767133a748438e09","pointType":"669a3e0f5370b31a798ae24c","pointFor":"669a3c952381f922519f3b10","points":16,"match_type_name":"T20","point_for_name":"5 Wicket Bonus","point_for_status":"five_wicket","point_type_name":"Bowling"},{"_id":"669a41073b226c10dc58120a","matchType":"669a3f49767133a748438e09","pointType":"669a3e83b1673fd0cdccff72","pointFor":"669a3d092381f922519f3b1a","points":8,"match_type_name":"T20","point_for_name":"Catch","point_for_status":"catch","point_type_name":"Fielding Points"},{"_id":"669a41073b226c10dc58120c","matchType":"669a3f49767133a748438e09","pointType":"669a3e83b1673fd0cdccff72","pointFor":"669a3d2f6521865c75c0b920","points":4,"match_type_name":"T20","point_for_name":"3 Catch Bonus","point_for_status":"three_catch","point_type_name":"Fielding Points"},{"_id":"669a41073b226c10dc58120e","matchType":"669a3f49767133a748438e09","pointType":"669a3e83b1673fd0cdccff72","pointFor":"669a3d3b6521865c75c0b925","points":12,"match_type_name":"T20","point_for_name":"Stumping","point_for_status":"stumping","point_type_name":"Fielding Points"},{"_id":"669a41073b226c10dc581210","matchType":"669a3f49767133a748438e09","pointType":"669a3e83b1673fd0cdccff72","pointFor":"669a3d4c6521865c75c0b92a","points":6,"match_type_name":"T20","point_for_name":"Run out","point_for_status":"runout","point_type_name":"Fielding Points"}]
//
// PointsSystemModel pointsSystemModelFromJson(String str) => PointsSystemModel.fromJson(json.decode(str));
// String pointsSystemModelToJson(PointsSystemModel data) => json.encode(data.toJson());
// class PointsSystemModel {
//   PointsSystemModel({
//       bool? success,
//       String? message,
//       List<Data>? data,}){
//     _success = success;
//     _message = message;
//     _data = data;
// }
//
//   PointsSystemModel.fromJson(dynamic json) {
//     _success = json['success'];
//     _message = json['message'];
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(Data.fromJson(v));
//       });
//     }
//   }
//   bool? _success;
//   String? _message;
//   List<Data>? _data;
// PointsSystemModel copyWith({  bool? success,
//   String? message,
//   List<Data>? data,
// }) => PointsSystemModel(  success: success ?? _success,
//   message: message ?? _message,
//   data: data ?? _data,
// );
//   bool? get success => _success;
//   String? get message => _message;
//   List<Data>? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['success'] = _success;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// /// _id : "669a3f8b3b226c10dc5811cb"
// /// matchType : "669a3f49767133a748438e09"
// /// pointType : "669a3df45370b31a798ae243"
// /// pointFor : "669a3b7c071193c4b7bd1197"
// /// points : 2
// /// match_type_name : "T20"
// /// point_for_name : "Six Bonus"
// /// point_for_status : "six"
// /// point_type_name : "Batting"
//
// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
// String dataToJson(Data data) => json.encode(data.toJson());
// class Data {
//   Data({
//       String? id,
//       String? matchType,
//       String? pointType,
//       String? pointFor,
//       num? points,
//       String? matchTypeName,
//       String? pointForName,
//       String? pointForStatus,
//       String? pointTypeName,}){
//     _id = id;
//     _matchType = matchType;
//     _pointType = pointType;
//     _pointFor = pointFor;
//     _points = points;
//     _matchTypeName = matchTypeName;
//     _pointForName = pointForName;
//     _pointForStatus = pointForStatus;
//     _pointTypeName = pointTypeName;
// }
//
//   Data.fromJson(dynamic json) {
//     _id = json['_id'];
//     _matchType = json['matchType'];
//     _pointType = json['pointType'];
//     _pointFor = json['pointFor'];
//     _points = json['points'];
//     _matchTypeName = json['match_type_name'];
//     _pointForName = json['point_for_name'];
//     _pointForStatus = json['point_for_status'];
//     _pointTypeName = json['point_type_name'];
//   }
//   String? _id;
//   String? _matchType;
//   String? _pointType;
//   String? _pointFor;
//   num? _points;
//   String? _matchTypeName;
//   String? _pointForName;
//   String? _pointForStatus;
//   String? _pointTypeName;
// Data copyWith({  String? id,
//   String? matchType,
//   String? pointType,
//   String? pointFor,
//   num? points,
//   String? matchTypeName,
//   String? pointForName,
//   String? pointForStatus,
//   String? pointTypeName,
// }) => Data(  id: id ?? _id,
//   matchType: matchType ?? _matchType,
//   pointType: pointType ?? _pointType,
//   pointFor: pointFor ?? _pointFor,
//   points: points ?? _points,
//   matchTypeName: matchTypeName ?? _matchTypeName,
//   pointForName: pointForName ?? _pointForName,
//   pointForStatus: pointForStatus ?? _pointForStatus,
//   pointTypeName: pointTypeName ?? _pointTypeName,
// );
//   String? get id => _id;
//   String? get matchType => _matchType;
//   String? get pointType => _pointType;
//   String? get pointFor => _pointFor;
//   num? get points => _points;
//   String? get matchTypeName => _matchTypeName;
//   String? get pointForName => _pointForName;
//   String? get pointForStatus => _pointForStatus;
//   String? get pointTypeName => _pointTypeName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['matchType'] = _matchType;
//     map['pointType'] = _pointType;
//     map['pointFor'] = _pointFor;
//     map['points'] = _points;
//     map['match_type_name'] = _matchTypeName;
//     map['point_for_name'] = _pointForName;
//     map['point_for_status'] = _pointForStatus;
//     map['point_type_name'] = _pointTypeName;
//     return map;
//   }
//
// }

class PointsSystemModel {
  bool? success;
  String? message;
  List<Data>? data;

  PointsSystemModel({this.success, this.message, this.data});

  PointsSystemModel.fromJson(Map<String, dynamic> json) {
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
  String? matchType;
  String? pointType;
  String? pointFor;
  int? points;
  String? matchTypeName;
  String? pointForName;
  String? pointForStatus;
  String? pointTypeName;

  Data(
      {this.sId,
        this.matchType,
        this.pointType,
        this.pointFor,
        this.points,
        this.matchTypeName,
        this.pointForName,
        this.pointForStatus,
        this.pointTypeName});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    matchType = json['matchType'];
    pointType = json['pointType'];
    pointFor = json['pointFor'];
    points = json['points'];
    matchTypeName = json['match_type_name'];
    pointForName = json['point_for_name'];
    pointForStatus = json['point_for_status'];
    pointTypeName = json['point_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['matchType'] = matchType;
    data['pointType'] = pointType;
    data['pointFor'] = pointFor;
    data['points'] = points;
    data['match_type_name'] = matchTypeName;
    data['point_for_name'] = pointForName;
    data['point_for_status'] = pointForStatus;
    data['point_type_name'] = pointTypeName;
    return data;
  }
}
