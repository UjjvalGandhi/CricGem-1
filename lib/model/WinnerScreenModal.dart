
class WinnerScreenModal {
  final bool success;
  final String message;
  final List<ContestDetail> data;

  WinnerScreenModal({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WinnerScreenModal.fromJson(Map<String, dynamic> json) {
    return WinnerScreenModal(
      success: json['success'],
      message: json['message'],
      data: List<ContestDetail>.from(
          json['data'].map((x) => ContestDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class ContestDetail {
  final String id;
  final String leagueName;
  final String matchType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Match matches;
  final TeamDetails team1Details;
  final TeamDetails team2Details;
  final List<Contest> contests;

  ContestDetail({
    required this.id,
    required this.leagueName,
    required this.matchType,
    required this.createdAt,
    required this.updatedAt,
    required this.matches,
    required this.team1Details,
    required this.team2Details,
    required this.contests,
  });

  factory ContestDetail.fromJson(Map<String, dynamic> json) {
    return ContestDetail(
      id: json['_id'],
      leagueName: json['league_name'],
      matchType: json['matchType'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      matches: Match.fromJson(json['matches']),
      team1Details: TeamDetails.fromJson(json['team_1_details']),
      team2Details: TeamDetails.fromJson(json['team_2_details']),
      contests: List<Contest>.from(
          json['contests'].map((x) => Contest.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'league_name': leagueName,
      'matchType': matchType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'matches': matches.toJson(),
      'team_1_details': team1Details.toJson(),
      'team_2_details': team2Details.toJson(),
      'contests': List<dynamic>.from(contests.map((x) => x.toJson())),
    };
  }
}

class Match {
  final String id;
  final String leagueId;
  final String team1Id;
  final String team2Id;
  final String matchName;
  final DateTime date;
  final String time;
  final String vanue;
  final String city;
  final String state;
  final String country;
  final bool isStarted;
  final int overs;
  final int innings;
  final DateTime createdAt;
  final DateTime updatedAt;

  Match({
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
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['_id'],
      leagueId: json['league_id'],
      team1Id: json['team_1_id'],
      team2Id: json['team_2_id'],
      matchName: json['match_name'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      vanue: json['vanue'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      isStarted: json['isStarted'],
      overs: json['overs'],
      innings: json['innings'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'league_id': leagueId,
      'team_1_id': team1Id,
      'team_2_id': team2Id,
      'match_name': matchName,
      'date': date.toIso8601String(),
      'time': time,
      'vanue': vanue,
      'city': city,
      'state': state,
      'country': country,
      'isStarted': isStarted,
      'overs': overs,
      'innings': innings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class TeamDetails {
  final String id;
  final String teamName;
  final String teamShortName;
  final String logo;

  TeamDetails({
    required this.id,
    required this.teamName,
    required this.teamShortName,
    required this.logo,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      id: json['_id'],
      teamName: json['teamName'],
      teamShortName: json['teamShortName'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'teamName': teamName,
      'teamShortName': teamShortName,
      'logo': logo,
    };
  }
}

class Contest {
  final String matchId;
  final String contestTypeId;
  final int pricePool;
  final int entryFees;
  final int totalParticipant;
  final int maxTeamPerUser;
  final UserDetails userDetails;
  final double totalPoints;
  final int rank;
  final int winningAmount;

  Contest({
    required this.matchId,
    required this.contestTypeId,
    required this.pricePool,
    required this.entryFees,
    required this.totalParticipant,
    required this.maxTeamPerUser,
    required this.userDetails,
    required this.totalPoints,
    required this.rank,
    required this.winningAmount,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      matchId: json['match_id'],
      contestTypeId: json['contest_type_id'],
      pricePool: json['price_pool'],
      entryFees: json['entry_fees'],
      totalParticipant: json['total_participant'],
      maxTeamPerUser: json['max_team_per_user'],
      userDetails: UserDetails.fromJson(json['user_details']),
      totalPoints: json['totalPoints'].toDouble(),
      rank: json['rank'],
      winningAmount: json['winningAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'contest_type_id': contestTypeId,
      'price_pool': pricePool,
      'entry_fees': entryFees,
      'total_participant': totalParticipant,
      'max_team_per_user': maxTeamPerUser,
      'user_details': userDetails.toJson(),
      'totalPoints': totalPoints,
      'rank': rank,
      'winningAmount': winningAmount,
    };
  }
}

// class UserDetails {
//   final String id;
//   final String name;
//   final String profilePhoto;
//
//   UserDetails({
//     required this.id,
//     required this.name,
//     required this.profilePhoto,
//   });
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       id: json['_id'],
//       name: json['name'],
//       profilePhoto: json['profile_photo'],
//     );
//   }
class UserDetails {
  final String id;
  final String name;
  final String profilePhoto;

  UserDetails({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profile_photo': profilePhoto,
    };
  }
}
