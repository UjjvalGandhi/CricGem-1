// class chatscreendisplayModel {
//   bool? success;
//   String? message;
//   List<Data>? data;
//
//   chatscreendisplayModel({this.success, this.message, this.data});
//
//   chatscreendisplayModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? message;
//   String? dateAndTime;
//   UserDetails? userDetails;
//   String? date;
//   String? time;
//
//   Data(
//       {this.sId,
//         this.message,
//         this.dateAndTime,
//         this.userDetails,
//         this.date,
//         this.time});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     message = json['message'];
//     dateAndTime = json['dateAndTime'];
//     userDetails = json['user_details'] != null
//         ? new UserDetails.fromJson(json['user_details'])
//         : null;
//     date = json['date'];
//     time = json['time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['message'] = this.message;
//     data['dateAndTime'] = this.dateAndTime;
//     if (this.userDetails != null) {
//       data['user_details'] = this.userDetails!.toJson();
//     }
//     data['date'] = this.date;
//     data['time'] = this.time;
//     return data;
//   }
// }
//
// class UserDetails {
//   String? sId;
//   String? uniqueId;
//   String? name;
//   String? email;
//   int? mobile;
//   String? dob;
//   String? gender;
//   String? address;
//   String? city;
//   int? pincode;
//   String? state;
//   String? country;
//   String? profilePhoto;
//   String? status;
//   String? dateAndTime;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   UserDetails(
//       {this.sId,
//         this.uniqueId,
//         this.name,
//         this.email,
//         this.mobile,
//         this.dob,
//         this.gender,
//         this.address,
//         this.city,
//         this.pincode,
//         this.state,
//         this.country,
//         this.profilePhoto,
//         this.status,
//         this.dateAndTime,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   UserDetails.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     uniqueId = json['unique_id'];
//     name = json['name'];
//     email = json['email'];
//     mobile = json['mobile'];
//     dob = json['dob'];
//     gender = json['gender'];
//     address = json['address'];
//     city = json['city'];
//     pincode = json['pincode'];
//     state = json['state'];
//     country = json['country'];
//     profilePhoto = json['profile_photo'];
//     status = json['status'];
//     dateAndTime = json['dateAndTime'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['unique_id'] = this.uniqueId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['mobile'] = this.mobile;
//     data['dob'] = this.dob;
//     data['gender'] = this.gender;
//     data['address'] = this.address;
//     data['city'] = this.city;
//     data['pincode'] = this.pincode;
//     data['state'] = this.state;
//     data['country'] = this.country;
//     data['profile_photo'] = this.profilePhoto;
//     data['status'] = this.status;
//     data['dateAndTime'] = this.dateAndTime;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
