// import 'dart:convert';
//
// // Function to parse JSON data to JoinContestModel
// JoinContestModel joinContestModelFromJson(String str) => JoinContestModel.fromJson(json.decode(str));
//
// // Function to convert JoinContestModel to JSON string
// String joinContestModelToJson(JoinContestModel data) => json.encode(data.toJson());
//
// class JoinContestModel {
//   bool success;
//   String message;
//   List<Datum> data;
//
//   JoinContestModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory JoinContestModel.fromJson(Map<String, dynamic> json) => JoinContestModel(
//     success: json["success"],
//     message: json["message"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   String id;
//   String userId;
//   List<String> myTeamId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   ContestDetails contestDetails;
//   List<MyTeam> myTeams;
//   int joinedTeamCount; // Added field
//   int remainingSpots;  // Added field
//
//   Datum({
//     required this.id,
//     required this.userId,
//     required this.myTeamId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.contestDetails,
//     required this.myTeams,
//     required this.joinedTeamCount,  // Added field
//     required this.remainingSpots,   // Added field
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["_id"],
//     userId: json["user_id"],
//     myTeamId: List<String>.from(json["myTeam_id"].map((x) => x)),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     contestDetails: ContestDetails.fromJson(json["contest_details"]),
//     myTeams: List<MyTeam>.from(json["myTeams"].map((x) => MyTeam.fromJson(x))),
//     joinedTeamCount: json["joined_team_count"],  // Added field
//     remainingSpots: json["remaining_spots"],       // Added field
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user_id": userId,
//     "myTeam_id": List<dynamic>.from(myTeamId.map((x) => x)),
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "contest_details": contestDetails.toJson(),
//     "myTeams": List<dynamic>.from(myTeams.map((x) => x.toJson())),
//     "joined_team_count": joinedTeamCount,  // Added field
//     "remaining_spots": remainingSpots,     // Added field
//   };
// }
//
// class ContestDetails {
//   String id;
//   String matchId;
//   String contestTypeId;
//   int pricePool;
//   int entryFees;
//   int totalParticipant;
//   int maxTeamPerUser;
//   int profit;
//   DateTime dateTime;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   List<WinningRange>? maxWinning; // Changed to nullable
//   List<WinningRange>? currWinnings; // Changed to nullable
//
//   ContestDetails({
//     required this.id,
//     required this.matchId,
//     required this.contestTypeId,
//     required this.pricePool,
//     required this.entryFees,
//     required this.totalParticipant,
//     required this.maxTeamPerUser,
//     required this.profit,
//     required this.dateTime,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     this.maxWinning, // Updated
//     this.currWinnings, // Updated
//   });
//
//   factory ContestDetails.fromJson(Map<String, dynamic> json) => ContestDetails(
//     id: json["_id"],
//     matchId: json["match_id"],
//     contestTypeId: json["contest_type_id"],
//     pricePool: json["price_pool"],
//     entryFees: json["entry_fees"],
//     totalParticipant: json["total_participant"],
//     maxTeamPerUser: json["max_team_per_user"],
//     profit: json["profit"],
//     dateTime: DateTime.parse(json["date_time"]),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     maxWinning: json["maxWinning"] != null
//         ? List<WinningRange>.from(json["maxWinning"].map((x) => WinningRange.fromJson(x)))
//         : null, // Updated
//     currWinnings: json["currWinnings"] != null
//         ? List<WinningRange>.from(json["currWinnings"].map((x) => WinningRange.fromJson(x)))
//         : null, // Updated
//     // maxWinning: List<WinningRange>.from(json["maxWinning"].map((x) => WinningRange.fromJson(x))),
//     // currWinnings: List<WinningRange>.from(json["currWinnings"].map((x) => WinningRange.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "match_id": matchId,
//     "contest_type_id": contestTypeId,
//     "price_pool": pricePool,
//     "entry_fees": entryFees,
//     "total_participant": totalParticipant,
//     "max_team_per_user": maxTeamPerUser,
//     "profit": profit,
//     "date_time": dateTime.toIso8601String(),
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "maxWinning": maxWinning != null
//         ? List<dynamic>.from(maxWinning!.map((x) => x.toJson()))
//         : null, // Updated
//     "currWinnings": currWinnings != null
//         ? List<dynamic>.from(currWinnings!.map((x) => x.toJson()))
//         : null, // Updated
//     // "maxWinning": List<dynamic>.from(maxWinning.map((x) => x.toJson())),
//     // "currWinnings": List<dynamic>.from(currWinnings.map((x) => x.toJson())),
//   };
// }
//
//
// // class WinningRange {
// //   List<int> range;
// //   String prize;
// //
// //   WinningRange({
// //     required this.range,
// //     required this.prize,
// //   });
// //
// //   factory WinningRange.fromJson(Map<String, dynamic> json) => WinningRange(
// //     range: List<int>.from(json["range"].map((x) => x)),
// //     prize: json["prize"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "range": List<dynamic>.from(range.map((x) => x)),
// //     "prize": prize,
// //   };
// // }
//
// class WinningRange {
//   List<int> range;
//   String prize;
//
//   WinningRange({
//     required this.range,
//     required this.prize,
//   });
//
//   factory WinningRange.fromJson(Map<String, dynamic> json) => WinningRange(
//     range: List<int>.from(json["range"].map((x) => x)),
//     prize: json["prize"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "range": List<dynamic>.from(range.map((x) => x)),
//     "prize": prize,
//   };
// }
//
//
// class MyTeam {
//   String id;
//   String matchId;
//   String userId;
//   List<String> players;
//   String captain;
//   String vicecaptain;
//   DateTime dateTime;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//
//   MyTeam({
//     required this.id,
//     required this.matchId,
//     required this.userId,
//     required this.players,
//     required this.captain,
//     required this.vicecaptain,
//     required this.dateTime,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory MyTeam.fromJson(Map<String, dynamic> json) => MyTeam(
//     id: json["_id"],
//     matchId: json["match_id"],
//     userId: json["user_id"],
//     players: List<String>.from(json["players"].map((x) => x)),
//     captain: json["captain"],
//     vicecaptain: json["vicecaptain"],
//     dateTime: DateTime.parse(json["date_time"]),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "match_id": matchId,
//     "user_id": userId,
//     "players": List<dynamic>.from(players.map((x) => x)),
//     "captain": captain,
//     "vicecaptain": vicecaptain,
//     "date_time": dateTime.toIso8601String(),
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//   };
// }

import 'dart:convert';

// Function to parse JSON data to JoinContestModel
JoinContestModel joinContestModelFromJson(String str) => JoinContestModel.fromJson(json.decode(str));

// Function to convert JoinContestModel to JSON string
String joinContestModelToJson(JoinContestModel data) => json.encode(data.toJson());

class JoinContestModel {
  bool success;
  String message;
  List<Datum> data;

  JoinContestModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JoinContestModel.fromJson(Map<String, dynamic> json) => JoinContestModel(
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
  String userId;
  List<String> myTeamId;
  DateTime createdAt;
  DateTime updatedAt;
  ContestDetails contestDetails;
  List<MyTeam> myTeams;
  int joinedTeamCount;
  int remainingSpots;
  List<WinningRange> maxWinning;
  List<WinningRange> currWinnings;

  Datum({
    required this.id,
    required this.userId,
    required this.myTeamId,
    required this.createdAt,
    required this.updatedAt,
    required this.contestDetails,
    required this.myTeams,
    required this.joinedTeamCount,
    required this.remainingSpots,
    required this.maxWinning,
    required this.currWinnings
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    userId: json["user_id"],
    myTeamId: List<String>.from(json["myTeam_id"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    contestDetails: ContestDetails.fromJson(json["contest_details"]),
    myTeams: List<MyTeam>.from(json["myTeams"].map((x) => MyTeam.fromJson(x))),
    joinedTeamCount: json["joined_team_count"],
    remainingSpots: json["remaining_spots"],
    // maxWinning: List<WinningRange>.from(json["maxWinning"].map((x) => WinningRange.fromJson(x))),
    // currWinnings: List<WinningRange>.from(json["currWinnings"].map((x) => WinningRange.fromJson(x))),
    maxWinning: json["maxWinning"] != null
        ? List<WinningRange>.from(json["maxWinning"].map((x) => WinningRange.fromJson(x)))
        : [],
    currWinnings: json["currWinnings"] != null
        ? List<WinningRange>.from(json["currWinnings"].map((x) => WinningRange.fromJson(x)))
        : [],

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "myTeam_id": List<dynamic>.from(myTeamId.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "contest_details": contestDetails.toJson(),
    "myTeams": List<dynamic>.from(myTeams.map((x) => x.toJson())),
    "joined_team_count": joinedTeamCount,
    "remaining_spots": remainingSpots,
    // "maxWinning": List<dynamic>.from(maxWinning.map((x) => x.toJson())),
    // "currWinnings": List<dynamic>.from(currWinnings.map((x) => x.toJson())),
    "maxWinning": maxWinning != null
        ? List<dynamic>.from(maxWinning.map((x) => x.toJson()))
        : null, // Updated
    "currWinnings": currWinnings != null
        ? List<dynamic>.from(currWinnings.map((x) => x.toJson()))
        : null,
  };
}

class ContestDetails {
  String id;
  String matchId;
  String contestTypeId;
  int pricePool;
  int entryFees;
  int totalParticipant;
  int maxTeamPerUser;
  int profit;
  DateTime dateTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  DateTime match_date;
  String match_time;


  ContestDetails({
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
    required this.match_date,
    required this.match_time,
  });

  factory ContestDetails.fromJson(Map<String, dynamic> json) => ContestDetails(
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
    match_date: DateTime.parse(json["match_date"]),
    match_time: json["match_time"],


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
    "match_date": match_date.toIso8601String(),
    "match_time": match_time,
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

class MyTeam {
  String id;
  String matchId;
  String userId;
  List<String> players;
  String captain;
  String vicecaptain;
  DateTime dateTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  MyTeam({
    required this.id,
    required this.matchId,
    required this.userId,
    required this.players,
    required this.captain,
    required this.vicecaptain,
    required this.dateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MyTeam.fromJson(Map<String, dynamic> json) => MyTeam(
    id: json["_id"],
    matchId: json["match_id"],
    userId: json["user_id"],
    players: List<String>.from(json["players"].map((x) => x)),
    captain: json["captain"],
    vicecaptain: json["vicecaptain"],
    dateTime: DateTime.parse(json["date_time"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "match_id": matchId,
    "user_id": userId,
    "players": List<dynamic>.from(players.map((x) => x)),
    "captain": captain,
    "vicecaptain": vicecaptain,
    "date_time": dateTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
