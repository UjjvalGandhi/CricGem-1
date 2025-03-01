import 'dart:math';
import 'package:http/http.dart' as http;

Future<int> sendSMS(int number) async {
  Random random = Random();
  // Generate a random 6-digit number
  int otp = 100000 + random.nextInt(900000);
  // var username = uname, password = pass;
  int destination = number;

  print("Mobile number of user for registration.......$destination");
  print("otpppppppppppppppp for registration.....$otp");
  final url = Uri.parse(
      // "https://rslri.connectbind.com:8443/bulksms/bulksms?username=DG35-iota&password=digimile&type=0&dlr=1&destination=${destination}&source=IOTADG&message=Dear Customer, Your one time password ${otp.toString()} and its valid for 5 minutes only. Do not share to anyone. Thank you, Team IOTA DIAGNOSTIC.&entityid=1101503090000076036&tempid=1107170739252182993"
    "https://rslri.connectbind.com:8443/bulksms/bulksms?username=DG35-webearl&password=digimile&type=0&dlr=1&destination=$destination&source=WEBEAR&message=Dear User, Your one time password is ${otp.toString()} and it is valid for 10 minutes. Do not share it to anyone. Thank you, Team WEBEARL TECHNOLOGIES.&entityid=1101602010000073269&tempid=1107169899584811565"
    // "https://rslri.connectbind.com:8443/bulksms/bulksms?username=di78-trans&password=digimile&type=0&dlr=1&"
    //     "destination=${destination}&source=DIGIML&message=Dear User, "
    //     "Your one time password ${otp.toString()} and its valid for 15 mins. Do not share to anyone. Digimiles.&entityid=1201159100989151460&tempid=1107162089216820716"
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    print('SMS sent successfully');
    print('response :- ${response.body.toString()}');
    return otp;
  } else {
    print('Failed to send SMS. Status code: ${response.statusCode}');
    return 0;
  }
}

// Future<int> sendSMS(int number) async {
//   Random random = Random();
//   int otp = 100000 + random.nextInt(900000);
//   int destination = number;
//   var plusdestination = "+91${destination}";
//   print('Plus destination:-${plusdestination}');
//   print("Mobile number with plus of user for registration: $plusdestination");
//
//   print("Mobile number of user for registration: $destination");
//   print("OTP for registration: $otp");
//
//   final url = Uri.parse(
//       "https://rslri.connectbind.com:8443/bulksms/bulksms?username=DG35-webearl&password=digimile&type=0&dlr=1&destination=${plusdestination}&source=WEBEAR&message=Dear User, Your one time password is ${otp.toString()} and it is valid for 10 minutes. Do not share it to anyone. Thank you, Team WEBEARL TECHNOLOGIES.&entityid=1101602010000073269&tempid=1107169899584811565"
//     // "https://rslri.connectbind.com:8443/bulksms/bulksms?username=DG35-iota&password=digimile&type=0&dlr=1&destination=${destination}&source=IOTADG&message=Dear Customer, Your one time password ${otp.toString()} and its valid for 5 minutes only. Do not share to anyone. Thank you, Team IOTA DIAGNOSTIC.&entityid=1101503090000076036&tempid=1107170739252182993"
//
//   );
//
//   print("Request URL: $url");
//
//   final response = await http.get(url);
//
//   if (response.statusCode == 200) {
//     print('SMS sent successfully');
//     print('Response: ${response.body}');
//     return otp;
//   } else {
//     print('Failed to send SMS. Status code: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     return 0;
//   }
// }