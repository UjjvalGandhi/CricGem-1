
class WalletModel {
  bool success;
  String message;
  WalletData data;

  WalletModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: WalletData.fromJson(json['data'] ?? {}),
    );
  }
}

class WalletData {
  String id;
  String userId;
  int funds;
  int fundsUtilized;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int bonus;
  int winnings;

  WalletData({
    required this.id,
    required this.userId,
    required this.funds,
    required this.fundsUtilized,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.bonus,
    required this.winnings,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      funds: json['funds'] ?? 0,
      fundsUtilized: json['fundsUtilized'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      v: json['__v'] ?? 0,
      bonus: json['bonus'] ?? 0,
      winnings: json['winnings'] ?? 0,
    );
  }
}
