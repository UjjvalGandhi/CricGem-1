import 'dart:convert';
/// success : true
/// message : "Display Last Recently Play Match"
/// data : [{"liveMatches":{"matches":[{"_id":"66a1eb65385101014e26e144","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a35d4639b48ee96a1b9161","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a921bdfe1c34842720eac6","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66c8202eadd3e63ed8251b97","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]}},{"upcomingMatches":{"matches":[{"_id":"669f85c18e3e0c2c56263367","match_name":"DC vs MI","date":"2024-09-25T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f1491f4793dc9421a1f","time":"18:00","vanue":"Naredra Modi stediuam","city":"Babra","state":"Gujarat","country":"India","isStarted":true,"createdAt":"2024-06-18T13:56:00.416Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f1491f4793dc9421a1f","team_name":"Mumbai Indians","short_name":"MI","logo":"https://batting-api-1.onrender.com/teamPhoto/MIoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/MIoutline.png","captain":"669a580f91f4793dc9421bae","vice_captain":"669a560591f4793dc9421b66","league_id":"669a499db7d111a9d554f5d0","color_code":"#3988ff"}}]}},{"completedMatches":{"matches":[{"_id":"66c87953c8d5a2490fe4498e","match_name":"PK vs RCB","date":"2024-09-22T00:00:00.000Z","team_1_id":"669a4f4a91f4793dc9421a29","team_2_id":"669a4f9d91f4793dc9421a3b","time":"12:00","vanue":"M Chinnaswamy Stadium","city":"Bangalore Urban","state":"Karnataka","country":"India","isStarted":false,"overs":20,"innings":2,"createdAt":"2024-07-19T14:29:04.224Z","team_1_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"},"team_2_details":{"_id":"669a4f9d91f4793dc9421a3b","team_name":"Royal Challengers Bengaluru","short_name":"RCB","logo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/RCBoutline.png","captain":"669a448491f4793dc942183f","vice_captain":"669a42a891f4793dc9421835","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]}}]

MymatchestestModel mymatchestestModelFromJson(String str) => MymatchestestModel.fromJson(json.decode(str));
String mymatchestestModelToJson(MymatchestestModel data) => json.encode(data.toJson());
class MymatchestestModel {
  MymatchestestModel({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  MymatchestestModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  List<Data>? _data;
MymatchestestModel copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => MymatchestestModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// liveMatches : {"matches":[{"_id":"66a1eb65385101014e26e144","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a35d4639b48ee96a1b9161","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a921bdfe1c34842720eac6","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66c8202eadd3e63ed8251b97","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      LiveMatches? liveMatches,}){
    _liveMatches = liveMatches;
}

  Data.fromJson(dynamic json) {
    _liveMatches = json['liveMatches'] != null ? LiveMatches.fromJson(json['liveMatches']) : null;
  }
  LiveMatches? _liveMatches;

  get upcomingMatches => null;
Data copyWith({  LiveMatches? liveMatches,
}) => Data(  liveMatches: liveMatches ?? _liveMatches,
);
  LiveMatches? get liveMatches => _liveMatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_liveMatches != null) {
      map['liveMatches'] = _liveMatches?.toJson();
    }
    return map;
  }

}

/// matches : [{"_id":"66a1eb65385101014e26e144","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a35d4639b48ee96a1b9161","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66a921bdfe1c34842720eac6","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}},{"_id":"66c8202eadd3e63ed8251b97","match_name":"DC vs PK","date":"2024-09-24T00:00:00.000Z","team_1_id":"669a4e1491f4793dc94219de","team_2_id":"669a4f4a91f4793dc9421a29","time":"12:00","vanue":"Maharaja Yadavindra Singh International Cricket Stadium","city":"Zira","state":"Punjab","country":"India","isStarted":true,"overs":20,"innings":2,"createdAt":"2024-07-19T14:11:28.715Z","team_1_details":{"_id":"669a4e1491f4793dc94219de","team_name":"Delhi Capitals","short_name":"DC","logo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/DCoutline.png","captain":"669a5b8791f4793dc9421c22","vice_captain":"669a5bd391f4793dc9421c30","league_id":"669a499db7d111a9d554f5d0","color_code":"#0075ff"},"team_2_details":{"_id":"669a4f4a91f4793dc9421a29","team_name":"Punjab Kings","short_name":"PK","logo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","other_photo":"https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png","captain":"669a48f591f4793dc94218c6","vice_captain":"669a4cd791f4793dc9421984","league_id":"669a499db7d111a9d554f5d0","color_code":"#ff0000"}}]

LiveMatches liveMatchesFromJson(String str) => LiveMatches.fromJson(json.decode(str));
String liveMatchesToJson(LiveMatches data) => json.encode(data.toJson());
class LiveMatches {
  LiveMatches({
      List<Matches>? matches,}){
    _matches = matches;
}

  LiveMatches.fromJson(dynamic json) {
    if (json['matches'] != null) {
      _matches = [];
      json['matches'].forEach((v) {
        _matches?.add(Matches.fromJson(v));
      });
    }
  }
  List<Matches>? _matches;
LiveMatches copyWith({  List<Matches>? matches,
}) => LiveMatches(  matches: matches ?? _matches,
);
  List<Matches>? get matches => _matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_matches != null) {
      map['matches'] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Matches matchesFromJson(String str) => Matches.fromJson(json.decode(str));
String matchesToJson(Matches data) => json.encode(data.toJson());
class Matches {
  Matches({
      String? id, 
      String? matchName, 
      String? date, 
      String? team1Id, 
      String? team2Id, 
      String? time, 
      String? vanue, 
      String? city, 
      String? state, 
      String? country, 
      bool? isStarted, 
      num? overs, 
      num? innings, 
      String? createdAt, 
      Team1Details? team1Details, 
      Team2Details? team2Details,}){
    _id = id;
    _matchName = matchName;
    _date = date;
    _team1Id = team1Id;
    _team2Id = team2Id;
    _time = time;
    _vanue = vanue;
    _city = city;
    _state = state;
    _country = country;
    _isStarted = isStarted;
    _overs = overs;
    _innings = innings;
    _createdAt = createdAt;
    _team1Details = team1Details;
    _team2Details = team2Details;
}

  Matches.fromJson(dynamic json) {
    _id = json['_id'];
    _matchName = json['match_name'];
    _date = json['date'];
    _team1Id = json['team_1_id'];
    _team2Id = json['team_2_id'];
    _time = json['time'];
    _vanue = json['vanue'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _isStarted = json['isStarted'];
    _overs = json['overs'];
    _innings = json['innings'];
    _createdAt = json['createdAt'];
    _team1Details = json['team_1_details'] != null ? Team1Details.fromJson(json['team_1_details']) : null;
    _team2Details = json['team_2_details'] != null ? Team2Details.fromJson(json['team_2_details']) : null;
  }
  String? _id;
  String? _matchName;
  String? _date;
  String? _team1Id;
  String? _team2Id;
  String? _time;
  String? _vanue;
  String? _city;
  String? _state;
  String? _country;
  bool? _isStarted;
  num? _overs;
  num? _innings;
  String? _createdAt;
  Team1Details? _team1Details;
  Team2Details? _team2Details;
Matches copyWith({  String? id,
  String? matchName,
  String? date,
  String? team1Id,
  String? team2Id,
  String? time,
  String? vanue,
  String? city,
  String? state,
  String? country,
  bool? isStarted,
  num? overs,
  num? innings,
  String? createdAt,
  Team1Details? team1Details,
  Team2Details? team2Details,
}) => Matches(  id: id ?? _id,
  matchName: matchName ?? _matchName,
  date: date ?? _date,
  team1Id: team1Id ?? _team1Id,
  team2Id: team2Id ?? _team2Id,
  time: time ?? _time,
  vanue: vanue ?? _vanue,
  city: city ?? _city,
  state: state ?? _state,
  country: country ?? _country,
  isStarted: isStarted ?? _isStarted,
  overs: overs ?? _overs,
  innings: innings ?? _innings,
  createdAt: createdAt ?? _createdAt,
  team1Details: team1Details ?? _team1Details,
  team2Details: team2Details ?? _team2Details,
);
  String? get id => _id;
  String? get matchName => _matchName;
  String? get date => _date;
  String? get team1Id => _team1Id;
  String? get team2Id => _team2Id;
  String? get time => _time;
  String? get vanue => _vanue;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  bool? get isStarted => _isStarted;
  num? get overs => _overs;
  num? get innings => _innings;
  String? get createdAt => _createdAt;
  Team1Details? get team1Details => _team1Details;
  Team2Details? get team2Details => _team2Details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['match_name'] = _matchName;
    map['date'] = _date;
    map['team_1_id'] = _team1Id;
    map['team_2_id'] = _team2Id;
    map['time'] = _time;
    map['vanue'] = _vanue;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['isStarted'] = _isStarted;
    map['overs'] = _overs;
    map['innings'] = _innings;
    map['createdAt'] = _createdAt;
    if (_team1Details != null) {
      map['team_1_details'] = _team1Details?.toJson();
    }
    if (_team2Details != null) {
      map['team_2_details'] = _team2Details?.toJson();
    }
    return map;
  }

}

/// _id : "669a4f4a91f4793dc9421a29"
/// team_name : "Punjab Kings"
/// short_name : "PK"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/PBKSoutline.png"
/// captain : "669a48f591f4793dc94218c6"
/// vice_captain : "669a4cd791f4793dc9421984"
/// league_id : "669a499db7d111a9d554f5d0"
/// color_code : "#ff0000"

Team2Details team2DetailsFromJson(String str) => Team2Details.fromJson(json.decode(str));
String team2DetailsToJson(Team2Details data) => json.encode(data.toJson());
class Team2Details {
  Team2Details({
      String? id, 
      String? teamName, 
      String? shortName, 
      String? logo, 
      String? otherPhoto, 
      String? captain, 
      String? viceCaptain, 
      String? leagueId, 
      String? colorCode,}){
    _id = id;
    _teamName = teamName;
    _shortName = shortName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _leagueId = leagueId;
    _colorCode = colorCode;
}

  Team2Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _shortName = json['short_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _leagueId = json['league_id'];
    _colorCode = json['color_code'];
  }
  String? _id;
  String? _teamName;
  String? _shortName;
  String? _logo;
  String? _otherPhoto;
  String? _captain;
  String? _viceCaptain;
  String? _leagueId;
  String? _colorCode;
Team2Details copyWith({  String? id,
  String? teamName,
  String? shortName,
  String? logo,
  String? otherPhoto,
  String? captain,
  String? viceCaptain,
  String? leagueId,
  String? colorCode,
}) => Team2Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  shortName: shortName ?? _shortName,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  leagueId: leagueId ?? _leagueId,
  colorCode: colorCode ?? _colorCode,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get shortName => _shortName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get captain => _captain;
  String? get viceCaptain => _viceCaptain;
  String? get leagueId => _leagueId;
  String? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['short_name'] = _shortName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['league_id'] = _leagueId;
    map['color_code'] = _colorCode;
    return map;
  }

}

/// _id : "669a4e1491f4793dc94219de"
/// team_name : "Delhi Capitals"
/// short_name : "DC"
/// logo : "https://batting-api-1.onrender.com/teamPhoto/DCoutline.png"
/// other_photo : "https://batting-api-1.onrender.com/teamPhoto/DCoutline.png"
/// captain : "669a5b8791f4793dc9421c22"
/// vice_captain : "669a5bd391f4793dc9421c30"
/// league_id : "669a499db7d111a9d554f5d0"
/// color_code : "#0075ff"

Team1Details team1DetailsFromJson(String str) => Team1Details.fromJson(json.decode(str));
String team1DetailsToJson(Team1Details data) => json.encode(data.toJson());
class Team1Details {
  Team1Details({
      String? id, 
      String? teamName, 
      String? shortName, 
      String? logo, 
      String? otherPhoto, 
      String? captain, 
      String? viceCaptain, 
      String? leagueId, 
      String? colorCode,}){
    _id = id;
    _teamName = teamName;
    _shortName = shortName;
    _logo = logo;
    _otherPhoto = otherPhoto;
    _captain = captain;
    _viceCaptain = viceCaptain;
    _leagueId = leagueId;
    _colorCode = colorCode;
}

  Team1Details.fromJson(dynamic json) {
    _id = json['_id'];
    _teamName = json['team_name'];
    _shortName = json['short_name'];
    _logo = json['logo'];
    _otherPhoto = json['other_photo'];
    _captain = json['captain'];
    _viceCaptain = json['vice_captain'];
    _leagueId = json['league_id'];
    _colorCode = json['color_code'];
  }
  String? _id;
  String? _teamName;
  String? _shortName;
  String? _logo;
  String? _otherPhoto;
  String? _captain;
  String? _viceCaptain;
  String? _leagueId;
  String? _colorCode;
Team1Details copyWith({  String? id,
  String? teamName,
  String? shortName,
  String? logo,
  String? otherPhoto,
  String? captain,
  String? viceCaptain,
  String? leagueId,
  String? colorCode,
}) => Team1Details(  id: id ?? _id,
  teamName: teamName ?? _teamName,
  shortName: shortName ?? _shortName,
  logo: logo ?? _logo,
  otherPhoto: otherPhoto ?? _otherPhoto,
  captain: captain ?? _captain,
  viceCaptain: viceCaptain ?? _viceCaptain,
  leagueId: leagueId ?? _leagueId,
  colorCode: colorCode ?? _colorCode,
);
  String? get id => _id;
  String? get teamName => _teamName;
  String? get shortName => _shortName;
  String? get logo => _logo;
  String? get otherPhoto => _otherPhoto;
  String? get captain => _captain;
  String? get viceCaptain => _viceCaptain;
  String? get leagueId => _leagueId;
  String? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['team_name'] = _teamName;
    map['short_name'] = _shortName;
    map['logo'] = _logo;
    map['other_photo'] = _otherPhoto;
    map['captain'] = _captain;
    map['vice_captain'] = _viceCaptain;
    map['league_id'] = _leagueId;
    map['color_code'] = _colorCode;
    return map;
  }

}