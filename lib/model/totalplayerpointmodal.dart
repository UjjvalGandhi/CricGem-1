
class PointsResponse {
  final bool success;
  final String message;
  final List<TeamData> data;

  PointsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PointsResponse.fromJson(Map<String, dynamic> json) {
    return PointsResponse(
      success: json['success'],
      message: json['message'],
      data: List<TeamData>.from(json['data'].map((x) => TeamData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class TeamData {
  final String id;
  final List<PlayerPoints> players;
  final num totalPoints;
  final String teamId;

  TeamData({
    required this.id,
    required this.players,
    required this.totalPoints,
    required this.teamId,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      id: json['_id'],
      players: List<PlayerPoints>.from(json['players'].map((x) => PlayerPoints.fromJson(x))),
      totalPoints: json['totalPoints'],
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'players': players.map((x) => x.toJson()).toList(),
      'totalPoints': totalPoints,
      'teamId': teamId,
    };
  }
}

class PlayerPoints {
  final String playerId;
  final String playerName;
  final String playerRole;
  final String captainViceCaptain;
  final num points;

  PlayerPoints({
    required this.playerId,
    required this.playerName,
    required this.playerRole,
    required this.captainViceCaptain,
    required this.points,
  });

  factory PlayerPoints.fromJson(Map<String, dynamic> json) {
    return PlayerPoints(
      playerId: json['playerId'],
      playerName: json['playerName'],
      playerRole: json['playerRole'],
      captainViceCaptain: json['captainViceCaptain'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'playerRole': playerRole,
      'captainViceCaptain': captainViceCaptain,
      'points': points,
    };
  }
}
// import 'dart:convert';
//
// // Main response model
// class PointsResponse {
//   final bool success;
//   final String message;
//   final List<Data> data;
//
//   PointsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory PointsResponse.fromJson(Map<String, dynamic> json) {
//     return PointsResponse(
//       success: json['success'],
//       message: json['message'],
//       data: List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': List<dynamic>.from(data.map((x) => x.toJson())),
//     };
//   }
// }
// class Data {
//   final String id;
//   final List<PlayerPoints> playerPoints;
//   final double totalPoints;
//
//   Data({
//     required this.id,
//     required this.playerPoints,
//     required this.totalPoints,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['_id'],
//       playerPoints: List<PlayerPoints>.from(
//           json['players'].map((x) => PlayerPoints.fromJson(x))), // Change 'playerPoints' to 'players'
//       totalPoints: (json["totalPoints"] as num?)!.toDouble(), // Convert to double
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'players': List<dynamic>.from(playerPoints.map((x) => x.toJson())), // Change 'playerPoints' to 'players'
//       'totalPoints': totalPoints,
//     };
//   }
// }
//
// // PlayerPoints model
// class PlayerPoints {
//   final String playerId;
//   final String playerName;
//   final String playerRole;
//   final String captainViceCaptain;
//   final double points;
//
//   PlayerPoints({
//     required this.playerId,
//     required this.playerName,
//     required this.playerRole,
//     required this.captainViceCaptain,
//     required this.points,
//   });
//
//   factory PlayerPoints.fromJson(Map<String, dynamic> json) {
//     return PlayerPoints(
//       playerId: json['playerId'],
//       playerName: json['playerName'],
//       playerRole: json['playerRole'],
//       captainViceCaptain: json['captainViceCaptain'],
//       // points: json['points'],
//       points: (json["points"] as num?)!.toDouble(), // Convert to double
//
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'playerId': playerId,
//       'playerName': playerName,
//       'playerRole': playerRole,
//       'captainViceCaptain': captainViceCaptain,
//       'points': points,
//     };
//   }
// }
//
//
//
//
//
// // Data model
// // class Data {
// //   final String id;
// //   final List<PlayerPoints> playerPoints;
// //   final double totalPoints;
// //
// //   Data({
// //     required this.id,
// //     required this.playerPoints,
// //     required this.totalPoints,
// //   });
// //
// //   factory Data.fromJson(Map<String, dynamic> json) {
// //     return Data(
// //       id: json['_id'],
// //       playerPoints: List<PlayerPoints>.from(
// //           json['playerPoints'].map((x) => PlayerPoints.fromJson(x))),
// //       // totalPoints: json['totalPoints'],
// //       totalPoints: (json["totalPoints"] as num?)!.toDouble(), // Convert to double
// //
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'playerPoints': List<dynamic>.from(playerPoints.map((x) => x.toJson())),
// //       'totalPoints': totalPoints ?? '',
// //     };
// //   }
// // }
// // import 'dart:convert';
// //
// // // Main model class
// // class PointsResponse {
// //   final bool success;
// //   final String message;
// //   final List<PlayerPointsData> data;
// //
// //   PointsResponse({
// //     required this.success,
// //     required this.message,
// //     required this.data,
// //   });
// //
// //   factory PointsResponse.fromJson(Map<String, dynamic> json) {
// //     return PointsResponse(
// //       success: json['success'],
// //       message: json['message'],
// //       data: (json['data'] as List)
// //           .map((item) => PlayerPointsData.fromJson(item))
// //           .toList(),
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'success': success,
// //       'message': message,
// //       'data': data.map((item) => item.toJson()).toList(),
// //     };
// //   }
// // }
// //
// // // Data class representing player points
// // class PlayerPointsData {
// //   final String id;
// //   final List<PlayerPoint> playerPoints;
// //   final int totalPoints;
// //
// //   PlayerPointsData({
// //     required this.id,
// //     required this.playerPoints,
// //     required this.totalPoints,
// //   });
// //
// //   factory PlayerPointsData.fromJson(Map<String, dynamic> json) {
// //     return PlayerPointsData(
// //       id: json['_id'],
// //       playerPoints: (json['playerPoints'] as List)
// //           .map((item) => PlayerPoint.fromJson(item))
// //           .toList(),
// //       totalPoints: json['totalPoints'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'playerPoints': playerPoints.map((item) => item.toJson()).toList(),
// //       'totalPoints': totalPoints,
// //     };
// //   }
// // }
// //
// // // Class representing individual player points
// // class PlayerPoint {
// //   final String playerId;
// //   final int points;
// //
// //   PlayerPoint({
// //     required this.playerId,
// //     required this.points,
// //   });
// //
// //   factory PlayerPoint.fromJson(Map<String, dynamic> json) {
// //     return PlayerPoint(
// //       playerId: json['playerId'],
// //       points: json['points'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'playerId': playerId,
// //       'points': points,
// //     };
// //   }
// // }
