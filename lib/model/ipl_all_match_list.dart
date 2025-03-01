import 'dart:convert';

IplMatchList iplMatchListFromJson(String str) => IplMatchList.fromJson(json.decode(str));

String iplMatchListToJson(IplMatchList data) => json.encode(data.toJson());

class IplMatchList {
  bool success;
  String message;
  List<IplDatum> data;

  IplMatchList({
    required this.success,
    required this.message,
    required this.data,
  });

  factory IplMatchList.fromJson(Map<String, dynamic> json) => IplMatchList(
    success: json["success"],
    message: json["message"],
    data: List<IplDatum>.from(json["data"].map((x) => IplDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class IplDatum {
  String id;
  LeagueId leagueId;
  String team1Id;
  String team2Id;
  String matchName;
  DateTime date;
  Time time;
  String vanue;
  String city;
  String state;
  Country country;
  bool isStarted;
  int overs;
  int innings;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<IplLeagueDetail> leagueDetails;
  List<IplTeamDetail> team1Details;
  List<IplTeamCaptainDetail> team1CaptainDetails;
  List<IplTeamCaptainDetail> team1ViceCaptainDetails;
  List<IplTeamDetail> team2Details;
  List<IplTeamCaptainDetail> team2CaptainDetails;
  List<IplTeamCaptainDetail> team2ViceCaptainDetails;

  IplDatum({
    required this.id,
    required this.leagueId,
    required this.team1Id,
    required this.team2Id,
    required this.matchName,
    required this.date,
    required this.time,
    required this.vanue,
    required this.city,
    required this.state,
    required this.country,
    required this.isStarted,
    required this.overs,
    required this.innings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.leagueDetails,
    required this.team1Details,
    required this.team1CaptainDetails,
    required this.team1ViceCaptainDetails,
    required this.team2Details,
    required this.team2CaptainDetails,
    required this.team2ViceCaptainDetails,
  });

  factory IplDatum.fromJson(Map<String, dynamic> json) => IplDatum(
    id: json["_id"],
    leagueId: leagueIdValues.map[json["league_id"]]!,
    team1Id: json["team_1_id"],
    team2Id: json["team_2_id"],
    matchName: json["match_name"],
    date: DateTime.parse(json["date"]),
    time: timeValues.map[json["time"]]!,
    vanue: json["vanue"],
    city: json["city"],
    state: json["state"],
    country: countryValues.map[json["country"]]!,
    isStarted: json["isStarted"],
    overs: json["overs"],
    innings: json["innings"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    leagueDetails: List<IplLeagueDetail>.from(json["league_details"].map((x) => IplLeagueDetail.fromJson(x))),
    team1Details: List<IplTeamDetail>.from(json["team_1_details"].map((x) => IplTeamDetail.fromJson(x))),
    team1CaptainDetails: List<IplTeamCaptainDetail>.from(json["team_1_captain_details"].map((x) => IplTeamCaptainDetail.fromJson(x))),
    team1ViceCaptainDetails: List<IplTeamCaptainDetail>.from(json["team_1_viceCaptain_details"].map((x) => IplTeamCaptainDetail.fromJson(x))),
    team2Details: List<IplTeamDetail>.from(json["team_2_details"].map((x) => IplTeamDetail.fromJson(x))),
    team2CaptainDetails: List<IplTeamCaptainDetail>.from(json["team_2_captain_details"].map((x) => IplTeamCaptainDetail.fromJson(x))),
    team2ViceCaptainDetails: List<IplTeamCaptainDetail>.from(json["team_2_viceCaptain_details"].map((x) => IplTeamCaptainDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "league_id": leagueIdValues.reverse[leagueId],
    "team_1_id": team1Id,
    "team_2_id": team2Id,
    "match_name": matchName,
    "date": date.toIso8601String(),
    "time": timeValues.reverse[time],
    "vanue": vanue,
    "city": city,
    "state": state,
    "country": countryValues.reverse[country],
    "isStarted": isStarted,
    "overs": overs,
    "innings": innings,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "league_details": List<dynamic>.from(leagueDetails.map((x) => x.toJson())),
    "team_1_details": List<dynamic>.from(team1Details.map((x) => x.toJson())),
    "team_1_captain_details": List<dynamic>.from(team1CaptainDetails.map((x) => x.toJson())),
    "team_1_viceCaptain_details": List<dynamic>.from(team1ViceCaptainDetails.map((x) => x.toJson())),
    "team_2_details": List<dynamic>.from(team2Details.map((x) => x.toJson())),
    "team_2_captain_details": List<dynamic>.from(team2CaptainDetails.map((x) => x.toJson())),
    "team_2_viceCaptain_details": List<dynamic>.from(team2ViceCaptainDetails.map((x) => x.toJson())),
  };
}

enum Country {
  AUSTRALIA,
  INDIA,
  SOUTH_AFRICA,
  UNITED_KINGDOM
}

final countryValues = EnumValues({
  "Australia": Country.AUSTRALIA,
  "India": Country.INDIA,
  "South Africa": Country.SOUTH_AFRICA,
  "United Kingdom": Country.UNITED_KINGDOM
});

class IplLeagueDetail {
  LeagueId id;
  LeagueName leagueName;
  MatchType matchType;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  IplLeagueDetail({
    required this.id,
    required this.leagueName,
    required this.matchType,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory IplLeagueDetail.fromJson(Map<String, dynamic> json) => IplLeagueDetail(
    id: leagueIdValues.map[json["_id"]]!,
    leagueName: leagueNameValues.map[json["league_name"]]!,
    matchType: matchTypeValues.map[json["matchType"]]!,
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": leagueIdValues.reverse[id],
    "league_name": leagueNameValues.reverse[leagueName],
    "matchType": matchTypeValues.reverse[matchType],
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

enum LeagueId {
  THE_669_A499_DB7_D111_A9_D554_F5_D0
}

final leagueIdValues = EnumValues({
  "669a499db7d111a9d554f5d0": LeagueId.THE_669_A499_DB7_D111_A9_D554_F5_D0
});

enum LeagueName {
  IPL_2024
}

final leagueNameValues = EnumValues({
  "IPL 2024": LeagueName.IPL_2024
});

enum MatchType {
  THE_669_A3_F49767133_A748438_E09
}

final matchTypeValues = EnumValues({
  "669a3f49767133a748438e09": MatchType.THE_669_A3_F49767133_A748438_E09
});

class IplTeamCaptainDetail {
  String id;
  String playerName;
  String playerPhoto;
  int age;
  Country nationality;
  DateTime birthDate;
  Role role;
  Type batType;
  Type bowlType;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  IplTeamCaptainDetail({
    required this.id,
    required this.playerName,
    required this.playerPhoto,
    required this.age,
    required this.nationality,
    required this.birthDate,
    required this.role,
    required this.batType,
    required this.bowlType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory IplTeamCaptainDetail.fromJson(Map<String, dynamic> json) => IplTeamCaptainDetail(
    id: json["_id"],
    playerName: json["player_name"],
    playerPhoto: json["player_photo"],
    age: json["age"],
    nationality: countryValues.map[json["nationality"]]!,
    birthDate: DateTime.parse(json["birth_date"]),
    role: roleValues.map[json["role"]]!,
    batType: typeValues.map[json["bat_type"]]!,
    bowlType: typeValues.map[json["bowl_type"]]!,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "player_name": playerName,
    "player_photo": playerPhoto,
    "age": age,
    "nationality": countryValues.reverse[nationality],
    "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
    "role": roleValues.reverse[role],
    "bat_type": typeValues.reverse[batType],
    "bowl_type": typeValues.reverse[bowlType],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

enum Type {
  LEFT_HAND,
  RIGHT_HAND
}

final typeValues = EnumValues({
  "Left hand": Type.LEFT_HAND,
  "Right hand": Type.RIGHT_HAND
});

enum Role {
  ALL_ROUNDER,
  BATSMAN,
  BOWLER,
  WICKET_KEEPER
}

final roleValues = EnumValues({
  "All Rounder": Role.ALL_ROUNDER,
  "Batsman": Role.BATSMAN,
  "Bowler": Role.BOWLER,
  "Wicket Keeper": Role.WICKET_KEEPER
});

class IplTeamDetail {
  String id;
  String teamName;
  String logo;
  String otherPhoto;
  String shortName;
  String captain;
  String viceCaptain;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String colorCode;
  LeagueId leagueId;

  IplTeamDetail({
    required this.id,
    required this.teamName,
    required this.logo,
    required this.otherPhoto,
    required this.shortName,
    required this.captain,
    required this.viceCaptain,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.colorCode,
    required this.leagueId,
  });

  factory IplTeamDetail.fromJson(Map<String, dynamic> json) => IplTeamDetail(
    id: json["_id"],
    teamName: json["team_name"],
    logo: json["logo"],
    otherPhoto: json["other_photo"],
    shortName: json["short_name"],
    captain: json["captain"],
    viceCaptain: json["vice_captain"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    colorCode: json["color_code"],
    leagueId: leagueIdValues.map[json["league_id"]]!,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "team_name": teamName,
    "logo": logo,
    "other_photo": otherPhoto,
    "short_name": shortName,
    "captain": captain,
    "vice_captain": viceCaptain,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "color_code": colorCode,
    "league_id": leagueIdValues.reverse[leagueId],
  };
}

enum Time {
  THE_1800
}

final timeValues = EnumValues({
  "18:00": Time.THE_1800
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}