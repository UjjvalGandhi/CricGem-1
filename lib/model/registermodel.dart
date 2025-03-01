class Welcome {
  bool success;
  String message;
  Data data;
  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });
}
class Data {
  String uniqueId;
  String name;
  String email;
  String password;
  int mobile;
  String dob;
  String gender;
  String address;
  String city;
  int pincode;
  String state;
  String country;
  String profilePhoto;
  String status;
  String id;
  DateTime dateAndTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Data({
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.country,
    required this.profilePhoto,
    required this.status,
    required this.id,
    required this.dateAndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

}
