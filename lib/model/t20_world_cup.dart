class T20WorldCup {
  final bool success;
  final String message;
  final List<Match> data;

  T20WorldCup({required this.success, required this.message, required this.data});

  factory T20WorldCup.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Match> matchesList = list.map((i) => Match.fromJson(i)).toList();

    return T20WorldCup(
      success: json['success'],
      message: json['message'],
      data: matchesList,
    );
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
  final String venue;
  final String city;
  final String state;
  final String country;
  final bool isStarted;
  final int overs;
  final int innings;
  final LeagueDetails leagueDetails;
  final TeamDetails team1Details;
  final TeamDetails team2Details;

  Match({
    required this.id,
    required this.leagueId,
    required this.team1Id,
    required this.team2Id,
    required this.matchName,
    required this.date,
    required this.time,
    required this.venue,
    required this.city,
    required this.state,
    required this.country,
    required this.isStarted,
    required this.overs,
    required this.innings,
    required this.leagueDetails,
    required this.team1Details,
    required this.team2Details,
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
      venue: json['vanue'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      isStarted: json['isStarted'],
      overs: json['overs'],
      innings: json['innings'],
      leagueDetails: LeagueDetails.fromJson(json['league_details'][0]),
      team1Details: TeamDetails.fromJson(json['team_1_details'][0]),
      team2Details: TeamDetails.fromJson(json['team_2_details'][0]),
    );
  }
}

class LeagueDetails {
  final String id;
  final String leagueName;
  final String matchType;
  final DateTime startDate;
  final DateTime endDate;

  LeagueDetails({
    required this.id,
    required this.leagueName,
    required this.matchType,
    required this.startDate,
    required this.endDate,
  });

  factory LeagueDetails.fromJson(Map<String, dynamic> json) {
    return LeagueDetails(
      id: json['_id'],
      leagueName: json['league_name'],
      matchType: json['matchType'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}

class TeamDetails {
  final String id;
  final String teamName;
  final String logo;
  final String shortName;
  final String colorCode;

  TeamDetails({
    required this.id,
    required this.teamName,
    required this.logo,
    required this.shortName,
    required this.colorCode,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      id: json['_id'],
      teamName: json['team_name'],
      logo: json['logo'],
      shortName: json['short_name'],
      colorCode: json['color_code'],
    );
  }
}
