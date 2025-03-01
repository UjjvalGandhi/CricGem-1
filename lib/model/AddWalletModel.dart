class AddWallateModlel {
  bool success;
  String message;
  List<Datum> data;

  AddWallateModlel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddWallateModlel.fromJson(Map<String, dynamic> json) {
    return AddWallateModlel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Datum {
  String id;
  UserId userId;
  int amount;
  PaymentMode paymentMode;
  PaymentType paymentType;
  Status status;
  bool approval;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Datum({
    required this.id,
    required this.userId,
    required this.amount,
    required this.paymentMode,
    required this.paymentType,
    required this.status,
    required this.approval,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['_id'] ?? '',
      userId: userIdValues.map[json['user_id']] ??
          UserId.THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
      amount: json['amount'] ?? 0,
      paymentMode: paymentModeValues.map[json['payment_mode']] ??
          PaymentMode.UPI,
      paymentType: paymentTypeValues.map[json['payment_type']] ??
          PaymentType.ADD_WALLET,
      status: statusValues.map[json['status']] ?? Status.UNKNOWN, // Updated fallback
      approval: json['approval'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      v: json['__v'] ?? 0,
    );
  }
}

enum PaymentMode {
  UPI,
  CONTEST,
  WINNING,
}

final paymentModeValues = EnumValues({
  "upi": PaymentMode.UPI,
  "contest": PaymentMode.CONTEST,
  "winning": PaymentMode.WINNING,
});

enum PaymentType {
  ADD_WALLET,
  WITHDRAW,
  CONTEST_FEE,
  WINNING_AMOUNT,
}

final paymentTypeValues = EnumValues({
  "add_wallet": PaymentType.ADD_WALLET,
  "withdraw": PaymentType.WITHDRAW,
  "contest_fee": PaymentType.CONTEST_FEE,
  "winning_amount": PaymentType.WINNING_AMOUNT,
});

enum Status {
  SUCCESS,
  PENDING,
  FAILED,
  UNKNOWN, // Added to handle unmapped statuses
}

final statusValues = EnumValues({
  "success": Status.SUCCESS,
  "pending": Status.PENDING,
  "fail": Status.FAILED,
});

enum UserId {
  THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
}

final userIdValues = EnumValues({
  "666a8b99bedfd9b231f35e7a": UserId.THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

//
// class AddWallateModlel {
//   bool success;
//   String message;
//   List<Datum> data;
//
//   AddWallateModlel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory AddWallateModlel.fromJson(Map<String, dynamic> json) {
//     return AddWallateModlel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => Datum.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
// }
//
// class Datum {
//   String id;
//   UserId userId;
//   int amount;
//   PaymentMode paymentMode;
//   PaymentType paymentType;
//   Status status;
//   bool approval;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//
//   Datum({
//     required this.id,
//     required this.userId,
//     required this.amount,
//     required this.paymentMode,
//     required this.paymentType,
//     required this.status,
//     required this.approval,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) {
//     return Datum(
//       id: json['_id'] ?? '',
//       userId: userIdValues.map[json['user_id']] ?? UserId.THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
//       amount: json['amount'] ?? 0,
//       paymentMode: paymentModeValues.map[json['payment_mode']] ?? PaymentMode.UPI,
//       paymentType: paymentTypeValues.map[json['payment_type']] ?? PaymentType.ADD_WALLET,
//       status: statusValues.map[json['status']] ?? Status.SUCCESS,
//       approval: json['approval'] ?? false,
//       createdAt: DateTime.parse(json['createdAt'] ?? ''),
//       updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
//       v: json['__v'] ?? 0,
//     );
//   }
// }
//
// enum PaymentMode {
//   UPI,
//   CONTEST,
//   WINNING,
// }
//
// final paymentModeValues = EnumValues({
//   "upi": PaymentMode.UPI,
//   "contest": PaymentMode.CONTEST,
//   "winning": PaymentMode.WINNING,
// });
//
// enum PaymentType {
//   ADD_WALLET,
//   WITHDRAW,
//   CONTEST_FEE,
//   WINNING_AMOUNT,
// // Added this line
// }
//
// final paymentTypeValues = EnumValues({
//   "add_wallet": PaymentType.ADD_WALLET,
//   "withdraw": PaymentType.WITHDRAW,
//   "contest_fee": PaymentType.CONTEST_FEE,
//   "winning_amount": PaymentType.WINNING_AMOUNT,
// // Added this line
// });
//
// enum Status {
//   SUCCESS,
// }
//
// final statusValues = EnumValues({
//   "success": Status.SUCCESS,
// });
//
// enum UserId {
//   THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
// }
//
// final userIdValues = EnumValues({
//   "666a8b99bedfd9b231f35e7a": UserId.THE_666_A8_B99_BEDFD9_B231_F35_E7_A,
// });
//
// class EnumValues<T> {
//   late Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
