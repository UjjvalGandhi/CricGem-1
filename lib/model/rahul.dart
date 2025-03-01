import 'dart:convert';
/// success : true
/// message : "Display Play Match User"
/// data : [{"liveMatches":{"matches":[{"_id":"669a745cea635b7eb2179332","match_name":"KKR vs SH","date":"2024-09-26T00:00:00.000Z","time":"13:20","city":"Kolkata","state":"West Bengal","country":"India","isStarted":true,"createdAt":"2024-07-19T14:12:44.105Z","team_1_details":{"_id":"669a4e6e91f4793dc94219fb","team_name":"Kolkata Knight Riders","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","color_code":"#9e00ff"},"team_2_details":{"_id":"669a501591f4793dc9421a6e","team_name":"Sunrisers Hyderabad","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","color_code":"#ff9900"},"teamScore":{"team1":{"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"},"team2":{"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}}}]}},{"upcomingMatches":{"matches":[{"_id":"66a1eb65385101014e26e144","match_name":"DC vs PK","date":"2024-09-27T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a35d4639b48ee96a1b9161","match_name":"DC vs PK","date":"2024-09-27T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66c8202eadd3e63ed8251b97","match_name":"DC vs PK","date":"2024-09-27T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]}},{"completedMatches":{"matches":[{"_id":"669a745cea635b7eb2179332","match_name":"KKR vs SH","date":"2024-09-26T00:00:00.000Z","time":"13:20","city":"Kolkata","state":"West Bengal","country":"India","isStarted":true,"createdAt":"2024-07-19T14:12:44.105Z","team_1_details":{"_id":"669a4e6e91f4793dc94219fb","team_name":"Kolkata Knight Riders","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","color_code":"#9e00ff"},"team_2_details":{"_id":"669a501591f4793dc9421a6e","team_name":"Sunrisers Hyderabad","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","color_code":"#ff9900"},"teamScore":{"team1":{"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"},"team2":{"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}}}]}}]

Rahul rahulFromJson(String str) => Rahul.fromJson(json.decode(str));
String rahulToJson(Rahul data) => json.encode(data.toJson());
class Rahul {
  Rahul({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  Rahul.fromJson(dynamic json) {
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
Rahul copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Rahul(  success: success ?? _success,
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

/// liveMatches : {"matches":[{"_id":"669a745cea635b7eb2179332","match_name":"KKR vs SH","date":"2024-09-26T00:00:00.000Z","time":"13:20","city":"Kolkata","state":"West Bengal","country":"India","isStarted":true,"createdAt":"2024-07-19T14:12:44.105Z","team_1_details":{"_id":"669a4e6e91f4793dc94219fb","team_name":"Kolkata Knight Riders","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","color_code":"#9e00ff"},"team_2_details":{"_id":"669a501591f4793dc9421a6e","team_name":"Sunrisers Hyderabad","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","color_code":"#ff9900"},"teamScore":{"team1":{"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"},"team2":{"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}}}]}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      LiveMatches? liveMatches,}){
    _liveMatches = liveMatches;
}

  Data.fromJson(dynamic json) {
    _liveMatches = json['liveMatches'] != null ? LiveMatches.fromJson(json['liveMatches']) : null;
  }
  LiveMatches? _liveMatches;
Data copyWith({  LiveMatches? liveMatches,
}) => Data(  liveMatches: liveMatches ?? _liveMatches,
);
  LiveMatches? get liveMatches => _liveMatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_liveMatches != null) {
      map['liveMatches'] = _liveMatches?.toJson();
    }
    return map;
  }

}

/// matches : [{"_id":"669a745cea635b7eb2179332","match_name":"KKR vs SH","date":"2024-09-26T00:00:00.000Z","time":"13:20","city":"Kolkata","state":"West Bengal","country":"India","isStarted":true,"createdAt":"2024-07-19T14:12:44.105Z","team_1_details":{"_id":"669a4e6e91f4793dc94219fb","team_name":"Kolkata Knight Riders","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","color_code":"#9e00ff"},"team_2_details":{"_id":"669a501591f4793dc9421a6e","team_name":"Sunrisers Hyderabad","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","color_code":"#ff9900"},"teamScore":{"team1":{"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"},"team2":{"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}}}]

LiveMatches liveMatchesFromJson(String str) => LiveMatches.fromJson(json.decode(str));
String liveMatchesToJson(LiveMatches data) => json.encode(data.toJson());
class LiveMatches {
  LiveMatches({
      List<Matches>? matches,}){
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
LiveMatches copyWith({  List<Matches>? matches,
}) => LiveMatches(  matches: matches ?? _matches,
);
  List<Matches>? get matches => _matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matches != null) {
      map['matches'] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "669a745cea635b7eb2179332"
/// match_name : "KKR vs SH"
/// date : "2024-09-26T00:00:00.000Z"
/// time : "13:20"
/// city : "Kolkata"
/// state : "West Bengal"
/// country : "India"
/// isStarted : true
/// createdAt : "2024-07-19T14:12:44.105Z"
/// team_1_details : {"_id":"669a4e6e91f4793dc94219fb","team_name":"Kolkata Knight Riders","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png","color_code":"#9e00ff"}
/// team_2_details : {"_id":"669a501591f4793dc9421a6e","team_name":"Sunrisers Hyderabad","short_name":"KKR","logo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png","color_code":"#ff9900"}
/// teamScore : {"team1":{"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"},"team2":{"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}}

Matches matchesFromJson(String str) => Matches.fromJson(json.decode(str));
String matchesToJson(Matches data) => json.encode(data.toJson());
class Matches {
  Matches({
      String? id, 
      String? matchName, 
      String? date, 
      String? time, 
      String? city, 
      String? state, 
      String? country, 
      bool? isStarted, 
      String? createdAt, 
      Team1Details? team1Details, 
      Team2Details? team2Details, 
      TeamScore? teamScore,}){
    _id = id;
    _matchName = matchName;
    _date = date;
    _time = time;
    _city = city;
    _state = state;
    _country = country;
    _isStarted = isStarted;
    _createdAt = createdAt;
    _team1Details = team1Details;
    _team2Details = team2Details;
    _teamScore = teamScore;
}

  Matches.fromJson(dynamic json) {
    _id = json['_id'];
    _matchName = json['match_name'];
    _date = json['date'];
    _time = json['time'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _isStarted = json['isStarted'];
    _createdAt = json['createdAt'];
    _team1Details = json['team_1_details'] != null ? Team1Details.fromJson(json['team_1_details']) : null;
    _team2Details = json['team_2_details'] != null ? Team2Details.fromJson(json['team_2_details']) : null;
    _teamScore = json['teamScore'] != null ? TeamScore.fromJson(json['teamScore']) : null;
  }
  String? _id;
  String? _matchName;
  String? _date;
  String? _time;
  String? _city;
  String? _state;
  String? _country;
  bool? _isStarted;
  String? _createdAt;
  Team1Details? _team1Details;
  Team2Details? _team2Details;
  TeamScore? _teamScore;
Matches copyWith({  String? id,
  String? matchName,
  String? date,
  String? time,
  String? city,
  String? state,
  String? country,
  bool? isStarted,
  String? createdAt,
  Team1Details? team1Details,
  Team2Details? team2Details,
  TeamScore? teamScore,
}) => Matches(  id: id ?? _id,
  matchName: matchName ?? _matchName,
  date: date ?? _date,
  time: time ?? _time,
  city: city ?? _city,
  state: state ?? _state,
  country: country ?? _country,
  isStarted: isStarted ?? _isStarted,
  createdAt: createdAt ?? _createdAt,
  team1Details: team1Details ?? _team1Details,
  team2Details: team2Details ?? _team2Details,
  teamScore: teamScore ?? _teamScore,
);
  String? get id => _id;
  String? get matchName => _matchName;
  String? get date => _date;
  String? get time => _time;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  bool? get isStarted => _isStarted;
  String? get createdAt => _createdAt;
  Team1Details? get team1Details => _team1Details;
  Team2Details? get team2Details => _team2Details;
  TeamScore? get teamScore => _teamScore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
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

/// team1 : {"score":"95/1 (7.0)","innings":1,"team_name":"Kolkata Knight Riders"}
/// team2 : {"score":"0/0 (0.0)","innings":0,"team_name":"Sunrisers Hyderabad"}

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

/// _id : "669a501591f4793dc9421a6e"
/// team_name : "Sunrisers Hyderabad"
/// short_name : "KKR"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/SRHoutline.png"
/// color_code : "#ff9900"

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

/// _id : "669a4e6e91f4793dc94219fb"
/// team_name : "Kolkata Knight Riders"
/// short_name : "KKR"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/KKRoutline.png"
/// color_code : "#9e00ff"

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