import 'dart:convert';
WorldcupModeltest worldcupModeltestFromJson(String str) => WorldcupModeltest.fromJson(json.decode(str));
String worldcupModeltestToJson(WorldcupModeltest data) => json.encode(data.toJson());
class WorldcupModeltest {
  WorldcupModeltest({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}
  WorldcupModeltest.fromJson(dynamic json) {
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
WorldcupModeltest copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => WorldcupModeltest(  success: success ?? _success,
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

/// _id : "669b6c12b7eb0d958355bac8"
/// league_id : "669b684cb7eb0d958355b928"
/// team_1_id : "66a0edf683032c52f2673bb4"
/// team_2_id : "66a0ee6d83032c52f2673bcd"
/// match_name : "IND vs PAK"
/// date : "2026-07-22T00:00:00.000Z"
/// time : "18:15"
/// city : "Ahmedabad"
/// state : "Gujarat"
/// country : "India"
/// isStarted : false
/// overs : 20
/// innings : 2
/// createdAt : "2024-07-20T07:49:38.452Z"
/// updatedAt : "2024-07-20T07:53:48.694Z"
/// __v : 0
/// venue : "Motera Stadium"
/// league_details : [{"_id":"669b684cb7eb0d958355b928","league_name":"T20 World Cup","matchType":"669a3f49767133a748438e09","start_date":"2026-07-20T00:00:00.000Z","end_date":"2026-12-20T00:00:00.000Z","createdAt":"2024-07-20T07:33:32.273Z","updatedAt":"2024-07-20T07:33:32.273Z","__v":0}]
/// team_1_details : [{"_id":"66a0edf683032c52f2673bb4","team_name":"INDIA","league_id":"669b684cb7eb0d958355b928","logo":"https://batting-api-1.onrender.com/teamPhoto/india.jpg","other_photo":"https://batting-api-1.onrender.com/teamPhoto/india.jpg","short_name":"IND","captain":"669a55c391f4793dc9421b5c","vice_captain":"669a565691f4793dc9421b70","color_code":"#06038d","createdAt":"2024-07-24T12:05:10.100Z","updatedAt":"2024-07-24T12:05:10.100Z","__v":0}]
/// team_1_captain_details : [{"_id":"669a55c391f4793dc9421b5c","player_name":"Rohit Sharma","player_photo":"https://batting-api-1.onrender.com/playerPhoto/rohit.png","age":37,"nationality":"India","birth_date":"1987-04-30","role":"Batsman","bat_type":"Right hand","bowl_type":"Right hand","createdAt":"2024-07-19T12:02:11.969Z","updatedAt":"2024-07-19T12:02:11.969Z","__v":0}]
/// team_1_viceCaptain_details : [{"_id":"669a565691f4793dc9421b70","player_name":"Suryakumar Yadav","player_photo":"https://batting-api-1.onrender.com/playerPhoto/sky.png","age":33,"nationality":"India","birth_date":"1990-09-14","role":"Batsman","bat_type":"Right hand","bowl_type":"Right hand","createdAt":"2024-07-19T12:04:38.663Z","updatedAt":"2024-07-19T12:04:38.663Z","__v":0}]
/// team_2_details : [{"_id":"66a0ee6d83032c52f2673bcd","team_name":"PAKISTAN","league_id":"669b684cb7eb0d958355b928","logo":"https://batting-api-1.onrender.com/teamPhoto/pakistan.jpeg","other_photo":"https://batting-api-1.onrender.com/teamPhoto/pakistan.jpeg","short_name":"PAK","captain":"66c5b664a97a839e907cc86d","vice_captain":null,"color_code":"#00401a","createdAt":"2024-07-24T12:07:09.719Z","updatedAt":"2024-07-24T12:07:09.719Z","__v":0}]
/// team_2_captain_details : [{"_id":"66c5b664a97a839e907cc86d","player_name":"Babar Azam","player_photo":"https://batting-api-1.onrender.com/playerPhoto/babar.png","age":29,"nationality":"Pakistan","birth_date":"1994-10-04","role":"Batsman","bat_type":"Right hand","bowl_type":"Right hand","createdAt":"2024-07-19T11:03:57.504Z","updatedAt":"2024-07-20T05:34:42.659Z","__v":0}]
/// team_2_viceCaptain_details : []

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
      String? city, 
      String? state, 
      String? country, 
      bool? isStarted, 
      num? overs, 
      num? innings, 
      String? createdAt, 
      String? updatedAt, 
      num? v,
    int? megaPrice,
      String? venue, 
      List<LeagueDetails>? leagueDetails, 
      List<Team1Details>? team1Details, 
      List<Team1CaptainDetails>? team1CaptainDetails, 
      List<Team1ViceCaptainDetails>? team1ViceCaptainDetails, 
      List<Team2Details>? team2Details, 
      List<Team2CaptainDetails>? team2CaptainDetails, 
      List<dynamic>? team2ViceCaptainDetails,}){
    _id = id;
    _leagueId = leagueId;
    _team1Id = team1Id;
    _team2Id = team2Id;
    _matchName = matchName;
    _date = date;
    _time = time;
    _city = city;
    _state = state;
    _country = country;
    _isStarted = isStarted;
    _overs = overs;
    _innings = innings;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _megaPrice = megaPrice;
    _venue = venue;
    _leagueDetails = leagueDetails;
    _team1Details = team1Details;
    _team1CaptainDetails = team1CaptainDetails;
    _team1ViceCaptainDetails = team1ViceCaptainDetails;
    _team2Details = team2Details;
    _team2CaptainDetails = team2CaptainDetails;
    _team2ViceCaptainDetails = team2ViceCaptainDetails;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _leagueId = json['league_id'];
    _team1Id = json['team_1_id'];
    _team2Id = json['team_2_id'];
    _matchName = json['match_name'];
    _date = json['date'];
    _time = json['time'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _isStarted = json['isStarted'];
    _overs = json['overs'];
    _innings = json['innings'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _megaPrice = json['megaPrice'];
    _venue = json['venue'];
    if (json['league_details'] != null) {
      _leagueDetails = [];
      json['league_details'].forEach((v) {
        _leagueDetails?.add(LeagueDetails.fromJson(v));
      });
    }
    if (json['team_1_details'] != null) {
      _team1Details = [];
      json['team_1_details'].forEach((v) {
        _team1Details?.add(Team1Details.fromJson(v));
      });
    }
    if (json['team_1_captain_details'] != null) {
      _team1CaptainDetails = [];
      json['team_1_captain_details'].forEach((v) {
        _team1CaptainDetails?.add(Team1CaptainDetails.fromJson(v));
      });
    }
    if (json['team_1_viceCaptain_details'] != null) {
      _team1ViceCaptainDetails = [];
      json['team_1_viceCaptain_details'].forEach((v) {
        _team1ViceCaptainDetails?.add(Team1ViceCaptainDetails.fromJson(v));
      });
    }
    if (json['team_2_details'] != null) {
      _team2Details = [];
      json['team_2_details'].forEach((v) {
        _team2Details?.add(Team2Details.fromJson(v));
      });
    }
    if (json['team_2_captain_details'] != null) {
      _team2CaptainDetails = [];
      json['team_2_captain_details'].forEach((v) {
        _team2CaptainDetails?.add(Team2CaptainDetails.fromJson(v));
      });
    }
    if (json['team_2_viceCaptain_details'] != null) {
      _team2ViceCaptainDetails = [];
      json['team_2_viceCaptain_details'].forEach((v) {
        _team2ViceCaptainDetails?.add(Team2Details.fromJson(v));
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
  String? _city;
  String? _state;
  String? _country;
  bool? _isStarted;
  num? _overs;
  num? _innings;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  int? _megaPrice;
  String? _venue;
  List<LeagueDetails>? _leagueDetails;
  List<Team1Details>? _team1Details;
  List<Team1CaptainDetails>? _team1CaptainDetails;
  List<Team1ViceCaptainDetails>? _team1ViceCaptainDetails;
  List<Team2Details>? _team2Details;
  List<Team2CaptainDetails>? _team2CaptainDetails;
  List<dynamic>? _team2ViceCaptainDetails;
Data copyWith({  String? id,
  String? leagueId,
  String? team1Id,
  String? team2Id,
  String? matchName,
  String? date,
  String? time,
  String? city,
  String? state,
  String? country,
  bool? isStarted,
  num? overs,
  num? innings,
  String? createdAt,
  String? updatedAt,
  num? v,
  int? megaPrice,
  String? venue,
  List<LeagueDetails>? leagueDetails,
  List<Team1Details>? team1Details,
  List<Team1CaptainDetails>? team1CaptainDetails,
  List<Team1ViceCaptainDetails>? team1ViceCaptainDetails,
  List<Team2Details>? team2Details,
  List<Team2CaptainDetails>? team2CaptainDetails,
  List<dynamic>? team2ViceCaptainDetails,
}) => Data(  id: id ?? _id,
  leagueId: leagueId ?? _leagueId,
  team1Id: team1Id ?? _team1Id,
  team2Id: team2Id ?? _team2Id,
  matchName: matchName ?? _matchName,
  date: date ?? _date,
  time: time ?? _time,
  city: city ?? _city,
  state: state ?? _state,
  country: country ?? _country,
  isStarted: isStarted ?? _isStarted,
  overs: overs ?? _overs,
  innings: innings ?? _innings,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  megaPrice: megaPrice ?? _megaPrice,
  venue: venue ?? _venue,
  leagueDetails: leagueDetails ?? _leagueDetails,
  team1Details: team1Details ?? _team1Details,
  team1CaptainDetails: team1CaptainDetails ?? _team1CaptainDetails,
  team1ViceCaptainDetails: team1ViceCaptainDetails ?? _team1ViceCaptainDetails,
  team2Details: team2Details ?? _team2Details,
  team2CaptainDetails: team2CaptainDetails ?? _team2CaptainDetails,
  team2ViceCaptainDetails: team2ViceCaptainDetails ?? _team2ViceCaptainDetails,
);
  String? get id => _id;
  String? get leagueId => _leagueId;
  String? get team1Id => _team1Id;
  String? get team2Id => _team2Id;
  String? get matchName => _matchName;
  String? get date => _date;
  String? get time => _time;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  bool? get isStarted => _isStarted;
  num? get overs => _overs;
  num? get innings => _innings;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  int? get megaPrice => _megaPrice;
  String? get venue => _venue;
  List<LeagueDetails>? get leagueDetails => _leagueDetails;
  List<Team1Details>? get team1Details => _team1Details;
  List<Team1CaptainDetails>? get team1CaptainDetails => _team1CaptainDetails;
  List<Team1ViceCaptainDetails>? get team1ViceCaptainDetails => _team1ViceCaptainDetails;
  List<Team2Details>? get team2Details => _team2Details;
  List<Team2CaptainDetails>? get team2CaptainDetails => _team2CaptainDetails;
  List<dynamic>? get team2ViceCaptainDetails => _team2ViceCaptainDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['league_id'] = _leagueId;
    map['team_1_id'] = _team1Id;
    map['team_2_id'] = _team2Id;
    map['match_name'] = _matchName;
    map['date'] = _date;
    map['time'] = _time;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['isStarted'] = _isStarted;
    map['overs'] = _overs;
    map['innings'] = _innings;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['venue'] = _venue;
    if (_leagueDetails != null) {
      map['league_details'] = _leagueDetails?.map((v) => v.toJson()).toList();
    }
    if (_team1Details != null) {
      map['team_1_details'] = _team1Details?.map((v) => v.toJson()).toList();
    }
    if (_team1CaptainDetails != null) {
      map['team_1_captain_details'] = _team1CaptainDetails?.map((v) => v.toJson()).toList();
    }
    if (_team1ViceCaptainDetails != null) {
      map['team_1_viceCaptain_details'] = _team1ViceCaptainDetails?.map((v) => v.toJson()).toList();
    }
    if (_team2Details != null) {
      map['team_2_details'] = _team2Details?.map((v) => v.toJson()).toList();
    }
    if (_team2CaptainDetails != null) {
      map['team_2_captain_details'] = _team2CaptainDetails?.map((v) => v.toJson()).toList();
    }
    if (_team2ViceCaptainDetails != null) {
      map['team_2_viceCaptain_details'] = _team2ViceCaptainDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "66c5b664a97a839e907cc86d"
/// player_name : "Babar Azam"
/// player_photo : "https://batting-api-1.onrender.com/playerPhoto/babar.png"
/// age : 29
/// nationality : "Pakistan"
/// birth_date : "1994-10-04"
/// role : "Batsman"
/// bat_type : "Right hand"
/// bowl_type : "Right hand"
/// createdAt : "2024-07-19T11:03:57.504Z"
/// updatedAt : "2024-07-20T05:34:42.659Z"
/// __v : 0

Team2CaptainDetails team2CaptainDetailsFromJson(String str) => Team2CaptainDetails.fromJson(json.decode(str));
String team2CaptainDetailsToJson(Team2CaptainDetails data) => json.encode(data.toJson());
class Team2CaptainDetails {
  Team2CaptainDetails({
      String? id, 
      String? playerName, 
      String? playerPhoto, 
      num? age, 
      String? nationality, 
      String? birthDate, 
      String? role, 
      String? batType, 
      String? bowlType, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _playerName = playerName;
    _playerPhoto = playerPhoto;
    _age = age;
    _nationality = nationality;
    _birthDate = birthDate;
    _role = role;
    _batType = batType;
    _bowlType = bowlType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Team2CaptainDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _playerName = json['player_name'];
    _playerPhoto = json['player_photo'];
    _age = json['age'];
    _nationality = json['nationality'];
    _birthDate = json['birth_date'];
    _role = json['role'];
    _batType = json['bat_type'];
    _bowlType = json['bowl_type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _playerName;
  String? _playerPhoto;
  num? _age;
  String? _nationality;
  String? _birthDate;
  String? _role;
  String? _batType;
  String? _bowlType;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Team2CaptainDetails copyWith({  String? id,
  String? playerName,
  String? playerPhoto,
  num? age,
  String? nationality,
  String? birthDate,
  String? role,
  String? batType,
  String? bowlType,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Team2CaptainDetails(  id: id ?? _id,
  playerName: playerName ?? _playerName,
  playerPhoto: playerPhoto ?? _playerPhoto,
  age: age ?? _age,
  nationality: nationality ?? _nationality,
  birthDate: birthDate ?? _birthDate,
  role: role ?? _role,
  batType: batType ?? _batType,
  bowlType: bowlType ?? _bowlType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get playerName => _playerName;
  String? get playerPhoto => _playerPhoto;
  num? get age => _age;
  String? get nationality => _nationality;
  String? get birthDate => _birthDate;
  String? get role => _role;
  String? get batType => _batType;
  String? get bowlType => _bowlType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['player_name'] = _playerName;
    map['player_photo'] = _playerPhoto;
    map['age'] = _age;
    map['nationality'] = _nationality;
    map['birth_date'] = _birthDate;
    map['role'] = _role;
    map['bat_type'] = _batType;
    map['bowl_type'] = _bowlType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "66a0ee6d83032c52f2673bcd"
/// team_name : "PAKISTAN"
/// league_id : "669b684cb7eb0d958355b928"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/pakistan.jpeg"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/pakistan.jpeg"
/// short_name : "PAK"
/// captain : "66c5b664a97a839e907cc86d"
/// vice_captain : null
/// color_code : "#00401a"
/// createdAt : "2024-07-24T12:07:09.719Z"
/// updatedAt : "2024-07-24T12:07:09.719Z"
/// __v : 0

Team2Details team2DetailsFromJson(String str) => Team2Details.fromJson(json.decode(str));
String team2DetailsToJson(Team2Details data) => json.encode(data.toJson());
class Team2Details {
  Team2Details({
      String? id, 
      String? teamName, 
      String? leagueId, 
      String? logo, 
      String? otherPhoto, 
      String? shortName, 
      String? captain, 
      dynamic viceCaptain, 
      String? colorCode, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _teamName = teamName;
    _leagueId = leagueId;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _shortName = shortName;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _colorCode = colorCode;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Team2Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _leagueId = json['league_id'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _shortName = json['short_name'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _colorCode = json['color_code'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _teamName;
  String? _leagueId;
  String? _logo;
  String? _otherPhoto;
  String? _shortName;
  String? _captain;
  dynamic _viceCaptain;
  String? _colorCode;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Team2Details copyWith({  String? id,
  String? teamName,
  String? leagueId,
  String? logo,
  String? otherPhoto,
  String? shortName,
  String? captain,
  dynamic viceCaptain,
  String? colorCode,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Team2Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  leagueId: leagueId ?? _leagueId,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  shortName: shortName ?? _shortName,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  colorCode: colorCode ?? _colorCode,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get leagueId => _leagueId;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get shortName => _shortName;
  String? get captain => _captain;
  dynamic get viceCaptain => _viceCaptain;
  String? get colorCode => _colorCode;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['league_id'] = _leagueId;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['short_name'] = _shortName;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['color_code'] = _colorCode;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "669a565691f4793dc9421b70"
/// player_name : "Suryakumar Yadav"
/// player_photo : "https://batting-api-1.onrender.com/playerPhoto/sky.png"
/// age : 33
/// nationality : "India"
/// birth_date : "1990-09-14"
/// role : "Batsman"
/// bat_type : "Right hand"
/// bowl_type : "Right hand"
/// createdAt : "2024-07-19T12:04:38.663Z"
/// updatedAt : "2024-07-19T12:04:38.663Z"
/// __v : 0

Team1ViceCaptainDetails team1ViceCaptainDetailsFromJson(String str) => Team1ViceCaptainDetails.fromJson(json.decode(str));
String team1ViceCaptainDetailsToJson(Team1ViceCaptainDetails data) => json.encode(data.toJson());
class Team1ViceCaptainDetails {
  Team1ViceCaptainDetails({
      String? id, 
      String? playerName, 
      String? playerPhoto, 
      num? age, 
      String? nationality, 
      String? birthDate, 
      String? role, 
      String? batType, 
      String? bowlType, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _playerName = playerName;
    _playerPhoto = playerPhoto;
    _age = age;
    _nationality = nationality;
    _birthDate = birthDate;
    _role = role;
    _batType = batType;
    _bowlType = bowlType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Team1ViceCaptainDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _playerName = json['player_name'];
    _playerPhoto = json['player_photo'];
    _age = json['age'];
    _nationality = json['nationality'];
    _birthDate = json['birth_date'];
    _role = json['role'];
    _batType = json['bat_type'];
    _bowlType = json['bowl_type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _playerName;
  String? _playerPhoto;
  num? _age;
  String? _nationality;
  String? _birthDate;
  String? _role;
  String? _batType;
  String? _bowlType;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Team1ViceCaptainDetails copyWith({  String? id,
  String? playerName,
  String? playerPhoto,
  num? age,
  String? nationality,
  String? birthDate,
  String? role,
  String? batType,
  String? bowlType,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Team1ViceCaptainDetails(  id: id ?? _id,
  playerName: playerName ?? _playerName,
  playerPhoto: playerPhoto ?? _playerPhoto,
  age: age ?? _age,
  nationality: nationality ?? _nationality,
  birthDate: birthDate ?? _birthDate,
  role: role ?? _role,
  batType: batType ?? _batType,
  bowlType: bowlType ?? _bowlType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get playerName => _playerName;
  String? get playerPhoto => _playerPhoto;
  num? get age => _age;
  String? get nationality => _nationality;
  String? get birthDate => _birthDate;
  String? get role => _role;
  String? get batType => _batType;
  String? get bowlType => _bowlType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['player_name'] = _playerName;
    map['player_photo'] = _playerPhoto;
    map['age'] = _age;
    map['nationality'] = _nationality;
    map['birth_date'] = _birthDate;
    map['role'] = _role;
    map['bat_type'] = _batType;
    map['bowl_type'] = _bowlType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "669a55c391f4793dc9421b5c"
/// player_name : "Rohit Sharma"
/// player_photo : "https://batting-api-1.onrender.com/playerPhoto/rohit.png"
/// age : 37
/// nationality : "India"
/// birth_date : "1987-04-30"
/// role : "Batsman"
/// bat_type : "Right hand"
/// bowl_type : "Right hand"
/// createdAt : "2024-07-19T12:02:11.969Z"
/// updatedAt : "2024-07-19T12:02:11.969Z"
/// __v : 0

Team1CaptainDetails team1CaptainDetailsFromJson(String str) => Team1CaptainDetails.fromJson(json.decode(str));
String team1CaptainDetailsToJson(Team1CaptainDetails data) => json.encode(data.toJson());
class Team1CaptainDetails {
  Team1CaptainDetails({
      String? id, 
      String? playerName, 
      String? playerPhoto, 
      num? age, 
      String? nationality, 
      String? birthDate, 
      String? role, 
      String? batType, 
      String? bowlType, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _playerName = playerName;
    _playerPhoto = playerPhoto;
    _age = age;
    _nationality = nationality;
    _birthDate = birthDate;
    _role = role;
    _batType = batType;
    _bowlType = bowlType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Team1CaptainDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _playerName = json['player_name'];
    _playerPhoto = json['player_photo'];
    _age = json['age'];
    _nationality = json['nationality'];
    _birthDate = json['birth_date'];
    _role = json['role'];
    _batType = json['bat_type'];
    _bowlType = json['bowl_type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _playerName;
  String? _playerPhoto;
  num? _age;
  String? _nationality;
  String? _birthDate;
  String? _role;
  String? _batType;
  String? _bowlType;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Team1CaptainDetails copyWith({  String? id,
  String? playerName,
  String? playerPhoto,
  num? age,
  String? nationality,
  String? birthDate,
  String? role,
  String? batType,
  String? bowlType,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Team1CaptainDetails(  id: id ?? _id,
  playerName: playerName ?? _playerName,
  playerPhoto: playerPhoto ?? _playerPhoto,
  age: age ?? _age,
  nationality: nationality ?? _nationality,
  birthDate: birthDate ?? _birthDate,
  role: role ?? _role,
  batType: batType ?? _batType,
  bowlType: bowlType ?? _bowlType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get playerName => _playerName;
  String? get playerPhoto => _playerPhoto;
  num? get age => _age;
  String? get nationality => _nationality;
  String? get birthDate => _birthDate;
  String? get role => _role;
  String? get batType => _batType;
  String? get bowlType => _bowlType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['player_name'] = _playerName;
    map['player_photo'] = _playerPhoto;
    map['age'] = _age;
    map['nationality'] = _nationality;
    map['birth_date'] = _birthDate;
    map['role'] = _role;
    map['bat_type'] = _batType;
    map['bowl_type'] = _bowlType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "66a0edf683032c52f2673bb4"
/// team_name : "INDIA"
/// league_id : "669b684cb7eb0d958355b928"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/india.jpg"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/india.jpg"
/// short_name : "IND"
/// captain : "669a55c391f4793dc9421b5c"
/// vice_captain : "669a565691f4793dc9421b70"
/// color_code : "#06038d"
/// createdAt : "2024-07-24T12:05:10.100Z"
/// updatedAt : "2024-07-24T12:05:10.100Z"
/// __v : 0

Team1Details team1DetailsFromJson(String str) => Team1Details.fromJson(json.decode(str));
String team1DetailsToJson(Team1Details data) => json.encode(data.toJson());
class Team1Details {
  Team1Details({
      String? id, 
      String? teamName, 
      String? leagueId, 
      String? logo, 
      String? otherPhoto, 
      String? shortName, 
      String? captain, 
      String? viceCaptain, 
      String? colorCode, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _teamName = teamName;
    _leagueId = leagueId;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _shortName = shortName;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _colorCode = colorCode;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Team1Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _leagueId = json['league_id'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _shortName = json['short_name'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _colorCode = json['color_code'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _teamName;
  String? _leagueId;
  String? _logo;
  String? _otherPhoto;
  String? _shortName;
  String? _captain;
  String? _viceCaptain;
  String? _colorCode;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Team1Details copyWith({  String? id,
  String? teamName,
  String? leagueId,
  String? logo,
  String? otherPhoto,
  String? shortName,
  String? captain,
  String? viceCaptain,
  String? colorCode,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Team1Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  leagueId: leagueId ?? _leagueId,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  shortName: shortName ?? _shortName,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  colorCode: colorCode ?? _colorCode,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get leagueId => _leagueId;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get shortName => _shortName;
  String? get captain => _captain;
  String? get viceCaptain => _viceCaptain;
  String? get colorCode => _colorCode;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['league_id'] = _leagueId;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['short_name'] = _shortName;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['color_code'] = _colorCode;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "669b684cb7eb0d958355b928"
/// league_name : "T20 World Cup"
/// matchType : "669a3f49767133a748438e09"
/// start_date : "2026-07-20T00:00:00.000Z"
/// end_date : "2026-12-20T00:00:00.000Z"
/// createdAt : "2024-07-20T07:33:32.273Z"
/// updatedAt : "2024-07-20T07:33:32.273Z"
/// __v : 0

LeagueDetails leagueDetailsFromJson(String str) => LeagueDetails.fromJson(json.decode(str));
String leagueDetailsToJson(LeagueDetails data) => json.encode(data.toJson());
class LeagueDetails {
  LeagueDetails({
      String? id, 
      String? leagueName, 
      String? matchType, 
      String? startDate, 
      String? endDate, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _leagueName = leagueName;
    _matchType = matchType;
    _startDate = startDate;
    _endDate = endDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  LeagueDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _leagueName = json['league_name'];
    _matchType = json['matchType'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _leagueName;
  String? _matchType;
  String? _startDate;
  String? _endDate;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
LeagueDetails copyWith({  String? id,
  String? leagueName,
  String? matchType,
  String? startDate,
  String? endDate,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => LeagueDetails(  id: id ?? _id,
  leagueName: leagueName ?? _leagueName,
  matchType: matchType ?? _matchType,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get leagueName => _leagueName;
  String? get matchType => _matchType;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['league_name'] = _leagueName;
    map['matchType'] = _matchType;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}