import 'dart:convert';

// ScoreboardtestModel for handling scoreboard data
ScoreboardtestModel scoreboardtestModelFromJson(String str) => ScoreboardtestModel.fromJson(json.decode(str));
String scoreboardtestModelToJson(ScoreboardtestModel data) => json.encode(data.toJson());

class ScoreboardtestModel {
  ScoreboardtestModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  ScoreboardtestModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  ScoreboardtestModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => ScoreboardtestModel(
    success: success ?? _success,
    message: message ?? _message,
    data: data ?? _data,
  );

  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

// Data class to hold team information
class Data {
  Data({
    Team1? team1,
    Team2? team2,
  }) {
    _team1 = team1;
    _team2 = team2;
  }

  Data.fromJson(dynamic json) {
    _team1 = json['team1'] != null ? Team1.fromJson(json['team1']) : null;
    _team2 = json['team2'] != null ? Team2.fromJson(json['team2']) : null;
  }

  Team1? _team1;
  Team2? _team2;

  Data copyWith({
    Team1? team1,
    Team2? team2,
  }) => Data(
    team1: team1 ?? _team1,
    team2: team2 ?? _team2,
  );

  Team1? get team1 => _team1;
  Team2? get team2 => _team2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_team1 != null) {
      map['team1'] = _team1?.toJson();
    }
    if (_team2 != null) {
      map['team2'] = _team2?.toJson();
    }
    return map;
  }
}

// Team1 class
class Team1 {
  Team1({
    String? id,
    String? name,
    String? score,
    String? logo,
    List<Batting1Players>? batting1Players,
    List<Bowling1Players>? bowling1Players,
  }) {
    _id = id;
    _name = name;
    _score = score;
    _logo = logo;
    _batting1Players = batting1Players;
    _bowling1Players = bowling1Players;
  }

  Team1.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _score = json['score'];
    _logo = json['logo'];
    if (json['batting1Players'] != null) {
      _batting1Players = [];
      json['batting1Players'].forEach((v) {
        _batting1Players?.add(Batting1Players.fromJson(v));
      });
    }
    if (json['bowling1Players'] != null) {
      _bowling1Players = [];
      json['bowling1Players'].forEach((v) {
        _bowling1Players?.add(Bowling1Players.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  String? _score;
  String? _logo;
  List<Batting1Players>? _batting1Players;
  List<Bowling1Players>? _bowling1Players;

  Team1 copyWith({
    String? id,
    String? name,
    String? score,
    String? logo,
    List<Batting1Players>? batting1Players,
    List<Bowling1Players>? bowling1Players,
  }) => Team1(
    id: id ?? _id,
    name: name ?? _name,
    score: score ?? _score,
    logo: logo ?? _logo,
    batting1Players: batting1Players ?? _batting1Players,
    bowling1Players: bowling1Players ?? _bowling1Players,
  );

  String? get id => _id;
  String? get name => _name;
  String? get score => _score;
  String? get logo => _logo;
  List<Batting1Players>? get batting1Players => _batting1Players;
  List<Bowling1Players>? get bowling1Players => _bowling1Players;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['score'] = _score;
    map['logo'] = _logo;
    if (_batting1Players != null) {
      map['batting1Players'] = _batting1Players?.map((v) => v.toJson()).toList();
    }
    if (_bowling1Players != null) {
      map['bowling1Players'] = _bowling1Players?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// Team2 class
class Team2 {
  Team2({
    String? id,
    String? name,
    String? score,
    String? logo,
    List<Batting2Players>? batting2Players,
    List<Bowling2Players>? bowling2Players,
  }) {
    _id = id;
    _name = name;
    _score = score;
    _logo = logo;
    _batting2Players = batting2Players;
    _bowling2Players = bowling2Players;
  }

  Team2.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _score = json['score'];
    _logo = json['logo'];
    if (json['batting2Players'] != null) {
      _batting2Players = [];
      json['batting2Players'].forEach((v) {
        _batting2Players?.add(Batting2Players.fromJson(v));
      });
    }
    if (json['bowling2Players'] != null) {
      _bowling2Players = [];
      json['bowling2Players'].forEach((v) {
        _bowling2Players?.add(Bowling2Players.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  String? _score;
  String? _logo;
  List<Batting2Players>? _batting2Players;
  List<Bowling2Players>? _bowling2Players;

  Team2 copyWith({
    String? id,
    String? name,
    String? score,
    String? logo,
    List<Batting2Players>? batting2Players,
    List<Bowling2Players>? bowling2Players,
  }) => Team2(
    id: id ?? _id,
    name: name ?? _name,
    score: score ?? _score,
    logo: logo ?? _logo,
    batting2Players: batting2Players ?? _batting2Players,
    bowling2Players: bowling2Players ?? _bowling2Players,
  );

  String? get id => _id;
  String? get name => _name;
  String? get score => _score;
  String? get logo => _logo;
  List<Batting2Players>? get batting2Players => _batting2Players;
  List<Bowling2Players>? get bowling2Players => _bowling2Players;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['score'] = _score;
    map['logo'] = _logo;
    if (_batting2Players != null) {
      map['batting2Players'] = _batting2Players?.map((v) => v.toJson()).toList();
    }
    if (_bowling2Players != null) {
      map['bowling2Players'] = _bowling2Players?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// Bowling2Players class
class Bowling2Players {
  Bowling2Players({
    String? playerId,
    String? playerName,
    num? runs,
    num? economy,
    num? wickets,
    String? overs,
    String? id,
    PlayerDetails? playerDetails,
  }) {
    _playerId = playerId;
    _playerName = playerName;
    _runs = runs;
    _wickets = wickets;
    _overs = overs;
    _id = id;
    _economy =economy;
    _playerDetails = playerDetails;
  }

  Bowling2Players.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _playerName = json['playerName'];
    _runs = json['runs'];
    _wickets = json['wickets'];
    _overs = json['overs'];
    _id = json['_id'];
    _economy = json['economy'];
    _playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }

  String? _playerId;
  String? _playerName;
  num? _runs;
  num? _wickets;
  String? _overs;
  String? _id;
  num? _economy;
  PlayerDetails? _playerDetails;

  Bowling2Players copyWith({
    String? playerId,
    String? playerName,
    num? runs,
    num? wickets,
    String? overs,
    String? id,
    num? economy,
    PlayerDetails? playerDetails,
  }) => Bowling2Players(
    playerId: playerId ?? _playerId,
    playerName: playerName ?? _playerName,
    runs: runs ?? _runs,
    wickets: wickets ?? _wickets,
    overs: overs ?? _overs,
    id: id ?? _id,
    economy : economy ?? _economy,
    playerDetails: playerDetails ?? _playerDetails,
  );

  String? get playerId => _playerId;
  String? get playerName => _playerName;
  num? get runs => _runs;
  num? get wickets => _wickets;
  String? get overs => _overs;
  String? get id => _id;
  num? get economy => _economy;
  PlayerDetails? get playerDetails => _playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['playerName'] = _playerName;
    map['runs'] = _runs;
    map['wickets'] = _wickets;
    map['overs'] = _overs;
    map['_id'] = _id;
    map['economy'] = _economy;
    if (_playerDetails != null) {
      map['playerDetails'] = _playerDetails?.toJson();
    }
    return map;
  }
}

// Bowling1Players class
class Bowling1Players {
  Bowling1Players({
    String? playerId,
    String? playerName,
    num? runs,
    num? wickets,
    String? overs,
    String? id,
    num? economy,
    PlayerDetails? playerDetails,
  }) {
    _playerId = playerId;
    _playerName = playerName;
    _runs = runs;
    _wickets = wickets;
    _overs = overs;
    _id = id;
    _economy = economy;
    _playerDetails = playerDetails;
  }

  Bowling1Players.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _playerName = json['playerName'];
    _runs = json['runs'];
    _wickets = json['wickets'];
    _overs = json['overs'];
    _id = json['_id'];
    _economy = json['economy'];
    _playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }

  String? _playerId;
  String? _playerName;
  num? _runs;
  num? _wickets;
  String? _overs;
  String? _id;
  num? _economy;
  PlayerDetails? _playerDetails;

  Bowling1Players copyWith({
    String? playerId,
    String? playerName,
    num? runs,
    num? wickets,
    String? overs,
    String? id,
    num? economy,
    PlayerDetails? playerDetails,
  }) => Bowling1Players(
    playerId: playerId ?? _playerId,
    playerName: playerName ?? _playerName,
    runs: runs ?? _runs,
    wickets: wickets ?? _wickets,
    overs: overs ?? _overs,
    id: id ?? _id,
    economy: economy?? _economy,
    playerDetails: playerDetails ?? _playerDetails,
  );

  String? get playerId => _playerId;
  String? get playerName => _playerName;
  num? get runs => _runs;
  num? get wickets => _wickets;
  String? get overs => _overs;
  String? get id => _id;
  num? get economy => _economy;
  PlayerDetails? get playerDetails => _playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['playerName'] = _playerName;
    map['runs'] = _runs;
    map['wickets'] = _wickets;
    map['overs'] = _overs;
    map['_id'] = _id;
    map['economy'] = economy;
    if (_playerDetails != null) {
      map['playerDetails'] = _playerDetails?.toJson();
    }
    return map;
  }
}

// Batting2Players class
class Batting2Players {
  Batting2Players({
    String? playerId,
    String? playerName,
    num? runs,
    num? ballsFaced,
    num? four,
    num? six,
    num? strikeRate,
    String? id,
    PlayerDetails? playerDetails,
  }) {
    _playerId = playerId;
    _playerName = playerName;
    _runs = runs;
    _ballsFaced = ballsFaced;
    _four = four;
    _six = six;
    _id = id;
    _strikeRate = strikeRate;
    _playerDetails = playerDetails;
  }

  Batting2Players.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _playerName = json['playerName'];
    _runs = json['runs'];
    _ballsFaced = json['ballsFaced'];
    _four = json['four'];
    _six = json['six'];
    _id = json['_id'];
    _strikeRate = json['strikeRate'];
    _playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }

  String? _playerId;
  String? _playerName;
  num? _runs;
  num? _ballsFaced;
  num? _four;
  num? _six;
  String? _id;
  num? _strikeRate;
  PlayerDetails? _playerDetails;

  Batting2Players copyWith({
    String? playerId,
    String? playerName,
    num? runs,
    num? ballsFaced,
    num? four,
    num? six,
    String? id,
    num? strikeRate,
    PlayerDetails? playerDetails,
  }) => Batting2Players(
    playerId: playerId ?? _playerId,
    playerName: playerName ?? _playerName,
    runs: runs ?? _runs,
    ballsFaced: ballsFaced ?? _ballsFaced,
    four: four ?? _four,
    six: six ?? _six,
    id: id ?? _id,
    strikeRate: strikeRate ?? _strikeRate,
    playerDetails: playerDetails ?? _playerDetails,
  );

  String? get playerId => _playerId;
  String? get playerName => _playerName;
  num? get runs => _runs;
  num? get ballsFaced => _ballsFaced;
  num? get four => _four;
  num? get six => _six;
  String? get id => _id;
  num? get strikeRate => _strikeRate;
  PlayerDetails? get playerDetails => _playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['playerName'] = _playerName;
    map['runs'] = _runs;
    map['ballsFaced'] = _ballsFaced;
    map['four'] = _four;
    map['six'] = _six;
    map['_id'] = _id;
    map['strikeRate'] = _strikeRate;
    if (_playerDetails != null) {
      map['playerDetails'] = _playerDetails?.toJson();
    }
    return map;
  }
}

// Batting1Players class
class Batting1Players {
  Batting1Players({
    String? playerId,
    String? playerName,
    num? runs,
    num? ballsFaced,
    num? four,
    num? six,
    String? id,
    num? strikeRate,
    PlayerDetails? playerDetails,
  }) {
    _playerId = playerId;
    _playerName = playerName;
    _runs = runs;
    _ballsFaced = ballsFaced;
    _four = four;
    _six = six;
    _id = id;
    _strikeRate = strikeRate;
    _playerDetails = playerDetails;
  }

  Batting1Players.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _playerName = json['playerName'];
    _runs = json['runs'];
    _ballsFaced = json['ballsFaced'];
    _four = json['four'];
    _six = json['six'];
    _id = json['_id'];
    _strikeRate = json['strikeRate'];
    _playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }

  String? _playerId;
  String? _playerName;
  num? _runs;
  num? _ballsFaced;
  num? _four;
  num? _six;
  String? _id;
  num? _strikeRate;
  PlayerDetails? _playerDetails;

  Batting1Players copyWith({
    String? playerId,
    String? playerName,
    num? runs,
    num? ballsFaced,
    num? four,
    num? six,
    String? id,
    num? strikeRate,
    PlayerDetails? playerDetails,
  }) => Batting1Players(
    playerId: playerId ?? _playerId,
    playerName: playerName ?? _playerName,
    runs: runs ?? _runs,
    ballsFaced: ballsFaced ?? _ballsFaced,
    four: four ?? _four,
    six: six ?? _six,
    strikeRate: strikeRate ?? _strikeRate,
    id: id ?? _id,
    playerDetails: playerDetails ?? _playerDetails,
  );

  String? get playerId => _playerId;
  String? get playerName => _playerName;
  num? get runs => _runs;
  num? get ballsFaced => _ballsFaced;
  num? get four => _four;
  num? get six => _six;
  String? get id => _id;
  num? get strikeRate => _strikeRate;
  PlayerDetails? get playerDetails => _playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['playerName'] = _playerName;
    map['runs'] = _runs;
    map['ballsFaced'] = _ballsFaced;
    map['four'] = _four;
    map['six'] = _six;
    map['_id'] = _id;
    map['strikeRate'] = _strikeRate;
    if (_playerDetails != null) {
      map['playerDetails'] = _playerDetails?.toJson();
    }
    return map;
  }
}

// PlayerDetails class
class PlayerDetails {
  PlayerDetails({
    String? playerId,
    String? playerName,
    String? playerType,
    String? playerCountry,
    String? playerProfileImage,
  }) {
    _playerId = playerId;
    _playerName = playerName;
    _playerType = playerType;
    _playerCountry = playerCountry;
    _playerProfileImage = playerProfileImage;
  }

  PlayerDetails.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _playerName = json['playerName'];
    _playerType = json['playerType'];
    _playerCountry = json['playerCountry'];
    _playerProfileImage = json['playerProfileImage'];
  }

  String? _playerId;
  String? _playerName;
  String? _playerType;
  String? _playerCountry;
  String? _playerProfileImage;

  PlayerDetails copyWith({
    String? playerId,
    String? playerName,
    String? playerType,
    String? playerCountry,
    String? playerProfileImage,
  }) => PlayerDetails(
    playerId: playerId ?? _playerId,
    playerName: playerName ?? _playerName,
    playerType: playerType ?? _playerType,
    playerCountry: playerCountry ?? _playerCountry,
    playerProfileImage: playerProfileImage ?? _playerProfileImage,
  );

  String? get playerId => _playerId;
  String? get playerName => _playerName;
  String? get playerType => _playerType;
  String? get playerCountry => _playerCountry;
  String? get playerProfileImage => _playerProfileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['playerName'] = _playerName;
    map['playerType'] = _playerType;
    map['playerCountry'] = _playerCountry;
    map['playerProfileImage'] = _playerProfileImage;
    return map;
  }
}

// MatchDetails class
class MatchDetails {
  MatchDetails({
    String? matchId,
    String? matchName,
    String? matchDate,
    String? matchStatus,
    String? matchFormat,
    List<Bowling1Players>? bowling1,
    List<Bowling2Players>? bowling2,
    List<Batting1Players>? batting1,
    List<Batting2Players>? batting2,
  }) {
    _matchId = matchId;
    _matchName = matchName;
    _matchDate = matchDate;
    _matchStatus = matchStatus;
    _matchFormat = matchFormat;
    _bowling1 = bowling1;
    _bowling2 = bowling2;
    _batting1 = batting1;
    _batting2 = batting2;
  }

  MatchDetails.fromJson(dynamic json) {
    _matchId = json['matchId'];
    _matchName = json['matchName'];
    _matchDate = json['matchDate'];
    _matchStatus = json['matchStatus'];
    _matchFormat = json['matchFormat'];
    if (json['bowling1'] != null) {
      _bowling1 = [];
      json['bowling1'].forEach((v) {
        _bowling1?.add(Bowling1Players.fromJson(v));
      });
    }
    if (json['bowling2'] != null) {
      _bowling2 = [];
      json['bowling2'].forEach((v) {
        _bowling2?.add(Bowling2Players.fromJson(v));
      });
    }
    if (json['batting1'] != null) {
      _batting1 = [];
      json['batting1'].forEach((v) {
        _batting1?.add(Batting1Players.fromJson(v));
      });
    }
    if (json['batting2'] != null) {
      _batting2 = [];
      json['batting2'].forEach((v) {
        _batting2?.add(Batting2Players.fromJson(v));
      });
    }
  }

  String? _matchId;
  String? _matchName;
  String? _matchDate;
  String? _matchStatus;
  String? _matchFormat;
  List<Bowling1Players>? _bowling1;
  List<Bowling2Players>? _bowling2;
  List<Batting1Players>? _batting1;
  List<Batting2Players>? _batting2;

  MatchDetails copyWith({
    String? matchId,
    String? matchName,
    String? matchDate,
    String? matchStatus,
    String? matchFormat,
    List<Bowling1Players>? bowling1,
    List<Bowling2Players>? bowling2,
    List<Batting1Players>? batting1,
    List<Batting2Players>? batting2,
  }) => MatchDetails(
    matchId: matchId ?? _matchId,
    matchName: matchName ?? _matchName,
    matchDate: matchDate ?? _matchDate,
    matchStatus: matchStatus ?? _matchStatus,
    matchFormat: matchFormat ?? _matchFormat,
    bowling1: bowling1 ?? _bowling1,
    bowling2: bowling2 ?? _bowling2,
    batting1: batting1 ?? _batting1,
    batting2: batting2 ?? _batting2,
  );

  String? get matchId => _matchId;
  String? get matchName => _matchName;
  String? get matchDate => _matchDate;
  String? get matchStatus => _matchStatus;
  String? get matchFormat => _matchFormat;
  List<Bowling1Players>? get bowling1 => _bowling1;
  List<Bowling2Players>? get bowling2 => _bowling2;
  List<Batting1Players>? get batting1 => _batting1;
  List<Batting2Players>? get batting2 => _batting2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['matchId'] = _matchId;
    map['matchName'] = _matchName;
    map['matchDate'] = _matchDate;
    map['matchStatus'] = _matchStatus;
    map['matchFormat'] = _matchFormat;
    if (_bowling1 != null) {
      map['bowling1'] = _bowling1?.map((v) => v.toJson()).toList();
    }
    if (_bowling2 != null) {
      map['bowling2'] = _bowling2?.map((v) => v.toJson()).toList();
    }
    if (_batting1 != null) {
      map['batting1'] = _batting1?.map((v) => v.toJson()).toList();
    }
    if (_batting2 != null) {
      map['batting2'] = _batting2?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// MatchData class
class MatchData {
  MatchData({
    MatchDetails? matchDetails,
    String? message,
    bool? status,
  }) {
    _matchDetails = matchDetails;
    _message = message;
    _status = status;
  }

  MatchData.fromJson(dynamic json) {
    _matchDetails = json['matchDetails'] != null ? MatchDetails.fromJson(json['matchDetails']) : null;
    _message = json['message'];
    _status = json['status'];
  }

  MatchDetails? _matchDetails;
  String? _message;
  bool? _status;

  MatchData copyWith({
    MatchDetails? matchDetails,
    String? message,
    bool? status,
  }) => MatchData(
    matchDetails: matchDetails ?? _matchDetails,
    message: message ?? _message,
    status: status ?? _status,
  );

  MatchDetails? get matchDetails => _matchDetails;
  String? get message => _message;
  bool? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matchDetails != null) {
      map['matchDetails'] = _matchDetails?.toJson();
    }
    map['message'] = _message;
    map['status'] = _status;
    return map;
  }
}
