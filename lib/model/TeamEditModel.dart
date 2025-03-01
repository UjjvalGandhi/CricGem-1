
// Main response model class
class EditTeamModel {
  final bool success;
  final String message;
  final TeamDetails data;

  EditTeamModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EditTeamModel.fromJson(Map<String, dynamic> json) {
    return EditTeamModel(
      success: json['success'],
      message: json['message'],
      data: TeamDetails.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Team details model
class TeamDetails {
  final String id;
  final String captain;
  final String viceCaptain;
  final List<UserDetail> userDetails;
  final MatchDetails match;
  final League league;
  final Team team1;
  final Team team2;
  final List<Player> players;
  final String team1ShortName;
  final String team2ShortName;
  final int team1PlayerCount;
  final int team2PlayerCount;

  TeamDetails({
    required this.id,
    required this.captain,
    required this.viceCaptain,
    required this.userDetails,
    required this.match,
    required this.league,
    required this.team1,
    required this.team2,
    required this.players,
    required this.team1ShortName,
    required this.team2ShortName,
    required this.team1PlayerCount,
    required this.team2PlayerCount,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      id: json['_id'],
      captain: json['captain'],
      viceCaptain: json['vicecaptain'],
      userDetails: (json['user_details'] as List)
          .map((item) => UserDetail.fromJson(item))
          .toList(),
      match: MatchDetails.fromJson(json['match']),
      league: League.fromJson(json['league']),
      team1: Team.fromJson(json['team1']),
      team2: Team.fromJson(json['team2']),
      players: (json['players'] as List)
          .map((item) => Player.fromJson(item))
          .toList(),
      team1ShortName: json['team1ShortName'],
      team2ShortName: json['team2ShortName'],
      team1PlayerCount: json['team1PlayerCount'],
      team2PlayerCount: json['team2PlayerCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'captain': captain,
      'vicecaptain': viceCaptain,
      'user_details': userDetails.map((item) => item.toJson()).toList(),
      'match': match.toJson(),
      'league': league.toJson(),
      'team1': team1.toJson(),
      'team2': team2.toJson(),
      'players': players.map((item) => item.toJson()).toList(),
      'team1ShortName': team1ShortName,
      'team2ShortName': team2ShortName,
      'team1PlayerCount': team1PlayerCount,
      'team2PlayerCount': team2PlayerCount,
    };
  }
}

// User detail model
class UserDetail {
  final String uniqueId;
  final String name;

  UserDetail({
    required this.uniqueId,
    required this.name,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      uniqueId: json['unique_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unique_id': uniqueId,
      'name': name,
    };
  }
}

// Match details model
class MatchDetails {
  final String id;
  final String time;
  final String city;
  final String state;
  final String country;

  MatchDetails({
    required this.id,
    required this.time,
    required this.city,
    required this.state,
    required this.country,
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      id: json['_id'],
      time: json['time'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'time': time,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}

// League model
class League {
  final String leagueName;

  League({
    required this.leagueName,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      leagueName: json['league_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_name': leagueName,
    };
  }
}

// Team model
class Team {
  final String teamName;
  final String logo;
  final String otherPhoto;
  final String shortName;

  Team({
    required this.teamName,
    required this.logo,
    required this.otherPhoto,
    required this.shortName,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamName: json['team_name'],
      logo: json['logo'],
      otherPhoto: json['other_photo'],
      shortName: json['short_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'logo': logo,
      'other_photo': otherPhoto,
      'short_name': shortName,
    };
  }
}

// Player model
class Player {
  final String id;
  final String playerName;
  final String playerPhoto;
  final String nationality;
  final String role;
  final String teamShortName;

  Player({
    required this.id,
    required this.playerName,
    required this.playerPhoto,
    required this.nationality,
    required this.role,
    required this.teamShortName,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['_id'],
      playerName: json['player_name'],
      playerPhoto: json['player_photo'],
      nationality: json['nationality'],
      role: json['role'],
      teamShortName: json['team_short_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'player_name': playerName,
      'player_photo': playerPhoto,
      'nationality': nationality,
      'role': role,
      'team_short_name': teamShortName,
    };
  }
}
// import 'dart:convert';
//
// enum Country {
//   AUSTRALIA,
//   INDIA,
// }
//
// class EditTeamModel {
//   final bool success;
//   final String message;
//   final Data data;
//
//   EditTeamModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory EditTeamModel.fromJson(Map<String, dynamic> json) {
//     return EditTeamModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: Data.fromJson(json['data'] ?? {}),
//     );
//   }
// }
//
// class Data {
//   final String id;
//   final List<UserDetail> userdetails;
//   final List<Player> players;
//   final Match match;
//   final League league;
//   final Team team1;
//   final Team team2;
//   final int team1PlayerCount;
//   final int team2PlayerCount;
//
//   Data({
//     required this.id,
//     required this.userdetails,
//     required this.players,
//     required this.match,
//     required this.league,
//     required this.team1,
//     required this.team2,
//     required this.team1PlayerCount,
//     required this.team2PlayerCount,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['_id'] ?? '',
//       userdetails: (json['user_details'] as List<dynamic>? ?? [])
//           .map((e) => UserDetail.fromJson(e))
//           .toList(),
//       players: (json['players'] as List<dynamic>? ?? [])
//           .map((e) => Player.fromJson(e))
//           .toList(),
//       match: Match.fromJson(json['match'] ?? {}),
//       league: League.fromJson(json['league'] ?? {}),
//       team1: Team.fromJson(json['team1'] ?? {}),
//       team2: Team.fromJson(json['team2'] ?? {}),
//       team1PlayerCount: json['team1PlayerCount'] ?? 0,
//       team2PlayerCount: json['team2PlayerCount'] ?? 0,
//     );
//   }
// }
//
// class Match {
//   final String id;
//   final String time;
//   final String city;
//   final String state;
//   final Country country;
//
//   Match({
//     required this.id,
//     required this.time,
//     required this.city,
//     required this.state,
//     required this.country,
//   });
//
//   factory Match.fromJson(Map<String, dynamic> json) {
//     return Match(
//       id: json['_id'] ?? '',
//       time: json['time'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       country: parseCountry(json['country'] ?? ''),
//     );
//   }
//
//   static Country parseCountry(String countryString) {
//     return countryString.toLowerCase() == 'australia'
//         ? Country.AUSTRALIA
//         : Country.INDIA;
//   }
// }
//
// class League {
//   League();
//
//   factory League.fromJson(Map<String, dynamic> json) {
//     return League();
//   }
// }
//
// class Player {
//   final String playerName;
//   final String playerPhoto;
//   final Country nationality;
//   final String role;
//
//   Player({
//     required this.playerName,
//     required this.playerPhoto,
//     required this.nationality,
//     required this.role,
//   });
//
//   factory Player.fromJson(Map<String, dynamic> json) {
//     return Player(
//       playerName: json['player_name'] ?? '',
//       playerPhoto: json['player_photo'] ?? '',
//       nationality: parseCountry(json['nationality'] ?? ''),
//       role: json['role'] ?? '',
//     );
//   }
//
//   static Country parseCountry(String countryString) {
//     return countryString.toLowerCase() == 'australia'
//         ? Country.AUSTRALIA
//         : Country.INDIA;
//   }
// }
//
// class Team {
//   final String? teamName;
//   final String logo;
//   final String otherPhoto;
//   final String shortName;
//
//   Team({
//     this.teamName,
//     required this.logo,
//     required this.otherPhoto,
//     required this.shortName,
//   });
//
//   factory Team.fromJson(Map<String, dynamic> json) {
//     return Team(
//       teamName: json['team_name'], // Note the updated key
//       logo: json['logo'] ?? '',
//       otherPhoto: json['other_photo'] ?? '',
//       shortName: json['short_name'] ?? '',
//     );
//   }
// }
//
// class UserDetail {
//   final String uniqueId;
//   final String name;
//
//   UserDetail({
//     required this.uniqueId,
//     required this.name,
//   });
//
//   factory UserDetail.fromJson(Map<String, dynamic> json) {
//     return UserDetail(
//       uniqueId: json['unique_id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }
