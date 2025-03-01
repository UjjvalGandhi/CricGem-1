import 'dart:convert';
Testt testtFromJson(String str) => Testt.fromJson(json.decode(str));
String testtToJson(Testt data) => json.encode(data.toJson());
class Testt {
  Testt({
      bool? success,
      String? message,
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  Testt.fromJson(dynamic json) {
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
Testt copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Testt(  success: success ?? _success,
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
      String? vanue,
      String? city,
      String? state,
      String? country,
      bool? isStarted,
      num? overs,
      num? innings,
      String? createdAt,
      String? updatedAt,
      num? v,
    int? megaPrice, // Add megaPrice here
    List<LeagueDetails>? leagueDetails,
      List<Team1Details>? team1Details,
      List<Team1CaptainDetails>? team1CaptainDetails,
      List<Team1ViceCaptainDetails>? team1ViceCaptainDetails,
      List<Team2Details>? team2Details,
      List<Team2CaptainDetails>? team2CaptainDetails,
      List<Team2ViceCaptainDetails>? team2ViceCaptainDetails,
  }){
    _id = id;
    _leagueId = leagueId;
    _team1Id = team1Id;
    _team2Id = team2Id;
    _matchName = matchName;
    _date = date;
    _time = time;
    _vanue = vanue;
    _city = city;
    _state = state;
    _country = country;
    _isStarted = isStarted;
    _overs = overs;
    _innings = innings;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _megaPrice = megaPrice; // Initialize megaPrice
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
    _vanue = json['vanue'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _isStarted = json['isStarted'];
    _overs = json['overs'];
    _innings = json['innings'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _megaPrice = json['megaPrice']; // Parse megaPrice
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
        _team2ViceCaptainDetails?.add(Team2ViceCaptainDetails.fromJson(v));
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
  String? _vanue;
  String? _city;
  String? _state;
  String? _country;
  bool? _isStarted;
  num? _overs;
  num? _innings;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  int? _megaPrice; // Add megaPrice here
  List<LeagueDetails>? _leagueDetails;
  List<Team1Details>? _team1Details;
  List<Team1CaptainDetails>? _team1CaptainDetails;
  List<Team1ViceCaptainDetails>? _team1ViceCaptainDetails;
  List<Team2Details>? _team2Details;
  List<Team2CaptainDetails>? _team2CaptainDetails;
  List<Team2ViceCaptainDetails>? _team2ViceCaptainDetails;
Data copyWith({  String? id,
  String? leagueId,
  String? team1Id,
  String? team2Id,
  String? matchName,
  String? date,
  String? time,
  String? vanue,
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
  List<LeagueDetails>? leagueDetails,
  List<Team1Details>? team1Details,
  List<Team1CaptainDetails>? team1CaptainDetails,
  List<Team1ViceCaptainDetails>? team1ViceCaptainDetails,
  List<Team2Details>? team2Details,
  List<Team2CaptainDetails>? team2CaptainDetails,
  List<Team2ViceCaptainDetails>? team2ViceCaptainDetails,
}) => Data(  id: id ?? _id,
  leagueId: leagueId ?? _leagueId,
  team1Id: team1Id ?? _team1Id,
  team2Id: team2Id ?? _team2Id,
  matchName: matchName ?? _matchName,
  date: date ?? _date,
  time: time ?? _time,
  vanue: vanue ?? _vanue,
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
  String? get vanue => _vanue;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  bool? get isStarted => _isStarted;
  num? get overs => _overs;
  num? get innings => _innings;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  int? get megaPrice => _megaPrice; // Add megaPrice getter
  List<LeagueDetails>? get leagueDetails => _leagueDetails;
  List<Team1Details>? get team1Details => _team1Details;
  List<Team1CaptainDetails>? get team1CaptainDetails => _team1CaptainDetails;
  List<Team1ViceCaptainDetails>? get team1ViceCaptainDetails => _team1ViceCaptainDetails;
  List<Team2Details>? get team2Details => _team2Details;
  List<Team2CaptainDetails>? get team2CaptainDetails => _team2CaptainDetails;
  List<Team2ViceCaptainDetails>? get team2ViceCaptainDetails => _team2ViceCaptainDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['league_id'] = _leagueId;
    map['team_1_id'] = _team1Id;
    map['team_2_id'] = _team2Id;
    map['match_name'] = _matchName;
    map['date'] = _date;
    map['time'] = _time;
    map['vanue'] = _vanue;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['isStarted'] = _isStarted;
    map['overs'] = _overs;
    map['innings'] = _innings;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
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
Team2ViceCaptainDetails team2ViceCaptainDetailsFromJson(String str) => Team2ViceCaptainDetails.fromJson(json.decode(str));
String team2ViceCaptainDetailsToJson(Team2ViceCaptainDetails data) => json.encode(data.toJson());
class Team2ViceCaptainDetails {
  Team2ViceCaptainDetails({
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

  Team2ViceCaptainDetails.fromJson(dynamic json) {
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
Team2ViceCaptainDetails copyWith({  String? id,
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
}) => Team2ViceCaptainDetails(  id: id ?? _id,
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
Team2Details team2DetailsFromJson(String str) => Team2Details.fromJson(json.decode(str));
String team2DetailsToJson(Team2Details data) => json.encode(data.toJson());
class Team2Details {
  Team2Details({
      String? id,
      String? teamName,
      String? logo,
      String? otherPhoto,
      String? shortName,
      String? captain,
      String? viceCaptain,
      String? createdAt,
      String? updatedAt,
      num? v,
      String? leagueId,
      String? colorCode,}){
    _id = id;
    _teamName = teamName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _shortName = shortName;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _leagueId = leagueId;
    _colorCode = colorCode;
}

  Team2Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _shortName = json['short_name'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _leagueId = json['league_id'];
    _colorCode = json['color_code'];
  }
  String? _id;
  String? _teamName;
  String? _logo;
  String? _otherPhoto;
  String? _shortName;
  String? _captain;
  String? _viceCaptain;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _leagueId;
  String? _colorCode;
Team2Details copyWith({  String? id,
  String? teamName,
  String? logo,
  String? otherPhoto,
  String? shortName,
  String? captain,
  String? viceCaptain,
  String? createdAt,
  String? updatedAt,
  num? v,
  String? leagueId,
  String? colorCode,
}) => Team2Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  shortName: shortName ?? _shortName,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  leagueId: leagueId ?? _leagueId,
  colorCode: colorCode ?? _colorCode,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get shortName => _shortName;
  String? get captain => _captain;
  String? get viceCaptain => _viceCaptain;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get leagueId => _leagueId;
  String? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['short_name'] = _shortName;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['league_id'] = _leagueId;
    map['color_code'] = _colorCode;
    return map;
  }
}
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
Team1Details team1DetailsFromJson(String str) => Team1Details.fromJson(json.decode(str));
String team1DetailsToJson(Team1Details data) => json.encode(data.toJson());
class Team1Details {
  Team1Details({
      String? id,
      String? teamName,
      String? logo,
      String? otherPhoto,
      String? shortName,
      String? captain,
      String? viceCaptain,
      String? createdAt,
      String? updatedAt,
      num? v,
      String? colorCode,
      String? leagueId,}){
    _id = id;
    _teamName = teamName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _shortName = shortName;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _colorCode = colorCode;
    _leagueId = leagueId;
}
  Team1Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _shortName = json['short_name'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _colorCode = json['color_code'];
    _leagueId = json['league_id'];
  }
  String? _id;
  String? _teamName;
  String? _logo;
  String? _otherPhoto;
  String? _shortName;
  String? _captain;
  String? _viceCaptain;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _colorCode;
  String? _leagueId;
Team1Details copyWith({  String? id,
  String? teamName,
  String? logo,
  String? otherPhoto,
  String? shortName,
  String? captain,
  String? viceCaptain,
  String? createdAt,
  String? updatedAt,
  num? v,
  String? colorCode,
  String? leagueId,
}) => Team1Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  shortName: shortName ?? _shortName,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  colorCode: colorCode ?? _colorCode,
  leagueId: leagueId ?? _leagueId,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get shortName => _shortName;
  String? get captain => _captain;
  String? get viceCaptain => _viceCaptain;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get colorCode => _colorCode;
  String? get leagueId => _leagueId;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['short_name'] = _shortName;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['color_code'] = _colorCode;
    map['league_id'] = _leagueId;
    return map;
  }
}
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