
// Main model class
class PlayerModel {
  bool success;
  String message;
  List<Datum> data;

  PlayerModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: json["data"] != null
        ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// Match data class
class Datum {
  String id;
  String matchName;
  DateTime date;
  String time;
  String venue;  // Fixed typo from 'vanue' to 'venue'
  String city;
  String state;
  String country;
  TeamDetails team1Details;
  TeamDetails team2Details;
  List<ClassifiedPlayer> classifiedPlayers;

  Datum({
    required this.id,
    required this.matchName,
    required this.date,
    required this.time,
    required this.venue,
    required this.city,
    required this.state,
    required this.country,
    required this.team1Details,
    required this.team2Details,
    required this.classifiedPlayers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"] ?? '',
    matchName: json["match_name"] ?? '',
    date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
    time: json["time"] ?? '',
    venue: json["vanue"] ?? '',  // Keep as 'vanue' to match JSON
    city: json["city"] ?? '',
    state: json["state"] ?? '',
    country: json["country"] ?? '',
    team1Details: json["team1Details"] != null
        ? TeamDetails.fromJson(json["team1Details"])
        : TeamDetails.empty(),
    team2Details: json["team2Details"] != null
        ? TeamDetails.fromJson(json["team2Details"])
        : TeamDetails.empty(),
    classifiedPlayers: json["classifiedPlayers"] != null
        ? List<ClassifiedPlayer>.from(json["classifiedPlayers"].map((x) => ClassifiedPlayer.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "match_name": matchName,
    "date": date.toIso8601String(),
    "time": time,
    "vanue": venue,
    "city": city,
    "state": state,
    "country": country,
    "team1Details": team1Details.toJson(),
    "team2Details": team2Details.toJson(),
    "classifiedPlayers": List<dynamic>.from(classifiedPlayers.map((x) => x.toJson())),
  };
}

// Classified player class
class ClassifiedPlayer {
  List<Player> players;
  String role;

  ClassifiedPlayer({
    required this.players,
    required this.role,
  });

  factory ClassifiedPlayer.fromJson(Map<String, dynamic> json) => ClassifiedPlayer(
    players: json["players"] != null
        ? List<Player>.from(json["players"].map((x) => Player.fromJson(x, json["role"])))
        : [],
    role: json["role"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "players": List<dynamic>.from(players.map((x) => x.toJson())),
    "role": role,
  };
}

// Player class
class Player {
  String id;
  String playerName;
  String playerPhoto;
  int age;
  String nationality;
  DateTime birthDate;
  String batType;
  String bowlType;
  String status;
  String teamId;
  String teamName;
  String teamShortName;
  int totalPoints;
  String credit;  // Fixed typo from 'creadit' to 'credit'
  String? role;   // Optional field for player role

  Player({
    required this.id,
    required this.playerName,
    required this.playerPhoto,
    required this.age,
    required this.nationality,
    required this.birthDate,
    required this.batType,
    required this.bowlType,
    required this.status,
    required this.teamId,
    required this.teamName,
    required this.teamShortName,
    required this.totalPoints,
    required this.credit,
    this.role,
  });

  factory Player.fromJson(Map<String, dynamic> json, String playerRole) => Player(
    id: json["_id"] ?? '',
    playerName: json["player_name"] ?? '',
    playerPhoto: json["player_photo"] ?? '',
    age: json["age"] ?? 0,
    nationality: json["nationality"] ?? '',
    birthDate: json["birth_date"] != null
        ? DateTime.parse(json["birth_date"])
        : DateTime.now(),
    batType: json["bat_type"] ?? '',
    bowlType: json["bowl_type"] ?? '',
    status: json["status"] ?? '',
    teamId: json["team_id"] ?? '',
    teamName: json["team_name"] ?? '',
    totalPoints: json["totalPoints"] ?? 0,
    teamShortName: json["team_short_name"] ?? '',
    credit: json["credit"] ?? '0.0',
    role: playerRole,  // Assign the role directly from the classified player
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "player_name": playerName,
    "player_photo": playerPhoto,
    "age": age,
    "nationality": nationality,
    "birth_date": birthDate.toIso8601String(),
    "bat_type": batType,
    "bowl_type": bowlType,
    "status": status,
    "team_id": teamId,
    "team_name": teamName,
    "team_short_name": teamShortName,
    "totalPoints": totalPoints,
    "credit": credit,
    "role": role,  // Optional field for role
  };
}

// Team details class
class TeamDetails {
  String id;
  String teamName;
  String teamLogo;
  String teamShortName;

  TeamDetails({
    required this.id,
    required this.teamName,
    required this.teamLogo,
    required this.teamShortName,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
    id: json["_id"] ?? '',
    teamName: json["team_name"] ?? '',
    teamLogo: json["team_logo"] ?? '',
    teamShortName: json["team_short_name"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "team_name": teamName,
    "team_logo": teamLogo,
    "team_short_name": teamShortName,
  };

  static TeamDetails empty() => TeamDetails(
    id: '',
    teamName: '',
    teamLogo: '',
    teamShortName: '',
  );
}
// import 'dart:convert';
//
// // Main model class
// class PlayerModel {
//   bool success;
//   String message;
//   List<Datum> data;
//
//   PlayerModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
//     success: json["success"] ?? false,
//     message: json["message"] ?? '',
//     data: json["data"] != null
//         ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
//         : [],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// // Match data class
// class Datum {
//   String id;
//   String matchName;
//   DateTime date;
//   String time;
//   String venue;  // Fixed typo from 'vanue' to 'venue'
//   String city;
//   String state;
//   String country;
//   TeamDetails team1Details;
//   TeamDetails team2Details;
//   List<ClassifiedPlayer> classifiedPlayers;
//
//   Datum({
//     required this.id,
//     required this.matchName,
//     required this.date,
//     required this.time,
//     required this.venue,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.team1Details,
//     required this.team2Details,
//     required this.classifiedPlayers,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["_id"] ?? '',
//     matchName: json["match_name"] ?? '',
//     date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
//     time: json["time"] ?? '',
//     venue: json["vanue"] ?? '',  // Keep as 'vanue' to match JSON, consider renaming in the source if possible
//     city: json["city"] ?? '',
//     state: json["state"] ?? '',
//     country: json["country"] ?? '',
//     team1Details: json["team1Details"] != null
//         ? TeamDetails.fromJson(json["team1Details"])
//         : TeamDetails.empty(),
//     team2Details: json["team2Details"] != null
//         ? TeamDetails.fromJson(json["team2Details"])
//         : TeamDetails.empty(),
//     classifiedPlayers: json["classifiedPlayers"] != null
//         ? List<ClassifiedPlayer>.from(json["classifiedPlayers"].map((x) => ClassifiedPlayer.fromJson(x)))
//         : [],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "match_name": matchName,
//     "date": date.toIso8601String(),
//     "time": time,
//     "vanue": venue,
//     "city": city,
//     "state": state,
//     "country": country,
//     "team1Details": team1Details.toJson(),
//     "team2Details": team2Details.toJson(),
//     "classifiedPlayers": List<dynamic>.from(classifiedPlayers.map((x) => x.toJson())),
//   };
// }
//
// // Classified player class
// class ClassifiedPlayer {
//   List<Player> players;
//   String role;
//
//   ClassifiedPlayer({
//     required this.players,
//     required this.role,
//   });
//
//   factory ClassifiedPlayer.fromJson(Map<String, dynamic> json) => ClassifiedPlayer(
//     players: json["players"] != null
//         ? List<Player>.from(json["players"].map((x) => Player.fromJson(x)))
//         : [],
//     role: json["role"] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     "players": List<dynamic>.from(players.map((x) => x.toJson())),
//     "role": role,
//   };
// }
//
// // Player class
// class Player {
//   String id;
//   String playerName;
//   String playerPhoto;
//   int age;
//   String nationality;
//   DateTime birthDate;
//   String batType;
//   String bowlType;
//   String status;
//   String teamId;
//   String teamName;
//   String teamShortName;
//   int totalPoints;
//   String credit;  // Fixed typo from 'creadit' to 'credit'
//   String? role;   // Optional field for player role
//
//   Player({
//     required this.id,
//     required this.playerName,
//     required this.playerPhoto,
//     required this.age,
//     required this.nationality,
//     required this.birthDate,
//     required this.batType,
//     required this.bowlType,
//     required this.status,
//     required this.teamId,
//     required this.teamName,
//     required this.teamShortName,
//     required this.totalPoints,
//     required this.credit,
//     this.role,
//   });
//
//   factory Player.fromJson(Map<String, dynamic> json) => Player(
//     id: json["_id"] ?? '',
//     playerName: json["player_name"] ?? '',
//     playerPhoto: json["player_photo"] ?? '',
//     age: json["age"] ?? 0,
//     nationality: json["nationality"] ?? '',
//     birthDate: json["birth_date"] != null
//         ? DateTime.parse(json["birth_date"])
//         : DateTime.now(),
//     batType: json["bat_type"] ?? '',
//     bowlType: json["bowl_type"] ?? '',
//     status: json["status"] ?? '',
//     teamId: json["team_id"] ?? '',
//     teamName: json["team_name"] ?? '',
//     totalPoints: json["totalPoints"] ?? 0,
//     teamShortName: json["team_short_name"] ?? '',
//     credit: json["credit"] ?? '0.0',
//     role: json["role"],  // Optional field for role
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "player_name": playerName,
//     "player_photo": playerPhoto,
//     "age": age,
//     "nationality": nationality,
//     "birth_date": birthDate.toIso8601String(),
//     "bat_type": batType,
//     "bowl_type": bowlType,
//     "status": status,
//     "team_id": teamId,
//     "team_name": teamName,
//     "team_short_name": teamShortName,
//     "totalPoints": totalPoints,
//     "credit": credit,
//     "role": role,  // Optional field for role
//   };
// }
//
// // Team details class
// class TeamDetails {
//   String id;
//   String teamName;
//   String teamLogo;
//   String teamShortName;
//
//   TeamDetails({
//     required this.id,
//     required this.teamName,
//     required this.teamLogo,
//     required this.teamShortName,
//   });
//
//   factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
//     id: json["_id"] ?? '',
//     teamName: json["team_name"] ?? '',
//     teamLogo: json["team_logo"] ?? '',
//     teamShortName: json["team_short_name"] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "team_name": teamName,
//     "team_logo": teamLogo,
//     "team_short_name": teamShortName,
//   };
//
//   static TeamDetails empty() => TeamDetails(
//     id: '',
//     teamName: '',
//     teamLogo: '',
//     teamShortName: '',
//   );
// }
