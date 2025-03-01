import 'dart:convert';
/// success : true
/// message : "All contests fetched successfully"
/// data : [{"_id":"669a7410ea635b7eb2179321","league_id":"669a499db7d111a9d554f5d0","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","match_name":"DC vs PK","date":"2025-03-23T00:00:00.000Z","time":"18:00","venue":null,"city":"Zira","state":"Punjab","country":"India","createdAt":"2024-07-19T14:11:28.715Z","updatedAt":"2024-07-20T11:10:56.207Z","__v":0,"contests":[{"_id":"669b4fcbcf157ac1ecf0537f","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":100000,"entry_fees":50,"total_participant":2000,"max_team_per_user":2,"profit":30,"date_time":"2024-07-20T05:48:59.859Z","createdAt":"2024-07-20T05:48:59.859Z","updatedAt":"2024-07-20T05:48:59.859Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":6,"remaining_spots":1994,"joined_teams":6},{"_id":"669b4ff2cf157ac1ecf053a4","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":5000,"entry_fees":2500,"total_participant":2,"max_team_per_user":1,"profit":20,"date_time":"2024-07-20T05:49:38.885Z","createdAt":"2024-07-20T05:49:38.885Z","updatedAt":"2024-07-20T05:49:38.885Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":0,"joined_teams":2},{"_id":"669b5026cf157ac1ecf053d4","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":200,"entry_fees":100,"total_participant":2,"max_team_per_user":1,"profit":20,"date_time":"2024-07-20T05:50:30.731Z","createdAt":"2024-07-20T05:50:30.731Z","updatedAt":"2024-07-20T05:50:30.731Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":0,"joined_teams":2},{"_id":"669b50ddcf157ac1ecf05414","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":20000,"entry_fees":10,"total_participant":2000,"max_team_per_user":4,"profit":30,"date_time":"2024-07-20T05:53:33.712Z","createdAt":"2024-07-20T05:53:33.713Z","updatedAt":"2024-07-20T05:53:33.713Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":1998,"joined_teams":2}]}]

Contastmodel contastmodelFromJson(String str) => Contastmodel.fromJson(json.decode(str));
String contastmodelToJson(Contastmodel data) => json.encode(data.toJson());
class Contastmodel {
  Contastmodel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  Contastmodel.fromJson(dynamic json) {
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
Contastmodel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Contastmodel(  success: success ?? _success,
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

/// _id : "669a7410ea635b7eb2179321"
/// league_id : "669a499db7d111a9d554f5d0"
/// team_1_id : "669a4e1491f4793dc94219de"
/// team_2_id : "669a4f4a91f4793dc9421a29"
/// match_name : "DC vs PK"
/// date : "2025-03-23T00:00:00.000Z"
/// time : "18:00"
/// venue : null
/// city : "Zira"
/// state : "Punjab"
/// country : "India"
/// createdAt : "2024-07-19T14:11:28.715Z"
/// updatedAt : "2024-07-20T11:10:56.207Z"
/// __v : 0
/// contests : [{"_id":"669b4fcbcf157ac1ecf0537f","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":100000,"entry_fees":50,"total_participant":2000,"max_team_per_user":2,"profit":30,"date_time":"2024-07-20T05:48:59.859Z","createdAt":"2024-07-20T05:48:59.859Z","updatedAt":"2024-07-20T05:48:59.859Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":6,"remaining_spots":1994,"joined_teams":6},{"_id":"669b4ff2cf157ac1ecf053a4","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":5000,"entry_fees":2500,"total_participant":2,"max_team_per_user":1,"profit":20,"date_time":"2024-07-20T05:49:38.885Z","createdAt":"2024-07-20T05:49:38.885Z","updatedAt":"2024-07-20T05:49:38.885Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":0,"joined_teams":2},{"_id":"669b5026cf157ac1ecf053d4","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":200,"entry_fees":100,"total_participant":2,"max_team_per_user":1,"profit":20,"date_time":"2024-07-20T05:50:30.731Z","createdAt":"2024-07-20T05:50:30.731Z","updatedAt":"2024-07-20T05:50:30.731Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":0,"joined_teams":2},{"_id":"669b50ddcf157ac1ecf05414","match_id":"669a7410ea635b7eb2179321","contest_type_id":"6630e7d06794aa4d8c280fe4","price_pool":20000,"entry_fees":10,"total_participant":2000,"max_team_per_user":4,"profit":30,"date_time":"2024-07-20T05:53:33.712Z","createdAt":"2024-07-20T05:53:33.713Z","updatedAt":"2024-07-20T05:53:33.713Z","__v":0,"contest_type":{"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0},"joined_team_count":2,"remaining_spots":1998,"joined_teams":2}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? leagueId, 
      String? team1Id, 
      String? team2Id, 
      String? matchName, 
      String? date, 
      String? time, 
      dynamic venue, 
      String? city, 
      String? state, 
      String? country, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      List<Contests>? contests,}){
    _id = id;
    _leagueId = leagueId;
    _team1Id = team1Id;
    _team2Id = team2Id;
    _matchName = matchName;
    _date = date;
    _time = time;
    _venue = venue;
    _city = city;
    _state = state;
    _country = country;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _contests = contests;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _leagueId = json['league_id'];
    _team1Id = json['team_1_id'];
    _team2Id = json['team_2_id'];
    _matchName = json['match_name'];
    _date = json['date'];
    _time = json['time'];
    _venue = json['venue'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    if (json['contests'] != null) {
      _contests = [];
      json['contests'].forEach((v) {
        _contests?.add(Contests.fromJson(v));
      });
    }
  }
  String? _id;
  String? _leagueId;
  String? _team1Id;
  String? _team2Id;
  String? _matchName;
  String? _date;
  String? _time;
  dynamic _venue;
  String? _city;
  String? _state;
  String? _country;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  List<Contests>? _contests;
Data copyWith({  String? id,
  String? leagueId,
  String? team1Id,
  String? team2Id,
  String? matchName,
  String? date,
  String? time,
  dynamic venue,
  String? city,
  String? state,
  String? country,
  String? createdAt,
  String? updatedAt,
  num? v,
  List<Contests>? contests,
}) => Data(  id: id ?? _id,
  leagueId: leagueId ?? _leagueId,
  team1Id: team1Id ?? _team1Id,
  team2Id: team2Id ?? _team2Id,
  matchName: matchName ?? _matchName,
  date: date ?? _date,
  time: time ?? _time,
  venue: venue ?? _venue,
  city: city ?? _city,
  state: state ?? _state,
  country: country ?? _country,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  contests: contests ?? _contests,
);
  String? get id => _id;
  String? get leagueId => _leagueId;
  String? get team1Id => _team1Id;
  String? get team2Id => _team2Id;
  String? get matchName => _matchName;
  String? get date => _date;
  String? get time => _time;
  dynamic get venue => _venue;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  List<Contests>? get contests => _contests;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['league_id'] = _leagueId;
    map['team_1_id'] = _team1Id;
    map['team_2_id'] = _team2Id;
    map['match_name'] = _matchName;
    map['date'] = _date;
    map['time'] = _time;
    map['venue'] = _venue;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_contests != null) {
      map['contests'] = _contests?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "669b4fcbcf157ac1ecf0537f"
/// match_id : "669a7410ea635b7eb2179321"
/// contest_type_id : "6630e7d06794aa4d8c280fe4"
/// price_pool : 100000
/// entry_fees : 50
/// total_participant : 2000
/// max_team_per_user : 2
/// profit : 30
/// date_time : "2024-07-20T05:48:59.859Z"
/// createdAt : "2024-07-20T05:48:59.859Z"
/// updatedAt : "2024-07-20T05:48:59.859Z"
/// __v : 0
/// contest_type : {"_id":"6630e7d06794aa4d8c280fe4","contest_type":"Head To Head","createdAt":"2024-04-30T12:45:04.659Z","updatedAt":"2024-06-19T06:00:00.571Z","__v":0}
/// joined_team_count : 6
/// remaining_spots : 1994
/// joined_teams : 6

Contests contestsFromJson(String str) => Contests.fromJson(json.decode(str));
String contestsToJson(Contests data) => json.encode(data.toJson());
class Contests {
  Contests({
      String? id, 
      String? matchId, 
      String? contestTypeId, 
      num? pricePool, 
      num? entryFees, 
      num? totalParticipant, 
      num? maxTeamPerUser, 
      num? profit, 
      String? dateTime, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      ContestType? contestType, 
      num? joinedTeamCount, 
      num? remainingSpots, 
      num? joinedTeams,}){
    _id = id;
    _matchId = matchId;
    _contestTypeId = contestTypeId;
    _pricePool = pricePool;
    _entryFees = entryFees;
    _totalParticipant = totalParticipant;
    _maxTeamPerUser = maxTeamPerUser;
    _profit = profit;
    _dateTime = dateTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _contestType = contestType;
    _joinedTeamCount = joinedTeamCount;
    _remainingSpots = remainingSpots;
    _joinedTeams = joinedTeams;
}

  Contests.fromJson(dynamic json) {
    _id = json['_id'];
    _matchId = json['match_id'];
    _contestTypeId = json['contest_type_id'];
    _pricePool = json['price_pool'];
    _entryFees = json['entry_fees'];
    _totalParticipant = json['total_participant'];
    _maxTeamPerUser = json['max_team_per_user'];
    _profit = json['profit'];
    _dateTime = json['date_time'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _contestType = json['contest_type'] != null ? ContestType.fromJson(json['contest_type']) : null;
    _joinedTeamCount = json['joined_team_count'];
    _remainingSpots = json['remaining_spots'];
    _joinedTeams = json['joined_teams'];
  }
  String? _id;
  String? _matchId;
  String? _contestTypeId;
  num? _pricePool;
  num? _entryFees;
  num? _totalParticipant;
  num? _maxTeamPerUser;
  num? _profit;
  String? _dateTime;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  ContestType? _contestType;
  num? _joinedTeamCount;
  num? _remainingSpots;
  num? _joinedTeams;
Contests copyWith({  String? id,
  String? matchId,
  String? contestTypeId,
  num? pricePool,
  num? entryFees,
  num? totalParticipant,
  num? maxTeamPerUser,
  num? profit,
  String? dateTime,
  String? createdAt,
  String? updatedAt,
  num? v,
  ContestType? contestType,
  num? joinedTeamCount,
  num? remainingSpots,
  num? joinedTeams,
}) => Contests(  id: id ?? _id,
  matchId: matchId ?? _matchId,
  contestTypeId: contestTypeId ?? _contestTypeId,
  pricePool: pricePool ?? _pricePool,
  entryFees: entryFees ?? _entryFees,
  totalParticipant: totalParticipant ?? _totalParticipant,
  maxTeamPerUser: maxTeamPerUser ?? _maxTeamPerUser,
  profit: profit ?? _profit,
  dateTime: dateTime ?? _dateTime,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  contestType: contestType ?? _contestType,
  joinedTeamCount: joinedTeamCount ?? _joinedTeamCount,
  remainingSpots: remainingSpots ?? _remainingSpots,
  joinedTeams: joinedTeams ?? _joinedTeams,
);
  String? get id => _id;
  String? get matchId => _matchId;
  String? get contestTypeId => _contestTypeId;
  num? get pricePool => _pricePool;
  num? get entryFees => _entryFees;
  num? get totalParticipant => _totalParticipant;
  num? get maxTeamPerUser => _maxTeamPerUser;
  num? get profit => _profit;
  String? get dateTime => _dateTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  ContestType? get contestType => _contestType;
  num? get joinedTeamCount => _joinedTeamCount;
  num? get remainingSpots => _remainingSpots;
  num? get joinedTeams => _joinedTeams;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['match_id'] = _matchId;
    map['contest_type_id'] = _contestTypeId;
    map['price_pool'] = _pricePool;
    map['entry_fees'] = _entryFees;
    map['total_participant'] = _totalParticipant;
    map['max_team_per_user'] = _maxTeamPerUser;
    map['profit'] = _profit;
    map['date_time'] = _dateTime;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_contestType != null) {
      map['contest_type'] = _contestType?.toJson();
    }
    map['joined_team_count'] = _joinedTeamCount;
    map['remaining_spots'] = _remainingSpots;
    map['joined_teams'] = _joinedTeams;
    return map;
  }

}

/// _id : "6630e7d06794aa4d8c280fe4"
/// contest_type : "Head To Head"
/// createdAt : "2024-04-30T12:45:04.659Z"
/// updatedAt : "2024-06-19T06:00:00.571Z"
/// __v : 0

ContestType contestTypeFromJson(String str) => ContestType.fromJson(json.decode(str));
String contestTypeToJson(ContestType data) => json.encode(data.toJson());
class ContestType {
  ContestType({
      String? id, 
      String? contestType, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _contestType = contestType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  ContestType.fromJson(dynamic json) {
    _id = json['_id'];
    _contestType = json['contest_type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _contestType;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
ContestType copyWith({  String? id,
  String? contestType,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => ContestType(  id: id ?? _id,
  contestType: contestType ?? _contestType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get contestType => _contestType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['contest_type'] = _contestType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}