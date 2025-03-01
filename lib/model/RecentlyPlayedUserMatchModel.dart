import 'dart:convert';

// To parse this JSON data, use `MatchData.fromJson(jsonString)`.
class RecentlyPlayedUserMatchModel {
  bool? success;
  String? message;
  List<Match>? data;

  RecentlyPlayedUserMatchModel({this.success, this.message, this.data});

  factory RecentlyPlayedUserMatchModel.fromJson(Map<String, dynamic> json) => RecentlyPlayedUserMatchModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Match>.from(json["data"].map((x) => Match.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Match {
  String? contestId;
  String? id;
  String? matchName;
  DateTime? date;
  String? time;
  String? city;
  String? state;
  String? country;
  bool? isStarted;
  DateTime? createdAt;
  double? totalPoints;
  TeamDetails? team1Details;
  TeamDetails? team2Details;
  TeamScore? teamScore;
  String? matchResult;

  Match({
    this.contestId,
    this.id,
    this.matchName,
    this.date,
    this.time,
    this.city,
    this.state,
    this.country,
    this.isStarted,
    this.createdAt,
    this.totalPoints,
    this.team1Details,
    this.team2Details,
    this.teamScore,
    this.matchResult,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    contestId: json["contest_id"],
    id: json["_id"],
    matchName: json["match_name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    isStarted: json["isStarted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    // totalPoints: json["totalPoints"],
    totalPoints: (json["totalPoints"] as num?)?.toDouble(), // Convert to double

    team1Details: json["team_1_details"] == null
        ? null
        : TeamDetails.fromJson(json["team_1_details"]),
    team2Details: json["team_2_details"] == null
        ? null
        : TeamDetails.fromJson(json["team_2_details"]),
    teamScore: json["teamScore"] == null
        ? null
        : TeamScore.fromJson(json["teamScore"]),
    matchResult: json["matchResult"],
  );

  Map<String, dynamic> toJson() => {
    "contest_id": contestId,
    "_id": id,
    "match_name": matchName,
    "date": date?.toIso8601String(),
    "time": time,
    "city": city,
    "state": state,
    "country": country,
    "isStarted": isStarted,
    "createdAt": createdAt?.toIso8601String(),
    "totalPoints": totalPoints,
    "team_1_details": team1Details?.toJson(),
    "team_2_details": team2Details?.toJson(),
    "teamScore": teamScore?.toJson(),
    "matchResult": matchResult,
  };
}

class TeamDetails {
  String? id;
  String? teamName;
  String? logo;
  String? otherPhoto;
  String? shortName;
  String? captain;
  String? viceCaptain;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? version;
  String? colorCode;
  String? leagueId;

  TeamDetails({
    this.id,
    this.teamName,
    this.logo,
    this.otherPhoto,
    this.shortName,
    this.captain,
    this.viceCaptain,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.colorCode,
    this.leagueId,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
    id: json["_id"],
    teamName: json["team_name"],
    logo: json["logo"],
    otherPhoto: json["other_photo"],
    shortName: json["short_name"],
    captain: json["captain"],
    viceCaptain: json["vice_captain"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    version: json["__v"],
    colorCode: json["color_code"],
    leagueId: json["league_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "team_name": teamName,
    "logo": logo,
    "other_photo": otherPhoto,
    "short_name": shortName,
    "captain": captain,
    "vice_captain": viceCaptain,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": version,
    "color_code": colorCode,
    "league_id": leagueId,
  };
}

class TeamScore {
  TeamScoreDetails? team1;
  TeamScoreDetails? team2;

  TeamScore({this.team1, this.team2});

  factory TeamScore.fromJson(Map<String, dynamic> json) => TeamScore(
    team1: json["team1"] == null
        ? null
        : TeamScoreDetails.fromJson(json["team1"]),
    team2: json["team2"] == null
        ? null
        : TeamScoreDetails.fromJson(json["team2"]),
  );

  Map<String, dynamic> toJson() => {
    "team1": team1?.toJson(),
    "team2": team2?.toJson(),
  };
}

class TeamScoreDetails {
  String? score;
  int? innings;
  String? teamName;

  TeamScoreDetails({this.score, this.innings, this.teamName});

  factory TeamScoreDetails.fromJson(Map<String, dynamic> json) =>
      TeamScoreDetails(
        score: json["score"],
        innings: json["innings"],
        teamName: json["team_name"],
      );

  Map<String, dynamic> toJson() => {
    "score": score,
    "innings": innings,
    "team_name": teamName,
  };
}

// Utility function for decoding JSON
RecentlyPlayedUserMatchModel parseMatchData(String jsonStr) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonStr);
  return RecentlyPlayedUserMatchModel.fromJson(jsonData);
}

// import 'dart:convert';
//
// /// Parses JSON string to RecentlyPlayedUserMatchModel object
// RecentlyPlayedUserMatchModel recentlyPlayedUserMatchModelFromJson(String str) => RecentlyPlayedUserMatchModel.fromJson(json.decode(str));
//
// /// Converts RecentlyPlayedUserMatchModel object to JSON string
// String recentlyPlayedUserMatchModelToJson(RecentlyPlayedUserMatchModel data) => json.encode(data.toJson());
//
// class RecentlyPlayedUserMatchModel {
//   RecentlyPlayedUserMatchModel({
//     bool? success,
//     String? message,
//     List<Data>? data,
//   }) {
//     _success = success;
//     _message = message;
//     _data = data;
//   }
//
//   RecentlyPlayedUserMatchModel.fromJson(dynamic json) {
//     _success = json['success'];
//     _message = json['message'];
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   bool? _success;
//   String? _message;
//   List<Data>? _data;
//
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
// }
//
// class Data {
//   Data({
//     String? id,
//     String? matchName,
//     String? date,
//     String? team1Id,
//     String? team2Id,
//     String? time,
//     String? vanue,
//     String? city,
//     String? state,
//     String? country,
//     String? matchResult,
//     bool? isStarted,
//     num? overs,
//     num? innings,
//     String? createdAt,
//     TeamDetails? team1Details,
//     TeamDetails? team2Details,
//     TeamScore? teamScore,
//     int? totalPoints,
//   }) {
//     _id = id;
//     _matchName = matchName;
//     _date = date;
//     _team1Id = team1Id;
//     _team2Id = team2Id;
//     _time = time;
//     _vanue = vanue;
//     _city = city;
//     _state = state;
//     _country = country;
//     _matchResult = matchResult;
//     _isStarted = isStarted;
//     _overs = overs;
//     _innings = innings;
//     _createdAt = createdAt;
//     _team1Details = team1Details;
//     _team2Details = team2Details;
//     _teamScore = teamScore;
//     _totalPoints = totalPoints;
//   }
//
//   Data.fromJson(dynamic json) {
//     _id = json['_id'];
//     _matchName = json['match_name'];
//     _date = json['date'];
//     _team1Id = json['team_1_id'];
//     _team2Id = json['team_2_id'];
//     _time = json['time'];
//     _vanue = json['vanue'];
//     _city = json['city'];
//     _state = json['state'];
//     _country = json['country'];
//     _matchResult = json['matchResult'];
//     _isStarted = json['isStarted'];
//     _overs = json['overs'];
//     _innings = json['innings'];
//     _createdAt = json['createdAt'];
//     _totalPoints = json['totalPoints'];
//     _team1Details = json['team_1_details'] != null ? TeamDetails.fromJson(json['team_1_details']) : null;
//     _team2Details = json['team_2_details'] != null ? TeamDetails.fromJson(json['team_2_details']) : null;
//     _teamScore = json['teamScore'] != null ? TeamScore.fromJson(json['teamScore']) : null;
//   }
//
//   String? _id;
//   String? _matchName;
//   String? _date;
//   String? _team1Id;
//   String? _team2Id;
//   String? _time;
//   String? _vanue;
//   String? _city;
//   String? _state;
//   String? _country;
//   String? _matchResult;
//   bool? _isStarted;
//   num? _overs;
//   num? _innings;
//   String? _createdAt;
//   int? _totalPoints;
//   TeamDetails? _team1Details;
//   TeamDetails? _team2Details;
//   TeamScore? _teamScore;
//
//   String? get id => _id;
//   String? get matchName => _matchName;
//   String? get date => _date;
//   String? get team1Id => _team1Id;
//   String? get team2Id => _team2Id;
//   String? get time => _time;
//   String? get vanue => _vanue;
//   String? get city => _city;
//   String? get state => _state;
//   String? get country => _country;
//   String? get matchResult => _matchResult;
//   bool? get isStarted => _isStarted;
//   num? get overs => _overs;
//   num? get innings => _innings;
//   int? get totalPoints => _totalPoints;
//   String? get createdAt => _createdAt;
//   TeamDetails? get team1Details => _team1Details;
//   TeamDetails? get team2Details => _team2Details;
//   TeamScore? get teamScore => _teamScore;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['match_name'] = _matchName;
//     map['date'] = _date;
//     map['team_1_id'] = _team1Id;
//     map['team_2_id'] = _team2Id;
//     map['time'] = _time;
//     map['vanue'] = _vanue;
//     map['city'] = _city;
//     map['state'] = _state;
//     map['country'] = _country;
//     map['matchResult'] = _matchResult;
//     map['isStarted'] = _isStarted;
//     map['overs'] = _overs;
//     map['innings'] = _innings;
//     map['totalPoints'] = _totalPoints;
//     map['createdAt'] = _createdAt;
//     if (_team1Details != null) {
//       map['team_1_details'] = _team1Details?.toJson();
//     }
//     if (_team2Details != null) {
//       map['team_2_details'] = _team2Details?.toJson();
//     }
//     if (_teamScore != null) {
//       map['teamScore'] = _teamScore?.toJson();
//     }
//     return map;
//   }
// }
//
// class TeamScore {
//   TeamScore({
//     required this.team1,
//     required this.team2,
//   });
//
//   TeamScore.fromJson(Map<String, dynamic> json)
//       : team1 = ScoreDetails.fromJson(json['team1']),
//         team2 = ScoreDetails.fromJson(json['team2']);
//
//   ScoreDetails team1;
//   ScoreDetails team2;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'team1': team1.toJson(),
//       'team2': team2.toJson(),
//     };
//   }
// }
//
// class ScoreDetails {
//   ScoreDetails({
//     required this.teamName,
//     required this.score,
//   });
//
//   ScoreDetails.fromJson(Map<String, dynamic> json)
//       : teamName = json['teamName'],
//         score = json['score'];
//
//   String teamName;
//   String score;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'teamName': teamName,
//       'score': score,
//     };
//   }
// }
//
// class TeamDetails {
//   TeamDetails({
//     String? id,
//     String? teamName,
//     String? shortName,
//     String? logo,
//     String? otherPhoto,
//     String? captain,
//     String? viceCaptain,
//     String? leagueId,
//     String? colorCode,
//   }) {
//     _id = id;
//     _teamName = teamName;
//     _shortName = shortName;
//     _logo = logo;
//     _otherPhoto = otherPhoto;
//     _captain = captain;
//     _viceCaptain = viceCaptain;
//     _leagueId = leagueId;
//     _colorCode = colorCode;
//   }
//
//   TeamDetails.fromJson(dynamic json) {
//     _id = json['_id'];
//     _teamName = json['team_name'];
//     _shortName = json['short_name'];
//     _logo = json['logo'];
//     _otherPhoto = json['other_photo'];
//     _captain = json['captain'];
//     _viceCaptain = json['vice_captain'];
//     _leagueId = json['league_id'];
//     _colorCode = json['color_code'];
//   }
//
//   String? _id;
//   String? _teamName;
//   String? _shortName;
//   String? _logo;
//   String? _otherPhoto;
//   String? _captain;
//   String? _viceCaptain;
//   String? _leagueId;
//   String? _colorCode;
//
//   String? get id => _id;
//   String? get teamName => _teamName;
//   String? get shortName => _shortName;
//   String? get logo => _logo;
//   String? get otherPhoto => _otherPhoto;
//   String? get captain => _captain;
//   String? get viceCaptain => _viceCaptain;
//   String? get leagueId => _leagueId;
//   String? get colorCode => _colorCode;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['team_name'] = _teamName;
//     map['short_name'] = _shortName;
//     map['logo'] = _logo;
//     map['other_photo'] = _otherPhoto;
//     map['captain'] = _captain;
//     map['vice_captain'] = _viceCaptain;
//     map['league_id'] = _leagueId;
//     map['color_code'] = _colorCode;
//     return map;
//   }
// }
//
// // import 'dart:convert';
// // /// success : true
// // /// message : "Display Last Recently Play Match"
// // /// data : [{"_id":"66c87953c8d5a2490fe4498e","match_name":"PK vs RCB","date":"2024-09-22T00:00:00.000Z","team_1_id":"669a4f4a91f4793dc9421a29","team_2_id":"669a4f9d91f4793dc9421a3b","time":"12:00","vanue":"M Chinnaswamy Stadium","city":"Bangalore Urban","state":"Karnataka","country":"India","isStarted":false,"overs":20,"innings":2,"createdAt":"2024-07-19T14:29:04.224Z","team_1_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"},"team_2_details":{"_id":"669a4f9d91f4793dc9421a3b","team_name":"Royal Challengers Bengaluru","logo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","captain":"669a448491f4793dc942183f","vice_captain":"669a42a891f4793dc9421835","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]
// //
// // RecentlyPlayedUserMatchModel recentlyPlayedUserMatchModelFromJson(String str) => RecentlyPlayedUserMatchModel.fromJson(json.decode(str));
// // String recentlyPlayedUserMatchModelToJson(RecentlyPlayedUserMatchModel data) => json.encode(data.toJson());
// // class RecentlyPlayedUserMatchModel {
// //   RecentlyPlayedUserMatchModel({
// //       bool? success,
// //       String? message,
// //       List<Data>? data,}){
// //     _success = success;
// //     _message = message;
// //     _data = data;
// // }
// //
// //   RecentlyPlayedUserMatchModel.fromJson(dynamic json) {
// //     _success = json['success'];
// //     _message = json['message'];
// //     if (json['data'] != null) {
// //       _data = [];
// //       json['data'].forEach((v) {
// //         _data?.add(Data.fromJson(v));
// //       });
// //     }
// //   }
// //   bool? _success;
// //   String? _message;
// //   List<Data>? _data;
// // RecentlyPlayedUserMatchModel copyWith({  bool? success,
// //   String? message,
// //   List<Data>? data,
// // }) => RecentlyPlayedUserMatchModel(  success: success ?? _success,
// //   message: message ?? _message,
// //   data: data ?? _data,
// // );
// //   bool? get success => _success;
// //   String? get message => _message;
// //   List<Data>? get data => _data;
// //
// //   Map<String, dynamic> toJson() {
// //     final map = <String, dynamic>{};
// //     map['success'] = _success;
// //     map['message'] = _message;
// //     if (_data != null) {
// //       map['data'] = _data?.map((v) => v.toJson()).toList();
// //     }
// //     return map;
// //   }
// //
// // }
// //
// // /// _id : "66c87953c8d5a2490fe4498e"
// // /// match_name : "PK vs RCB"
// // /// date : "2024-09-22T00:00:00.000Z"
// // /// team_1_id : "669a4f4a91f4793dc9421a29"
// // /// team_2_id : "669a4f9d91f4793dc9421a3b"
// // /// time : "12:00"
// // /// vanue : "M Chinnaswamy Stadium"
// // /// city : "Bangalore Urban"
// // /// state : "Karnataka"
// // /// country : "India"
// // /// isStarted : false
// // /// overs : 20
// // /// innings : 2
// // /// createdAt : "2024-07-19T14:29:04.224Z"
// // /// team_1_details : {"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}
// // /// team_2_details : {"_id":"669a4f9d91f4793dc9421a3b","team_name":"Royal Challengers Bengaluru","logo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","captain":"669a448491f4793dc942183f","vice_captain":"669a42a891f4793dc9421835","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}
// //
// // Data dataFromJson(String str) => Data.fromJson(json.decode(str));
// // String dataToJson(Data data) => json.encode(data.toJson());
// // class Data {
// //   Data({
// //       String? id,
// //       String? matchName,
// //       String? date,
// //       String? team1Id,
// //       String? team2Id,
// //       String? time,
// //       String? vanue,
// //       String? city,
// //       String? state,
// //       String? country,
// //       bool? isStarted,
// //       num? overs,
// //       num? innings,
// //       String? createdAt,
// //       Team1Details? team1Details,
// //       Team2Details? team2Details,}){
// //     _id = id;
// //     _matchName = matchName;
// //     _date = date;
// //     _team1Id = team1Id;
// //     _team2Id = team2Id;
// //     _time = time;
// //     _vanue = vanue;
// //     _city = city;
// //     _state = state;
// //     _country = country;
// //     _isStarted = isStarted;
// //     _overs = overs;
// //     _innings = innings;
// //     _createdAt = createdAt;
// //     _team1Details = team1Details;
// //     _team2Details = team2Details;
// // }
// //
// //   Data.fromJson(dynamic json) {
// //     _id = json['_id'];
// //     _matchName = json['match_name'];
// //     _date = json['date'];
// //     _team1Id = json['team_1_id'];
// //     _team2Id = json['team_2_id'];
// //     _time = json['time'];
// //     _vanue = json['vanue'];
// //     _city = json['city'];
// //     _state = json['state'];
// //     _country = json['country'];
// //     _isStarted = json['isStarted'];
// //     _overs = json['overs'];
// //     _innings = json['innings'];
// //     _createdAt = json['createdAt'];
// //     _team1Details = json['team_1_details'] != null ? Team1Details.fromJson(json['team_1_details']) : null;
// //     _team2Details = json['team_2_details'] != null ? Team2Details.fromJson(json['team_2_details']) : null;
// //   }
// //   String? _id;
// //   String? _matchName;
// //   String? _date;
// //   String? _team1Id;
// //   String? _team2Id;
// //   String? _time;
// //   String? _vanue;
// //   String? _city;
// //   String? _state;
// //   String? _country;
// //   bool? _isStarted;
// //   num? _overs;
// //   num? _innings;
// //   String? _createdAt;
// //   Team1Details? _team1Details;
// //   Team2Details? _team2Details;
// // Data copyWith({  String? id,
// //   String? matchName,
// //   String? date,
// //   String? team1Id,
// //   String? team2Id,
// //   String? time,
// //   String? vanue,
// //   String? city,
// //   String? state,
// //   String? country,
// //   bool? isStarted,
// //   num? overs,
// //   num? innings,
// //   String? createdAt,
// //   Team1Details? team1Details,
// //   Team2Details? team2Details,
// // }) => Data(  id: id ?? _id,
// //   matchName: matchName ?? _matchName,
// //   date: date ?? _date,
// //   team1Id: team1Id ?? _team1Id,
// //   team2Id: team2Id ?? _team2Id,
// //   time: time ?? _time,
// //   vanue: vanue ?? _vanue,
// //   city: city ?? _city,
// //   state: state ?? _state,
// //   country: country ?? _country,
// //   isStarted: isStarted ?? _isStarted,
// //   overs: overs ?? _overs,
// //   innings: innings ?? _innings,
// //   createdAt: createdAt ?? _createdAt,
// //   team1Details: team1Details ?? _team1Details,
// //   team2Details: team2Details ?? _team2Details,
// // );
// //   String? get id => _id;
// //   String? get matchName => _matchName;
// //   String? get date => _date;
// //   String? get team1Id => _team1Id;
// //   String? get team2Id => _team2Id;
// //   String? get time => _time;
// //   String? get vanue => _vanue;
// //   String? get city => _city;
// //   String? get state => _state;
// //   String? get country => _country;
// //   bool? get isStarted => _isStarted;
// //   num? get overs => _overs;
// //   num? get innings => _innings;
// //   String? get createdAt => _createdAt;
// //   Team1Details? get team1Details => _team1Details;
// //   Team2Details? get team2Details => _team2Details;
// //
// //   Map<String, dynamic> toJson() {
// //     final map = <String, dynamic>{};
// //     map['_id'] = _id;
// //     map['match_name'] = _matchName;
// //     map['date'] = _date;
// //     map['team_1_id'] = _team1Id;
// //     map['team_2_id'] = _team2Id;
// //     map['time'] = _time;
// //     map['vanue'] = _vanue;
// //     map['city'] = _city;
// //     map['state'] = _state;
// //     map['country'] = _country;
// //     map['isStarted'] = _isStarted;
// //     map['overs'] = _overs;
// //     map['innings'] = _innings;
// //     map['createdAt'] = _createdAt;
// //     if (_team1Details != null) {
// //       map['team_1_details'] = _team1Details?.toJson();
// //     }
// //     if (_team2Details != null) {
// //       map['team_2_details'] = _team2Details?.toJson();
// //     }
// //     return map;
// //   }
// //
// // }
// //
// // /// _id : "669a4f9d91f4793dc9421a3b"
// // /// team_name : "Royal Challengers Bengaluru"
// // /// logo : "https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png"
// // /// other_photo : "https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png"
// // /// captain : "669a448491f4793dc942183f"
// // /// vice_captain : "669a42a891f4793dc9421835"
// // /// league_id : "669a499db7d111a9d554f5d0"
// // /// color_code : "#ff0000"
// //
// // Team2Details team2DetailsFromJson(String str) => Team2Details.fromJson(json.decode(str));
// // String team2DetailsToJson(Team2Details data) => json.encode(data.toJson());
// // class Team2Details {
// //   Team2Details({
// //       String? id,
// //       String? teamName,
// //       String? short_name,
// //       String? logo,
// //       String? otherPhoto,
// //       String? captain,
// //       String? viceCaptain,
// //       String? leagueId,
// //       String? colorCode,}){
// //     _id = id;
// //     _teamName = teamName;
// //     _short_name = short_name;
// //     _logo = logo;
// //     _otherPhoto = otherPhoto;
// //     _captain = captain;
// //     _viceCaptain = viceCaptain;
// //     _leagueId = leagueId;
// //     _colorCode = colorCode;
// // }
// //
// //   Team2Details.fromJson(dynamic json) {
// //     _id = json['_id'];
// //     _teamName = json['team_name'];
// //     _short_name = json['short_name'];
// //     _logo = json['logo'];
// //     _otherPhoto = json['other_photo'];
// //     _captain = json['captain'];
// //     _viceCaptain = json['vice_captain'];
// //     _leagueId = json['league_id'];
// //     _colorCode = json['color_code'];
// //   }
// //   String? _id;
// //   String? _teamName;
// //   String? _short_name;
// //   String? _logo;
// //   String? _otherPhoto;
// //   String? _captain;
// //   String? _viceCaptain;
// //   String? _leagueId;
// //   String? _colorCode;
// // Team2Details copyWith({  String? id,
// //   String? teamName,
// //   String? short_name,
// //   String? logo,
// //   String? otherPhoto,
// //   String? captain,
// //   String? viceCaptain,
// //   String? leagueId,
// //   String? colorCode,
// // }) => Team2Details(  id: id ?? _id,
// //   teamName: teamName ?? _teamName,
// //   short_name: short_name ?? _short_name,
// //   logo: logo ?? _logo,
// //   otherPhoto: otherPhoto ?? _otherPhoto,
// //   captain: captain ?? _captain,
// //   viceCaptain: viceCaptain ?? _viceCaptain,
// //   leagueId: leagueId ?? _leagueId,
// //   colorCode: colorCode ?? _colorCode,
// // );
// //   String? get id => _id;
// //   String? get teamName => _teamName;
// //   String? get short_name => _short_name;
// //   String? get logo => _logo;
// //   String? get otherPhoto => _otherPhoto;
// //   String? get captain => _captain;
// //   String? get viceCaptain => _viceCaptain;
// //   String? get leagueId => _leagueId;
// //   String? get colorCode => _colorCode;
// //
// //   Map<String, dynamic> toJson() {
// //     final map = <String, dynamic>{};
// //     map['_id'] = _id;
// //     map['team_name'] = _teamName;
// //     map['short_name'] = _short_name;
// //     map['logo'] = _logo;
// //     map['other_photo'] = _otherPhoto;
// //     map['captain'] = _captain;
// //     map['vice_captain'] = _viceCaptain;
// //     map['league_id'] = _leagueId;
// //     map['color_code'] = _colorCode;
// //     return map;
// //   }
// //
// // }
// //
// // /// _id : "669a4f4a91f4793dc9421a29"
// // /// team_name : "Punjab Kings"
// // /// logo : "https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png"
// // /// other_photo : "https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png"
// // /// captain : "669a48f591f4793dc94218c6"
// // /// vice_captain : "669a4cd791f4793dc9421984"
// // /// league_id : "669a499db7d111a9d554f5d0"
// // /// color_code : "#ff0000"
// //
// // Team1Details team1DetailsFromJson(String str) => Team1Details.fromJson(json.decode(str));
// // String team1DetailsToJson(Team1Details data) => json.encode(data.toJson());
// // class Team1Details {
// //   Team1Details({
// //       String? id,
// //       String? teamName,
// //     String? short_name,
// //     String? logo,
// //       String? otherPhoto,
// //       String? captain,
// //       String? viceCaptain,
// //       String? leagueId,
// //       String? colorCode,}){
// //     _id = id;
// //     _teamName = teamName;
// //     _short_name = short_name;
// //     _logo = logo;
// //     _otherPhoto = otherPhoto;
// //     _captain = captain;
// //     _viceCaptain = viceCaptain;
// //     _leagueId = leagueId;
// //     _colorCode = colorCode;
// // }
// //
// //   Team1Details.fromJson(dynamic json) {
// //     _id = json['_id'];
// //     _teamName = json['team_name'];
// //     _short_name = json['short_name'];
// //     _logo = json['logo'];
// //     _otherPhoto = json['other_photo'];
// //     _captain = json['captain'];
// //     _viceCaptain = json['vice_captain'];
// //     _leagueId = json['league_id'];
// //     _colorCode = json['color_code'];
// //   }
// //   String? _id;
// //   String? _teamName;
// //   String? _short_name;
// //   String? _logo;
// //   String? _otherPhoto;
// //   String? _captain;
// //   String? _viceCaptain;
// //   String? _leagueId;
// //   String? _colorCode;
// // Team1Details copyWith({  String? id,
// //   String? teamName,
// //   String? short_name,
// //   String? logo,
// //   String? otherPhoto,
// //   String? captain,
// //   String? viceCaptain,
// //   String? leagueId,
// //   String? colorCode,
// // }) => Team1Details(  id: id ?? _id,
// //   teamName: teamName ?? _teamName,
// //   short_name: short_name ?? _short_name,
// //   logo: logo ?? _logo,
// //   otherPhoto: otherPhoto ?? _otherPhoto,
// //   captain: captain ?? _captain,
// //   viceCaptain: viceCaptain ?? _viceCaptain,
// //   leagueId: leagueId ?? _leagueId,
// //   colorCode: colorCode ?? _colorCode,
// // );
// //   String? get id => _id;
// //   String? get teamName => _teamName;
// //   String? get short_name => _short_name;
// //   String? get logo => _logo;
// //   String? get otherPhoto => _otherPhoto;
// //   String? get captain => _captain;
// //   String? get viceCaptain => _viceCaptain;
// //   String? get leagueId => _leagueId;
// //   String? get colorCode => _colorCode;
// //
// //   Map<String, dynamic> toJson() {
// //     final map = <String, dynamic>{};
// //     map['_id'] = _id;
// //     map['team_name'] = _teamName;
// //     map['short_name'] = _short_name;
// //     map['logo'] = _logo;
// //     map['other_photo'] = _otherPhoto;
// //     map['captain'] = _captain;
// //     map['vice_captain'] = _viceCaptain;
// //     map['league_id'] = _leagueId;
// //     map['color_code'] = _colorCode;
// //     return map;
// //   }
// //
// // }