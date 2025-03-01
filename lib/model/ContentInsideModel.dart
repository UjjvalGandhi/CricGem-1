import 'dart:convert';

// Main ContestInsideModel
class ContestInsideModel {
  bool? success;
  String? message;
  Data? data;

  ContestInsideModel({this.success, this.message, this.data});

  factory ContestInsideModel.fromJson(Map<String, dynamic> json) =>
      ContestInsideModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

// Data class containing contest details, winnings, leaderboard, etc.
class Data {
  ContestDetails? contestDetails;
  List<Winnings>? maxWinning;
  List<Winnings>? currWinnings;
  List<Leaderboard>? leaderboard;
  int? joinedTeamsCount;
  int? remainingSpots;

  Data({
    this.contestDetails,
    this.maxWinning,
    this.currWinnings,
    this.leaderboard,
    this.joinedTeamsCount,
    this.remainingSpots,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contestDetails: json["contest_details"] != null
        ? ContestDetails.fromJson(json["contest_details"])
        : null,
    maxWinning: json["maxWinning"] != null
        ? List<Winnings>.from(
        json["maxWinning"].map((x) => Winnings.fromJson(x)))
        : [],
    currWinnings: json["currWinnings"] != null
        ? List<Winnings>.from(
        json["currWinnings"].map((x) => Winnings.fromJson(x)))
        : [],
    leaderboard: json["leaderboard"] != null
        ? List<Leaderboard>.from(
        json["leaderboard"].map((x) => Leaderboard.fromJson(x)))
        : [],
    joinedTeamsCount: json["joinedTeamsCount"],
    remainingSpots: json["remainingSpots"],
  );

  Map<String, dynamic> toJson() => {
    "contest_details": contestDetails?.toJson(),
    "maxWinning": maxWinning != null
        ? List<dynamic>.from(maxWinning!.map((x) => x.toJson()))
        : [],
    "currWinnings": currWinnings != null
        ? List<dynamic>.from(currWinnings!.map((x) => x.toJson()))
        : [],
    "leaderboard": leaderboard != null
        ? List<dynamic>.from(leaderboard!.map((x) => x.toJson()))
        : [],
    "joinedTeamsCount": joinedTeamsCount,
    "remainingSpots": remainingSpots,
  };
}

// Contest Details class
class ContestDetails {
  String? id;
  String? matchId;
  String? contestTypeId;
  int? pricePool;
  int? entryFees;
  int? totalParticipant;
  int? maxTeamPerUser ;
  int? profit;
  DateTime? dateTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? version;
  DateTime? matchDate;
  String? matchTime;

  ContestDetails({
    this.id,
    this.matchId,
    this.contestTypeId,
    this.pricePool,
    this.entryFees,
    this.totalParticipant,
    this.maxTeamPerUser ,
    this.profit,
    this.dateTime,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.matchDate,
    this.matchTime,
  });

  factory ContestDetails.fromJson(Map<String, dynamic> json) =>
      ContestDetails(
        id: json["_id"],
        matchId: json["match_id"],
        contestTypeId: json["contest_type_id"],
        pricePool: json["price_pool"],
        entryFees: json["entry_fees"],
        totalParticipant: json["total_participant"],
        maxTeamPerUser : json["max_team_per_user"],
        profit: json["profit"],
        dateTime: json["date_time"] != null
            ? DateTime.parse(json["date_time"])
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        version: json["__v"],
        matchDate: json["match_date"] != null
            ? DateTime.parse(json["match_date"])
            : null,
        matchTime: json["match_time"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "match_id": matchId,
    "contest_type_id": contestTypeId,
    "price_pool": pricePool,
    "entry_fees": entryFees,
    "total_participant": totalParticipant,
    "max_team_per_user": maxTeamPerUser ,
    "profit": profit,
    "date_time": dateTime?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": version,
    "match_date": matchDate?.toIso8601String(),
    "match_time": matchTime,
  };
}

// Winnings class
class Winnings {
  List<int>? range;
  String? prize;

  Winnings({this.range, this.prize});

  factory Winnings.fromJson(Map<String, dynamic> json) => Winnings(
    range: json["range"] != null ? List<int>.from(json["range"]) : [],
    prize: json["prize"],
  );

  Map<String, dynamic> toJson() => {
    "range": range != null ? List<dynamic>.from(range!) : [],
    "prize": prize,
  };
}

// Leaderboard class
class Leaderboard {
  Id? id;
  String? userId;
  String? contestId;
  List<String>? myTeamId;
  List<UserDetails>? userDetails;
  double? totalPoints; // Changed to double to accommodate decimal points
  int? rank;
  String? teamLabel;
  String? winningAmount;

  Leaderboard({
    this.id,
    this.userId,
    this.contestId,
    this.myTeamId,
    this.userDetails,
    this.totalPoints,
    this.rank,
    this.teamLabel,
    this.winningAmount,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
    id: json["_id"] != null ? Id.fromJson(json["_id"]) : null,
    userId: json["user_id"],
    contestId: json["contest_id"],
    myTeamId: json["myTeam_id"] != null
        ? List<String>.from(json["myTeam_id"])
        : [],
    userDetails: json["user_details"] != null
        ? List<UserDetails>.from(
        json["user_details"].map((x) => UserDetails.fromJson(x)))
        : [],
    totalPoints: json["totalPoints"]?.toDouble(), // Ensure it's a double
    rank: json["rank"],
    teamLabel : json['teamLabel'],
    winningAmount: json["winningAmount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id?.toJson(),
    "user_id": userId,
    "contest_id": contestId,
    "myTeam_id": myTeamId != null
        ? List<dynamic>.from(myTeamId!)
        : [],
    "user_details": userDetails != null
        ? List<dynamic>.from(userDetails!.map((x) => x.toJson()))
        : [],
    "totalPoints": totalPoints,
    "rank": rank,
    "teamLabel" : teamLabel,
    "winningAmount": winningAmount,
  };
  @override
  String toString() {
    return 'Leaderboard(myTeamId: $myTeamId, userDetails: $userDetails, totalPoints: $totalPoints, rank: $rank)';
  }
}

// ID class for embedded object
class Id {
  String? userId;
  String? contestId;
  String? teamId;

  Id({this.userId, this.contestId, this.teamId});

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    userId: json["user_id"],
    contestId: json["contest_id"],
    teamId: json["team_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "contest_id": contestId,
    "team_id": teamId,
  };
}

// User details class
class UserDetails {
  String? id;
  String? name;
  String? profilePhoto;

  UserDetails({this.id, this.name, this.profilePhoto});

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["_id"],
    name: json["name"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_photo": profilePhoto,
  };
}

// Utility function to parse JSON string
ContestInsideModel parseContestDetails(String jsonStr) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonStr);
  return ContestInsideModel.fromJson(jsonData);
}
//
// class ContestInsideModel {
//   final bool success;
//   final String message;
//   final ContestData data;
//
//   ContestInsideModel({required this.success, required this.message, required this.data});
//
//   factory ContestInsideModel.fromJson(Map<String, dynamic> json) {
//     return ContestInsideModel(
//       success: json['success'],
//       message: json['message'],
//       data: ContestData.fromJson(json['data']),
//     );
//   }
// }
//
// class ContestData {
//   final ContestDetails contestDetails;
//   final List<Winning> maxWinning;
//   final List<Winning> currWinnings;
//   final List<Leaderboard> leaderboard;
//   final int joinedTeamsCount;
//   final int remainingSpots;
//
//   ContestData({
//     required this.contestDetails,
//     required this.maxWinning,
//     required this.currWinnings,
//     required this.leaderboard,
//     required this.joinedTeamsCount,
//     required this.remainingSpots,
//   });
//
//   factory ContestData.fromJson(Map<String, dynamic> json) {
//     return ContestData(
//       contestDetails: ContestDetails.fromJson(json['contest_details']),
//       maxWinning: List<Winning>.from(json['maxWinning'].map((x) => Winning.fromJson(x))),
//       currWinnings: List<Winning>.from(json['currWinnings'].map((x) => Winning.fromJson(x))),
//       leaderboard: List<Leaderboard>.from(json['leaderboard'].map((x) => Leaderboard.fromJson(x))),
//       joinedTeamsCount: json['joinedTeamsCount'],
//       remainingSpots: json['remainingSpots'],
//     );
//   }
// }
//
// class ContestDetails {
//   final String id;
//   final String matchId;
//   final String contestTypeId;
//   final int pricePool;
//   final int entryFees;
//   final int totalParticipant;
//   final int maxTeamPerUser ;
//   final int profit;
//   final DateTime dateTime;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//   final DateTime matchDate;
//   final String matchTime;
//
//   ContestDetails({
//     required this.id,
//     required this.matchId,
//     required this.contestTypeId,
//     required this.pricePool,
//     required this.entryFees,
//     required this.totalParticipant,
//     required this.maxTeamPerUser ,
//     required this.profit,
//     required this.dateTime,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.matchDate,
//     required this.matchTime,
//   });
//
//   factory ContestDetails.fromJson(Map<String, dynamic> json) {
//     return ContestDetails(
//       id: json['_id'],
//       matchId: json['match_id'],
//       contestTypeId: json['contest_type_id'],
//       pricePool: json['price_pool'],
//       entryFees: json['entry_fees'],
//       totalParticipant: json['total_participant'],
//       maxTeamPerUser : json['max_team_per_user'],
//       profit: json['profit'],
//       dateTime: DateTime.parse(json['date_time']),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       v: json['__v'],
//       matchDate: DateTime.parse(json['match_date']),
//       matchTime: json['match_time'],
//     );
//   }
// }
//
// class Winning {
//   final List<int> range;
//   final String prize;
//
//   Winning({required this.range, required this.prize});
//
//   factory Winning.fromJson(Map<String, dynamic> json) {
//     return Winning(
//       range: List<int>.from(json['range']),
//       prize: json['prize'],
//     );
//   }
// }
//
// class Leaderboard {
//   final LeaderboardId id;
//   final String userId;
//   final String contestId;
//   final List<String> myTeamId;
//   final List<UserDetail> userDetails;
//   final int totalPoints;
//   final int rank;
//   final String winningAmount;
//
//   Leaderboard({
//     required this.id,
//     required this.userId,
//     required this.contestId,
//     required this.myTeamId,
//     required this.userDetails,
//     required this.totalPoints,
//     required this.rank,
//     required this.winningAmount,
//   });
//
//   factory Leaderboard.fromJson(Map<String, dynamic> json) {
//     return Leaderboard(
//       id: LeaderboardId.fromJson(json['_id']),
//       userId: json['user_id'],
//       contestId: json['contest_id'],
//       myTeamId: List<String>.from(json['myTeam_id']),
//       userDetails: List<UserDetail>.from(json['user_details'].map((x) => UserDetail.fromJson(x))),
//       totalPoints: json['totalPoints'],
//       rank: json['rank'],
//       winningAmount: json['winningAmount'],
//     );
//   }
// }
//
// class LeaderboardId {
//   final String userId;
//   final String contestId;
//   final String teamId;
//
//   LeaderboardId({required this.userId, required this.contestId, required this.teamId});
//
//   factory LeaderboardId.fromJson(Map<String, dynamic> json) {
//     return LeaderboardId(
//       userId: json['user_id'],
//       contestId: json['contest_id'],
//       teamId: json['team_id'],
//     );
//   }
// }
//
// class UserDetail {
//   final String id;
//   final String name;
//   final String profilePhoto;
//
//   UserDetail({required this.id, required this.name, required this.profilePhoto});
//
//   factory UserDetail.fromJson(Map<String, dynamic> json) {
//     return UserDetail(
//       id: json['_id'],
//       name: json['name'],
//       profilePhoto: json['profile_photo'],
//     );
//   }
// }









// import 'dart:convert';
//
// // Main ContestDetails Model
// class ContestInsideModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   ContestInsideModel({this.success, this.message, this.data});
//
//   factory ContestInsideModel.fromJson(Map<String, dynamic> json) =>
//       ContestInsideModel(
//         success: json["success"],
//         message: json["message"],
//         data: json["data"] != null ? Data.fromJson(json["data"]) : null,
//       );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "data": data?.toJson(),
//   };
// }
//
// // Data class containing contest details, winnings, leaderboard, etc.
// class Data {
//   ContestDetails? contestDetails;
//   List<Winnings>? maxWinning;
//   List<Winnings>? currWinnings;
//   List<Leaderboard>? leaderboard;
//   int? joinedTeamsCount;
//   int? remainingSpots;
//
//   Data({
//     this.contestDetails,
//     this.maxWinning,
//     this.currWinnings,
//     this.leaderboard,
//     this.joinedTeamsCount,
//     this.remainingSpots,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     contestDetails: json["contest_details"] != null
//         ? ContestDetails.fromJson(json["contest_details"])
//         : null,
//     maxWinning: json["maxWinning"] != null
//         ? List<Winnings>.from(
//         json["maxWinning"].map((x) => Winnings.fromJson(x)))
//         : [],
//     currWinnings: json["currWinnings"] != null
//         ? List<Winnings>.from(
//         json["currWinnings"].map((x) => Winnings.fromJson(x)))
//         : [],
//     leaderboard: json["leaderboard"] != null
//         ? List<Leaderboard>.from(
//         json["leaderboard"].map((x) => Leaderboard.fromJson(x)))
//         : [],
//     joinedTeamsCount: json["joinedTeamsCount"],
//     remainingSpots: json["remainingSpots"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "contest_details": contestDetails?.toJson(),
//     "maxWinning": maxWinning != null
//         ? List<dynamic>.from(maxWinning!.map((x) => x.toJson()))
//         : [],
//     "currWinnings": currWinnings != null
//         ? List<dynamic>.from(currWinnings!.map((x) => x.toJson()))
//         : [],
//     "leaderboard": leaderboard != null
//         ? List<dynamic>.from(leaderboard!.map((x) => x.toJson()))
//         : [],
//     "joinedTeamsCount": joinedTeamsCount,
//     "remainingSpots": remainingSpots,
//   };
// }
//
// // Contest Details class
// class ContestDetails {
//   String? id;
//   String? matchId;
//   String? contestTypeId;
//   num? pricePool;
//   num? entryFees;
//   num? totalParticipant;
//   int? maxTeamPerUser;
//   int? profit;
//   DateTime? dateTime;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? version;
//   DateTime? matchDate;
//   String? matchTime;
//
//   ContestDetails({
//     this.id,
//     this.matchId,
//     this.contestTypeId,
//     this.pricePool,
//     this.entryFees,
//     this.totalParticipant,
//     this.maxTeamPerUser,
//     this.profit,
//     this.dateTime,
//     this.createdAt,
//     this.updatedAt,
//     this.version,
//     this.matchDate,
//     this.matchTime,
//   });
//
//   factory ContestDetails.fromJson(Map<String, dynamic> json) =>
//       ContestDetails(
//         id: json["_id"],
//         matchId: json["match_id"],
//         contestTypeId: json["contest_type_id"],
//         pricePool: json["price_pool"],
//         entryFees: json["entry_fees"],
//         totalParticipant: json["total_participant"],
//         maxTeamPerUser: json["max_team_per_user"],
//         profit: json["profit"],
//         dateTime: json["date_time"] != null
//             ? DateTime.parse(json["date_time"])
//             : null,
//         createdAt: json["createdAt"] != null
//             ? DateTime.parse(json["createdAt"])
//             : null,
//         updatedAt: json["updatedAt"] != null
//             ? DateTime.parse(json["updatedAt"])
//             : null,
//         version: json["__v"],
//         matchDate: json["match_date"] != null
//             ? DateTime.parse(json["match_date"])
//             : null,
//         matchTime: json["match_time"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "match_id": matchId,
//     "contest_type_id": contestTypeId,
//     // "price_pool": pricePool,
//     // "entry_fees": entryFees,
//     // "total_participant": totalParticipant,
//     "price_pool": pricePool?.toInt(), // Convert to int if needed
//     "entry_fees": entryFees?.toInt(), // Convert to int if needed
//     "total_participant": totalParticipant?.toInt(), // Convert to int if needed
//     "max_team_per_user": maxTeamPerUser,
//     "profit": profit,
//     "date_time": dateTime?.toIso8601String(),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": version,
//     "match_date": matchDate?.toIso8601String(),
//     "match_time": matchTime,
//   };
// }
//
// // Winnings class
// class Winnings {
//   List<int>? range;
//   String? prize;
//
//   Winnings({this.range, this.prize});
//
//   factory Winnings.fromJson(Map<String, dynamic> json) => Winnings(
//     range: json["range"] != null ? List<int>.from(json["range"]) : [],
//     prize: json["prize"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "range": range != null ? List<dynamic>.from(range!) : [],
//     "prize": prize,
//   };
// }
//
// // Leaderboard class
// class Leaderboard {
//   Id? id;
//   String? userId;
//   String? contestId;
//   List<String>? myTeamId;
//   List<UserDetails>? userDetails;
//   int? totalPoints;
//   int? rank;
//   String? winningAmount;
//
//   Leaderboard({
//     this.id,
//     this.userId,
//     this.contestId,
//     this.myTeamId,
//     this.userDetails,
//     this.totalPoints,
//     this.rank,
//     this.winningAmount,
//   });
//
//   factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
//     id: json["_id"] != null ? Id.fromJson(json["_id"]) : null,
//     userId: json["user_id"],
//     contestId: json["contest_id"],
//     myTeamId: json["myTeam_id"] != null
//         ? List<String>.from(json["myTeam_id"])
//         : [],
//     userDetails: json["user_details"] != null
//         ? List<UserDetails>.from(
//         json["user_details"].map((x) => UserDetails.fromJson(x)))
//         : [],
//     totalPoints: json["totalPoints"],
//     rank: json["rank"],
//     winningAmount: json["winningAmount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id?.toJson(),
//     "user_id": userId,
//     "contest_id": contestId,
//     "myTeam_id": myTeamId != null
//         ? List<dynamic>.from(myTeamId!)
//         : [],
//     "user_details": userDetails != null
//         ? List<dynamic>.from(userDetails!.map((x) => x.toJson()))
//         : [],
//     "totalPoints": totalPoints,
//     "rank": rank,
//     "winningAmount": winningAmount,
//   };
// }
//
// // ID class for embedded object
// class Id {
//   String? userId;
//   String? contestId;
//   String? teamId;
//
//   Id({this.userId, this.contestId, this.teamId});
//
//   factory Id.fromJson(Map<String, dynamic> json) => Id(
//     userId: json["user_id"],
//     contestId: json["contest_id"],
//     teamId: json["team_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "contest_id": contestId,
//     "team_id": teamId,
//   };
// }
//
// // User details class
// class UserDetails {
//   String? id;
//   String? name;
//   String? profilePhoto;
//
//   UserDetails({this.id, this.name, this.profilePhoto});
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
//     id: json["_id"],
//     name: json["name"],
//     profilePhoto: json["profile_photo"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "name": name,
//     "profile_photo": profilePhoto,
//   };
// }
//
// // Utility function to parse JSON string
// ContestInsideModel parseContestDetails(String jsonStr) {
//   final Map<String, dynamic> jsonData = jsonDecode(jsonStr);
//   return ContestInsideModel.fromJson(jsonData);
// }

// // import 'dart:convert';
// //
// // // Function to convert JSON string to ContestInsideModel
// // ContestInsideModel contestInsideModelFromJson(String str) =>
// //     ContestInsideModel.fromJson(json.decode(str));
// //
// // // Function to convert ContestInsideModel to JSON string
// // String contestInsideModelToJson(ContestInsideModel data) =>
// //     json.encode(data.toJson());
// //
// // // Main model class
// // class ContestInsideModel {
// //   bool success;
// //   String message;
// //   Data data;
// //
// //   ContestInsideModel({
// //     required this.success,
// //     required this.message,
// //     required this.data,
// //   });
// //
// //   factory ContestInsideModel.fromJson(Map<String, dynamic> json) =>
// //       ContestInsideModel(
// //         success: json["success"],
// //         message: json["message"],
// //         data: Data.fromJson(json["data"]),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //     "success": success,
// //     "message": message,
// //     "data": data.toJson(),
// //   };
// // }
// //
// // // Data class to hold contest-related information
// // class Data {
// //   ContestDetails contestDetails;
// //   List<MaxWinning> maxWinning;
// //   List<CurrentWinning> currWinnings;
// //   List<Leaderboard> leaderboard;
// //   int joinedTeamsCount;
// //   int remainingSpots;
// //
// //   Data({
// //     required this.contestDetails,
// //     required this.maxWinning,
// //     required this.currWinnings,
// //     required this.leaderboard,
// //     required this.joinedTeamsCount,
// //     required this.remainingSpots,
// //   });
// //
// //   factory Data.fromJson(Map<String, dynamic> json) => Data(
// //     contestDetails: ContestDetails.fromJson(json["contest_details"]),
// //     maxWinning: List<MaxWinning>.from(
// //         json["maxWinning"].map((x) => MaxWinning.fromJson(x))),
// //     currWinnings: List<CurrentWinning>.from(
// //         json["currWinnings"].map((x) => CurrentWinning.fromJson(x))),
// //     leaderboard: List<Leaderboard>.from(
// //         json["leaderboard"].map((x) => Leaderboard.fromJson(x))),
// //     joinedTeamsCount: json["joinedTeamsCount"],
// //     remainingSpots: json["remainingSpots"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "contest_details": contestDetails.toJson(),
// //     "maxWinning": List<dynamic>.from(maxWinning.map((x) => x.toJson())),
// //     "currWinnings": List<dynamic>.from(currWinnings.map((x) => x.toJson())),
// //     "leaderboard": List<dynamic>.from(leaderboard.map((x) => x.toJson())),
// //     "joinedTeamsCount": joinedTeamsCount,
// //     "remainingSpots": remainingSpots,
// //   };
// // }
// //
// // // ContestDetails class to hold detailed information about the contest
// // class ContestDetails {
// //   String id;
// //   String matchId;
// //   String contestTypeId;
// //   int pricePool;
// //   int entryFees;
// //   int totalParticipant;
// //   int maxTeamPerUser ;
// //   int profit;
// //   DateTime dateTime;
// //   DateTime createdAt;
// //   DateTime updatedAt;
// //   int v;
// //   DateTime match_date;
// //   String match_time;
// //
// //   ContestDetails({
// //     required this.id,
// //     required this.matchId,
// //     required this.contestTypeId,
// //     required this.pricePool,
// //     required this.entryFees,
// //     required this.totalParticipant,
// //     required this.maxTeamPerUser ,
// //     required this.profit,
// //     required this.dateTime,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     required this.v,
// //     required this.match_date,
// //     required this.match_time,
// //   });
// //
// //   factory ContestDetails.fromJson(Map<String, dynamic> json) => ContestDetails(
// //     id: json["_id"],
// //     matchId: json["match_id"],
// //     contestTypeId: json["contest_type_id"],
// //     pricePool: json["price_pool"],
// //     entryFees: json["entry_fees"],
// //     totalParticipant: json["total_participant"],
// //     maxTeamPerUser: json["max_team_per_user"],
// //     profit: json["profit"],
// //     dateTime: DateTime.parse(json["date_time"]),
// //     createdAt: DateTime.parse(json["createdAt"]),
// //     updatedAt: DateTime.parse(json["updatedAt"]),
// //     v: json["__v"],
// //     match_date: DateTime.parse(json["match_date"]),
// //     match_time: json["match_time"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "_id": id,
// //     "match_id": matchId,
// //     "contest_type_id": contestTypeId,
// //     "price_pool": pricePool,
// //     "entry_fees": entryFees,
// //     "total_participant": totalParticipant,
// //     "max_team_per_user": maxTeamPerUser ,
// //     "profit": profit,
// //     "date_time": dateTime.toIso8601String(),
// //     "createdAt": createdAt.toIso8601String(),
// //     "updatedAt": updatedAt.toIso8601String(),
// //     "__v": v,
// //     "match_date": match_date.toIso8601String(),
// //     "match_time": match_time,
// //   };
// // }
// //
// // // CurrentWinning class to hold current winnings information
// // class CurrentWinning {
// //   List<int> range;
// //   String prize; // Changed to String to match API response
// //
// //   CurrentWinning({
// //     required this.range,
// //     required this.prize,
// //   });
// //
// //   factory CurrentWinning.fromJson(Map<String, dynamic> json) => CurrentWinning(
// //     range: List<int>.from(json["range"].map((x) => x)),
// //     prize: json["prize"], // Keep as String
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "range": List<dynamic>.from(range.map((x) => x)),
// //     "prize": prize,
// //   };
// // }
// //
// // // Leaderboard class to hold leaderboard information
// // class Leaderboard {
// //   String id;
// //   String userId;
// //   String contestId;
// //   List<String> myTeamId;
// //   List<UserDetail> userDetails;
// //   int totalPoints; // Added totalPoints
// //   int rank; // Added rank
// //   String winningAmount; // Added winningAmount
// //
// //   Leaderboard({
// //     required this.id,
// //     required this.userId,
// //     required this.contestId,
// //     required this.myTeamId,
// //     required this.userDetails,
// //     required this.totalPoints,
// //     required this.rank,
// //     required this.winningAmount, // Include winningAmount
// //   });
// //
// //   factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
// //     id: json["_id"],
// //     userId: json["user_id"],
// //     contestId: json["contest_id"],
// //     myTeamId: List<String>.from(json["myTeam_id"].map((x) => x)),
// //     totalPoints: json['totalPoints'],
// //     rank: json['rank'],
// //     winningAmount: json['winningAmount']?? "0", // Include winningAmount
// //     userDetails: List<UserDetail>.from(
// //         json["user_details"].map((x) => UserDetail.fromJson(x))),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "_id": id,
// //     "user_id": userId,
// //     "contest_id": contestId,
// //     "myTeam_id": List<dynamic>.from(myTeamId.map((x) => x)),
// //     "user_details": List<dynamic>.from(userDetails.map((x) => x.toJson())),
// //     "totalPoints": totalPoints,
// //     "rank": rank,
// //     "winningAmount": winningAmount, // Include winningAmount
// //   };
// // }
// //
// // // UserDetail class to hold information about users
// // class UserDetail {
// //   String id;
// //   String name;
// //   String profilePhoto;
// //
// //   UserDetail({
// //     required this.id,
// //     required this.name,
// //     required this.profilePhoto,
// //   });
// //
// //   factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
// //     id: json["_id"],
// //     name: json["name"],
// //     profilePhoto: json["profile_photo"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "_id": id,
// //     "name": name,
// //     "profile_photo": profilePhoto,
// //   };
// // }
//
// // MaxWinning class to hold maximum winning information
// class MaxWinning {
//   List<int> range;
//   String prize;
//
//   MaxWinning({
//     required this.range,
//     required this.prize,
//   });
//
//   factory MaxWinning.fromJson(Map<String, dynamic> json) => MaxWinning(
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
// // import 'dart:convert';
// //
// // // Function to convert JSON string to ContestInsideModel
// // ContestInsideModel contestInsideModelFromJson(String str) =>
// //     ContestInsideModel.fromJson(json.decode(str));
// //
// // // Function to convert ContestInsideModel to JSON string
// // String contestInsideModelToJson(ContestInsideModel data) =>
// //     json.encode(data.toJson());
// //
// // // Main model class
// // class ContestInsideModel {
// //   bool success;
// //   String message;
// //   Data data;
// //
// //   ContestInsideModel({
// //     required this.success,
// //     required this.message,
// //     required this.data,
// //   });
// //
// //   factory ContestInsideModel.fromJson(Map<String, dynamic> json) =>
// //       ContestInsideModel(
// //         success: json["success"],
// //         message: json["message"],
// //         data: Data.fromJson(json["data"]),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "success": success,
// //         "message": message,
// //         "data": data.toJson(),
// //       };
// // }
// //
// // // Data class to hold contest-related information
// // class Data {
// //   ContestDetails contestDetails;
// //   List<MaxWinning> maxWinning;
// //   List<CurrentWinning> currWinnings;
// //   List<Leaderboard> leaderboard;
// //   int joinedTeamsCount;
// //   int remainingSpots;
// //
// //   Data({
// //     required this.contestDetails,
// //     required this.maxWinning,
// //     required this.currWinnings,
// //     required this.leaderboard,
// //     required this.joinedTeamsCount,
// //     required this.remainingSpots,
// //   });
// //
// //   factory Data.fromJson(Map<String, dynamic> json) => Data(
// //         contestDetails: ContestDetails.fromJson(json["contest_details"]),
// //         maxWinning: List<MaxWinning>.from(
// //             json["maxWinning"].map((x) => MaxWinning.fromJson(x))),
// //         currWinnings: List<CurrentWinning>.from(
// //             json["currWinnings"].map((x) => CurrentWinning.fromJson(x))),
// //         leaderboard: List<Leaderboard>.from(
// //             json["leaderboard"].map((x) => Leaderboard.fromJson(x))),
// //         joinedTeamsCount: json["joinedTeamsCount"],
// //         remainingSpots: json["remainingSpots"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "contest_details": contestDetails.toJson(),
// //         "maxWinning": List<dynamic>.from(maxWinning.map((x) => x.toJson())),
// //         "currWinnings": List<dynamic>.from(currWinnings.map((x) => x.toJson())),
// //         "leaderboard": List<dynamic>.from(leaderboard.map((x) => x.toJson())),
// //         "joinedTeamsCount": joinedTeamsCount,
// //         "remainingSpots": remainingSpots,
// //       };
// // }
// //
// // // ContestDetails class to hold detailed information about the contest
// // class ContestDetails {
// //   String id;
// //   String matchId;
// //   String contestTypeId;
// //   int pricePool;
// //   int entryFees;
// //   int totalParticipant;
// //   int maxTeamPerUser;
// //   int profit;
// //   DateTime dateTime;
// //   DateTime createdAt;
// //   DateTime updatedAt;
// //   int v;
// //   DateTime match_date;
// //   String match_time;
// //
// //   ContestDetails(
// //       {required this.id,
// //       required this.matchId,
// //       required this.contestTypeId,
// //       required this.pricePool,
// //       required this.entryFees,
// //       required this.totalParticipant,
// //       required this.maxTeamPerUser,
// //       required this.profit,
// //       required this.dateTime,
// //       required this.createdAt,
// //       required this.updatedAt,
// //       required this.v,
// //       required this.match_date,
// //       required this.match_time});
// //
// //   factory ContestDetails.fromJson(Map<String, dynamic> json) => ContestDetails(
// //         id: json["_id"],
// //         matchId: json["match_id"],
// //         contestTypeId: json["contest_type_id"],
// //         pricePool: json["price_pool"],
// //         entryFees: json["entry_fees"],
// //         totalParticipant: json["total_participant"],
// //         maxTeamPerUser: json["max_team_per_user"],
// //         profit: json["profit"],
// //         dateTime: DateTime.parse(json["date_time"]),
// //         createdAt: DateTime.parse(json["createdAt"]),
// //         updatedAt: DateTime.parse(json["updatedAt"]),
// //         v: json["__v"],
// //         match_date: DateTime.parse(json["match_date"]),
// //         match_time: json["match_time"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "_id": id,
// //         "match_id": matchId,
// //         "contest_type_id": contestTypeId,
// //         "price_pool": pricePool,
// //         "entry_fees": entryFees,
// //         "total_participant": totalParticipant,
// //         "max_team_per_user": maxTeamPerUser,
// //         "profit": profit,
// //         "date_time": dateTime.toIso8601String(),
// //         "createdAt": createdAt.toIso8601String(),
// //         "updatedAt": updatedAt.toIso8601String(),
// //         "__v": v,
// //         "match_date": match_date.toIso8601String(),
// //         "match_time": match_time
// //       };
// // }
// //
// // // CurrentWinning class to hold current winnings information
// // class CurrentWinning {
// //   List<int> range;
// //   double prize;
// //
// //   CurrentWinning({
// //     required this.range,
// //     required this.prize,
// //   });
// //
// //   factory CurrentWinning.fromJson(Map<String, dynamic> json) => CurrentWinning(
// //         range: List<int>.from(json["range"].map((x) => x)),
// //         prize: json["prize"] is String
// //             ? double.parse(json["prize"])
// //             : json["prize"]?.toDouble(),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "range": List<dynamic>.from(range.map((x) => x)),
// //         "prize": prize,
// //       };
// // }
// //
// // // Leaderboard class to hold leaderboard information
// // class Leaderboard {
// //   String id;
// //   String userId;
// //   String contestId;
// //   List<String> myTeamId;
// //   List<UserDetail> userDetails;
// //   final int totalPoints;
// //   final int rank;
// //
// //   Leaderboard({
// //     required this.id,
// //     required this.userId,
// //     required this.contestId,
// //     required this.myTeamId,
// //     required this.userDetails,
// //     required this.totalPoints,
// //     required this.rank,
// //   });
// //
// //   factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
// //         id: json["_id"],
// //         userId: json["user_id"],
// //         contestId: json["contest_id"],
// //         myTeamId: List<String>.from(json["myTeam_id"].map((x) => x)),
// //     totalPoints: json['totalPoints'],
// //     rank: json['rank'],
// //         userDetails: List<UserDetail>.from(
// //             json["user_details"].map((x) => UserDetail.fromJson(x))),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "_id": id,
// //         "user_id": userId,
// //         "contest_id": contestId,
// //         "myTeam_id": List<dynamic>.from(myTeamId.map((x) => x)),
// //         "user_details": List<dynamic>.from(userDetails.map((x) => x.toJson())),
// //       };
// // }
// //
// // // UserDetail class to hold information about users
// // class UserDetail {
// //   String id;
// //   String name;
// //   String profilePhoto;
// //
// //   UserDetail({
// //     required this.id,
// //     required this.name,
// //     required this.profilePhoto,
// //   });
// //
// //   factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
// //         id: json["_id"],
// //         name: json["name"],
// //         profilePhoto: json["profile_photo"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "_id": id,
// //         "name": name,
// //         "profile_photo": profilePhoto,
// //       };
// // }
// //
// // // MaxWinning class to hold maximum winning information
// // class MaxWinning {
// //   List<int> range;
// //   String prize;
// //
// //   MaxWinning({
// //     required this.range,
// //     required this.prize,
// //   });
// //
// //   factory MaxWinning.fromJson(Map<String, dynamic> json) => MaxWinning(
// //         range: List<int>.from(json["range"].map((x) => x)),
// //         prize: json["prize"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "range": List<dynamic>.from(range.map((x) => x)),
// //         "prize": prize,
// //       };
// // }
