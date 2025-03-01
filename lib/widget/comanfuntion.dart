class ComunFunction {
  static void register({

    required String fullname,
    required String email,
    required String mobile,
    required String gender,
    required String date,
    required String password,
    required String conformPassword,

  }){
    print(' full name ::::$fullname');
    print(' email ::::$email');
    print('mobile ::::$mobile');
    print(' gender ::::$gender');
    print(' date ::::$date');
    print(' password ::::$password');
    print(' conformpassword ::::$conformPassword');

  }
  static void address({
    required String address,
     String country = "India",
    required String state,
    required String city,
    required String pincodee
}){
    print("addres:::$address");
    print("country:::$country");
    print("state:::$state");
    print("city:::$city");
    print("pincode:::$pincodee");

  }

  static void fulldata({
    required fullname,
    required email,
    required mobile,
    required gender,
    required date,
    required password,
    required conformPassword,
    required address,
    required state,
    required city,
    required pincodee,
}){
    register(fullname: fullname, email: email, mobile: mobile, gender: gender, date: date, password: password, conformPassword: conformPassword);

    address(address: address, state: state, city: city, pincodee: pincodee);
}
}