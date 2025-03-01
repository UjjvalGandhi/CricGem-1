class MyTeamLIstModel {
  bool success;
  String message;
  List<Datum> data;

  MyTeamLIstModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MyTeamLIstModel.fromJson(Map<String, dynamic> json) {
    return MyTeamLIstModel(
      success: json["success"],
      message: json["message"],
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Datum {
  String id;
  DateTime match_date;
  String? match_time;
  String? team1Logo;
  String? team2Logo;
  String? team_label;
  int batsman;
  int allrounder;
  int wicketkeeper;
  int bowler;
  Captain? captain;
  Captain? vicecaptain;

  Datum({
    required this.id,
    required this.match_date,
    required this.match_time,
    required this.team1Logo,
    required this.team2Logo,
    required this.batsman,
    required this.allrounder,
    required this.wicketkeeper,
    required this.bowler,
    this.team_label,
    this.captain,
    this.vicecaptain,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"],
      match_date: DateTime.parse(json['match_date']),
      match_time: json['match_time'],
      team1Logo: json["team1_logo"],
      team2Logo: json["team2_logo"],
      batsman: json["batsman"],
      team_label: json['team_label'],
      allrounder: json["allrounder"],
      wicketkeeper: json["wicketkeeper"],
      bowler: json["bowler"],
      captain: json["captain"] == null ? null : Captain.fromJson(json["captain"]),
      vicecaptain: json["vicecaptain"] == null ? null : Captain.fromJson(json["vicecaptain"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "match_date": match_date,
      "match_time": match_time,
      "team1Logo": team1Logo,
      "team2Logo": team2Logo,
      "batsman": batsman,
      "team_label":team_label,
      "allrounder": allrounder,
      "wicketkeeper": wicketkeeper,
      "bowler": bowler,
      "captain": captain?.toJson(),
      "vicecaptain": vicecaptain?.toJson(),
    };
  }
}

class Captain {
  String id;
  String playerName;
  String playerPhoto;
  int age;
  String nationality;
  DateTime birthDate;
  String role;
  String batType;
  String bowlType;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Captain({
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

  factory Captain.fromJson(Map<String, dynamic> json) {
    return Captain(
      id: json["_id"],
      playerName: json["player_name"],
      playerPhoto: json["player_photo"],
      age: json["age"],
      nationality: json["nationality"],
      birthDate: DateTime.parse(json["birth_date"]),
      role: json["role"],
      batType: json["bat_type"],
      bowlType: json["bowl_type"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "player_name": playerName,
      "player_photo": playerPhoto,
      "age": age,
      "nationality": nationality,
      "birth_date": birthDate.toIso8601String(),
      "role": role,
      "bat_type": batType,
      "bowl_type": bowlType,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": v,
    };
  }
}
