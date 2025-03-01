import 'dart:convert';

// Function to parse the JSON response into UserMyMatchesModel
UserMyMatchesModel userMyMatchesModelFromJson(String str) => UserMyMatchesModel.fromJson(json.decode(str));
String userMyMatchesModelToJson(UserMyMatchesModel data) => json.encode(data.toJson());

class UserMyMatchesModel {
  UserMyMatchesModel({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  UserMyMatchesModel.fromJson(dynamic json) {
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

class Data {
  Data({
    LiveMatches? liveMatches,
    UpcomingMatches? upcomingMatches,
    CompletedMatches? completedMatches,
  }) {
    _liveMatches = liveMatches;
    _upcomingMatches = upcomingMatches;
    _completedMatches = completedMatches;
  }

  Data.fromJson(dynamic json) {
    _liveMatches = json['liveMatches'] != null ? LiveMatches.fromJson(json['liveMatches']) : null;
    _upcomingMatches = json['upcomingMatches'] != null ? UpcomingMatches.fromJson(json['upcomingMatches']) : null;
    _completedMatches = json['completedMatches'] != null ? CompletedMatches.fromJson(json['completedMatches']) : null;
  }

  LiveMatches? _liveMatches;
  UpcomingMatches? _upcomingMatches;
  CompletedMatches? _completedMatches;

  LiveMatches? get liveMatches => _liveMatches;
  UpcomingMatches? get upcomingMatches => _upcomingMatches;
  CompletedMatches? get completedMatches => _completedMatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_liveMatches != null) {
      map['liveMatches'] = _liveMatches?.toJson();
    }
    if (_upcomingMatches != null) {
      map['upcomingMatches'] = _upcomingMatches?.toJson();
    }
    if (_completedMatches != null) {
      map['completedMatches'] = _completedMatches?.toJson();
    }
    return map;
  }
}

class LiveMatches {
  LiveMatches({
    List<Matches>? matches,
  }) {
    _matches = matches;
  }

  LiveMatches.fromJson(dynamic json) {
    if (json['matches'] != null) {
      _matches = [];
      json['matches'].forEach((v) {
        _matches?.add(Matches.fromJson(v));
      });
    }
  }

  List<Matches>? _matches;

  List<Matches>? get matches => _matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matches != null) {
      map['matches'] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UpcomingMatches {
  UpcomingMatches({
    List<Matches>? matches,
  }) {
    _matches = matches;
  }

  UpcomingMatches.fromJson(dynamic json) {
    if (json['matches'] != null) {
      _matches = [];
      json['matches'].forEach((v) {
        _matches?.add(Matches.fromJson(v));
      });
    }
  }

  List<Matches>? _matches;

  List<Matches>? get matches => _matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matches != null) {
      map['matches'] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CompletedMatches {
  CompletedMatches({
    List<Matches>? matches,
  }) {
    _matches = matches;
  }

  CompletedMatches.fromJson(dynamic json) {
    if (json['matches'] != null) {
      _matches = [];
      json['matches'].forEach((v) {
        _matches?.add(Matches.fromJson(v));
      });
    }
  }

  List<Matches>? _matches;

  List<Matches>? get matches => _matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matches != null) {
      map['matches'] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Matches {
  Matches({
    String? id,
    String? contestId,
    String? matchName,
    String? date,
    String? time,
    String? city,
    String? state,
    String? country,
    bool? isStarted,
    String? createdAt,
    String? winningAmount,
    Team1Details? team1Details,
    Team2Details? team2Details,
    TeamScore? teamScore,}){
    _id = id;
    _contestId = contestId;
    _matchName = matchName;
    _date = date;
    _time = time;
    _city = city;
    _state = state;
    _country = country;
    _isStarted = isStarted;
    _createdAt = createdAt;
    _winningAmount = winningAmount;
    _team1Details = team1Details;
    _team2Details = team2Details;
    _teamScore = teamScore;
  }

  Matches.fromJson(dynamic json) {
    _id = json['_id'];
    _contestId = json['contest_id'];
    _matchName = json['match_name'];
    _date = json['date'];
    _time = json['time'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _isStarted = json['isStarted'];
    _createdAt = json['createdAt'];
    _winningAmount = json['winningAmount'];
    _team1Details = json['team_1_details'] != null ? Team1Details.fromJson(json['team_1_details']) : null;
    _team2Details = json['team_2_details'] != null ? Team2Details.fromJson(json['team_2_details']) : null;
    _teamScore = json['teamScore'] != null ? TeamScore.fromJson(json['teamScore']) : null;
  }

  String? _id;
  String? _contestId;
  String? _matchName;
  String? _date;
  String? _time;
  String? _city;
  String? _state;
  String? _country;
  bool? _isStarted;
  String? _createdAt;
  String? _winningAmount;
  Team1Details? _team1Details;
  Team2Details? _team2Details;
  TeamScore? _teamScore;
  Matches copyWith({  String? id,
    String? contestId,
    String? matchName,
    String? date,
    String? time,
    String? city,
    String? state,
    String? country,
    bool? isStarted,
    String? createdAt,
    String? winningAmount,
    Team1Details? team1Details,
    Team2Details? team2Details,
    TeamScore? teamScore,
  }) => Matches(  id: id ?? _id,
    contestId: contestId ?? _contestId,
    matchName: matchName ?? _matchName,
    date: date ?? _date,
    time: time ?? _time,
    city: city ?? _city,
    state: state ?? _state,
    country: country ?? _country,
    isStarted: isStarted ?? _isStarted,
    createdAt: createdAt ?? _createdAt,
    winningAmount: winningAmount?? _winningAmount,
    team1Details: team1Details ?? _team1Details,
    team2Details: team2Details ?? _team2Details,
    teamScore: teamScore ?? _teamScore,
  );

  String? get id => _id;
  String? get contestId => _contestId;
  String? get matchName => _matchName;
  String? get date => _date;
  String? get time => _time;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  bool? get isStarted => _isStarted;
  String? get createdAt => _createdAt;
  String? get winningAmount => _winningAmount;
  Team1Details? get team1Details => _team1Details;
  Team2Details? get team2Details => _team2Details;
  TeamScore? get teamScore => _teamScore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['contest_id'] = _contestId;
    map['match_name'] = _matchName;
    map['date'] = _date;
    map['time'] = _time;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['isStarted'] = _isStarted;
    map['createdAt'] = _createdAt;
    if (_team1Details != null) {
      map['team_1_details'] = _team1Details?.toJson();
    }
    if (_team2Details != null) {
      map['team_2_details'] = _team2Details?.toJson();
    }
    if (_teamScore != null) {
      map['teamScore'] = _teamScore?.toJson();
    }
    return map;
  }
}


TeamScore teamScoreFromJson(String str) => TeamScore.fromJson(json.decode(str));
String teamScoreToJson(TeamScore data) => json.encode(data.toJson());
class TeamScore {
  TeamScore({
    Team1? team1,
    Team2? team2,}){
    _team1 = team1;
    _team2 = team2;
  }

  TeamScore.fromJson(dynamic json) {
    _team1 = json['team1'] != null ? Team1.fromJson(json['team1']) : null;
    _team2 = json['team2'] != null ? Team2.fromJson(json['team2']) : null;
  }
  Team1? _team1;
  Team2? _team2;
  TeamScore copyWith({  Team1? team1,
    Team2? team2,
  }) => TeamScore(  team1: team1 ?? _team1,
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

/// score : "0/0 (0.0)"
/// innings : 0
/// team_name : "Sunrisers Hyderabad"

Team2 team2FromJson(String str) => Team2.fromJson(json.decode(str));
String team2ToJson(Team2 data) => json.encode(data.toJson());
class Team2 {
  Team2({
    String? score,
    num? innings,
    String? teamName,}){
    _score = score;
    _innings = innings;
    _teamName = teamName;
  }

  Team2.fromJson(dynamic json) {
    _score = json['score'];
    _innings = json['innings'];
    _teamName = json['team_name'];
  }
  String? _score;
  num? _innings;
  String? _teamName;
  Team2 copyWith({  String? score,
    num? innings,
    String? teamName,
  }) => Team2(  score: score ?? _score,
    innings: innings ?? _innings,
    teamName: teamName ?? _teamName,
  );
  String? get score => _score;
  num? get innings => _innings;
  String? get teamName => _teamName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['score'] = _score;
    map['innings'] = _innings;
    map['team_name'] = _teamName;
    return map;
  }

}

/// score : "95/1 (7.0)"
/// innings : 1
/// team_name : "Kolkata Knight Riders"

Team1 team1FromJson(String str) => Team1.fromJson(json.decode(str));
String team1ToJson(Team1 data) => json.encode(data.toJson());
class Team1 {
  Team1({
    String? score,
    num? innings,
    String? teamName,}){
    _score = score;
    _innings = innings;
    _teamName = teamName;
  }

  Team1.fromJson(dynamic json) {
    _score = json['score'];
    _innings = json['innings'];
    _teamName = json['team_name'];
  }
  String? _score;
  num? _innings;
  String? _teamName;
  Team1 copyWith({  String? score,
    num? innings,
    String? teamName,
  }) => Team1(  score: score ?? _score,
    innings: innings ?? _innings,
    teamName: teamName ?? _teamName,
  );
  String? get score => _score;
  num? get innings => _innings;
  String? get teamName => _teamName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['score'] = _score;
    map['innings'] = _innings;
    map['team_name'] = _teamName;
    return map;
  }

}

Team2Details team2DetailsFromJson(String str) => Team2Details.fromJson(json.decode(str));
String team2DetailsToJson(Team2Details data) => json.encode(data.toJson());
class Team2Details {
  Team2Details({
    String? id,
    String? teamName,
    String? shortName,
    String? logo,
    String? otherPhoto,
    String? colorCode,}){
    _id = id;
    _teamName = teamName;
    _shortName = shortName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _colorCode = colorCode;
  }

  Team2Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _shortName = json['short_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _colorCode = json['color_code'];
  }
  String? _id;
  String? _teamName;
  String? _shortName;
  String? _logo;
  String? _otherPhoto;
  String? _colorCode;
  Team2Details copyWith({  String? id,
    String? teamName,
    String? shortName,
    String? logo,
    String? otherPhoto,
    String? colorCode,
  }) => Team2Details(  id: id ?? _id,
    teamName: teamName ?? _teamName,
    shortName: shortName ?? _shortName,
    logo: logo ?? _logo,
    otherPhoto: otherPhoto ?? _otherPhoto,
    colorCode: colorCode ?? _colorCode,
  );
  String? get id => _id;
  String? get teamName => _teamName;
  String? get shortName => _shortName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['short_name'] = _shortName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['color_code'] = _colorCode;
    return map;
  }

}

Team1Details team1DetailsFromJson(String str) => Team1Details.fromJson(json.decode(str));
String team1DetailsToJson(Team1Details data) => json.encode(data.toJson());
class Team1Details {
  Team1Details({
    String? id,
    String? teamName,
    String? shortName,
    String? logo,
    String? otherPhoto,
    String? colorCode,}){
    _id = id;
    _teamName = teamName;
    _shortName = shortName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _colorCode = colorCode;
  }

  Team1Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _shortName = json['short_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _colorCode = json['color_code'];
  }
  String? _id;
  String? _teamName;
  String? _shortName;
  String? _logo;
  String? _otherPhoto;
  String? _colorCode;
  Team1Details copyWith({  String? id,
    String? teamName,
    String? shortName,
    String? logo,
    String? otherPhoto,
    String? colorCode,
  }) => Team1Details(  id: id ?? _id,
    teamName: teamName ?? _teamName,
    shortName: shortName ?? _shortName,
    logo: logo ?? _logo,
    otherPhoto: otherPhoto ?? _otherPhoto,
    colorCode: colorCode ?? _colorCode,
  );
  String? get id => _id;
  String? get teamName => _teamName;
  String? get shortName => _shortName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['short_name'] = _shortName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['color_code'] = _colorCode;
    return map;
  }

}

// class TeamDetails {
//   TeamDetails({
//     String? teamName,
//     String? short_name,
//     String? logo,
//     String? otherPhoto,
//     String? captain,
//     String? viceCaptain,
//     String? leagueId,
//     String? colorCode,
//   }) {
//     _teamName = teamName;
//     _short_name = short_name;
//     _logo = logo;
//     _otherPhoto = otherPhoto;
//     _captain = captain;
//     _viceCaptain = viceCaptain;
//     _leagueId = leagueId;
//     _colorCode = colorCode;
//   }
//
//   TeamDetails.fromJson(dynamic json) {
//     _teamName = json['team_name'];
//     _short_name = json['short_name'];
//     _logo = json['logo'];
//     _otherPhoto = json['other_photo'];
//     _captain = json['captain'];
//     _viceCaptain = json['vice_captain'];
//     _leagueId = json['league_id'];
//     _colorCode = json['color_code'];
//   }
//
//   String? _teamName;
//   String? _short_name;
//   String? _logo;
//   String? _otherPhoto;
//   String? _captain;
//   String? _viceCaptain;
//   String? _leagueId;
//   String? _colorCode;
//
//   String? get teamName => _teamName;
//   String? get short_name => _short_name;
//   String? get logo => _logo;
//   String? get otherPhoto => _otherPhoto;
//   String? get captain => _captain;
//   String? get viceCaptain => _viceCaptain;
//   String? get leagueId => _leagueId;
//   String? get colorCode => _colorCode;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['team_name'] = _teamName;
//     map['short_name'] = _short_name;
//     map['logo'] = _logo;
//     map['other_photo'] = _otherPhoto;
//     map['captain'] = _captain;
//     map['vice_captain'] = _viceCaptain;
//     map['league_id'] = _leagueId;
//     map['color_code'] = _colorCode;
//     return map;
//   }
// }
