class Fulldata {
  final fullname;
  String email;
  String mobile;
  String gender;
  DateTime date;
  String password;
  String conformPassword;
  String address;
  String? state;
  String? city;
  String pincode;

  Fulldata({
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.date,
    required this.password,
    required this.conformPassword,
    required this.address,
     this.state,
     this.city,
    required this.pincode,
  });
}
