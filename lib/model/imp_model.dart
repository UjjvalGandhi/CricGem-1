import 'dart:convert';

class IplModel {
  final bool? success;
  final String? message;
  final List<IplTeam>? data;

  IplModel({
    this.success,
    this.message,
    this.data,
  });

  IplModel copyWith({
    bool? success,
    String? message,
    List<IplTeam>? data,
  }) =>
      IplModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory IplModel.fromRawJson(String str) => IplModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IplModel.fromJson(Map<String, dynamic> json) => IplModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<IplTeam>.from(json["data"]!.map((x) => IplTeam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class IplTeam {
  final String? id;
  final String? leagueId;
  final String? team1Id;
  final String? team2Id;
  final String? matchName;
  final DateTime? date;
  final String? time;
  final String? vanue;
  final String? city;
  final String? state;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<LeagueDetail>? leagueDetails;
  final List<TeamDetail>? team1Details;
  final List<dynamic>? team1CaptainDetails;
  final List<dynamic>? team1ViceCaptainDetails;
  final List<TeamDetail>? team2Details;
  final List<dynamic>? team2CaptainDetails;
  final List<dynamic>? team2ViceCaptainDetails;

  IplTeam({
    this.id,
    this.leagueId,
    this.team1Id,
    this.team2Id,
    this.matchName,
    this.date,
    this.time,
    this.vanue,
    this.city,
    this.state,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.leagueDetails,
    this.team1Details,
    this.team1CaptainDetails,
    this.team1ViceCaptainDetails,
    this.team2Details,
    this.team2CaptainDetails,
    this.team2ViceCaptainDetails,
  });

  IplTeam copyWith({
    String? id,
    String? leagueId,
    String? team1Id,
    String? team2Id,
    String? matchName,
    DateTime? date,
    String? time,
    String? vanue,
    String? city,
    String? state,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<LeagueDetail>? leagueDetails,
    List<TeamDetail>? team1Details,
    List<dynamic>? team1CaptainDetails,
    List<dynamic>? team1ViceCaptainDetails,
    List<TeamDetail>? team2Details,
    List<dynamic>? team2CaptainDetails,
    List<dynamic>? team2ViceCaptainDetails,
  }) =>
      IplTeam(
        id: id ?? this.id,
        leagueId: leagueId ?? this.leagueId,
        team1Id: team1Id ?? this.team1Id,
        team2Id: team2Id ?? this.team2Id,
        matchName: matchName ?? this.matchName,
        date: date ?? this.date,
        time: time ?? this.time,
        vanue: vanue ?? this.vanue,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        leagueDetails: leagueDetails ?? this.leagueDetails,
        team1Details: team1Details ?? this.team1Details,
        team1CaptainDetails: team1CaptainDetails ?? this.team1CaptainDetails,
        team1ViceCaptainDetails: team1ViceCaptainDetails ?? this.team1ViceCaptainDetails,
        team2Details: team2Details ?? this.team2Details,
        team2CaptainDetails: team2CaptainDetails ?? this.team2CaptainDetails,
        team2ViceCaptainDetails: team2ViceCaptainDetails ?? this.team2ViceCaptainDetails,
      );

  factory IplTeam.fromRawJson(String str) => IplTeam.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IplTeam.fromJson(Map<String, dynamic> json) => IplTeam(
    id: json["_id"],
    leagueId: json["league_id"],
    team1Id: json["team_1_id"],
    team2Id: json["team_2_id"],
    matchName: json["match_name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    vanue: json["vanue"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    leagueDetails: json["league_details"] == null ? [] : List<LeagueDetail>.from(json["league_details"]!.map((x) => LeagueDetail.fromJson(x))),
    team1Details: json["team_1_details"] == null ? [] : List<TeamDetail>.from(json["team_1_details"]!.map((x) => TeamDetail.fromJson(x))),
    team1CaptainDetails: json["team_1_captain_details"] == null ? [] : List<dynamic>.from(json["team_1_captain_details"]!.map((x) => x)),
    team1ViceCaptainDetails: json["team_1_viceCaptain_details"] == null ? [] : List<dynamic>.from(json["team_1_viceCaptain_details"]!.map((x) => x)),
    team2Details: json["team_2_details"] == null ? [] : List<TeamDetail>.from(json["team_2_details"]!.map((x) => TeamDetail.fromJson(x))),
    team2CaptainDetails: json["team_2_captain_details"] == null ? [] : List<dynamic>.from(json["team_2_captain_details"]!.map((x) => x)),
    team2ViceCaptainDetails: json["team_2_viceCaptain_details"] == null ? [] : List<dynamic>.from(json["team_2_viceCaptain_details"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "league_id": leagueId,
    "team_1_id": team1Id,
    "team_2_id": team2Id,
    "match_name": matchName,
    "date": date?.toIso8601String(),
    "time": time,
    "vanue": vanue,
    "city": city,
    "state": state,
    "country": country,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "league_details": leagueDetails == null ? [] : List<dynamic>.from(leagueDetails!.map((x) => x.toJson())),
    "team_1_details": team1Details == null ? [] : List<dynamic>.from(team1Details!.map((x) => x.toJson())),
    "team_1_captain_details": team1CaptainDetails == null ? [] : List<dynamic>.from(team1CaptainDetails!.map((x) => x)),
    "team_1_viceCaptain_details": team1ViceCaptainDetails == null ? [] : List<dynamic>.from(team1ViceCaptainDetails!.map((x) => x)),
    "team_2_details": team2Details == null ? [] : List<dynamic>.from(team2Details!.map((x) => x.toJson())),
    "team_2_captain_details": team2CaptainDetails == null ? [] : List<dynamic>.from(team2CaptainDetails!.map((x) => x)),
    "team_2_viceCaptain_details": team2ViceCaptainDetails == null ? [] : List<dynamic>.from(team2ViceCaptainDetails!.map((x) => x)),
  };
}

class LeagueDetail {
  final String? id;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? leagueName;

  LeagueDetail({
    this.id,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.leagueName,
  });

  LeagueDetail copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? leagueName,
  }) =>
      LeagueDetail(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        leagueName: leagueName ?? this.leagueName,
      );

  factory LeagueDetail.fromRawJson(String str) => LeagueDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeagueDetail.fromJson(Map<String, dynamic> json) => LeagueDetail(
    id: json["_id"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    leagueName: json["league_name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "league_name": leagueName,
  };
}

class TeamDetail {
  final String? id;
  final String? teamName;
  final String? logo;
  final String? otherPhoto;
  final String? shortName;
  final String? captain;
  final String? viceCaptain;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? teamDetailColorCode;
  final String? colorCode;
  final String? leagueId;

  TeamDetail({
    this.id,
    this.teamName,
    this.logo,
    this.otherPhoto,
    this.shortName,
    this.captain,
    this.viceCaptain,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.teamDetailColorCode,
    this.colorCode,
    this.leagueId,
  });

  TeamDetail copyWith({
    String? id,
    String? teamName,
    String? logo,
    String? otherPhoto,
    String? shortName,
    String? captain,
    String? viceCaptain,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? teamDetailColorCode,
    String? colorCode,
    String? leagueId,
  }) =>
      TeamDetail(
        id: id ?? this.id,
        teamName: teamName ?? this.teamName,
        logo: logo ?? this.logo,
        otherPhoto: otherPhoto ?? this.otherPhoto,
        shortName: shortName ?? this.shortName,
        captain: captain ?? this.captain,
        viceCaptain: viceCaptain ?? this.viceCaptain,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        teamDetailColorCode: teamDetailColorCode ?? this.teamDetailColorCode,
        colorCode: colorCode ?? this.colorCode,
        leagueId: leagueId ?? this.leagueId,
      );

  factory TeamDetail.fromRawJson(String str) => TeamDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamDetail.fromJson(Map<String, dynamic> json) => TeamDetail(
    id: json["_id"],
    teamName: json["team_name"],
    logo: json["logo"],
    otherPhoto: json["other_photo"],
    shortName: json["short_name"],
    captain: json["captain"],
    viceCaptain: json["vice_captain"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    teamDetailColorCode: json["color_code"],
    colorCode: json[" color_code"],
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
    "__v": v,
    "color_code": teamDetailColorCode,
    " color_code": colorCode,
    "league_id": leagueId,
  };
}
