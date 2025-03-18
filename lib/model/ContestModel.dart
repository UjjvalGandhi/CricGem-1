import 'dart:convert';

ContestModlel contestModlelFromJson(String str) => ContestModlel.fromJson(json.decode(str));

String contestModlelToJson(ContestModlel data) => json.encode(data.toJson());

class ContestModlel {
  bool success;
  String message;
  List<Datum> data;

  ContestModlel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContestModlel.fromJson(Map<String, dynamic> json) => ContestModlel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String leagueId;
  String team1Id;
  String team2Id;
  String matchName;
  DateTime date;
  String time;
  String? venue;  // Nullable
  String city;
  String state;
  String country;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<Contest> contests;

  Datum({
    required this.id,
    required this.leagueId,
    required this.team1Id,
    required this.team2Id,
    required this.matchName,
    required this.date,
    required this.time,
    this.venue,  // Nullable
    required this.city,
    required this.state,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.contests,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    leagueId: json["league_id"],
    team1Id: json["team_1_id"],
    team2Id: json["team_2_id"],
    matchName: json["match_name"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    venue: json["venue"],  // Nullable
    city: json["city"],
    state: json["state"],
    country: json["country"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    contests: List<Contest>.from(json["contests"].map((x) => Contest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "league_id": leagueId,
    "team_1_id": team1Id,
    "team_2_id": team2Id,
    "match_name": matchName,
    "date": date.toIso8601String(),
    "time": time,
    "venue": venue,  // Nullable
    "city": city,
    "state": state,
    "country": country,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "contests": List<dynamic>.from(contests.map((x) => x.toJson())),
  };
}

class Contest {
  String id;
  String matchId;
  String contestTypeId;
  num pricePool;
  int entryFees;
  int totalParticipant;
  int maxTeamPerUser;
  dynamic profit;
  DateTime dateTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  ContestType contestType;
  int joinedTeamCount;
  int remainingSpots;
  List<WinningRange> maxWinning;
  List<WinningRange> currWinnings;

  Contest({
    required this.id,
    required this.matchId,
    required this.contestTypeId,
    required this.pricePool,
    required this.entryFees,
    required this.totalParticipant,
    required this.maxTeamPerUser,
    required this.profit,
    required this.dateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.contestType,
    required this.joinedTeamCount,
    required this.remainingSpots,
    required this.maxWinning,
    required this.currWinnings,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["_id"],
    matchId: json["match_id"],
    contestTypeId: json["contest_type_id"],
    pricePool: json["price_pool"],
    entryFees: json["entry_fees"],
    totalParticipant: json["total_participant"],
    maxTeamPerUser: json["max_team_per_user"],
    profit: json["profit"],
    dateTime: DateTime.parse(json["date_time"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    contestType: ContestType.fromJson(json["contest_type"]),
    joinedTeamCount: json["joined_team_count"],
    remainingSpots: json["remaining_spots"],
    maxWinning: json["maxWinning"] != null
        ? List<WinningRange>.from(json["maxWinning"].map((x) => WinningRange.fromJson(x)))
        : [],
    currWinnings: json["currWinnings"] != null
        ? List<WinningRange>.from(json["currWinnings"].map((x) => WinningRange.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "match_id": matchId,
    "contest_type_id": contestTypeId,
    "price_pool": pricePool,
    "entry_fees": entryFees,
    "total_participant": totalParticipant,
    "max_team_per_user": maxTeamPerUser,
    "profit": profit,
    "date_time": dateTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "contest_type": contestType.toJson(),
    "joined_team_count": joinedTeamCount,
    "remaining_spots": remainingSpots,
    // "maxWinning": List<dynamic>.from(maxWinning.map((x) => x.toJson())),
    // "currWinnings": List<dynamic>.from(currWinnings.map((x) => x.toJson())),
    "maxWinning": maxWinning != null
        ? List<dynamic>.from(maxWinning.map((x) => x.toJson()))
        : null, // Updated
    "currWinnings": currWinnings != null
        ? List<dynamic>.from(currWinnings.map((x) => x.toJson()))
        : null, // Updated
  };
}


class ContestType {
  String id;
  String contestType;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ContestType({
    required this.id,
    required this.contestType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ContestType.fromJson(Map<String, dynamic> json) => ContestType(
    id: json["_id"],
    contestType: json["contest_type"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "contest_type": contestType,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class WinningRange {
  List<int> range;
  String prize;

  WinningRange({
    required this.range,
    required this.prize,
  });

  factory WinningRange.fromJson(Map<String, dynamic> json) => WinningRange(
    range: List<int>.from(json["range"].map((x) => x)),
    prize: json["prize"],
  );

  Map<String, dynamic> toJson() => {
    "range": List<dynamic>.from(range.map((x) => x)),
    "prize": prize,
  };
}
