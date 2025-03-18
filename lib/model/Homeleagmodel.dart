import 'dart:convert';

class HomeLeagModel {
  final bool? success;
  final String? message;
  final List<AppDatum>? data;

  HomeLeagModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeLeagModel.fromJson(Map<String, dynamic> json) => HomeLeagModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<AppDatum>.from(json["data"].map((x) => AppDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AppDatum {
  final LeagueDetails? leagueDetails;
  final UpcomingMatches? upcomingMatches;
  final UserMatches? userMatches;

  AppDatum({
    this.leagueDetails,
    this.upcomingMatches,
    this.userMatches,
  });

  factory AppDatum.fromJson(Map<String, dynamic> json) => AppDatum(
    leagueDetails: json["league_details"] == null
        ? null
        : LeagueDetails.fromJson(json["league_details"]),
    upcomingMatches: json["upcomingMatches"] == null
        ? null
        : UpcomingMatches.fromJson(json["upcomingMatches"]),
    userMatches: json["userMatches"] == null
        ? null
        : UserMatches.fromJson(json["userMatches"]),
  );

  Map<String, dynamic> toJson() => {
    "league_details": leagueDetails?.toJson(),
    "upcomingMatches": upcomingMatches?.toJson(),
    "userMatches": userMatches?.toJson(),
  };
}

class LeagueDetails {
  final String? id;
  final String? leaguaName;
  final String? design;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<Match>? matches;

  LeagueDetails({
    this.id,
    this.leaguaName,
    this.design,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.matches,
  });

  factory LeagueDetails.fromJson(Map<String, dynamic> json) => LeagueDetails(
    id: json["_id"],
    leaguaName: json["leagua_name"],
      design: json['design'],
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    matches: json["matches"] == null
        ? []
        : List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "leagua_name": leaguaName,
    "design": design,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "matches": matches == null ? [] : List<dynamic>.from(matches!.map((x) => x.toJson())),
  };
}

class Match {
  final String? id;
  final String? leagueId;
  final String? matchName;
  final DateTime? date;
  final String? time;
  final String? vanue;
  final String? city;
  final String? state;
  final String? country;
  final num? megaprice;
  final TeamDetails? team1Details;
  final TeamDetails? team2Details;

  Match({
    this.id,
    this.leagueId,
    this.matchName,
    this.date,
    this.time,
    this.vanue,
    this.city,
    this.state,
    this.country,
    this.megaprice,
    this.team1Details,
    this.team2Details,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["_id"],
    leagueId: json["league_id"],
    matchName: json["match_name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    vanue: json["vanue"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    megaprice: json["megaPrice"],
    team1Details: json["team_1_details"] == null
        ? null
        : TeamDetails.fromJson(json["team_1_details"]),
    team2Details: json["team_2_details"] == null
        ? null
        : TeamDetails.fromJson(json["team_2_details"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "league_id": leagueId,
    "match_name": matchName,
    "date": date?.toIso8601String(),
    "time": time,
    "vanue": vanue,
    "city": city,
    "state": state,
    "country": country,
    "team_1_details": team1Details?.toJson(),
    "team_2_details": team2Details?.toJson(),
  };
}
class TeamDetails {
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
  final String? colorCode;
  final String? leagueId;
  final String? teamDetailsColorCode;
  final String? captain_photo;


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
    this.v,
    this.colorCode,
    this.leagueId,
    this.teamDetailsColorCode,
    this.captain_photo
  });



  TeamDetails copyWith({
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
    String? colorCode,
    String? leagueId,
    String? teamDetailsColorCode,
    String? captain_photo,
  }) =>
      TeamDetails(
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
          colorCode: colorCode ?? this.colorCode,
          leagueId: leagueId ?? this.leagueId,
          teamDetailsColorCode: teamDetailsColorCode ?? this.teamDetailsColorCode,
          captain_photo: leagueId ?? this.captain_photo

      );

  factory TeamDetails.fromRawJson(String str) => TeamDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
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
      colorCode: json["color_code"],
      leagueId: json["league_id"],
      teamDetailsColorCode: json["color_code"],
      captain_photo:json['captain_photo']
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
    " color_code": colorCode,
    "league_id": leagueId,
    "color_code": teamDetailsColorCode,
    "captain_photo":captain_photo
  };
}

class UpcomingMatches {
  final List<UpcomingMatchesMatch>? matches;

  UpcomingMatches({
    this.matches,
  });

  UpcomingMatches copyWith({
    List<UpcomingMatchesMatch>? matches,
  }) =>
      UpcomingMatches(
        matches: matches ?? this.matches,
      );

  factory UpcomingMatches.fromRawJson(String str) => UpcomingMatches.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpcomingMatches.fromJson(Map<String, dynamic> json) => UpcomingMatches(
    matches: json["matches"] == null ? [] : List<UpcomingMatchesMatch>.from(json["matches"]!.map((x) => UpcomingMatchesMatch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "matches": matches == null ? [] : List<dynamic>.from(matches!.map((x) => x.toJson())),
  };
}

class UpcomingMatchesMatch {
  final Match? matchDetails;

  UpcomingMatchesMatch({
    this.matchDetails,
  });

  UpcomingMatchesMatch copyWith({
    Match? matchDetails,
  }) =>
      UpcomingMatchesMatch(
        matchDetails: matchDetails ?? this.matchDetails,
      );

  factory UpcomingMatchesMatch.fromRawJson(String str) => UpcomingMatchesMatch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpcomingMatchesMatch.fromJson(Map<String, dynamic> json) => UpcomingMatchesMatch(
    matchDetails: json["match_details"] == null ? null : Match.fromJson(json["match_details"]),
  );

  Map<String, dynamic> toJson() => {
    "match_details": matchDetails?.toJson(),
  };
}

class UserMatches {
  final List<UserMatchesMatch>? matches;

  UserMatches({
    this.matches,
  });

  UserMatches copyWith({
    List<UserMatchesMatch>? matches,
  }) =>
      UserMatches(
        matches: matches ?? this.matches,
      );

  factory UserMatches.fromRawJson(String str) => UserMatches.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMatches.fromJson(Map<String, dynamic> json) => UserMatches(
    matches: json["matches"] == null ? [] : List<UserMatchesMatch>.from(json["matches"]!.map((x) => UserMatchesMatch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "matches": matches == null ? [] : List<dynamic>.from(matches!.map((x) => x.toJson())),
  };
}

class UserMatchesMatch {
  final UserMatchDetails? userMatchDetails;

  UserMatchesMatch({
    this.userMatchDetails,
  });

  UserMatchesMatch copyWith({
    UserMatchDetails? userMatchDetails,
  }) =>
      UserMatchesMatch(
        userMatchDetails: userMatchDetails ?? this.userMatchDetails,
      );

  factory UserMatchesMatch.fromRawJson(String str) => UserMatchesMatch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMatchesMatch.fromJson(Map<String, dynamic> json) => UserMatchesMatch(
    userMatchDetails: json["user_match_details"] == null ? null : UserMatchDetails.fromJson(json["user_match_details"]),
  );

  Map<String, dynamic> toJson() => {
    "user_match_details": userMatchDetails?.toJson(),
  };
}

class UserMatchDetails {
  final String? id;
  final String? leagueId;
  final String? matchName;
  final DateTime? date;
  final String? time;
  final String? vanue;
  final String? city;
  final String? state;
  final String? country;
  final TeamDetails? team1Details;
  final TeamDetails? team2Details;
  final List<String>? players;
  final String? captain;
  final String? vicecaptain;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserMatchDetails({
    this.id,
    this.leagueId,
    this.matchName,
    this.date,
    this.time,
    this.vanue,
    this.city,
    this.state,
    this.country,
    this.team1Details,
    this.team2Details,
    this.players,
    this.captain,
    this.vicecaptain,
    this.createdAt,
    this.updatedAt,
  });

  UserMatchDetails copyWith({
    String? id,
    String? leagueId,
    String? matchName,
    DateTime? date,
    String? time,
    String? vanue,
    String? city,
    String? state,
    String? country,
    TeamDetails? team1Details,
    TeamDetails? team2Details,
    List<String>? players,
    String? captain,
    String? vicecaptain,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserMatchDetails(
        id: id ?? this.id,
        leagueId: leagueId ?? this.leagueId,
        matchName: matchName ?? this.matchName,
        date: date ?? this.date,
        time: time ?? this.time,
        vanue: vanue ?? this.vanue,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        team1Details: team1Details ?? this.team1Details,
        team2Details: team2Details ?? this.team2Details,
        players: players ?? this.players,
        captain: captain ?? this.captain,
        vicecaptain: vicecaptain ?? this.vicecaptain,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserMatchDetails.fromRawJson(String str) => UserMatchDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMatchDetails.fromJson(Map<String, dynamic> json) => UserMatchDetails(
    id: json["_id"],
    leagueId: json["league_id"],
    matchName: json["match_name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    vanue: json["vanue"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    team1Details: json["team_1_details"] == null ? null : TeamDetails.fromJson(json["team_1_details"]),
    team2Details: json["team_2_details"] == null ? null : TeamDetails.fromJson(json["team_2_details"]),
    players: json["players"] == null ? [] : List<String>.from(json["players"]!.map((x) => x)),
    captain: json["captain"],
    vicecaptain: json["vicecaptain"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "league_id": leagueId,
    "match_name": matchName,
    "date": date?.toIso8601String(),
    "time": time,
    "vanue": vanue,
    "city": city,
    "state": state,
    "country": country,
    "team_1_details": team1Details?.toJson(),
    "team_2_details": team2Details?.toJson(),
    "players": players == null ? [] : List<dynamic>.from(players!.map((x) => x)),
    "captain": captain,
    "vicecaptain": vicecaptain,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

// class Wallet {
//   String id;
//   double funds;
//   double fundsUtilized;
//
//   Wallet({
//     required this.id,
//     required this.funds,
//     required this.fundsUtilized,
//   });
//
//   // Factory method to create a Wallet object from a JSON map
//   factory Wallet.fromJson(Map<String, dynamic> json) {
//     return Wallet(
//       id: json['_id'],
//       funds: json['funds'].toDouble(),
//       fundsUtilized: json['fundsUtilized'].toDouble(),
//     );
//   }
//
//   // Method to convert a Wallet object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'funds': funds,
//       'fundsUtilized': fundsUtilized,
//     };
//   }
// }
//
// class UserWallet {
//   List<Wallet> wallet;
//
//   UserWallet({required this.wallet});
//
//   // Factory method to create a UserWallet object from a JSON map
//   factory UserWallet.fromJson(Map<String, dynamic> json) {
//     var walletList = json['wallet'] as List;
//     List<Wallet> wallet = walletList.map((i) => Wallet.fromJson(i)).toList();
//
//     return UserWallet(wallet: wallet);
//   }
//
//   // Method to convert a UserWallet object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'wallet': wallet.map((e) => e.toJson()).toList(),
//     };
//   }
// }

class UserWallet {
  List<Wallet>? wallet;

  UserWallet({this.wallet});

  UserWallet.fromJson(Map<String, dynamic> json) {
    if (json['wallet'] != null) {
      wallet = <Wallet>[];
      json['wallet'].forEach((v) {
        wallet!.add(Wallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wallet != null) {
      data['wallet'] = wallet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallet {
  String? sId;
  int? funds;
  int? fundsUtilized;

  Wallet({this.sId, this.funds, this.fundsUtilized});

  Wallet.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    funds = json['funds'];
    fundsUtilized = json['fundsUtilized'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['funds'] = funds;
    data['fundsUtilized'] = fundsUtilized;
    return data;
  }
}